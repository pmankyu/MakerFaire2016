int serial_data[] = new int[100];
int serial_data_index = 0;

void serial_setup()
{
  println("Serial List");
  printArray(Serial.list());
  
  String portName = Serial.list()[2];
  candle_port = new Serial(this, portName, 115200);
  
  for(int i=0;i<100;i++)
  {
    serial_data[i] = 0;
  }
  
  println("Serial Setup END");
}

void serialEvent(Serial candle_port) 
{
  int read_data = candle_port.read();
  
  serial_data[serial_data_index] = read_data;
  serial_data_index++;
  
  serial_process();
}

void serial_process()
{
  //시리얼 데이터 버퍼를 스캔
  for(int i=0;i<serial_data_index;i++)
  {
    // 시작 바이트를 발견하면
    if(serial_data[i] == 0xFA)
    {
      //채워져 있는 양이  candle 데이터보다 많으면
      if((serial_data_index - i) >= 6)
      {
        // 마지막 데이터를 확인한다.
        if(serial_data[i+5]==0x0D)
        {
          //맞으면 데이터가 제대로 들어온 것이다.
          /*
          if(serial_data[i+1]==2) candle_r = -1 * serial_data[i+2];
          else candle_r = serial_data[i+2];
          
          if(serial_data[i+3]==2) candle_g = -1 * serial_data[i+4];
          else candle_g = serial_data[i+4];
          
          if(serial_data[i+5]==2) candle_b = -1 * serial_data[i+6];
          else candle_b = serial_data[i+6];
          */
          
          candle_mic = serial_data[i+1];
          candle_r = serial_data[i+2];
          candle_g = serial_data[i+3];
          candle_b = serial_data[i+4];
          
          println("serial data >> R : " + candle_r + ",G : " + candle_g +  ",B : " + candle_b +  ",MIC : " + candle_mic+  ",index : " + serial_data_index);
          
          is_candle_data_end = true;
          
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