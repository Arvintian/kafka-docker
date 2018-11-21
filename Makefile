KAFKA_VERSION = 1.0.2
SCALA_VERSION = 2.11
VERSION     = $(KAFKA_VERSION)

PROJECT     = docker-kafka

build:
	docker build --build-arg kafka_version=$(KAFKA_VERSION) --build-arg scala_version=$(SCALA_VERSION) -t $(PROJECT):$(VERSION) .