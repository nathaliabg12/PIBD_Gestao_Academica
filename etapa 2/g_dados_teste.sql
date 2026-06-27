-- ============================================================
-- GESTÃO ACADÊMICA — Dados de teste
-- ============================================================

INSERT INTO curso (codigo, nome, descricao) VALUES
('BCC', 'Ciência da Computação',    'Bacharelado com ênfase em fundamentos teóricos e práticos da computação'),
('BSI', 'Sistemas de Informação',   'Bacharelado voltado à análise, projeto e gestão de sistemas de informação'),
('BEC', 'Engenharia de Computação', 'Bacharelado integrando hardware, software e sistemas embarcados'),
('BMA', 'Matemática',               'Bacharelado em matemática pura e aplicada com optativas em computação'),
('BFI', 'Física',                   'Bacharelado em física teórica e experimental com laboratórios avançados'),
('BMB', 'Biomedicina',              'Bacharelado voltado ao diagnóstico laboratorial e à pesquisa biomédica'),
('BAD', 'Administração',            'Bacharelado em gestão organizacional, finanças e estratégia empresarial'),
('BDI', 'Direito',                  'Bacharelado em ciências jurídicas com ênfase em direito digital'),
('BPS', 'Psicologia',               'Bacharelado e licenciatura em psicologia clínica e organizacional'),
('BBI', 'Biotecnologia',            'Bacharelado interdisciplinar em biologia molecular e engenharia genética');

INSERT INTO professor (nome, cpf, email, titulacao) VALUES
('Roberto Sperandio Bigonha',           '12345678909', 'roberto.bigonha@dc.ufscar.br',     'Pos-Doutorado'),
('Elaine Parros Machado de Sousa',      '98765432100', 'elaine.sousa@dc.ufscar.br',         'Doutorado'),
('Caetano Traina Junior',               '11122233344', 'caetano.traina@dc.ufscar.br',       'Pos-Doutorado'),
('Agma Juci Machado Traina',            '22233344455', 'agma.traina@dc.ufscar.br',          'Doutorado'),
('José Augusto Baranauskas',            '33344455566', 'jose.baranauskas@dc.ufscar.br',     'Doutorado'),
('Maria Cristina Ferreira de Oliveira', '44455566677', 'mcristina.oliveira@dc.ufscar.br',   'Doutorado'),
('Alneu de Andrade Lopes',              '55566677788', 'alneu.lopes@dc.ufscar.br',          'Doutorado'),
('Thiago Alexandre Salgueiro Pardo',    '66677788899', 'thiago.pardo@dc.ufscar.br',         'Doutorado'),
('Diego Furtado Silva',                 '77788899900', 'diego.furtado@dc.ufscar.br',        'Mestrado'),
('Marcela Xavier Ribeiro',              '88899900011', 'marcela.ribeiro@dc.ufscar.br',      'Doutorado'),
('Luciano Antonio Digiampietri',        '99900011122', 'luciano.digiampietri@dc.ufscar.br', 'Doutorado'),
('Ricardo Marcondes Marcacini',         '10011022033', 'ricardo.marcacini@dc.ufscar.br',    'Mestrado');

INSERT INTO disciplina (codigo, nome, descricao, cargaHoraria) VALUES
('SCC0101', 'Introdução à Computação',            'Fundamentos de lógica, algoritmos e linguagens de programação',      60),
('SCC0204', 'Algoritmos e Estruturas de Dados I', 'Estruturas lineares, recursão e análise de algoritmos básicos',      60),
('SCC0205', 'Algoritmos e Estruturas de Dados II','Árvores, grafos, hashing e algoritmos avançados de busca',           60),
('SCC0501', 'Organização de Computadores I',      'Representação de dados, circuitos combinacionais e sequenciais',     60),
('SCC0602', 'Banco de Dados I',                   'Modelagem relacional, SQL, normalização e integridade de dados',     60),
('SCC0603', 'Banco de Dados II',                  'Transações, concorrência, indexação e tópicos em NoSQL',             45),
('SCC0504', 'Sistemas Operacionais',              'Gerência de processos, memória, escalonamento e sistemas de arquivos',60),
('SCC0506', 'Redes de Computadores',              'Modelos em camadas, protocolos TCP/IP, roteamento e segurança',      60),
('SCC0201', 'Programação Orientada a Objetos',    'Herança, polimorfismo, padrões de projeto e SOLID com Java',         60),
('SCC0715', 'Inteligência Artificial',            'Busca heurística, representação do conhecimento e aprendizado',      60),
('SME0101', 'Cálculo para Computação I',          'Limites, derivadas, integrais e aplicações em computação',           60),
('SME0201', 'Álgebra Linear e Aplicações',        'Vetores, matrizes, transformações lineares e autovalores',           60),
('SME0305', 'Probabilidade e Estatística',        'Distribuições de probabilidade, testes de hipótese e inferência',    45),
('SCC0901', 'Engenharia de Software I',           'Levantamento de requisitos, UML, processos ágeis e testes',          45),
('SCC0252', 'Desenvolvimento Web',                'HTML5, CSS3, JavaScript, REST APIs e frameworks modernos',           60);

