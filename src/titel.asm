ONETITEL:
	DI
	LD	BC,00017H
	CALL	WRTVDP
	LD	BC,0D213H
	CALL	WRTVDP
	LD	SP,(AMAZSTACK)
	LD	BC,00201H
	CALL	WRTVDP
	LD	HL,PALLETLEEG
	LD	DE,PALLETLEEG
	LD	A,1
	CALL	LETFADE
	CALL	INSTMUSINT
	LD	HL,TITELINT2
	LD	(INTERCALL),HL
	CALL	SPRITEPAG2
	CALL	CLEARSPR
	CALL	SPRTOVRAM2
	CALL	REPLAYROUT
	EI
	LD	HL,TITCOMM1
	CALL	IVDPCOMM
	LD	HL,TITCOMM2
	CALL	IVDPCOMM
	CALL	CHECKVDP
	LD	BC,04201H
	CALL	WRTVDP
	LD	HL,PALLETLEEG
	LD	DE,TITELPAL
	LD	A,1
	CALL	LETFADE
ONETITELC:
	LD	BC,0D213H
	CALL	WRTVDP
	LD	BC,500
ONETITELB:
	PUSH	BC
	EI
	HALT
	CALL	JOYSTICK
	POP	BC
	LD	D,A
	AND	00010001B
	JP	NZ,STARTZP
	LD	A,D
	AND	00101010B
	JP	NZ,STARTMP
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,ONETITELB
	CALL	CLEARSPR
	XOR	A
	LD	(TITCOMM5+4),A
	LD	HL,TITPROG1
	LD	(TITELINT3+1),HL
	LD	HL,TITELINT3
	LD	(INTERCALL),HL
	LD	B,20
	CALL	PAUSE
	LD	HL,PALLETLEEG
	LD	DE,STORY1PAL
	LD	A,3
	CALL	LETFADE
	LD	HL,TITCOMM6
	CALL	IVDPCOMM
	LD	HL,ANI1DATA
	CALL	INSTALANI
	LD	IX,STORYTXT1
	LD	L,140
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,ANI2DATA
	CALL	INSTALANI
	LD	IX,STORYTXT1B
	LD	L,188
	CALL	TEXTPUT
	LD	B,150
	CALL	PAUSE
	LD	HL,STORY1PAL
	LD	DE,PALLETVOL
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	;tekst verwijderen
	LD	HL,TITCOMM7
	CALL	IVDPCOMM
	LD	HL,PALLETVOL
	LD	DE,STORY2PAL
	LD	A,3
	CALL	LETFADE
	LD	IX,STORYTXT2
	LD	L,160
	CALL	TEXTPUT
	LD	B,150
	CALL	PAUSE
	LD	HL,TITCOMM8
	CALL	IVDPCOMM
	LD	B,50
	CALL	PAUSE
	LD	IX,STORYTXT2B
	LD	L,145
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,STORY2PAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,TITCOMM6
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,STORY1PAL
	LD	A,3
	CALL	LETFADE
	LD	HL,ANI2DATA
	CALL	INSTALANI
	LD	IX,STORYTXT3
	LD	L,150
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,STORY1PAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	;scherm is zwart, gebouwscroll voorbereiden
	LD	BC,02A08H
	CALL	IWRTVDP
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,TITCOMM9
	CALL	IVDPCOMM
	LD	HL,TITCOMMA
	CALL	IVDPCOMM
	LD	HL,TITCOMMB
	CALL	IVDPCOMM
	LD	HL,RAAMDATA
	LD	(RAAMPOINT),HL
	CALL	NEWRAAM
	LD	HL,TITCOMMC
	CALL	IVDPCOMM
	LD	A,0FFH
	LD	(LINEG+8),A
	LD	A,01110000B
	LD	(LINEG+10),A
	LD	HL,04C00H
	LD	DE,04C6DH
	CALL	LINE
	LD	HL,04C00H
	LD	DE,0B500H
	CALL	LINE
	LD	HL,04C6DH
	LD	DE,0B56DH
	CALL	LINE
	LD	HL,0B500H
	LD	DE,0B56DH
	CALL	LINE
	LD	HL,04CFFH
	LD	DE,0B5FFH
	CALL	LINE
	LD	A,109
	LD	(TITCOMMD+6),A
	LD	A,254
	LD	(TITCOMME+6),A
	LD	A,63
	LD	(TITCOMMF+2),A
	XOR	A
	LD	(TITCOMMF+6),A
	LD	(RAAMREG23),A
	CALL	NEWRAAM
	LD	HL,PALLETLEEG
	LD	DE,STORY3PAL
	LD	A,3
	CALL	LETFADE
	LD	IX,STORYTXT4
	LD	L,160
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,TITCOMM8
	CALL	IVDPCOMM
	XOR	A
	LD	(RAAMSTAT),A
	DI
	LD	BC,07813H
	CALL	WRTVDP
	LD	HL,INTRAAM
	LD	(TITELINT3+1),HL
	CALL	READINT
	EI
ONETITELF:
	LD	A,(RAAMSTAT)
	CP	2
	JR	NZ,ONETITELF
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	LD	B,100
	CALL	PAUSE
	LD	BC,0D413H
	CALL	IWRTVDP
	LD	BC,02808H
	CALL	IWRTVDP
	LD	IX,STORYTXT5
	LD	L,145
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,STORY3PAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	BC,00017H
	CALL	IWRTVDP
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,TITCOMMH
	CALL	IVDPCOMM
	LD	HL,TITCOMMI
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,STORY4PALB
	LD	A,3
	CALL	LETFADE
	LD	HL,ANI3DATA
	CALL	INSTALANI
	LD	IX,STORYTXT6
	LD	L,156
	CALL	TEXTPUT
	LD	HL,PSGEFF26
	CALL	SETPSGEFF
	LD	B,100
	CALL	PAUSE
	LD	HL,STORY4PALB
	LD	DE,STORY4PAL
	LD	A,30
	CALL	LETFADE
	LD	IX,STORYTXT6B
	LD	L,204
	CALL	TEXTPUT
	LD	B,100
	CALL	PAUSE
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	LD	HL,TITCOMMJ
	CALL	IVDPCOMM
	LD	HL,ANI4DATA
	CALL	INSTALANI
	LD	IX,STORYTXT7
	LD	L,156
	CALL	TEXTPUT
	LD	HL,MONDCOMM
	CALL	IVDPCOMM
	LD	HL,ANI3DATA
	CALL	INSTALANI
	LD	B,150
	CALL	PAUSE
	LD	IX,STORYTXT8
	LD	L,188
	CALL	TEXTPUT
	LD	B,100
	CALL	PAUSE
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	LD	HL,TITCOMMJ
	CALL	IVDPCOMM
	LD	HL,ANI4DATA
	CALL	INSTALANI
	LD	IX,STORYTXT9
	LD	L,164
	CALL	TEXTPUT
	LD	HL,MONDCOMM
	CALL	IVDPCOMM
	LD	HL,ANI3DATA
	CALL	INSTALANI
	LD	B,0
	CALL	PAUSE
	LD	HL,STORY4PAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,STORY4PAL
	LD	A,3
	CALL	LETFADE
	LD	IX,STORYTXTA
	LD	L,94
	CALL	TEXTPUT
	LD	B,200
	CALL	PAUSE
	LD	HL,STORY4PAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,CREDITPAL
	LD	A,3
	CALL	LETFADE
	LD	IX,CREDITTXT
	LD	HL,05050H
	CALL	TEXTPUT2
	LD	B,100
	CALL	PAUSE
	LD	HL,CREDITPAL
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	CALL	PUTCRED
	XOR	A
	LD	(0FC82H),A
	LD	SP,(AMAZSTACK)
	RET

VEEGCOMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	239,0        ;Naar (Y)
	DW	96           ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

STARTZP:
	LD	A,1
STARTZP2:
	DI
	LD	(0FC83H),A
	ADD	A,48
	LD	(JOBNR),A
	LD	HL,TITELINT2
	LD	(INTERCALL),HL
	DI
	XOR	A
	OUT	(0A0H),A
	OUT	(0A1H),A
	LD	A,1
	OUT	(0A0H),A
	XOR	A
	OUT	(0A1H),A
	LD	A,7
	OUT	(0A0H),A
	LD	A,10111000B
	OUT	(0A1H),A
	LD	B,21
	CALL	SETVOLUDEC
	LD	HL,PAGE0COMM
	CALL	IVDPCOMM
	DI
	LD	BC,0D213H
	CALL	WRTVDP
	LD	BC,02808H
	CALL	WRTVDP
	CALL	INSTMUSINT
	LD	HL,TITELINT4
	LD	(INTERCALL),HL
	LD	HL,VEEGSCR
	LD	(TITELINT4+1),HL
	CALL	SPRITEPAG2
	CALL	CLEARSPR
	LD	HL,BLOEDDAT
	LD	DE,SPRITEATR+4
	LD	BC,64
	LDIR
	CALL	SPRTOVRAM2
	CALL	REPLAYROUT
	LD	A,239
	LD	(VEEGCOMM+6),A
	LD	A,100
	LD	(VEEGWACHT),A
	XOR	A
	LD	(VEEGR23),A
	EI
	LD	B,140
	CALL	PAUSE
	LD	IX,STARTTXT
	LD	HL,04CD4H
	CALL	TEXTPUT2
	LD	B,26
	CALL	PAUSE
	LD	SP,(STACK)
	DI
	LD	HL,STORY4PALB
	LD	DE,STORY4PALB
	LD	A,1
	CALL	LETFADE
	LD	HL,LASTCOMM
	CALL	VDPCOMM
	CALL	CHECKVDP
	LD	BC,00A08H
	CALL	WRTVDP
	LD	BC,0000FH
	CALL	WRTVDP
	LD	BC,00600H
	CALL	WRTVDP
	LD	BC,06201H
	CALL	WRTVDP
	CALL	ALLMUSICOFF
	CALL	RAMROMBYTE
	LD	A,D
	OUT	(0A8H),A
	LD	A,E
	LD	(0FFFFH),A
	RET

VEEGSCR:
	XOR	A
	LD	(VEEGCOMM+4),A
	LD	A,96
	LD	(VEEGCOMM+8),A
	LD	HL,VEEGCOMM
	CALL	VDPCOMM
	LD	A,224
	LD	(VEEGCOMM+4),A
	LD	A,32
	LD	(VEEGCOMM+8),A
	LD	HL,VEEGCOMM
	CALL	VDPCOMM
	LD	A,(VEEGCOMM+6)
	PUSH	AF
	ADD	A,16
	LD	(VEEGCOMM+6),A
	LD	A,96
	LD	(VEEGCOMM+4),A
	LD	A,128
	LD	(VEEGCOMM+8),A
	LD	HL,VEEGCOMM
	CALL	VDPCOMM
	CALL	CHECKVDP
	POP	AF
	DEC	A
	LD	(VEEGCOMM+6),A
	CP	239
	JR	NZ,VEEGSCRC
	LD	HL,NIETS
	LD	(TITELINT4+1),HL
VEEGSCRC:
	LD	HL,SPRITEATR+4
	LD	DE,4
	LD	B,16
VEEGSCRB:
	DEC	(HL)
	ADD	HL,DE
	DJNZ	VEEGSCRB
VEEGSCR2:
	LD	HL,VEEGWACHT
	LD	A,(HL)
	OR	A
	JR	Z,VEEGSCR2B
	DEC	(HL)
	RET
VEEGSCR2B:
	LD	A,(VEEGR23)
	DEC	A
	LD	(VEEGR23),A
	PUSH	AF
	LD	B,A
	LD	C,23
	CALL	WRTVDP
	POP	AF
	ADD	A,212
	LD	B,A
	LD	C,19
	CALL	WRTVDP
	RET
VEEGWACHT:
	DB	0
VEEGR23:
	DB	0
STARTTXT:
	DB	"LOADING JOB "
JOBNR:
	DB	0,0

PASSWORD:
	DS	6
PASSWXCOR:
	DB	168
PASSWPOINT:
	DW	PASSWORD

STARTMP:
	LD	BC,0C014H
	LD	DE,000E8H
	LD	HL,02096H
	LD	A,3
	CALL	PFADEIN
	LD	IX,PASSWTXT
	LD	HL,0289CH
	CALL	TEXTPUT2
	LD	HL,PASSWORD
	LD	DE,PASSWORD+1
	LD	(HL),0
	LD	BC,5
	LDIR
	LD	HL,PASSWORD
	LD	(PASSWPOINT),HL
	LD	A,168
	LD	(PASSWXCOR),A
STARTMP2:
	EI
	HALT
	CALL	JOYSTICK
	AND	00010001B
	JP	NZ,STARTZP
	CALL	SCANKEYB
	LD	A,(SCANHUIDIG+5)
	BIT	7,A
	JP	NZ,CHECKPASSW
	BIT	5,A
	JP	NZ,BACKSPACE
	BIT	2,A
	JP	NZ,PASSWSTOP
	CALL	READPASS
	JR	NC,STARTMP2
	LD	A,(PASSWXCOR)
	CP	216
	JR	Z,STARTMP2
	LD	(PASCOMM+4),A
	ADD	A,8
	LD	(PASSWXCOR),A
	LD	A,D
	LD	(PASCOMM),A
	LD	HL,(PASSWPOINT)
	LD	(HL),A
	INC	HL
	LD	(PASSWPOINT),HL
	LD	HL,PASCOMM
