# Usa la imagen de gcc con la versión que te interese, por ejemplo gcc:14
FROM gcc:14
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=python
ENV SOLVER_PROGRAMMING_LANGUAGE_VERSION=3.12

# Evitar interacciones al instalar
ENV DEBIAN_FRONTEND=noninteractive

# Instalamos paquetes necesarios para compilar Python desde fuente
RUN apt-get update && apt-get install -y --no-install-recommends  build-essential make wget curl 
RUN apt-get install -y --no-install-recommends software-properties-common ca-certificates libssl-dev libffi-dev zlib1g-dev libbz2-dev 
RUN apt-get install -y --no-install-recommends libreadline-dev libsqlite3-dev tk-dev python3 python3-pip xz-utils && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get -y upgrade
RUN python3 -m venv venv
RUN source venv/bin/activate
