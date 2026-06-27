-- ============================================================
-- GESTÃO ACADÊMICA — Functions, Procedures e Triggers
-- Etapa 2 · Grupo 11
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTIONS
-- ------------------------------------------------------------

-- i) Vagas disponíveis em uma turma
CREATE OR REPLACE FUNCTION contar_vagas_disponiveis(p_idTurma INT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
    v_capacidade   INT;
    v_matriculados INT;
BEGIN
    SELECT capacidadeMaxima INTO v_capacidade
    FROM turma WHERE idTurma = p_idTurma;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Turma % não encontrada.', p_idTurma;
    END IF;

    SELECT COUNT(*) INTO v_matriculados
    FROM matricula
    WHERE idTurma = p_idTurma
      AND status NOT IN ('Cancelada','Trancada');

    RETURN v_capacidade - v_matriculados;
END;
$$;

-- ii) Índice de Rendimento Acadêmico (IRA) ponderado por carga horária
CREATE OR REPLACE FUNCTION calcular_ira(p_idAluno INT)
RETURNS NUMERIC(4,2)
LANGUAGE plpgsql AS $$
DECLARE
    v_ira NUMERIC(4,2);
BEGIN
    SELECT ROUND(
        SUM(m.nota * d.cargaHoraria) / NULLIF(SUM(d.cargaHoraria), 0),
        2
    ) INTO v_ira
    FROM matricula m
    JOIN turma      t ON t.idTurma      = m.idTurma
    JOIN disciplina d ON d.idDisciplina = t.idDisciplina
    WHERE m.idAluno = p_idAluno
      AND m.nota IS NOT NULL;

    RETURN COALESCE(v_ira, 0);
END;
$$;

-- iii) Verificação de aprovação por nota e frequência
CREATE OR REPLACE FUNCTION aluno_aprovado(p_idAluno INT, p_idTurma INT)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
DECLARE
    v_nota NUMERIC(4,2);
    v_freq NUMERIC(5,2);
BEGIN
    SELECT nota, frequencia INTO v_nota, v_freq
    FROM matricula
    WHERE idAluno = p_idAluno AND idTurma = p_idTurma;

    IF NOT FOUND OR v_nota IS NULL OR v_freq IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN v_nota >= 5.0 AND v_freq >= 75.0;
END;
$$;

-- ------------------------------------------------------------
-- PROCEDURES
-- ------------------------------------------------------------

-- i) Realização de matrícula com validação de vagas e duplicidade
CREATE OR REPLACE PROCEDURE realizar_matricula(p_idAluno INT, p_idTurma INT)
LANGUAGE plpgsql AS $$
DECLARE
    v_vagas INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM turma WHERE idTurma = p_idTurma) THEN
        RAISE EXCEPTION 'Turma % não encontrada.', p_idTurma;
    END IF;

    IF EXISTS (
        SELECT 1 FROM matricula
        WHERE idAluno = p_idAluno AND idTurma = p_idTurma
    ) THEN
        RAISE EXCEPTION 'Aluno % já está matriculado na turma %.', p_idAluno, p_idTurma;
    END IF;

    v_vagas := contar_vagas_disponiveis(p_idTurma);
    IF v_vagas <= 0 THEN
        RAISE EXCEPTION 'Turma % sem vagas disponíveis.', p_idTurma;
    END IF;

    INSERT INTO matricula (idAluno, idTurma, dataMatricula, status)
    VALUES (p_idAluno, p_idTurma, CURRENT_DATE, 'Ativa');

    RAISE NOTICE 'Matrícula do aluno % na turma % realizada. Vagas restantes: %.',
        p_idAluno, p_idTurma, v_vagas - 1;
END;
$$;

-- Teste da procedure realizar_matricula (espera-se sucesso)
CALL realizar_matricula(13, 11);

