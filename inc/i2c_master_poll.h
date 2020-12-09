/**
  ******************************************************************************
  * @file    i2c_opt.h
  * @author  MCD Application Team
  * @version V0.0.3
  * @date    Feb 2010
  * @brief   This file contains definitions for optimized I2C software
  ******************************************************************************
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  *                     COPYRIGHT 2009 STMicroelectronics  
  */ 

/* Define to prevent recursive inclusion */
#ifndef __I2C_OPT_H
#define __I2C_OPT_H

#include "stm8s.h"


#define SLAVE_ADDRESS  0x51


// ************************* Function Declaration ***************************


void I2C_Init(void);
void TIM4_Init(void);
void I2C_RandomRead(u8 u8_NumByteToRead, u8 *u8_ReadBuffer);
void I2C_ReadRegister(u8 u8_regAddr, u8 u8_NumByteToRead, u8 *u8_ReadBuffer);
void I2C_WriteRegister(u8 u8_regAddr, u8 u8_NumByteToWrite, u8 *u8_DataBuffer);
void ErrProc(void);

/* flag clearing sequence - uncoment next for peripheral clock under 2MHz */
#define dead_time() { /* _asm("nop"); _asm("nop"); */ }
#define delay(a)          { TIM4_tout= a; while(TIM4_tout); }
#define tout()            (TIM4_tout)
#define set_tout_ms(a)    { TIM4_tout= a; }
extern u16 TIM4_tout;


// ************************* Interrupt handler Declaration ***************************


@far @interrupt void I2C_error_Interrupt_Handler (void);

@far @interrupt void TIM4InterruptHandle (void);



// ************************* I2C Example decalaration ***************************

#define MAX_DUMMY 10
#define LED1  0x08
#define LED2  0x04
#define LED3  0x02
#define LED4  0x01
#define switch_on(msk) GPIOH->ODR |= (msk) ;
#define switch_off(msk) GPIOH->ODR &= ~(msk);


#endif /* __I2C_OPT_H */

/******************* (C) COPYRIGHT 2009 STMicroelectronics *****END OF FILE****/
