# Portal do Aluno — Gestão Acadêmica

Aplicação web para o subsistema de matrículas de um sistema de gestão acadêmica universitária. Desenvolvida em Python com Streamlit, conectada a um banco PostgreSQL.

## Funcionalidades

- **Login** por número de matrícula
- **Minhas Turmas** — visualização de disciplinas, professor, horários, nota, frequência e status de cada matrícula, com cálculo do IRA
- **Nova Matrícula** — listagem de turmas com vagas disponíveis e realização de matrícula
- **Trancamento** de matrícula ativa

## Tecnologias

| | |
|---|---|
| Python 3 | Linguagem principal |
| Streamlit | Interface web |
| psycopg2 | Conexão com PostgreSQL |
| PostgreSQL 16 | Banco de dados |
| Docker + pgAdmin | Infraestrutura local |

## Como rodar

**Pré-requisitos:** Docker e Python 3 instalados.

```bash
make run
```

Isso irá:
1. Limpar cache Python
2. Derrubar e recriar o container do banco
3. Copiar os scripts SQL e inicializar o banco com dados de teste
4. Aguardar o PostgreSQL ficar pronto
5. Instalar dependências Python
6. Abrir a aplicação em `http://localhost:8501`

## pgAdmin

Para visualizar o banco, acesse `http://localhost:5050` após o `make run`.

- **Email:** `admin@admin.com`
- **Senha:** `admin`

Ao adicionar um novo servidor, use:
- **Host:** `postgres`
- **Port:** `5432`
- **Username:** `postgres`
- **Password:** `postgres`

## Matrículas para teste

| Matrícula | Aluno |
|---|---|
| `758001` | Ana Carolina Pereira Rodrigues |
| `758002` | Bruno Henrique dos Santos Lima |
| `761003` | Mariana Cristina Nogueira Castro |
| `761005` | Olivia Borges Machado |

## Outros comandos

```bash
make db-down   # para o PostgreSQL
make clean     # limpa cache Python
```
