PRAAT:	LD	HL,PALLETLEEG
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	IX,PRANI1
	CALL	PRCOPY
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	CALL	CHECKVDP
	LD	HL,PALLETLEEG
	LD	DE,CRAMPPAL
	LD	A,3
	CALL	LETFADE
	LD	IX,JOBDATA+070H
	LD	HL,00464H
PRAATB:	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATB
	LD	IX,PRANI3
	CALL	PRCOPY
	LD	IX,PRANI4
	CALL	PRCOPY
	LD	B,100
	CALL	PAUSE
	LD	HL,CRAMPPAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,28
	CALL	PAUSE
	RET

PRCOPY:	LD	A,(IX+0)
	CP	255
	RET	Z
	LD	(PRAATCOMM),A
	LD	A,(IX+1)
	LD	(PRAATCOMM+2),A
	LD	A,(IX+2)
	LD	(PRAATCOMM+3),A
	LD	A,(IX+3)
	LD	(PRAATCOMM+8),A
	LD	A,(IX+4)
	LD	(PRAATCOMM+10),A
	LD	A,(IX+5)
	LD	(PRAATCOMM+4),A
	LD	A,(IX+6)
	LD	(PRAATCOMM+6),A
	LD	HL,PRAATCOMM
	CALL	IVDPCOMM
	LD	DE,7
	ADD	IX,DE
	JR	PRCOPY

CLRTXTCOMM: DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	64,0         ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	192          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

PRAATCOMM:	DW	0            ;Van (X)
	DB	0,1          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	0            ;Aantal horizontaal
	DW	212          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

	;zet crampje
PRANI1:	DB	00,16,2, 50,32, 103,10
	DB	50,16,2, 50,31, 103,42,255
	;mond crampje dicht
PRANI2:	DB	50,47,2, 4,4, 126,52,255
	;mond crampje open
PRANI3:	DB	54,47,2, 4,4, 126,52,255
	;ogen crampje open
PRANI4:	DB	58,47,2, 14,4, 121,37,255
	;ogen crampje dicht
PRANI5:	DB	72,47,2, 14,4, 121,37,255

	;zet gast op scherm
PRANI6:	DB	64, 48,1, 48,16, 192,0
	DB	112,48,1, 48,16, 192,16
	DB	160,48,1, 48,16, 192,32
	DB	208,48,1, 48,16, 192,48,255
	;zet franc op scherm
PRANI7:	DB	100,16,2, 48,29, 16,0
	DB	148,16,2, 48,29, 16,29,255
	;mond van gast bewegen
PRANI8:	DB	0,64, 1, 2,2, 0,0,255;sourX,Xoffs,Yoffs,desX,desY invullen
PRANI9:	DB	0,64, 1, 2,2, 0,0,255
PRANI10:	DB	0,64, 1, 2,2, 0,0,255
	;mond FRANC bewegen
PRANI11:	DB	196,16,2, 12,18, 46,27,255
PRANI12:	DB	208,16,2, 12,18, 46,27,255
PRANI13:	DB	220,16,2, 12,18, 46,27,255

PRPROGINI:	LD	(PRPROGPNT),HL
	LD	A,1
	LD	(PRPROGTEL),A
	RET

PRPROG:	LD	HL,PRPROGTEL
	DEC	(HL)
	RET	NZ
	LD	IY,(PRPROGPNT)
	LD	A,(IY+0)
	CP	255
	JR	NZ,PRPROGB
	LD	L,(IY+1)
	LD	H,(IY+2)
	PUSH	HL
	POP	IY
	LD	A,(IY+0)
PRPROGB:	LD	(PRPROGTEL),A
	LD	L,(IY+1)
	LD	H,(IY+2)
	PUSH	HL
	POP	IX
	CALL	PRCOPY
	LD	DE,3
	ADD	IY,DE
	LD	(PRPROGPNT),IY
	RET

PRPROGPNT:	DW	0
PRPROGTEL:	DB	1

PRPROGDAT1: DB	1
	DW	PRANI2
	DB	1
	DW	PRANI3
	DB	2
	DW	PRANI2
	DB	1
	DW	PRANI3
	DB	1
	DW	PRANI2
	DB	2
	DW	PRANI3
	DB	1
	DW	PRANI2
	DB	1
	DW	PRANI3
	DB	1
	DW	PRANI5
	DB	1
	DW	PRANI4
	DB	255
	DW	PRPROGDAT1

	;praten van gast
