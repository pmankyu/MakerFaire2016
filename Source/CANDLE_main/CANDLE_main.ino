// constants won't change. Used here to set a pin number :
const int led_pin =  13;      // the number of the LED pin

/*
 * a0 a1 a2 
 * 000 : out 0
 * 001 : out 1
 * 010 : out 2
 * 011 : out 3
 * 100 : out 4
 * 101 : out 5
 * 110 : out 6
 * 111 : out 7
 */

const int a0_pin =  2;
const int a1_pin =  3;
const int a2_pin =  4;

const int e1_pin =  5;
const int e2_pin =  6;
const int e3_pin =  7;
const int e4_pin =  8;

int candle_index = 1;

void select_candle(int num);
void select_mux(int num);
void select_port(int num);

void setup() {
  // put your setup code here, to run once:
  pinMode(led_pin, OUTPUT);
  
  pinMode(a0_pin, OUTPUT);
  pinMode(a1_pin, OUTPUT);
  pinMode(a2_pin, OUTPUT);
  
  pinMode(e1_pin, OUTPUT);
  pinMode(e2_pin, OUTPUT);
  pinMode(e3_pin, OUTPUT);
  pinMode(e4_pin, OUTPUT);
  
  Serial.begin(115200); // 디버그용 시리얼 포트
  Serial3.begin(115200); // 촛불들과 연결될 시리얼 포트

  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("CANDLE main start!!!");
  

}

void loop() {
  /*
  select_candle(candle_index);
  candle_index++;
  if(candle_index == 33) candle_index = 1;
  //select_mux(1);select_port(1);
  
  Serial.print('r');Serial3.print('r');
  digitalWrite(led_pin, HIGH);
  delay(100);
  Serial.print('g');Serial3.print('g');
  digitalWrite(led_pin, LOW);
  delay(100);
  Serial.print('b');Serial3.print('b');
  digitalWrite(led_pin, HIGH);
  delay(100);
  Serial.print('a');Serial3.print('a');
  digitalWrite(led_pin, LOW);
  delay(100);
  */
  // 주기적으로 실행되도록 time 관련 함수

  // 현재 초의 정보를 읽어온다.
  // MUX를 이용해서 초를 선택
  // 현재 초의 색깔
  // 초의 정보 (현재 색깔, 변화값(불 켜짐, 꺼짐)을 읽어온다.)
  // 초에 Response를 보내서 변화값을 초기화 한다.

  // 변화값을 기준으로 전체 초의 변화값을 계산한다.

  
}

void select_candle(int num)
{
  switch(num)
  {
    case 1:  select_mux(1);select_port(1);break;
    case 2:  select_mux(1);select_port(2);break;
    case 3:  select_mux(1);select_port(3);break;
    case 4:  select_mux(1);select_port(4);break;
    case 5:  select_mux(1);select_port(5);break;
    case 6:  select_mux(1);select_port(6);break;
    case 7:  select_mux(1);select_port(7);break;
    case 8:  select_mux(1);select_port(8);break;
    case 9:  select_mux(2);select_port(1);break;
    case 10: select_mux(2);select_port(2);break;
    case 11: select_mux(2);select_port(3);break;
    case 12: select_mux(2);select_port(4);break;
    case 13: select_mux(2);select_port(5);break;
    case 14: select_mux(2);select_port(6);break;
    case 15: select_mux(2);select_port(7);break;
    case 16: select_mux(2);select_port(8);break;
    case 17: select_mux(3);select_port(1);break;
    case 18: select_mux(3);select_port(2);break;
    case 19: select_mux(3);select_port(3);break;
    case 20: select_mux(3);select_port(4);break;
    case 21: select_mux(3);select_port(5);break;
    case 22: select_mux(3);select_port(6);break;
    case 23: select_mux(3);select_port(7);break;
    case 24: select_mux(3);select_port(8);break;
    case 25: select_mux(4);select_port(1);break;
    case 26: select_mux(4);select_port(2);break;
    case 27: select_mux(4);select_port(3);break;
    case 28: select_mux(4);select_port(4);break;
    case 29: select_mux(4);select_port(5);break;
    case 30: select_mux(4);select_port(6);break;
    case 31: select_mux(4);select_port(7);break;
    case 32: select_mux(4);select_port(8);break;
  }
}

void select_mux(int num)
{
  digitalWrite(e1_pin, LOW);
  digitalWrite(e2_pin, LOW);
  digitalWrite(e3_pin, LOW);
  digitalWrite(e4_pin, LOW);

  switch(num)
  {
    case 1:digitalWrite(e1_pin, HIGH);break;
    case 2:digitalWrite(e2_pin, HIGH);break;
    case 3:digitalWrite(e3_pin, HIGH);break;
    case 4:digitalWrite(e4_pin, HIGH);break;
    default:break;
  }
}

void select_port(int num)
{
  switch(num)
  {
    case 1:digitalWrite(a0_pin, LOW); digitalWrite(a1_pin, LOW); digitalWrite(a2_pin, LOW); break;
    case 2:digitalWrite(a0_pin, LOW); digitalWrite(a1_pin, LOW); digitalWrite(a2_pin, HIGH);break;
    case 3:digitalWrite(a0_pin, LOW); digitalWrite(a1_pin, HIGH);digitalWrite(a2_pin, LOW); break;
    case 4:digitalWrite(a0_pin, LOW); digitalWrite(a1_pin, HIGH);digitalWrite(a2_pin, HIGH);break;
    case 5:digitalWrite(a0_pin, HIGH);digitalWrite(a1_pin, LOW); digitalWrite(a2_pin, LOW); break;
    case 6:digitalWrite(a0_pin, HIGH);digitalWrite(a1_pin, LOW); digitalWrite(a2_pin, HIGH);break;
    case 7:digitalWrite(a0_pin, HIGH);digitalWrite(a1_pin, HIGH);digitalWrite(a2_pin, LOW); break;
    case 8:digitalWrite(a0_pin, HIGH);digitalWrite(a1_pin, HIGH);digitalWrite(a2_pin, HIGH);break;
    default:break;
  }
}

