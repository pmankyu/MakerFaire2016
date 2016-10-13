#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"


void CLK_Configuration(void);
void GPIO_Configuration(void);
void Toggle(void);
void delay_us(volatile int);
void delay_ms(volatile int);
void set_PWM1_2(uint16_t);
void set_PWM1_B(uint16_t);
void set_PWM1_4(uint16_t);
void Printf(char *message);
                
u8 BlinkSpeed = 0;
int NumberOfStart;
int CheckFlag = 1;
char input;

#define CCR1_Val  ((uint16_t)0)
#define CCR2_Val  ((uint16_t)0) //R
#define CCR3_Val  ((uint16_t)0) //B
#define CCR4_Val  ((uint16_t)0) //G

#define PUTCHAR_PROTOTYPE char putchar (char c)
#define GETCHAR_PROTOTYPE char getchar (void)

void GPIO_Configuration(void)
{
  /* LED */
  GPIO_DeInit(GPIOC);
  GPIO_Init(GPIOC, GPIO_PIN_2 | GPIO_PIN_3 | GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
  
  /* ADC */
  GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOC, GPIO_PIN_0 | GPIO_PIN_1, GPIO_MODE_IN_FL_NO_IT);
}

void TIM1_Config(void)
{
  TIM1_DeInit();

  TIM1_TimeBaseInit(0, TIM1_COUNTERMODE_UP, 10000, 0);
  
  TIM1_OC1Init(TIM1_OCMODE_PWM2, TIM1_OUTPUTSTATE_ENABLE, TIM1_OUTPUTNSTATE_ENABLE,
               CCR1_Val, TIM1_OCPOLARITY_LOW, TIM1_OCNPOLARITY_HIGH, TIM1_OCIDLESTATE_SET,
               TIM1_OCNIDLESTATE_RESET); 

  /*TIM1_Pulse = CCR2_Val*/
  TIM1_OC2Init(TIM1_OCMODE_PWM2, TIM1_OUTPUTSTATE_ENABLE, TIM1_OUTPUTNSTATE_ENABLE, CCR2_Val,
               TIM1_OCPOLARITY_LOW, TIM1_OCNPOLARITY_HIGH, TIM1_OCIDLESTATE_SET, 
               TIM1_OCNIDLESTATE_RESET);

  /*TIM1_Pulse = CCR3_Val*/
  TIM1_OC3Init(TIM1_OCMODE_PWM2, TIM1_OUTPUTSTATE_ENABLE, TIM1_OUTPUTNSTATE_ENABLE,
               CCR3_Val, TIM1_OCPOLARITY_LOW, TIM1_OCNPOLARITY_HIGH, TIM1_OCIDLESTATE_SET,
               TIM1_OCNIDLESTATE_RESET);

  /*TIM1_Pulse = CCR4_Val*/
  TIM1_OC4Init(TIM1_OCMODE_PWM2, TIM1_OUTPUTSTATE_ENABLE, CCR4_Val, TIM1_OCPOLARITY_LOW,
               TIM1_OCIDLESTATE_SET);

  /* TIM1 counter enable */
  TIM1_Cmd(ENABLE);

  /* TIM1 Main Output Enable */
  TIM1_CtrlPWMOutputs(ENABLE);
}

void UART2_Config(void)
{
  UART2_Init((uint32_t)115200, UART2_WORDLENGTH_8D, UART2_STOPBITS_1, UART2_PARITY_NO,
              UART2_SYNCMODE_CLOCK_DISABLE, UART2_MODE_TXRX_ENABLE);
  
  UART2_ITConfig(UART2_IT_RXNE, ENABLE);
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

void ADC1_Config(void)
{
  // sensor 
  ADC1_DeInit(); 
  ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
  ADC1_CHANNEL_0, 
  ADC1_PRESSEL_FCPU_D2, 
  ADC1_EXTTRIG_TIM, 
  DISABLE, 
  ADC1_ALIGN_RIGHT, 
  ADC1_SCHMITTTRIG_CHANNEL0, 
  DISABLE); 
  ADC1_Cmd(ENABLE); 
  ADC1_StartConversion();
}

int ReadSensor()
{
  return ADC1_GetConversionValue();
} 

