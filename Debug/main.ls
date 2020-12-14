   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  62                     ; 12 void main (void) { 
  64                     	switch	.text
  65  0000               _main:
  67  0000 89            	pushw	x
  68       00000002      OFST:	set	2
  71                     ; 20   TIM4_Init();                    
  73  0001 cd0000        	call	_TIM4_Init
  75                     ; 23 	I2C_Init(); 
  77  0004 cd0000        	call	_I2C_Init
  79                     ; 26   InitialiseUART();                    
  81  0007 cd0000        	call	_InitialiseUART
  83                     ; 30 	enableInterrupts();
  86  000a 9a            rim
  88                     ; 33   if(!Verify_RTC())
  91  000b cd0000        	call	_Verify_RTC
  93  000e 4d            	tnz	a
  94  000f 2603          	jrne	L13
  95                     ; 34       Setup_RTC_Chip();
  97  0011 cd0000        	call	_Setup_RTC_Chip
  99  0014               L13:
 100                     ; 40     ReadTimeRTC();
 102  0014 cd0000        	call	_ReadTimeRTC
 104                     ; 42     uart_write(time_now.Year>>8);
 106  0017 b605          	ld	a,_time_now+5
 107  0019 cd0000        	call	_uart_write
 109                     ; 43     uart_write((u8)time_now.Year);
 111  001c b606          	ld	a,_time_now+6
 112  001e cd0000        	call	_uart_write
 114                     ; 44     uart_write(time_now.Month);
 116  0021 b604          	ld	a,_time_now+4
 117  0023 cd0000        	call	_uart_write
 119                     ; 45     uart_write(time_now.Date);
 121  0026 b603          	ld	a,_time_now+3
 122  0028 cd0000        	call	_uart_write
 124                     ; 46     uart_write(time_now.Hour);
 126  002b b602          	ld	a,_time_now+2
 127  002d cd0000        	call	_uart_write
 129                     ; 47     uart_write(time_now.Minute);
 131  0030 b601          	ld	a,_time_now+1
 132  0032 cd0000        	call	_uart_write
 134                     ; 48     uart_write(time_now.Second);
 136  0035 b600          	ld	a,_time_now
 137  0037 cd0000        	call	_uart_write
 139                     ; 50     for(i=0;i<32000;i++);
 141  003a 5f            	clrw	x
 142  003b 1f01          	ldw	(OFST-1,sp),x
 144  003d               L53:
 148  003d 1e01          	ldw	x,(OFST-1,sp)
 149  003f 1c0001        	addw	x,#1
 150  0042 1f01          	ldw	(OFST-1,sp),x
 154  0044 9c            	rvf
 155  0045 1e01          	ldw	x,(OFST-1,sp)
 156  0047 a37d00        	cpw	x,#32000
 157  004a 2ff1          	jrslt	L53
 159  004c 20c6          	jra	L13
 183                     	xdef	_main
 184                     	xref	_uart_write
 185                     	xref	_InitialiseUART
 186                     	xref	_Setup_RTC_Chip
 187                     	xref	_Verify_RTC
 188                     	xref	_ReadTimeRTC
 189                     	xref.b	_time_now
 190                     	switch	.ubsct
 191  0000               _TIM4_tout:
 192  0000 0000          	ds.b	2
 193                     	xdef	_TIM4_tout
 194                     	xref	_TIM4_Init
 195                     	xref	_I2C_Init
 215                     	end
