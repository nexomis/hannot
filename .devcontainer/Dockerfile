FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update \
  && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  openjdk-11-jre \
  python3-pip \
  wget \
  && mkdir -p /usr/local/bin \
  && wget -qO- https://get.nextflow.io | bash \
  && mv nextflow /usr/local/bin/ \
  && chmod o+rx /usr/local/bin//nextflow \
  && apt-get clean \
  && pip install nf-core \
  && rm -rf /var/lib/apt/lists/*
