	ORG	08100H

INITMUSDAT:	EQU 0000H ; start/initialize new music/song
REPLAYROUT:	EQU 0003H ; interrupt routine for playing music
ALLMUSICOFF:	EQU 0006H ; turn off music all at once
SETVOLUDEC:	EQU 0009H ; start fading out music volume
MUSADRES:	EQU 002DH ; prepare music data (relative offsets -> absolute RAM addresses)
	
START:	DI
	LD	(STACK),SP
	CALL	READINT
	LD	HL,CLRSCRCOMM	;scherm wissen
	CALL	VDPCOMM
	CALL	CHECKVDP
	CALL	RAMBYTE	;RAM op alle pagina's instellen
	LD	A,D
	OUT	(0A8H),A
	LD	A,E
	LD	(0FFFFH),A

	LD	BC,0020FH
	CALL	WRTVDP
	LD	BC,00A08H	;Sprites uit
	CALL	WRTVDP
	LD	BC,01600H	;Line interrupt aan
	CALL	WRTVDP
	LD	BC,04201H	;interrupt
	CALL	WRTVDP
	LD	BC,0BE13H	;Line interrupt op line 190
	CALL	WRTVDP
	LD	BC,00017H
	CALL	WRTVDP

	LD	HL,MUSICINT	;Interruptroutine met alleen muziekroutine
	LD	(00039H),HL

	LD	HL,01800H
	LD	BC,1000
	CALL	MUSADRES

	LD	HL,01804H
	CALL	INITMUSDAT

	LD	HL,PALLETLEEG
	LD	DE,PALLET1
	LD	A,4
	CALL	LETFADE
	LD	HL,ENDCOMM1
	CALL	VDPCOMM
	CALL	CHECKVDP

	EI
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	LD	IX,ENDTEXT1
	LD	HL,0A008H
PRAATB:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATB
	LD	B,0
	CALL	PAUSE
	LD	HL,PALLET1
	LD	DE,PALLETLEEG
	LD	A,4
	CALL	LETFADE
	LD	B,36
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,ENDCOMM2
	CALL	IVDPCOMM
	LD	HL,ENDCOMM3
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,PALLET2
	LD	A,4
	CALL	LETFADE
	LD	B,100
	CALL	PAUSE
	LD	IX,ENDTEXT2
	LD	HL,00098H
PRAATC:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATC
	LD	B,150
	CALL	PAUSE
	LD	HL,PALLET2
	LD	DE,PALLETVOL
	LD	A,4
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,ENDCOMM4
	CALL	IVDPCOMM
	LD	HL,PRPROGDAT2
	CALL	PRPROGINI
	LD	HL,PALLETVOL
	LD	DE,PALLET4
	LD	A,4
	CALL	LETFADE
	LD	IX,ENDTEXT3
	LD	HL,00087H
PRAATD:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATD
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	LD	B,150
	CALL	PAUSE
	LD	HL,ENDCOMM7
	CALL	IVDPCOMM
	LD	HL,PRPROGDAT2
	CALL	PRPROGINI
	LD	IX,ENDTEXT3B
	LD	HL,00087H
PRAATE:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATE
	LD	IX,PRANI8
	CALL	PRCOPY
	LD	B,150
	CALL	PAUSE
	LD	HL,PALLET4
	LD	DE,PALLETLEEG
	LD	A,4
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,ENDCOMM8
	CALL	IVDPCOMM
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	LD	HL,PALLETLEEG
	LD	DE,PALLET3
	LD	A,4
	CALL	LETFADE
	LD	IX,ENDTEXT4
	LD	HL,00087H
PRAATF:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATF
	XOR	A
	LD	(ENDCOMMA),A
	LD	IY,KOPTEXTS
	LD	B,5
PRAATG:
	PUSH	BC
	PUSH	IY
	LD	B,100
	CALL	PAUSE
	LD	HL,ENDCOMM7
	CALL	IVDPCOMM
	LD	HL,ENDCOMM9
	CALL	IVDPCOMM
	LD	A,(ENDCOMMA)
	ADD	A,8
	LD	(ENDCOMMA+4),A
	PUSH	AF
	LD	HL,ENDCOMMA
	CALL	IVDPCOMM
	CALL	CHECKVDP
	POP	AF
	ADD	A,40
	LD	(ENDCOMMA),A
	LD	BC,0003AH
	LD	DE,00000H
	LD	HL,00030H
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
	POP	IY
	PUSH	IY
	LD	L,(IY+0)
	LD	H,(IY+1)
	PUSH	HL
	POP	IX
	LD	HL,00087H
