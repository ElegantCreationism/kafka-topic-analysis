SHELL=/bin/bash

.PHONY: ci
ci: all

.PHONY: all
all: lint unit_test build dockerise

.PHONY: build
build:
	CGO_ENABLED=0 GOOS=linux go build -a -o ./artifacts/kafkanalysis-linux .
	CGO_ENABLED=0 GOOS=darwin go build -a -o ./artifacts/kafkanalysis-darwin .

.PHONY: deps
deps:
	go mod vendor

.PHONY: unit_test
unit_test:
	go test -v -cover `go list ./... | grep -v tests_system`

.PHONY: system_test
system_test: build dockerise

.PHONY: dockerise
dockerise:
	docker build -t kafkanalysis:v0.0.0 .

.PHONY: lint
lint:
	golangci-lint run


