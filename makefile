ENV_FILE=.env

include $(ENV_FILE)

install:
	@#test -e .env || cp -n .env.example .env
	docker-compose build --no-cache
	docker-compose up -d
	docker exec -i app composer install
	docker exec -i app php artisan key:generate
	docker exec -i app php artisan migrate