#include "string.h"
#include "unistd.h"
#include "stdio.h"
#include "stdlib.h"

#define WRITE(x) write(1, x, strlen(x))
#define DWRITE(x) do{ \
    if(debug) { \
        WRITE(x); \
    } \
} while(0);
#define FALSE 0
#define TRUE !FALSE

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
    for(i=0; i<=size; ++i) {
        char out[4] = {0};
        fmt_xlong(out, idtr[i]);
        WRITE(out);
    }
    WRITE("\n");
}

#if defined (__i386__)
int checkVmware(const int debug)
{
    unsigned char idtr[6] = {0};
    asm("sidt %0" : "=m" (idtr));
    if(debug)
        printIdtr(idtr, 6);
    return (0xff==idtr[5]) ? 1 : 0;
}
int checkVmwareIO()
{
    unsigned int vmaj, vmin, magic, dout;
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
    return (0x564D5868 == magic) ? 1 : 0;
}
#elif defined (__x86_64__)
// only guessed, possible need to check against 0xffff?
int checkVmware(const int debug)
{
    unsigned char idtr[10];
    asm("sidt %0" : "=m" (idtr));
    if(debug)
        printIdtr(idtr, 10);
    return (0xff==idtr[9]) ? 1 : 0;
}
int checkVmwareIO() { return 0; }
#else
// vmware runs only on the archs above
int checkVmware(const int) { return 0; }
int checkVmwareIO() { return 0; }
#endif

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
        return 1;
    }
    DWRITE("true\n");

    // never returns if not running under vmware
    void dummy() { DWRITE("false\n"); exit(1); }
    signal(SIGSEGV, dummy);
    DWRITE("ioport-check: ");
    b = checkVmwareIO();
    if(b) {
        DWRITE("true\n");
        return 0;
    }
    // never reached
    return 1;
}
// vim: foldmethod=marker
