FROM python:3.12-alpine
RUN apk add --no-cache gcc binutils util-linux bash python3.dev libbsd-dev musl-dev linux-headers hdf5-dev
WORKDIR /app
COPY . /app
