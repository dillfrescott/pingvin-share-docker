FROM ubuntu:24.04

RUN apt update && apt upgrade -y

RUN apt install -y git sudo curl debian-keyring debian-archive-keyring apt-transport-https

RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/testing/gpg.key' | sudo gpg \
--dearmor -o /usr/share/keyrings/caddy-testing-archive-keyring.gpg

RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/testing/debian.deb.txt' | sudo \
tee /etc/apt/sources.list.d/caddy-testing.list

RUN apt update && apt install -y caddy

RUN mkdir -p /etc/caddy

RUN rm -rf /etc/caddy/*

COPY ./Caddyfile /etc/caddy/

RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh

RUN sudo -E bash nodesource_setup.sh

RUN sudo apt install -y nodejs

RUN git clone https://github.com/dillfrescott/pingvin-share

RUN npm i -g pm2

WORKDIR /pingvin-share/backend

RUN npm install && npm run build

WORKDIR /pingvin-share/frontend

RUN npm install && npm run build

COPY ./entrypoint.sh /

ENTRYPOINT ["/bin/bash", "-c", "chmod +x /entrypoint.sh && /entrypoint.sh"]