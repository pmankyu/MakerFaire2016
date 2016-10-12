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

int serial_data[100] = {0,};
int serial_data_index = 0;

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

String inputString = "";         // a string to hold incoming data
int stringComplete = 0;  // whether the string is complete

int r_value = 0;
int g_value = 0;
int b_value = 0;
int zero_value = 0;

int candle_id = 0;

int main_id = 0;
int main_mode = 0;
int main_r = 0;
int main_g = 0;
int main_b = 0;
bool is_main_data_end = false;

int test_cnt = 0;

int random_id = 0;
int random_color = 0;
int random_value = 0;

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

  //Serial.println("CANDLE main start!!!");
}

void loop() {

  if(is_main_data_end)
  {
    switch(main_mode)
    {
      //in
      case 1:
                
      break;

      //out
      case 2:
        if(main_id == 0)
        {
          test_cnt++;
          
          if(test_cnt == 7)
          {
            random_id = random(30);
            random_color = random(3);
            random_value = random(50,100);
          }
        }

        if(main_id == random_id)
        {
          if(test_cnt == 8)
          {
            if(random_color == 0)
            {
              r_value += random_value;
            }
            else if(random_color == 1)
            {
              g_value += random_value;
            }
            else if(random_color == 2)
            {
              b_value += random_value;
            }
  
            if(r_value >= 255) r_value = 0;
            if(g_value >= 255) g_value = 0;
            if(b_value >= 255) b_value = 0;

            test_cnt = 0;
          }
        }

        Serial.write(0xFA);
        Serial.write(0x01);//Serial3.print('r');
        Serial.write(r_value);//Serial3.print(r_value);
        Serial.write(0x01);//Serial3.print('g');
        Serial.write(g_value);//Serial3.print(g_value);
        Serial.write(0x01);//Serial3.print('b');
        Serial.write(b_value);//Serial3.print(b_value);
        Serial.write(0x0D);

        r_value = g_value = b_value = 0;
  
        is_main_data_end = false;
      break;

      default:
      break;
    }
  }
    
}

void serialEvent() {
  while (Serial.available()) {
    int read_data = Serial.read();
  
    serial_data[serial_data_index] = read_data;
    serial_data_index++;
    
    serial_process();
  }
}
/*
 * 0xFA : Start
 * 0x?? : ID
 * 0x?? : in(1),out(2)
 * 0x?? : R color
 * 0x?? : G color
 * 0x?? : B color
 * 0x0D : END
 */

void serial_process()
{
  int R_value;
  int G_value;
  int B_value;
  //시리얼 데이터 버퍼를 스캔
  for(int i=0;i<serial_data_index;i++)
  {
    // 시작 바이트를 발견하면
    if(serial_data[i] == 0xFA)
    {
      //채워져 있는 양이  candle 데이터보다 많으면
      if((serial_data_index - i) >= 7)
      {
        // 마지막 데이터를 확인한다.
        if(serial_data[i+6]==0x0D)
        {
          //맞으면 데이터가 제대로 들어온 것이다.
          main_id = serial_data[i+1];
          main_mode = serial_data[i+2];
          main_r = serial_data[i+3];
          main_g = serial_data[i+4];
          main_b = serial_data[i+5];
          
          is_main_data_end = true;
          
          //println("serial data >> R : " + R_value + ",G : " + G_value +  ",B : " + B_value +  ",i : " + i+  ",index : " + serial_data_index);
          
          // index를 초기화 한다.
          serial_data_index = 0;
          break;
        }
      }
      else
      {
      }
    }
  }
}


/*
 * if (stringComplete==1) {
    //Serial.println(stringComplete);
    // clear the string:
    digitalWrite(led_pin, HIGH);
    inputString = "";
    stringComplete = false;
    Serial.write(0xFA);
    Serial.write(0x01);//Serial3.print('r');
    Serial.write(r_value);//Serial3.print(r_value);
    Serial.write(0x02);//Serial3.print('g');
    Serial.write(g_value);//Serial3.print(g_value);
    Serial.write(0x01);//Serial3.print('b');
    Serial.write(b_value);//Serial3.print(b_value);
    Serial.write(0x0D);
  }
  else if (stringComplete==2) {
    //Serial.println(stringComplete);
    // clear the string:
    digitalWrite(led_pin, LOW);
    inputString = "";
    stringComplete = false;
    Serial.write(0xFA);
    Serial.write(0x01);//Serial3.print('r');
    Serial.write(zero_value);//Serial3.print(r_value);
    Serial.write(0x02);//Serial3.print('g');
    Serial.write(zero_value);//Serial3.print(g_value);
    Serial.write(0x01);//Serial3.print('b');
    Serial.write(zero_value);//Serial3.print(b_value);
    Serial.write(0x0D);
  }
 * 
 * 
 * 
 * 
 * // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '-') {
      
      //stringComplete = true;
      if (inputString.equals("candle-"))
      {
        //Serial.println("candle-");
        stringComplete = 1;
      }
      else if (inputString.equals("end-"))
      {
        //Serial.println("end-");
        stringComplete = 2;
      }
      else inputString = "";
    }
 * 
*/


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

