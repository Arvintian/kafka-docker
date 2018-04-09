KAFKA_VERSION = 1.0.0
VERSION     = $(KAFKA_VERSION)

PROJECT     = docker-kafka
REGISTRY_URL = registry.cn-shanghai.aliyuncs.com/arvintian


build: 
	docker build -t $(PROJECT):$(VERSION) .

package: build
	docker tag $(PROJECT):$(VERSION) $(REGISTRY_URL)/$(PROJECT):$(VERSION)

publish: package
	docker push $(REGISTRY_URL)/$(PROJECT):$(VERSION)

clean:
	docker images | grep -E "($(PROJECT))" | awk '{print $$3}' | uniq | xargs -I {} docker rmi --force {}