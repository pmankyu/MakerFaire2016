#ifndef __UTIL_H
#define __UTIL_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#include "global_variable.h"

void delay_ms(volatile int ms);
void delay_us(volatile int us);

//extern char input;

#endif 