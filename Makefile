setup-db:
    docker compose exec bagisto-mysql mysql --user=root --password=root -e "CREATE DATABASE bagisto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

.PHONY: setup-db