PRAATH:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATH
	POP	IY
	INC	IY
	INC	IY
	POP	BC
	DJNZ	PRAATG
	LD	B,100
	CALL	PAUSE
	LD	HL,PALLET3
	LD	DE,PALLETLEEG
	LD	A,4
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	HL,ENDCOMM5
	CALL	IVDPCOMM
	LD	HL,PALLETLEEG
	LD	DE,PALLET3
	LD	A,4
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	LD	IX,ENDTEXTA
	LD	HL,00087H
PRAATI:
	CALL	PRTEXT
	CP	3
	JR	NZ,PRAATI
	LD	B,100
	CALL	PAUSE
	LD	HL,ENDCOMM7
	CALL	IVDPCOMM
	LD	HL,PALLET3
	LD	DE,PALLET4
	LD	A,5
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	LD	HL,PRPROGDAT3
	CALL	PRPROGINI
	LD	IX,ENDTEXTB
	LD	HL,01887H
	CALL	PRTEXT
	LD	IX,PRANI11
	CALL	PRCOPY
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	LD	B,100
	CALL	PAUSE
	LD	HL,ENDCOMM7
	CALL	IVDPCOMM
	LD	HL,PALLET4
	LD	DE,PALLET3
	LD	A,5
	CALL	LETFADE
	LD	B,50
	CALL	PAUSE
	XOR	A
	LD	(OMHOOG),A
	LD	B,100
	CALL	PAUSE
	LD	HL,ENDCOMM6
	CALL	IVDPCOMM
	LD	B,100
	CALL	PAUSE
	LD	IX,ENDTEXTC
	LD	HL,058F8H
	CALL	PRTEXT
PRAATK:
	EI
	HALT
	CALL	JOYSTICK
	OR	A
	JR	Z,PRAATK
	LD	HL,PALLET3
	LD	DE,PALLETLEEG
	LD	A,4
	CALL	LETFADE
	LD	B,7
	CALL	SETVOLUDEC
	LD	B,45
	CALL	PAUSE
	LD	HL,PRPROGDAT1
	CALL	PRPROGINI
	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	A,1
	LD	(PRTEXTX+1),A
	LD	IX,ENDTEXTD
	LD	HL,05864H
	CALL	PRTEXT
	DI
	LD	BC,00017H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	LD	HL,PALLETLEEG
	LD	DE,PALLET4
	LD	A,4
	CALL	LETFADE
	LD	B,45
	CALL	PAUSE
	CALL	ALLMUSICOFF
	DI
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
	LD	SP,(STACK)
	RET

KOPTEXTS:
	DW	ENDTEXT5,ENDTEXT6,ENDTEXT7,ENDTEXT8,ENDTEXT9

MUSICINT:
	PUSH	AF
	LD	A,1
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	AND	1
	JR	Z,MUSICINTB
	DI
	PUSH	HL
	PUSH	DE
	PUSH	BC
	EXX
	EX	AF,AF'
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	AF
	PUSH	IX
	PUSH	IY
	CALL	OMHOOG
	CALL	REGELFADE
	CALL	REPLAYROUT
	POP	IY
	POP	IX
	POP	AF
	POP	BC
	POP	DE
	POP	HL
	EXX
	EX	AF,AF'
	POP	BC
	POP	DE
	POP	HL
MUSICINTB:
	LD	A,2	;Status register 2
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	POP	AF
	EI
	RET

CLRSCRCOMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	256          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

RAMBYTE:
	LD	HL,0F344H	;Geeft primaire en secundaire sloten
	LD	DE,0	;voor RAM op alle pages.
	LD	B,4	;Invoer: Niets
RAMBYTE2:
	LD	A,(HL)	;Uitvoer: D=primair (outpoort 0a8h)
	RR	A	;         E=secundair (adres 0FFFFh)
	RR	D
	RR	A
	RR	D
	RR	A
	RR	E
	RR	A
	RR	E
	DJNZ	RAMBYTE2
	RET