NOTONSCR:
	CALL	IVDPCOMM
	LD	HL,FMEFF10
	LD	DE,PSGEFF28
	CALL	EFFECTOR
	JR	STARTMP2
PASSWSTOP:
	LD	BC,0C014H
	LD	DE,000D4H
	LD	HL,02096H
	LD	A,3
	CALL	PFADEIN
	JP	ONETITELC

BACKSPACE:
	LD	A,(PASSWXCOR)
	CP	168
	JP	Z,STARTMP2
	SUB	8
	LD	(PASSWXCOR),A
	LD	(PASCOMM+4),A
	LD	A,248
	LD	(PASCOMM),A
	LD	HL,(PASSWPOINT)
	DEC	HL
	LD	(HL),0
	LD	(PASSWPOINT),HL
	LD	HL,PASCOMM
	CALL	IVDPCOMM
	LD	HL,FMEFF6
	LD	DE,PSGEFF10
	CALL	EFFECTOR
	JP	STARTMP2
CHECKPASSW:
	LD	B,1
	LD	DE,PWORDS
CHECKPASSV:
	PUSH	BC
	LD	HL,PASSWORD
	LD	BC,00600H
CHECKPASSX:
	LD	A,(DE)
	XOR	(HL)
	OR	C
	LD	C,A
	INC	DE
	INC	HL
	DJNZ	CHECKPASSX
	LD	A,C
	OR	A
	JR	Z,PASSRIGHT
	POP	BC
	INC	B
	LD	A,B
	CP	10
	JR	NZ,CHECKPASSV
	LD	HL,PSGEFF40
	CALL	SETPSGEFF
	JP	STARTMP2
	;password juist,b=levelnr
PASSRIGHT:
	POP	BC
	LD	A,B
	CP	7
	JP	C,STARTZP2
	CP	7
	JR	Z,PPROTEC
	CP	8
	JR	Z,PEXTRAS
	CALL	BACKS
	LD	HL,0
	LD	(NOTONSCR),HL
	LD	(NOTONSCR+1),HL
	JP	STARTMP2
PPROTEC:
	LD	A,1
	LD	(0FC84H),A
	CALL	BACKS
	JP	STARTMP2
PEXTRAS:
	LD	A,1
	LD	(0FC85H),A
	CALL	BACKS
	JP	STARTMP2
BACKS:
	LD	B,6
BACKS2:
	PUSH	BC
	CALL	POSTERUG
	POP	BC
	DJNZ	BACKS2
	RET

POSTERUG:
	LD	A,(PASSWXCOR)
	CP	168
	RET	Z
	SUB	8
	LD	(PASSWXCOR),A
	LD	(PASCOMM+4),A
	LD	A,248
	LD	(PASCOMM),A
	LD	HL,(PASSWPOINT)
	DEC	HL
	LD	(HL),0
	LD	(PASSWPOINT),HL
	LD	HL,PASCOMM
	JP	IVDPCOMM

PWORDS:
	DB	152,136,168, 40, 40, 88    ;SQUEEK-1
	DB	112,120,152, 64, 80, 40    ;NOSHJE-2
	DB	152, 40,136,168, 40, 96    ;SEQUEL-3
	DB	160,184, 72,160, 24, 64    ;TWITCH-4
	DB	104,  8,144,176, 40, 96    ;MARVEL-5
	DB	 56, 72, 16, 16, 40,160    ;GIBBET-6
	DB	128,144,120,160, 40, 24    ;PROTEC
	DB	 40,192,160,144,  8,152    ;EXTRAS
	DB	120, 48, 48,  0,  0,  0    ;OFF

TITPROG1:
	LD	HL,TITCOMM5
	CALL	VDPCOMM
	LD	A,(TITCOMM5+4)
	ADD	A,4
	NEG
	LD	(TITCOMM5+4),A
	LD	HL,TITCOMM5
	CALL	VDPCOMM
	LD	A,(TITCOMM5+4)
	NEG
	ADD	A,4
	LD	(TITCOMM5+4),A
	RET	NZ
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	RET

PASCOMM:
	DW	0            ;Van (X)
	DB	199,2        ;Van (Y)
	DW	0            ;Naar (X)
	DB	156,0        ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	8            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

LASTCOMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	220,0        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	30           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

TITCOMMJ:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	156,0        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	64           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

TITCOMMH:
	DW	0            ;Van (X)
	DB	0,2          ;Van (Y)
	DW	68           ;Naar (X)
	DB	0 ,0         ;Naar (Y)
	DW	122          ;Aantal horizontaal
	DW	119          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
TITCOMMI:
	DW	122          ;Van (X)
	DB	96,2         ;Van (Y)
	DW	68           ;Naar (X)
	DB	119,0        ;Naar (Y)
	DW	122          ;Aantal horizontaal
	DW	23           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMMB:
	DW	150          ;Van (X)
	DB	30,3         ;Van (Y)
	DW	76           ;Naar (X)
	DB	35,0         ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	74           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMMC:
	DW	150          ;Van (X)
	DB	30,3         ;Van (Y)
	DW	76           ;Naar (X)
	DB	1,0          ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	34           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM9:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	150          ;Naar (X)
	DB	30,3         ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	34           ;Aantal verticaal
	DB	077H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

TITCOMMA:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	247          ;Naar (X)
	DB	30,3         ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	34           ;Aantal verticaal
	DB	077H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10000000B    ;Commando/Logop

TITCOMM8:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	160,0        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	32           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

TITCOMM7:
	DW	0            ;Van (X)
	DB	0,3          ;Van (Y)
	DW	52           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	150          ;Aantal horizontaal
	DW	119          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM6:
	DW	0            ;Van (X)
	DB	119,3        ;Van (Y)
	DW	76           ;Naar (X)
	DB	30,0         ;Naar (Y)
	DW	102          ;Aantal horizontaal
	DW	90           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM5:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	212          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

TITCOMM1:
	DW	0            ;Van (X)
	DB	0,1          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	212          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM2:
	DW	150          ;Van (X)
	DB	128,3        ;Van (Y)
	DW	118          ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	68           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM3:
	DW	0            ;Van (X)
	DB	239,1        ;Van (Y)
	DW	0            ;Naar (X)
	DB	239,0        ;Naar (Y)
	DW	96           ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

TITCOMM4:
	DW	150          ;Van (X)
	DB	195,3        ;Van (Y)
	DW	118          ;Naar (X)
	DB	1,0          ;Naar (Y)
	DW	32           ;Aantal horizontaal
	DW	2            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	8            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