PRPROGDAT2: DB	2
	DW	PRANI8
	DB	2
	DW	PRANI9
	DB	1
	DW	PRANI8
	DB	2
	DW	PRANI9
	DB	2
	DW	PRANI10
	DB	1
	DW	PRANI9
	DB	1
	DW	PRANI10
	DB	2
	DW	PRANI9
	DB	255
	DW	PRPROGDAT2

	;praten van FRANC
PRPROGDAT3: DB	2
	DW	PRANI11
	DB	1
	DW	PRANI12
	DB	1
	DW	PRANI11
	DB	2
	DW	PRANI12
	DB	2
	DW	PRANI13
	DB	2
	DW	PRANI12
	DB	1
	DW	PRANI13
	DB	2
	DW	PRANI12
	DB	255
	DW	PRPROGDAT3

PRTEXT:	CALL	WITBEGCOR
	LD	A,L
	ADD	A,16
	LD	L,A
	PUSH	HL
PRTEXT2:	LD	A,(IX+0)
	INC	IX
	CP	4
	JR	C,PRTEXT3
	CP	32
	JR	Z,PRTEXT4
	EI
	HALT
	CALL	WITPUTLET
	PUSH	IX
	CALL	PRPROG
	POP	IX
	LD	A,255
	LD	(JOYFIREBUF),A
	CALL	JOYSTICK
	OR	A
	JR	NZ,PRTEXT2
	LD	B,6
	CALL	PAUSE
	JR	PRTEXT2
PRTEXT3:	POP	HL
	RET
PRTEXT4:	CALL	WITPUTLET
	JR	PRTEXT2

	;wordt aangeroepen als FRANC met gast gaat converseren
CONVER:	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	DI
	LD	HL,MUSICINT
	LD	(00039H),HL
	LD	BC,00017H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	LD	BC,00A08H
	CALL	WRTVDP
	EI
	LD	HL,(JOBDATA+100)
	LD	(PRANI8),HL
	LD	HL,(JOBDATA+102)
	LD	(PRANI9),HL
	LD	HL,(JOBDATA+104)
	LD	(PRANI10),HL
	LD	HL,(JOBDATA+108)
	LD	(PRANI8+3),HL
	LD	(PRANI9+3),HL
	LD	(PRANI10+3),HL
	LD	HL,(JOBDATA+110)
	LD	(PRANI8+5),HL
	LD	(PRANI9+5),HL
	LD	(PRANI10+5),HL
	LD	IX,PRANI6
	CALL	PRCOPY
	LD	IX,PRANI7
	CALL	PRCOPY
	CALL	CHECKVDP
	LD	HL,PALLETLEEG
	LD	DE,JOBDATA+32
	LD	A,3
	CALL	LETFADE
	LD	HL,PRPROGDAT3
	CALL	PRPROGINI
	LD	A,(EINDGOED)
	LD	HL,00050H
	LD	IX,GEENDIEN
	CP	4
	JR	Z,CONVERB
	LD	IX,JOBDATA+368
CONVERB:	CALL	PRTEXT
	OR	A
	JR	Z,CONVERB
	CP	3
	JR	Z,CONVERC
	PUSH	AF
	CALL	MONDDICHT
	LD	B,90
	CALL	PAUSE
	LD	HL,CLRTXTCOMM
	CALL	IVDPCOMM
	CALL	CHECKVDP
	POP	AF
	CP	1
	JR	Z,CONVERD
	LD	HL,PRPROGDAT2
	CALL	PRPROGINI
	LD	HL,04050H
	JR	CONVERB
CONVERD:	LD	HL,PRPROGDAT3
	CALL	PRPROGINI
	LD	HL,00050H
	JR	CONVERB
CONVERC:	CALL	MONDDICHT
	LD	A,(EINDGOED)
	CP	6
	JR	Z,CONVERG
	LD	B,12
	CALL	SETVOLUDEC
CONVERG:	LD	B,150
	CALL	PAUSE
	LD	HL,CLRTXTCOMM
	CALL	IVDPCOMM
	CALL	CHECKVDP
	LD	HL,JOBDATA+32
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,28
	CALL	PAUSE
	LD	SP,(STACK)
	LD	A,(EINDGOED)
	CP	4
	JP	Z,NAARCONT
	LD	C,219
	CALL	CLEARSPR
	LD	BC,00808H
	CALL	IWRTVDP
	LD	HL,06FD9H
	CALL	NEWPLACE
	LD	HL,07C8CH
	LD	(SPRITEATR+4),HL
	LD	(SPRITEATR+8),HL
	CALL	REGSTAND
	DI
	LD	HL,STANDINT
	LD	(00039H),HL
	LD	HL,PALLETLEEG
	LD	DE,JOBDATA
	LD	A,3
	CALL	LETFADE
	LD	B,134
