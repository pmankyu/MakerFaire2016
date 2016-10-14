void arduino_setup()
{
  println("Arduino List");
  printArray(Arduino.list());
  
  arduino = new Arduino(this, Arduino.list()[0], 57600);
}