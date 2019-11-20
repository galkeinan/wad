# TODO replace to alpine
FROM debian:stretch
ENV WSPORT 9000
# TODO replace with passing variable $WSPORT
EXPOSE 9000

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y vim gcc cmake git libssl-dev libev-dev pkg-config systemd-sysv zlib1g-dev libsqlite3-dev
RUN apt-get -t stretch-backports install libuv1-dev

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src/
RUN git clone https://github.com/warmcat/libwebsockets.git libwebsockets
WORKDIR /usr/local/src/libwebsockets
RUN mkdir build
WORKDIR /usr/local/src/libwebsockets/build

RUN cmake .. -DLWS_WITH_LWSWS=1 -DLWS_WITH_GENERIC_SESSIONS=1
RUN make && make install
# install libs in /usr/local/lib ; configured in /etc/ld.so.conf.d/libc.conf
# ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
RUN ldconfig -v 

WORKDIR /usr/local/src
ADD main.c .
RUN gcc main.c -L/usr/local/lib -lwebsockets -o wad

# Run webserver when the container launches
# git clone git@galk:wad
# TODO CMD ["git pull && make && ./wad", ""]
CMD ["./wad", ""]
