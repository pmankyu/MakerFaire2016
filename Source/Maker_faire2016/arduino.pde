int a0_pin =  2;
int a1_pin =  3;
int a2_pin =  4;

int e1_pin =  5;
int e2_pin =  6;
int e3_pin =  7;
int e4_pin =  8;

void arduino_setup()
{
  println("Arduino List");
  printArray(Arduino.list());
  
  arduino = new Arduino(this, Arduino.list()[0], 57600);
}