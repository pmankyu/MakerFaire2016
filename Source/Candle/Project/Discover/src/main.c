#include "stm8s.h"
#include "stm8s_tim1.h"
#include "stm8s_tim2.h"
#include "stm8s_uart2.h"

#include "global_variable.h"
#include "util.h"
#include "uart.h"
#include "init.h"
#include "pwm.h"

//char input;
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
  int R_temp = 0;
  int G_temp = 0;
  int B_temp = 0;
  int Basic_rand = 0;
  
  uint16_t R=10000, G=10000, B=10000, demper=0,mic_cnt=0, cali=0;
  //uint16_t R_temp=10000, G_temp=10000, B_temp=10000, Basic_rand=0;
  unsigned int R_cnt=0, G_cnt=0, B_cnt=0, off_flag=0;
  unsigned int MIC_Value_offset, MIC_Value;
  uint16_t IR_Value;
  unsigned int mic_Q[100]={0}, mic_avr, ir_sum=0;
  //unsigned int ir_avr;
 
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
  set_PWM1_R(0);        set_PWM1_G(10000);      set_PWM1_B(10000);      delay_ms(500); 
  set_PWM1_R(10000);    set_PWM1_G(0);          set_PWM1_B(10000);      delay_ms(500); 
  set_PWM1_R(10000);    set_PWM1_G(10000);      set_PWM1_B(0);          delay_ms(500); 
  
  set_PWM1_B(10000);//BLUE
  set_PWM1_G(10000);//GREEN
  set_PWM1_R(10000);//RED
  
  
   /* LIGHTER Calibration */ 
  for(cali=0;cali<100;cali++){
    mic_Q[cali] = ReadSensor_IR();
    ir_sum+=mic_Q[cali];
  }
  //ir_avr 은 사용되지 않는다.
  //ir_avr=ir_sum/100; 

  while (1)
  {
    /* Select the ADC1 channel 0 select */
    ADC1->CSR &= (uint8_t)(0xf0);
    ADC1->CR1 |= ADC1_CR1_ADON;  
    // 라이터 값을 읽는다.
    IR_Value = ReadSensor_IR();

    /* Select the ADC1 channel 1 select */
    ADC1->CSR |= (uint8_t)(0x01);
    ADC1->CR1 |= ADC1_CR1_ADON;
    // MIC 값을 읽는다.
    MIC_Value_offset = ReadSensor_MIC();    
        
    /* MIC Calibration */
    mic_Q[mic_cnt] = MIC_Value_offset;
    if(demper==10)
    {
      demper=0; int i=0; unsigned int mic_sum=0;
      for(i=0;i<100;i++)
      {
        mic_sum+=mic_Q[i];
      }
      mic_avr=mic_sum/100; 
      mic_sum=0;
    }
    
    if(mic_cnt==100) mic_cnt=0; 
    
    demper++; mic_cnt++;
    
    /* LIGHTER Calibration */
    
    
    
    // R,G,B 값은 10000에서 시작해서 감소할수록 켜지는 것이다.
    // 라이터 입력에 따라 해당 값을 감소시킨다.
    if(IR_Value >750 && IR_Value <940 && R>=1000)
    {
      // Red 라이터 입력
      off_flag=0;B_cnt=0;G_cnt=0;
      
      if(R_cnt==4000)
      {
        R_cnt=0; R=R-1000;
        if(R<1000) R=0;
      }
      
      R_cnt++;
    }
    else if(IR_Value >400 && IR_Value <750 && G>=5500) 
    {
      // Green
      off_flag=0;R_cnt=0;B_cnt=0;
      
      if(G_cnt==4000)
      {
        G_cnt=0; G=G-500;
        if(G<5500)G=5000;
      }
      
      G_cnt++;
    }
    else if(IR_Value <400 && B>=1000) 
    {
      // Blue 라이터 입력
      off_flag=0;G_cnt=0;R_cnt=0;
      
      if(B_cnt==4000)
      {
        B_cnt=0; B=B-1000;
        if(B<1000) B=0;
      }
      
      B_cnt++;
    }
    
   
  //  set_PWM1_4(R); set_PWM1_3(G); set_PWM1_2(B); 
    Basic_rand=0;//rand()%3000;
  //  R=5000;B=5000;G=5000;
    
    if(MIC_Value_offset>mic_avr) MIC_Value = MIC_Value_offset-mic_avr;
    else MIC_Value = mic_avr-MIC_Value_offset;
    
    R_temp=R+(MIC_Value)*100+2*Basic_rand; 
    G_temp=G+(MIC_Value)*50+Basic_rand; 
    B_temp=B+(MIC_Value)*100+2*Basic_rand;
    
    if(R_temp>10000)R_temp=10000;
    if(G_temp>10000)G_temp=10000;
    if(B_temp>10000)B_temp=10000;
    
    /* led off by mic*/
    if((MIC_Value_offset-mic_avr)>300&&(MIC_Value_offset-mic_avr)<1000)
    {
      R=G=B=10000; 
      off_flag=1;
    }
    else {
      if(off_flag==1)
      {
        // 마이크로 OFF 했을때
        set_PWM1_R(10000); 
        set_PWM1_G(10000); 
        set_PWM1_B(10000);
      }
      else 
      {
        // 라이터로 색을 바꿨을때
        set_PWM1_R(R_temp); 
        set_PWM1_G(G_temp); 
        set_PWM1_B(B_temp);
      }//LED SET
    }
    
    // 시리얼 데이터가 들어오면 처리할 부분
    if(is_main_data_end==TRUE)
    {
      switch(main_mode)
      {
        case 1:
            // main으로부터 초의 색깔 데이터를 입력 받았을때
          
          set_R_LED(main_r);
          set_G_LED(main_g);
          set_B_LED(main_b);
        break;
        
        case 2:
          // main으로부터 초의 현재 상태에 대한 정보를 요청받았을때
          
          // 초의 값이 음수라면 (마이크를 이용한 OFF 명령) 색 데이터 직전 데이터에 2를 보내주고
          // 초 값을 양수로 바꿔준다.
          if(R_temp > 0) candle_data[1] = 1;
          else
          {
            candle_data[1] = 2;
            R_temp = -1 * R_temp;
          }
          
          if(G_temp > 0) candle_data[3] = 1;
          else 
          {
            candle_data[3] = 2;
            G_temp = -1 * G_temp;
          }
          
          if(B_temp > 0) candle_data[5] = 1;
          else 
          {
            candle_data[5] = 2;
            B_temp = -1 * B_temp;
          }
          
          candle_data[2] = R_temp;
          candle_data[4] = G_temp;
          candle_data[6] = B_temp;
          
          // 데이터를 main 으로 보낸다.
          send_serial();
        break;
      }
      is_main_data_end = FALSE;
    }
    
    //set_PWM1_4(R); set_PWM1_3(G); set_PWM1_2(B); 
    //delay_ms(20);
    //putchar2(1);putchar2(2);
    //putchar2(3);
    
  } // End of while(1)
}






/*
OLD source

  uint16_t i=0, j=0, k=0;
  unsigned int i_flag=0;
  unsigned int j_flag=0;
  unsigned int k_flag=0;
  unsigned int ADC1_Value;
  unsigned int ADC1_Max_Value = 0;
  unsigned int ADC1_Min_Value = 10000;
  unsigned int LED_B_Value = 0;

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
    
    set_PWM1_2(0);delay_ms(200);set_PWM1_2(10000);
    delay_ms(200);
    set_PWM1_B(0);delay_ms(200);set_PWM1_B(10000);
    delay_ms(200);
    set_PWM1_4(0);delay_ms(200);set_PWM1_4(10000);
    delay_ms(200);
    
    
    delay_ms(20);
   // ADC1_Value = ReadSensor();
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
    //if(LED_B_Value < 0) LED_B_Value = 0;
    
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
    
*/