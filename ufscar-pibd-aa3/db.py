import psycopg2
import psycopg2.extras

DB_CONFIG = {
    "host": "localhost",
    "dbname": "gestao_academica",
    "user": "postgres",
    "password": "postgres",
    "port": 5433,
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def buscar_aluno_por_matricula(num_matricula: str):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(
                """
                SELECT a.idAluno     AS id_aluno,
                       a.numMatricula AS num_matricula,
                       a.nome,
                       a.email,
                       c.nome        AS nome_curso
                FROM aluno a
                JOIN curso c ON c.idCurso = a.idCurso
                WHERE a.numMatricula = %s
                """,
                (num_matricula,),
            )
            row = cur.fetchone()
            return dict(row) if row else None
    finally:
        conn.close()


def buscar_matriculas_aluno(id_aluno: int):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(
                """
                SELECT
                    d.nome                                              AS disciplina,
                    d.cargaHoraria                                      AS carga_horaria,
                    p.nome                                              AS professor,
                    t.codigo                                            AS codigo_turma,
                    t.periodoLetivo                                     AS periodo_letivo,
                    t.idTurma                                           AS id_turma,
                    m.nota,
                    m.frequencia,
                    m.status,
                    m.dataMatricula                                     AS data_matricula,
                    STRING_AGG(
                        h.diaSemana
                        || ' ' || TO_CHAR(h.horaInicio, 'HH24:MI')
                        || '-'  || TO_CHAR(h.horaFim,   'HH24:MI')
                        || ' (' || h.local || ')',
                        ', ' ORDER BY h.diaSemana, h.horaInicio
                    )                                                   AS horarios
                FROM matricula m
                JOIN turma      t ON t.idTurma      = m.idTurma
                JOIN disciplina d ON d.idDisciplina = t.idDisciplina
                JOIN professor  p ON p.idProfessor  = t.idProfessor
                LEFT JOIN horario h ON h.idTurma    = t.idTurma
                WHERE m.idAluno = %s
                GROUP BY d.nome, d.cargaHoraria, p.nome, t.codigo, t.periodoLetivo,
                         t.idTurma, m.nota, m.frequencia, m.status, m.dataMatricula
                ORDER BY t.periodoLetivo DESC, d.nome
                """,
                (id_aluno,),
            )
            return [dict(r) for r in cur.fetchall()]
    finally:
        conn.close()


def calcular_ira(id_aluno: int):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT calcular_ira(%s)", (id_aluno,))
            return cur.fetchone()[0]
    finally:
        conn.close()


def buscar_turmas_disponiveis(id_aluno: int):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(
                """
                SELECT
                    t.idTurma                           AS id_turma,
                    d.nome                              AS disciplina,
                    d.cargaHoraria                      AS carga_horaria,
                    p.nome                              AS professor,
                    t.codigo                            AS codigo_turma,
                    t.periodoLetivo                     AS periodo_letivo,
                    contar_vagas_disponiveis(t.idTurma) AS vagas_disponiveis,
                    STRING_AGG(
                        h.diaSemana
                        || ' ' || TO_CHAR(h.horaInicio, 'HH24:MI')
                        || '-'  || TO_CHAR(h.horaFim,   'HH24:MI')
                        || ' (' || h.local || ')',
                        ', ' ORDER BY h.diaSemana, h.horaInicio
                    )                                   AS horarios
                FROM turma t
                JOIN disciplina d ON d.idDisciplina = t.idDisciplina
                JOIN professor  p ON p.idProfessor  = t.idProfessor
                LEFT JOIN horario h ON h.idTurma    = t.idTurma
                WHERE contar_vagas_disponiveis(t.idTurma) > 0
                  AND NOT EXISTS (
                      SELECT 1 FROM matricula m
                      WHERE m.idAluno = %s
                        AND m.idTurma = t.idTurma
                        AND m.status NOT IN ('Cancelada')
                  )
                GROUP BY t.idTurma, d.nome, d.cargaHoraria, p.nome,
                         t.codigo, t.periodoLetivo
                ORDER BY t.periodoLetivo DESC, d.nome
                """,
                (id_aluno,),
            )
            return [dict(r) for r in cur.fetchall()]
    finally:
        conn.close()


def realizar_matricula(id_aluno: int, id_turma: int):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("CALL realizar_matricula(%s, %s)", (id_aluno, id_turma))
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def trancar_matricula(id_aluno: int, id_turma: int):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("CALL trancar_matricula(%s, %s)", (id_aluno, id_turma))
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
