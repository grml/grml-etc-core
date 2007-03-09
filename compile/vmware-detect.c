#if defined (__i386__)
int checkVmware()
{
    unsigned char idtr[6];
    asm("sidt %0" : "=m" (idtr));
    return (0xff==idtr[5]) ? 0 : 1;
}
#elif defined (__x86_64__)
// only guessed, possible need to check against 0xffff?
int checkVmware()
{
    unsigned char idtr[10];
    asm("sidt %0" : "=m" (idtr));
    return (0xff==idtr[9]) ? 0 : 1;
}
#else
// vmware runs only on the archs above
int checkVmware() { return 1; }
#endif

int main() {
    // returns 0 if running inside vmware, 1 otherwise
    return checkVmware();
}
// vim: foldmethod=marker
