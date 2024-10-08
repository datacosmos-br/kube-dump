CHART_NAME := kube-dump
NAMESPACE := kube-dump

.PHONY: all lint install upgrade delete

all: lint install

lint:
	@echo "Linting Helm chart..."
	helm lint $(CHART_NAME)/

install:
	@echo "Installing Helm chart..."
	helm upgrade --install $(CHART_NAME)/ ./ -n $(NAMESPACE) --create-namespace

upgrade:
	@echo "Upgrading Helm chart..."
	helm upgrade $(CHART_NAME)/ ./ -n $(NAMESPACE)

delete:
	@echo "Deleting Helm chart..."
	helm uninstall $(CHART_NAME)/ -n $(NAMESPACE)