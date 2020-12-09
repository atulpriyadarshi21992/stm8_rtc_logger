   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  48                     ; 11 void main (void) { 
  50                     	switch	.text
  51  0000               _main:
  55                     ; 13   CLK->CKDIVR = 0x01;             // sys clock / 2
  57  0000 350150c6      	mov	20678,#1
  58                     ; 16   GPIOH->DDR |=  0x0F;            
  60  0004 c65025        	ld	a,20517
  61  0007 aa0f          	or	a,#15
  62  0009 c75025        	ld	20517,a
  63                     ; 17   GPIOH->CR1 |=  0x0F;            
  65  000c c65026        	ld	a,20518
  66  000f aa0f          	or	a,#15
  67  0011 c75026        	ld	20518,a
  68                     ; 20   TIM4_Init();                    
  70  0014 cd0000        	call	_TIM4_Init
  72                     ; 23 	I2C_Init();                     
  74  0017 cd0000        	call	_I2C_Init
  76                     ; 27 	enableInterrupts();
  79  001a 9a            rim
  81                     ; 30   if(!Verify_RTC())
  84  001b cd0000        	call	_Verify_RTC
  86  001e 4d            	tnz	a
  87  001f 2603          	jrne	L32
  88                     ; 31       Setup_RTC_Chip();
  90  0021 cd0000        	call	_Setup_RTC_Chip
  92  0024               L32:
  93                     ; 37     ReadTimeRTC();
  95  0024 cd0000        	call	_ReadTimeRTC
  98  0027 20fb          	jra	L32
 122                     	xdef	_main
 123                     	xref	_Setup_RTC_Chip
 124                     	xref	_Verify_RTC
 125                     	xref	_ReadTimeRTC
 126                     	switch	.ubsct
 127  0000               _TIM4_tout:
 128  0000 0000          	ds.b	2
 129                     	xdef	_TIM4_tout
 130                     	xref	_TIM4_Init
 131                     	xref	_I2C_Init
 151                     	end
