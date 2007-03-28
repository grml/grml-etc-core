#include "string.h"
#include "unistd.h"
#include "stdio.h"
#include "stdlib.h"
#include "signal.h"

#define WRITE(x) write(1, x, strlen(x))
#define DWRITE(x) do{ \
    if(debug) { \
        WRITE(x); \
    } \
} while(0);
#define FALSE 0
#define TRUE !FALSE

/* doc:
 * vmware IO backdoor: http://chitchat.at.infoseek.co.jp/vmware/backdoor.html
 * http://www.honeynet.org/papers/bots/botnet-code.html
 * http://www.codegurus.be/codegurus/Programming/virtualpc&vmware_en.htm
 */

// from libowfat {{{
static inline char tohex(char c) {
  return c>=10?c-10+'a':c+'0';
}

unsigned int fmt_xlong(char *dest,unsigned long i) {
  register unsigned long len,tmp;
  /* first count the number of bytes needed */
  for (len=1, tmp=i; tmp>15; ++len) tmp>>=4;
  if (dest)
    for (tmp=i, dest+=len; ; ) {
      *--dest = tohex(tmp&15);
      if (!(tmp>>=4)) break;
    }
  return len;
}
// }}}

void printIdtr(const unsigned char* idtr, unsigned size)
{
    unsigned i;
    for(i=0; i<size; ++i) {
        char out[4] = {0};
        fmt_xlong(out, idtr[i]);
        if(strlen(out) == 1)
            WRITE("0");
        WRITE(out);
    }
    WRITE("\n");
}

// i386 {{{
#if defined (__i386__) || defined (__x86_64__)
int checkVmware(const int debug)
{
    unsigned char idtr[10] = {0};
    asm("sidt %0" : "=m" (idtr));
    if(debug)
        printIdtr(idtr, sizeof(idtr));
    // should normally be the case on amd64, but does not work
    //return (0xff==idtr[9]) ? 1 : 0;
    return (0xff==idtr[5]) ? 1 : 0;
}
int checkVmwareIO()
{
    unsigned int vmaj, vmin, magic, dout = 11;
    __asm__ __volatile__(
            "mov $0x564D5868, %%eax; /* magic number */"
            "mov $0x3c6cf712, %%ebx; /* random number */"
            "mov $0x0000000A, %%ecx; /* specifies command */"
            "mov $0x5658, %%edx; /* VMware I/O port */"
            "in %%dx, %%eax;"
            "mov %%eax, %0;"
            "mov %%ebx, %1;"
            "mov %%ecx, %2;"
            "mov %%edx, %3;"
        : "=r"(vmaj), "=r"(magic), "=r"(vmin), "=r"(dout));
#ifdef DEBUG
    fprintf(stderr, "version: major=%x, minor=%x, magic=%x, dout=%x\n",
            vmaj, vmin, magic, dout);
#endif
    return (0x564D5868 == magic) ? 1 : 0;
}
// }}}

// others {{{
#else
// vmware runs only on the archs above
int checkVmware(const int) { return 0; }
int checkVmwareIO() { return 0; }
#endif
// }}}

static int Killed = FALSE;

// returns 0 if running inside vmware, 1 otherwise
int main(int argc, char* argv[]) {
    int debug = FALSE;
    if(argc == 2 && !strcmp(argv[1], "--debug"))
        debug = TRUE;

    int a, b;
    // known to be false positives
    a = checkVmware(debug);
    DWRITE("idt-check: ")
    if(!a) {
        DWRITE("false\n");
        if(!debug)
            return EXIT_FAILURE;
    } else
        DWRITE("true\n");

    // never returns if not running under vmware
    void dummy() { Killed=TRUE; DWRITE("false\n"); exit(1); }
    signal(SIGSEGV, dummy);
    DWRITE("ioport-check: ");
    b = checkVmwareIO();
    if(b) {
        DWRITE("true\n");
        return EXIT_SUCCESS;
    } else {
        if(!Killed) {
            // check unuseable or not implemented
            DWRITE("false\n");
            DWRITE("Check not implemented, yet!\n");
            return a ? EXIT_SUCCESS : EXIT_FAILURE;
        } else {
            // never reached
            WRITE("Error: IO check hasn't killed the program but no vmware found either!\n");
            return EXIT_FAILURE;
        }
    }
}
// vim: foldmethod=marker
