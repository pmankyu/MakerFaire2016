/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __INIT_H
#define __INIT_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#define CCR1_Val  ((uint16_t)0)
#define CCR2_Val  ((uint16_t)0) //R
#define CCR3_Val  ((uint16_t)0) //B
#define CCR4_Val  ((uint16_t)0) //G

void CLK_Configuration(void);
void GPIO_Configuration(void);
void TIM1_Config(void);
void UART2_Config(void);
void ADC1_Config(void);

#endif /* __INIT_H */