RAMROMBYTE:
	CALL	RAMBYTE	;Geeft primaire en secundaire sloten
	LD	A,(0FCC1H)	;voor RAM op page 2 en 3 en ROM op page
	PUSH	AF	;0 en 1.
	AND	3	;Invoer: Niets
	LD	B,A	;Uitvoer: D=primair (outpoort 0A8h)
	ADD	A,A	;         E=secundair (adres 0FFFFh)
	ADD	A,A
	OR	B
	LD	B,A
	LD	A,D
	AND	240
	OR	B
	LD	D,A
	POP	AF
	AND	12
	LD	B,A
	SRL	A
	SRL	A
	OR	B
	LD	B,A
	LD	A,E
	AND	240
	OR	B
	LD	E,A
	RET

IGETKEYS:
	LD	B,A
	DI
	IN	A,(0AAH)
	AND	0F0H
	ADD	A,B
	OUT	(0AAH),A
	EI
	IN	A,(0A9H)
	RET

GETKEYS:
	LD	B,A
	IN	A,(0AAH)
	AND	0F0H
	ADD	A,B
	OUT	(0AAH),A
	IN	A,(0A9H)
	RET

READINT:
	DI
	LD	A,1
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	LD	A,2
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	RET

READINT2:
	DI
	LD	A,2
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	LD	A,1
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	XOR	A
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	RET

SETRDVRAM:
	LD	A,H	    ;Stelt het VRAM-adres in (voor lezen)
	RL	A	    ;Invoer : HL=adres
	RL	A	    ;	  c=1 voor bovenste 64kb
	RL	A
	AND	7
	OUT	(099H),A
	LD	A,142
	OUT	(099H),A
	LD	A,L
	OUT	(099H),A
	LD	A,H
	AND	03FH
	OUT	(099H),A
	RET

ISETRDVRAM:
	LD	A,H	    ;Stelt het VRAM-adres in (voor lezen)
	RL	A	    ;Invoer : HL=adres
	RL	A	    ;	  c=1 voor bovenste 64kb
	RL	A
	AND	7
	DI
	OUT	(099H),A
	LD	A,142
	EI
	OUT	(099H),A
	LD	A,L
	DI
	OUT	(099H),A
	LD	A,H
	AND	03FH
	EI
	OUT	(099H),A
	RET

SETWRVRAM:
	LD	A,H	    ;Stelt het VRAM-adres in (voor scrijven)
	RL	A                   ;Invoer : HL=adres
	RL	A                   ;         c=1 voor bovenste 64kb
	RL	A
	AND	7
	OUT	(099H),A
	LD	A,142
	OUT	(099H),A
	LD	A,L
	OUT	(099H),A
	LD	A,H
	AND	03FH
	OR	040H
	OUT	(099H),A
	RET

ISETWRVRAM:
	LD	A,H	    ;Stelt het VRAM-adres in (voor scrijven)
	RL	A	    ;Invoer : HL=adres
	RL	A	    ;	  c=1 voor bovenste 64kb
	RL	A
	AND	7
	DI
	OUT	(099H),A
	LD	A,142
	EI
	OUT	(099H),A
	LD	A,L
	DI
	OUT	(099H),A
	LD	A,H
	AND	03FH
	OR	040H
	EI
	OUT	(099H),A
	RET

WRVRAM:
	PUSH	AF	    ;Schijft 1 byte data naar willekeurig
	CALL	SETWRVRAM	    ;VRAM-adres
	POP	AF	    ;Invoer :HL=adres, c=1 voor bovenste 64kb
	OUT	(098H),A	    ;	 A=data
	RET

RDVRAM:
	PUSH	AF	    ;Leest 1 byte data naar willekeurig
	CALL	SETRDVRAM	    ;VRAM-adres
	POP	AF	    ;Invoer :HL=adres, c=1 voor bovenste 64kb
	IN	A,(098H)	    ;Uitvoer:A=data
	RET

IWRVRAM:
	PUSH	AF	    ;Schijft 1 byte data naar willekeurig
	CALL	ISETWRVRAM	    ;VRAM-adres
	POP	AF	    ;Invoer :HL=adres, c=1 voor bovenste 64kb
	OUT	(098H),A	    ;	 A=data
	RET

IRDVRAM:
	PUSH	AF	    ;Leest 1 byte data naar willekeurig
	CALL	ISETRDVRAM	    ;VRAM-adres
	POP	AF	    ;Invoer :HL=adres, c=1 voor bovenste 64kb
	IN	A,(098H)	    ;Uitvoer:A=data
	RET

