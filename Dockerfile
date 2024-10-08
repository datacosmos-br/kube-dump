FROM alpine:3.20

ARG KUBECTL_VERSION="1.24.0"

LABEL maintainer="woozymasta@gmail.com"

# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    bash bind-tools jq yq openssh-client git tar xz gzip bzip2 curl coreutils grep python3 py3-pip && \
    curl -sLo /usr/bin/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" && \
    chmod +x /usr/bin/kubectl

RUN mkdir /root/.ssh/

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -H github.com >> /root/.ssh/known_hosts

RUN touch /root/.ssh/config
RUN echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

RUN pip3 install awscli --break-system-packages

COPY ./kube-dump /kube-dump

ENTRYPOINT [ "/kube-dump" ]
