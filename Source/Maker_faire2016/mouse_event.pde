void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  mouse_time = millis();
  check_lighter(mouseX,mouseY);
  
  //select change candle to candle
  if(lighter == 5){
    //int tempR,tempG,tempB;
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if( ((candle[i][j].x - candle[i][j].w/2) < x) && ((candle[i][j].x + candle[i][j].w/2) > x))
        {
          if( ((candle[i][j].y - candle[i][j].h/2) < y) && ((candle[i][j].y + candle[i][j].h/2) > y))
          {
            if( (Seleted_candle_i == -1)&&(Seleted_candle_j == -1))
            {
              Seleted_candle_i = i;
              Seleted_candle_j = j;
            }
            else
            {
              /*
              print("Change Candle: " + Seleted_candle_i + "," + Seleted_candle_j + " --> Change Candle: " + i + "," + j);
              tempR = grid[i][j].Get_R();
              tempG = grid[i][j].Get_G();
              tempB = grid[i][j].Get_B();
              
              grid[i][j].Set_R(grid[Seleted_candle_i][Seleted_candle_j].Get_R());
              grid[i][j].Set_G(grid[Seleted_candle_i][Seleted_candle_j].Get_G());
              grid[i][j].Set_B(grid[Seleted_candle_i][Seleted_candle_j].Get_B());
              
              grid[Seleted_candle_i][Seleted_candle_j].Set_R(tempR);
              grid[Seleted_candle_i][Seleted_candle_j].Set_G(tempG);
              grid[Seleted_candle_i][Seleted_candle_j].Set_B(tempB);
              
              Seleted_candle_i = -1;
              Seleted_candle_j = -1;
              */
            }
          }
        }
      }
    }
  }
}

void mouseReleased() {
  int x = mouseX;
  int y = mouseY;
  int time = millis() - mouse_time;
  int plus_value = 50;//time/10;
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if( ((candle[i][j].x - candle[i][j].w/2) < x) && ((candle[i][j].x + candle[i][j].w/2) > x))
      {
        if( ((candle[i][j].y - candle[i][j].h/2) < y) && ((candle[i][j].y + candle[i][j].h/2) > y))
        {
          //print("Candle: " + i + "," + j);
          //println(", lighter : " +lighter +", mouse time(ms): " + time );
          
          if(lighter<4) fire_on_sound.play();
          else fire_off_sound.play();
          
          candle[i][j].change_color(lighter,plus_value);
          
          //if(grid[i][j].change_color(lighter,plus_value))  change_color_nearby(i,j,plus_value);
        }
      }
    }
  }
}