CONVERE:	PUSH	BC
	LD	A,4
	LD	(JOYRICHT),A
	XOR	A
	LD	(JOYFIRENU),A
	CALL	BESTUR+1
	LD	B,1
	CALL	GADOOD2
	POP	BC
	DJNZ	CONVERE
	LD	HL,JOBDATA
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	GADOOD2
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	DI
	XOR	A
	LD	(BESTUR),A
	LD	(MOVEDIEN),A
	CALL	SPUGENON
	LD	HL,MUSICINT
	LD	(00039H),HL
	LD	BC,00017H
	CALL	WRTVDP
	LD	BC,00A08H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	EI
	CALL	CHECKVDP
	LD	A,(WORLDNR)
	CP	5
	LD	A,1
	JP	Z,LOADTEXT
	LD	IX,KLAARTXT1
	CALL	DROPTXT
	LD	HL,PALLETLEEG
	LD	DE,JOBDATA
	LD	A,3
	CALL	LETFADE
	LD	B,150
	CALL	PAUSE
	LD	A,(WORLDNR)
	DEC	A
	SLA	A
	LD	B,A
	SLA	A
	ADD	A,B
	LD	E,A
	LD	D,0
	LD	IX,PASSWORDS
	ADD	IX,DE
	LD	HL,06864H
	CALL	WITBEGCOR
	LD	B,6
PUTPASSW:	PUSH	BC
	LD	A,(IX+0)
	SRL	A
	SRL	A
	SRL	A
	ADD	A,64
	CALL	WITPUTLET
	LD	HL,PSGEFF16
	CALL	SETPSGEFF
	LD	B,50
	CALL	PAUSE
	INC	IX
	POP	BC
	DJNZ	PUTPASSW
	LD	B,50
	CALL	PAUSE
	LD	IX,KLAARTXT2
	CALL	DROPTXT
PUTPASSW2:	EI
	HALT
	CALL	JOYSTICK
	OR	A
	JR	Z,PUTPASSW2
	LD	DE,PALLETLEEG
	LD	HL,JOBDATA
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	B,20
	CALL	PAUSE
	LD	A,1
	JP	LOADTEXT

NAARCONT:	CALL	ALLMUSICOFF
	DI
	XOR	A
	LD	(BESTUR),A
	LD	(MOVEDIEN),A
	CALL	SPUGENON
	LD	HL,0D7A3H
	LD	BC,2000
	CALL	INITSTMUS
	LD	HL,1086
	LD	(CONTINUEX+1),HL
	JP	CONTINUE

MONDDICHT:	PUSH	IX
	LD	IX,PRANI8
	CALL	PRCOPY
	LD	IX,PRANI11
	CALL	PRCOPY
	POP	IX
	RET

GEENDIEN:	DB	"HELLO, EEH, I EH...    ",2
	DB	"I ALREADY SEE! IS THIS ",0
	DB	"WERE BUTLERS ARE FOR!?!",0
	DB	"I AM STILL THIRSTY!!   ",0
	DB	"SO HURRY UP AND GET    ",0
	DB	"SOMETHING TO DRINK FOR ",0
	DB	"ME!!!                  ",3

CONTINUE:	DI
	LD	HL,MUSICINT
	LD	(00039H),HL
	EI
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	DI
	LD	BC,00A08H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	LD	BC,00017H
	CALL	WRTVDP
	LD	IX,CONTTXT
	CALL	DROPTXT
	LD	A,116
	LD	(PIJLCOMM+6),A
	CALL	PUTPIJL
	LD	HL,PALLETLEEG
	LD	DE,JOBDATA
	LD	A,3
	CALL	LETFADE
CONTINUEX:	LD	BC,800
CONTINUEB:	PUSH	BC
	EI
	HALT
	CALL	JOYSTICK
	LD	A,(JOYRICHT)
	BIT	0,A
	JP	NZ,PIJLUP
	BIT	1,A
	JP	NZ,PIJLDOWN
CONTINUEC:	POP	BC
	LD	A,(JOYFIRENU)
	OR	A
	JR	NZ,PIJLKOOS
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,CONTINUEB
PIJLKOOS:	LD	A,(PIJLCOMM+6)
	CP	116
	JR	NZ,PIJLKOOSX
	LD	B,4
	CALL	SETVOLUDEC
