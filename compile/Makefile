PROGS = cpu-screen

#ifndef CFLAGS
CFLAGS = -O2 -Wall -s
#endif

#ifndef LDFALGS
LDFLAGS = -s
#endif

#ifndef CC
CC = gcc
#endif

all: $(PROGS)

cpu-screen: cpu-screen.c
	diet $(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(PROGS)
