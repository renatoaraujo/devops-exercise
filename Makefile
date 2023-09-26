.PHONY: test

test:
	go test ./... -v

local-infrastructure:
	docker compose up --build