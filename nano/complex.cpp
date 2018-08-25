#include <Thermistor.h>
#include "DHT.h"
#include "complex.h"
//
//#define templed1 A0
//#define templed2 A1
//#define templed3 A2
//#define templed4 A3
//#define umidsolo1 A6
//#define umidsolo2 A7
//#define reserv.vazio D6
//#define reserv.cheio D7
#define ambiente 13


#define DHTTYPE DHT11
DHT dht(ambiente, DHTTYPE);

Thermistor temp1(templed1);
Thermistor temp2(templed2);
Thermistor temp3(templed3);
Thermistor temp4(templed4);

void init_complex() {
  dht.begin();
}

//função para ler entradas digitais
int lerd(byte pinod) {
  int sval2 =  digitalRead(pinod);
  return sval2;
}


//função para ler entradas analogicas
int lera(byte pinoa) {
  int sval1 =  analogRead(pinoa);
  return sval1;
}


//função para ler umidade do sensor DHT11
float leruamb(byte pinoh) {
  float umid = dht.readHumidity();
  return umid;
}


//função para ler temperatura do sensor DHT11
float lertamb(byte pinox) {
  float temp = dht.readTemperature();
  return temp;
}


int usolo1() {
  return lera(umidsolo1);
}
int usolo2() {
  return lera(umidsolo2);
}
int u() { //era float
  return (int)(leruamb(ambiente));
}
int t() { //era float
  return (int)(lertamb(ambiente));
}
int temperatura1() {
  return temp1.getTemp();
}
int temperatura2() {
  return temp2.getTemp();
}
int temperatura3() {
  return temp3.getTemp();
}
int temperatura4() {
  return temp4.getTemp();
}


