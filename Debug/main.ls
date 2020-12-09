   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  14                     .const:	section	.text
  15  0000               _DUMMY_INIT:
  16  0000 10            	dc.b	16
  17  0001 20            	dc.b	32
  18  0002 30            	dc.b	48
  19  0003 40            	dc.b	64
  20  0004 50            	dc.b	80
  21  0005 60            	dc.b	96
  22  0006 70            	dc.b	112
  23  0007 80            	dc.b	128
  24  0008 90            	dc.b	144
  25  0009 a0            	dc.b	160
  63                     ; 37 void main (void) { 
  65                     	switch	.text
  66  0000               _main:
  70                     ; 39   CLK->CKDIVR = 0x01;             // sys clock / 2
  72  0000 350150c6      	mov	20678,#1
  73                     ; 42   GPIOH->DDR |=  0x0F;            
  75  0004 c65025        	ld	a,20517
  76  0007 aa0f          	or	a,#15
  77  0009 c75025        	ld	20517,a
  78                     ; 43   GPIOH->CR1 |=  0x0F;            
  80  000c c65026        	ld	a,20518
  81  000f aa0f          	or	a,#15
  82  0011 c75026        	ld	20518,a
  83                     ; 46   TIM4_Init();                    
  85  0014 cd0000        	call	_TIM4_Init
  87                     ; 49 	I2C_Init();                     
  89  0017 cd0000        	call	_I2C_Init
  91                     ; 52   memcpy(Dummy, DUMMY_INIT, MAX_DUMMY);
  93  001a ae000a        	ldw	x,#10
  94  001d               L6:
  95  001d d6ffff        	ld	a,(_DUMMY_INIT-1,x)
  96  0020 e7ff          	ld	(_Dummy-1,x),a
  97  0022 5a            	decw	x
  98  0023 26f8          	jrne	L6
  99                     ; 55 	enableInterrupts();
 102  0025 9a            rim
 104  0026               L12:
 105                     ; 60     set_tout_ms(10);
 107  0026 ae000a        	ldw	x,#10
 108  0029 bf0a          	ldw	_TIM4_tout,x
 109                     ; 61     I2C_WriteRegister(8, 1, &Dummy[8]);
 112  002b ae0008        	ldw	x,#_Dummy+8
 113  002e 89            	pushw	x
 114  002f ae0801        	ldw	x,#2049
 115  0032 cd0000        	call	_I2C_WriteRegister
 117  0035 85            	popw	x
 118                     ; 62     I2C_ReadRegister(0, 2, &Dummy[0]);
 120  0036 ae0000        	ldw	x,#_Dummy
 121  0039 89            	pushw	x
 122  003a ae0002        	ldw	x,#2
 123  003d cd0000        	call	_I2C_ReadRegister
 125  0040 85            	popw	x
 126                     ; 64     switch_on(LED2);
 128  0041 72145023      	bset	20515,#2
 129                     ; 65     delay(1);
 132  0045 ae0001        	ldw	x,#1
 133  0048 bf0a          	ldw	_TIM4_tout,x
 135  004a               L13:
 138  004a be0a          	ldw	x,_TIM4_tout
 139  004c 26fc          	jrne	L13
 140                     ; 66     switch_off(LED2);
 143  004e 72155023      	bres	20515,#2
 144                     ; 67     delay(1);
 147  0052 ae0001        	ldw	x,#1
 148  0055 bf0a          	ldw	_TIM4_tout,x
 150  0057               L14:
 153  0057 be0a          	ldw	x,_TIM4_tout
 154  0059 26fc          	jrne	L14
 157  005b 20c9          	jra	L12
 201                     	xdef	_main
 202                     	switch	.ubsct
 203  0000               _Dummy:
 204  0000 000000000000  	ds.b	10
 205                     	xdef	_Dummy
 206                     	xdef	_DUMMY_INIT
 207  000a               _TIM4_tout:
 208  000a 0000          	ds.b	2
 209                     	xdef	_TIM4_tout
 210                     	xref	_I2C_WriteRegister
 211                     	xref	_I2C_ReadRegister
 212                     	xref	_TIM4_Init
 213                     	xref	_I2C_Init
 233                     	end