INSERT INTO grade_curricular (idCurso, anoVigencia) VALUES
(1, 2020), (1, 2023),
(2, 2019), (2, 2022),
(3, 2021), (3, 2023),
(4, 2020), (5, 2021),
(6, 2022), (7, 2023);

INSERT INTO grade_disciplina (idGrade, idDisciplina, obrigatoria, periodoSugerido) VALUES
(1, 1,  TRUE,  1), (1, 2,  TRUE,  2), (1, 3,  TRUE,  3), (1, 9,  TRUE,  2), (1, 5,  TRUE,  4),
(2, 1,  TRUE,  1), (2, 2,  TRUE,  2), (2, 5,  TRUE,  3), (2, 6,  FALSE, 5), (2, 10, FALSE, 6),
(3, 1,  TRUE,  1), (3, 2,  TRUE,  2), (3, 5,  TRUE,  3), (3, 14, TRUE,  4),
(4, 1,  TRUE,  1), (4, 5,  TRUE,  2), (4, 14, TRUE,  3), (4, 15, FALSE, 4),
(5, 1,  TRUE,  1), (5, 11, TRUE,  1);

INSERT INTO aluno (numMatricula, nome, cpf, email, dataNascimento, idCurso) VALUES
('758001', 'Ana Carolina Pereira Rodrigues',    '35678901234', 'ana.rodrigues@aluno.ufscar.br',     '2001-03-15', 1),
('758002', 'Bruno Henrique dos Santos Lima',    '46789012345', 'bruno.lima@aluno.ufscar.br',        '2000-07-22', 1),
('758003', 'Camila Vitória Ferreira Souza',     '57890123456', 'camila.souza@aluno.ufscar.br',      '2001-11-30', 2),
('758004', 'Danilo Augusto Almeida Costa',      '68901234567', 'danilo.costa@aluno.ufscar.br',      '2000-05-10', 2),
('759001', 'Estela Mariana Gomes Martins',      '79012345678', 'estela.martins@aluno.ufscar.br',    '2002-01-08', 1),
('759002', 'Felipe Correia Nascimento',         '80123456789', 'felipe.nascimento@aluno.ufscar.br', '2001-09-17', 3),
('759003', 'Giovana Beatriz Ribeiro Carvalho',  '91234567890', 'giovana.carvalho@aluno.ufscar.br',  '2002-04-25', 3),
('760001', 'Heitor Lucas Melo Teixeira',        '02345678901', 'heitor.teixeira@aluno.ufscar.br',   '2003-06-12', 4),
('760002', 'Isabela Fontana Pires',             '14456789012', 'isabela.pires@aluno.ufscar.br',     '2002-08-03', 1),
('760003', 'João Pedro Moraes Cardoso',         '25567890123', 'joao.cardoso@aluno.ufscar.br',      '2003-02-19', 2),
('761001', 'Karina Luz Andrade Barbosa',        '36678901234', 'karina.barbosa@aluno.ufscar.br',    '2004-10-05', 5),
('761002', 'Leonardo Vieira Ramos',             '47789012345', 'leonardo.ramos@aluno.ufscar.br',    '2004-03-28', 4),
('761003', 'Mariana Cristina Nogueira Castro',  '58890123456', 'mariana.castro@aluno.ufscar.br',    '2003-07-14', 7),
('761004', 'Nicolas Eduardo Azevedo Fernandes', '69901234567', 'nicolas.fernandes@aluno.ufscar.br', '2004-12-01', 8),
('761005', 'Olivia Borges Machado',             '71012345678', 'olivia.machado@aluno.ufscar.br',    '2003-05-20', 1);

