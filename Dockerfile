FROM gcc:latest
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=python
ENV SOLVER_PROGRAMMING_LANGUAGE_VERSION={{programming_language_version}}



ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
RUN /bin/sh -c set -eux; apt-get update; apt-get install -y --no-install-recommends ca-certificates netbase tzdata ; rm -rf /var/lib/apt/lists/* # buildkit
ENV GPG_KEY=7169605F62C751356D054A26A821E680E5FA6305
ENV PYTHON_VERSION=3.12.8
ENV PYTHON_SHA256=c909157bb25ec114e5869124cc2a9c4a4d4c1e957ca4ff553f1edc692101154e
RUN /bin/sh -c set -eux; savedAptMark="$(apt-mark showmanual)"; apt-get update; apt-get install -y --no-install-recommends dpkg-dev gcc gnupg libbluetooth-dev libbz2-dev libc6-dev libdb-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev make tk-dev uuid-dev wget xz-utils zlib1g-dev ; wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; echo "$PYTHON_SHA256 *python.tar.xz" | sha256sum -c -; wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; gpg --batch --verify python.tar.xz.asc python.tar.xz; gpgconf --kill all; rm -rf "$GNUPGHOME" python.tar.xz.asc; mkdir -p /usr/src/python; tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; rm python.tar.xz; cd /usr/src/python; gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; ./configure --build="$gnuArch" --enable-loadable-sqlite-extensions --enable-optimizations --enable-option-checking=fatal --enable-shared --with-lto --with-ensurepip ; nproc="$(nproc)"; EXTRA_CFLAGS="$(dpkg-buildflags --get CFLAGS)"; LDFLAGS="$(dpkg-buildflags --get LDFLAGS)"; LDFLAGS="${LDFLAGS:--Wl},--strip-all"; make -j "$nproc" "EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" "LDFLAGS=${LDFLAGS:-}" ; rm python; make -j "$nproc" "EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" "LDFLAGS=${LDFLAGS:--Wl},-rpath='\$\$ORIGIN/../lib'" python ; make install; cd /; rm -rf /usr/src/python; find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \) -exec rm -rf '{}' + ; ldconfig; apt-mark auto '.*' > /dev/null; apt-mark manual $savedAptMark; find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual ; apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; rm -rf /var/lib/apt/lists/*; export PYTHONDONTWRITEBYTECODE=1; python3 --version; pip3 --version # buildkit
RUN /bin/sh -c set -eux; for src in idle3 pip3 pydoc3 python3 python3-config; do dst="$(echo "$src" | tr -d 3)"; [ -s "/usr/local/bin/$src" ]; [ ! -e "/usr/local/bin/$dst" ]; ln -svT "$src" "/usr/local/bin/$dst"; done # buildkit




RUN apt update && apt install -y libcurl4-openssl-dev libgomp1 && apt-get update && apt clean && rm -rf /var/lib/apt/lists/*
