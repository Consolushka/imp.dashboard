# Переменные
COMPOSE = docker compose
EXEC = $(COMPOSE) exec app

.PHONY: help build up down restart logs ps shell install

help: ## Показать справку
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Собрать образ
	$(COMPOSE) build

up: ## Запустить контейнеры
	$(COMPOSE) up -d

down: ## Остановить контейнеры
	$(COMPOSE) down

restart: down up ## Перезапустить контейнеры

logs: ## Просмотр логов
	$(COMPOSE) logs -f

ps: ## Статус контейнеров
	$(COMPOSE) ps

shell: ## Войти в консоль контейнера
	$(EXEC) bash

install: ## Установить зависимости внутри контейнера
	$(EXEC) npm install $(args)
