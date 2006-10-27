/*
 * By Patrick Reynolds <reynolds@cs.duke.edu>
 * Too trivial to copyright.  It's in the public domain!
 *
 * To build:
 *   gcc align.c -o align
 *
 * To run:
 *   ./align
 *
 * Note that optimizing compilers will almost certainly reorder the data
 * segment, throwing off the values you get for structure alignments.
 * Annoyingly, some compilers don't let you disable optimizations.
 * GCC by default (with optimizations off) doesn't reorder data segments.
 * So use GCC.
 */

#include <stdio.h>

typedef struct { char a; } s_char;
typedef struct { short a; } s_short;
typedef struct { int a; } s_int;
typedef struct { long a; } s_long;
typedef struct { long long a; } s_long_long;
typedef struct { float a; } s_float;
typedef struct { double a; } s_double;
typedef struct { int *a; } s_intp;

int main() {
  int i = 0x01020304;
  char *ch = (char*)&i;
  char c1;        char ch0;  char c2;
  double d1;      char ch1;  double d2;
  float f1;       char ch2;  float f2;
  short s1;       char ch3;  short s2;
  int i1;         char ch4;  int i2;
  long long ll1;  char ch5;  long long ll2;
  int *p1;        char ch6;  int *p2;
  long l1;        char ch7;  long l2;
  s_char sc1;     char ch8;  s_char sc2;
  s_short ss1;    char ch9;  s_short ss2;
  s_int si1;      char ch10; s_int si2;
  s_long sl1;     char ch11; s_long sl2;
  s_long_long sll1;char ch12;s_long_long sll2;
  s_float sf1;    char ch13; s_float sf2;
  s_double sd1;   char ch14; s_double sd2;
  s_intp sp1;     char ch15; s_intp sp2;

  if (ch[0] == 0x01)
    printf("Big endian (%d %d %d %d)\n",     ch[0], ch[1], ch[2], ch[3]);
  else if (ch[0] == 0x04)
    printf("Little endian (%d %d %d %d)\n",  ch[0], ch[1], ch[2], ch[3]);
  else
    printf("Unknown endian (%d %d %d %d)\n", ch[0], ch[1], ch[2], ch[3]);

  printf("sizes:\n");
  printf("  char:      %d\n", sizeof(char));
  printf("  short:     %d\n", sizeof(short));
  printf("  int:       %d\n", sizeof(int));
  printf("  long:      %d\n", sizeof(long));
  printf("  long long: %d\n", sizeof(long long));
  printf("  float:     %d\n", sizeof(float));
  printf("  double:    %d\n", sizeof(double));
  printf("  int*:      %d\n", sizeof(int*));
  printf("alignments:\n");
  printf("  char:      %d (%p %p %p)\n",
    (char*)&c1  - (char*)&c2  - sizeof(char),       &c1,  &ch0, &c2);
  printf("  short:     %d (%p %p %p)\n",
    (char*)&s1  - (char*)&s2  - sizeof(short),      &s1,  &ch3, &s2);
  printf("  int:       %d (%p %p %p)\n",
    (char*)&i1  - (char*)&i2  - sizeof(int),        &i1,  &ch4, &i2);
  printf("  long:      %d (%p %p %p)\n",
    (char*)&l1  - (char*)&l2  - sizeof(long),       &l1,  &ch7, &l2);
  printf("  long long: %d (%p %p %p)\n",
    (char*)&ll1 - (char*)&ll2 - sizeof(long long),  &ll1, &ch5, &ll2);
  printf("  float:     %d (%p %p %p)\n",
    (char*)&f1  - (char*)&f2  - sizeof(float),      &f1,  &ch2, &f2);
  printf("  double:    %d (%p %p %p)\n",
    (char*)&d1  - (char*)&d2  - sizeof(double),     &d1,  &ch1, &d2);
  printf("  int*:      %d (%p %p %p)\n",
    (char*)&p1  - (char*)&p2  - sizeof(int*),       &p1,  &ch6, &p2);
  printf("structure alignments:\n");
  printf("  char struct:      %d (%p %p %p)\n",
    (char*)&sc1  - (char*)&sc2  - sizeof(s_char),   &sc1,  &ch8, &sc2);
  printf(" short struct:      %d (%p %p %p)\n",
    (char*)&ss1  - (char*)&ss2  - sizeof(s_short),  &ss1,  &ch9, &ss2);
  printf("   int struct:      %d (%p %p %p)\n",
    (char*)&si1  - (char*)&si2  - sizeof(s_int),    &si1,  &ch10,&si2);
  printf("  long struct:      %d (%p %p %p)\n",
    (char*)&sl1  - (char*)&sl2  - sizeof(s_long),   &sl1,  &ch11,&sl2);
  printf(" llong struct:      %d (%p %p %p)\n",
    (char*)&sll1  - (char*)&sll2  - sizeof(s_long_long),&sll1,&ch12,&sll2);
  printf(" float struct:      %d (%p %p %p)\n",
    (char*)&sf1  - (char*)&sf2  - sizeof(s_float),  &sf1,  &ch13,&sf2);
  printf("double struct:      %d (%p %p %p)\n",
    (char*)&sd1  - (char*)&sd2  - sizeof(s_double), &sd1,  &ch14,&sd2);
  printf("  int* struct:      %d (%p %p %p)\n",
    (char*)&sp1  - (char*)&sp2  - sizeof(s_intp),   &sp1,  &ch15,&sp2);

  return 0;
}
