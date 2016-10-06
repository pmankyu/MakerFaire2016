// 2D Array of objects
Candle[][] grid;

// Number of columns and rows in the grid
int cols = 6;
int rows = 5;

int mouse_time = 0;

int lighterX = 800;
int lighterSize = 100;
int R_lighterY = 100;
int G_lighterY = 200;
int B_lighterY = 300;
int OFF_lighterY = 400;
int RESET_lighterY = 500;

int lighter = 0;

int Seleted_candle_i = -1;
int Seleted_candle_j = -1;

int[][] candle_R_now;
int[][] candle_G_now;
int[][] candle_B_now;

int[][] candle_R_target;
int[][] candle_G_target;
int[][] candle_B_target;

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
  size(1000,700);
  background(0);
  grid = new Candle[cols][rows];
  
  candle_R_now = new int[cols][rows];
  candle_G_now = new int[cols][rows];
  candle_B_now = new int[cols][rows];
  
  candle_R_target = new int[cols][rows];
  candle_G_target = new int[cols][rows];
  candle_B_target = new int[cols][rows];
   
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Candle(i*110+100,j*110+100,100,100,0,0,0);
      candle_R_target[i][j] = grid[i][j].Get_R();
      candle_G_target[i][j] = grid[i][j].Get_G();
      candle_B_target[i][j] = grid[i][j].Get_B();
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
    if((millis() - now_time) > 10) break;
  }
  
  time_cnt++;
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Read each candle
      candle_R_target[i][j] = grid[i][j].Get_R();
      candle_G_target[i][j] = grid[i][j].Get_G();
      candle_B_target[i][j] = grid[i][j].Get_B();
      
      print("Candle: " + i + "," + j);
      println(", R : " +candle_R_target[i][j] +", G : " +candle_G_target[i][j] + ", B : " +candle_B_target[i][j]);
    }
  }
  
  //calc candle target
  //bsy idea
  //find max R,G,B Color
  
  if(time_cnt >= 40)
  {
    time_cnt = 0;
    MAX_R_Value = 0; MAX_R_i=0; MAX_R_j=0;
    MAX_G_Value = 0; MAX_G_i=0; MAX_G_j=0;
    MAX_B_Value = 0; MAX_B_i=0; MAX_B_j=0;
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Read each candle
        if(MAX_R_Value < candle_R_target[i][j])
        {
          MAX_R_Value = candle_R_target[i][j];
          MAX_R_i = i;
          MAX_R_j = j;
        }
        
        if(MAX_G_Value < candle_G_target[i][j])
        {
          MAX_G_Value = candle_G_target[i][j];
          MAX_G_i = i;
          MAX_G_j = j;
        }
        
        if(MAX_B_Value < candle_B_target[i][j])
        {
          MAX_B_Value = candle_B_target[i][j];
          MAX_B_i = i;
          MAX_B_j = j;
        }
      }
    }
    
    println("MAX_R_Value: " + candle_R_target[MAX_R_i][MAX_R_j] + ", i : " + MAX_R_i + ", j : " + MAX_R_j);
    println("MAX_G_Value: " + candle_G_target[MAX_G_i][MAX_G_j] + ", i : " + MAX_G_i + ", j : " + MAX_G_j);
    println("MAX_B_Value: " + candle_B_target[MAX_B_i][MAX_B_j] + ", i : " + MAX_B_i + ", j : " + MAX_B_j);
    
    // set color 1st rule
    /*
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if(candle_R_target[i][j] < MAX_R_Value)
        {
          R_Value = candle_R_target[i][j] + MAX_R_Value/(  (abs(MAX_R_i-i)+abs(MAX_R_j-j))*2  );
          if(R_Value >= MAX_R_Value) R_Value = MAX_R_Value;
          grid[i][j].Set_R(R_Value);
        }
        
        if(candle_G_target[i][j] < MAX_G_Value)
        {
          G_Value = candle_G_target[i][j] + MAX_G_Value/(  (abs(MAX_G_i-i)+abs(MAX_G_j-j))*2  );
          if(G_Value >= MAX_G_Value) G_Value = MAX_G_Value;
          grid[i][j].Set_G(G_Value);
        }
        
        if(candle_B_target[i][j] < MAX_B_Value)
        {
          B_Value = candle_B_target[i][j] + MAX_B_Value/(  (abs(MAX_B_i-i)+abs(MAX_B_j-j))*2  );
          if(B_Value >= MAX_B_Value) B_Value = MAX_B_Value;
          grid[i][j].Set_B(B_Value);
        }
      }
    }
  }
  */
  
  
  
  
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      // real set : send once
      // test processing : send every 10ms
      grid[i][j].display();
    }
  }
}

