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
void set_PWM1_3(uint16_t);
void set_PWM1_4(uint16_t);
                
u8 BlinkSpeed = 0;
int NumberOfStart;
int CheckFlag = 1;

#define CCR1_Val  ((uint16_t)0)
#define CCR2_Val  ((uint16_t)0) //R
#define CCR3_Val  ((uint16_t)0) //B
#define CCR4_Val  ((uint16_t)0) //G

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
  UART2_Init((uint32_t)9600, UART2_WORDLENGTH_8D, UART2_STOPBITS_1, UART2_PARITY_NO,
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
  ADC1_DeInit(); 
  ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
  ADC1_CHANNEL_1, 
  ADC1_PRESSEL_FCPU_D2, 
  ADC1_EXTTRIG_TIM, 
  DISABLE, 
  ADC1_ALIGN_RIGHT, 
  ADC1_SCHMITTTRIG_CHANNEL0|ADC1_SCHMITTTRIG_CHANNEL1, 
  DISABLE); 
  ADC1_Cmd(ENABLE); 
  ADC1_StartConversion();
}

int ReadSensor_MIC()
{
  return ADC1_GetConversionValue();
} 
int ReadSensor_IR()
{
  return ADC1_GetConversionValue();
} 


void main(void)
{
  uint16_t R=10000, G=10000, B=10000, demper=0,mic_cnt=0, cali=0;
  uint16_t R_temp=10000, G_temp=10000, B_temp=10000, Basic_rand=0;;
  unsigned int R_cnt=0, G_cnt=0, B_cnt=0, off_flag=0;
  unsigned int MIC_Value_offset, MIC_Value;
  uint16_t IR_Value;
  unsigned int mic_Q[100]={0}, mic_avr, ir_avr, ir_sum=0;
 
  
  CLK_Configuration();
  GPIO_Configuration();
  TIM1_Config();
  UART2_Config();
  ADC1_Config();  
  enableInterrupts();
  
  GPIO_WriteReverse(GPIOC, GPIO_PIN_2);
  GPIO_WriteReverse(GPIOC, GPIO_PIN_3);
  GPIO_WriteReverse(GPIOC, GPIO_PIN_4);

  /*LED OFF*/
  set_PWM1_4(0); set_PWM1_3(10000); set_PWM1_2(10000);delay_ms(500); 
  set_PWM1_4(10000); set_PWM1_3(0); set_PWM1_2(10000);delay_ms(500); 
  set_PWM1_4(10000); set_PWM1_3(10000); set_PWM1_2(0);delay_ms(500); 
  set_PWM1_2(10000);//BLUE
  set_PWM1_3(10000);//GREEN
  set_PWM1_4(10000);//RED
  
  
   /* LIGHTER Calibration */ 
  for(cali=0;cali<100;cali++){
    mic_Q[cali] = ReadSensor_IR();
    ir_sum+=mic_Q[cali];
  }
  ir_avr=ir_sum/100; 
    
    
  
  
  while (1)
  {
    /* Select the ADC1 channel 0 select */
    ADC1->CSR &= (uint8_t)(0xf0);
    ADC1->CR1 |= ADC1_CR1_ADON;    
    IR_Value = ReadSensor_IR();

    /* Select the ADC1 channel 1 select */
    ADC1->CSR |= (uint8_t)(0x01);
    ADC1->CR1 |= ADC1_CR1_ADON;
    MIC_Value_offset = ReadSensor_MIC();    
        
    /* MIC Calibration */
    mic_Q[mic_cnt]=MIC_Value_offset;
    if(demper==10){
      demper=0; int i=0; unsigned int mic_sum=0;
      for(i=0;i<100;i++){mic_sum+=mic_Q[i];}
      mic_avr=mic_sum/100; mic_sum=0;
    }if(mic_cnt==100) mic_cnt=0; demper++; mic_cnt++;
    
    /* LIGHTER Calibration */
    
    if(IR_Value >750 && IR_Value <940 && R>=1000) {off_flag=0;B_cnt=0;G_cnt=0;if(R_cnt==4000){R_cnt=0; R=R-1000;if(R<1000){R=0;}}R_cnt++;}
    else if(IR_Value >400 && IR_Value <750 && G>=5500) {off_flag=0;R_cnt=0;B_cnt=0;if(G_cnt==4000){G_cnt=0; G=G-500;if(G<5500){G=5000;}}G_cnt++;}
    else if(IR_Value <400 && B>=1000) {off_flag=0;G_cnt=0;R_cnt=0;if(B_cnt==4000){B_cnt=0; B=B-1000;if(B<1000){B=0;}}B_cnt++;}
    
   
  //  set_PWM1_4(R); set_PWM1_3(G); set_PWM1_2(B); 
    Basic_rand=0;//rand()%3000;
  //  R=5000;B=5000;G=5000;
    if(MIC_Value_offset>mic_avr)MIC_Value=MIC_Value_offset-mic_avr;else MIC_Value=mic_avr-MIC_Value_offset;
    R_temp=R+(MIC_Value)*100+2*Basic_rand; G_temp=G+(MIC_Value)*50+Basic_rand; B_temp=B+(MIC_Value)*100+2*Basic_rand;
    if(R_temp>10000)R_temp=10000;if(G_temp>10000)G_temp=10000;if(B_temp>10000)B_temp=10000;
    
    /* led off by mic*/
    if((MIC_Value_offset-mic_avr)>300&&(MIC_Value_offset-mic_avr)<1000){R=G=B=10000; off_flag=1;}
    else {
      if(off_flag==1){set_PWM1_4(10000); set_PWM1_3(10000); set_PWM1_2(10000);}
      else {set_PWM1_4(R_temp); set_PWM1_3(G_temp); set_PWM1_2(B_temp);}//LED SET
    }
    //set_PWM1_4(R); set_PWM1_3(G); set_PWM1_2(B); 
    
    
   
    //delay_ms(20);
    
//    putchar2(1);putchar2(2);
//    putchar2(3);
    
    
    
  }
}

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
  putchar2(c);
  /*
  if(c=='R'){
    set_PWM1_2(10000);
    set_PWM1_3(10000);
    set_PWM1_4(0);
  }
  else if(c=='G'){
    set_PWM1_2(10000);
    set_PWM1_3(0);
    set_PWM1_4(10000);
  }
  if(c=='B'){
    set_PWM1_2(0);
    set_PWM1_3(10000);
    set_PWM1_4(10000);
  }
  */
}
