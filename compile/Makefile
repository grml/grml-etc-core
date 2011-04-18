PROGS = ip-screen cpu-screen

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

ip-screen: ip-screen.c
	diet $(CC) $(CFLAGS) -o $@ $^

cpu-screen: cpu-screen.c
	diet $(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(PROGS)
