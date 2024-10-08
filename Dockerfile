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

COPY ./kube-dump /kube-dump

RUN addgroup -S kubeuser && adduser -S kubeuser -G kubeuser && \
    mkdir -p /home/kubeuser/.ssh && \
    ssh-keyscan -H github.com >> /home/kubeuser/.ssh/known_hosts && \
    touch /kubeuser/.ssh/config && \
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /kubeuser/.ssh/config && \
    chown -R kubeuser:kubeuser /home/kubeuser/.ssh && \
    chmod 700 /home/kubeuser/.ssh && \
    chmod 600 /home/kubeuser/.ssh/ && \
    mkdir -p /data && chown -R kubeuser:kubeuser /data & \
    chmod +x /kube-dump

USER kubeuser

ENTRYPOINT [ "/kube-dump" ]
