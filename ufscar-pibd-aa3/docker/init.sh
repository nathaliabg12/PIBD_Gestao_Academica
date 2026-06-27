#!/bin/bash
set -e

echo ">>> Criando banco gestao_academica..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d postgres \
    -c "CREATE DATABASE gestao_academica WITH ENCODING = 'UTF8';"

echo ">>> Criando tabelas e restrições..."
tail -n +6 /sql/e_ddl_restricoes.sql | \
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d gestao_academica

echo ">>> Criando índices..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d gestao_academica \
    -f /sql/f_indices.sql

echo ">>> Inserindo dados de teste..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d gestao_academica \
    -f /sql/g_dados_teste.sql

echo ">>> Criando procedures, functions e triggers..."
# || true pois o script tem chamadas de teste que falham intencionalmente
psql -U "$POSTGRES_USER" -d gestao_academica \
    -f /sql/h_procedures_functions_triggers.sql || true

echo ">>> Banco inicializado com sucesso."
