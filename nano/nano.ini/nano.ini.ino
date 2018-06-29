#define DEBUG

enum fn {PW, AI, DO, DI, HELP};
#define MY_ID 01 //ID 01-99

void parse_do(int data[]) {
  int id1 = data[0];
      id1 -= '0';
  int id0 = data[1];
      id0 -= '0';
  id0 += id1 * 10; //(id0+10*id1) converção char para 0 -> 99
  
  int fun = data[2];
      fun -= '0';
  
  int pin1 = data[3];
      pin1 -= '0'; 
  int pin0 = data[4];
      pin0 -= '0';
  pin0 += pin1 * 10; //converção char para inteiro 0 -> 99

#ifdef DEBUG
  Serial.print("id:");
  Serial.print(id0);
  Serial.print("pin:");
  Serial.print(pin0);
  Serial.print("_");
#endif

  if (id0 == MY_ID) switch (fun) {
      case HELP:
      {
        Serial.print("HELP\t");
        }
      break;  
      case PW:
      case DO:
      {
        if (pin0 < 0 || pin0 > 99) {
          Serial.print("ERRO_PW+DO_PIN\t");
          id0 = 0; //não entrar no switch, pois deu erro
        }
        int val2 = data[5];
        val2 -= '0';
        int val1 = data[6];
        val1 -= '0';
        int val0 = data[7];
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
            break;
        }
        Serial.print("ACK");
        }
        break;
      case AI:
      case DI:
        {
        if (pin0 < 0 || pin0 > 99) {
          Serial.print("ERRO_PW+DO_PIN\t");
          id0 = 0; //não entrar no switch, pois deu erro
        }
        Serial.print("AC1\t");
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
        Serial.print(value);
        Serial.print("ACK\t");
        break;
        }
      default:
      {
        Serial.print("ERRO_FN\t");
      }
      break;  
    }
}

int indice;
int last_received;
int dados[10];
enum estados {SEM_INICIO,RECEBENDO} meu_estado;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  if(Serial.available()){
    last_received = Serial.read();
    switch(meu_estado){
      case SEM_INICIO:
        indice=0;
        if('&' == last_received) meu_estado = RECEBENDO;
      break;
      case RECEBENDO:
        dados[indice++]=last_received;
        if('\n' == last_received){
          meu_estado = SEM_INICIO;
          parse_do(dados);
          
          #ifdef DEBUG
          Serial.print("__");
          for(int j=0;j<10;j++) Serial.print((char)dados[j]);
          Serial.println("__");
          #endif
        }
        if(indice>10){
          meu_estado = SEM_INICIO;
          indice=0;
          Serial.print("ERRO_TOO_LONG\t");
          }
      break;
      }
    }
}
