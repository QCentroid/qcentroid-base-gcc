FROM alpine:3.21
ENV PIP_ROOT_USER_ACTION=ignore
ENV SOLVER_PROGRAMMING_LANGUAGE=python
ENV SOLVER_PROGRAMMING_LANGUAGE_VERSION={{programming_language_version}}
ENV RUST_BACKTRACE=full
ENV CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true
RUN apk add --no-cache gcc binutils util-linux bash python3 cmd:pip3 python3-dev libbsd-dev musl-dev linux-headers hdf5-dev curl cargo openssl-dev ca-certificates && \
    apk add --no-cache clang llvm lld build-base elfutils-dev  linux-headers maturin mitmproxy libffi-dev g++ libxml2-dev zlib-dev libxslt-dev tshark