SETTITEL:
	DI
	LD	BC,0D213H
	CALL	WRTVDP
	LD	BC,00017H
	CALL	WRTVDP
	LD	SP,(AMAZSTACK)
	LD	BC,00201H
	CALL	WRTVDP
	LD	BC,02808H
	CALL	WRTVDP
	CALL	INSTMUSINT
	LD	HL,TITELINT
	LD	(INTERCALL),HL
	CALL	SPRITEPAG2
	CALL	CLEARSPR
	LD	HL,BLOEDDAT
	LD	DE,SPRITEATR
	LD	BC,64
	LDIR
	CALL	SPRTOVRAM2
	CALL	REPLAYROUT
	EI
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	CALL	CHECKVDP
	LD	HL,TITELPAL
	LD	DE,TITELPAL
	LD	A,1
	CALL	LETFADE
	LD	BC,04201H
	CALL	WRTVDP
	LD	A,239
	LD	(TITCOMM3+2),A
	LD	(TITCOMM3+6),A
	LD	B,245
SETTITELB:
	PUSH	BC
	EI
	HALT
	XOR	A
	LD	(TITCOMM3),A
	LD	(TITCOMM3+4),A
	LD	A,96
	LD	(TITCOMM3+8),A
	LD	HL,TITCOMM3
	CALL	VDPCOMM
	LD	A,224
	LD	(TITCOMM3),A
	LD	(TITCOMM3+4),A
	LD	A,32
	LD	(TITCOMM3+8),A
	LD	HL,TITCOMM3
	CALL	VDPCOMM
	LD	A,(TITCOMM3+2)
	PUSH	AF
	ADD	A,16
	LD	(TITCOMM3+2),A
	LD	(TITCOMM3+6),A
	LD	A,96
	LD	(TITCOMM3),A
	LD	(TITCOMM3+4),A
	LD	A,128
	LD	(TITCOMM3+8),A
	LD	HL,TITCOMM3
	CALL	VDPCOMM
	POP	AF
	INC	A
	LD	(TITCOMM3+2),A
	LD	(TITCOMM3+6),A
	LD	HL,SPRITEATR
	LD	DE,4
	LD	B,16
SETTITELC:
	INC	(HL)
	ADD	HL,DE
	DJNZ	SETTITELC
	POP	BC
	DJNZ	SETTITELB
	LD	A,1
	LD	(TITCOMM4+6),A
	INC	A
	LD	(TITCOMM4+10),A
	LD	BC,04413H
	CALL	WRTVDP
SETTITELD:
	EI
	HALT
	LD	HL,TITCOMM4
	CALL	VDPCOMM
	LD	A,(TITCOMM4+6)
	ADD	A,2
	LD	(TITCOMM4+6),A
	LD	A,(TITCOMM4+10)
	ADD	A,2
	LD	(TITCOMM4+10),A
	CP	70
	JR	NZ,SETTITELD
	DI
	LD	HL,TITELINT2
	LD	(INTERCALL),HL
	JP	ONETITELC

TITELINT3:
	CALL	NIETS
TITELINT:
	CALL	JOYSTICK
	OR	A
	JR	Z,TITELINT2
	DI
	JP	ONETITEL
TITELINT2:
	CALL	REGELFADE
	CALL	SPRTOVRAM2
	CALL	EFFPSGBEG
	CALL	EFFFMPBEG
	JP	REPLAYROUT

TITELINT4:
	CALL	NIETS
	CALL	REGELFADE
	CALL	SPRTOVRAM2
	CALL	EFFPSGBEG
	CALL	EFFFMPBEG
	JP	REPLAYROUT

SPRTOVRAM2:
	LD	HL,07600H
	SCF
	CALL	SETWRVRAM
	LD	HL,SPRITEATR
	LD	BC,08098H
	OTIR
	RET

BLOEDDAT:
	DB	223,  0, 0,0
	DB	223, 16, 4,0
	DB	223, 32, 8,0
	DB	223, 48,12,0
	DB	223, 64,16,0
	DB	223, 80,20,0
	DB	239, 96,32,0
	DB	239,112,36,0
	DB	239,128,40,0
	DB	239,144,44,0
	DB	239,160,48,0
	DB	239,176,52,0
	DB	239,192,56,0
	DB	239,208,60,0
	DB	223,224,24,0
	DB	223,240,28,0

TITELPAL:
	DB	000H,000H,000H,003H,044H,004H,000H,002H
	DB	031H,001H,007H,000H,042H,002H,075H,005H
	DB	063H,003H,022H,000H,003H,000H,005H,000H
	DB	031H,002H,033H,003H,055H,005H,077H,007H

STORY1PAL:
	DB	000H,000H,033H,003H,074H,004H,075H,005H
	DB	037H,004H,014H,003H,037H,003H,031H,001H
	DB	055H,005H,047H,006H,000H,003H,000H,002H
	DB	042H,002H,074H,005H,000H,004H,077H,007H

STORY2PAL:
	DB	000H,000H,033H,003H,007H,000H,007H,000H
	DB	017H,001H,007H,000H,007H,000H,007H,000H
	DB	055H,005H,007H,000H,007H,000H,007H,000H
	DB	007H,000H,007H,000H,007H,000H,077H,007H

STORY3PAL:
	DB	000H,000H,044H,004H,027H,003H,037H,004H
	DB	060H,000H,043H,003H,031H,001H,006H,000H
	DB	055H,005H,000H,003H,033H,002H,021H,001H
	DB	007H,000H,070H,005H,042H,002H,077H,007H

STORY4PAL:
	DB	000H,000H,000H,002H,002H,001H,033H,004H
	DB	031H,001H,042H,003H,041H,002H,020H,002H
	DB	055H,005H,020H,000H,064H,005H,032H,003H
	DB	053H,004H,033H,003H,022H,003H,077H,007H

STORY4PALB:
	DB	000H,000H,000H,000H,000H,000H,000H,000H
	DB	000H,000H,000H,000H,000H,000H,000H,000H
	DB	055H,005H,000H,000H,000H,000H,000H,000H
	DB	000H,000H,000H,000H,000H,000H,077H,007H

CREDITPAL:
	DB	000H,000H,000H,000H,000H,000H,000H,000H
	DB	000H,000H,000H,000H,000H,000H,000H,000H
	DB	050H,000H,000H,000H,000H,000H,000H,000H
	DB	000H,000H,000H,000H,000H,000H,070H,000H

CREDITPAL2:
	DB	000H,000H,000H,000H,000H,000H,033H,003H
	DB	000H,000H,000H,000H,000H,000H,000H,000H
	DB	055H,005H,000H,000H,000H,000H,000H,000H
	DB	000H,000H,000H,000H,000H,000H,077H,007H