VDPCOMM:
	LD	A,32	    ;Stuurt 15-bytes data naar de
	OUT	(099H),A	    ;command-registers van de VDP.
	LD	A,145	    ;Invoer : HL=startadres van tabel data.
	OUT	(099H),A
VDPCOMMB:
	IN	A,(099H)
	BIT	0,A
	JR	NZ,VDPCOMMB
	LD	BC,00F9BH
	OTIR
	RET

IVDPCOMM:
	LD	A,32	    ;Stuurt 15-bytes data naar de
	DI
	OUT	(099H),A	    ;command-registers van de VDP.
	LD	A,145	    ;Invoer : HL=startadres van tabel data.
	EI
	OUT	(099H),A
IVDPCOMMB:
	IN	A,(099H)
	BIT	0,A
	JR	NZ,IVDPCOMMB
	LD	BC,00F9BH
	OTIR
	RET

VDPCOMM2:
	LD	A,32	    ;Stuurt 15-bytes data naar de
	OUT	(099H),A	    ;command-registers van de VDP.
	LD	A,145               ;Invoer : HL=startadres van tabel data.
	OUT	(099H),A
	CALL	CHECKVDP2
	LD	BC,00F9BH
	OTIR
	RET

CHECKVDP:
	IN	A,(099H)
	AND	1
	JR	NZ,CHECKVDP
	RET

CHECKVDP2:
	LD	A,2	    ;Kijkt of VDP klaar is, zonee, wacht
	OUT	(099H),A	    ;Invoer : -
	LD	A,143
	OUT	(099H),A
CHECKVDP2B:
	IN	A,(099H)
	AND	1
	JR	NZ,CHECKVDP2B
	XOR	A
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	RET

WRTVDP:
	LD	A,B
	OUT	(099H),A
	LD	A,C
	OR	128
	OUT	(099H),A
	RET

IWRTVDP:
	LD	A,B
	DI
	OUT	(099H),A
	LD	A,C
	OR	128
	EI
	OUT	(099H),A
	RET

WRTVDP9:
	LD	A,(0FFE8H)
	AND	2
	OR	B
	OUT	(099H),A
	LD	A,137
	OUT	(099H),A
	RET

IWRTVDP9:
	LD	A,(0FFE8H)
	AND	2
	OR	B
	DI
	OUT	(099H),A
	LD	A,137
	EI
	OUT	(099H),A
	RET

	;Om kleuren via de interrupt te laten faden
LETFADE:
	LD	(STARTPAL),HL	;Invoer: HL=STARTPALLET
	LD	(EINDPAL),DE	;        DE=EINDPALLET
	CALL	FADEINIT	;        A=SNELHEID
	XOR	A
	LD	(REGELFADE),A
	RET

	;Op interrupt-niveau aanroepen en het faden wordt weer geregeld!
REGELFADE:
	RET
	LD	IX,0
	LD	IY,0
	CALL	FADE
	RET	NC
	LD	A,0C9H
	LD	(REGELFADE),A
	RET
STARTPAL:	EQU	REGELFADE+3
EINDPAL:	EQU	REGELFADE+7

FADEINIT:
	LD	(FADESPD1),A	;Invoer: HL=startpallet
	LD	(FADESPD2),A	;        A =snelheid
	LD	A,8
	LD	(FADEAANT),A	;8 keer faden
	XOR	A
	OUT	(099H),A
	LD	A,144
	OUT	(099H),A	;colorregister resetten
	LD	BC,0209AH
	OTIR		;start-pallet naar VDP
	LD	HL,FADEIRED
	LD	(FADEROUT),HL	;Deze routine als eerste aanroepen
	OR	A
	RET
FADEIRED:
	LD	HL,FADEIBLUE
	LD	(FADEROUT),HL
	LD	HL,FADETABEL
	LD	DE,2
	LD	B,16
FADEIREDC:
	LD	A,(IY+0)
	OR	15
	SUB	(IX+0)
FADEIREDB:
	SRA	A
	SRA	A
	SRA	A
	SRA	A
	LD	(HL),A
	INC	HL
	LD	A,(IX+0)
	SRL	A
	AND	00111000B
	LD	(HL),A
	INC	HL
	ADD	HL,DE
	ADD	HL,DE
	ADD	IX,DE
	ADD	IY,DE
	DJNZ	FADEIREDC
	OR	A
	RET
