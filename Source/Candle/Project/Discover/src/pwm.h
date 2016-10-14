#ifndef __PWM_H
#define __PWM_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#include "global_variable.h"

void set_PWM1_R(uint16_t TIM1_Pulse);
void set_PWM1_G(uint16_t TIM1_Pulse);
void set_PWM1_B(uint16_t TIM1_Pulse);

void set_R_LED(int value);
void set_G_LED(int value);
void set_B_LED(int value);

#endif 