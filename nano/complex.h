#ifndef COMPLEX_H
#define COMPLEX_H

#define templed1 A0
#define templed2 A1
#define templed3 A2
#define templed4 A3
#define umidsolo1 A6
#define umidsolo2 A7
//#define reserv.vazio D6
//#define reserv.cheio D7

float leruamb(byte pinoh);

int usolo1();
int usolo2();
int u();
int t();
int temperatura1();
int temperatura2();
int temperatura3();
int temperatura4();

static int (*fn_complexa[])() = {  
 usolo1,
 usolo2,
 u,
 t,
 temperatura1,
 temperatura2,
 temperatura3,
 temperatura4
};


#endif
