
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G104:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G104:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x1B,0x36,0x24,0x48,0x0,LOW(_test_7408),HIGH(_test_7408),0x35
	.DB  0x56,0xA,0x28,0x0,LOW(_test_4066),HIGH(_test_4066),0x0,0x1E
	.DB  0x7F,0xE0,0x1,LOW(_test_7445),HIGH(_test_7445),0x1F,0x78,0x60
	.DB  0x86,0x1,LOW(_test_4532),HIGH(_test_4532),0x37,0x6E,0x48,0x90
	.DB  0x1,LOW(_test_74157),HIGH(_test_74157),0x7,0xE,0x78,0xF0,0x1
	.DB  LOW(_test_74156),HIGH(_test_74156)
_0x0:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x74,0x6F
	.DB  0x20,0x74,0x65,0x73,0x74,0x0,0x54,0x65
	.DB  0x73,0x74,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x0,0x49,0x43,0x20,0x69,0x73,0x20,0x37
	.DB  0x34,0x30,0x38,0x0,0x44,0x49,0x50,0x31
	.DB  0x34,0x20,0x2D,0x20,0x54,0x54,0x4C,0x0
	.DB  0x49,0x43,0x20,0x69,0x73,0x20,0x34,0x30
	.DB  0x36,0x36,0x0,0x44,0x49,0x50,0x31,0x34
	.DB  0x20,0x2D,0x20,0x43,0x4D,0x4F,0x53,0x0
	.DB  0x49,0x43,0x20,0x69,0x73,0x20,0x37,0x34
	.DB  0x34,0x35,0x0,0x44,0x49,0x50,0x31,0x36
	.DB  0x20,0x2D,0x20,0x54,0x54,0x4C,0x0,0x49
	.DB  0x43,0x20,0x69,0x73,0x20,0x34,0x35,0x33
	.DB  0x32,0x0,0x44,0x49,0x50,0x31,0x36,0x20
	.DB  0x2D,0x20,0x43,0x4D,0x4F,0x53,0x0,0x49
	.DB  0x43,0x20,0x69,0x73,0x20,0x37,0x34,0x31
	.DB  0x35,0x37,0x0,0x49,0x43,0x20,0x69,0x73
	.DB  0x20,0x37,0x34,0x31,0x35,0x36,0x0,0x55
	.DB  0x6E,0x6B,0x6E,0x6F,0x77,0x6E,0x20,0x49
	.DB  0x43,0x0
_0x2100060:
	.DB  0x1
_0x2100000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x2A
	.DW  _ICs
	.DW  _0x3*2

	.DW  0x0E
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0xB+14
	.DW  _0x0*2+14

	.DW  0x0B
	.DW  _0x28
	.DW  _0x0*2+25

	.DW  0x0C
	.DW  _0x28+11
	.DW  _0x0*2+36

	.DW  0x0B
	.DW  _0x30
	.DW  _0x0*2+48

	.DW  0x0D
	.DW  _0x30+11
	.DW  _0x0*2+59

	.DW  0x0B
	.DW  _0x39
	.DW  _0x0*2+72

	.DW  0x0C
	.DW  _0x39+11
	.DW  _0x0*2+83

	.DW  0x0B
	.DW  _0x40
	.DW  _0x0*2+95

	.DW  0x0D
	.DW  _0x40+11
	.DW  _0x0*2+106

	.DW  0x0C
	.DW  _0x4E
	.DW  _0x0*2+119

	.DW  0x0C
	.DW  _0x4E+12
	.DW  _0x0*2+83

	.DW  0x0C
	.DW  _0x55
	.DW  _0x0*2+131

	.DW  0x0C
	.DW  _0x55+12
	.DW  _0x0*2+83

	.DW  0x0B
	.DW  _0x5A
	.DW  _0x0*2+143

	.DW  0x01
	.DW  __seed_G108
	.DW  _0x2100060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <io.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include "IC_Configs.h"

	.DSEG
;#include <stdio.h>
;
;
;
;
;// Pin Definitions
;#define LED_PASS    PORTC0
;#define LED_FAIL    PORTC1
;#define TEST_BUTTON_PIN PINB3
;#define GLCD_LCD_WIDTH 84
;#define LINES_DY 9
;#define F_CPU 11059200UL
;
;#define NUM_ICs (sizeof(ICs) / sizeof(IC_Config))
;
;
;
;// Function prototypes
;void initialize_ports(void);
;void power_ic(IC_Package package_type);
;void display_result(unsigned char result);
;void glcd_drawCenteredStr(const char *str, uint8_t y, uint8_t dx);
;unsigned char is_button_pressed();
;void clear_LEDs();
;void clear_ports();
;unsigned char reverseBits(unsigned char num);
;
;
;
;void main(void) {
; 0000 0026 void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0027     unsigned char result = 0;
; 0000 0028 	unsigned char state = 1;
; 0000 0029 	unsigned char current_ic = 0;
; 0000 002A 
; 0000 002B 
; 0000 002C 
; 0000 002D 	// Initialize Nokia5110 Display
; 0000 002E 	GLCDINIT_t glcd_init_data;
; 0000 002F     glcd_init_data.font = font5x7;
	SBIW R28,8
;	result -> R17
;	state -> R16
;	current_ic -> R19
;	glcd_init_data -> Y+0
	LDI  R17,0
	LDI  R16,1
	LDI  R19,0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0030     glcd_init_data.temp_coef = PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 0031     glcd_init_data.bias = PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 0032     glcd_init_data.vlcd = PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 0033     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0034 
; 0000 0035 	// Clear the display
; 0000 0036     glcd_clear();
	CALL _glcd_clear
; 0000 0037 
; 0000 0038     // Initialize ports
; 0000 0039     initialize_ports();
	RCALL _initialize_ports
; 0000 003A 
; 0000 003B 
; 0000 003C     // Main loop
; 0000 003D     while (1) {
_0x4:
; 0000 003E         switch (state) {
	MOV  R30,R16
	LDI  R31,0
; 0000 003F             case 1: // Idle State
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA
; 0000 0040 				clear_LEDs();
	RCALL _clear_LEDs
; 0000 0041 
; 0000 0042                 // Display message
; 0000 0043                 glcd_drawCenteredStr("Press to test", LINES_DY * 2, 1);
	__POINTW1MN _0xB,0
	CALL SUBOPT_0x0
; 0000 0044 
; 0000 0045                 // Wait for button press
; 0000 0046                 if (is_button_pressed()) {
	RCALL _is_button_pressed
	CPI  R30,0
	BREQ _0xC
; 0000 0047                     state = 2; // Move to Testing State
	LDI  R16,LOW(2)
; 0000 0048 
; 0000 0049                     while (is_button_pressed()); // Wait for button release
_0xD:
	RCALL _is_button_pressed
	CPI  R30,0
	BRNE _0xD
; 0000 004A                 }
; 0000 004B                 break;
_0xC:
	RJMP _0x9
; 0000 004C 
; 0000 004D             case 2: // Testing State
_0xA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10
; 0000 004E 
; 0000 004F 				glcd_clear();
	CALL _glcd_clear
; 0000 0050 				glcd_drawCenteredStr("Testing...", LINES_DY * 2, 1);
	__POINTW1MN _0xB,14
	CALL SUBOPT_0x0
; 0000 0051 				while (current_ic < NUM_ICs) {
_0x11:
	CPI  R19,6
	BRSH _0x13
; 0000 0052 					// Run the test for the current IC
; 0000 0053 					result = ICs[current_ic].test_function();
	LDI  R26,LOW(7)
	MUL  R19,R26
	MOVW R30,R0
	__ADDW1MN _ICs,5
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	ICALL
	MOV  R17,R30
; 0000 0054 					clear_ports();
	RCALL _clear_ports
; 0000 0055 
; 0000 0056 					if (result) {
	CPI  R17,0
	BREQ _0x14
; 0000 0057 						state = 3;
	LDI  R16,LOW(3)
; 0000 0058 					 break;
	RJMP _0x13
; 0000 0059 					}
; 0000 005A 
; 0000 005B                     // Move to the next IC or Result State
; 0000 005C                     current_ic++;
_0x14:
	SUBI R19,-1
; 0000 005D                 }
	RJMP _0x11
_0x13:
; 0000 005E 
; 0000 005F 				display_result(result);
	MOV  R26,R17
	RCALL _display_result
; 0000 0060                 state = 3; // All tests completed, move to Result State
	LDI  R16,LOW(3)
; 0000 0061 
; 0000 0062                 break;
	RJMP _0x9
; 0000 0063             case 3: // Result State
_0x10:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9
; 0000 0064 
; 0000 0065 				// Wait for button press to move to Idle State
; 0000 0066                 if (is_button_pressed()) {
	RCALL _is_button_pressed
	CPI  R30,0
	BREQ _0x16
; 0000 0067 					while (is_button_pressed()); // Wait for button release
_0x17:
	RCALL _is_button_pressed
	CPI  R30,0
	BRNE _0x17
; 0000 0068 					glcd_clear();
	CALL _glcd_clear
; 0000 0069                     current_ic = 0;
	LDI  R19,LOW(0)
; 0000 006A                     state = 1; // Move to Result State
	LDI  R16,LOW(1)
; 0000 006B 
; 0000 006C                 }
; 0000 006D                 break;
_0x16:
; 0000 006E         }
_0x9:
; 0000 006F     }
	RJMP _0x4
; 0000 0070 }
_0x1A:
	RJMP _0x1A
