	;lengte:128-32
SPRITEATR2:
	DB	219,120,0,0,219,120,16,0	;de Z
	DB	219,136,4,0,219,136,20,0
	DB	219,120,8,0,219,120,24,0
	DB	219,136,12,0,219,136,28,0
	DB	219,172,32,0,219,172,48,0	;de N
	DB	219,188,36,0,219,188,52,0
	DB	219,172,40,0,219,172,56,0
	DB	219,188,44,0,219,188,60,0
	DB	180,16,156,0,180,16,176,0	;plasma
	DB	219,186,100,0,219,186,128,0 ;ontplof plasma
	DB	219,00,208,0,219,00,212,0	;bom
	DB	219,192,200,0,219,220,204,0 ;kogel/voet
	DB	0,210,96,0


	;letters ANMA bubble stuk voor stuk
AMAZCOMM1:
	DW	0            ;Van (X)
	DB	0 ,2         ;Van (Y)
	DW	0            ;Naar (X)
	DB	68,0         ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop


	;letters van AMAZING stuk voor stuk
AMAZCOMM2:
	DW	0            ;Van (X)
	DB	16,2         ;Van (Y)
	DW	0            ;Naar (X)
	DB	90,0         ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de I naar boven scrollen
AMAZCOMM6:
	DW	154          ;Van (X)
	DB	92 ,0        ;Van (Y)
	DW	154          ;Naar (X)
	DB	88 ,0        ;Naar (Y)
	DW	16           ;Aantal horizontaal
	DW	38           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;NOSH naar onderen
AMAZCOMM7:
	DW	238          ;Van (X)
	DB	0  ,3        ;Van (Y)
	DW	210          ;Naar (X)
	DB	0  ,0        ;Naar (Y)
	DW	16           ;Aantal horizontaal
	DW	17           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;NOSH naar rechts
AMAZCOMM8:
	DW	0            ;Van (X)
	DB	129,3        ;Van (Y)
	DW	209          ;Naar (X)
	DB	73 ,0        ;Naar (Y)
	DW	17           ;Aantal horizontaal
	DW	16           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

	;de G naar onderen
AMAZCOMM9:
	DW	206          ;Van (X)
	DB	121 ,0        ;Van (Y)
	DW	206          ;Naar (X)
	DB	123,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	34           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00001000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de Z verwijderen
AMAZCOMM10:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	120          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;de A rood maken
AMAZCOMM11:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	18           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	088H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10001011B    ;Commando/Logop

	;de A iets naar links
AMAZCOMM12:
	DW	18           ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	16           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	34           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de A iets naar rechts
AMAZCOMM13:
	DW	47           ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	49           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	34           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000100B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de A weer iets naar rechts
AMAZCOMM14:
	DW	49           ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	51           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	34           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000100B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de A weer iets naar links
AMAZCOMM15:
	DW	20           ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	18           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	34           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;troep tussen A en M verwijderen
AMAZCOMM16:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	52           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	2            ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;de M iets naar rechts (tegen de A aan)
AMAZCOMM17:
	DW	83           ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	85           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000100B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de letters MA 4 punten naar rechts
AMAZCOMM18:
	DW	117          ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	121          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	68           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000100B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de A langzaam weer wit maken
AMAZCOMM19:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	18           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	088H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	10001011B    ;Commando/Logop

	;Wis de letter N
AMAZCOMM20:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	172          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;Zet NOSH zonder poten neer
AMAZCOMM21:
	DW	220          ;Van (X)
	DB	147 ,3       ;Van (Y)
	DW	210          ;Naar (X)
	DB	73 ,0        ;Naar (Y)
	DW	16           ;Aantal horizontaal
	DW	16           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;Zet de letter N onder de sprites
AMAZCOMM22:
	DW	192          ;Van (X)
	DB	64  ,2       ;Van (Y)
	DW	52           ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;de M 2 punten naar links
AMAZCOMM23:
	DW	106          ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	104          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;troep tussen M en A weg
AMAZCOMM24:
	DW	0            ;Van (X)
	DB	0   ,0       ;Van (Y)
	DW	136          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	2            ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;de letters MA naar links
AMAZCOMM25:
	DW	104          ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	102          ;Naar (X)
	DB	90 ,0        ;Naar (Y)
	DW	68           ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;ANMA als geheel schuin naar boven
AMAZCOMM26:
	DW	151          ;Van (X)
	DB	90  ,0       ;Van (Y)
	DW	153          ;Naar (X)
	DB	89 ,0        ;Naar (Y)
	DW	136          ;Aantal horizontaal
	DW	33           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000100B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;Neerzetten van een letter van PRESENTS
AMAZCOMM27:
	DW	248          ;Van (X)
	DB	120 ,2       ;Van (Y)
	DW	82           ;Naar (X)
	DB	163,0        ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	8            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

NOSHDOWN:
	DB	128,146,164,146 ;y-coordinaten
NOSHRIGDAT:
	DB	183,201,219,201 ;x-coordinaten

AMAZCOMDAT:
	DB	160,32,32,18
	DB	192,32,32,52
	DB	160,32,32,86
	DB	224,32,32,120
	DB	176,64,16,154
	DB	192,64,32,172
	DB	224,64,32,206

AMAZSTACK:
	DW	0

PALLETROOD:
	DB	070H,000H,070H,000H,070H,000H,070H,000H
	DB	070H,000H,070H,000H,070H,000H,070H,000H
	DB	070H,000H,070H,000H,070H,000H,070H,000H
	DB	070H,000H,070H,000H,070H,000H,070H,000H

