import processing.serial.*;
import processing.sound.*;

Serial candle_port;  // Create object from Serial class

SoundFile fire_on_sound;
SoundFile fire_off_sound;

void setup() {
  size(1100,600);
  background(0);
  
  fire_on_sound = new SoundFile(this, "fire_on.wav");
  fire_off_sound = new SoundFile(this, "fire_off.wav");
  
  
  printArray(PFont.list());
  f = createFont("consola.ttf", 15);
  textFont(f);
  
  printArray(Serial.list());
  
  String portName = Serial.list()[1];
  candle_port = new Serial(this, portName, 115200);

  candle = new Candle[rows][cols];
  candle_data = new Candle_data[rows][cols];
  
  for(int i=0;i<100;i++)
  {
    serial_data[i] = 0;
  }
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Initialize each object
      candle[i][j] = new Candle(candle_X_pos[i][j],candle_Y_pos[i][j],100,100,0,0,0);
      candle_data[i][j] = new Candle_data();
    }
  }
  
  stroke(255);
  fill(255,0,0);
  rect(lighterX,R_lighterY,lighterSize,lighterSize/2);
  
  stroke(255);
  fill(0,255,0);
  rect(lighterX,G_lighterY,lighterSize,lighterSize/2);
  
  stroke(255);
  fill(0,0,255);
  rect(lighterX,B_lighterY,lighterSize,lighterSize/2);
  
  stroke(255);
  fill(255,255,255);
  rect(lighterX,OFF_lighterY,lighterSize,lighterSize/2);
  
  stroke(255);
  fill(0,0,0);
  rect(lighterX,RESET_lighterY,lighterSize,lighterSize/2);
  
  
}