PIJLKOOSX:	LD	HL,JOBDATA
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	SP,(STACK)
	LD	A,(PIJLCOMM+6)
	CP	116
	JP	Z,TRYAGAIN
	XOR	A
	;A=0 als stoppen, 1 als stage af is
LOADTEXT:	PUSH	AF
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	IX,KLAARTXT3
	CALL	DROPTXT
	LD	B,3
	CALL	SETVOLUDEC
LOADTEXT2:	LD	HL,PALLETLEEG
	LD	DE,CRAMPPAL
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	CALL	ALLMUSICOFF
	DI
	LD	A,0C3H
	LD	(INITMUSDAT),A
	LD	(REPLAYROUT),A
	LD	(EFFPSGBEG),A
	LD	(SETPSGEFF),A
	LD	BC,0000FH
	CALL	WRTVDP
	LD	BC,00600H
	CALL	WRTVDP
	LD	BC,06201H
	CALL	WRTVDP
	CALL	RAMROMBYTE
	LD	A,D
	OUT	(0A8H),A
	LD	A,E
	LD	(0FFFFH),A
	POP	AF
	LD	SP,(STACK)
	RET

ENDOF6:	DI
	LD	HL,PALLETVOL
	LD	(LOADTEXT2+1),HL
	LD	HL,MUSICINT
	LD	(00039H),HL
	EI
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	DI
	LD	BC,00A08H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	LD	BC,00017H
	CALL	WRTVDP
	LD	A,1
	JP	LOADTEXT

TRYAGAIN:	DI
	CALL	ALLMUSICOFF
	LD	HL,04000H
	SCF
	CALL	SETRDVRAM
	LD	HL,04000H
	LD	BC,04000H
TRYAGAINB:	IN	A,(098H)
	LD	(HL),A
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TRYAGAINB
	XOR	A
	LD	(BESTUR),A
	CALL	INITWORLD
	LD	BC,00808H
	CALL	WRTVDP
	CALL	READINT
	XOR	A
	LD	(FRANR23),A
	LD	C,219
	CALL	CLEARSPR
	CALL	SPRTOVRM
	JP	AFTERCONT
PIJLUP:	LD	A,(PIJLCOMM+6)
	CP	116
	JP	Z,CONTINUEC
	JR	PIJLDOWNB
PIJLDOWN:	LD	A,(PIJLCOMM+6)
	CP	146
	JP	Z,CONTINUEC
PIJLDOWNB:	XOR	230
	LD	(PIJLCOMM+6),A
	CALL	PUTPIJL
	LD	HL,PSGEFF7
	CALL	SETPSGEFF
	JP	CONTINUEC

DROPTXT:	LD	A,(IX+0)
	CP	255
	RET	Z
	OR	A
	CALL	Z,DROPTXTB
	CALL	WITPUTLET
	INC	IX
	JR	DROPTXT
DROPTXTB:	INC	IX
	LD	H,(IX+0)
	INC	IX
	LD	L,(IX+0)
	CALL	WITBEGCOR
	INC	IX
	LD	A,(IX+0)
	RET

CONTTXT:	DB	0,80,16,"- CONTINUE -"
	DB	0,120,120,"YES"
	DB	0,120,150,"NO"
	DB	255
KLAARTXT1:	DB	0,60,80,"YOUR PASSWORD IS:",255
KLAARTXT2:	DB	0,12,130,"PRESS SPACE/FIRE TO CONTINUE!",255
KLAARTXT3:	DB	0,88,100,"LOADING...",255
PASSWORDS:	DB	112,120,152, 64, 80, 40    ;NOSHJE-2
	DB	152, 40,136,168, 40, 96    ;SEQUEL-3
	DB	160,184, 72,160, 24, 64    ;TWITCH-4
	DB	104,  8,144,176, 40, 96    ;MARVEL-5
	DB	 56, 72, 16, 16, 40,160    ;GIBBET-6

PIJLCOMM:	DW	224          ;Van (X)
	DB	176,1        ;Van (Y)
	DW	96           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	16           ;Aantal horizontaal
	DW	16           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

PUTPIJL:	LD	A,11010000B
	LD	(PIJLCOMM+14),A
	LD	HL,PIJLCOMM
	CALL	IVDPCOMM
	LD	A,(PIJLCOMM+6)
	PUSH	AF
	XOR	230
	LD	(PIJLCOMM+6),A
	LD	A,11000000B
	LD	(PIJLCOMM+14),A
	LD	HL,PIJLCOMM
	CALL	IVDPCOMM
	POP	AF
	LD	(PIJLCOMM+6),A
	RET