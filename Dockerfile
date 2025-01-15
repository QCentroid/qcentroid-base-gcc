FROM python:3.12-slim
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=julia
RUN apt-get clean -qq && \
    apt-get update -qq && apt-get install -y -qq libc-bin libcurl4-openssl-dev libgomp1 curl bash && apt-get clean -qq && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -q --upgrade pip
RUN pip install --no-cache-dir -q juliacall
WORKDIR /problem