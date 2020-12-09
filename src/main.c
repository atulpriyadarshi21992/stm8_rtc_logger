
#include "stm8s.h"
#include "i2c_master_poll.h"
#include "rtc.h"
#include <string.h>


volatile u16 TIM4_tout;


void main (void) { 
  /* peripheral initialization */  
  CLK->CKDIVR = 0x01;             // sys clock / 2
  
	// Set GPIO for LED uses 
  GPIOH->DDR |=  0x0F;            
  GPIOH->CR1 |=  0x0F;            
  
	// initialize timer 4 mandatory for timout and tick measurement 
  TIM4_Init();                    
  
	// Initialize I2C for communication
	I2C_Init();                     
  
  
	// Enable all interrupts  
	enableInterrupts();

    
  if(!Verify_RTC())
      Setup_RTC_Chip();

  /* main test loop */
  while(1) {
		// write 1 data bytes with offset 8 from Dummy filed to slave memory

    ReadTimeRTC();

  }
}