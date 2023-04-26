DB_DIR=db/migration
DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable
PWD=.

postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migratecreate:
	migrate create -ext sql -dir "$(DB_DIR)" -seq init_schema

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration --database "$(DB_URL)" -verbose down

sqlc:
	docker run --rm -v ${pwd}:/src -w /src kjconroy/sqlc generate
	
.PHONY: postgres createdb dropdb migratecreate migrateup migratedown sqlc