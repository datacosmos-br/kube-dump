# Carrega as variáveis do .env se existir, senão usa valores padrão
-include .env

# Valores padrão caso as variáveis não estejam definidas no .env
DOCKER_REGISTRY ?= example-registry.com
DOCKER_REPOSITORY ?= example-repository
DOCKER_IMAGE ?= example-image
DOCKER_TAG ?= latest

# Nome completo da imagem
IMAGE_NAME = $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY)/$(DOCKER_IMAGE):$(DOCKER_TAG)

# Build da imagem Docker
build:
	@echo "Building Docker image $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

# Push da imagem para o repositório
push:
	@echo "Pushing Docker image $(IMAGE_NAME)"
	docker push $(IMAGE_NAME)

# Limpeza de imagens locais
clean:
	@echo "Cleaning up local Docker images"
	docker rmi $(IMAGE_NAME)

# Build e Push em uma única etapa
all: build push

.PHONY: build push clean all
