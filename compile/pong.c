/*
 * By Patrick Reynolds <reynolds@cs.duke.edu>
 * Distributed under GPL.
 *
 * Build instructions
 *   gcc pong.c -o pong
 *
 * Usage:
 *   pong 1.2.3.0     # as root!
 */

#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/ip_icmp.h>
#include <sys/socket.h>

#define PONG_DEAD 0
#define PONG_BROKEN 1
#define PONG_OKAY 2

#undef I_CARE_ABOUT_BAD_RETURN_PACKETS

int id, sock;
int datalen = 0;
int nhosts = 256;
int vec[256];
int foo_set = 0;
struct sockaddr_in dest;

void pong();
void catch();
int in_cksum(u_short *addr, int len);
void print();
void foo(int i) { foo_set = 1; }

int main(int argc, char **argv) {
  id = getpid();
  if ((sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)) < 0) {
    perror("pong: socket");
    return -1;
  }
  if (argc != 2) {
    fprintf(stderr, "Usage:\n  %s aaa.bbb.ccc.0\n\n", argv[0]);
    return -1;
  }
  bzero(&dest, sizeof(dest));
  dest.sin_family = AF_INET;
  inet_aton(argv[1], &dest.sin_addr);
  pong();
  catch();
  print();
  return 0;
}

void pong() {
  unsigned char buf[sizeof(struct icmphdr)];
  struct icmphdr *p = (struct icmphdr *)buf;
  int ret, i;

	fprintf(stderr, "Sending packets");

  p->type = ICMP_ECHO;
  p->code = 0;
  p->checksum = 0;
  p->un.echo.sequence = 0;
  p->un.echo.id = id;

  p->checksum = in_cksum((u_short *)p, datalen + 8);

  dest.sin_addr.s_addr &= 0xffffff;
  for (i=1; i<=254; i++) {
		fputc('.', stderr);
		fflush(stderr);
    dest.sin_addr.s_addr &= 0xffffff;
    dest.sin_addr.s_addr |= (i<<24);
    ret = sendto(sock, (char *)buf, 8 + datalen, 0,
      (struct sockaddr *)&dest, sizeof(struct sockaddr_in));
    if (ret != 8 + datalen) {
      if (ret < 0)
        perror("pong: sendto");
      printf("pong: wrote %d chars, ret=%d\n", 8+datalen, ret);
    }
  }
	fputc('\n', stderr);
}

void catch() {
  int ret;
  char incoming[128];
	fprintf(stderr, "Gathering responses");
  bzero(vec, nhosts*sizeof(int));
  alarm(5);
  signal(SIGALRM, foo);
  signal(SIGINT, foo);
  while (!foo_set) {
    struct sockaddr_in from;
		fd_set rfds;
		struct timeval tv = { 1, 0 };
    socklen_t fromlen = sizeof(from);
		FD_ZERO(&rfds);
		FD_SET(sock, &rfds);
		if (select(sock+1, &rfds, NULL, NULL, &tv) <= 0) continue;
    ret = recvfrom(sock, (char *)incoming, 128, 0, (struct sockaddr *)&from,
      &fromlen);
#ifdef I_CARE_ABOUT_BAD_RETURN_PACKETS
    if (ret != datalen + 16 && (ret >= 0 || errno != EINTR)) {
      if (ret < 0)
        perror("pong: recvfrom");
      else
        vec[from.sin_addr.s_addr >> 24] = PONG_BROKEN;
      printf("pong: read %d chars, ret=%d, host=%d\n", 16+datalen, ret,
        from.sin_addr.s_addr>>24);
    }
    else
#endif
		{
			fputc('.', stderr);
			fflush(stderr);
      vec[from.sin_addr.s_addr >> 24] = PONG_OKAY;
		}
  }
	fputc('\n', stderr);
}

int in_cksum(u_short *addr, int len) {
  register int nleft = len;
  register u_short *w = addr;
  register int sum = 0;
  u_short answer = 0;
        
  while (nleft > 1)  {
    sum += *w++;
    nleft -= 2;
  }
  if (nleft == 1) {
    *(u_char *)(&answer) = *(u_char *)w ;
    sum += answer;
  }
  sum = (sum >> 16) + (sum & 0xffff);
  sum += (sum >> 16);
  answer = ~sum;
  return(answer);
}

void print() {
  int i, count = 0;
  for (i=0; i<=255; i++)
    if (vec[i]) {
      unsigned int ip = ntohl(dest.sin_addr.s_addr);
      count++;
      printf("%d.%d.%d.%d: %s\n", ip>>24, (ip>>16)&0xff, (ip>>8)&0xff, i,
        vec[i]==PONG_OKAY ? "found" : "broken");
    }
  printf("\nTotal hosts: %d\n", count);
}