INSERT INTO turma (codigo, periodoLetivo, capacidadeMaxima, idDisciplina, idProfessor) VALUES
('SCC0101-A', '2025.1', 40, 1,  1),
('SCC0204-A', '2025.1', 35, 2,  2),
('SCC0602-A', '2025.1', 30, 5,  3),
('SCC0201-A', '2025.1', 40, 9,  4),
('SCC0504-A', '2025.1', 30, 7,  5),
('SCC0901-A', '2025.1', 35, 14, 6),
('SCC0252-A', '2025.1', 25, 15, 7),
('SCC0603-A', '2025.1', 20, 6,  8),
('SCC0715-A', '2025.1', 25, 10, 9),
('SME0101-A', '2025.1', 50, 11, 10),
('SCC0506-A', '2025.1', 30, 8,  11),
('SCC0205-A', '2025.1', 20, 3,  12);

INSERT INTO horario (diaSemana, horaInicio, horaFim, local, idTurma) VALUES
('SEG', '08:00', '10:00', 'Sala AB1-04', 1),
('QUA', '08:00', '10:00', 'Sala AB1-04', 1),
('TER', '10:00', '12:00', 'Sala AB2-12', 2),
('QUI', '10:00', '12:00', 'Sala AB2-12', 2),
('SEG', '14:00', '16:00', 'Lab BD',      3),
('QUA', '14:00', '16:00', 'Lab BD',      3),
('TER', '08:00', '10:00', 'Sala AB1-08', 4),
('QUI', '08:00', '10:00', 'Sala AB1-08', 4),
('SEX', '08:00', '10:00', 'Sala AB2-06', 5),
('SEG', '10:00', '12:00', 'Sala AB3-02', 6),
('QUA', '10:00', '12:00', 'Sala AB3-02', 6),
('TER', '14:00', '16:00', 'Lab Web',     7),
('QUI', '14:00', '16:00', 'Lab Web',     7),
('SEG', '16:00', '18:00', 'Sala AB2-14', 8),
('SEX', '14:00', '16:00', 'Sala IA-01',  9);

INSERT INTO matricula (idAluno, idTurma, dataMatricula, status, nota, frequencia) VALUES
(1,  1,  '2025-02-01', 'Aprovado',  8.5,  92.0),
(1,  3,  '2025-02-01', 'Aprovado',  7.2,  85.0),
(1,  4,  '2025-02-01', 'Ativa',    NULL,  75.0),
(2,  1,  '2025-02-01', 'Reprovado', 4.0,  60.0),
(2,  3,  '2025-02-01', 'Aprovado',  9.0,  95.0),
(3,  6,  '2025-02-03', 'Ativa',    NULL,  80.0),
(3,  7,  '2025-02-03', 'Ativa',    NULL,  88.0),
(4,  6,  '2025-02-03', 'Trancada', NULL,  30.0),
(5,  1,  '2025-02-05', 'Ativa',    NULL,  70.0),
(5,  4,  '2025-02-05', 'Ativa',    NULL,  65.0),
(6,  7,  '2025-02-05', 'Aprovado',  9.5,  98.0),
(7,  7,  '2025-02-05', 'Ativa',    NULL,  50.0),
(8,  10, '2025-02-07', 'Ativa',    NULL,  72.0),
(9,  2,  '2025-02-07', 'Ativa',    NULL,  68.0),
(10, 2,  '2025-02-07', 'Aprovado',  7.8,  90.0),
(11, 10, '2025-02-07', 'Ativa',    NULL,  55.0),
(12, 10, '2025-02-07', 'Reprovado', 3.5,  40.0),
(15, 1,  '2025-02-09', 'Ativa',    NULL,  82.0);
