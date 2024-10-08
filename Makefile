# Carrega as variáveis do .env
include .env
export $(shell sed 's/=.*//' .env)

# Nome completo da imagem
IMAGE_NAME = $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
PLATFORMS := linux/amd64,linux/arm64

# Build da imagem Docker
build:
	@echo "Building Docker image $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

# Push da imagem para o repositório
push:
	@echo "Pushing Docker image $(IMAGE_NAME)"
	docker push $(IMAGE_NAME)


# Construir imagens para múltiplas arquiteturas
# Realizar o push da imagem já construída para múltiplas arquiteturas
push-multiarch:
	@echo "Pushing multi-arch image..."
	docker buildx build . --platform $(PLATFORMS) --tag $(IMAGE_NAME) --push


# Limpeza de imagens locais
clean:
	@echo "Cleaning up local Docker images"
	docker rmi $(IMAGE_NAME)

# Build e Push em uma única etapa
all: build push

.PHONY: build push clean all
