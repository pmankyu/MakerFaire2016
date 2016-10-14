void candle_setup()
{
  candle = new Candle[rows][cols];
  candle_data = new Candle_data[rows][cols];
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Initialize each object
      candle[i][j] = new Candle(candle_X_pos[i][j],candle_Y_pos[i][j],100,100,0,0,0);
      candle_data[i][j] = new Candle_data();
    }
  }
}

int calc_distance(int start_x, int start_y, int end_x, int end_y)
{
  int result = 0;
  
  result = (abs(candle_X_pos[start_x][start_y] - candle_X_pos[end_x][end_y]) + abs(candle_Y_pos[start_x][start_y] - candle_Y_pos[end_x][end_y]))/150;
  
  //println("start_x : " + start_x +", start_y : " + start_y +", end_x : " + end_x +", end_y : " + end_y);
  //println("start_x : " + candle_X_pos[start_x][start_y] +", start_y : " + candle_Y_pos[start_x][start_y] +", end_x : " + candle_X_pos[end_x][end_y] +", end_y : " + candle_Y_pos[end_x][end_y]);
  //println("result : " + result);
  
  //while(result != 0){};
  
  return result;
}

// 1 턴마다 변화할 촛불색
int calc_color_value(int target, int now)
{
  int result = 0;

  result = (target - now)/5;

  if(result == 0)
  {
    if(target > now) result = 1;
    else if(target < now) result = -1;
  }
  
  return result;
}

void print_candle_now()
{
  println("Now-------------------------------------------------------");
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      print("(" + candle_data[i][j].R_color_now + ", " + candle_data[i][j].G_color_now + ", " + candle_data[i][j].B_color_now+ "), ");
    }
    println(" ");
  }
}

void print_candle_change()
{
  println("Change------------------------------------------------------");
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      print("(" + candle_data[i][j].R_color_change + ", " + candle_data[i][j].G_color_change + ", " + candle_data[i][j].B_color_change+ "), ");
    }
    println(" ");
  }
}

void print_candle_target()
{
  println("Target--------------------------------------------------------");
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      print("(" + candle_data[i][j].R_color_target + ", " + candle_data[i][j].G_color_target + ", " + candle_data[i][j].B_color_target+ "), ");
    }
    println(" ");
  }
}

int calc_color(int near_color, int color_value)
{
  int result=0;
  
  if(color_value > near_color) result = color_value - ceil((color_value - near_color)/30);
  else if(color_value < near_color) result = color_value + round((near_color - color_value)/3);
  else result = color_value;
  
  return result;
}

void check_lighter(int x,int y){
  if( (lighterX < x) && ((lighterX + lighterSize) > x)) {
    if( (R_lighterY < y) && ((R_lighterY + lighterSize/2) > y)) {
      println("RED");
      lighter = 1;
    }
    else if( (G_lighterY < y) && ((G_lighterY + lighterSize/2) > y)) {
      println("GREEN");
      lighter = 2;
    }
    else if( (B_lighterY < y) && ((B_lighterY + lighterSize/2) > y)) {
      println("BLUE");
      lighter = 3;
    }
    else if( (OFF_lighterY < y) && ((OFF_lighterY + lighterSize/2) > y)) {
      println("OFF");
      lighter = 4;
    }
    else if( (RESET_lighterY < y) && ((RESET_lighterY + lighterSize/2) > y)) {
      println("CHANGE");
      lighter = 5;
    }
  }
}


// update target

void update_R_target(int i, int j, int change_value)
{
  int change_result = 0;
  
  if(change_value!=0)
  {
    for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
        change_result = change_value - ceil(    (change_value * calc_distance(i,j,ii,jj))/6     );
        //print("(" + change_value+ "), ");
        //print("(" + calc_distance(i,j,ii,jj)+ "), ");
        candle_data[ii][jj].R_color_target = candle_data[ii][jj].R_color_now + change_result;
            
        if(candle_data[ii][jj].R_color_target > 255) candle_data[ii][jj].R_color_target = 255;
        else if(candle_data[ii][jj].R_color_target < 0) candle_data[ii][jj].R_color_target = 0;
      }
      //println(" ");
    }
  }
}

void update_G_target(int i, int j, int change_value)
{
  int change_result = 0;
  
  if(change_value!=0)
  {
    for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
        change_result = change_value - ceil(    (change_value * calc_distance(i,j,ii,jj))/6     );
        //print("(" + change_value+ "), ");
        //print("(" + calc_distance(i,j,ii,jj)+ "), ");
        candle_data[ii][jj].G_color_target = candle_data[ii][jj].G_color_now + change_result;
            
        if(candle_data[ii][jj].G_color_target > 255) candle_data[ii][jj].G_color_target = 255;
        else if(candle_data[ii][jj].G_color_target < 0) candle_data[ii][jj].G_color_target = 0;
      }
      //println(" ");
    }
  }
}

void update_B_target(int i, int j, int change_value)
{
  int change_result = 0;
  
  if(change_value!=0)
  {
    for (int ii = 0; ii < rows; ii++) {
          for (int jj = 0; jj < cols; jj++) {
        change_result = change_value - ceil(    (change_value * calc_distance(i,j,ii,jj))/6     );
        //print("(" + change_value+ "), ");
        //print("(" + calc_distance(i,j,ii,jj)+ "), ");
        candle_data[ii][jj].B_color_target = candle_data[ii][jj].B_color_now + change_result;
            
        if(candle_data[ii][jj].B_color_target > 255) candle_data[ii][jj].B_color_target = 255;
        else if(candle_data[ii][jj].B_color_target < 0) candle_data[ii][jj].B_color_target = 0;
      }
      //println(" ");
    }
  }
}


/*
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
      }*/
      
      
      
      