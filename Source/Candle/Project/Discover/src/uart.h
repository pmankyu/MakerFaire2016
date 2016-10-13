#ifndef __UART_H
#define __UART_H

#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#include "global_variable.h"

#define PUTCHAR_PROTOTYPE void putchar (char c)
#define GETCHAR_PROTOTYPE char getchar (void)

void Printf(char *message);
void putchar2(char c);
char getchar2(void);

#endif 