STORYTXT1:
	DB	"ONE DAY FRANC WENT TO THE PARK.",1
	DB	"HE WANTED TO READ THE NEWSPAPER",1
	DB	"QUIETLY...            ",0
STORYTXT1B: 
	DB	"SUDDENLY HE SAW AN ADVERTISEMENT",1
	DB	"ABOUT A JOB IN THE NEWSPAPER.   ",0

STORYTXT2:
	DB	"BECAUSE FRANC WAS AN UNEMPLOYED",1
	DB	"BUTLER, HE WANTED THE JOB...    ",0
STORYTXT2B: 
	DB	"'THEY WILL PAY ME GOOD AND TREAT",1
	DB	"ME WELL!!'      ",0

STORYTXT3:
	DB	"FRANC DIDN'T REALIZE WHAT THE",1
	DB	"GREAT EXPERIENCE MEANT....",0

STORYTXT4:
	DB	"FRANC WENT TO THE ADDRESS AND",1
	DB	"SAW A GREAT BUILDING.",0

STORYTXT5:
	DB	"'SHOULD THIS BE THE GREAT",1
	DB	"EXPERIENCE' FRANC THOUGHT AND ",1
	DB	"WALKED TO THE DOOR. ",0

STORYTXT6:
	DB	"AFTER FRANC WENT INTO THE",1
	DB	"BUILDING EVERYTHING WENT DARK...",1
	DB	"THE DOOR SLAMMED BEHIND HIM... ",0
STORYTXT6B:
	DB	"SLOWLY EVERYTHING BECAME CLEAR.",0

STORYTXT7:
	DB	"'HELLO STRANGER! I'M EARL CRAMP'",0
STORYTXT8:
	DB	"FRANC REALIZED THAT HE HAD BEEN",1
	DB	"CAPTURED BY AN EVIL CREATURE...",0

STORYTXT9:
	DB	"'SO YOU WANT TO BE MY BUTLER?',",1
	DB	"EARL CRAMP ASKED.",1
	DB	"'HAHAHA!! YOU ARE QUALIFIED!!'",0

STORYTXTA:
	DB	"CAN YOU HELP FRANC TO ESCAPE ",1
	DB	"FROM THE EVIL EARL CRAMP?     ",0

CREDITTXT:
	DB	"THE CREDITS: ",0

PASSWTXT:
	DB	"ENTER PASSWORD:",0

	;invoer: IX wijst naar tekst, L=begin Y
TEXTPUT:
	LD	H,0
TEXTPUT2:
	CALL	WITBEGCOR
TEXTPUTB:
	LD	A,(IX+0)
	OR	A
	RET	Z
	CP	1
	JR	NZ,TEXTPUTC
	LD	A,(LETTERCOMM+6)
	ADD	A,16
	LD	(LETTERCOMM+6),A
	XOR	A
	LD	(LETTERCOMM+4),A
	INC	IX
	JR	TEXTPUTB
TEXTPUTC:
	LD	A,(LETTERCOMM+4)
	LD	(SPRITEATR+1),A
	LD	A,64
	LD	(SPRITEATR+2),A
	LD	A,(LETTERCOMM+6)
	DEC	A
	LD	(SPRITEATR),A
	EI
	HALT
	LD	A,(IX+0)
	CALL	WITPUTLET
	LD	B,6
TEXTPUTD:
	LD	A,(SPRITEATR+2)
	ADD	A,4
	LD	(SPRITEATR+2),A
	EI
	HALT
	DJNZ	TEXTPUTD
	LD	A,(SPRITEATR+2)
	ADD	A,4
	LD	(SPRITEATR+2),A
	INC	IX
	JR	TEXTPUTB

	;van x,y,page, naar x,y, offset x,y, pause
ANI1DATA:
	DB	38,209,3, 40+76,41+30, 19,3, 30
	DB	0, 209,3, 40+76,41+30, 19,3, 30
	DB	19,209,3, 40+76,41+30, 19,3, 45
	DB	255

	;van x,y,page, naar x,y, offset x,y, pause
ANI2DATA:
	DB	57,209,3, 40+76,41+30, 19,3, 5
	DB	76,209,3, 40+76,41+30, 19,3, 5
	DB	57,209,3, 40+76,41+30, 19,3, 5
	DB	38,209,3, 40+76,41+30, 19,3, 110
	DB	255

	;van x,y,page, naar x,y, offset x,y, pause
ANI3DATA:
	DB	122,00,2, 42+68,61, 37,10, 25
	DB	122,10,2, 42+68,61, 37,10, 25
	DB	122,00,2, 42+68,61, 37,10, 25
	DB	122,20,2, 42+68,61, 37,10, 25
	DB	122,00,2, 42+68,61, 37,10, 25
	DB	122,10,2, 42+68,61, 37,10, 25
	DB	122,00,2, 42+68,61, 37,10, 25
	DB	122,20,2, 42+68,61, 37,10, 25
	DB	122,00,2, 42+68,61, 37,10, 50
	DB	122,40,2, 42+68,61, 37,10, 5
	DB	122,50,2, 42+68,61, 37,10, 5
	DB	122,40,2, 42+68,61, 37,10, 5
	DB	122,00,2, 42+68,61, 37,10, 70
	DB	255
	;van x,y,page, naar x,y, offset x,y, pause
ANI4DATA:
	DB	122,60,2, 55+68,99, 11,8, 10
	DB	135,60,2, 55+68,99, 11,8, 10
	DB	122,60,2, 55+68,99, 11,8, 10
	DB	135,60,2, 55+68,99, 11,8, 10
	DB	148,60,2, 55+68,99, 11,8, 10
	DB	135,60,2, 55+68,99, 11,8, 10
	DB	148,60,2, 55+68,99, 11,8, 10
	DB	135,60,2, 55+68,99, 11,8, 10
	DB	255

INSTALANI:
	LD	(ANIPOINT1),HL
	LD	(ANIPOINT2),HL
	LD	A,1
	LD	(ANIWAIT),A
	LD	HL,ANIMATE
	LD	(TITELINT3+1),HL
	RET

ANIPOINT1:
	DW	0
ANIPOINT2:
	DW	0
ANIWAIT:
	DB	0

ANIMATE:
	LD	HL,ANIWAIT
	DEC	(HL)
	RET	NZ
	LD	IX,(ANIPOINT1)
	LD	A,(IX+0)
	CP	255
	JR	NZ,ANIMATEB
	LD	IX,(ANIPOINT2)
	LD	A,(IX+0)
