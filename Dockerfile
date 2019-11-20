# TODO replace to alpine
FROM debian:stretch
ENV WSPORT 9000
# TODO replace with passing variable $WSPORT
EXPOSE 9000

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y build-essential vim gcc make cmake git libssl-dev libev-dev pkg-config systemd-sysv zlib1g-dev libsqlite3-dev libuv1-dev

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src/
RUN git clone https://github.com/warmcat/libwebsockets.git libwebsockets
WORKDIR /usr/local/src/libwebsockets
RUN mkdir build
WORKDIR /usr/local/src/libwebsockets/build

RUN cmake .. && make && make install && ldconfig -v

WORKDIR /usr/local/src
RUN git clone https://github.com/galkeinan/wad.git
WORKDIR /usr/local/src/wad
RUN git pull
ENTRYPOINT make build run