void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  mouse_time = millis();
  check_lighter(mouseX,mouseY);
  
  //select change candle to candle
  if(lighter == 5){
    int tempR,tempG,tempB;
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if( ((grid[i][j].x - grid[i][j].w/2) < x) && ((grid[i][j].x + grid[i][j].w/2) > x))
        {
          if( ((grid[i][j].y - grid[i][j].h/2) < y) && ((grid[i][j].y + grid[i][j].h/2) > y))
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
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if( ((grid[i][j].x - grid[i][j].w/2) < x) && ((grid[i][j].x + grid[i][j].w/2) > x))
      {
        if( ((grid[i][j].y - grid[i][j].h/2) < y) && ((grid[i][j].y + grid[i][j].h/2) > y))
        {
          print("Candle: " + i + "," + j);
          println(", lighter : " +lighter +", mouse time(ms): " + time );
          
          grid[i][j].change_color(lighter,plus_value);
          
          //if(grid[i][j].change_color(lighter,plus_value))  change_color_nearby(i,j,plus_value);
        }
      }
    }
  }
}

void change_color_nearby(int candle_i,int candle_j, int value){
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].change_color(lighter,value/( (  abs(candle_i-i)+abs(candle_j-j)+1 )));
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

// A Cell object
class Candle {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  int R_color_now;
  int G_color_now;
  int B_color_now;
  int R_color_target;
  int G_color_target;
  int B_color_target;

  // Cell Constructor
  Candle(float tempX, float tempY, float tempW, float tempH, int tempR, int tempG, int tempB) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    R_color_target = tempR;
    G_color_target = tempG;
    B_color_target = tempB;
    R_color_now = 0;
    G_color_now = 0;
    B_color_now = 0;
  } 
  
  boolean  change_color(int mode,int value){
    switch(mode){
      case 1:
        if(R_color_target <= 255) {
          R_color_target += value;
          if(R_color_target >= 255) R_color_target = 255;
          return true;
        }
      break;
      
      case 2:
        if(G_color_target <= 255) {
          G_color_target += value;
          if(G_color_target >= 255) G_color_target = 255;
          return true;
        }
      break;
      
      case 3:
        if(B_color_target <= 255) {
          B_color_target += value;
          if(B_color_target >= 255) B_color_target = 255;
          return true;
        }
      break;
      
      case 4:
        R_color_target = 0;
        G_color_target = 0;
        B_color_target = 0;
        R_color_now = 0;
        G_color_now = 0;
        B_color_now = 0;
      break;
      
      default:
      break;
    }
    
    return false;
  }
  
  int Get_R(){return R_color_target;}
  void Set_R(int value){R_color_target = value;}
  
  int Get_G(){return G_color_target;}
  void Set_G(int value){G_color_target = value;}
  
  int Get_B(){return B_color_target;}
  void Set_B(int value){B_color_target = value;}

  void display() {
    stroke(255);
    
    if(R_color_now < R_color_target) R_color_now ++;
    else if(R_color_now > R_color_target) R_color_now--;
    
    if(G_color_now < G_color_target) G_color_now ++;
    else if(G_color_now > G_color_target) G_color_now--;
    
    if(B_color_now < B_color_target) B_color_now ++;
    else if(B_color_now > B_color_target) B_color_now--;
    
    fill(R_color_now,G_color_now,B_color_now);
    ellipse(x,y,w,h); 
  }
}