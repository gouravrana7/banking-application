postgres:
	sudo docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=90483 -d postgres:12-alpine

createdb:
	sudo docker exec -it postgres12 createdb --username=root --owner=root banking_app

dropdb:
	sudo docker exec -it postgres12 dropdb banking_app

migrateup:
	migrate -path db/migration -database "postgresql://root:90483@localhost:5432/banking_app?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:90483@localhost:5432/banking_app?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test