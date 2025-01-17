FROM python:3.11-slim
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=python
ENV SOLVER_PROGRAMMING_LANGUAGE_VERSION=3.11
RUN echo "deb http://deb.debian.org/debian bookworm-backports main" >> /etc/apt/sources.list
RUN apt update && apt install -y libcurl4-openssl-dev libgomp1 && apt-get install -y build-essential libstdc++6 \ 
    build-essential wget libgmp-dev libmpfr-dev libmpc-dev && apt clean && rm -rf /var/lib/apt/lists/*

RUN wget -q https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz && \
    tar -xf gcc-14.2.0.tar.gz && \
    cd gcc-14.2.0 && \
    ./contrib/download_prerequisites && \
    ./configure --disable-multilib --enable-languages=c,c++ && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf gcc-14.2.0.tar.gz gcc-14.2.0

RUN update-alternatives \
        --install /usr/bin/gcc gcc /usr/local/bin/gcc 60 \
        --slave /usr/bin/g++ g++ /usr/local/bin/g++ && \
    apt purge -y gcc cpp
