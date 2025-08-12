FROM node:20

LABEL org.opencontainers.image.title="Terraform Drift Detection"
LABEL org.opencontainers.image.description="Run terraform plan to detect drift"
LABEL org.opencontainers.image.authors="Gus Vega <github.com/gusvega>"

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN set -eux; \
    mkdir -p /tmp/terraform && cd /tmp/terraform && \
    wget -q https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip && \
    unzip terraform_1.5.6_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform && \
    cd / && rm -rf /tmp/terraform

WORKDIR /github/workspace

COPY . /action
WORKDIR /action

RUN npm install

ENTRYPOINT ["node", "/action/index.js"]