-- ii) Lançamento de nota e frequência
CREATE OR REPLACE PROCEDURE lancar_nota_frequencia(
    p_idAluno INT,
    p_idTurma INT,
    p_nota    NUMERIC(4,2),
    p_freq    NUMERIC(5,2)
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM matricula
        WHERE idAluno = p_idAluno AND idTurma = p_idTurma AND status = 'Ativa'
    ) THEN
        RAISE EXCEPTION 'Matrícula ativa não encontrada para aluno % na turma %.',
            p_idAluno, p_idTurma;
    END IF;

    UPDATE matricula
    SET nota = p_nota, frequencia = p_freq
    WHERE idAluno = p_idAluno AND idTurma = p_idTurma;

    RAISE NOTICE 'Nota %.2f e frequência %.1f%% lançadas para aluno % na turma %.',
        p_nota, p_freq, p_idAluno, p_idTurma;
END;
$$;

-- Teste do lançamento de nota (aluno 1, turma 4 — status Ativa)
CALL lancar_nota_frequencia(1, 4, 6.5, 78.0);

-- iii) Trancamento de matrícula
CREATE OR REPLACE PROCEDURE trancar_matricula(p_idAluno INT, p_idTurma INT)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM matricula
        WHERE idAluno = p_idAluno AND idTurma = p_idTurma AND status = 'Ativa'
    ) THEN
        RAISE EXCEPTION 'Matrícula do aluno % na turma % não está ativa.',
            p_idAluno, p_idTurma;
    END IF;

    UPDATE matricula SET status = 'Trancada'
    WHERE idAluno = p_idAluno AND idTurma = p_idTurma;

    RAISE NOTICE 'Matrícula do aluno % na turma % trancada com sucesso.',
        p_idAluno, p_idTurma;
END;
$$;

-- Teste do trancamento (aluno 3, turma 7 — status Ativa)
CALL trancar_matricula(3, 7);

-- ------------------------------------------------------------
-- TRIGGERS
-- ------------------------------------------------------------

-- i) Auditoria de alterações de status da matrícula
CREATE OR REPLACE FUNCTION fn_log_status_matricula()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO log_status_matricula (idAluno, idTurma, statusAnterior, statusNovo)
        VALUES (NEW.idAluno, NEW.idTurma, OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tg_log_status_matricula
AFTER UPDATE ON matricula
FOR EACH ROW EXECUTE FUNCTION fn_log_status_matricula();

-- ii) Atualização automática de status ao lançar nota e frequência
CREATE OR REPLACE FUNCTION fn_atualizar_status_nota()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.nota IS NOT NULL AND NEW.frequencia IS NOT NULL
       AND NEW.status NOT IN ('Cancelada','Trancada') THEN
        NEW.status := CASE
            WHEN NEW.nota >= 5.0 AND NEW.frequencia >= 75.0 THEN 'Aprovado'
            ELSE 'Reprovado'
        END;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tg_atualizar_status_nota
BEFORE UPDATE OF nota, frequencia ON matricula
FOR EACH ROW EXECUTE FUNCTION fn_atualizar_status_nota();

-- iii) Validação de conflito de sala e horário
CREATE OR REPLACE FUNCTION fn_validar_horario_conflito()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_conflito INT;
BEGIN
    SELECT COUNT(*) INTO v_conflito
    FROM horario
    WHERE local      = NEW.local
      AND diaSemana  = NEW.diaSemana
      AND idHorario <> COALESCE(NEW.idHorario, -1)
      AND (NEW.horaInicio, NEW.horaFim) OVERLAPS (horaInicio, horaFim);

    IF v_conflito > 0 THEN
        RAISE EXCEPTION 'Conflito de horário: sala "%" já ocupada na % entre % e %.',
            NEW.local, NEW.diaSemana, NEW.horaInicio, NEW.horaFim;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tg_validar_horario_conflito
BEFORE INSERT OR UPDATE ON horario
FOR EACH ROW EXECUTE FUNCTION fn_validar_horario_conflito();

-- Teste do trigger de conflito (deve falhar — sala já ocupada)
INSERT INTO horario (diaSemana, horaInicio, horaFim, local, idTurma)
VALUES ('SEG', '09:00', '11:00', 'Sala AB1-04', 2);
