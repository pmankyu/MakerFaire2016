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

int calc_color_value(int target, int now)
{
  int result = 0;

  result = (target - now)/10;

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