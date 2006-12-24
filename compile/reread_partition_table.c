/*
 * Filename:      reread_partition_table.c
 * Purpose:       re-read partition table on Linux
 * Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
 * Bug-Reports:   see http://grml.org/bugs/
 * License:       This file is licensed under the GPL v2.
 * Latest change: Die Sep 05 23:13:57 CEST 2006 [mika]
 *******************************************************************************/

// diet gcc -s -Os -o reread_partition_table reread_partition_table.c

#include <fcntl.h>
#include <linux/fs.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <unistd.h>

void usage()
{
  printf("Usage: reread_partition_table <device>\n");
}

int reread_partition_table(char *dev)
{
  int fd;

  sync();

  if ((fd = open(dev, O_RDONLY)) < 0) {
    perror("error opening device");
    return(1);
  }

  if (ioctl(fd, BLKRRPART) < 0) {
    perror("unable to reload partition table");
    return(1);
  }
  else {
    printf("successfully reread partition table\n");
    return(0);
  }
}

int main(int argc, char** argv)
{
  if (getuid() != 0){
    printf("Error: reread_partition_table requires root permissions\n");
    exit(1);
  }

  if (argc < 2) {
    usage();
    exit(1);
  }
  else {
    if (strncmp(argv[1], "/dev/", 5) != 0) {
      printf("Invalid argument.\n");
      usage();
      exit(1);
    }
    reread_partition_table(argv[1]);
  }
  return EXIT_SUCCESS;
}

/* END OF FILE ****************************************************************/
