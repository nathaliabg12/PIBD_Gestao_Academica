-- ============================================================
-- GESTÃO ACADÊMICA — Índices
-- ============================================================

CREATE INDEX idx_aluno_num_matricula    ON aluno(numMatricula);
CREATE INDEX idx_aluno_curso            ON aluno(idCurso);
CREATE INDEX idx_turma_periodo_letivo   ON turma(periodoLetivo);
CREATE INDEX idx_turma_professor        ON turma(idProfessor);
CREATE INDEX idx_matricula_aluno        ON matricula(idAluno);
CREATE INDEX idx_matricula_status       ON matricula(status);
CREATE INDEX idx_grade_disciplina_grade ON grade_disciplina(idGrade);
CREATE INDEX idx_horario_turma          ON horario(idTurma);
