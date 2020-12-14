
#include "stm8s.h"
#include "i2c_master_poll.h"
#include "rtc.h"
#include "uart_handler.h"
#include <string.h>


volatile u16 TIM4_tout;


void main (void) { 
  /* peripheral initialization */ 

  int i,j; 
	
           
  
	// initialize timer 4 mandatory for timout and tick measurement 
  TIM4_Init();                    
  
	// Initialize I2C for communication
	I2C_Init(); 

  //Initialize UART for communication
  InitialiseUART();                    
  
  
	// Enable all interrupts  
	enableInterrupts();

    
  if(!Verify_RTC())
      Setup_RTC_Chip();

  /* main test loop */
  while(1) {
		// write 1 data bytes with offset 8 from Dummy filed to slave memory

    ReadTimeRTC();

    uart_write(time_now.Year>>8);
    uart_write((u8)time_now.Year);
    uart_write(time_now.Month);
    uart_write(time_now.Date);
    uart_write(time_now.Hour);
    uart_write(time_now.Minute);
    uart_write(time_now.Second);

    for(i=0;i<32000;i++);

  }
}