void main(void)
{
  uint16_t i=0, j=0, k=0;
  unsigned int i_flag=0;
  unsigned int j_flag=0;
  unsigned int k_flag=0;
  unsigned int ADC1_Value;
  unsigned int ADC1_Max_Value = 0;
  unsigned int ADC1_Min_Value = 10000;
  unsigned int LED_B_Value = 0;
  
  CLK_Configuration();
  GPIO_Configuration();
  TIM1_Config();
  UART2_Config();
  ADC1_Config();
  
  enableInterrupts();
  
  GPIO_WriteReverse(GPIOC, GPIO_PIN_2);
  GPIO_WriteReverse(GPIOC, GPIO_PIN_3);
  GPIO_WriteReverse(GPIOC, GPIO_PIN_4);

  while (1)
  {
    if(i_flag==0)
    {
      i+=10;
      if(i>10000) i_flag=1;
    }
    else
    {
      i-=10;
      if(i<=10) i_flag=0;
    }
    
    if(j_flag==0)
    {
      j+=30;
      if(j>10000) j_flag=1;
    }
    else
    {
      j-=30;
      if(j<=30) j_flag=0;
    }
    
    if(k_flag==0)
    {
      k+=50;
      if(k>10000) k_flag=1;
    }
    else
    {
      k-=50;
      if(k<=50) k_flag=0;
    }
    
    //0:ON, 10000:OFF
    /*
    set_PWM1_2(0);delay_ms(200);set_PWM1_2(10000);
    delay_ms(200);
    set_PWM1_B(0);delay_ms(200);set_PWM1_B(10000);
    delay_ms(200);
    set_PWM1_4(0);delay_ms(200);set_PWM1_4(10000);
    delay_ms(200);
    */
    
    delay_ms(20);
    ADC1_Value = ReadSensor();
    ADC1_Value /=4;
    
    if(ADC1_Max_Value < ADC1_Value) ADC1_Max_Value = ADC1_Value;
    if(ADC1_Min_Value > ADC1_Value) ADC1_Min_Value = ADC1_Value;
    
    putchar2((ADC1_Value/1000)%10 + 48);
    putchar2((ADC1_Value/100)%10 + 48);
    putchar2((ADC1_Value/10)%10 + 48);
    putchar2(ADC1_Value%10 + 48);
    putchar2(',');
    
    putchar2((ADC1_Max_Value/1000)%10 + 48);
    putchar2((ADC1_Max_Value/100)%10 + 48);
    putchar2((ADC1_Max_Value/10)%10 + 48);
    putchar2(ADC1_Max_Value%10 + 48);
    putchar2(',');
    
    putchar2((ADC1_Min_Value/1000)%10 + 48);
    putchar2((ADC1_Min_Value/100)%10 + 48);
    putchar2((ADC1_Min_Value/10)%10 + 48);
    putchar2(ADC1_Min_Value%10 + 48);
    putchar2('\r');
    putchar2('\n');
    
    LED_B_Value = 10000 - (ADC1_Value*50);
    if(LED_B_Value < 0) LED_B_Value = 0;
    
    if(input == 'r')
    {
      set_PWM1_2(0);
      set_PWM1_B(10000);
      set_PWM1_4(10000);
    }
    else if(input == 'g')
    {
      set_PWM1_2(10000);
      set_PWM1_B(10000);
      set_PWM1_4(0);
    }
    else if(input == 'b')
    {
      set_PWM1_2(10000);
      set_PWM1_B(0);
      set_PWM1_4(10000);
    }
    else if(input == 'a')
    {
      set_PWM1_2(0);
      set_PWM1_B(0);
      set_PWM1_4(0);
    }
    else
    {
      set_PWM1_2(10000);
      set_PWM1_B(10000);
      set_PWM1_4(10000);
    }
    
  }
}

void set_PWM1_2(uint16_t TIM1_Pulse)
{
  TIM1->CCR2H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR2L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_B(uint16_t TIM1_Pulse)
{
  TIM1->CCR3H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR3L = (uint8_t)(TIM1_Pulse);
}

void set_PWM1_4(uint16_t TIM1_Pulse)
{
  TIM1->CCR4H = (uint8_t)(TIM1_Pulse >> 8);
  TIM1->CCR4L = (uint8_t)(TIM1_Pulse);
}

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

void CLK_Configuration(void)
{
  /* Fmaster = 16MHz */
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
}

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