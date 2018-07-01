//#define DEBUG

#include <Wire.h>
enum fn {NONE, PW, AI, DO, DI, READ, HELP};
#define MY_ID 8 //

char out_buffer[32];
uint8_t used_size;

void parse_do(char data[]) {
  int fun = data[0];
      fun -= '0';
  
  int pin1 = data[1];
      pin1 -= '0'; 
  int pin0 = data[2];
      pin0 -= '0';
  pin0 += pin1 * 10; //converção char para inteiro 0 -> 99

#ifdef DEBUG
  Serial.print("pin:");
  Serial.print(pin0);
  Serial.print("_");
#endif

switch (fun) {
      case HELP:
      {
        Serial.print("HELP\t");
        }
      break;
      case READ:
      {
        int someInt;
        switch(data[1])
        {
        case 'A':
          someInt = analogRead(pin0);
        break;
        case 'C':
          Serial.println("READ C nao implementado");
        break;
        case '0':
        case '1':
          someInt = digitalRead(pin0);
        break;  
          }
        char aux[12];
        sprintf(aux, "%d", someInt);
        write_buffer(aux);
      }
      break;  
      case PW:
      case DO:
      {
        if (pin0 < 0 || pin0 > 99) {
          Serial.print("ERRO_PW+DO_PIN\t");//não entrar no switch, pois deu erro
        }
        int val2 = data[3];
        val2 -= '0';
        int val1 = data[4];
        val1 -= '0';
        int val0 = data[5];
        val0 -= '0';
        val1 += val2 * 10;
        val0 += val1 * 10; //converção char para inteiro 0 -> 999

        if (val0 < 0 || val0 > 999) {
          Serial.print("ERRO_PW+DO_VAL\t");
          break;
        }
        switch (fun) {
          case PW:
            analogWrite(pin0,val0);
            break;
          case DO:
            pinMode(pin0,OUTPUT);
            digitalWrite(pin0,val0);
            Serial.print("digital write");
            Serial.print(pin0);
            Serial.print("(");
            Serial.print(val0);
            Serial.print(")");
            break;
        }
        write_buffer("ACK");
        }
        break;
      case AI:
      case DI:
        {
        if (pin0 < 0 || pin0 > 99) {
          Serial.print("ERRO_PW+DO_PIN\t");//não entrar no switch, pois deu erro
        }
        int value;
        switch (fun) {
          case AI:
            value = analogRead(pin0);
            break;
          case DI:
            pinMode(pin0,INPUT);
            value = digitalRead(pin0);
            break;
        }
        char aux[12];
        sprintf(aux, "%d", value);
        write_buffer(aux);
        Serial.print(value);
        break;
        }
      default:
      {
        Serial.print("ERRO_FN\t");
      }
      break;  
    }
}

uint8_t write_buffer(char *x){
  used_size=strlen(x);//variavel global do buffer global de escrita
  memcpy(out_buffer,x,used_size);
  out_buffer[used_size]='\0';
  return used_size;
  }

int indice;
char last_received;
char dados[10];
enum estados {SEM_INICIO,RECEBENDO} meu_estado;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Wire.begin(MY_ID);                // join i2c bus with address MY_ID
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(requestEvent); // register event
}

void requestEvent(){
Wire.write(out_buffer);  
  }

void receiveEvent(int howMany) {
  Serial.println();
  memset(out_buffer,0,sizeof(out_buffer));
  while (0 < Wire.available()) { // loop through all but the last
    last_received = Wire.read();
    switch(meu_estado){
      case SEM_INICIO:
        indice=0;
        Serial.print("0");
        if('&' == last_received) meu_estado = RECEBENDO;
      break;
      case RECEBENDO:
        dados[indice++]=last_received;
        Serial.print("R");
        if('!' == last_received){
          meu_estado = SEM_INICIO;
          Serial.print("_dados_");
          Serial.print(dados);
          Serial.print("\t:\t");
          parse_do(dados);
          
          #ifdef DEBUG
          Serial.print("_");
          for(int j=0;j<10;j++) Serial.print((char)dados[j]);
          Serial.print("_");
          #endif
        }
        if(indice>10){
          meu_estado = SEM_INICIO;
          indice=0;
          Serial.print("ERRO_TOO_LONG\t");
          }
      break;
      }
    };         // print the integer
}



void loop() {
    
}
