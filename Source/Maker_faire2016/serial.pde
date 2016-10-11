int serial_data[] = new int[100];
int serial_data_index = 0;

void serial_read()
{
  int data = candle_port.read();
  
  if(data != -1)
  {
    println(data);
  }
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
      if((serial_data_index - i) >= 8)
      {
        // 마지막 데이터를 확인한다.
        if(serial_data[i+7]==0x0D)
        {
          //맞으면 데이터가 제대로 들어온 것이다.
          if(serial_data[i+1]==2) R_value = -1 * serial_data[i+2];
          else R_value = serial_data[i+2];
          
          if(serial_data[i+3]==2) G_value = -1 * serial_data[i+4];
          else G_value = serial_data[i+4];
          
          if(serial_data[i+5]==2) B_value = -1 * serial_data[i+6];
          else B_value = serial_data[i+6];
          
          println("serial data >> R : " + R_value + ",G : " + G_value +  ",B : " + B_value +  ",i : " + i+  ",index : " + serial_data_index);
          
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