#include "uart.h"

INTERRUPT_HANDLER(UART2_RX_IRQHandler, 21)
{
  char c;
  UART2_ClearITPendingBit(UART2_IT_RXNE);
  c = (uint8_t)UART2->DR;
  input = c;
  //putchar2(c);
}

void Printf(char *message)
{
    char *ch = message;
    while (*ch)
    {
        UART2->DR = (u8) (*ch);
        while ((UART2->SR & (u8) UART2_FLAG_TXE) == RESET);
        ch++;
    }
}

PUTCHAR_PROTOTYPE
{
    while (!(UART2->SR & UART2_SR_TXE));
    UART2->DR = c;    
}

GETCHAR_PROTOTYPE
{
     while(!(UART2->SR & UART2_SR_RXNE));
     return ((uint8_t)UART2->DR);
}

void putchar2(char c)
{
  UART2_SendData8(c);
  while (UART2_GetFlagStatus(UART2_FLAG_TXE) == RESET);
}

char getchar2(void)
{
  char c = 0;
  while (UART2_GetFlagStatus(UART2_FLAG_RXNE) == RESET);
  c = UART2_ReceiveData8();
  return (c);
}