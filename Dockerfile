FROM python:3.6.9-alpine3.10
FROM ubuntu:20.04
WORKDIR /usr/src/app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y make \
  curl \
  git \
  python3-pip \
  libpq-dev \
  build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
RUN curl https://pyenv.run | bash
RUN ln -s /root/.pyenv/bin/pyenv /bin/pyenv
RUN pip3 install tox
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY . .
RUN make dev || :
RUN chmod +x ./scripts/await-elastic.sh