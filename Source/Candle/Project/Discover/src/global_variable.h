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

#endif /* __GLOBAL_VARIABLE_H */