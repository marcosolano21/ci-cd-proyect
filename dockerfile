FROM jenkins/jenkins:lts-jdk21

USER root

# Instalar herramientas básicas
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        ca-certificates \
        lsb-release \
        gnupg && \
    rm -rf /var/lib/apt/lists/*

# Agregar el repositorio oficial de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list

# Instalar Docker CLI y Docker Compose
RUN apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Mantener Jenkins ejecutándose como root para este laboratorio, ojo: no es el best practice
USER root