.PHONY: help mobile-format mobile-analyze mobile-test mobile-integration-test api-build api-format api-lint api-test api-health api-alembic-current api-alembic-upgrade openapi-validate db-up db-down validate-phase-0 validate-phase-1 validate-phase-2 validate-phase-3 validate-phase-4

API_DIR := apps/api
MOBILE_DIR := apps/mobile
DOCKER_CONFIG_DIR ?= /tmp/inline-hockey-coach-docker
DOCKER_HOST ?= unix://$(HOME)/.docker/run/docker.sock
COMPOSE := DOCKER_CONFIG=$(DOCKER_CONFIG_DIR) DOCKER_HOST=$(DOCKER_HOST) docker compose
DATABASE_URL ?= postgresql+asyncpg://app:app@localhost:5432/inline_hockey
API_ENV ?= local
API_KEY ?= development-only

help:
	@printf '%s\n' 'Targets: validate-phase-0, validate-phase-1, validate-phase-2, validate-phase-3, validate-phase-4, mobile-format, mobile-analyze, mobile-test, mobile-integration-test, api-lint, api-test, api-health, openapi-validate, db-up, db-down'

mobile-format:
	cd $(MOBILE_DIR) && dart format --output=none --set-exit-if-changed .

mobile-analyze:
	cd $(MOBILE_DIR) && flutter analyze

mobile-test:
	cd $(MOBILE_DIR) && flutter test

mobile-integration-test:
	cd $(MOBILE_DIR) && flutter test integration_test/app_smoke_test.dart -d flutter-tester

api-build:
	@mkdir -p $(DOCKER_CONFIG_DIR)
	@test -f $(DOCKER_CONFIG_DIR)/config.json || printf '{}\n' > $(DOCKER_CONFIG_DIR)/config.json
	$(COMPOSE) build api

api-format: api-build
	$(COMPOSE) run --rm --no-deps api ruff format --check .

api-lint: api-build
	$(COMPOSE) run --rm --no-deps api ruff check .

api-test: api-build
	$(COMPOSE) run --rm --no-deps api pytest

api-health: api-build
	$(COMPOSE) run --rm --no-deps api python -c "from fastapi.testclient import TestClient; from app.main import app; response = TestClient(app).get('/health'); assert response.status_code == 200, response.text; assert response.json() == {'status': 'ok'}, response.text"

api-alembic-current: db-up api-build
	$(COMPOSE) run --rm api alembic current

api-alembic-upgrade: db-up api-build
	$(COMPOSE) run --rm api alembic upgrade head

openapi-validate: api-build
	$(COMPOSE) run --rm --no-deps -v "$(CURDIR)/contracts:/contracts:ro" api openapi-spec-validator /contracts/openapi.yaml

db-up:
	$(COMPOSE) up -d db

db-down:
	$(COMPOSE) down

validate-phase-0: mobile-format mobile-analyze mobile-test mobile-integration-test api-format api-lint api-test api-health api-alembic-current openapi-validate

validate-phase-1: mobile-format mobile-analyze mobile-test mobile-integration-test api-format api-lint api-test api-health api-alembic-upgrade openapi-validate

validate-phase-2: mobile-format mobile-analyze mobile-test mobile-integration-test api-format api-lint api-test api-health api-alembic-upgrade openapi-validate

validate-phase-3: mobile-format mobile-analyze mobile-test mobile-integration-test api-format api-lint api-test api-health api-alembic-upgrade openapi-validate

validate-phase-4: mobile-format mobile-analyze mobile-test mobile-integration-test api-format api-lint api-test api-health api-alembic-upgrade openapi-validate
