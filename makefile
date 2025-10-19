ENV_FILE=.env

include $(ENV_FILE)

install:
#	docker-compose build
#	docker-compose up -d
	docker exec -i app composer install
	docker exec -i app php artisan key:generate

build-docker: ## Пересборка Docker-контейнеров без использования кэша
	docker-compose build --no-cache --progress=plain

stop:
	docker-compose stop

down:
	docker-compose down

up:
	docker-compose up -d

sh:
	docker exec -it app sh