FADEIGREEN:
	LD	HL,FADEMAAR
	LD	(FADEROUT),HL
	LD	HL,FADETABEL+4
	INC	IX
	INC	IY
	JR	FADEIBLGR
FADEIBLUE:
	LD	HL,FADEIGREEN
	LD	(FADEROUT),HL
	LD	HL,FADETABEL+2
FADEIBLGR:
	LD	DE,2
	LD	B,16
FADEIBLGRC:
	LD	A,(IY+0)
	OR	240
	SUB	(IX+0)
	OR	240
	BIT	3,A
	JR	NZ,FADEIBLGRB
	AND	15
FADEIBLGRB:
	LD	(HL),A
	INC	HL
	LD	A,(IX+0)
	AND	00000111B
	SLA	A
	SLA	A
	SLA	A
	LD	(HL),A
	INC	HL
	ADD	HL,DE
	ADD	HL,DE
	ADD	IX,DE
	ADD	IY,DE
	DJNZ	FADEIBLGRC
	OR	A
	RET
FADESPD1:	DB	0
FADESPD2:	DB	0
FADEAANT:	DB	0

FADE:
	DB	0C3H	;Invoer: IX=startpallet
FADEROUT:
	DW	0	;        IY=eindpallet
FADEMAAR:
	LD	HL,FADESPD1
	OR	A
	DEC	(HL)
	RET	NZ
	INC	HL
	LD	A,(HL)
	DEC	HL
	LD	(HL),A
	XOR	A
	OUT	(099H),A
	LD	A,144
	OUT	(099H),A
	LD	HL,FADETABEL
	LD	B,16
FADEMAARB:
	LD	A,(HL)
	INC	HL
	ADD	A,(HL)
	LD	(HL),A
	INC	HL
	SLA	A
	AND	01110000B
	LD	C,A
	LD	A,(HL)
	INC	HL
	ADD	A,(HL)
	LD	(HL),A
	INC	HL
	SRL	A
	SRL	A
	SRL	A
	OR	C
	OUT	(09AH),A
	LD	A,(HL)
	INC	HL
	ADD	A,(HL)
	LD	(HL),A
	INC	HL
	SRL	A
	SRL	A
	SRL	A
	OUT	(09AH),A
	DJNZ	FADEMAARB
	LD	HL,FADEAANT
	DEC	(HL)
	SCF
	RET	Z
	OR	A
	RET
FADETABEL:
	DS	96
PALLETLEEG:
	DS	32	;Een pallet van allemaal zwarte kleuren
PALLETVOL:
	DB	077H,07H,077H,07H,077H,07H,077H,07H
	DB	077H,07H,077H,07H,077H,07H,077H,07H
	DB	077H,07H,077H,07H,077H,07H,077H,07H
	DB	077H,07H,077H,07H,077H,07H,077H,07H

PAUSE:
	EI
	HALT
	DJNZ	PAUSE
	RET

NIETS:
	RET

	;Startcoordinaten witte scroll: H=x, L=y
WITBEGCOR:
	LD	A,H
	LD	(LETTERCOMM+4),A
	LD	A,L
	LD	(LETTERCOMM+6),A
	RET
	;Zet letter neer: a=letter, automatisch 1 positie verder
WITPUTLET:
	SUB	32
	ADD	A,A
	ADD	A,A
	ADD	A,A
	LD	(LETTERCOMM),A
	LD	A,188
	JR	NC,WITPUTLETB
	ADD	A,8
WITPUTLETB:
	LD	(LETTERCOMM+2),A
	LD	HL,LETTERCOMM
	CALL	IVDPCOMM
	LD	A,(LETTERCOMM+4)
	ADD	A,8
	LD	(LETTERCOMM+4),A
	RET
	;Kleine menu-letters neerzetten
LETTERCOMM:
	DW	0            ;Van (X)
	DB	191 ,2       ;Van (Y)
	DW	0            ;Naar (X)
	DB	0  ,0        ;Naar (Y)
	DW	8            ;Aantal horizontaal
	DW	8            ;Aantal verticaal
	DB	000H         ;Kleur
	DB	00000000B    ;Manier van copieren
	DB	11010000B    ;Commando/Logop

	;Leest stand van cursors, beide joysticks, SPACE, SHIFT en GRAPH
	;vuurknoppen (ook SPACE,SHIFT,GRAPH) alleen bij indrukken aktief.
	;Invoer: (JOYWELKE)=143 voor JOYST1 en 207 voor JOYST2
	;uitvoer:A &(JOYFIRENU):bit 7    6    5    4    3    2   1    0
	;		     0    0    TrB  TrA  GRP  0   SHFT SPC

	;	D en (JOYRICHT): bit 7    6    5    4    3    2    1    0
	;		     0    0    0    0    R    L    D    U

