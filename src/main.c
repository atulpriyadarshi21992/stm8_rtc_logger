/**
  ******************************************************************************
  * @file    main.c
  * @author  MCD Application Team
  * @version V0.0.3
  * @date    Feb 2010
  * @brief   This file contains main test loop for optimized I2C master
  ******************************************************************************
  * @copy
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATI\\ON REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2009 STMicroelectronics</center></h2>
  */ 
#include "stm8s.h"
#include "i2c_master_poll.h"
#include <string.h>

const u8 DUMMY_INIT[MAX_DUMMY]= { 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80, 0x90, 0xa0 };

u8 Dummy[MAX_DUMMY];
volatile u16 TIM4_tout;


/******************************************************************************
* Function name : main
* Description 	: Main testing loop
* Input param 	: None
* Return 		    : None
* See also 		  : None
*******************************************************************************/
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
  
  // initialization of dummy field for test purpose    
  memcpy(Dummy, DUMMY_INIT, MAX_DUMMY);
  
	// Enable all interrupts  
	enableInterrupts();

  /* main test loop */
  while(1) {
		// write 1 data bytes with offset 8 from Dummy filed to slave memory
    set_tout_ms(10);
    I2C_WriteRegister(8, 1, &Dummy[8]);
    I2C_ReadRegister(0, 2, &Dummy[0]);

    switch_on(LED2);
    delay(1);
    switch_off(LED2);
    delay(1);
  }
}