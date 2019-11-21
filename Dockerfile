FROM alpine:3.9
ENV WSPORT 9000
# TODO replace with passing variable $WSPORT
EXPOSE 9000

# RUN apk add --update 
RUN apk add --no-cache alpine-sdk bash vim gcc linux-headers make cmake git libressl-dev
# Install libwebsockets from source
RUN mkdir -p /usr/local/src &&  git clone https://github.com/warmcat/libwebsockets.git && cd libwebsockets && mkdir build && cd build && cmake .. && make && make install &&  ldconfig /

RUN cd /usr/local/src && git clone https://github.com/galkeinan/wad.git
WORKDIR /usr/local/src/wad
RUN git pull

ENTRYPOINT make build run
