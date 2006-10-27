/* Filename:      dpkg_not_running
*  Purpose:       check whether Debian's package management (dpkg) is running
*  Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
*  Bug-Reports:   see http://grml.org/bugs/
*  License:       This file is licensed under the GPL v2.
*  Latest change: Mit Jun 28 18:13:43 CEST 2006 [mika]
*******************************************************************************/
// return 0 if it is not running; return 1 if it is running

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    struct flock fl = { F_WRLCK, SEEK_SET, 0, 0, 0 };
    int fd;
    fl.l_pid = getpid();

    if ((fd = open("/var/lib/dpkg/lock", O_RDWR)) == -1) {
        exit(1);
    }

    if (fcntl(fd, F_SETLK, &fl) == -1) {
        exit(1); // it is running
    }
    else {
        exit(0); // it is not running
    }

    return 0;
}

/* END OF FILE ****************************************************************/
