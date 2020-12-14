   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
 126                     ; 11 bool SetTimeRTC(time_t *t)
 126                     ; 12 {
 128                     	switch	.text
 129  0000               _SetTimeRTC:
 133                     ; 23     return TRUE;
 135  0000 a601          	ld	a,#1
 138  0002 81            	ret
 141                     .const:	section	.text
 142  0000               L16_rx_buff:
 143  0000 00            	dc.b	0
 144  0001 000000000000  	ds.b	6
 182                     ; 25 bool ReadTimeRTC(void)
 182                     ; 26 {
 183                     	switch	.text
 184  0003               _ReadTimeRTC:
 186  0003 5207          	subw	sp,#7
 187       00000007      OFST:	set	7
 190                     ; 28     u8 rx_buff[7]={0};
 192  0005 96            	ldw	x,sp
 193  0006 1c0001        	addw	x,#OFST-6
 194  0009 90ae0000      	ldw	y,#L16_rx_buff
 195  000d a607          	ld	a,#7
 196  000f cd0000        	call	c_xymvx
 198                     ; 29     set_tout_ms(10);
 200  0012 ae000a        	ldw	x,#10
 201  0015 bf00          	ldw	_TIM4_tout,x
 202                     ; 30     I2C_ReadRegister(0,7,rx_buff);
 205  0017 96            	ldw	x,sp
 206  0018 1c0001        	addw	x,#OFST-6
 207  001b 89            	pushw	x
 208  001c ae0007        	ldw	x,#7
 209  001f cd0000        	call	_I2C_ReadRegister
 211  0022 85            	popw	x
 212                     ; 31     if(!BufferToTime(&time_now,rx_buff))
 214  0023 96            	ldw	x,sp
 215  0024 1c0001        	addw	x,#OFST-6
 216  0027 89            	pushw	x
 217  0028 ae0000        	ldw	x,#_time_now
 218  002b ad0c          	call	_BufferToTime
 220  002d 85            	popw	x
 221  002e 4d            	tnz	a
 222  002f 2603          	jrne	L101
 223                     ; 32         return FALSE;
 225  0031 4f            	clr	a
 227  0032 2002          	jra	L01
 228  0034               L101:
 229                     ; 33     return TRUE;
 231  0034 a601          	ld	a,#1
 233  0036               L01:
 235  0036 5b07          	addw	sp,#7
 236  0038 81            	ret
 285                     ; 38 bool BufferToTime(time_t *t,u8 *buf)
 285                     ; 39 {
 286                     	switch	.text
 287  0039               _BufferToTime:
 289  0039 89            	pushw	x
 290       00000000      OFST:	set	0
 293                     ; 40     if(!(buf[0] & 0b10000000))              //Oscillator Stopped
 295  003a 1e05          	ldw	x,(OFST+5,sp)
 296  003c f6            	ld	a,(x)
 297  003d a580          	bcp	a,#128
 298  003f 2603          	jrne	L721
 299                     ; 42         return FALSE;
 301  0041 4f            	clr	a
 303  0042 204c          	jra	L41
 304  0044               L721:
 305                     ; 45     t->Second=bcd2dec((buf[0]&0x7F));
 307  0044 1e05          	ldw	x,(OFST+5,sp)
 308  0046 f6            	ld	a,(x)
 309  0047 a47f          	and	a,#127
 310  0049 ad47          	call	_bcd2dec
 312  004b 1e01          	ldw	x,(OFST+1,sp)
 313  004d f7            	ld	(x),a
 314                     ; 46     t->Minute=bcd2dec((buf[1]&0x7F));
 316  004e 1e05          	ldw	x,(OFST+5,sp)
 317  0050 e601          	ld	a,(1,x)
 318  0052 a47f          	and	a,#127
 319  0054 ad3c          	call	_bcd2dec
 321  0056 1e01          	ldw	x,(OFST+1,sp)
 322  0058 e701          	ld	(1,x),a
 323                     ; 47     t->Hour  =bcd2dec((buf[2]&0x3F));
 325  005a 1e05          	ldw	x,(OFST+5,sp)
 326  005c e602          	ld	a,(2,x)
 327  005e a43f          	and	a,#63
 328  0060 ad30          	call	_bcd2dec
 330  0062 1e01          	ldw	x,(OFST+1,sp)
 331  0064 e702          	ld	(2,x),a
 332                     ; 48     t->Date=bcd2dec((buf[4]&0x3F));
 334  0066 1e05          	ldw	x,(OFST+5,sp)
 335  0068 e604          	ld	a,(4,x)
 336  006a a43f          	and	a,#63
 337  006c ad24          	call	_bcd2dec
 339  006e 1e01          	ldw	x,(OFST+1,sp)
 340  0070 e703          	ld	(3,x),a
 341                     ; 49     t->Month=bcd2dec((buf[5]&0x1F));
 343  0072 1e05          	ldw	x,(OFST+5,sp)
 344  0074 e605          	ld	a,(5,x)
 345  0076 a41f          	and	a,#31
 346  0078 ad18          	call	_bcd2dec
 348  007a 1e01          	ldw	x,(OFST+1,sp)
 349  007c e704          	ld	(4,x),a
 350                     ; 50     t->Year=bcd2dec(buf[6])+2000;
 352  007e 1e05          	ldw	x,(OFST+5,sp)
 353  0080 e606          	ld	a,(6,x)
 354  0082 ad0e          	call	_bcd2dec
 356  0084 5f            	clrw	x
 357  0085 97            	ld	xl,a
 358  0086 1c07d0        	addw	x,#2000
 359  0089 1601          	ldw	y,(OFST+1,sp)
 360  008b 90ef05        	ldw	(5,y),x
 361                     ; 52     return TRUE;
 363  008e a601          	ld	a,#1
 365  0090               L41:
 367  0090 85            	popw	x
 368  0091 81            	ret
 402                     ; 58 u8 bcd2dec(u8 num)
 402                     ; 59 {
 403                     	switch	.text
 404  0092               _bcd2dec:
 406  0092 88            	push	a
 407  0093 88            	push	a
 408       00000001      OFST:	set	1
 411                     ; 60     return ((num/16 * 10) + (num % 16));
 413  0094 a40f          	and	a,#15
 414  0096 6b01          	ld	(OFST+0,sp),a
 416  0098 7b02          	ld	a,(OFST+1,sp)
 417  009a 5f            	clrw	x
 418  009b 97            	ld	xl,a
 419  009c 57            	sraw	x
 420  009d 57            	sraw	x
 421  009e 57            	sraw	x
 422  009f 57            	sraw	x
 423  00a0 a60a          	ld	a,#10
 424  00a2 cd0000        	call	c_bmulx
 426  00a5 01            	rrwa	x,a
 427  00a6 1b01          	add	a,(OFST+0,sp)
 428  00a8 2401          	jrnc	L02
 429  00aa 5c            	incw	x
 430  00ab               L02:
 433  00ab 85            	popw	x
 434  00ac 81            	ret
 468                     ; 67 u8 dec2bcd(u8 num)
 468                     ; 68 {
 469                     	switch	.text
 470  00ad               _dec2bcd:
 472  00ad 88            	push	a
 473  00ae 88            	push	a
 474       00000001      OFST:	set	1
 477                     ; 69     return ((num/10 * 16) + (num % 10));
 479  00af 5f            	clrw	x
 480  00b0 97            	ld	xl,a
 481  00b1 a60a          	ld	a,#10
 482  00b3 62            	div	x,a
 483  00b4 5f            	clrw	x
 484  00b5 97            	ld	xl,a
 485  00b6 9f            	ld	a,xl
 486  00b7 6b01          	ld	(OFST+0,sp),a
 488  00b9 7b02          	ld	a,(OFST+1,sp)
 489  00bb 5f            	clrw	x
 490  00bc 97            	ld	xl,a
 491  00bd a60a          	ld	a,#10
 492  00bf 62            	div	x,a
 493  00c0 9f            	ld	a,xl
 494  00c1 97            	ld	xl,a
 495  00c2 a610          	ld	a,#16
 496  00c4 42            	mul	x,a
 497  00c5 9f            	ld	a,xl
 498  00c6 1b01          	add	a,(OFST+0,sp)
 501  00c8 85            	popw	x
 502  00c9 81            	ret
 539                     ; 72 bool Verify_RTC(void)
 539                     ; 73 {
 540                     	switch	.text
 541  00ca               _Verify_RTC:
 543  00ca 88            	push	a
 544       00000001      OFST:	set	1
 547                     ; 74     u8 val=0;
 549  00cb 0f01          	clr	(OFST+0,sp)
 551                     ; 75     set_tout_ms(10);
 553  00cd ae000a        	ldw	x,#10
 554  00d0 bf00          	ldw	_TIM4_tout,x
 555                     ; 76     I2C_ReadRegister(0x03,1,&val);
 558  00d2 96            	ldw	x,sp
 559  00d3 1c0001        	addw	x,#OFST+0
 560  00d6 89            	pushw	x
 561  00d7 ae0301        	ldw	x,#769
 562  00da cd0000        	call	_I2C_ReadRegister
 564  00dd 85            	popw	x
 565                     ; 78     if(!(val & 0b00100000))         //Oscillator Stopped
 567  00de 7b01          	ld	a,(OFST+0,sp)
 568  00e0 a520          	bcp	a,#32
 569  00e2 2604          	jrne	L302
 570                     ; 79         return FALSE;
 572  00e4 4f            	clr	a
 575  00e5 5b01          	addw	sp,#1
 576  00e7 81            	ret
 577  00e8               L302:
 578                     ; 80     if((val & 0b00010000))          //Power Failed
 580  00e8 7b01          	ld	a,(OFST+0,sp)
 581  00ea a510          	bcp	a,#16
 582  00ec 2704          	jreq	L502
 583                     ; 81         return FALSE;
 585  00ee 4f            	clr	a
 588  00ef 5b01          	addw	sp,#1
 589  00f1 81            	ret
 590  00f2               L502:
 591                     ; 82     if(!(val & 0b00001000))         //Ext Power Not Enabled
 593  00f2 7b01          	ld	a,(OFST+0,sp)
 594  00f4 a508          	bcp	a,#8
 595  00f6 2604          	jrne	L702
 596                     ; 83         return FALSE;
 598  00f8 4f            	clr	a
 601  00f9 5b01          	addw	sp,#1
 602  00fb 81            	ret
 603  00fc               L702:
 604                     ; 84     set_tout_ms(10);
 606  00fc ae000a        	ldw	x,#10
 607  00ff bf00          	ldw	_TIM4_tout,x
 608                     ; 85     I2C_ReadRegister(0x02,1,&val);
 611  0101 96            	ldw	x,sp
 612  0102 1c0001        	addw	x,#OFST+0
 613  0105 89            	pushw	x
 614  0106 ae0201        	ldw	x,#513
 615  0109 cd0000        	call	_I2C_ReadRegister
 617  010c 85            	popw	x
 618                     ; 86     if(val & 0b01000000)
 620  010d 7b01          	ld	a,(OFST+0,sp)
 621  010f a540          	bcp	a,#64
 622  0111 2704          	jreq	L112
 623                     ; 87         return FALSE;
 625  0113 4f            	clr	a
 628  0114 5b01          	addw	sp,#1
 629  0116 81            	ret
 630  0117               L112:
 631                     ; 89     return TRUE;
 633  0117 a601          	ld	a,#1
 636  0119 5b01          	addw	sp,#1
 637  011b 81            	ret
 677                     ; 91 bool Setup_RTC_Chip(void)
 677                     ; 92 {
 678                     	switch	.text
 679  011c               _Setup_RTC_Chip:
 681  011c 88            	push	a
 682       00000001      OFST:	set	1
 685                     ; 93 		u8 val=0;
 687  011d 0f01          	clr	(OFST+0,sp)
 689                     ; 94     RTC_Start();
 691  011f ad5c          	call	_RTC_Start
 693                     ; 96     set_tout_ms(10);
 695  0121 ae000a        	ldw	x,#10
 696  0124 bf00          	ldw	_TIM4_tout,x
 697                     ; 97     I2C_ReadRegister(0x03,1,&val);
 700  0126 96            	ldw	x,sp
 701  0127 1c0001        	addw	x,#OFST+0
 702  012a 89            	pushw	x
 703  012b ae0301        	ldw	x,#769
 704  012e cd0000        	call	_I2C_ReadRegister
 706  0131 85            	popw	x
 707                     ; 99     val|=(0b00001000);              //Enable Ext Power
 709  0132 7b01          	ld	a,(OFST+0,sp)
 710  0134 aa08          	or	a,#8
 711  0136 6b01          	ld	(OFST+0,sp),a
 713                     ; 100     val&=(0b11101111);              //Clear Power Failed bit
 715  0138 7b01          	ld	a,(OFST+0,sp)
 716  013a a4ef          	and	a,#239
 717  013c 6b01          	ld	(OFST+0,sp),a
 719                     ; 101     set_tout_ms(10);
 721  013e ae000a        	ldw	x,#10
 722  0141 bf00          	ldw	_TIM4_tout,x
 723                     ; 102     I2C_WriteRegister(0x03,1,&val);
 726  0143 96            	ldw	x,sp
 727  0144 1c0001        	addw	x,#OFST+0
 728  0147 89            	pushw	x
 729  0148 ae0301        	ldw	x,#769
 730  014b cd0000        	call	_I2C_WriteRegister
 732  014e 85            	popw	x
 733                     ; 103     set_tout_ms(10);
 735  014f ae000a        	ldw	x,#10
 736  0152 bf00          	ldw	_TIM4_tout,x
 737                     ; 104     I2C_ReadRegister(0x02,1,&val);
 740  0154 96            	ldw	x,sp
 741  0155 1c0001        	addw	x,#OFST+0
 742  0158 89            	pushw	x
 743  0159 ae0201        	ldw	x,#513
 744  015c cd0000        	call	_I2C_ReadRegister
 746  015f 85            	popw	x
 747                     ; 105     val&=(0b10111111);
 749  0160 7b01          	ld	a,(OFST+0,sp)
 750  0162 a4bf          	and	a,#191
 751  0164 6b01          	ld	(OFST+0,sp),a
 753                     ; 106     set_tout_ms(10);
 755  0166 ae000a        	ldw	x,#10
 756  0169 bf00          	ldw	_TIM4_tout,x
 757                     ; 107     I2C_WriteRegister(0x02,1,&val);
 760  016b 96            	ldw	x,sp
 761  016c 1c0001        	addw	x,#OFST+0
 762  016f 89            	pushw	x
 763  0170 ae0201        	ldw	x,#513
 764  0173 cd0000        	call	_I2C_WriteRegister
 766  0176 85            	popw	x
 767                     ; 109     return Verify_RTC();
 769  0177 cd00ca        	call	_Verify_RTC
 773  017a 5b01          	addw	sp,#1
 774  017c 81            	ret
 811                     ; 111 void RTC_Start(void)
 811                     ; 112 {
 812                     	switch	.text
 813  017d               _RTC_Start:
 815  017d 88            	push	a
 816       00000001      OFST:	set	1
 819                     ; 113     u8 val=0;
 821  017e 0f01          	clr	(OFST+0,sp)
 823                     ; 114     set_tout_ms(10);
 825  0180 ae000a        	ldw	x,#10
 826  0183 bf00          	ldw	_TIM4_tout,x
 827                     ; 115     I2C_ReadRegister(0,1,&val);
 830  0185 96            	ldw	x,sp
 831  0186 1c0001        	addw	x,#OFST+0
 832  0189 89            	pushw	x
 833  018a ae0001        	ldw	x,#1
 834  018d cd0000        	call	_I2C_ReadRegister
 836  0190 85            	popw	x
 837                     ; 116     val=val|0b10000000;
 839  0191 7b01          	ld	a,(OFST+0,sp)
 840  0193 aa80          	or	a,#128
 841  0195 6b01          	ld	(OFST+0,sp),a
 843                     ; 117     set_tout_ms(10);
 845  0197 ae000a        	ldw	x,#10
 846  019a bf00          	ldw	_TIM4_tout,x
 847                     ; 118     I2C_WriteRegister(0,1,&val);
 850  019c 96            	ldw	x,sp
 851  019d 1c0001        	addw	x,#OFST+0
 852  01a0 89            	pushw	x
 853  01a1 ae0001        	ldw	x,#1
 854  01a4 cd0000        	call	_I2C_WriteRegister
 856  01a7 85            	popw	x
 857                     ; 119 }
 860  01a8 84            	pop	a
 861  01a9 81            	ret
 898                     ; 120 void RTC_Stop(void)
 898                     ; 121 {
 899                     	switch	.text
 900  01aa               _RTC_Stop:
 902  01aa 88            	push	a
 903       00000001      OFST:	set	1
 906                     ; 122     u8 val=0;
 908  01ab 0f01          	clr	(OFST+0,sp)
 910                     ; 123     set_tout_ms(10);
 912  01ad ae000a        	ldw	x,#10
 913  01b0 bf00          	ldw	_TIM4_tout,x
 914                     ; 124     I2C_ReadRegister(0,1,&val);
 917  01b2 96            	ldw	x,sp
 918  01b3 1c0001        	addw	x,#OFST+0
 919  01b6 89            	pushw	x
 920  01b7 ae0001        	ldw	x,#1
 921  01ba cd0000        	call	_I2C_ReadRegister
 923  01bd 85            	popw	x
 924                     ; 125     val=val&0b01111111;
 926  01be 7b01          	ld	a,(OFST+0,sp)
 927  01c0 a47f          	and	a,#127
 928  01c2 6b01          	ld	(OFST+0,sp),a
 930                     ; 126     set_tout_ms(10);
 932  01c4 ae000a        	ldw	x,#10
 933  01c7 bf00          	ldw	_TIM4_tout,x
 934                     ; 127     I2C_WriteRegister(0,1,&val);
 937  01c9 96            	ldw	x,sp
 938  01ca 1c0001        	addw	x,#OFST+0
 939  01cd 89            	pushw	x
 940  01ce ae0001        	ldw	x,#1
 941  01d1 cd0000        	call	_I2C_WriteRegister
 943  01d4 85            	popw	x
 944                     ; 128 }
 947  01d5 84            	pop	a
 948  01d6 81            	ret
 995                     ; 129 bool SetInternalTime(u8* time_buf)
 995                     ; 130 {
 996                     	switch	.text
 997  01d7               _SetInternalTime:
 999  01d7 5207          	subw	sp,#7
1000       00000007      OFST:	set	7
1003                     ; 133     new_time.Second =time_buf[0];
1005  01d9 f6            	ld	a,(x)
1006  01da 6b01          	ld	(OFST-6,sp),a
1008                     ; 134     new_time.Minute =time_buf[1];
1010  01dc e601          	ld	a,(1,x)
1011  01de 6b02          	ld	(OFST-5,sp),a
1013                     ; 135     new_time.Hour   =time_buf[2];
1015  01e0 e602          	ld	a,(2,x)
1016  01e2 6b03          	ld	(OFST-4,sp),a
1018                     ; 136     new_time.Date   =time_buf[3];
1020  01e4 e603          	ld	a,(3,x)
1021  01e6 6b04          	ld	(OFST-3,sp),a
1023                     ; 137     new_time.Month  =time_buf[4];
1025  01e8 e604          	ld	a,(4,x)
1026  01ea 6b05          	ld	(OFST-2,sp),a
1028                     ; 138     new_time.Year   =time_buf[5]+2000;
1030  01ec e605          	ld	a,(5,x)
1031  01ee 5f            	clrw	x
1032  01ef 97            	ld	xl,a
1033  01f0 1c07d0        	addw	x,#2000
1034  01f3 1f06          	ldw	(OFST-1,sp),x
1036                     ; 140     return SetTimeRTC(&new_time);
1038  01f5 96            	ldw	x,sp
1039  01f6 1c0001        	addw	x,#OFST-6
1040  01f9 cd0000        	call	_SetTimeRTC
1044  01fc 5b07          	addw	sp,#7
1045  01fe 81            	ret
1070                     	xdef	_SetInternalTime
1071                     	xdef	_RTC_Stop
1072                     	xdef	_RTC_Start
1073                     	xdef	_Setup_RTC_Chip
1074                     	xdef	_Verify_RTC
1075                     	xdef	_bcd2dec
1076                     	xdef	_dec2bcd
1077                     	xdef	_BufferToTime
1078                     	xdef	_ReadTimeRTC
1079                     	xdef	_SetTimeRTC
1080                     	switch	.ubsct
1081  0000               _time_now:
1082  0000 000000000000  	ds.b	7
1083                     	xdef	_time_now
1084                     	xref.b	_TIM4_tout
1085                     	xref	_I2C_WriteRegister
1086                     	xref	_I2C_ReadRegister
1087                     	xref.b	c_x
1107                     	xref	c_bmulx
1108                     	xref	c_xymvx
1109                     	end