JOYSTICK:
	IN	A,(0AAH)
	AND	0F0H
	LD	B,A
	OR	8
	OUT	(0AAH),A
	NOP
	IN	A,(0A9H)
	CPL
	AND	11110001B
	LD	D,A
	LD	A,B
	OR	6
	OUT	(0AAH),A
	NOP
	IN	A,(0A9H)
	CPL
	SLA	A
	OR	D
	AND	00001011B
	LD	C,A
	SRL	D
	SRL	D
	SRL	D
	SRL	D
	LD	A,D
	AND	8
	RES	3,D
	SRL	D
	JR	NC,JOYSTICK2B
	OR	4
JOYSTICK2B:
	OR	D
	LD	D,A
	LD	A,15
	OUT	(0A0H),A
	LD	A,(JOYWELKE)
	OUT	(0A1H),A
	LD	A,14
	OUT	(0A0H),A
	NOP
	IN	A,(0A2H)
	CPL
	OR	D
	LD	E,A
	AND	15
	LD	D,A
	LD	(JOYRICHT),A
	LD	A,(JOYLETOP)
	AND	D
	LD	(JOYLETOP),A
	LD	A,E
	AND	00110000B
	OR	C
	LD	BC,(JOYFIREBUF)
	CPL
	LD	(JOYFIREBUF),A
	CPL
	SET	0,C
	SET	4,C
	AND	C
	LD	(JOYFIRENU),A
	RET
JOYFIREBUF:
	DB	255
JOYFIRENU:
	DB	0
JOYRICHT:
	DB	0
JOYWELKE:
	DB	143	;143 voor joystick 1, 207 voor joystick 2
JOYLETOP:
	DB	0	;Om te kijken of UP losgelaten is


PRCOPY:
	LD	A,(IX+0)
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

CLRTXTCOMM:
	DW	0            ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	64,0         ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	192          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop

PRAATCOMM:
	DW	0            ;Van (X)
	DB	0,1          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	0            ;Aantal horizontaal
	DW	212          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	10010000B    ;Commando/Logop

	;mond van reporter bewegen
PRANI8:
	DB	136,80, 2,18,13,104+11,48+37,255;sourX,Xoffs,Yoffs,desX,desY invullen
PRANI9:
	DB	154,80, 2,18,13,104+11,48+37,255
PRANI10:
	DB	172,80, 2,18,13,104+11,48+37,255
	;mond FRANC bewegen
PRANI11:
	DB	96,80 ,2, 13,18, 104+30,27+48,255
PRANI12:
	DB	109,80,2, 13,18, 104+30,27+48,255
PRANI13:
	DB	122,80,2, 13,18, 104+30,27+48,255

PRANI14:
	DB	255,255,0,1,1, 255,255,255	      ;niets

PRPROGINI:
	LD	(PRPROGPNT),HL
	LD	A,1
	LD	(PRPROGTEL),A
	RET

PRPROG:
	LD	HL,PRPROGTEL
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
PRPROGB:
	LD	(PRPROGTEL),A
	LD	L,(IY+1)
	LD	H,(IY+2)
	PUSH	HL
	POP	IX
	CALL	PRCOPY
	LD	DE,3
	ADD	IY,DE
	LD	(PRPROGPNT),IY
	RET

PRPROGPNT:
	DW	0
PRPROGTEL:
	DB	1

	;doe niets
PRPROGDAT1:
	DB	200
	DW	PRANI14
	DB	255
	DW	PRPROGDAT1

	;praten reporter
PRPROGDAT2:
	DB	2
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
PRPROGDAT3:
	DB	2
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

PRTEXT:
	CALL	WITBEGCOR
	LD	A,L
	ADD	A,16
	LD	L,A
	PUSH	HL
PRTEXT2:
	LD	A,(IX+0)
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
PRTEXTX:
	LD	B,6
	CALL	PAUSE
	JR	PRTEXT2
