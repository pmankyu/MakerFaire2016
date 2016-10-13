#include "util.h"

void delay_us(volatile int us)
{
  int i;
  for(i=0;i<us;i++)
  {
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
  }
}

void delay_ms(volatile int ms)
{
  int i;
  for(i=0;i<ms;i++)
    delay_us(1000);
}



