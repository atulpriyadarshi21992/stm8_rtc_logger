   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  42                     ; 5 void InitialiseUART(void)
  42                     ; 6 {       
  44                     	switch	.text
  45  0000               _InitialiseUART:
  49                     ; 11     (void) UART1->SR;
  51  0000 c65230        	ld	a,21040
  52                     ; 12     (void) UART1->DR;
  54  0003 c65231        	ld	a,21041
  55                     ; 14     UART1->CR2 = UART1_CR2_RESET_VALUE;
  57  0006 725f5235      	clr	21045
  58                     ; 15     UART1->CR4 = UART1_CR4_RESET_VALUE;
  60  000a 725f5237      	clr	21047
  61                     ; 16     UART1->CR5 = UART1_CR5_RESET_VALUE;
  63  000e 725f5238      	clr	21048
  64                     ; 17     UART1->GTR = UART1_GTR_RESET_VALUE;
  66  0012 725f5239      	clr	21049
  67                     ; 18     UART1->PSCR = UART1_PSCR_RESET_VALUE;
  69  0016 725f523a      	clr	21050
  70                     ; 22     UART1->CR1 = (u8) 0x00 | (u8) 0x00;   // Word length = 8, no parity.
  72  001a 725f5234      	clr	21044
  73                     ; 23     UART1->CR3 = (u8) 0x00;                             // 1 stop bit.
  75  001e 725f5236      	clr	21046
  76                     ; 25     UART1->BRR1 &= (u8) (~UART1_BRR1_DIVM);
  78  0022 725f5232      	clr	21042
  79                     ; 26     UART1->BRR2 &= (u8) (~UART1_BRR2_DIVM);
  81  0026 c65233        	ld	a,21043
  82  0029 a40f          	and	a,#15
  83  002b c75233        	ld	21043,a
  84                     ; 27     UART1->BRR2 &= (u8) (~UART1_BRR2_DIVF);
  86  002e c65233        	ld	a,21043
  87  0031 a4f0          	and	a,#240
  88  0033 c75233        	ld	21043,a
  89                     ; 31     UART1->BRR2 = 0x0b;
  91  0036 350b5233      	mov	21043,#11
  92                     ; 32     UART1->BRR1 = 0x08;
  94  003a 35085232      	mov	21042,#8
  95                     ; 36     UART1->CR2 &= (u8) ~(UART1_CR2_TEN | UART1_CR2_REN);
  97  003e c65235        	ld	a,21045
  98  0041 a4f3          	and	a,#243
  99  0043 c75235        	ld	21045,a
 100                     ; 40     UART1->CR3 &= (u8)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL);
 102  0046 c65236        	ld	a,21046
 103  0049 a4f8          	and	a,#248
 104  004b c75236        	ld	21046,a
 105                     ; 44     UART1->CR3 |= (u8)((u8) 0x08 &
 105                     ; 45                        (u8) (UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL));
 107  004e c65236        	ld	a,21046
 108                     ; 49     UART1->CR2 |= (u8) ((u8) UART1_CR2_TEN | (u8) UART1_CR2_REN);
 110  0051 c65235        	ld	a,21045
 111  0054 aa0c          	or	a,#12
 112  0056 c75235        	ld	21045,a
 113                     ; 50     UART1->CR3 &= (u8) (~UART1_CR3_CKEN);
 115  0059 72175236      	bres	21046,#3
 116                     ; 51 }
 119  005d 81            	ret
 154                     ; 53 @far @interrupt void UARTInterruptHandle (void)
 154                     ; 54 {
 156                     	switch	.text
 157  005e               f_UARTInterruptHandle:
 159       00000001      OFST:	set	1
 160  005e 88            	push	a
 163                     ; 56     recd = UART1->DR;
 165  005f c65231        	ld	a,21041
 166                     ; 58 }
 169  0062 84            	pop	a
 170  0063 80            	iret
 203                     ; 60 void uart_write(unsigned char c) {
 205                     	switch	.text
 206  0064               _uart_write:
 210                     ; 62         UART1->DR = c;
 212  0064 c75231        	ld	21041,a
 213                     ; 66 }
 216  0067 81            	ret
 229                     	xdef	f_UARTInterruptHandle
 230                     	xdef	_uart_write
 231                     	xdef	_InitialiseUART
 250                     	end
