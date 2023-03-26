FROM golang:1.18.2-alpine as build

COPY build/app/go.mod src/go.mod
COPY build/app/cmd src/cmd/
COPY build/app/models src/models/
COPY build/app/restapi src/restapi/

RUN cd src/ && go mod tidy

RUN cd src && \
    export CGO_LDFLAGS="-static -w -s" && \
    go build -tags osusergo,netgo -o /application cmd/vmware-python-server/main.go; 

FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
		ca-certificates \
		libbluetooth-dev \
		netbase \
		tk-dev \
		uuid-dev

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
		cmake \
		gnupg \
		gzip \
		jq \
		tzdata \
		unzip \
		wget \
		zip \
		dpkg-dev \
		gcc \
		gnupg dirmngr \
		libbluetooth-dev \
		libbz2-dev \
		libc6-dev \
		libdb-dev \
		libexpat1-dev \
		libffi-dev \
		libgdbm-dev \
		liblzma-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		tk-dev \
		uuid-dev \
		wget \
		xz-utils \
		zlib1g-dev

RUN apt-get install -y git

RUN curl https://pyenv.run | bash 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PYENV_ROOT=/root/.pyenv \
	PATH=/root/.pyenv/shims:/root/.pyenv/bin:/root/.poetry/bin:$PATH

# install n-2 (pyenv install --list)
RUN env PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations" pyenv install 3.11.2 && pyenv global 3.11.2
# RUN env PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations" pyenv install 3.10.10 && pyenv global 3.10.10
# RUN env PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations" pyenv install 3.9.16
# RUN env PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations" pyenv install 3.8.16

RUN python --version && \
	pip --version && \
	pip install pipenv wheel pyvmomi setuptools

RUN pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -

# DON'T CHANGE BELOW 
COPY --from=build /application /bin/application

EXPOSE 8080

CMD ["/bin/application", "--port=8080", "--host=0.0.0.0", "--write-timeout=0"]