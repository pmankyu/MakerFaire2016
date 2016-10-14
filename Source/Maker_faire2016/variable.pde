int candle_index = 1;

// 2D Array of objects
Candle[][] candle;
Candle_data[][] candle_data;

PFont f;

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

int[] candle_off = {100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100};

int candle_id = 0;
int candle_mode = 0;
int candle_mic = 0;
int candle_r = 0;
int candle_g = 0;
int candle_b = 0;
boolean is_candle_data_end = false;

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
      
      case 5:
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