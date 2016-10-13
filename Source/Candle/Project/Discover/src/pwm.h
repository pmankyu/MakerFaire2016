#ifndef __PWM_H
#define __PWM_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#include "global_variable.h"

void set_PWM1_2(uint16_t TIM1_Pulse);
void set_PWM1_3(uint16_t TIM1_Pulse);
void set_PWM1_4(uint16_t TIM1_Pulse);

#endif 