; .FEND

	.DSEG
_0xB:
	.BYTE 0x19
;
;void initialize_ports(void) {
; 0000 0072 void initialize_ports(void) {

	.CSEG
_initialize_ports:
; .FSTART _initialize_ports
; 0000 0073     // Configure TEST_BUTTON_PIN as input with pull-up
; 0000 0074     DDRB &= ~(1 << TEST_BUTTON_PIN);
	CBI  0x17,3
; 0000 0075     PORTB |= (1 << TEST_BUTTON_PIN);
	SBI  0x18,3
; 0000 0076 
; 0000 0077     // Configure LED pins
; 0000 0078     DDRC |= (1 << LED_PASS) | (1 << LED_FAIL);
	IN   R30,0x14
	ORI  R30,LOW(0x3)
	OUT  0x14,R30
; 0000 0079     PORTC &= ~((1 << LED_PASS) | (1 << LED_FAIL));
	IN   R30,0x15
	ANDI R30,LOW(0xFC)
	OUT  0x15,R30
; 0000 007A 
; 0000 007B }
	RET
; .FEND
;
;void power_ic(IC_Package package_type) {
; 0000 007D void power_ic(IC_Package package_type) {
_power_ic:
; .FSTART _power_ic
; 0000 007E     IC_Package package = package_type;
; 0000 007F 
; 0000 0080 
; 0000 0081 	// Reset power pins
; 0000 0082 	DDRA |= (1 << PORTA0);
	ST   -Y,R26
	ST   -Y,R17
;	package_type -> Y+1
;	package -> R17
	LDD  R17,Y+1
	SBI  0x1A,0
; 0000 0083     PORTA &= ~(1 << PORTA0);
	CBI  0x1B,0
; 0000 0084     if (package == DIP14) {
	CPI  R17,0
	BRNE _0x1B
; 0000 0085 		DDRD |= (1 << PORTD6);
	SBI  0x11,6
; 0000 0086         PORTD &= ~(1 << PORTD6);
	CBI  0x12,6
; 0000 0087     } else if (package == DIP16) {
	RJMP _0x1C
_0x1B:
	CPI  R17,1
	BRNE _0x1D
; 0000 0088 		DDRD |= (1 << PORTD7);
	SBI  0x11,7
; 0000 0089         PORTD &= ~(1 << PORTD7);
	CBI  0x12,7
; 0000 008A     }
; 0000 008B     delay_ms(5);
_0x1D:
_0x1C:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 008C 
; 0000 008D     // Power the IC
; 0000 008E     PORTA |= (1 << PORTA0);
	SBI  0x1B,0
; 0000 008F     if (package == DIP14) {
	CPI  R17,0
	BRNE _0x1E
; 0000 0090         PORTD &= ~(1 << PORTD6);
	CBI  0x12,6
; 0000 0091     } else if (package == DIP16) {
	RJMP _0x1F
_0x1E:
	CPI  R17,1
	BRNE _0x20
; 0000 0092         PORTD &= ~(1 << PORTD7);
	CBI  0x12,7
; 0000 0093     }
; 0000 0094 }
_0x20:
_0x1F:
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;unsigned char test_7408(void) {
; 0000 0096 unsigned char test_7408(void) {
_test_7408:
; .FSTART _test_7408
; 0000 0097     unsigned char i;
; 0000 0098     unsigned char input1, input2; // Inputs for gates
; 0000 0099     unsigned char output1, output2, output3, output4;
; 0000 009A 
; 0000 009B 
; 0000 009C     // Configure 7408 input pins as outputs (from MCU)
; 0000 009D     DDRD |= IC_7408.input_mask_PD;
	SBIW R28,1
	CALL __SAVELOCR6
;	i -> R17
;	input1 -> R16
;	input2 -> R19
;	output1 -> R18
;	output2 -> R21
;	output3 -> R20
;	output4 -> Y+6
	IN   R30,0x11
	LDS  R26,_ICs
	CALL SUBOPT_0x1
; 0000 009E     DDRA |= IC_7408.input_mask_PA;
	__GETB1MN _ICs,1
	CALL SUBOPT_0x2
; 0000 009F 
; 0000 00A0     // Configure 7408 output pins as inputs (from MCU)
; 0000 00A1     DDRD &= ~IC_7408.output_mask_PD;
	__GETB1MN _ICs,2
	CALL SUBOPT_0x3
; 0000 00A2     DDRA &= ~IC_7408.output_mask_PA;
	__GETB1MN _ICs,3
	CALL SUBOPT_0x4
; 0000 00A3 
; 0000 00A4     // Set initial pin states to low
; 0000 00A5     PORTD &= ~IC_7408.input_mask_PD;
	LDS  R30,_ICs
	CALL SUBOPT_0x5
; 0000 00A6     PORTA &= ~IC_7408.input_mask_PA;
	__GETB1MN _ICs,1
	COM  R30
	AND  R30,R26
	OUT  0x1B,R30
; 0000 00A7 
; 0000 00A8     power_ic(IC_7408.package_type);
	__GETB2MN _ICs,4
	RCALL _power_ic
; 0000 00A9 
; 0000 00AA     for (i = 0; i < 4; i++) {
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x23
; 0000 00AB         input1 = (i & 0x01); // LSB of inputs
	MOV  R30,R17
	ANDI R30,LOW(0x1)
	MOV  R16,R30
; 0000 00AC         input2 = (i & 0x02) >> 1; // MSB of inputs
	MOV  R30,R17
	CALL SUBOPT_0x6
	MOV  R19,R30
; 0000 00AD 
; 0000 00AE         PORTD = (PORTD & ~IC_7408.input_mask_PD) | (input1 << PORTD0) | (input2 << PORTD1) | (input1 << PORTD3) | (input ...
	IN   R30,0x12
	MOV  R26,R30
	LDS  R30,_ICs
	COM  R30
	AND  R30,R26
	OR   R30,R16
	MOV  R26,R30
	MOV  R30,R19
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R16
	CALL SUBOPT_0x7
	SWAP R30
	ANDI R30,0xF0
	CALL SUBOPT_0x8
; 0000 00AF         PORTA = (PORTA & ~IC_7408.input_mask_PA) | (input1 << PORTA1) | (input2 << PORTA2) | (input1 << PORTA4) | (input ...
	__GETB1MN _ICs,1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	MOV  R30,R19
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	CALL SUBOPT_0xB
; 0000 00B0 
; 0000 00B1         delay_ms(20); // Allow time for IC to process
; 0000 00B2 
; 0000 00B3         // Read outputs for all gates
; 0000 00B4         output1 = (PIND & (1 << PORTD2)) >> PORTD2; // Gate 1 output
	ANDI R30,LOW(0x4)
	LDI  R31,0
	CALL __ASRW2
	MOV  R18,R30
; 0000 00B5         output2 = (PIND & (1 << PORTD5)) >> PORTD5; // Gate 2 output
	IN   R30,0x10
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 00B6         output3 = (PINA & (1 << PORTA3)) >> PORTA3; // Gate 3 output
; 0000 00B7         output4 = (PINA & (1 << PORTA6)) >> PORTA6; // Gate 4 output
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 00B8 
; 0000 00B9         delay_ms(10);
; 0000 00BA 
; 0000 00BB         if (output1 != (input1 & input2)) return 0; // Gate 1 check
	MOV  R30,R19
	AND  R30,R16
	CP   R30,R18
	BREQ _0x24
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00BC         if (output2 != (input1 & input2)) return 0; // Gate 2 check
_0x24:
	MOV  R30,R19
	AND  R30,R16
	CP   R30,R21
	BREQ _0x25
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00BD         if (output3 != (input1 & input2)) return 0; // Gate 3 check
_0x25:
	MOV  R30,R19
	AND  R30,R16
	CP   R30,R20
	BREQ _0x26
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00BE         if (output4 != (input1 & input2)) return 0; // Gate 4 check
_0x26:
	MOV  R30,R19
	AND  R30,R16
	LDD  R26,Y+6
	CP   R30,R26
	BREQ _0x27
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00BF     }
_0x27:
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 00C0 
; 0000 00C1     glcd_clear();
	CALL _glcd_clear
; 0000 00C2     glcd_drawCenteredStr("IC is 7408", LINES_DY * 2, 1);
	__POINTW1MN _0x28,0
	CALL SUBOPT_0x0
; 0000 00C3     glcd_drawCenteredStr("DIP14 - TTL", LINES_DY * 3, 1);
	__POINTW1MN _0x28,11
	RJMP _0x212000D
; 0000 00C4     return 1; // Test passed
; 0000 00C5 }
; .FEND

	.DSEG
_0x28:
	.BYTE 0x17
;
;unsigned char test_4066(void) {
; 0000 00C7 unsigned char test_4066(void) {

	.CSEG
_test_4066:
; .FSTART _test_4066
; 0000 00C8     unsigned char i;
; 0000 00C9     unsigned char control, input, output1, output2, output3, output4;
; 0000 00CA 
; 0000 00CB     // Configure control and input pins as outputs (from MCU)
; 0000 00CC     DDRD |= IC_4066.input_mask_PD;
	SBIW R28,1
	CALL SUBOPT_0x10
;	i -> R17
;	control -> R16
;	input -> R19
;	output1 -> R18
;	output2 -> R21
;	output3 -> R20
;	output4 -> Y+6
	__GETB1MN _ICs,7
	CALL SUBOPT_0x1
; 0000 00CD     DDRA |= IC_4066.input_mask_PA;
	__GETB1MN _ICs,8
	CALL SUBOPT_0x2
; 0000 00CE 
; 0000 00CF     // Configure output pins as inputs (from MCU)
; 0000 00D0     DDRD &= ~IC_4066.output_mask_PD;
	__GETB1MN _ICs,9
	CALL SUBOPT_0x3
; 0000 00D1 	DDRA &= ~IC_4066.output_mask_PA;
	__GETB1MN _ICs,10
	CALL SUBOPT_0x4
; 0000 00D2 
; 0000 00D3     // Set initial pin states to low
; 0000 00D4     PORTD &= ~IC_4066.input_mask_PD;
	__GETB1MN _ICs,7
	CALL SUBOPT_0x5
; 0000 00D5     PORTA &= ~IC_4066.input_mask_PA;
	__GETB1MN _ICs,8
	COM  R30
	AND  R30,R26
	OUT  0x1B,R30
; 0000 00D6 
; 0000 00D7     power_ic(IC_4066.package_type);
	__GETB2MN _ICs,11
	RCALL _power_ic
; 0000 00D8 
; 0000 00D9     // Testing loop for all switch combinations
; 0000 00DA     for (i = 0; i < 2; i++) {
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,2
	BRLO PC+2
	RJMP _0x2B
; 0000 00DB         control = 1; // Set control to 0 or 1
	LDI  R16,LOW(1)
; 0000 00DC         input = i;   // Set input to 0 or 1
	MOV  R19,R17
; 0000 00DD 
; 0000 00DE         // Set control and inputs
; 0000 00DF         PORTD = (PORTD & ~IC_4066.input_mask_PD) | (input << PORTD0) | (input << PORTD2) | (control << PORTD4) | (contro ...
	IN   R30,0x12
	MOV  R26,R30
	__GETB1MN _ICs,7
	COM  R30
	AND  R30,R26
	OR   R30,R19
	MOV  R26,R30
	CALL SUBOPT_0xA
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	CALL SUBOPT_0x8
; 0000 00E0         PORTA = (PORTA & ~IC_4066.input_mask_PA) | (control << PORTA1) | (control << PORTA2) | (input << PORTA4) | (inpu ...
	__GETB1MN _ICs,8
	CALL SUBOPT_0x9
	MOV  R30,R16
	CALL SUBOPT_0x11
	MOV  R30,R19
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	CALL SUBOPT_0xB
; 0000 00E1 
; 0000 00E2         delay_ms(20); // Allow time for IC to process
; 0000 00E3 
; 0000 00E4         // Read outputs for all switches
; 0000 00E5         output1 = ((PIND & (1 << PORTD1)) >> PORTD1);
	CALL SUBOPT_0x6
	MOV  R18,R30
; 0000 00E6         output2 = ((PIND & (1 << PORTD3)) >> PORTD3);
	IN   R30,0x10
	ANDI R30,LOW(0x8)
	LDI  R31,0
	CALL __ASRW3
	CALL SUBOPT_0xD
; 0000 00E7         output3 = ((PINA & (1 << PORTA3)) >> PORTA3);
; 0000 00E8         output4 = ((PINA & (1 << PORTA5)) >> PORTA5);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
; 0000 00E9 
; 0000 00EA 
; 0000 00EB 
; 0000 00EC         delay_ms(10);
; 0000 00ED 
; 0000 00EE         // Verify output matches the input for all switches
; 0000 00EF         if (output1 != input) return 0;
	CP   R19,R18
	BREQ _0x2C
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00F0 		if (output2 != input) return 0;
_0x2C:
	CP   R19,R21
	BREQ _0x2D
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00F1 		if (output3 != input) return 0;
_0x2D:
	CP   R19,R20
	BREQ _0x2E
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00F2 		if (output4 != input) return 0;
_0x2E:
	LDD  R26,Y+6
	CP   R19,R26
	BREQ _0x2F
	LDI  R30,LOW(0)
	RJMP _0x212000C
; 0000 00F3     }
_0x2F:
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 00F4 
; 0000 00F5     glcd_clear();
	CALL _glcd_clear
; 0000 00F6     glcd_drawCenteredStr("IC is 4066", LINES_DY * 2, 1);
	__POINTW1MN _0x30,0
	CALL SUBOPT_0x0
; 0000 00F7     glcd_drawCenteredStr("DIP14 - CMOS", LINES_DY * 3, 1);
	__POINTW1MN _0x30,11
_0x212000D:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
; 0000 00F8     return 1; // Test passed
_0x212000C:
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; 0000 00F9 }
; .FEND

	.DSEG
_0x30:
	.BYTE 0x18
;
;unsigned char test_7445(void) {
; 0000 00FB unsigned char test_7445(void) {

	.CSEG
_test_7445:
; .FSTART _test_7445
; 0000 00FC     unsigned char input, expected_PA, expected_PD, i;
; 0000 00FD     unsigned char outputs_PD, outputs_PA;
; 0000 00FE 
; 0000 00FF     // Configure input pins as outputs (from MCU)
; 0000 0100     DDRD |= IC_7445.input_mask_PD;
	CALL SUBOPT_0x10
;	input -> R17
;	expected_PA -> R16
;	expected_PD -> R19
;	i -> R18
;	outputs_PD -> R21
;	outputs_PA -> R20
	__GETB1MN _ICs,14
	CALL SUBOPT_0x1
; 0000 0101     DDRA |= IC_7445.input_mask_PA;
	__GETB1MN _ICs,15
	CALL SUBOPT_0x2
; 0000 0102 
; 0000 0103     // Configure output pins as inputs (from MCU)
; 0000 0104     DDRD &= ~IC_7445.output_mask_PD;
	__GETB1MN _ICs,16
	CALL SUBOPT_0x3
; 0000 0105     DDRA &= ~IC_7445.output_mask_PA;
	__GETB1MN _ICs,17
	CALL SUBOPT_0x4
; 0000 0106 
; 0000 0107     // Set initial input states to low
; 0000 0108     PORTD &= ~IC_7445.input_mask_PD;
	__GETB1MN _ICs,14
	CALL SUBOPT_0x5
; 0000 0109     PORTA &= ~IC_7445.input_mask_PA;
	__GETB1MN _ICs,15
	COM  R30
	AND  R30,R26
	OUT  0x1B,R30
; 0000 010A 
; 0000 010B     power_ic(IC_7445.package_type);
	__GETB2MN _ICs,18
	RCALL _power_ic
; 0000 010C 
; 0000 010D     // Testing loop for all BCD inputs
; 0000 010E     for (i = 0; i < 10; i++) {
	LDI  R18,LOW(0)
_0x32:
	CPI  R18,10
	BRSH _0x33
; 0000 010F         // Set inputs (BCD value)
; 0000 0110         input = i;
	MOV  R17,R18
; 0000 0111         PORTA = (PORTA & ~IC_7445.input_mask_PA) | ((input & 0x0F) << PORTA1); // Set D, C, B, A
	IN   R30,0x1B
	MOV  R26,R30
	__GETB1MN _ICs,15
	CALL SUBOPT_0x13
	ANDI R30,LOW(0xF)
	LSL  R30
	CALL SUBOPT_0xB
; 0000 0112 
; 0000 0113         delay_ms(20); // Allow time for IC to process
; 0000 0114 
; 0000 0115         // Read outputs
; 0000 0116         outputs_PD = (PIND & IC_7445.output_mask_PD); // Outputs 0-6
	MOV  R26,R30
	__GETB1MN _ICs,16
	AND  R30,R26
	MOV  R21,R30
; 0000 0117         outputs_PA = (PINA & IC_7445.output_mask_PA); // Outputs 7-9
	IN   R30,0x19
	MOV  R26,R30
	__GETB1MN _ICs,17
	AND  R30,R26
	MOV  R20,R30
; 0000 0118 
; 0000 0119 		expected_PD = 0x7F; // All high initially
	LDI  R19,LOW(127)
; 0000 011A         expected_PA = 0xE0;
	LDI  R16,LOW(224)
; 0000 011B 
; 0000 011C         delay_ms(10);
	CALL SUBOPT_0x14
; 0000 011D 
; 0000 011E         if (input < 7) {
	CPI  R17,7
	BRSH _0x34
; 0000 011F             expected_PD &= ~(1 << input); // Set the correct bit low
	MOV  R30,R17
	CALL SUBOPT_0x15
	AND  R19,R30
; 0000 0120         } else {
	RJMP _0x35
_0x34:
; 0000 0121             expected_PA &= ~(1 << (14 - input));
	LDI  R30,LOW(14)
	SUB  R30,R17
	CALL SUBOPT_0x15
	AND  R16,R30
; 0000 0122         }
_0x35:
; 0000 0123 
; 0000 0124 		 if (outputs_PD != expected_PD || outputs_PA != expected_PA) {
	CP   R19,R21
	BRNE _0x37
	CP   R16,R20
	BREQ _0x36
_0x37:
; 0000 0125             return 0; // Test failed
	LDI  R30,LOW(0)
	CALL __LOADLOCR6
	JMP  _0x2120008
; 0000 0126         }
; 0000 0127     }
_0x36:
	SUBI R18,-1
	RJMP _0x32
_0x33:
; 0000 0128 
; 0000 0129     glcd_clear();
	CALL _glcd_clear
; 0000 012A     glcd_drawCenteredStr("IC is 7445", LINES_DY * 2, 1);
	__POINTW1MN _0x39,0
	CALL SUBOPT_0x0
; 0000 012B     glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
	__POINTW1MN _0x39,11
	CALL SUBOPT_0x16
; 0000 012C     return 1; // Test passed
	CALL __LOADLOCR6
	JMP  _0x2120008
; 0000 012D }
; .FEND

	.DSEG
_0x39:
	.BYTE 0x17
;
;unsigned char test_4532(void) {
; 0000 012F unsigned char test_4532(void) {

	.CSEG
_test_4532:
; .FSTART _test_4532
; 0000 0130     unsigned char input;
; 0000 0131     unsigned char outputs_PD;
; 0000 0132     unsigned char outputs_PA;
; 0000 0133     unsigned char expected_output;
; 0000 0134     unsigned char q0;
; 0000 0135     unsigned char q2;
; 0000 0136     unsigned char q1;
; 0000 0137     unsigned char combined_output;
; 0000 0138 
; 0000 0139     // Configure input pins as outputs (from MCU)
; 0000 013A     DDRD |= IC_4532.input_mask_PD;
	SBIW R28,2
	CALL SUBOPT_0x10
;	input -> R17
;	outputs_PD -> R16
;	outputs_PA -> R19
;	expected_output -> R18
;	q0 -> R21
;	q2 -> R20
;	q1 -> Y+7
;	combined_output -> Y+6
	__GETB1MN _ICs,21
	CALL SUBOPT_0x1
; 0000 013B     DDRA |= IC_4532.input_mask_PA;
	__GETB1MN _ICs,22
	CALL SUBOPT_0x2
; 0000 013C 
; 0000 013D     // Configure output pins as inputs (from MCU)
; 0000 013E     DDRD &= ~IC_4532.output_mask_PD;
	__GETB1MN _ICs,23
	CALL SUBOPT_0x3
; 0000 013F     DDRA &= ~IC_4532.output_mask_PA;
	__GETB1MN _ICs,24
	CALL SUBOPT_0x4
; 0000 0140 
; 0000 0141     // Set initial input states to low (important for priority encoder)
; 0000 0142     PORTD &= ~IC_4532.input_mask_PD;
	__GETB1MN _ICs,21
	CALL SUBOPT_0x5
; 0000 0143     PORTA &= ~IC_4532.input_mask_PA;
	__GETB1MN _ICs,22
	COM  R30
	AND  R30,R26
	OUT  0x1B,R30
; 0000 0144 
; 0000 0145     // Set EN_IN high to enable the encoder
; 0000 0146     PORTD |= (1 << PORTD4); // Assuming PORTD4 is EN_IN
	SBI  0x12,4
; 0000 0147 
; 0000 0148     power_ic(IC_4532.package_type);
	__GETB2MN _ICs,25
	RCALL _power_ic
; 0000 0149 
; 0000 014A     // Test each input individually, starting with the highest priority
; 0000 014B     for (input = 7; input > 0; input--) {
	LDI  R17,LOW(7)
_0x3B:
	CPI  R17,1
	BRSH PC+2
	RJMP _0x3C
; 0000 014C 
; 0000 014D 		PORTD &= ~((1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2) | (1 << PORTD3));
	IN   R30,0x12
	ANDI R30,LOW(0xF0)
	OUT  0x12,R30
; 0000 014E 		PORTA &= ~((1 << PORTA3) | (1 << PORTA4) | (1 << PORTA5) | (1 << PORTA6));
	IN   R30,0x1B
	ANDI R30,LOW(0x87)
	OUT  0x1B,R30
; 0000 014F 
; 0000 0150         // Set the current input high
; 0000 0151         if (input < 4) {
	CPI  R17,4
	BRSH _0x3D
; 0000 0152             PORTA |= (1 << (PORTA3 + (3 - input))); // Set inputs 0-3
	IN   R1,27
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(3)
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x1B,R30
; 0000 0153         } else {
	RJMP _0x3E
_0x3D:
; 0000 0154             PORTD |= (1 << (PORTD0 + (input - 4))); // Set inputs 4-7
	IN   R1,18
	MOV  R30,R17
	SUBI R30,LOW(4)
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x12,R30
; 0000 0155         }
_0x3E:
; 0000 0156 
; 0000 0157         delay_ms(20);
	CALL SUBOPT_0x17
; 0000 0158 
; 0000 0159         // Read outputs
; 0000 015A         outputs_PD = (PIND & IC_4532.output_mask_PD);
	MOV  R26,R30
	__GETB1MN _ICs,23
	AND  R30,R26
	MOV  R16,R30
; 0000 015B         outputs_PA = (PINA & IC_4532.output_mask_PA);
	IN   R30,0x19
	MOV  R26,R30
	__GETB1MN _ICs,24
	AND  R30,R26
	MOV  R19,R30
; 0000 015C 
; 0000 015D 		delay_ms(10);
	CALL SUBOPT_0x14
; 0000 015E 
; 0000 015F         //Extract the relevant bits
; 0000 0160         q0 = (outputs_PA >> PORTA7) & 0x01;
	MOV  R30,R19
	ROL  R30
	LDI  R30,0
	ROL  R30
	ANDI R30,LOW(0x1)
	MOV  R21,R30
; 0000 0161         q2 = (outputs_PD >> PORTD5) & 0x01;
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	MOV  R20,R30
; 0000 0162         q1 = (outputs_PD >> PORTD6) & 0x01;
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	STD  Y+7,R30
; 0000 0163 
; 0000 0164         // Combine the outputs
; 0000 0165         combined_output = (q2 << 2) | (q1 << 1) | q0;
	MOV  R30,R20
	LSL  R30
	LSL  R30
	MOV  R26,R30
	LDD  R30,Y+7
	LSL  R30
	OR   R30,R26
	OR   R30,R21
	STD  Y+6,R30
; 0000 0166 
; 0000 0167         //Calculate the expected output
; 0000 0168         expected_output = input;
	MOV  R18,R17
; 0000 0169 
; 0000 016A         // Check the outputs
; 0000 016B         if (combined_output != expected_output) {
	LDD  R26,Y+6
	CP   R18,R26
	BREQ _0x3F
; 0000 016C             return 0; // Test failed
	LDI  R30,LOW(0)
	RJMP _0x212000B
; 0000 016D         }
; 0000 016E     }
_0x3F:
	SUBI R17,1
	RJMP _0x3B
_0x3C:
; 0000 016F 
; 0000 0170     glcd_clear();
	CALL _glcd_clear
; 0000 0171     glcd_drawCenteredStr("IC is 4532", LINES_DY * 2, 1);
	__POINTW1MN _0x40,0
	CALL SUBOPT_0x0
; 0000 0172     glcd_drawCenteredStr("DIP16 - CMOS", LINES_DY * 3, 1);
	__POINTW1MN _0x40,11
	CALL SUBOPT_0x16
; 0000 0173     return 1; // Test passed
_0x212000B:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 0174 }
; .FEND

	.DSEG
_0x40:
	.BYTE 0x18
;
;unsigned char test_74157(void) {
; 0000 0176 unsigned char test_74157(void) {

	.CSEG
_test_74157:
; .FSTART _test_74157
; 0000 0177 	unsigned char select;
; 0000 0178     unsigned char i;
; 0000 0179     unsigned char input1, input2, expected_output;
; 0000 017A     unsigned char output1, output2, output3, output4;
; 0000 017B 
; 0000 017C 	// Configure input pins as outputs (from MCU)
; 0000 017D     DDRD |= IC_74157.input_mask_PD;
	SBIW R28,3
	CALL SUBOPT_0x10
;	select -> R17
;	i -> R16
;	input1 -> R19
;	input2 -> R18
;	expected_output -> R21
;	output1 -> R20
;	output2 -> Y+8
;	output3 -> Y+7
;	output4 -> Y+6
	__GETB1MN _ICs,28
	CALL SUBOPT_0x1
; 0000 017E     DDRA |= IC_74157.input_mask_PA;
	__GETB1MN _ICs,29
	CALL SUBOPT_0x2
; 0000 017F 
; 0000 0180     // Configure output pins as inputs (from MCU)
; 0000 0181     DDRD &= ~IC_74157.output_mask_PD;
	__GETB1MN _ICs,30
	CALL SUBOPT_0x3
; 0000 0182     DDRA &= ~IC_74157.output_mask_PA;
	__GETB1MN _ICs,31
	COM  R30
	AND  R30,R26
	OUT  0x1A,R30
; 0000 0183 
; 0000 0184 	power_ic(IC_74157.package_type);
	__GETB2MN _ICs,32
	RCALL _power_ic
; 0000 0185 
; 0000 0186 	// Enable the 74157
; 0000 0187     PORTA &= ~(1 << PORTA1); // Enable low (PORTA1)
	CBI  0x1B,1
; 0000 0188 	PORTD &= ~(1 << PORTD0); // Select pin cleared
	CBI  0x12,0
; 0000 0189 
; 0000 018A 	for (select = 0; select <= 1; select++) {
	LDI  R17,LOW(0)
_0x42:
	CPI  R17,2
	BRLO PC+2
	RJMP _0x43
; 0000 018B         for (i = 0; i < 4; i++) {
	LDI  R16,LOW(0)
_0x45:
	CPI  R16,4
	BRLO PC+2
	RJMP _0x46
; 0000 018C 			input1 = (i & 0x01); // LSB of inputs
	MOV  R30,R16
	ANDI R30,LOW(0x1)
	MOV  R19,R30
; 0000 018D 			input2 = (i & 0x02) >> 1; // MSB of inputs
	MOV  R30,R16
	CALL SUBOPT_0x6
	MOV  R18,R30
; 0000 018E 
; 0000 018F 			// Set inputs for Mux 1 and Mux 2 on PORTD
; 0000 0190 			PORTD = (PORTD & ~IC_74157.input_mask_PD) | (input1 << PORTD1) | (input2 << PORTD2) | (input1 << PORTD4) | (input2 << ...
	IN   R30,0x12
	MOV  R26,R30
	__GETB1MN _ICs,28
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R19
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R18
	CALL SUBOPT_0x11
	MOV  R30,R18
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	CALL SUBOPT_0x8
; 0000 0191 
; 0000 0192 			// Set inputs for Mux 3 and Mux 4 on PORTA
; 0000 0193 			PORTA = (PORTA & ~IC_74157.input_mask_PA) | (input1 << PORTA2) | (input2 << PORTA3) | (input1 << PORTA5) | (input2 << ...
	__GETB1MN _ICs,29
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R19
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R18
	CALL SUBOPT_0x7
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R18
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	OR   R30,R26
	OUT  0x1B,R30
; 0000 0194 
; 0000 0195 			// Set Select Pin
; 0000 0196 			PORTD |= (select << PORTD0);
	IN   R30,0x12
	OR   R30,R17
	OUT  0x12,R30
; 0000 0197 
; 0000 0198 			delay_ms(20);
	CALL SUBOPT_0x17
; 0000 0199 
; 0000 019A 			// Read outputs for all Muxs
; 0000 019B 			output1 = (PIND & (1 << PORTD3)) >> PORTD3; // Gate 1 output
	ANDI R30,LOW(0x8)
	LDI  R31,0
	CALL __ASRW3
	MOV  R20,R30
; 0000 019C 			output2 = (PIND & (1 << PORTD6)) >> PORTD6; // Gate 2 output
	IN   R30,0x10
	CALL SUBOPT_0xE
	STD  Y+8,R30
; 0000 019D 			output3 = (PINA & (1 << PORTA7)) >> PORTA7; // Gate 3 output
	IN   R30,0x19
	ANDI R30,LOW(0x80)
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	STD  Y+7,R30
; 0000 019E 			output4 = (PINA & (1 << PORTA4)) >> PORTA4; // Gate 4 output
	IN   R30,0x19
	ANDI R30,LOW(0x10)
	LDI  R31,0
	CALL __ASRW4
	CALL SUBOPT_0xF
; 0000 019F 
; 0000 01A0 			delay_ms(10);
; 0000 01A1 
; 0000 01A2 			// Verify Mux truth table
; 0000 01A3 			expected_output = (select == 0) ? input1 : input2;
	CPI  R17,0
	BRNE _0x47
	MOV  R30,R19
	RJMP _0x48
_0x47:
	MOV  R30,R18
_0x48:
	MOV  R21,R30
; 0000 01A4             if (output1 != expected_output) return 0;
	CP   R21,R20
	BREQ _0x4A
	LDI  R30,LOW(0)
	RJMP _0x212000A
; 0000 01A5             if (output2 != expected_output) return 0;
_0x4A:
	LDD  R26,Y+8
	CP   R21,R26
	BREQ _0x4B
	LDI  R30,LOW(0)
	RJMP _0x212000A
; 0000 01A6             if (output3 != expected_output) return 0;
_0x4B:
	LDD  R26,Y+7
	CP   R21,R26
	BREQ _0x4C
	LDI  R30,LOW(0)
	RJMP _0x212000A
; 0000 01A7             if (output4 != expected_output) return 0;
_0x4C:
	LDD  R26,Y+6
	CP   R21,R26
	BREQ _0x4D
	LDI  R30,LOW(0)
	RJMP _0x212000A
; 0000 01A8 
; 0000 01A9 		}
_0x4D:
	SUBI R16,-1
	RJMP _0x45
_0x46:
; 0000 01AA     }
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 01AB 
; 0000 01AC 	glcd_clear();
	CALL _glcd_clear
; 0000 01AD     glcd_drawCenteredStr("IC is 74157", LINES_DY * 2, 1);
	__POINTW1MN _0x4E,0
	CALL SUBOPT_0x0
; 0000 01AE     glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
	__POINTW1MN _0x4E,12
	CALL SUBOPT_0x16
; 0000 01AF     return 1; // Test passed
_0x212000A:
	CALL __LOADLOCR6
	ADIW R28,9
	RET
; 0000 01B0 }
; .FEND

	.DSEG
_0x4E:
	.BYTE 0x18
;
;
;unsigned char test_74156(void) {
; 0000 01B3 unsigned char test_74156(void) {

	.CSEG
_test_74156:
; .FSTART _test_74156
; 0000 01B4 	unsigned char address;
; 0000 01B5     unsigned char expected_output;
; 0000 01B6     unsigned char outputs_PD;
; 0000 01B7     unsigned char outputs_PA;
; 0000 01B8 //	char str[12];
; 0000 01B9 
; 0000 01BA 	// Configure input pins as outputs (from MCU)
; 0000 01BB     DDRD |= IC_74156.input_mask_PD;
	CALL __SAVELOCR4
;	address -> R17
;	expected_output -> R16
;	outputs_PD -> R19
;	outputs_PA -> R18
	IN   R30,0x11
	MOV  R26,R30
	__GETB1MN _ICs,35
	CALL SUBOPT_0x1
; 0000 01BC     DDRA |= IC_74156.input_mask_PA;
	__GETB1MN _ICs,36
	CALL SUBOPT_0x2
; 0000 01BD 
; 0000 01BE     // Configure output pins as inputs (from MCU)
; 0000 01BF     DDRD &= ~IC_74156.output_mask_PD;
	__GETB1MN _ICs,37
	CALL SUBOPT_0x3
; 0000 01C0     DDRA &= ~IC_74156.output_mask_PA;
	__GETB1MN _ICs,38
	CALL SUBOPT_0x4
; 0000 01C1 
; 0000 01C2 	// Enable pull-up for ouptuts
; 0000 01C3 	PORTD |= IC_74156.output_mask_PD;
	__GETB1MN _ICs,37
	CALL SUBOPT_0x8
; 0000 01C4 	PORTA |= IC_74156.output_mask_PA ;
	__GETB1MN _ICs,38
	OR   R30,R26
	OUT  0x1B,R30
; 0000 01C5 
; 0000 01C6 	power_ic(IC_74156.package_type);
	__GETB2MN _ICs,39
	RCALL _power_ic
; 0000 01C7 
; 0000 01C8 	// Enable the 74156
; 0000 01C9     PORTA &= ~(1 << PORTA2);
	CBI  0x1B,2
; 0000 01CA 	PORTD &= ~(1 << PORTD1);
	CBI  0x12,1
; 0000 01CB 
; 0000 01CC 	// Test for all addresses
; 0000 01CD     for (address = 0; address <= 3; address++) {
	LDI  R17,LOW(0)
_0x50:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x51
; 0000 01CE 
; 0000 01CF 
; 0000 01D0         // Set address lines
; 0000 01D1         PORTD = (PORTD & ~IC_74156.input_mask_PD) | (((address & 0x02) >> 1) << PORTD2); // Address B
	IN   R30,0x12
	MOV  R26,R30
	__GETB1MN _ICs,35
	CALL SUBOPT_0x13
	CALL SUBOPT_0x6
	LSL  R30
	LSL  R30
	CALL SUBOPT_0x8
; 0000 01D2         PORTA = (PORTA & ~IC_74156.input_mask_PA) | ((address & 0x01) << PORTA3); // Address A
	__GETB1MN _ICs,36
	CALL SUBOPT_0x13
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R30,R26
	OUT  0x1B,R30
; 0000 01D3 
; 0000 01D4 
; 0000 01D5         // Test with input high
; 0000 01D6         PORTD |= (1 << PORTD0); // I1 high
	SBI  0x12,0
; 0000 01D7         PORTA &= ~(1 << PORTA1); // I2 Low
	CBI  0x1B,1
; 0000 01D8 
; 0000 01D9 
; 0000 01DA         delay_ms(20);
	CALL SUBOPT_0x17
; 0000 01DB 
; 0000 01DC         outputs_PD = (PIND & IC_74156.output_mask_PD) >> PORTD3;
	MOV  R26,R30
	__GETB1MN _ICs,37
	AND  R30,R26
	LDI  R31,0
	CALL __ASRW3
	MOV  R19,R30
; 0000 01DD         outputs_PA = (PINA & IC_74156.output_mask_PA) >> PORTA4;
	IN   R30,0x19
	MOV  R26,R30
	__GETB1MN _ICs,38
	AND  R30,R26
	LDI  R31,0
	CALL __ASRW4
	MOV  R18,R30
; 0000 01DE 		expected_output = (~(1 << address)) & 0x0F;
	MOV  R30,R17
	CALL SUBOPT_0x15
	ANDI R30,LOW(0xF)
	MOV  R16,R30
; 0000 01DF 
; 0000 01E0 		outputs_PD = reverseBits(outputs_PD) >> 4;
	MOV  R26,R19
	RCALL _reverseBits
	LDI  R31,0
	CALL __ASRW4
	MOV  R19,R30
; 0000 01E1 		outputs_PA = reverseBits(outputs_PA) >> 4;
	MOV  R26,R18
	RCALL _reverseBits
	LDI  R31,0
	CALL __ASRW4
	MOV  R18,R30
; 0000 01E2 
; 0000 01E3 
; 0000 01E4 		// sprintf(str, "%d %d %d", expected_output, outputs_PD, outputs_PA);
; 0000 01E5 		// glcd_drawCenteredStr(str, LINES_DY * 3, 1);
; 0000 01E6 
; 0000 01E7 		delay_ms(10);
	CALL SUBOPT_0x14
; 0000 01E8 
; 0000 01E9 
; 0000 01EA         if((outputs_PD != expected_output) || (outputs_PA != expected_output)) return 0;
	CP   R16,R19
	BRNE _0x53
	CP   R16,R18
	BREQ _0x52
_0x53:
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	JMP  _0x2120001
; 0000 01EB 
; 0000 01EC 
; 0000 01ED     }
_0x52:
	SUBI R17,-1
	RJMP _0x50
_0x51:
; 0000 01EE 
; 0000 01EF 	glcd_clear();
	CALL _glcd_clear
; 0000 01F0     glcd_drawCenteredStr("IC is 74156", LINES_DY * 2, 1);
	__POINTW1MN _0x55,0
	CALL SUBOPT_0x0
; 0000 01F1     glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
	__POINTW1MN _0x55,12
	CALL SUBOPT_0x16
; 0000 01F2     return 1; // Test passed
	CALL __LOADLOCR4
	JMP  _0x2120001
; 0000 01F3 
; 0000 01F4 }
; .FEND

	.DSEG
_0x55:
	.BYTE 0x18
;
;
;
;unsigned char is_button_pressed(void) {
; 0000 01F8 unsigned char is_button_pressed(void) {

	.CSEG
_is_button_pressed:
; .FSTART _is_button_pressed
; 0000 01F9     // Read the button state
; 0000 01FA     if (!(PINB & (1 << TEST_BUTTON_PIN))) { // Active LOW
	SBIC 0x16,3
	RJMP _0x56
; 0000 01FB         delay_ms(50); // Debounce delay
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 01FC         if (!(PINB & (1 << TEST_BUTTON_PIN))) {
	SBIC 0x16,3
	RJMP _0x57
; 0000 01FD             return 1; // Button is pressed
	LDI  R30,LOW(1)
	RET
; 0000 01FE         }
; 0000 01FF     }
_0x57:
; 0000 0200     return 0; // Button is not pressed
_0x56:
	LDI  R30,LOW(0)
	RET
; 0000 0201 }
; .FEND
;
;
;void clear_LEDs() {
; 0000 0204 void clear_LEDs() {
_clear_LEDs:
; .FSTART _clear_LEDs
; 0000 0205 	PORTC &= ~(1 << LED_PASS);
	CBI  0x15,0
; 0000 0206 	PORTC &= ~(1 << LED_FAIL);
	CBI  0x15,1
; 0000 0207 
; 0000 0208 }
	RET
; .FEND
;
;void clear_ports() {
; 0000 020A void clear_ports() {
_clear_ports:
; .FSTART _clear_ports
; 0000 020B 	PORTA = 0;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 020C 	PORTD = 0;
	OUT  0x12,R30
; 0000 020D }
	RET
; .FEND
;
;
;
;void display_result(unsigned char result) {
; 0000 0211 void display_result(unsigned char result) {
_display_result:
; .FSTART _display_result
; 0000 0212     if (result) {
	ST   -Y,R26
;	result -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x58
; 0000 0213         PORTC |= (1 << LED_PASS); // Light up pass LED
	SBI  0x15,0
; 0000 0214         PORTC &= ~(1 << LED_FAIL); // Turn off fail LED
	CBI  0x15,1
; 0000 0215         // glcd_clear();
; 0000 0216 		// glcd_drawCenteredStr("OK!!", LINES_DY * 2, 1);
; 0000 0217 
; 0000 0218 
; 0000 0219     } else {
	RJMP _0x59
_0x58:
; 0000 021A         PORTC |= (1 << LED_FAIL); // Light up fail LED
	SBI  0x15,1
; 0000 021B         PORTC &= ~(1 << LED_PASS); // Turn off pass LED
	CBI  0x15,0
; 0000 021C         glcd_clear();
	CALL _glcd_clear
; 0000 021D 		glcd_drawCenteredStr("Unknown IC", LINES_DY * 2, 1);
	__POINTW1MN _0x5A,0
	CALL SUBOPT_0x0
; 0000 021E 
; 0000 021F     }
_0x59:
; 0000 0220 }
	JMP  _0x2120009
; .FEND

	.DSEG
_0x5A:
	.BYTE 0xB
;
;
;unsigned char reverseBits(unsigned char num)
; 0000 0224 {

	.CSEG
_reverseBits:
; .FSTART _reverseBits
; 0000 0225     unsigned char count = sizeof(num) * 8 - 1;
; 0000 0226     unsigned char reverse_num = num;
; 0000 0227 
; 0000 0228     num >>= 1;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+2
;	count -> R17
;	reverse_num -> R16
	LDI  R17,7
	LDD  R16,Y+2
	LDD  R30,Y+2
	LSR  R30
	STD  Y+2,R30
; 0000 0229     while (num) {
_0x5B:
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x5D
; 0000 022A         reverse_num <<= 1;
	LSL  R16
; 0000 022B         reverse_num |= num & 1;
	ANDI R30,LOW(0x1)
	OR   R16,R30
; 0000 022C         num >>= 1;
	LDD  R30,Y+2
	LSR  R30
	STD  Y+2,R30
; 0000 022D         count--;
	SUBI R17,1
; 0000 022E     }
	RJMP _0x5B
_0x5D:
; 0000 022F     reverse_num <<= count;
	MOV  R30,R17
	MOV  R26,R16
	CALL __LSLB12
	MOV  R16,R30
; 0000 0230     return reverse_num;
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120002
; 0000 0231 }
; .FEND
;
;
;void glcd_drawCenteredStr(const char *str, uint8_t y, uint8_t dx)
; 0000 0235 {
_glcd_drawCenteredStr:
; .FSTART _glcd_drawCenteredStr
; 0000 0236     // Calculate the length of the string
; 0000 0237     uint8_t len = strlen(str);
; 0000 0238     uint8_t x;
; 0000 0239     uint8_t i = 0;
; 0000 023A 
; 0000 023B     // Calculate the starting X coordinate to center the string
; 0000 023C     if (len <= 15)
	ST   -Y,R26
	CALL __SAVELOCR4
;	*str -> Y+6
;	y -> Y+5
;	dx -> Y+4
;	len -> R17
;	x -> R16
;	i -> R19
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlen
	MOV  R17,R30
	LDI  R19,0
	CPI  R17,16
	BRSH _0x5E
; 0000 023D     {
; 0000 023E         x = (GLCD_LCD_WIDTH - len * 5 - (len - 1) * dx) / 2; // Center X position
	LDI  R30,LOW(5)
	MUL  R30,R17
	MOVW R30,R0
	LDI  R26,LOW(84)
	LDI  R27,HIGH(84)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R22,R26
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R30
	LDD  R30,Y+4
	LDI  R31,0
	CALL __MULW12
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R16,R30
; 0000 023F     }
; 0000 0240     else
	RJMP _0x5F
_0x5E:
; 0000 0241     {
; 0000 0242         x = 0; // Start at the beginning for long strings
	LDI  R16,LOW(0)
; 0000 0243     }
_0x5F:
; 0000 0244 
; 0000 0245 
; 0000 0246     // Loop through each character in the string
; 0000 0247     while (len > 0)
_0x60:
	CPI  R17,1
	BRLO _0x62
; 0000 0248     {
; 0000 0249         char c = str[i++];
; 0000 024A         if (!c)
	SBIW R28,1
;	*str -> Y+7
;	y -> Y+6
;	dx -> Y+5
;	c -> Y+0
	MOV  R30,R19
	SUBI R19,-1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   Y,R30
	CPI  R30,0
	BRNE _0x63
; 0000 024B         {
; 0000 024C             return; // Exit loop if null terminator is reached
	ADIW R28,1
	CALL __LOADLOCR4
	JMP  _0x2120005
; 0000 024D         }
; 0000 024E 
; 0000 024F         // Display the character using `glcd_putcharxy`
; 0000 0250         glcd_putcharxy(x, y, c);
_0x63:
	ST   -Y,R16
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_putcharxy
; 0000 0251 
; 0000 0252         // Update X coordinate for the next character
; 0000 0253         x += 5 + dx; // Character width (5 pixels) + spacing
	LDD  R30,Y+5
	SUBI R30,-LOW(5)
	ADD  R16,R30
; 0000 0254 
; 0000 0255         // If X exceeds the screen width, move to the next line
; 0000 0256         if (x > GLCD_LCD_WIDTH - 6)
	CPI  R16,79
	BRLO _0x64
; 0000 0257         {
; 0000 0258             x = 0;
	LDI  R16,LOW(0)
; 0000 0259             y += 10; // Move to the next line (font height + spacing)
	LDD  R30,Y+6
	SUBI R30,-LOW(10)
	STD  Y+6,R30
; 0000 025A         }
; 0000 025B 
; 0000 025C         len--; // Decrease remaining length
_0x64:
	SUBI R17,1
; 0000 025D     }
	ADIW R28,1
	RJMP _0x60
_0x62:
; 0000 025E }
	CALL __LOADLOCR4
	JMP  _0x2120005
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G101:
; .FSTART _pcd8544_delay_G101
	RET
; .FEND
_pcd8544_wrbus_G101:
; .FSTART _pcd8544_wrbus_G101
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x18,3
	LDI  R17,LOW(8)
_0x2020004:
	RCALL _pcd8544_delay_G101
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2020006
	SBI  0x18,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,5
_0x2020007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G101
	SBI  0x18,7
	RCALL _pcd8544_delay_G101
	CBI  0x18,7
	SUBI R17,LOW(1)
	BRNE _0x2020004
	SBI  0x18,3
	LDD  R17,Y+0
	JMP  _0x2120003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x18,0
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x2120009
; .FEND
_pcd8544_wrdata_G101:
; .FSTART _pcd8544_wrdata_G101
	ST   -Y,R26
	SBI  0x18,0
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x2120009
; .FEND
_pcd8544_setaddr_G101:
; .FSTART _pcd8544_setaddr_G101
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G101,R30
	STS  _gfx_addr_G101+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G101
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	JMP  _0x2120003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G101
	LDS  R31,_gfx_addr_G101+1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
	JMP  _0x2120003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x18
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G101
	RJMP _0x2120009
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	SBI  0x17,3
	SBI  0x18,3
	SBI  0x17,7
	CBI  0x18,7
	SBI  0x17,5
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,1
	CALL SUBOPT_0x14
	SBI  0x18,1
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2020008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20200A0
_0x2020008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20200A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2120008
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x202000A
	LDI  R30,LOW(12)
	RJMP _0x202000B
_0x202000A:
	LDI  R30,LOW(8)
_0x202000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x2120009:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x202000D
	LDI  R19,LOW(255)
_0x202000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x202000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2020010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x202000E
_0x2020010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2120001
; .FEND
_pcd8544_wrmasked_G101:
; .FSTART _pcd8544_wrmasked_G101
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2020020
	CPI  R30,LOW(0x8)
	BRNE _0x2020021
_0x2020020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2020022
_0x2020021:
	CPI  R30,LOW(0x3)
	BRNE _0x2020024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2020025
_0x2020024:
	CPI  R30,0
	BRNE _0x2020026
_0x2020025:
_0x2020022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2020027
_0x2020026:
	CPI  R30,LOW(0x2)
	BRNE _0x2020028
_0x2020027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x202001E
_0x2020028:
	CPI  R30,LOW(0x1)
	BRNE _0x2020029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x202001E
_0x2020029:
	CPI  R30,LOW(0x4)
	BRNE _0x202001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x202001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x2120008:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x202002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x202002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x202002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x202002B
_0x202002C:
	RJMP _0x2120007
_0x202002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x202002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x202002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x202002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x202002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2020030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2020034
	RJMP _0x2120007
_0x2020034:
	CPI  R30,LOW(0x3)
	BRNE _0x2020037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2020036
	RJMP _0x2120007
_0x2020036:
_0x2020037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2020039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2020038
_0x2020039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x19
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x202003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x202003D
	MOV  R17,R16
_0x202003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020040
	CALL SUBOPT_0x1A
	RJMP _0x202003E
_0x2020040:
	RJMP _0x202003B
_0x202003D:
_0x2020038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2020041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x19
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2020042
	SUBI R19,-LOW(1)
_0x2020042:
	LDI  R18,LOW(0)
_0x2020043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2020045
	LDD  R17,Y+14
_0x2020046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2020048
	CALL SUBOPT_0x1A
	RJMP _0x2020046
_0x2020048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x19
	RJMP _0x2020043
_0x2020045:
_0x2020041:
_0x2020030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2020049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x202004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x202004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2020052
	CPI  R30,LOW(0x3)
	BRNE _0x2020053
_0x2020052:
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x7)
	BRNE _0x2020055
_0x2020054:
	RJMP _0x2020056
_0x2020055:
	CPI  R30,LOW(0x8)
	BRNE _0x2020057
_0x2020056:
	RJMP _0x2020058
_0x2020057:
	CPI  R30,LOW(0x9)
	BRNE _0x2020059
_0x2020058:
	RJMP _0x202005A
_0x2020059:
	CPI  R30,LOW(0xA)
	BRNE _0x202005B
_0x202005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2020050
_0x202005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2020050
	CALL SUBOPT_0x1B
_0x2020050:
_0x202005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2020060
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x18
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2020061
_0x2020060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2020065
	LDI  R21,LOW(0)
	RJMP _0x2020066
_0x2020065:
	CPI  R30,LOW(0xA)
	BRNE _0x2020064
	LDI  R21,LOW(255)
	RJMP _0x2020066
_0x2020064:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x202006D
	CPI  R30,LOW(0x8)
	BRNE _0x202006E
_0x202006D:
_0x2020066:
	CALL SUBOPT_0x1E
	MOV  R21,R30
	RJMP _0x202006F
_0x202006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2020071
	COM  R21
	RJMP _0x2020072
_0x2020071:
	CPI  R30,0
	BRNE _0x2020074
_0x2020072:
_0x202006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G101
	RJMP _0x202006B
_0x2020074:
	CALL SUBOPT_0x1F
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
_0x202006B:
_0x2020061:
	RJMP _0x202005D
_0x202005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2020075
_0x202004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020076
_0x202004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2020077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020078
_0x2020077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2020078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x202007C
	CALL SUBOPT_0x1B
_0x202007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202007F
	CALL SUBOPT_0x18
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x20
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x202007D
_0x202007F:
	RJMP _0x202007B
_0x202007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2020080
	LDI  R21,LOW(0)
	RJMP _0x2020081
_0x2020080:
	CPI  R30,LOW(0xA)
	BRNE _0x2020087
	LDI  R21,LOW(255)
_0x2020081:
	CALL SUBOPT_0x1E
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2020084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020086
	CALL SUBOPT_0x1F
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020084
_0x2020086:
	RJMP _0x202007B
_0x2020087:
_0x2020088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202008A
	CALL SUBOPT_0x21
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020088
_0x202008A:
_0x202007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x202008B
	RJMP _0x202004B
_0x202008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x202008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20200A1
_0x202008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20200A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2020076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2020091
	CALL SUBOPT_0x1B
_0x2020092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020094
	CALL SUBOPT_0x18
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x20
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2020092
_0x2020094:
	RJMP _0x2020090
_0x2020091:
	CPI  R30,LOW(0x9)
	BRNE _0x2020095
	LDI  R21,LOW(0)
	RJMP _0x2020096
_0x2020095:
	CPI  R30,LOW(0xA)
	BRNE _0x202009C
	LDI  R21,LOW(255)
_0x2020096:
	CALL SUBOPT_0x1E
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2020099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009B
	CALL SUBOPT_0x1F
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020099
_0x202009B:
	RJMP _0x2020090
_0x202009C:
_0x202009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009F
	CALL SUBOPT_0x21
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x202009D
_0x202009F:
_0x2020090:
_0x2020075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020049
_0x202004B:
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x22
	BRLT _0x2040003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2040003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2040004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2120003
_0x2040004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x22
	BRLT _0x2040005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2040005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2040006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2120003
_0x2040006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_getcharw_G102:
; .FSTART _glcd_getcharw_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x23
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x204000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000B:
	CALL SUBOPT_0x24
	STD  Y+7,R0
	CALL SUBOPT_0x24
	STD  Y+6,R0
	CALL SUBOPT_0x24
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x204000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x204000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x204000E
	SUBI R20,-LOW(1)
_0x204000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x204000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120006
_0x204000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2040010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2040012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2040010
_0x2040012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G102:
; .FSTART _glcd_new_line_G102
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x25
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x23
	SBIW R30,0
	BRNE PC+2
	RJMP _0x204001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2040020
	RJMP _0x2040021
_0x2040020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G102
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2040022
	RJMP _0x2120004
_0x2040022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2040023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G102
_0x2040023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x25
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x25
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x26
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2040024
_0x2040021:
	RCALL _glcd_new_line_G102
	RJMP _0x2120004
_0x2040024:
_0x204001F:
	__PUTBMRN _glcd_state,2,16
_0x2120004:
	CALL __LOADLOCR6
_0x2120005:
	ADIW R28,8
	RET
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2120003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20A0007
	CPI  R30,LOW(0xA)
	BRNE _0x20A0008
_0x20A0007:
	LDS  R17,_glcd_state
	RJMP _0x20A0009
_0x20A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20A0009
_0x20A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20A0005
	__GETBRMN 17,_glcd_state,16
_0x20A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20A000E
	CPI  R17,0
	BREQ _0x20A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000E:
	CPI  R17,0
	BRNE _0x20A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A0011:
_0x20A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20A0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x20A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20A0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20A001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20A001B
_0x20A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20A001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20A001B
_0x20A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20A001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_ICs:
	.BYTE 0x2A
_gfx_addr_G101:
	.BYTE 0x2
_gfx_buffer_G101:
	.BYTE 0x1F8
__seed_G108:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _glcd_drawCenteredStr

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	OR   R30,R26
	OUT  0x11,R30
	IN   R30,0x1A
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	OR   R30,R26
	OUT  0x1A,R30
	IN   R30,0x11
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	COM  R30
	AND  R30,R26
	OUT  0x11,R30
	IN   R30,0x1A
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	COM  R30
	AND  R30,R26
	OUT  0x1A,R30
	IN   R30,0x12
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
	IN   R30,0x1B
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ANDI R30,LOW(0x2)
	LDI  R31,0
	ASR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	OR   R30,R26
	OUT  0x12,R30
	IN   R30,0x1B
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R16
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	MOV  R30,R19
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	OR   R30,R26
	OUT  0x1B,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ANDI R30,LOW(0x20)
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __ASRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOV  R21,R30
	IN   R30,0x19
	ANDI R30,LOW(0x8)
	LDI  R31,0
	CALL __ASRW3
	MOV  R20,R30
	IN   R30,0x19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ANDI R30,LOW(0x40)
	LDI  R31,0
	CALL __ASRW2
	CALL __ASRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	STD  Y+6,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	CALL __SAVELOCR6
	IN   R30,0x11
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R19
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _glcd_drawCenteredStr
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_gfx_addr_G101)
	LDI  R27,HIGH(_gfx_addr_G101)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xACD
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
