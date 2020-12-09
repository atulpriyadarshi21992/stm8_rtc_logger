   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  42                     ; 30 void I2C_Init(void) {
  44                     	switch	.text
  45  0000               _I2C_Init:
  49                     ; 31   GPIOE->ODR |= 6;                //define SDA, SCL outputs, HiZ, Open drain, Fast
  51  0000 c65014        	ld	a,20500
  52  0003 aa06          	or	a,#6
  53  0005 c75014        	ld	20500,a
  54                     ; 32   GPIOE->DDR |= 6;
  56  0008 c65016        	ld	a,20502
  57  000b aa06          	or	a,#6
  58  000d c75016        	ld	20502,a
  59                     ; 33   GPIOE->CR2 |= 6;
  61  0010 c65018        	ld	a,20504
  62  0013 aa06          	or	a,#6
  63  0015 c75018        	ld	20504,a
  64                     ; 35   I2C->FREQR = 8;                // input clock to I2C - 8MHz
  66  0018 35085212      	mov	21010,#8
  67                     ; 36   I2C->CCRL = 40;                // CCR= 40 - (SCLhi must be at least 4000+1000=5000ns!)
  69  001c 3528521b      	mov	21019,#40
  70                     ; 37   I2C->CCRH = 0;                 // standard mode, duty 1/1 bus speed 100kHz
  72  0020 725f521c      	clr	21020
  73                     ; 38   I2C->TRISER = 9;               // 1000ns/(125ns) + 1  (maximum 1000ns)
  75  0024 3509521d      	mov	21021,#9
  76                     ; 40   I2C->OARL = 0xA0;              // own address A0;
  78  0028 35a05213      	mov	21011,#160
  79                     ; 41   I2C->OARH |= 0x40;
  81  002c 721c5214      	bset	21012,#6
  82                     ; 42   I2C->ITR = 1;                  // enable error interrupts
  84  0030 3501521a      	mov	21018,#1
  85                     ; 43   I2C->CR2 |= 0x04;              // ACK=1, Ack enable
  87  0034 72145211      	bset	21009,#2
  88                     ; 44   I2C->CR1 |= 0x01;              // PE=1
  90  0038 72105210      	bset	21008,#0
  91                     ; 45 }
  94  003c 81            	ret
 156                     ; 54 void I2C_ReadRegister(u8 u8_regAddr, u8 u8_NumByteToRead, u8 *u8_DataBuffer)
 156                     ; 55 {
 157                     	switch	.text
 158  003d               _I2C_ReadRegister:
 160  003d 89            	pushw	x
 161       00000000      OFST:	set	0
 164  003e 200f          	jra	L15
 165  0040               L74:
 166                     ; 59 		I2C->CR2 |= I2C_CR2_STOP;                   				// Generate stop here (STOP=1)
 168  0040 72125211      	bset	21009,#1
 170  0044               L75:
 171                     ; 60     while(I2C->CR2 & I2C_CR2_STOP  &&  tout()); 				// Wait until stop is performed
 173  0044 c65211        	ld	a,21009
 174  0047 a502          	bcp	a,#2
 175  0049 2704          	jreq	L15
 177  004b be00          	ldw	x,_TIM4_tout
 178  004d 26f5          	jrne	L75
 179  004f               L15:
 180                     ; 57 	while(I2C->SR3 & I2C_SR3_BUSY  &&  tout())	  				// Wait while the bus is busy
 182  004f c65219        	ld	a,21017
 183  0052 a502          	bcp	a,#2
 184  0054 2704          	jreq	L56
 186  0056 be00          	ldw	x,_TIM4_tout
 187  0058 26e6          	jrne	L74
 188  005a               L56:
 189                     ; 62   I2C->CR2 |= I2C_CR2_ACK;                      				// ACK=1, Ack enable
 191  005a 72145211      	bset	21009,#2
 192                     ; 64   I2C->CR2 |= I2C_CR2_START;                    				// START=1, generate start
 194  005e 72105211      	bset	21009,#0
 196  0062               L17:
 197                     ; 65   while((I2C->SR1 & I2C_SR1_SB)==0  &&  tout());				// Wait for start bit detection (SB)
 199  0062 c65217        	ld	a,21015
 200  0065 a501          	bcp	a,#1
 201  0067 2604          	jrne	L57
 203  0069 be00          	ldw	x,_TIM4_tout
 204  006b 26f5          	jrne	L17
 205  006d               L57:
 206                     ; 67   if(tout())
 208  006d be00          	ldw	x,_TIM4_tout
 209  006f 2704          	jreq	L301
 210                     ; 69     I2C->DR = (u8)(SLAVE_ADDRESS << 1);   						// Send 7-bit device address & Write (R/W = 0)
 212  0071 35de5216      	mov	21014,#222
 213  0075               L301:
 214                     ; 71   while(!(I2C->SR1 & I2C_SR1_ADDR) &&  tout()); 				// test EV6 - wait for address ack (ADDR)
 216  0075 c65217        	ld	a,21015
 217  0078 a502          	bcp	a,#2
 218  007a 2604          	jrne	L701
 220  007c be00          	ldw	x,_TIM4_tout
 221  007e 26f5          	jrne	L301
 222  0080               L701:
 223                     ; 73   I2C->SR3;
 226  0080 c65219        	ld	a,21017
 228  0083               L311:
 229                     ; 75   while(!(I2C->SR1 & I2C_SR1_TXE) &&  tout());  				// Wait for TxE
 231  0083 c65217        	ld	a,21015
 232  0086 a580          	bcp	a,#128
 233  0088 2604          	jrne	L711
 235  008a be00          	ldw	x,_TIM4_tout
 236  008c 26f5          	jrne	L311
 237  008e               L711:
 238                     ; 76   if(tout())
 240  008e be00          	ldw	x,_TIM4_tout
 241  0090 2705          	jreq	L521
 242                     ; 78     I2C->DR = u8_regAddr;                         			// Send register address
 244  0092 7b01          	ld	a,(OFST+1,sp)
 245  0094 c75216        	ld	21014,a
 246  0097               L521:
 247                     ; 80   while((I2C->SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) != (I2C_SR1_TXE | I2C_SR1_BTF)  &&  tout()); 
 249  0097 c65217        	ld	a,21015
 250  009a a484          	and	a,#132
 251  009c a184          	cp	a,#132
 252  009e 2704          	jreq	L131
 254  00a0 be00          	ldw	x,_TIM4_tout
 255  00a2 26f3          	jrne	L521
 256  00a4               L131:
 257                     ; 84   I2C->CR2 |= I2C_CR2_START;                     				// START=1, generate re-start
 260  00a4 72105211      	bset	21009,#0
 262  00a8               L531:
 263                     ; 85   while((I2C->SR1 & I2C_SR1_SB)==0  &&  tout()); 				// Wait for start bit detection (SB)
 265  00a8 c65217        	ld	a,21015
 266  00ab a501          	bcp	a,#1
 267  00ad 2604          	jrne	L141
 269  00af be00          	ldw	x,_TIM4_tout
 270  00b1 26f5          	jrne	L531
 271  00b3               L141:
 272                     ; 87   if(tout())
 274  00b3 be00          	ldw	x,_TIM4_tout
 275  00b5 2704          	jreq	L741
 276                     ; 89     I2C->DR = (u8)(SLAVE_ADDRESS << 1) | 1;         	// Send 7-bit device address & Write (R/W = 1)
 278  00b7 35df5216      	mov	21014,#223
 279  00bb               L741:
 280                     ; 91   while(!(I2C->SR1 & I2C_SR1_ADDR)  &&  tout());  			// Wait for address ack (ADDR)
 282  00bb c65217        	ld	a,21015
 283  00be a502          	bcp	a,#2
 284  00c0 2604          	jrne	L351
 286  00c2 be00          	ldw	x,_TIM4_tout
 287  00c4 26f5          	jrne	L741
 288  00c6               L351:
 289                     ; 93   if (u8_NumByteToRead > 2)                 						// *** more than 2 bytes are received? ***
 291  00c6 7b02          	ld	a,(OFST+2,sp)
 292  00c8 a103          	cp	a,#3
 293  00ca 2576          	jrult	L551
 294                     ; 95     I2C->SR3;                                     			// ADDR clearing sequence    
 296  00cc c65219        	ld	a,21017
 298  00cf 201b          	jra	L161
 299  00d1               L761:
 300                     ; 98       while(!(I2C->SR1 & I2C_SR1_BTF)  &&  tout()); 				// Wait for BTF
 302  00d1 c65217        	ld	a,21015
 303  00d4 a504          	bcp	a,#4
 304  00d6 2604          	jrne	L371
 306  00d8 be00          	ldw	x,_TIM4_tout
 307  00da 26f5          	jrne	L761
 308  00dc               L371:
 309                     ; 99 			*u8_DataBuffer++ = I2C->DR;                   				// Reading next data byte
 311  00dc 1e05          	ldw	x,(OFST+5,sp)
 312  00de 1c0001        	addw	x,#1
 313  00e1 1f05          	ldw	(OFST+5,sp),x
 314  00e3 1d0001        	subw	x,#1
 315  00e6 c65216        	ld	a,21014
 316  00e9 f7            	ld	(x),a
 317                     ; 100       --u8_NumByteToRead;																		// Decrease Numbyte to reade by 1
 319  00ea 0a02          	dec	(OFST+2,sp)
 320  00ec               L161:
 321                     ; 96     while(u8_NumByteToRead > 3  &&  tout())       			// not last three bytes?
 323  00ec 7b02          	ld	a,(OFST+2,sp)
 324  00ee a104          	cp	a,#4
 325  00f0 2504          	jrult	L102
 327  00f2 be00          	ldw	x,_TIM4_tout
 328  00f4 26db          	jrne	L761
 329  00f6               L102:
 330                     ; 103     while(!(I2C->SR1 & I2C_SR1_BTF)  &&  tout()); 			// Wait for BTF
 332  00f6 c65217        	ld	a,21015
 333  00f9 a504          	bcp	a,#4
 334  00fb 2604          	jrne	L502
 336  00fd be00          	ldw	x,_TIM4_tout
 337  00ff 26f5          	jrne	L102
 338  0101               L502:
 339                     ; 104     I2C->CR2 &=~I2C_CR2_ACK;                      			// Clear ACK
 341  0101 72155211      	bres	21009,#2
 342                     ; 105     disableInterrupts();                          			// Errata workaround (Disable interrupt)
 345  0105 9b            sim
 347                     ; 106     *u8_DataBuffer++ = I2C->DR;                     		// Read 1st byte
 350  0106 1e05          	ldw	x,(OFST+5,sp)
 351  0108 1c0001        	addw	x,#1
 352  010b 1f05          	ldw	(OFST+5,sp),x
 353  010d 1d0001        	subw	x,#1
 354  0110 c65216        	ld	a,21014
 355  0113 f7            	ld	(x),a
 356                     ; 107     I2C->CR2 |= I2C_CR2_STOP;                       		// Generate stop here (STOP=1)
 358  0114 72125211      	bset	21009,#1
 359                     ; 108     *u8_DataBuffer++ = I2C->DR;                     		// Read 2nd byte
 361  0118 1e05          	ldw	x,(OFST+5,sp)
 362  011a 1c0001        	addw	x,#1
 363  011d 1f05          	ldw	(OFST+5,sp),x
 364  011f 1d0001        	subw	x,#1
 365  0122 c65216        	ld	a,21014
 366  0125 f7            	ld	(x),a
 367                     ; 109     enableInterrupts();																	// Errata workaround (Enable interrupt)
 370  0126 9a            rim
 374  0127               L112:
 375                     ; 110     while(!(I2C->SR1 & I2C_SR1_RXNE)  &&  tout());			// Wait for RXNE
 377  0127 c65217        	ld	a,21015
 378  012a a540          	bcp	a,#64
 379  012c 2604          	jrne	L512
 381  012e be00          	ldw	x,_TIM4_tout
 382  0130 26f5          	jrne	L112
 383  0132               L512:
 384                     ; 111     *u8_DataBuffer++ = I2C->DR;                   			// Read 3rd Data byte
 386  0132 1e05          	ldw	x,(OFST+5,sp)
 387  0134 1c0001        	addw	x,#1
 388  0137 1f05          	ldw	(OFST+5,sp),x
 389  0139 1d0001        	subw	x,#1
 390  013c c65216        	ld	a,21014
 391  013f f7            	ld	(x),a
 393  0140 2058          	jra	L742
 394  0142               L551:
 395                     ; 115    if(u8_NumByteToRead == 2)                						// *** just two bytes are received? ***
 397  0142 7b02          	ld	a,(OFST+2,sp)
 398  0144 a102          	cp	a,#2
 399  0146 2634          	jrne	L122
 400                     ; 117       I2C->CR2 |= I2C_CR2_POS;                      		// Set POS bit (NACK at next received byte)
 402  0148 72165211      	bset	21009,#3
 403                     ; 118       disableInterrupts();                          		// Errata workaround (Disable interrupt)
 406  014c 9b            sim
 408                     ; 119       I2C->SR3;                                       	// Clear ADDR Flag
 411  014d c65219        	ld	a,21017
 412                     ; 120       I2C->CR2 &=~I2C_CR2_ACK;                        	// Clear ACK 
 414  0150 72155211      	bres	21009,#2
 415                     ; 121       enableInterrupts();																// Errata workaround (Enable interrupt)
 418  0154 9a            rim
 422  0155               L522:
 423                     ; 122       while(!(I2C->SR1 & I2C_SR1_BTF)  &&  tout()); 		// Wait for BTF
 425  0155 c65217        	ld	a,21015
 426  0158 a504          	bcp	a,#4
 427  015a 2604          	jrne	L132
 429  015c be00          	ldw	x,_TIM4_tout
 430  015e 26f5          	jrne	L522
 431  0160               L132:
 432                     ; 123       disableInterrupts();                          		// Errata workaround (Disable interrupt)
 435  0160 9b            sim
 437                     ; 124       I2C->CR2 |= I2C_CR2_STOP;                       	// Generate stop here (STOP=1)
 440  0161 72125211      	bset	21009,#1
 441                     ; 125       *u8_DataBuffer++ = I2C->DR;                     	// Read 1st Data byte
 443  0165 1e05          	ldw	x,(OFST+5,sp)
 444  0167 1c0001        	addw	x,#1
 445  016a 1f05          	ldw	(OFST+5,sp),x
 446  016c 1d0001        	subw	x,#1
 447  016f c65216        	ld	a,21014
 448  0172 f7            	ld	(x),a
 449                     ; 126       enableInterrupts();																// Errata workaround (Enable interrupt)
 452  0173 9a            rim
 454                     ; 127 			*u8_DataBuffer = I2C->DR;													// Read 2nd Data byte
 457  0174 1e05          	ldw	x,(OFST+5,sp)
 458  0176 c65216        	ld	a,21014
 459  0179 f7            	ld	(x),a
 461  017a 201e          	jra	L742
 462  017c               L122:
 463                     ; 131       I2C->CR2 &=~I2C_CR2_ACK;;                     		// Clear ACK 
 465  017c 72155211      	bres	21009,#2
 466                     ; 132       disableInterrupts();                          		// Errata workaround (Disable interrupt)
 470  0180 9b            sim
 472                     ; 133       I2C->SR3;                                       	// Clear ADDR Flag   
 475  0181 c65219        	ld	a,21017
 476                     ; 134       I2C->CR2 |= I2C_CR2_STOP;                       	// generate stop here (STOP=1)
 478  0184 72125211      	bset	21009,#1
 479                     ; 135       enableInterrupts();																// Errata workaround (Enable interrupt)
 482  0188 9a            rim
 486  0189               L732:
 487                     ; 136       while(!(I2C->SR1 & I2C_SR1_RXNE)  &&  tout()); 		// test EV7, wait for RxNE
 489  0189 c65217        	ld	a,21015
 490  018c a540          	bcp	a,#64
 491  018e 2604          	jrne	L342
 493  0190 be00          	ldw	x,_TIM4_tout
 494  0192 26f5          	jrne	L732
 495  0194               L342:
 496                     ; 137       *u8_DataBuffer = I2C->DR;                     		// Read Data byte
 498  0194 1e05          	ldw	x,(OFST+5,sp)
 499  0196 c65216        	ld	a,21014
 500  0199 f7            	ld	(x),a
 501  019a               L742:
 502                     ; 141   while((I2C->CR2 & I2C_CR2_STOP)  &&  tout());     		// Wait until stop is performed (STOPF = 1)
 504  019a c65211        	ld	a,21009
 505  019d a502          	bcp	a,#2
 506  019f 2704          	jreq	L352
 508  01a1 be00          	ldw	x,_TIM4_tout
 509  01a3 26f5          	jrne	L742
 510  01a5               L352:
 511                     ; 142   I2C->CR2 &=~I2C_CR2_POS;                          		// return POS to default state (POS=0)
 513  01a5 72175211      	bres	21009,#3
 514                     ; 143 }
 517  01a9 85            	popw	x
 518  01aa 81            	ret
 572                     ; 152 void I2C_WriteRegister(u8 u8_regAddr, u8 u8_NumByteToWrite, u8 *u8_DataBuffer)
 572                     ; 153 {
 573                     	switch	.text
 574  01ab               _I2C_WriteRegister:
 576  01ab 89            	pushw	x
 577       00000000      OFST:	set	0
 580  01ac 200f          	jra	L503
 581  01ae               L303:
 582                     ; 156     I2C->CR2 |= 2;                        								// STOP=1, generate stop
 584  01ae 72125211      	bset	21009,#1
 586  01b2               L313:
 587                     ; 157     while((I2C->CR2 & 2) && tout());      								// wait until stop is performed
 589  01b2 c65211        	ld	a,21009
 590  01b5 a502          	bcp	a,#2
 591  01b7 2704          	jreq	L503
 593  01b9 be00          	ldw	x,_TIM4_tout
 594  01bb 26f5          	jrne	L313
 595  01bd               L503:
 596                     ; 154   while((I2C->SR3 & 2) && tout())       									// Wait while the bus is busy
 598  01bd c65219        	ld	a,21017
 599  01c0 a502          	bcp	a,#2
 600  01c2 2704          	jreq	L123
 602  01c4 be00          	ldw	x,_TIM4_tout
 603  01c6 26e6          	jrne	L303
 604  01c8               L123:
 605                     ; 160   I2C->CR2 |= 1;                        									// START=1, generate start
 607  01c8 72105211      	bset	21009,#0
 609  01cc               L523:
 610                     ; 161   while(((I2C->SR1 & 1)==0) && tout()); 									// Wait for start bit detection (SB)
 612  01cc c65217        	ld	a,21015
 613  01cf a501          	bcp	a,#1
 614  01d1 2604          	jrne	L133
 616  01d3 be00          	ldw	x,_TIM4_tout
 617  01d5 26f5          	jrne	L523
 618  01d7               L133:
 619                     ; 163   if(tout())
 622  01d7 be00          	ldw	x,_TIM4_tout
 623  01d9 2704          	jreq	L733
 624                     ; 165     I2C->DR = (u8)(SLAVE_ADDRESS << 1);   							// Send 7-bit device address & Write (R/W = 0)
 626  01db 35de5216      	mov	21014,#222
 627  01df               L733:
 628                     ; 167   while(!(I2C->SR1 & 2) && tout());     									// Wait for address ack (ADDR)
 630  01df c65217        	ld	a,21015
 631  01e2 a502          	bcp	a,#2
 632  01e4 2604          	jrne	L343
 634  01e6 be00          	ldw	x,_TIM4_tout
 635  01e8 26f5          	jrne	L733
 636  01ea               L343:
 637                     ; 169   I2C->SR3;
 640  01ea c65219        	ld	a,21017
 642  01ed               L743:
 643                     ; 170   while(!(I2C->SR1 & 0x80) && tout());  									// Wait for TxE
 645  01ed c65217        	ld	a,21015
 646  01f0 a580          	bcp	a,#128
 647  01f2 2604          	jrne	L353
 649  01f4 be00          	ldw	x,_TIM4_tout
 650  01f6 26f5          	jrne	L743
 651  01f8               L353:
 652                     ; 171   if(tout())
 654  01f8 be00          	ldw	x,_TIM4_tout
 655  01fa 2705          	jreq	L553
 656                     ; 173     I2C->DR = u8_regAddr;                 								// send Offset command
 658  01fc 7b01          	ld	a,(OFST+1,sp)
 659  01fe c75216        	ld	21014,a
 660  0201               L553:
 661                     ; 175   if(u8_NumByteToWrite)
 663  0201 0d02          	tnz	(OFST+2,sp)
 664  0203 2722          	jreq	L104
 666  0205 2019          	jra	L363
 667  0207               L173:
 668                     ; 179       while(!(I2C->SR1 & 0x80) && tout());  								// test EV8 - wait for TxE
 670  0207 c65217        	ld	a,21015
 671  020a a580          	bcp	a,#128
 672  020c 2604          	jrne	L573
 674  020e be00          	ldw	x,_TIM4_tout
 675  0210 26f5          	jrne	L173
 676  0212               L573:
 677                     ; 180       I2C->DR = *u8_DataBuffer++;           								// send next data byte
 679  0212 1e05          	ldw	x,(OFST+5,sp)
 680  0214 1c0001        	addw	x,#1
 681  0217 1f05          	ldw	(OFST+5,sp),x
 682  0219 1d0001        	subw	x,#1
 683  021c f6            	ld	a,(x)
 684  021d c75216        	ld	21014,a
 685  0220               L363:
 686                     ; 177     while(u8_NumByteToWrite--)          									
 688  0220 7b02          	ld	a,(OFST+2,sp)
 689  0222 0a02          	dec	(OFST+2,sp)
 690  0224 4d            	tnz	a
 691  0225 26e0          	jrne	L173
 692  0227               L104:
 693                     ; 183   while(((I2C->SR1 & 0x84) != 0x84) && tout()); 					// Wait for TxE & BTF
 695  0227 c65217        	ld	a,21015
 696  022a a484          	and	a,#132
 697  022c a184          	cp	a,#132
 698  022e 2704          	jreq	L504
 700  0230 be00          	ldw	x,_TIM4_tout
 701  0232 26f3          	jrne	L104
 702  0234               L504:
 703                     ; 186   I2C->CR2 |= 2;                        									// generate stop here (STOP=1)
 706  0234 72125211      	bset	21009,#1
 708  0238               L114:
 709                     ; 187   while((I2C->CR2 & 2) && tout());      									// wait until stop is performed  
 711  0238 c65211        	ld	a,21009
 712  023b a502          	bcp	a,#2
 713  023d 2704          	jreq	L514
 715  023f be00          	ldw	x,_TIM4_tout
 716  0241 26f5          	jrne	L114
 717  0243               L514:
 718                     ; 188 }
 721  0243 85            	popw	x
 722  0244 81            	ret
 746                     ; 197 void ErrProc(void)
 746                     ; 198 {
 747                     	switch	.text
 748  0245               _ErrProc:
 752                     ; 200     I2C->SR2= 0;
 754  0245 725f5218      	clr	21016
 755                     ; 202 	  I2C->CR2 |= 2;  
 757  0249 72125211      	bset	21009,#1
 758                     ; 204     TIM4_tout= 0;
 760  024d 5f            	clrw	x
 761  024e bf00          	ldw	_TIM4_tout,x
 762                     ; 205 }
 765  0250 81            	ret
 788                     ; 216 void TIM4_Init (void) {
 789                     	switch	.text
 790  0251               _TIM4_Init:
 794                     ; 217   TIM4->ARR = 0x80;                // init timer 4 1ms inetrrupts
 796  0251 35805346      	mov	21318,#128
 797                     ; 218   TIM4->PSCR= 7;
 799  0255 35075345      	mov	21317,#7
 800                     ; 219   TIM4->IER = 1;
 802  0259 35015341      	mov	21313,#1
 803                     ; 220   TIM4->CR1 |= 1;
 805  025d 72105340      	bset	21312,#0
 806                     ; 221 }
 809  0261 81            	ret
 834                     ; 231 @far @interrupt void I2C_error_Interrupt_Handler (void) {
 836                     	switch	.text
 837  0262               f_I2C_error_Interrupt_Handler:
 839  0262 8a            	push	cc
 840  0263 84            	pop	a
 841  0264 a4bf          	and	a,#191
 842  0266 88            	push	a
 843  0267 86            	pop	cc
 844  0268 3b0002        	push	c_x+2
 845  026b be00          	ldw	x,c_x
 846  026d 89            	pushw	x
 847  026e 3b0002        	push	c_y+2
 848  0271 be00          	ldw	x,c_y
 849  0273 89            	pushw	x
 852                     ; 232 ErrProc();
 854  0274 adcf          	call	_ErrProc
 856                     ; 233 }
 859  0276 85            	popw	x
 860  0277 bf00          	ldw	c_y,x
 861  0279 320002        	pop	c_y+2
 862  027c 85            	popw	x
 863  027d bf00          	ldw	c_x,x
 864  027f 320002        	pop	c_x+2
 865  0282 80            	iret
 901                     ; 243 @far @interrupt void TIM4InterruptHandle (void) {
 902                     	switch	.text
 903  0283               f_TIM4InterruptHandle:
 905       00000001      OFST:	set	1
 906  0283 88            	push	a
 909                     ; 245   u8 dly= 10;
 911  0284 a60a          	ld	a,#10
 912  0286 6b01          	ld	(OFST+0,sp),a
 914                     ; 247   TIM4->SR1= 0;
 916  0288 725f5342      	clr	21314
 917                     ; 249   if(TIM4_tout)
 919  028c be00          	ldw	x,_TIM4_tout
 920  028e 270a          	jreq	L374
 921                     ; 250     if(--TIM4_tout == 0)
 923  0290 be00          	ldw	x,_TIM4_tout
 924  0292 1d0001        	subw	x,#1
 925  0295 bf00          	ldw	_TIM4_tout,x
 926  0297 2601          	jrne	L374
 927                     ; 251       _asm("nop");
 930  0299 9d            nop
 932  029a               L374:
 933                     ; 253   while(dly--);
 935  029a 7b01          	ld	a,(OFST+0,sp)
 936  029c 0a01          	dec	(OFST+0,sp)
 938  029e 4d            	tnz	a
 939  029f 26f9          	jrne	L374
 940                     ; 254 }
 943  02a1 84            	pop	a
 944  02a2 80            	iret
 956                     	xdef	f_TIM4InterruptHandle
 957                     	xdef	f_I2C_error_Interrupt_Handler
 958                     	xref.b	_TIM4_tout
 959                     	xdef	_ErrProc
 960                     	xdef	_I2C_WriteRegister
 961                     	xdef	_I2C_ReadRegister
 962                     	xdef	_TIM4_Init
 963                     	xdef	_I2C_Init
 964                     	xref.b	c_x
 965                     	xref.b	c_y
 984                     	end
