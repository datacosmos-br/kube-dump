FROM alpine:3.20

ARG KUBECTL_VERSION="1.30.0"
ARG TARGETPLATFORM

LABEL maintainer="woozymasta@gmail.com"

# Mapeia a arquitetura para baixar a versão correta do kubectl
RUN case "$TARGETPLATFORM" in \
    "linux/amd64") ARCH="amd64" ;; \
    "linux/arm64") ARCH="arm64" ;; \
    "linux/arm/v7") ARCH="arm" ;; \
    *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    apk add --update --no-cache \
        bash bind-tools jq yq openssh-client git tar xz gzip bzip2 curl coreutils grep aws-cli && \
    curl -sLo /usr/bin/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/${ARCH}/kubectl" && \
    chmod +x /usr/bin/kubectl

RUN mkdir -p /root/.ssh/ && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan -H github.com >> /root/.ssh/known_hosts && \
    touch /root/.ssh/config && \
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY ./kube-dump /kube-dump

ENTRYPOINT [ "/kube-dump" ]
