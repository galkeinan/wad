all: run

build: 
	gcc server.c -L/usr/local/lib -lwebsockets -o wad

run: wad
	./wad 

.PHONY: all run
