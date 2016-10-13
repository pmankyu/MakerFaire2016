/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __GLOBAL_VARIABLE_H
#define __GLOBAL_VARIABLE_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

extern char input;
extern u8 BlinkSpeed;
extern int NumberOfStart;
extern int CheckFlag;

extern int main_id;
extern int main_mode;
extern int main_r;
extern int main_g;
extern int main_b;
extern bool is_main_data_end;

extern uint8_t candle_data[8];

extern int r_value;
extern int g_value;
extern int b_value;

#endif /* __GLOBAL_VARIABLE_H */