void draw() {
  //int now_time = millis();
  //background(0);
  //fill(200);
  //text(now_time, 50, 20);
  
  //while(true)
  //{
  //  if((millis() - now_time) > 1) break;
  //}
  
  // 현재 촛불의 R,G,B 값을 읽고 R,G,B 의 변화값을 받아온다.
  // 시리얼로 값을 읽어오는데 현재값을 읽을 필요는 없을것같음
  // 변화값만 읽어오도록 한다.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      candle_data[i][j].R_color_now = candle[i][j].Get_R_now();
      candle_data[i][j].G_color_now = candle[i][j].Get_G_now();
      candle_data[i][j].B_color_now = candle[i][j].Get_B_now();
      
      candle_data[i][j].R_color_change = candle[i][j].Get_R_change();
      candle_data[i][j].G_color_change = candle[i][j].Get_G_change();
      candle_data[i][j].B_color_change = candle[i][j].Get_B_change();
      
      
      candle[i][j].display();
      
      fill(210);
      text(candle_data[i][j].R_color_now,candle_X_pos[i][j]-30, candle_Y_pos[i][j]-15);
      text(candle_data[i][j].G_color_now,candle_X_pos[i][j]-30, candle_Y_pos[i][j]);
      text(candle_data[i][j].B_color_now,candle_X_pos[i][j]-30, candle_Y_pos[i][j]+15);
    }
  }
  /*
  print("start time : " + millis());
  
  // 아두이노와 통신을 통해서 데이터를 읽어온다.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      candle_id = i*6+j;
      candle_mode = 2;
      //is_candle_data_end = true;
      while(true)
      {
        candle_port.write(0xFA);
        candle_port.write(candle_id);
        candle_port.write(candle_mode);
        candle_port.write(0);
        candle_port.write(1);
        candle_port.write(2);
        candle_port.write(0x0D);
        
        if(is_candle_data_end==true)  break;
      }
      
      candle_data[i][j].R_color_change = candle_r;
      candle_data[i][j].G_color_change = candle_g;
      candle_data[i][j].B_color_change = candle_b;
      
      //fill(210);
      //text(candle_r,candle_X_pos[i][j]+10, candle_Y_pos[i][j]-15);
      //text(candle_g,candle_X_pos[i][j]+10, candle_Y_pos[i][j]);
      //text(candle_b,candle_X_pos[i][j]+10, candle_Y_pos[i][j]+15);
      
      is_candle_data_end = false;
    }
  }
  println("~ end time : " + millis());
  */
  
  // 변화값을 기준으로 전체 초의 변화값을 계산한다.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      
      
      // 변화값이 존재하는지 확인
      if(candle_data[i][j].R_color_change != 0)
      {
        //print_candle_now();
        //print_candle_change();
        int change_value = 0;
        //println("R-----------------------------------------------------------");
        for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
            change_value = candle_data[i][j].R_color_change - ceil(    (candle_data[i][j].R_color_change * calc_distance(i,j,ii,jj))/6     );
            //print("(" + change_value+ "), ");
            //print("(" + calc_distance(i,j,ii,jj)+ "), ");
            candle_data[ii][jj].R_color_target = candle_data[ii][jj].R_color_now + change_value;
            
            if(candle_data[ii][jj].R_color_target > 255) candle_data[ii][jj].R_color_target = 255;
            else if(candle_data[ii][jj].R_color_target < 0) candle_data[ii][jj].R_color_target = 0;
          }
          println(" ");
        }
        //print_candle_target();
      }
      
      if(candle_data[i][j].G_color_change != 0)
      {
        //print_candle_now();
        //print_candle_change();
        int change_value = 0;
        //println("G-----------------------------------------------------------");
        for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
            change_value = candle_data[i][j].G_color_change - ceil(    (candle_data[i][j].G_color_change * calc_distance(i,j,ii,jj))/6     );
            //print("(" + change_value+ "), ");
            candle_data[ii][jj].G_color_target = candle_data[ii][jj].G_color_now + change_value;
            
            if(candle_data[ii][jj].G_color_target > 255) candle_data[ii][jj].G_color_target = 255;
            else if(candle_data[ii][jj].G_color_target < 0) candle_data[ii][jj].G_color_target = 0;
          }
          //println(" ");
        }
        //print_candle_target();
      }
      
      if(candle_data[i][j].B_color_change != 0)
      {
        //print_candle_now();
        //print_candle_change();
        int change_value = 0;
        //println("B-----------------------------------------------------------");
        for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
            change_value = candle_data[i][j].B_color_change - ceil(    (candle_data[i][j].B_color_change * calc_distance(i,j,ii,jj))/6     );
            //print("(" + change_value+ "), ");
            candle_data[ii][jj].B_color_target = candle_data[ii][jj].B_color_now + change_value;
            
            if(candle_data[ii][jj].B_color_target > 255) candle_data[ii][jj].B_color_target = 255;
            else if(candle_data[ii][jj].B_color_target < 0) candle_data[ii][jj].B_color_target = 0;
          }
          //println(" ");
        }
        //print_candle_target();
      }
      
      fill(210);
      text(candle_data[i][j].R_color_target,candle_X_pos[i][j]+10, candle_Y_pos[i][j]-15);
      text(candle_data[i][j].G_color_target,candle_X_pos[i][j]+10, candle_Y_pos[i][j]);
      text(candle_data[i][j].B_color_target,candle_X_pos[i][j]+10, candle_Y_pos[i][j]+15);
      
    }
  }
  
  // 계산된 변화값과 현재값의 차이만큼 초의 값을 세팅한다.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      candle[i][j].Set_R(candle_data[i][j].R_color_now + calc_color_value(candle_data[i][j].R_color_target,candle_data[i][j].R_color_now));
      candle[i][j].Set_G(candle_data[i][j].G_color_now + calc_color_value(candle_data[i][j].G_color_target,candle_data[i][j].G_color_now));
      candle[i][j].Set_B(candle_data[i][j].B_color_now + calc_color_value(candle_data[i][j].B_color_target,candle_data[i][j].B_color_now));
    }
  }
  
  //print_candle_change();
  //print_candle_now();
  //print_candle_target(); //<>//
}