PRTEXT3:
	POP	HL
	RET
PRTEXT4:
	CALL	WITPUTLET
	JR	PRTEXT2

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
	DB	 156, 245, 125, 199, 122, 9, 50, 100
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

	;tekst bij wegrennende FRANC
ENDTEXT1:
	DB	"AFTER THE",0
	DB	"EXPLOSION",0
	DB	"THERE CAME A",0
	DB	"BIG HOLE IN",0
	DB	"THE WALL.",0
	DB	"FRANC JUMPED",0
	DB	"THROUGH THE",0
	DB	"WALL INTO",0
	DB	"THE NIGHT...",3

	;tekst bij BRANDEND huis
ENDTEXT2:
	DB	"FROM A DISTANCE, FRANC COULD SEE",0
	DB	"THAT THE BUILDING WAS BURNING...",0
	DB	"PROBABLY THE EXPLOSION WAS VERY",0
	DB	"POWERFUL...",3


	;TEKST BIJ VERSLAGGEVER/REPORTER
ENDTEXT3:
	DB	"HERE IS YOUR REPORTER, LIVE FROM",0
	DB	"LONDON....       ",3
ENDTEXT3B:
	DB	"THERE WAS A BIG EXPLOSION AT",0
	DB	"34 EARL ROAD.... THERE ARE SOME",0
	DB	"SURVIVORS BUT WE HAVEN'T GOT",0
	DB	"THEIR NAMES YET...",3

	;TEKST BIJ DE KRANTENKOPPEN
ENDTEXT4:
	DB	"THE NEXT DAY ALL THE NEWSPAPERS",0
	DB	"WERE FULL OF PICTURES OF THE",0
	DB	"SURVIVORS AND THE VICTIMS...",3

	; EERSTE KOP
ENDTEXT5:
	DB	"JAN LIGTHART FROM HOLLAND IS ONE",0
	DB	"OF THE SURVIVORS... HE IS NOW IN",0
	DB	"THE HOSPITAL RECOVERING FROM HIS",0
	DB	"BURN-WOUNDS...",3

	; TWEEDE KOP
ENDTEXT6:
	DB	"SADLY, ONE OF THE VICTIMS IS",0
	DB	"MR.ADORY. HE WAS THE BOSS OF THE",0
	DB	"BIGGEST FIRE-DEPARTMENT IN",0
	DB	"LONDON...",3

	; DERDE KOP (STOPPELS)
ENDTEXT7:
	DB	"ANOTHER VICTIM WAS MR. STUBBLE.",0
	DB	"HE WAS A GOOD DRAWING ARTIST.",0
	DB	"HE MADE DESIGNS FOR TV PROGRAMS",0
	DB	"LIKE LINKO AND TIRE OF FORTUNE.",3

	;VIERDE KOP
ENDTEXT8:
	DB	"HERR HOLZSTEIN IS CURRENTLY IN",0
	DB	"THE HOSPITAL. HE IS BADLY",0
	DB	"INJURED. MAYBE HE CAN'T WALK",0
	DB	"ANYMORE...",3

	;VIJFDE KOP
ENDTEXT9:
	DB	"ANOTHER SURVIVOR IS FLOW ED ROB.",0
	DB	"HE COULD ESCAPE VERY FAST FROM",0
	DB	"THE EXPLOSION. HE IS NOT",0
	DB	"INJURED...",3

	;FRANC
ENDTEXTA:
	DB	"FRANC IS A VERY HAPPY MAN. HE",0
	DB	"HAS ESCAPED FROM THE EXPLOSION..",0
	DB	"AND NOW HE IS A BUTLER AT THE",0
	DB	"RITZ HOTEL...",3

	;FRANC MET GOEDE KLEUREN
ENDTEXTB:
	DB	"THANK YOU FOR HELPING ME!!",3

ENDTEXTC:
	DB	"@1992 ANMA",3

ENDTEXTD:
	DB	"LOADING...",3

	;pallet van wegrennende FRANC
PALLET1:
	DB	000H,000H,022H,002H,000H,003H,020H,000H
	DB	031H,001H,007H,000H,042H,002H,055H,005H
	DB	063H,003H,005H,000H,003H,000H,077H,007H
	DB	075H,005H,033H,003H,055H,000H,077H,007H
	;pallet van brandend huis
