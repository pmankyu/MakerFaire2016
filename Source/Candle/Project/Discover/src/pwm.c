#include "pwm.h"

void set_PWM1_B(uint16_t TIM1_Pulse)
{
  TIM1->CCR2H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR2L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_G(uint16_t TIM1_Pulse)
{
  TIM1->CCR3H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR3L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_R(uint16_t TIM1_Pulse)
{
  TIM1->CCR4H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR4L = (uint8_t)(TIM1_Pulse);
}

void set_R_LED(int value)
{
  // value 의 값은 0(OFF) ~ 255(Full) 인데
  // 초는 10000(OFF) ~ 0(Full) 이라서 바꿔준다.
  
  int led_value = 0;
  
  led_value = 10000 - ((value*10000) / 255);
  set_PWM1_R(led_value);
}

void set_G_LED(int value)
{
  int led_value = 0;
  
  led_value = 10000 - ((value*10000) / 255);
  
  set_PWM1_G(led_value); 
}

void set_B_LED(int value)
{
  int led_value = 0;
  
  led_value = 10000 - ((value*10000) / 255);
  
  set_PWM1_B(led_value);
}
        
        