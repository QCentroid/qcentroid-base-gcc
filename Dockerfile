# Usa la imagen de gcc con la versión que te interese, por ejemplo gcc:14
FROM gcc:14
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=python
ENV SOLVER_PROGRAMMING_LANGUAGE_VERSION=3.12

# Evitar interacciones al instalar
ENV DEBIAN_FRONTEND=noninteractive

# Instalamos paquetes necesarios para compilar Python desde fuente
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    make \
    wget \
    curl \
    software-properties-common \
    ca-certificates \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    tk-dev \
    python{{SOLVER_PROGRAMMING_LANGUAGE_VERSION}} \
    xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
