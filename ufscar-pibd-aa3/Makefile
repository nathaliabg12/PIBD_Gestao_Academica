.PHONY: run clean db-reset db-copy-sql db-up db-wait db-down

COMPOSE = docker compose -f docker/docker-compose.yml

run: clean db-reset db-copy-sql db-up db-wait
	@python3 -m venv .venv 2>/dev/null || true
	@.venv/bin/pip install -q -r requirements.txt && .venv/bin/streamlit run app.py

clean:
	@echo ">>> Limpando cache Python..."
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@echo ">>> Feito."

db-reset:
	@echo ">>> Derrubando container e volumes..."
	@$(COMPOSE) down -v 2>/dev/null || true

db-copy-sql:
	@echo ">>> Copiando arquivos SQL para docker/sql/..."
	@mkdir -p docker/sql
	@cp "../etapa 2/"*.sql docker/sql/
	@chmod 644 docker/sql/*.sql

db-up:
	@echo ">>> Subindo PostgreSQL..."
	@$(COMPOSE) up -d

db-wait:
	@echo ">>> Aguardando PostgreSQL ficar pronto..."
	@until $(COMPOSE) exec -T postgres pg_isready -U postgres -q 2>/dev/null; do sleep 1; done
	@echo ">>> PostgreSQL pronto."

db-down:
	@$(COMPOSE) down