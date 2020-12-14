#ifndef __UART_HANDLR__
#define __UART_HANDLR__
#include "stm8s.h"

void InitialiseUART(void);
void uart_write(unsigned char c);


@far @interrupt void UARTInterruptHandle (void);


#endif