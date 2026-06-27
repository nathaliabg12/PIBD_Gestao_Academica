-- ============================================================
-- GESTÃO ACADÊMICA — DDL: tabelas e restrições
-- Etapa 2 · Grupo 11
-- ============================================================

CREATE TABLE curso (
    idCurso   SERIAL PRIMARY KEY,
    codigo    VARCHAR(20)  NOT NULL UNIQUE,
    nome      VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE professor (
    idProfessor SERIAL PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    cpf         CHAR(11)     NOT NULL UNIQUE,
    email       VARCHAR(150) NOT NULL UNIQUE,
    titulacao   VARCHAR(30)  NOT NULL
        CHECK (titulacao IN ('Graduacao','Especializacao','Mestrado','Doutorado','Pos-Doutorado'))
);

CREATE TABLE disciplina (
    idDisciplina SERIAL PRIMARY KEY,
    codigo       VARCHAR(20)  NOT NULL UNIQUE,
    nome         VARCHAR(150) NOT NULL,
    descricao    TEXT,
    cargaHoraria SMALLINT     NOT NULL
        CHECK (cargaHoraria > 0 AND cargaHoraria % 15 = 0)
);

CREATE TABLE grade_curricular (
    idGrade     SERIAL   PRIMARY KEY,
    idCurso     INT      NOT NULL REFERENCES curso(idCurso) ON DELETE RESTRICT,
    anoVigencia SMALLINT NOT NULL CHECK (anoVigencia >= 2000),
    UNIQUE (idCurso, anoVigencia)
);

CREATE TABLE grade_disciplina (
    idGrade         INT     NOT NULL REFERENCES grade_curricular(idGrade) ON DELETE CASCADE,
    idDisciplina    INT     NOT NULL REFERENCES disciplina(idDisciplina)  ON DELETE RESTRICT,
    obrigatoria     BOOLEAN NOT NULL DEFAULT TRUE,
    periodoSugerido SMALLINT CHECK (periodoSugerido BETWEEN 1 AND 10),
    PRIMARY KEY (idGrade, idDisciplina)
);

CREATE TABLE aluno (
    idAluno        SERIAL  PRIMARY KEY,
    numMatricula   VARCHAR(20)  NOT NULL UNIQUE,
    nome           VARCHAR(150) NOT NULL,
    cpf            CHAR(11)     NOT NULL UNIQUE,
    email          VARCHAR(150) NOT NULL UNIQUE,
    dataNascimento DATE         NOT NULL
        CHECK (dataNascimento BETWEEN '1930-01-01' AND CURRENT_DATE - INTERVAL '15 years'),
    idCurso        INT NOT NULL REFERENCES curso(idCurso) ON DELETE RESTRICT
);

CREATE TABLE turma (
    idTurma          SERIAL PRIMARY KEY,
    codigo           VARCHAR(20) NOT NULL,
    periodoLetivo    VARCHAR(10) NOT NULL,
    capacidadeMaxima SMALLINT    NOT NULL CHECK (capacidadeMaxima >= 1),
    idDisciplina     INT NOT NULL REFERENCES disciplina(idDisciplina) ON DELETE RESTRICT,
    idProfessor      INT NOT NULL REFERENCES professor(idProfessor)   ON DELETE RESTRICT,
    UNIQUE (codigo, periodoLetivo)
);

CREATE TABLE horario (
    idHorario  SERIAL PRIMARY KEY,
    diaSemana  VARCHAR(10) NOT NULL
        CHECK (diaSemana IN ('SEG','TER','QUA','QUI','SEX','SAB')),
    horaInicio TIME NOT NULL,
    horaFim    TIME NOT NULL,
    local      VARCHAR(50) NOT NULL,
    idTurma    INT  NOT NULL REFERENCES turma(idTurma) ON DELETE CASCADE,
    CHECK (horaFim > horaInicio)
);

CREATE TABLE log_status_matricula (
    idLog          SERIAL    PRIMARY KEY,
    idAluno        INT       NOT NULL,
    idTurma        INT       NOT NULL,
    statusAnterior VARCHAR(20),
    statusNovo     VARCHAR(20),
    dataAlteracao  TIMESTAMP NOT NULL DEFAULT NOW(),
    usuarioBD      TEXT      NOT NULL DEFAULT current_user
);

CREATE TABLE matricula (
    idAluno       INT  NOT NULL REFERENCES aluno(idAluno) ON DELETE RESTRICT,
    idTurma       INT  NOT NULL REFERENCES turma(idTurma) ON DELETE RESTRICT,
    dataMatricula DATE NOT NULL DEFAULT CURRENT_DATE,
    status        VARCHAR(20) NOT NULL DEFAULT 'Ativa'
        CHECK (status IN ('Ativa','Trancada','Aprovado','Reprovado','Cancelada')),
    nota          NUMERIC(4,2) CHECK (nota BETWEEN 0 AND 10),
    frequencia    NUMERIC(5,2) CHECK (frequencia BETWEEN 0 AND 100),
    PRIMARY KEY (idAluno, idTurma)
);
