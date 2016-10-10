import processing.serial.*;

int candle_index = 1;

// 2D Array of objects
Candle[][] candle;
Candle_data[][] candle_data;

// Number of columns and rows in the grid
int cols = 6;
int rows = 5;

int mouse_time = 0;

int lighterX = 950;
int lighterSize = 100;
int R_lighterY = 100;
int G_lighterY = 200;
int B_lighterY = 300;
int OFF_lighterY = 400;
int RESET_lighterY = 500;

int lighter = 0;

int Seleted_candle_i = -1;
int Seleted_candle_j = -1;

//int[][] candle_R_now;
//int[][] candle_G_now;
//int[][] candle_B_now;

//int[][] candle_R_target;
//int[][] candle_G_target;
//int[][] candle_B_target;

int[][] candle_X_pos = {  {75,150,225,300,150,225},
                          {300,375,450,225,300,375},
                          {450,525,600,300,375,450},
                          {525,600,675,450,525,600},
                          {675,750,600,675,750,825} 
                        };
                        
int[][] candle_Y_pos = {  {300,225,150,75,375,300},
                          {225,150,75,450,375,300},
                          {225,150,75,525,450,375},
                          {300,225,150,525,450,375},
                          {300,225,525,450,375,300} };

int MAX_R_Value = 0;
int MAX_R_i=0;
int MAX_R_j=0;
int R_Value = 0;

int MAX_G_Value = 0;
int MAX_G_i=0;
int MAX_G_j=0;
int G_Value = 0;

int MAX_B_Value = 0;
int MAX_B_i=0;
int MAX_B_j=0;
int B_Value = 0;

int time_cnt = 0;

void setup() {
  size(1100,600);
  background(0);

  candle = new Candle[rows][cols];
  candle_data = new Candle_data[rows][cols];
  
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
  int now_time = millis();
  
  while(true)
  {
    if((millis() - now_time) > 30) break;
  }
  
  // 현재 촛불의 R,G,B 값을 읽고 R,G,B 의 변화값을 받아온다.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      candle_data[i][j].R_color_now = candle[i][j].Get_R_now();
      candle_data[i][j].G_color_now = candle[i][j].Get_G_now();
      candle_data[i][j].B_color_now = candle[i][j].Get_B_now();
      
      candle_data[i][j].R_color_change = candle[i][j].Get_R_change();
      candle_data[i][j].G_color_change = candle[i][j].Get_G_change();
      candle_data[i][j].B_color_change = candle[i][j].Get_B_change();
      
      candle[i][j].display();
    }
  }
  
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
  print_candle_now();
  //print_candle_target(); //<>//
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

int calc_color_value(int target, int now)
{
  int result = 0;

  result = (target - now)/30;

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
          
          candle[i][j].change_color(lighter,plus_value);
          
          //if(grid[i][j].change_color(lighter,plus_value))  change_color_nearby(i,j,plus_value);
        }
      }
    }
  }
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

class Candle_data {
  int R_color_now;
  int G_color_now;
  int B_color_now;
  
  int R_color_change;
  int G_color_change;
  int B_color_change;
  
  int R_color_target;
  int G_color_target;
  int B_color_target;
  
  int x_pos;
  int y_pos;
  
  Candle_data() {
    R_color_now = 0;
    G_color_now = 0;
    B_color_now = 0;
    
    R_color_change = 0;
    G_color_change = 0;
    B_color_change = 0;
    
    R_color_target = 0;
    G_color_target = 0;
    B_color_target = 0;
    x_pos = 0;
    y_pos = 0;
  } 
}

class Candle {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  int R_color_now;
  int G_color_now;
  int B_color_now;
  int R_color_change;
  int G_color_change;
  int B_color_change;

  // Cell Constructor
  Candle(float tempX, float tempY, float tempW, float tempH, int tempR, int tempG, int tempB) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    R_color_change = tempR;
    G_color_change = tempG;
    B_color_change = tempB;
    R_color_now = 0;
    G_color_now = 0;
    B_color_now = 0;
  } 
  
  boolean  change_color(int mode,int value){
    switch(mode){
      case 1:
        R_color_change += value;
        /*
        if(R_color_target <= 255) {
          R_color_target += value;
          if(R_color_target >= 255) R_color_target = 255;
          return true;
        }
        */
      break;
      
      case 2:
        G_color_change += value;
        /*
        if(G_color_target <= 255) {
          G_color_target += value;
          if(G_color_target >= 255) G_color_target = 255;
          return true;
        }
        */
      break;
      
      case 3:
        B_color_change += value;
        /*
        if(B_color_target <= 255) {
          B_color_target += value;
          if(B_color_target >= 255) B_color_target = 255;
          return true;
        }
        */
      break;
      
      case 4:
        R_color_change = -1 * R_color_now;
        G_color_change = -1 * G_color_now;
        B_color_change = -1 * B_color_now;
      break;
      
      default:
      break;
    }

    return false;
  }
  
  int Get_R_now(){return R_color_now;}
  void Set_R(int value)
  {
    if(value > 255) R_color_now = 255;
    else if(value < 0) R_color_now = 0;
    else R_color_now = value;
  }
  
  int Get_G_now(){return G_color_now;}
  void Set_G(int value)
  {
    if(value > 255) G_color_now = 255;
    else if(value < 0) G_color_now = 0;
    else G_color_now = value;
  }
  
  int Get_B_now(){return B_color_now;}
  void Set_B(int value)
  {
    if(value > 255) B_color_now = 255;
    else if(value < 0) B_color_now = 0;
    else B_color_now = value;
  }
  
  int Get_R_change()
  {
    int return_value = R_color_change;
    R_color_change = 0;
    return return_value;
  }
  
  int Get_G_change()
  {
    int return_value = G_color_change;
    G_color_change = 0;
    return return_value;
  }
  
  int Get_B_change()
  {
    int return_value = B_color_change;
    B_color_change = 0;
    return return_value;
  }

  void display() {
    stroke(255);
    /*
    if(R_color_now < R_color_target) R_color_now ++;
    else if(R_color_now > R_color_target) R_color_now--;
    
    if(G_color_now < G_color_target) G_color_now ++;
    else if(G_color_now > G_color_target) G_color_now--;
    
    if(B_color_now < B_color_target) B_color_now ++;
    else if(B_color_now > B_color_target) B_color_now--;
    
    fill(R_color_now,G_color_now,B_color_now);
    */
    fill(R_color_now,G_color_now,B_color_now);
    ellipse(x,y,w,h); 
  }
}