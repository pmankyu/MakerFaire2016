#include "pwm.h"

void set_PWM1_2(uint16_t TIM1_Pulse)
{
  TIM1->CCR2H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR2L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_3(uint16_t TIM1_Pulse)
{
  TIM1->CCR3H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR3L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_4(uint16_t TIM1_Pulse)
{
  TIM1->CCR4H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR4L = (uint8_t)(TIM1_Pulse);
}