PALLETWIT:
	DB	077H,007H,077H,007H,077H,007H,077H,007H
	DB	077H,007H,077H,007H,077H,007H,077H,007H
	DB	077H,007H,077H,007H,077H,007H,077H,007H
	DB	077H,007H,077H,007H,077H,007H,077H,007H

	;Pallet van het AMAZING ANMA gedeelte.
PALLET4:
	DB	000H,000H,033H,003H,055H,005H,077H,007H
	DB	027H,003H,040H,004H,026H,002H,057H,005H
	DB	000H,000H,040H,000H,070H,000H,073H,003H
	DB	027H,006H,060H,006H,050H,000H,004H,000H

	;betekenis data: x-coordinaat van kleine letter
	;	          start x-coordinaat van sprite-letter
	;	          wel/geen optelling bij naar onderen
	;	          8 bytes voor vorm van letter
PRESDATA:
	DB	2,11111111B
	DB	11111110B
	DB	10000001B
	DB	10000001B
	DB	10000001B
	DB	11111110B
	DB	10000000B
	DB	10000000B
	DB	10000000B
	DB	19,11101110B
	DB	11111110B
	DB	10000001B
	DB	10000001B
	DB	10000001B
	DB	11111110B
	DB	10000100B
	DB	10000010B
	DB	10000001B
	DB	36,10101010B
	DB	11111111B
	DB	10000000B
	DB	10000000B
	DB	11110000B
	DB	10000000B
	DB	10000000B
	DB	10000000B
	DB	11111111B
	DB	53,01000100B
	DB	01111110B
	DB	10000001B
	DB	10000000B
	DB	01110000B
	DB	00001110B
	DB	00000001B
	DB	10000001B
	DB	01111110B
	DB	75,01000100B
	DB	11111111B
	DB	10000000B
	DB	10000000B
	DB	11110000B
	DB	10000000B
	DB	10000000B
	DB	10000000B
	DB	11111111B
	DB	91,10101010B
	DB	10000001B
	DB	11000001B
	DB	10100001B
	DB	10010001B
	DB	10001001B
	DB	10000101B
	DB	10000011B
	DB	10000001B
	DB	106,11101110B
	DB	11111110B
	DB	00010000B
	DB	00010000B
	DB	00010000B
	DB	00010000B
	DB	00010000B
	DB	00010000B
	DB	00010000B
	DB	122,11111111B
	DB	01111110B
	DB	10000001B
	DB	10000000B
	DB	01110000B
	DB	00001110B
	DB	00000001B
	DB	10000001B
	DB	01111110B

	;Boog om N te bewegen. als bit 7=1 en bit 6=0 dan bit 0-5 =teller
	;Daarna komen y-offset en x-offset die teller keer verwerkt moeten
	;worden. Anders gelijk offset-y en offset-x en 1 keer verwerken.
	;Als teller =0 dan einde data.
NBOOG:
	DB	128+10,-2,5
	DB	0,0
	DB	128+26,-2,-4
	DB	128+3,-1,-4
	DB	0,-4
	DB	128+2, 0,-3
	DB	1,-3, 0,-3
	DB	128+2, 1,-3
	DB	128+4, 1,-2
	DB	128+3, 2,-2
	DB	128+2, 3,-2
	DB	4,-1, 4,-2
	DB	128+7, 4,-1
	DB	128+4, 5,-1
	DB	31,31

	;Werking gelijk aan NBOOG, maar nu om een BOM te bewegen.
	;startcoordinaten zijn: (0,30)
PIJLBOOG:
	DB	128+6,0,4
BOMBOOG:
	DB	128+5,1,4
	DB	2,4,1,4,2,4,1,4,2,4,1,4
	DB	128+8,2,4
	DB	3,4,2,4,3,4,3,4,2,4
	DB	128+3,3,4
	DB	4,4,3,4,4,4,3,4,4
	DB	4,31,31

SETWAYADR:
	LD	(WAYPOINT),HL
	XOR	A
	LD	(WAYAANTAL),A
	RET

WAYHEEN:
	LD	HL,(WAYPOINT)
	LD	A,(WAYAANTAL)
	OR	A
	JR	Z,WAYHEEN2
	DEC	A
	LD	(WAYAANTAL),A
	LD	BC,(WAYWAARDE)
	RET
WAYHEEN2:
	LD	A,(HL)
	AND	11000000B
	CP	128
	LD	A,0
	JR	NZ,WAYHEEN3
	LD	A,(HL)
	AND	00111111B
	DEC	A
	INC	HL
WAYHEEN3:
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	(WAYAANTAL),A
	LD	(WAYPOINT),HL
	LD	(WAYWAARDE),BC
	RET
WAYPOINT:
	DW	0
WAYWAARDE:
	DW	0
WAYAANTAL:
	DB	0

	;Deze sprite-kleurentabel bij het AMAZING en MENU gedeelte
	;instellen. Als PRESENTS komt, dan hele tabel met kleur 6 vullen.
SPRCOLAMAZ: 
	DB	001H,042H,001H,042H,001H,042H,001H,042H
	DB	001H,042H,001H,042H,001H,042H,001H,042H
	DB	084H,08CH,084H,08AH,001H,042H,083H,00BH
	DB	00FH,007H,007H,005H,005H,00CH,00CH,001H