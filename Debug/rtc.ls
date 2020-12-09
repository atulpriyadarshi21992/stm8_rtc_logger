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
 303  0042 2048          	jra	L41
 304  0044               L721:
 305                     ; 45     t->Second=bcd2dec((buf[0]&0x7F));
 307  0044 1e05          	ldw	x,(OFST+5,sp)
 308  0046 f6            	ld	a,(x)
 309  0047 a47f          	and	a,#127
 310  0049 ad43          	call	_bcd2dec
 312  004b 1e01          	ldw	x,(OFST+1,sp)
 313  004d f7            	ld	(x),a
 314                     ; 46     t->Minute=bcd2dec((buf[1]&0x7F));
 316  004e 1e05          	ldw	x,(OFST+5,sp)
 317  0050 e601          	ld	a,(1,x)
 318  0052 a47f          	and	a,#127
 319  0054 ad38          	call	_bcd2dec
 321  0056 1e01          	ldw	x,(OFST+1,sp)
 322  0058 e701          	ld	(1,x),a
 323                     ; 47     t->Hour  =bcd2dec((buf[2]&0x3F));
 325  005a 1e05          	ldw	x,(OFST+5,sp)
 326  005c e602          	ld	a,(2,x)
 327  005e a43f          	and	a,#63
 328  0060 ad2c          	call	_bcd2dec
 330  0062 1e01          	ldw	x,(OFST+1,sp)
 331  0064 e702          	ld	(2,x),a
 332                     ; 48     t->Date=bcd2dec((buf[4]&0x3F));
 334  0066 1e05          	ldw	x,(OFST+5,sp)
 335  0068 e604          	ld	a,(4,x)
 336  006a a43f          	and	a,#63
 337  006c ad20          	call	_bcd2dec
 339  006e 1e01          	ldw	x,(OFST+1,sp)
 340  0070 e703          	ld	(3,x),a
 341                     ; 49     t->Month=bcd2dec((buf[5]&0x1F));
 343  0072 1e05          	ldw	x,(OFST+5,sp)
 344  0074 e605          	ld	a,(5,x)
 345  0076 a41f          	and	a,#31
 346  0078 ad14          	call	_bcd2dec
 348  007a 1e01          	ldw	x,(OFST+1,sp)
 349  007c e704          	ld	(4,x),a
 350                     ; 50     t->Year=bcd2dec(buf[6])+2000;
 352  007e 1e05          	ldw	x,(OFST+5,sp)
 353  0080 e606          	ld	a,(6,x)
 354  0082 ad0a          	call	_bcd2dec
 356  0084 abd0          	add	a,#208
 357  0086 1e01          	ldw	x,(OFST+1,sp)
 358  0088 e705          	ld	(5,x),a
 359                     ; 52     return TRUE;
 361  008a a601          	ld	a,#1
 363  008c               L41:
 365  008c 85            	popw	x
 366  008d 81            	ret
 400                     ; 58 u8 bcd2dec(u8 num)
 400                     ; 59 {
 401                     	switch	.text
 402  008e               _bcd2dec:
 404  008e 88            	push	a
 405  008f 88            	push	a
 406       00000001      OFST:	set	1
 409                     ; 60     return ((num/16 * 10) + (num % 16));
 411  0090 a40f          	and	a,#15
 412  0092 6b01          	ld	(OFST+0,sp),a
 414  0094 7b02          	ld	a,(OFST+1,sp)
 415  0096 5f            	clrw	x
 416  0097 97            	ld	xl,a
 417  0098 57            	sraw	x
 418  0099 57            	sraw	x
 419  009a 57            	sraw	x
 420  009b 57            	sraw	x
 421  009c a60a          	ld	a,#10
 422  009e cd0000        	call	c_bmulx
 424  00a1 01            	rrwa	x,a
 425  00a2 1b01          	add	a,(OFST+0,sp)
 426  00a4 2401          	jrnc	L02
 427  00a6 5c            	incw	x
 428  00a7               L02:
 431  00a7 85            	popw	x
 432  00a8 81            	ret
 466                     ; 67 u8 dec2bcd(u8 num)
 466                     ; 68 {
 467                     	switch	.text
 468  00a9               _dec2bcd:
 470  00a9 88            	push	a
 471  00aa 88            	push	a
 472       00000001      OFST:	set	1
 475                     ; 69     return ((num/10 * 16) + (num % 10));
 477  00ab 5f            	clrw	x
 478  00ac 97            	ld	xl,a
 479  00ad a60a          	ld	a,#10
 480  00af 62            	div	x,a
 481  00b0 5f            	clrw	x
 482  00b1 97            	ld	xl,a
 483  00b2 9f            	ld	a,xl
 484  00b3 6b01          	ld	(OFST+0,sp),a
 486  00b5 7b02          	ld	a,(OFST+1,sp)
 487  00b7 5f            	clrw	x
 488  00b8 97            	ld	xl,a
 489  00b9 a60a          	ld	a,#10
 490  00bb 62            	div	x,a
 491  00bc 9f            	ld	a,xl
 492  00bd 97            	ld	xl,a
 493  00be a610          	ld	a,#16
 494  00c0 42            	mul	x,a
 495  00c1 9f            	ld	a,xl
 496  00c2 1b01          	add	a,(OFST+0,sp)
 499  00c4 85            	popw	x
 500  00c5 81            	ret
 537                     ; 72 bool Verify_RTC(void)
 537                     ; 73 {
 538                     	switch	.text
 539  00c6               _Verify_RTC:
 541  00c6 88            	push	a
 542       00000001      OFST:	set	1
 545                     ; 74     u8 val=0;
 547  00c7 0f01          	clr	(OFST+0,sp)
 549                     ; 75     set_tout_ms(10);
 551  00c9 ae000a        	ldw	x,#10
 552  00cc bf00          	ldw	_TIM4_tout,x
 553                     ; 76     I2C_ReadRegister(0x03,1,&val);
 556  00ce 96            	ldw	x,sp
 557  00cf 1c0001        	addw	x,#OFST+0
 558  00d2 89            	pushw	x
 559  00d3 ae0301        	ldw	x,#769
 560  00d6 cd0000        	call	_I2C_ReadRegister
 562  00d9 85            	popw	x
 563                     ; 78     if(!(val & 0b00100000))         //Oscillator Stopped
 565  00da 7b01          	ld	a,(OFST+0,sp)
 566  00dc a520          	bcp	a,#32
 567  00de 2604          	jrne	L302
 568                     ; 79         return FALSE;
 570  00e0 4f            	clr	a
 573  00e1 5b01          	addw	sp,#1
 574  00e3 81            	ret
 575  00e4               L302:
 576                     ; 80     if((val & 0b00010000))          //Power Failed
 578  00e4 7b01          	ld	a,(OFST+0,sp)
 579  00e6 a510          	bcp	a,#16
 580  00e8 2704          	jreq	L502
 581                     ; 81         return FALSE;
 583  00ea 4f            	clr	a
 586  00eb 5b01          	addw	sp,#1
 587  00ed 81            	ret
 588  00ee               L502:
 589                     ; 82     if(!(val & 0b00001000))         //Ext Power Not Enabled
 591  00ee 7b01          	ld	a,(OFST+0,sp)
 592  00f0 a508          	bcp	a,#8
 593  00f2 2604          	jrne	L702
 594                     ; 83         return FALSE;
 596  00f4 4f            	clr	a
 599  00f5 5b01          	addw	sp,#1
 600  00f7 81            	ret
 601  00f8               L702:
 602                     ; 84     set_tout_ms(10);
 604  00f8 ae000a        	ldw	x,#10
 605  00fb bf00          	ldw	_TIM4_tout,x
 606                     ; 85     I2C_ReadRegister(0x02,1,&val);
 609  00fd 96            	ldw	x,sp
 610  00fe 1c0001        	addw	x,#OFST+0
 611  0101 89            	pushw	x
 612  0102 ae0201        	ldw	x,#513
 613  0105 cd0000        	call	_I2C_ReadRegister
 615  0108 85            	popw	x
 616                     ; 86     if(val & 0b01000000)
 618  0109 7b01          	ld	a,(OFST+0,sp)
 619  010b a540          	bcp	a,#64
 620  010d 2704          	jreq	L112
 621                     ; 87         return FALSE;
 623  010f 4f            	clr	a
 626  0110 5b01          	addw	sp,#1
 627  0112 81            	ret
 628  0113               L112:
 629                     ; 89     return TRUE;
 631  0113 a601          	ld	a,#1
 634  0115 5b01          	addw	sp,#1
 635  0117 81            	ret
 675                     ; 91 bool Setup_RTC_Chip(void)
 675                     ; 92 {
 676                     	switch	.text
 677  0118               _Setup_RTC_Chip:
 679  0118 88            	push	a
 680       00000001      OFST:	set	1
 683                     ; 93 		u8 val=0;
 685  0119 0f01          	clr	(OFST+0,sp)
 687                     ; 94     RTC_Start();
 689  011b ad5c          	call	_RTC_Start
 691                     ; 96     set_tout_ms(10);
 693  011d ae000a        	ldw	x,#10
 694  0120 bf00          	ldw	_TIM4_tout,x
 695                     ; 97     I2C_ReadRegister(0x03,1,&val);
 698  0122 96            	ldw	x,sp
 699  0123 1c0001        	addw	x,#OFST+0
 700  0126 89            	pushw	x
 701  0127 ae0301        	ldw	x,#769
 702  012a cd0000        	call	_I2C_ReadRegister
 704  012d 85            	popw	x
 705                     ; 99     val|=(0b00001000);              //Enable Ext Power
 707  012e 7b01          	ld	a,(OFST+0,sp)
 708  0130 aa08          	or	a,#8
 709  0132 6b01          	ld	(OFST+0,sp),a
 711                     ; 100     val&=(0b11101111);              //Clear Power Failed bit
 713  0134 7b01          	ld	a,(OFST+0,sp)
 714  0136 a4ef          	and	a,#239
 715  0138 6b01          	ld	(OFST+0,sp),a
 717                     ; 101     set_tout_ms(10);
 719  013a ae000a        	ldw	x,#10
 720  013d bf00          	ldw	_TIM4_tout,x
 721                     ; 102     I2C_WriteRegister(0x03,1,&val);
 724  013f 96            	ldw	x,sp
 725  0140 1c0001        	addw	x,#OFST+0
 726  0143 89            	pushw	x
 727  0144 ae0301        	ldw	x,#769
 728  0147 cd0000        	call	_I2C_WriteRegister
 730  014a 85            	popw	x
 731                     ; 103     set_tout_ms(10);
 733  014b ae000a        	ldw	x,#10
 734  014e bf00          	ldw	_TIM4_tout,x
 735                     ; 104     I2C_ReadRegister(0x02,1,&val);
 738  0150 96            	ldw	x,sp
 739  0151 1c0001        	addw	x,#OFST+0
 740  0154 89            	pushw	x
 741  0155 ae0201        	ldw	x,#513
 742  0158 cd0000        	call	_I2C_ReadRegister
 744  015b 85            	popw	x
 745                     ; 105     val&=(0b10111111);
 747  015c 7b01          	ld	a,(OFST+0,sp)
 748  015e a4bf          	and	a,#191
 749  0160 6b01          	ld	(OFST+0,sp),a
 751                     ; 106     set_tout_ms(10);
 753  0162 ae000a        	ldw	x,#10
 754  0165 bf00          	ldw	_TIM4_tout,x
 755                     ; 107     I2C_WriteRegister(0x02,1,&val);
 758  0167 96            	ldw	x,sp
 759  0168 1c0001        	addw	x,#OFST+0
 760  016b 89            	pushw	x
 761  016c ae0201        	ldw	x,#513
 762  016f cd0000        	call	_I2C_WriteRegister
 764  0172 85            	popw	x
 765                     ; 109     return Verify_RTC();
 767  0173 cd00c6        	call	_Verify_RTC
 771  0176 5b01          	addw	sp,#1
 772  0178 81            	ret
 809                     ; 111 void RTC_Start(void)
 809                     ; 112 {
 810                     	switch	.text
 811  0179               _RTC_Start:
 813  0179 88            	push	a
 814       00000001      OFST:	set	1
 817                     ; 113     u8 val=0;
 819  017a 0f01          	clr	(OFST+0,sp)
 821                     ; 114     set_tout_ms(10);
 823  017c ae000a        	ldw	x,#10
 824  017f bf00          	ldw	_TIM4_tout,x
 825                     ; 115     I2C_ReadRegister(0,1,&val);
 828  0181 96            	ldw	x,sp
 829  0182 1c0001        	addw	x,#OFST+0
 830  0185 89            	pushw	x
 831  0186 ae0001        	ldw	x,#1
 832  0189 cd0000        	call	_I2C_ReadRegister
 834  018c 85            	popw	x
 835                     ; 116     val=val|0b10000000;
 837  018d 7b01          	ld	a,(OFST+0,sp)
 838  018f aa80          	or	a,#128
 839  0191 6b01          	ld	(OFST+0,sp),a
 841                     ; 117     set_tout_ms(10);
 843  0193 ae000a        	ldw	x,#10
 844  0196 bf00          	ldw	_TIM4_tout,x
 845                     ; 118     I2C_WriteRegister(0,1,&val);
 848  0198 96            	ldw	x,sp
 849  0199 1c0001        	addw	x,#OFST+0
 850  019c 89            	pushw	x
 851  019d ae0001        	ldw	x,#1
 852  01a0 cd0000        	call	_I2C_WriteRegister
 854  01a3 85            	popw	x
 855                     ; 119 }
 858  01a4 84            	pop	a
 859  01a5 81            	ret
 896                     ; 120 void RTC_Stop(void)
 896                     ; 121 {
 897                     	switch	.text
 898  01a6               _RTC_Stop:
 900  01a6 88            	push	a
 901       00000001      OFST:	set	1
 904                     ; 122     u8 val=0;
 906  01a7 0f01          	clr	(OFST+0,sp)
 908                     ; 123     set_tout_ms(10);
 910  01a9 ae000a        	ldw	x,#10
 911  01ac bf00          	ldw	_TIM4_tout,x
 912                     ; 124     I2C_ReadRegister(0,1,&val);
 915  01ae 96            	ldw	x,sp
 916  01af 1c0001        	addw	x,#OFST+0
 917  01b2 89            	pushw	x
 918  01b3 ae0001        	ldw	x,#1
 919  01b6 cd0000        	call	_I2C_ReadRegister
 921  01b9 85            	popw	x
 922                     ; 125     val=val&0b01111111;
 924  01ba 7b01          	ld	a,(OFST+0,sp)
 925  01bc a47f          	and	a,#127
 926  01be 6b01          	ld	(OFST+0,sp),a
 928                     ; 126     set_tout_ms(10);
 930  01c0 ae000a        	ldw	x,#10
 931  01c3 bf00          	ldw	_TIM4_tout,x
 932                     ; 127     I2C_WriteRegister(0,1,&val);
 935  01c5 96            	ldw	x,sp
 936  01c6 1c0001        	addw	x,#OFST+0
 937  01c9 89            	pushw	x
 938  01ca ae0001        	ldw	x,#1
 939  01cd cd0000        	call	_I2C_WriteRegister
 941  01d0 85            	popw	x
 942                     ; 128 }
 945  01d1 84            	pop	a
 946  01d2 81            	ret
 993                     ; 129 bool SetInternalTime(u8* time_buf)
 993                     ; 130 {
 994                     	switch	.text
 995  01d3               _SetInternalTime:
 997  01d3 5206          	subw	sp,#6
 998       00000006      OFST:	set	6
1001                     ; 133     new_time.Second =time_buf[0];
1003  01d5 f6            	ld	a,(x)
1004  01d6 6b01          	ld	(OFST-5,sp),a
1006                     ; 134     new_time.Minute =time_buf[1];
1008  01d8 e601          	ld	a,(1,x)
1009  01da 6b02          	ld	(OFST-4,sp),a
1011                     ; 135     new_time.Hour   =time_buf[2];
1013  01dc e602          	ld	a,(2,x)
1014  01de 6b03          	ld	(OFST-3,sp),a
1016                     ; 136     new_time.Date   =time_buf[3];
1018  01e0 e603          	ld	a,(3,x)
1019  01e2 6b04          	ld	(OFST-2,sp),a
1021                     ; 137     new_time.Month  =time_buf[4];
1023  01e4 e604          	ld	a,(4,x)
1024  01e6 6b05          	ld	(OFST-1,sp),a
1026                     ; 138     new_time.Year   =time_buf[5]+2000;
1028  01e8 e605          	ld	a,(5,x)
1029  01ea abd0          	add	a,#208
1030  01ec 6b06          	ld	(OFST+0,sp),a
1032                     ; 140     return SetTimeRTC(&new_time);
1034  01ee 96            	ldw	x,sp
1035  01ef 1c0001        	addw	x,#OFST-5
1036  01f2 cd0000        	call	_SetTimeRTC
1040  01f5 5b06          	addw	sp,#6
1041  01f7 81            	ret
1066                     	xdef	_SetInternalTime
1067                     	xdef	_RTC_Stop
1068                     	xdef	_RTC_Start
1069                     	xdef	_Setup_RTC_Chip
1070                     	xdef	_Verify_RTC
1071                     	xdef	_bcd2dec
1072                     	xdef	_dec2bcd
1073                     	xdef	_BufferToTime
1074                     	xdef	_ReadTimeRTC
1075                     	xdef	_SetTimeRTC
1076                     	switch	.ubsct
1077  0000               _time_now:
1078  0000 000000000000  	ds.b	6
1079                     	xdef	_time_now
1080                     	xref.b	_TIM4_tout
1081                     	xref	_I2C_WriteRegister
1082                     	xref	_I2C_ReadRegister
1083                     	xref.b	c_x
1103                     	xref	c_bmulx
1104                     	xref	c_xymvx
1105                     	end
