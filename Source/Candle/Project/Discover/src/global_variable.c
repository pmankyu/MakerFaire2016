#include "global_variable.h"

char input=0;

u8 BlinkSpeed = 0;
int NumberOfStart;
int CheckFlag = 1;

// main ���� ���� ����
int main_id = 0;
int main_mode = 0;
int main_r = 0;
int main_g = 0;
int main_b = 0;
bool is_main_data_end = FALSE;

// main ���� ������ ����
uint8_t candle_data[8] = {0xFA,1,0,1,0,1,0,0x0D};

int r_value = 0;
int g_value = 0;
int b_value = 0;