#include <Thermistor.h>
#include "DHT.h"

#define templed1 A0
#define templed2 A1
#define templed3 A2
#define templed4 A3
#define umidsolo1 A6
#define umidsolo2 A7
#define led1 D2
#define led2 D3
#define led3 D4
#define led4 D5
//#define reserv.vazio D6
//#define reserv.cheio D7
#define bomba1 D8
#define bomba2 D9
#define bomba3 D10
#define bomba4 D11
#define cooler D12
#define ambiente 13 


#define DHTTYPE DHT11
DHT dht(ambiente, DHTTYPE);

Thermistor temp1(templed1);
Thermistor temp2(templed2);
Thermistor temp3(templed3);
Thermistor temp4(templed4);

    
    //função para ler entradas digitais
    int lerd(byte pinod){
    int sval2 =  digitalRead(pinod); 
    return sval2;   
    }


    //função para ler entradas analogicas
    int lera(byte pinoa){
    int sval1 =  analogRead(pinoa); 
    return sval1;   
    }


    //função para ler umidade do sensor DHT11
    float leruamb(byte pinoh){
    float umid = dht.readHumidity();
    return umid;   
    }


    //função para ler temperatura do sensor DHT11
    float lertamb(byte pinox){
    float temp = dht.readTemperature(); 
    return temp;   
    }


    

    






void setup(){
  Serial.begin(9600);
  dht.begin();
}


void loop() {

    delay(300);
  
    int usolo1 = lera(umidsolo1);
    int usolo2 = lera(umidsolo2);
    float u = leruamb(ambiente);
    float t = lertamb(ambiente);
    int temperatura1 = temp1.getTemp();
    int temperatura2 = temp2.getTemp();
    int temperatura3 = temp3.getTemp();
    int temperatura4 = temp4.getTemp();
  


    
    Serial.print("Umidade: ");
    Serial.print(u);
    Serial.print("%\t");
    Serial.print("   Temperatura: ");
    Serial.print(t);
    Serial.print("*C");
    Serial.print("    Umidade vaso 1: ");
    Serial.print(usolo1);
    Serial.print("    Umidade vaso 2: ");
    Serial.print(usolo2);
    Serial.print("   Temperatura no Sensor: ");
    Serial.print(temperatura1);
    Serial.print("*C");
    Serial.print("\n");
  
    
}

