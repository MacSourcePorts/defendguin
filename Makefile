# Makefile for defendguin

# by Bill Kendrick
# bill@newbreedsoftware.com
# http://www.newbreedsoftware.com/defendguin/

# November 6, 1999 - May 25, 2020


# User-definable stuff:

CFLAGS=-Wall -O2
#DATA_PREFIX=$(PWD)/data/
PREFIX=/usr/local
MAN_PREFIX=$(PREFIX)
BIN_PREFIX=$(PREFIX)/bin
DATA_PREFIX=
JOY=YES


# Other definitions:

# SDL_CFLAGS := $(shell sdl-config --cflags)
# SDL_LDFLAGS := $(shell sdl-config --libs) -L/usr/X11R6/lib
MIXER=-lSDL_mixer
NOSOUNDFLAG=__SOUND
CFLAGS=-arch $(ARCH) -Wall $(SDL_CFLAGS) -DDATA_PREFIX=\"$(DATA_PREFIX)\" -D$(NOSOUNDFLAG) \
	-DJOY_$(JOY)
SDL_LIB=$(SDL_LDFLAGS) $(MIXER)


# Make commands:

all:	defendguin

nosound:
	make defendguin MIXER= NOSOUNDFLAG=NOSOUND

install:	defendguin
	install -d $(DATA_PREFIX)
	cp -R data/* $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp defendguin $(BIN_PREFIX)/
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/defendguin
	-mkdir -p $(MAN_PREFIX)/man/man6/
	cp src/defendguin.6 $(MAN_PREFIX)/man/man6/
	chmod a+rx,g-w,o-w $(MAN_PREFIX)/man/man6/defendguin.6

uninstall:
	-rm -r $(DATA_PREFIX)
	-rm $(PREFIX)/bin/defendguin
	-rm $(PREFIX)/man/man6/defendguin.6

clean:
	-rm defendguin
	-rm obj/*.o


# Main executable:

defendguin:	obj/defendguin.o obj/pixels.o
	$(CC) $(CFLAGS) obj/defendguin.o obj/pixels.o  src/msputils.m -o defendguin $(SDL_LIB) -lm


# Main object:

obj/defendguin.o:	src/defendguin.c src/pixels.h
	$(CC) $(CFLAGS)	src/defendguin.c -c -o obj/defendguin.o

# Other objects:

obj/pixels.o:	src/pixels.c src/pixels.h
	$(CC) $(CFLAGS)	src/pixels.c -c -o obj/pixels.o $(EXTRA_LIBS)
