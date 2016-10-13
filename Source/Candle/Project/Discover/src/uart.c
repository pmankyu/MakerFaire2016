#include "uart.h"

int serial_data[100] = {0,};
int serial_data_index = 0;

INTERRUPT_HANDLER(UART2_RX_IRQHandler, 21)
{
  char c;
  UART2_ClearITPendingBit(UART2_IT_RXNE);
  c = (uint8_t)UART2->DR;
  //input = c;
  
  serial_data[serial_data_index] = c;
  serial_data_index++;
  
  serial_process();
  
  //putchar2(c);
}

void serial_process()
{
  //�ø��� ������ ���۸� ��ĵ
  for(int i=0;i<serial_data_index;i++)
  {
    // ���� ����Ʈ�� �߰��ϸ�
    if(serial_data[i] == 0xFA)
    {
      //ä���� �ִ� ����  candle �����ͺ��� ������
      if((serial_data_index - i) >= 7)
      {
        // ������ �����͸� Ȯ���Ѵ�.
        if(serial_data[i+6]==0x0D)
        {
          //������ �����Ͱ� ����� ���� ���̴�.
          main_id = serial_data[i+1];
          main_mode = serial_data[i+2];
          main_r = serial_data[i+3];
          main_g = serial_data[i+4];
          main_b = serial_data[i+5];
          
          is_main_data_end = TRUE;
          
          //println("serial data >> R : " + R_value + ",G : " + G_value +  ",B : " + B_value +  ",i : " + i+  ",index : " + serial_data_index);
          
          // index�� �ʱ�ȭ �Ѵ�.
          serial_data_index = 0;
          break;
        }
      }
      else
      {
      }
    }
  }
}

void send_serial()
{
  int i=0;
  for(i=0;i<8;i++)
  {
    putchar2(candle_data[i]);
  }
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