ANIMATEB:
	LD	(ANICOMM),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+2),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+3),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+4),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+6),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+8),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANICOMM+10),A
	INC	IX
	LD	A,(IX+0)
	LD	(ANIWAIT),A
	INC	IX
	LD	(ANIPOINT1),IX
	LD	HL,ANICOMM
	CALL	VDPCOMM
	RET

ANICOMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	10           ;Aantal horizontaal
	DW	2            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

MONDCOMM:
	DW	122          ;Van (X)
	DB	60,2         ;Van (Y)
	DW	55+68        ;Naar (X)
	DB	99,0         ;Naar (Y)
	DW	11           ;Aantal horizontaal
	DW	8            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

RAAMPOINT:
	DW	0

	;voor ramen kiezen uit: 150,164,178,192,206,220,234
	;eerst soort lucht, dan 5 willekeurige ramen.
RAAMDATA:
	DB	102, 150,206,234,164,192
	DB	110, 192,164,234,178,150
	DB	110, 206,150,150,164,150
	DB	110, 192,220,164,178,150
	DB	110, 206,150,150,164,150
	DB	110, 234,164,192,178,150
	DB	110, 206,150,150,164,150
	DB	110, 192,164,178,220,150
	DB	118, 220,178,164,150,234
	DB	126, 164,220,192,234,220
	DB	126, 192,164,178,150,192
	DB	126, 150,164,234,178,192
	DB	126, 164,192,178,220,234
	DB	126, 220,164,178,164,192
	DB	126, 164,234,192,150,220
	DB	126, 178,164,150,178,192
	DB	134, 192,150,234,206,220
	DB	142, 234,206,150,220,164
	DB	142, 150,178,164,164,178
	DB	142, 206,220,150,192,192
	DB	142, 192,150,234,206,150
	DB	142, 206,220,150,192,192
	DB	142, 192,150,234,206,150
	DB	255		;nu het dak laten zien

NEWRAAM:
	LD	IX,(RAAMPOINT)
	LD	A,(IX+0)
	CP	255
	SCF
	RET	Z
	LD	(RAAMCOMM),A
	LD	A,150
	LD	(RAAMCOMM+4),A
	LD	A,11010000B
	LD	(RAAMCOMM+14),A
	LD	HL,RAAMCOMM
	CALL	IVDPCOMM
	LD	A,247
	LD	(RAAMCOMM+4),A
	LD	A,10010000B
	LD	(RAAMCOMM+14),A
	LD	HL,RAAMCOMM
	CALL	IVDPCOMM
	INC	IX
	LD	A,164
	LD	(RAAMCOMM2+4),A
	LD	B,5
NEWRAAMB:
	PUSH	BC
	LD	A,(IX+0)
	LD	(RAAMCOMM2),A
	LD	HL,RAAMCOMM2
	CALL	IVDPCOMM
	LD	A,(RAAMCOMM2+4)
	ADD	A,16
	LD	(RAAMCOMM2+4),A
	INC	IX
	POP	BC
	DJNZ	NEWRAAMB
	LD	(RAAMPOINT),IX
	OR	A
	RET

RAAMCOMM:
	DW	0            ;Van (X)
	DB	119,3        ;Van (Y)
	DW	0            ;Naar (X)
	DB	30,3         ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	34           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

RAAMCOMM2:
	DW	0            ;Van (X)
	DB	104,3        ;Van (Y)
	DW	0            ;Naar (X)
	DB	34,3         ;Naar (Y)
	DW	14           ;Aantal horizontaal
	DW	24           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;witte lijn/zwarte lijn onderaan
TITCOMMD:
	DW	0            ;Van (X)
	DB	0 ,0         ;Van (Y)
	DW	76           ;Naar (X)
	DB	109,0        ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;witte lijn bovenaan
TITCOMME:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	76           ;Naar (X)
	DB	254,0        ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	0FFH         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

	;nieuw stuk gebouw
TITCOMMF:
	DW	151          ;Van (X)
	DB	63,3         ;Van (Y)
	DW	77           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	104          ;Aantal horizontaal
	DW	1            ;Aantal verticaal
	DB	0FFH         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

RAAMREG23:
	DB	0
RAAMSTAT:
	DB	0

INTRAAM:
	LD	A,(RAAMREG23)
	DEC	A
	LD	(RAAMREG23),A
	LD	B,A
	LD	C,23
	CALL	WRTVDP
	LD	A,B
	ADD	A,120
	LD	B,A
	LD	C,013H
	CALL	WRTVDP
	LD	HL,TITCOMME
	CALL	IVDPCOMM
	LD	A,(TITCOMME+6)
	DEC	A
	LD	(TITCOMME+6),A
	XOR	A
	LD	(TITCOMMD+12),A
	LD	HL,TITCOMMD
	CALL	IVDPCOMM
	LD	A,(TITCOMMD+6)
	DEC	A
	LD	(TITCOMMD+6),A
	LD	A,0FFH
	LD	(TITCOMMD+12),A
	LD	HL,TITCOMMD
	CALL	IVDPCOMM
	LD	HL,TITCOMMF
	CALL	IVDPCOMM
	LD	A,(TITCOMMF+6)
	DEC	A
	LD	(TITCOMMF+6),A
	LD	A,(TITCOMMF+2)
	DEC	A
	LD	(TITCOMMF+2),A
	CP	255
	JR	Z,INTRAAMEND
	CP	29
	RET	NZ
	CALL	NEWRAAM
	RET	C
	LD	A,63
	LD	(TITCOMMF+2),A
	RET
INTRAAMEND:
	LD	A,2
	LD	(RAAMSTAT),A
	RET

	;witte lijn bovenaan
KNMCOMM:
	DW	0            ;Van (X)
	DB	119,2        ;Van (Y)
	DW	24           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	207          ;Aantal horizontaal
	DW	72           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop
	;witte lijn bovenaan
ANDRECOMM:
	DW	0            ;Van (X)
	DB	119,2        ;Van (Y)
	DW	70           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	23           ;Aantal horizontaal
	DW	72           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

	;zet knightram op scherm: A=y waarde
KNIGHTRAM:
	LD	(KNMCOMM+6),A
	LD	HL,KNMCOMM
	CALL	IVDPCOMM
	RET

	;zet andre op scherm: A=y waarde
ANDRE:
	LD	(ANDRECOMM+6),A
	LD	A,70
	LD	(ANDRECOMM+4),A
	LD	B,5
	LD	IX,ANDREDATA
ANDREB:
	PUSH	BC
	LD	A,(IX+0)
	LD	(ANDRECOMM),A
	LD	HL,ANDRECOMM
	CALL	IVDPCOMM
	LD	A,(ANDRECOMM+4)
	ADD	A,23
	LD	(ANDRECOMM+4),A
	POP	BC
	INC	IX
	DJNZ	ANDREB
	RET
