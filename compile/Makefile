PROGS = ip-screen pong vmware-detect align cpu-screen dpkg_not_running reread_partition_table gtf

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

pong: pong.c

vmware-detect: vmware-detect.c
	diet $(CC) $(CFLAGS) -o $@ $^

dpkg_not_running: dpkg_not_running.c
	diet $(CC) $(CFLAGS) -o $@ $^

align: align.c

reread_partition_table: reread_partition_table.c
	diet $(CC) $(CFLAGS) -o $@ $^

gtf: gtf.c
	$(CC) gtf.c -lm -Wall -o gtf

clean:
	rm -f $(PROGS)
