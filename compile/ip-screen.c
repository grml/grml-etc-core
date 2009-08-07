/*
 * Filename:      ip-screen.c
 * Purpose:       print ip address of configured network interfaces
 * Authors:       grml-team (grml.org), (c) Michael Gebetsroither <gebi@grml.org>
 * Bug-Reports:   see http://grml.org/bugs/
 * License:       This file is licensed under the GPL v2.
 *********************************************************************************/

#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MAX_IFS 32
#define WRITE(x) write(1, x, strlen(x))

// USER CONFIG
#define ERR_MSG "[running ip-screen failed]\n"
#define NO_IFACE_MSG "[ network n/a ]\n"

void die(int errcode)
{
    WRITE(ERR_MSG);
    exit(errcode);
}

int main()
{
    int sockfd;
    int total, remaining, current;
    struct ifconf ifc;
    struct ifreq *ifrp;
    struct sockaddr_in *addr;
    struct in_addr *tmp = NULL;
    char buf[sizeof(struct ifreq)*MAX_IFS];
    char *ctmp = NULL;

    sockfd = socket(PF_INET,SOCK_DGRAM,0);
    if(-1 == sockfd)
        die(1);

    ifc.ifc_buf = buf;
    ifc.ifc_len = sizeof(buf);
    if (-1 == ioctl(sockfd, SIOCGIFCONF, &ifc))
        die(2);

    remaining = total = ifc.ifc_len;
    ifrp = ifc.ifc_req;
    while(remaining) {
        if( ifrp->ifr_addr.sa_family == AF_INET ) {
            if (-1 == ioctl(sockfd, SIOCGIFFLAGS, ifrp)) {
                die(3);
            }
            addr = (struct sockaddr_in *)&(ifrp->ifr_addr);
            if(!(ifrp->ifr_flags & IFF_LOOPBACK)) {
                if(tmp) {
                    ctmp = inet_ntoa(*tmp);
                    WRITE(ctmp);
                    WRITE(" | ");
                }
                tmp = &addr->sin_addr;
            }
        }

        current = sizeof(struct ifreq);
        ifrp = (struct ifreq *)( ((char *)ifrp)+current );
        remaining -= current;
    }

    if(tmp){
        ctmp = inet_ntoa(*tmp);
        WRITE(ctmp);
        WRITE("\n");
    } else {
        WRITE(NO_IFACE_MSG);
    }

    return 0;
}

/** END OF FILE *****************************************************************/