PALLET2:
	DB	000H,000H,044H,004H,000H,000H,004H,000H
	DB	060H,000H,043H,003H,031H,001H,055H,005H
	DB	055H,005H,000H,003H,000H,000H,077H,007H
	DB	021H,001H,070H,005H,042H,002H,077H,007H
	;pallet van zwart-wit koppen en THE END
PALLET3:
	DB	000H,000H,067H,006H,022H,002H,064H,005H
	DB	011H,001H,052H,003H,022H,002H,044H,004H
	DB	055H,005H,033H,003H,041H,002H,077H,007H
	DB	063H,004H,033H,003H,033H,003H,057H,005H
	;pallet van franc en reporten in kleur
PALLET4:
	DB	000H,000H,055H,007H,044H,000H,022H,000H
	DB	031H,001H,002H,000H,042H,002H,055H,005H
	DB	075H,005H,074H,004H,004H,000H,077H,007H
	DB	066H,000H,033H,003H,063H,003H,000H,002H

	;plaatst wegrennende franc
ENDCOMM1:
	DW	0            ;Van (X)
	DB	0,1          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	154          ;Aantal horizontaal
	DW	212          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;plaatst bovenste deel brandend huis
ENDCOMM2:
	DW	0            ;Van (X)
	DB	116,2        ;Van (Y)
	DW	76           ;Naar (X)
	DB	0,0          ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	71           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;plaatst onderste deel brandend huis
ENDCOMM3:
	DW	106          ;Van (X)
	DB	116,2        ;Van (Y)
	DW	76           ;Naar (X)
	DB	71,0         ;Naar (Y)
	DW	106          ;Aantal horizontaal
	DW	71           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;plaatst reporter
ENDCOMM4:
	DW	48           ;Van (X)
	DB	58,2         ;Van (Y)
	DW	104          ;Naar (X)
	DB	48,0         ;Naar (Y)
	DW	48           ;Aantal horizontaal
	DW	58           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;plaatst FRANC (op het eind)
ENDCOMM5:
	DW	0            ;Van (X)
	DB	58,2         ;Van (Y)
	DW	104          ;Naar (X)
	DB	48,0         ;Naar (Y)
	DW	48           ;Aantal horizontaal
	DW	58           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;plaatst THE END
ENDCOMM6:
	DW	96           ;Van (X)
	DB	58,2         ;Van (Y)
	DW	50           ;Naar (X)
	DB	148,0        ;Naar (Y)
	DW	158          ;Aantal horizontaal
	DW	22           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;wist onderste deel van beeld
ENDCOMM7:
	DW	00           ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	135,0        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	77           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop
	;plaatst alle 5 koppen
ENDCOMM8:
	DW	00           ;Van (X)
	DB	0,2          ;Van (Y)
	DW	8            ;Naar (X)
	DB	48 ,0        ;Naar (Y)
	DW	240          ;Aantal horizontaal
	DW	58           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop
	;wist 3e pagina (bovenste gedeelte)
ENDCOMM9:
	DW	00           ;Van (X)
	DB	0,0          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0  ,3        ;Naar (Y)
	DW	256          ;Aantal horizontaal
	DW	100          ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11000000B    ;Commando/Logop
	;plaats 1 kop op 3e pagina (vanX,naarX nog invullen)
ENDCOMMA:
	DW	00           ;Van (X)
	DB	0,2          ;Van (Y)
	DW	0            ;Naar (X)
	DB	0  ,3        ;Naar (Y)
	DW	48           ;Aantal horizontaal
	DW	58           ;Aantal verticaal
	DB	000H         ;Kleur
	DB	0            ;Manier van copieren
	DB	11010000B    ;Commando/Logop

WAARDE23:
	DB	0

OMHOOG:
	RET
	LD	HL,WAARDE23
	INC	(HL)
	LD	A,(HL)
	CP	48
	JR	Z,OMHOOGB
	OUT	(099H),A
	LD	A,151
	OUT	(099H),A
	LD	A,(HL)
	ADD	A,192
	OUT	(099H),A
	LD	A,147
	OUT	(099H),A
	RET
OMHOOGB:
	LD	A,0C9H
	LD	(OMHOOG),A
	RET

STACK:
	DW	0

;----------------------------------------------------------------------------
; Fill with zero's to get binary file size divisible by 128 bytes
; That's what GEN80 used to do automatically
	
	DS (128-($%128))*($%128>0)*-1