ANDREDATA:
	DB	161,23,207,138,230

CREDDATA:
	DB	 90,255,    104,0,"CODING",0, 0,0," ",0
	DB	255, 90,    108,0,"MUSIC",0, 0,0," ",0
	DB	140, 32,    96,0,"GRAPHICS",0, 116,118,"AND ",0
	DB	 32,140,    80,0,"LEVEL DESIGN",0, 116,118,"AND ",0
	DB	 32,140,    88,0,"GAME IDEAS",0, 116,118,"AND",0
	DB	140, 32,    80,0,"STORY DESIGN",0, 116,118,"AND",0
	DB	255, 90,    80,0,"COVER DESIGN",0, 0,0, " ",0
	DB	 90,255,    76,0,"SOUND EFFECTS",0, 0,0, " ",0


PUTCRED:
	LD	IX,CREDDATA
	LD	B,8
PUTCREDB:
	PUSH	BC
	LD	A,(IX+0)
	CP	255
	JR	Z,PUTCREDC
	PUSH	IX
	CALL	ANDRE
	POP	IX
PUTCREDC:
	INC	IX
	LD	A,(IX+0)
	CP	255
	JR	Z,PUTCREDD
	PUSH	IX
	CALL	KNIGHTRAM
	POP	IX
PUTCREDD:
	CALL	CHECKVDP
	INC	IX
	CALL	SPECFADEI
	LD	H,(IX+0)
	INC	IX
	LD	L,(IX+0)
	INC	IX
	CALL	TEXTPUT2
	INC	IX
	LD	H,(IX+0)
	INC	IX
	LD	L,(IX+0)
	INC	IX
	CALL	TEXTPUT2
	INC	IX
	LD	B,200
	CALL	PAUSE
	PUSH	IX
	LD	HL,CREDITPAL2
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	POP	IX
	POP	BC
	DJNZ	PUTCREDB
	RET

SPECFADEI:
	LD	HL,SPECFADE
	LD	(TITELINT3+1),HL
	LD	HL,FADEDATA
	LD	(SPECFADEP),HL
	RET
SPECFADEP:
	DW	0
SPECFADEO:
	DB	0

SPECFADE:
	LD	BC,00810H
	CALL	WRTVDP
	LD	A,055H
	OUT	(09AH),A
	NOP
	OUT	(09AH),A
	LD	BC,00F10H
	CALL	WRTVDP
	LD	HL,SPECFADEO
	INC	(HL)
	BIT	0,(HL)
	RET	Z
	LD	A,077H
	OUT	(09AH),A
	NOP
	OUT	(09AH),A
	LD	HL,(SPECFADEP)
	LD	A,(HL)
	CP	255
	JR	Z,SPECFADEE
	LD	B,5
	LD	IX,FADEVOLG
SPECFADEB:
	LD	A,(IX+0)
	OUT	(099H),A
	LD	A,144
	OUT	(099H),A
	INC	IX
	LD	A,(HL)
	OUT	(09AH),A
	INC	HL
	LD	A,(HL)
	OUT	(09AH),A
	INC	HL
	DJNZ	SPECFADEB
	LD	(SPECFADEP),HL
	RET
SPECFADEE:
	LD	HL,NIETS
	LD	(TITELINT3+1),HL
	RET

FADEVOLG:
	DB	0,7,12,2,3
FADEDATA:
	DB	77H,07H, 77H,07H, 77H,07H, 77H,07H, 77H,07H
	DB	55H,05H, 77H,07H, 77H,07H, 77H,07H, 77H,07H
	DB	33H,03H, 66H,06H, 77H,07H, 77H,07H, 77H,07H
	DB	11H,01H, 55H,05H, 66H,06H, 77H,07H, 77H,07H
	DB	00H,00H, 44H,04H, 66H,06H, 66H,06H, 77H,07H
	DB	00H,00H, 33H,03H, 55H,05H, 66H,06H, 66H,06H
	DB	00H,00H, 22H,02H, 55H,05H, 66H,06H, 66H,06H
	DB	00H,00H, 11H,01H, 44H,04H, 55H,05H, 66H,06H
	DB	00H,00H, 00H,00H, 33H,03H, 55H,05H, 66H,06H
	DB	00H,00H, 00H,00H, 22H,02H, 55H,05H, 55H,05H
	DB	00H,00H, 00H,00H, 11H,01H, 44H,04H, 55H,05H
	DB	00H,00H, 00H,00H, 00H,00H, 44H,04H, 55H,05H
	DB	00H,00H, 00H,00H, 00H,00H, 44H,04H, 55H,05H
	DB	00H,00H, 00H,00H, 00H,00H, 33H,03H, 44H,04H
	DB	00H,00H, 00H,00H, 00H,00H, 33H,03H, 44H,04H
	DB	00H,00H, 00H,00H, 00H,00H, 33H,03H, 44H,04H
	DB	00H,00H, 00H,00H, 00H,00H, 22H,02H, 44H,04H
	DB	00H,00H, 00H,00H, 00H,00H, 22H,02H, 33H,03H
	DB	00H,00H, 00H,00H, 00H,00H, 22H,02H, 33H,03H
	DB	00H,00H, 00H,00H, 00H,00H, 11H,01H, 33H,03H
	DB	00H,00H, 00H,00H, 00H,00H, 11H,01H, 33H,03H
	DB	00H,00H, 00H,00H, 00H,00H, 11H,01H, 33H,03H
	DB	00H,00H, 00H,00H, 00H,00H, 00H,00H, 33H,03H
	DB	255

	LD	BC,0C014H
	LD	DE,000E8H
	LD	HL,02096H
	LD	A,3
	CALL	PFADEIN


	;Puntjesroutine
	;invoer: B=x offset
	;	  C=y offset
	;	  D=source x
	;	  E=source y
	;	  H=destination x
	;	  L=destination y
	;	  A=source page. (destination page altijd page 0)
	;Opmerking: Statusregister 2 moet ingesteld zijn

PFADEIN:
	PUSH	AF
	LD	A,10010000B
	LD	(PFADEE+1),A
	POP	AF
	JR	PFADE

PFADEOUT:
	LD	A,01010000B
	LD	(PFADEE+1),A

PFADE:
	LD	(PFADEPAG),A
	PUSH	BC
	LD	BC,00128H
	CALL	IWRTVDP
	LD	BC,0012AH
	CALL	IWRTVDP
	LD	BC,00029H
	CALL	IWRTVDP
	LD	BC,0002BH
	CALL	IWRTVDP
	LD	BC,00027H
	CALL	IWRTVDP
	LD	BC,0002DH
	POP	BC
	DEC	B
	DEC	C
	XOR	A
	LD	IX,PUNTRAND
	LD	IY,PUNTHULP
