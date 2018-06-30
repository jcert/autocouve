#include <Thermistor.h>
float i,t1, t2, t3,t4,t5;
int t11, t22, t33,t44,t55;
Thermistor temp1(1);
Thermistor temp2(2);
Thermistor temp3(3);
Thermistor temp4(4);
Thermistor temp5(5);

void setup() {
  Serial.begin(9600);
  //Serial.println("comecar");
}

void loop() {
  
  for(i = 1;i<=1;i++){
  t1 = temp1.getTemp()+t1;
  t2 = temp2.getTemp()+t2;
  t3 = temp3.getTemp()+t3;
  t4 = temp4.getTemp()+t4;
  t5 = temp5.getTemp()+t5;
  }
  t1 = t1/1500;
  t2 = t2/1500;
  t3 = t3/1500;
  t4 = t4/1500;
  t5 = t5/1500;

  t11 = temp1.getTemp();
  t22 = temp2.getTemp();
  t33 = temp3.getTemp();
  t44 = temp4.getTemp();
  t55 = temp5.getTemp();
  
  
  //Serial.print("Temperatura nos Sensores: ");
  Serial.print(t11);
  Serial.print("; ");
  Serial.print(t22);
  Serial.print("; ");
  Serial.print(t33);
  Serial.print("; ");
  Serial.print(t44);
  Serial.print("; ");
  Serial.print(t55);
  Serial.println("; ");
  delay(500);
}
