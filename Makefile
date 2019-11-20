all: run

build: 
	gcc main.c -L/usr/local/lib -lwebsockets -o wad

run: wad
	./wad 

.PHONY: all run