PFADEB:
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
	LD	A,(IX+0)
	AND	15
	LD	(IY+0),A
	NEG
	LD	(IY+1),A
	LD	A,(IX+0)
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	LD	(IY+2),A
	NEG
	LD	(IY+3),A
	LD	A,B
	ADD	A,(IY+1)
	LD	B,A
	LD	A,D
	ADD	A,(IY+0)
	LD	D,A
	LD	A,H
	ADD	A,(IY+0)
	LD	H,A

	LD	A,C
	ADD	A,(IY+3)
	LD	C,A
	LD	A,E
	ADD	A,(IY+2)
	LD	E,A
	LD	A,L
	ADD	A,(IY+2)
	LD	L,A
	CALL	PFADEC
	INC	IX
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	DEC	A
	JR	NZ,PFADEB
	RET

PFADEC:
	PUSH	BC
	PUSH	DE
	PUSH	HL
PFADED:
	LD	A,32
	DI
	OUT	(099H),A
	LD	A,145
	EI
	OUT	(099H),A
PFADEF:
	IN	A,(099H)
	AND	1
	JR	NZ,PFADEF
	LD	A,D
	OUT	(09BH),A
	XOR	A
	OUT	(09BH),A
	LD	A,E
	OUT	(09BH),A
	LD	A,(PFADEPAG)
	OUT	(09BH),A
	LD	A,H
	OUT	(09BH),A
	XOR	A
	OUT	(09BH),A
	LD	A,L
	OUT	(09BH),A
	XOR	A
	OUT	(09BH),A
	LD	A,1
	OUT	(09BH),A
	XOR	A
	OUT	(09BH),A
	LD	A,1
	OUT	(09BH),A
	XOR	A
	OUT	(09BH),A
PFADEE:
	LD	A,10010000B
	DI
	OUT	(099H),A
	LD	A,174
	EI
	OUT	(099H),A
	LD	A,D
	ADD	A,16
	LD	D,A
	LD	A,H
	ADD	A,16
	LD	H,A
	LD	A,B
	SUB	16
	LD	B,A
	JR	NC,PFADED
	POP	HL
	POP	DE
	POP	BC
	LD	A,L
	ADD	A,16
	LD	L,A
	LD	A,E
	ADD	A,16
	LD	E,A
	LD	A,C
	SUB	16
	LD	C,A
	JP	NC,PFADEC
	RET

PFADEPAG:
	DB	0
PUNTHULP:
	DS	4
PUNTRAND:
	DB	156, 245, 125, 199, 122, 9, 50, 100
	DB	191, 16, 157, 243, 168, 189, 219, 73
	DB	193, 33, 55, 113, 95, 146, 149, 29
	DB	80, 128, 221, 205, 121, 253, 229, 47
	DB	116, 76, 196, 77, 83, 182, 32, 140
	DB	0, 86, 131, 30, 186, 152, 145, 62
	DB	106, 236, 89, 7, 177, 61, 151, 233
	DB	18, 223, 81, 17, 171, 138, 153, 244
	DB	64, 218, 173, 130, 200, 10, 144, 107
	DB	114, 187, 234, 74, 167, 117, 90, 235
	DB	101, 154, 217, 252, 190, 67, 24, 172
	DB	97, 241, 225, 42, 78, 212, 35, 188
	DB	204, 34, 115, 60, 247, 195, 111, 109
	DB	210, 194, 11, 119, 104, 98, 176, 21
	DB	230, 38, 59, 216, 72, 255, 44, 40
	DB	65, 242, 134, 250, 159, 39, 211, 2
	DB	169, 220, 178, 201, 231, 8, 70, 160
	DB	215, 185, 37, 135, 240, 207, 27, 165
	DB	163, 103, 136, 45, 75, 69, 197, 94
	DB	183, 5, 126, 88, 222, 28, 105, 51
	DB	53, 63, 208, 228, 141, 22, 214, 120
	DB	162, 170, 246, 148, 237, 49, 71, 175
	DB	25, 181, 54, 93, 192, 226, 46, 96
	DB	127, 142, 56, 254, 224, 232, 180, 92
	DB	184, 174, 202, 129, 161, 110, 147, 124
	DB	164, 4, 1, 31, 139, 68, 19, 57
	DB	150, 203, 166, 248, 14, 41, 209, 15
	DB	66, 213, 91, 82, 87, 123, 26, 85
	DB	52, 13, 102, 36, 6, 227, 43, 238
	DB	3, 249, 239, 108, 137, 79, 118, 58
	DB	84, 99, 206, 133, 155, 20, 251, 12
	DB	179, 112, 23, 48, 198, 143, 158, 132


	;Deze routine kijkt of er een letter wordt ingetoetst.
	;Zoja, dan is de uitvoer de x-coordinaat waar deze letter
	;staat in het video geheugen.
	;Invoer: -    Uitvoer: c=1 als toets gedetecteerd, D=x-coordinaat
	;Info: BIT 0,A = CB 47
	;	BIT 1,A = CB 4F
	;	BIT 7,A = CB 7F (steeds 8 erbij)

READPASS:
	LD	HL,SCANHUIDIG
	LD	DE,00877H	;D=x-coordinaat, E=BIT 6,A
	LD	B,26
READPASSB:
	LD	A,E
	LD	(READPASSC+1),A
	LD	A,(HL)
READPASSC:
	BIT	0,A
	SCF
	RET	NZ
	LD	A,8
	ADD	A,D
	LD	D,A
	LD	A,8
	ADD	A,E
	LD	E,A
	CP	087H
	JR	NZ,READPASSD
	LD	E,047H
	INC	HL
READPASSD:
	DJNZ	READPASSB
	OR	A
	RET

	;Scan het keyboard. In (SCANHUIDIG) en de daarop volgende bytes
	;komt de informatie over het wel of niet ingedrukt zijn van
	;de toetsen.

SCANKEYB:
	LD	C,2	;Eerste rijnummer.
	LD	HL,SCANVORIG
	LD	DE,SCANHUIDIG
SCANKEYBB:
	IN	A,(0AAH)
	AND	0F0H
	OR	C
	OUT	(0AAH),A
	IN	A,(0A9H)
	LD	B,(HL)
	LD	(HL),A
	XOR	255
	AND	B
	LD	(DE),A
	INC	HL
	INC	DE
	INC	C
	LD	A,C
	CP	8	;Laatste rijnummer + 1
	JR	NZ,SCANKEYBB
	RET
SCANVORIG:
	DS	15
SCANHUIDIG:
	DS	15

PAGE0COMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	212,0        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	44           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop