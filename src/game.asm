	ORG	08100H

INITMUSDAT: EQU	00000H
REPLAYROUT: EQU	00003H
ALLMUSICOF: EQU	00006H
SETVOLUDEC: EQU	00009H
SETVOLUINC: EQU	0000CH
WORLDNR:	EQU	0FC83H
CHEATADR:	EQU	0FC84H	;beschermd dienblad en FRANC
CHEATADR2:	EQU	0FC85H	;extras m.b.v. toetsen
JOBDATA:	EQU	07000H
VIJANDEN:	EQU	JOBDATA+863
START:
	DI
	LD	HL,PALLETLEEG
	LD	DE,PALLETLEEG
	LD	A,3
	CALL	LETFADE
	LD	(STACK),SP
	CALL	READINT
	LD	HL,CLRSCRCOMM	;scherm wissen
	CALL	VDPCOMM
	CALL	COPYITEM	;items m.b.v. TPSET voorbereiden
	CALL	CHECKVDP
	CALL	SPRITEPAG1
	LD	C,219
	CALL	CLEARSPR
	XOR	A
	LD	(FRANR23),A
	CALL	SPRTOVRM
	CALL	RAMBYTE	;RAM op alle pagina's instellen
	LD	A,D
	OUT	(0A8H),A
	LD	A,E
	LD	(0FFFFH),A

	DI
	CALL	INITWORLD

STARTGAME:
	LD	BC,0020FH
	CALL	WRTVDP
	LD	BC,00808H	;Sprites aan
	CALL	WRTVDP
	LD	BC,01600H	;Line interrupt aan
	CALL	WRTVDP
	LD	BC,04201H	;interrupt
	CALL	WRTVDP
	LD	BC,0BE13H	;Line interrupt op line 190
	CALL	WRTVDP
	LD	BC,00017H
	CALL	WRTVDP
	XOR	A
	LD	(FRANR23),A
	LD	C,219
	CALL	CLEARSPR
	CALL	SPRTOVRM
	DI
	LD	HL,0D000H
	LD	BC,2000
	CALL	INITSTMUS

	LD	HL,MUSICINT	;Interruptroutine met alleen muziekroutine
	LD	(00039H),HL

	LD	A,(WORLDNR)	;als stage 6, dan niet praten
	CP	6
	JR	Z,AFTERCONT

	CALL	PRAAT
	CALL	00006H

	;spelmuziek initialiseren
AFTERCONT:
	DI
	LD	A,(WORLDNR)
	CP	6
	JR	NZ,AFTERCONT2
	LD	A,145
	LD	(043A0H),A
AFTERCONT2:
	LD	A,(JOBDATA+060H)
	LD	B,A
	CALL	INITMUSIC2
	EI

	LD	HL,CLRSCRCOMM
	CALL	IVDPCOMM
	LD	B,6
	CALL	PAUSE


	LD	HL,(JOBDATA+062H)
	CALL	NEWPLACE

	LD	HL,PALLETLEEG
	LD	DE,JOBDATA
	LD	A,3
	CALL	LETFADE

	XOR	A	;Buffer voor indrukken van vuurknoppen
	LD	(KNOPPEN),A

	DI
	LD	HL,STANDINT
	LD	(00039H),HL
	EI

HOOFDLUS2:
	XOR	A	;Buffer voor indrukken van vuurknoppen
	LD	(KNOPPEN),A
	LD	(SPUUGFLAG),A
	LD	A,219
	LD	(SPRITEATR),A
	LD	SP,(STACK)

HOOFDLUS1:
	CALL	INTERTIME
	CALL	COPYFRANC
	CALL	SYMBOLEN
	CALL	COPYBROS	;bros verwijderen als nodig
	CALL	COPYROTS
	CALL	NEWBLOK
	CALL	INITNEWV
	CALL	FRAAK	;raakt franc of dienblad
	CALL	NEWBLOK
	CALL	VIJBEZ
	CALL	NEWBLOK
	CALL	MLIFT	;beweeg lift
	CALL	SPRAAK	;check spuug
	CALL	NEWBLOK
	CALL	PAKITEM
	CALL	SPIEZEN
	CALL	DRUPPEL
	CALL	KANON
	LD	A,(DOODFLAG)
	OR	A
	JP	NZ,GADOOD
	LD	A,(KNOPPEN)
	AND	00101010B
	JP	NZ,VUURBOM
	JR	HOOFDLUS1

STANDINTB:
	LD	A,2
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	POP	AF
	EI
	RET

STANDINT:
	PUSH	AF
	LD	A,1
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	IN	A,(099H)
	AND	1
	JR	Z,STANDINTB
	DI
	LD	A,2	;Scherm uit
	OUT	(099H),A
	LD	A,129
	OUT	(099H),A
	EX	(SP),HL
	EX	(SP),HL
	LD	A,63	;Pagina 1
	OUT	(099H),A
	LD	A,130
	OUT	(099H),A
	XOR	A	;VDP(24)=0
	OUT	(099H),A
	LD	A,151
	OUT	(099H),A
	LD	A,00AH	;Sprites uit
	OUT	(099H),A
	LD	A,136
	OUT	(099H),A
	LD	A,042H	;Scherm aan
	OUT	(099H),A
	LD	A,129
	OUT	(099H),A
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

	CALL	JOYSTICK
	LD	B,A
	LD	A,(KNOPPEN)
	OR	B
	LD	(KNOPPEN),A

SPRITECALL:
	CALL	SPRTOVRM	;sprites naar het VRAM

	LD	A,31	;Pagina 0
	OUT	(099H),A
	LD	A,130
	OUT	(099H),A
	LD	A,(FRANR23)	;VDP(24)=X
	OUT	(099H),A
	LD	A,151
	OUT	(099H),A
	LD	A,(FRANR23)	;line interrupt
	ADD	A,190
	OUT	(099H),A
	LD	A,147
	OUT	(099H),A
	LD	A,008H	;Sprites aan
	OUT	(099H),A
	LD	A,136
	OUT	(099H),A
SCRONOFF:
	LD	A,042H
	OUT	(099H),A
	LD	A,129
	OUT	(099H),A

	CALL	BESTUR

	CALL	REGELFADE

	LD	HL,(POWERG)
	LD	A,H
	OR	L
	JR	NZ,NIETAF
	INC	A
	LD	(DOODFLAG),A	;power=0

NIETAF:
	LD	HL,NEGCOUNT
	INC	(HL)
	CALL	00024H
	CALL	00003H

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
	IN	A,(099H)	;Lees status register 1
	LD	A,2	;Status register 2
	OUT	(099H),A
	LD	A,143
	OUT	(099H),A
	POP	AF
	EI
	RET

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
	LD	HL,NEGCOUNT
	INC	(HL)
	CALL	REGELFADE
	CALL	00024H
	CALL	00003H
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

	;invoer: B=scroll-waarde
	;	     1 ->  4 = naar boven scrollen
	;	    -1 -> -4 = naar onder scrollen
SCROLL:
	BIT	7,B
	JR	NZ,SCROLLDO
	LD	A,(FRANFIADR+1)
	CP	06FH
	JR	C,SCROLLUP2
	LD	A,(FRANFIADR)
	AND	240
	CP	030H
	JR	C,SCROLLUP2
	LD	A,(LAPOINT)
	ADD	A,B
SCROLLUP4:
	OR	A
	JR	Z,SCROLLUP3
	CP	240
	JR	NC,SCROLLUP3
	DEC	A
	DEC	B
	JR	SCROLLUP4
SCROLLUP2:
	LD	A,(LAPOINT)
	ADD	A,B
SCROLLUP3:
	LD	(LAPOINT),A
	LD	A,(FIPOINT)
	ADD	A,B
	LD	(FIPOINT),A
	JR	SCROLLVER
SCROLLDO:
	LD	A,(FRANFIADR+1)
	CP	03FH
	JR	NZ,SCROLLDO2
	LD	A,(FIPOINT)
	ADD	A,B
SCROLLDO4:
	BIT	7,A
	JR	Z,SCROLLDO3
	INC	A
	INC	B
	JR	SCROLLDO4
SCROLLDO2:
	LD	A,(FIPOINT)
	ADD	A,B
SCROLLDO3:
	LD	(FIPOINT),A
	LD	A,(LAPOINT)
	ADD	A,B
	LD	(LAPOINT),A
SCROLLVER:
	LD	A,(FRANR23)
	ADD	A,B
	LD	(FRANR23),A
    ;	 OUT	 (099H),A
    ;	 LD	 A,151
    ;	 OUT	 (099H),A
    ;	 LD	 A,(FRANR23)
    ;	 ADD	 A,190
    ;	 OUT	 (099H),A
    ;	 LD	 A,147
    ;	 OUT	 (099H),A
	LD	A,B
	NEG
	LD	C,A
	LD	A,(ADDSPR)
	ADD	A,C
	LD	(ADDSPR),A
	RET

NEWBLOK:
	CALL	NEWBLOKUP
	JP	NEWBLOKDO

NEWBLOKUP:
	LD	A,(FIPOINT)
	BIT	7,A
	JR	NZ,NEWBLOKUPC
	CP	16
	JR	NC,NEWBLOKUPB
	LD	HL,(FRANFIADR)
	LD	(FRANFIADR2),HL
	RET
NEWBLOKUPB:
	SUB	16
	LD	(FIPOINT),A
	LD	HL,(FRANFIADR)
	LD	DE,16
	ADD	HL,DE
	LD	(FRANFIADR),HL
	LD	(FRANFIADR2),HL
	JP	VIJADRUPU
NEWBLOKUPC:
	CP	240
	CALL	C,NEWBLOKUPD
	LD	HL,(FRANFIADR)
	LD	DE,(FRANFIADR2)
	OR	A
	SBC	HL,DE
	LD	A,L
	ADD	A,16
	CP	32
	RET	NC
	EX	DE,HL
	DEC	HL
	LD	(FRANFIADR2),HL
	LD	A,L
	SLA	A
	SLA	A
	SLA	A
	SLA	A
	LD	E,A
	LD	A,(BLOKSUBY)
	LD	B,A
	LD	A,L
	AND	240
	SUB	B
	LD	D,A
	JP	PUTSCREEN
NEWBLOKUPD:
	ADD	A,16
	LD	(FIPOINT),A
	LD	HL,(FRANFIADR)
	LD	DE,-16
	ADD	HL,DE
	LD	(FRANFIADR),HL
	JP	VIJADRDOWU

NEWBLOKDO:
	LD	A,(LAPOINT)
	BIT	7,A
	JR	Z,NEWBLOKDOC
	CP	241
	JR	C,NEWBLOKDOB
	LD	HL,(FRANLAADR)
	LD	(FRANLAADR2),HL
	RET
NEWBLOKDOB:
	ADD	A,16
	LD	(LAPOINT),A
	LD	HL,(FRANLAADR)
	LD	DE,-16
	ADD	HL,DE
	LD	(FRANLAADR),HL
	LD	(FRANLAADR2),HL
	JP	VIJADRDOWD
NEWBLOKDOC:
	CP	16
	CALL	NC,NEWBLOKDOD
	LD	HL,(FRANLAADR2)
	LD	DE,(FRANLAADR)
	OR	A
	SBC	HL,DE
	LD	A,L
	ADD	A,16
	CP	32
	RET	NC
	LD	HL,(FRANLAADR2)
	PUSH	HL
	LD	A,L
	SLA	A
	SLA	A
	SLA	A
	SLA	A
	LD	E,A
	LD	A,(BLOKSUBY)
	LD	B,A
	LD	A,L
	AND	240
	SUB	B
	LD	D,A
	CALL	PUTSCREEN
	POP	HL
	INC	HL
	LD	(FRANLAADR2),HL
	RET
NEWBLOKDOD:
	SUB	16
	LD	(LAPOINT),A
	LD	HL,(FRANLAADR)
	LD	DE,16
	ADD	HL,DE
	LD	(FRANLAADR),HL
	JP	VIJADRUPD

NEWITEMS:
	LD	A,(SCANHUIDIG)
	BIT	5,A
	JR	NZ,DEKSBIJ
	BIT	6,A
	JR	NZ,SCHOENBIJ
	LD	A,(SCANHUIDIG+2)
	BIT	1,A
	JR	NZ,BOMBIJ
	BIT	2,A
	JR	NZ,SPUUGBIJ
	BIT	3,A
	JR	NZ,POWERBIJ
	RET
BOMBIJ:
	LD	A,(BOMMENG)
	ADD	A,1
	DAA
	LD	(BOMMENG),A
	RET
BOMAF:
	LD	A,(BOMMENG)
	OR	A
	RET	Z
	SUB	1
	DAA
	LD	(BOMMENG),A
	RET
DEKSBIJ:
	LD	A,(DEKSELG)
	ADD	A,040H
	DAA
	JR	NC,DEKSBIJ2
	LD	A,099H
DEKSBIJ2:
	LD	(DEKSELG),A
	RET
SCHOENBIJ:
	LD	A,(SCHOENG)
	ADD	A,040H
	DAA
	JR	NC,SCHOENBIJ2
	LD	A,099H
SCHOENBIJ2:
	LD	(SCHOENG),A
	RET
SPUUGBIJ:
	LD	B,3
	JP	SPUUGINC
POWERBIJ:
	LD	B,5
	JP	POWERINC

SCROLLSPD:
	DB	0

STACK:
	DW	0

INITBESTU2:
	LD	A,4
	LD	(DRAAGDIEN),A
	LD	HL,0B000H
	LD	(DIENADRES),HL
	LD	A,1
	LD	(DIENSTUK),A
	JR	INITBESTUB

INITBESTUR:
	DI
	LD	A,6
	LD	(DRAAGDIEN),A
	XOR	A
	LD	(DIENSTUK),A
INITBESTUB:
	LD	A,255
	LD	(REGBROST),A
	XOR	A
	LD	(ROTSSTAT),A
	LD	(FRANCSTAT),A
	LD	(FRANCRICH),A
	LD	(FRANCNR2),A
	LD	(BESTUR),A
	LD	HL,FRCOLDATA1
	CALL	FRANCOLOR
	LD	HL,TRCOLDATA1
	CALL	DIENCOLOR
	RET

	;besturingsroutines
EINDGOED:	DB	0  ;copy van DRAAGDIEN om te kijken of dienblad had
JUMPDATA1:	DB	3,3,2,3,2,3,2,2,2,2,1,2,2,1,2,1,1,0,1,1,0,255
JUMPDATA2:	DB	3,3,3,3,2,3,3,2,3,2,2,2,2,1,2,2,2,1,2,2,1,2,1
			DB	1,1,0,1,1,0,255
JUMPPOINT:	DW	0
VALDATA:	DB	1,2,2,1,2,2,2,3,2,2,3,2,3,3,3,4,3,4,4,3,4,132
VALPOINT:	DW	0      ;wijst naar valdata
BUKTELLER:	DB	0      ;zoveel ints minimaal bukken
BUK1WAIT:	DB	0      ;1 interrupt pause
VOORROTS:	DB	0      ;teller voordat rots verplaatst wordt
KONTTEL:	DB	0      ;aantal malen heen en weer gaan bij kontval
KONTFRNR:	DB	0      ;franc-standje voor de kontval (back-up)
VALTELLER:	DB	0      ;het aantal puntjes dat franc valt
HEBDEKSEL:	DB	0      ;is 1 als deksel heeft, 0=geen deksel
DIENADRES:	DW	0      ;adres van dienblad als niet gedragen wordt
DIENADD:	DB	0      ;bij x optellen(1/255) om op /16-adres te zetten
DIENYOFFS:	DB	0      ;getal van 0-15. zoveel kan nog naar beneden
DIENDATA:	DB	1,1,2,1,2,2,1,2,2,2,3,2,3,3,2,131 ;valdata dienblad
DIENPOINT:	DW	0      ;pointer naar valdata
DIENVALTEL: DB	0      ;zoveel blokken naar beneden gevallen
DRAAGDIEN:	DB	0      ;4=geen dienblad, 6=wel dienblad
DIENSTUK:	DB	0      ;=1 als dienblad stuk is.
FRANCSTAT:	DB	0      ;0=lopen,1=spring omh,2=val omlaag,4=buk,5=kontval
                       ;3=buk zonder dienblad
FRANCRICH:	DB	0      ;0=kijkt naar rechts, 1=kijkt naar links
STANDNR:	DB	0      ;waarde van 0 t/m 3 (huidige)
STANDTEL:	DB	0      ;teller, na zoveel volgende standje
YOFFSET:	DB	0      ;getal van 0-15 (low nibble van y coordinaat)
XOFFSET:	DB	0      ;getal van 0-15 (low nibble van x coordinaat)
FRANCNR:	DB	0      ;nr van FRANC aanvraag
FRANCNR2:	DB	0      ;nr van FRANC huidig
SPUUGSPD:	DB	0      ;pointer naar data die bij x moet komen
SPUUGFLAG:	DB	0      ;0=geen spuug, 1=spuug rechts, 2=spuug links
SPUUGPOINT: DW	0      ;pointer wijst naar data v. spuug
SPUUGDATA:	DB	1,1,2,1,2,1,2,2,1,2,2,2,2,3,2,2,3,2,2,2,3,131 ;y-verloop
VOETADRES:	DW	0      ;linker adres waar FRANC zijn voeten op staan
ONDERFRANC: DB	0,0    ;inhoud van adressen waar franc op staat, kan staan
			DB	0,0
			DB	0,0
			DB	0,0

BESTUR:
	NOP
	CALL	SPUGEN
	CALL	REGDEKSEL
	CALL	MOVEDIEN
	LD	A,(FRANCSTAT)
	CP	3
	JP	Z,BUKKENZD
	CP	4
	JP	Z,BUKKEN
	CP	5
	JP	Z,KONTVAL
	CP	1
	JP	Z,JUMPEN
	CP	2
	JP	Z,VALLEN
	;als naar boven, dan jump initialiseren
	EX	AF,AF'
	LD	A,(JOYRICHT)
	AND	1
	JR	Z,BESTURB
	LD	A,(JOYLETOP)
	OR	A
	JP	Z,INITJUMP
BESTURB:
	LD	A,(JOYRICHT)
	AND	2
	JP	NZ,OFBUKKEN
BESTURC:
	EX	AF,AF'
	OR	A
	JP	Z,LOPEN
	RET

REGDEKSEL:
	LD	A,(FRANCSTAT)
	CP	4
	RET	NC
	LD	HL,(DEKSELG)
	LD	A,H
	OR	L
	JR	Z,REGDEKSELB
	LD	A,(DRAAGDIEN)
	CP	6
	RET	NZ
	LD	A,1
REGDEKSELB:
	LD	B,A
	LD	A,(HEBDEKSEL)
	CP	B
	RET	Z
	LD	A,B
	LD	(HEBDEKSEL),A
	LD	HL,TRCOLDATA1
	BIT	0,B
	JP	Z,DIENCOLOR
	LD	HL,TRCOLDATA2
	JP	DIENCOLOR

	;vult FRANCNR met juiste FRANCje en zet juiste dienblad
REGSTAND:
	CALL	STDIENBL
	LD	A,(FRANCSTAT)
	OR	A
	JR	Z,STLOOP
	CP	1
	JP	Z,STSPRING
	CP	2
	JP	Z,STVAL
	RET
STLOOP:
	LD	A,(DRAAGDIEN)
	CP	6
	LD	B,112
	JR	NZ,STLOOP2
	LD	B,120
STLOOP2:
	LD	A,(FRANCRICH)
	SLA	A
	SLA	A
	ADD	A,B
	LD	B,A
	LD	A,(STANDNR)
	ADD	A,B
	LD	(FRANCNR),A
	RET
STSPRING:
	LD	A,(DRAAGDIEN)
	CP	6
	LD	B,128
	JR	NZ,STSPRING2
	LD	B,132
STSPRING2:
	LD	A,(FRANCRICH)
	SLA	A
	ADD	A,B
	LD	(FRANCNR),A
	RET
STVAL:
	LD	A,(DRAAGDIEN)
	CP	6
	LD	B,129
	JR	NZ,STVAL2
	LD	B,133
STVAL2:
	LD	A,(FRANCRICH)
	SLA	A
	ADD	A,B
	LD	(FRANCNR),A
	RET
STDIENBL:
	LD	A,(FRANCSTAT)
	CP	4
	JR	Z,STDIENBLT
	LD	A,(DRAAGDIEN)
	CP	6
	JP	NZ,BUKKEN4
STDIENBLT:
	LD	A,(FRANCKNIP)
	AND	4
	JR	Z,STDIENBL4
STDIENBLY:
	LD	A,160
	LD	(SPRITEATR+6),A
	LD	(SPRITEATR+10),A
	RET
STDIENBL4:
	LD	A,(FRANCSTAT)
	CP	4
	JR	NZ,STDIENBL5
	LD	A,(SPRITEATR+7)
	LD	(SPRITEATR+6),A
	LD	A,(SPRITEATR+11)
	LD	(SPRITEATR+10),A
	RET
STDIENBL5:
	LD	B,0
	LD	A,(HEBDEKSEL)
	OR	A
	JR	Z,STDIENBL2
	LD	B,32
STDIENBL2:
	LD	A,(FRANCRICH)
	ADD	A,A
	ADD	A,A
	ADD	A,A
	ADD	A,A
	ADD	A,B
	LD	B,A
	LD	A,(FRANCSTAT)
	CP	1
	LD	A,0
	JR	NC,STDIENBL3
	LD	A,(STANDNR)
	AND	1
	ADD	A,A
	ADD	A,A
	ADD	A,A
STDIENBL3:
	ADD	A,B
	LD	(SPRITEATR+6),A
	ADD	A,4
	LD	(SPRITEATR+10),A
	RET

	;past waarde STANDNR aan, om FRANC te animeren
AFWISSEL:
	LD	A,(JOYRICHT)
	AND	00001100B
	JR	Z,AFWISSELB
	CP	12
	JR	Z,AFWISSELB
	LD	HL,STANDTEL
	DEC	(HL)
	RET	NZ
	LD	(HL),6
	LD	A,(STANDNR)
	INC	A
	AND	3
	LD	(STANDNR),A
	RET
AFWISSELB:
	LD	A,1
	LD	(STANDNR),A
	LD	(STANDTEL),A
	RET

	;regelt het vallen in zijn geheel
VALLEN:
	LD	HL,(VALPOINT)
	LD	A,(HL)
	BIT	7,A
	JP	NZ,VALLEN2
	INC	HL
	LD	(VALPOINT),HL
VALLEN2:
	AND	127
	LD	C,A
	LD	A,(VALTELLER)
	CP	255
	JR	Z,VALLEN3
	INC	A
	LD	(VALTELLER),A
VALLEN3:
	CALL	VERTFRANC	;franc naar onderen bewegen
	CALL	OPADRESS
	CALL	LOSLAAT
	CALL	MOVEHORI
	CALL	OFLOPEN
	JP	REGSTAND

	;regelt het lopen in zijn geheel
LOPEN:
	CALL	AFWISSEL
	CALL	OPADRESS
	CALL	LOSLAAT
	CALL	TOMIDDEN
	CALL	OFVALLEN
	CALL	REGBROS
	CALL	MOVEHORI
	JP	REGSTAND

	;regelt het springen in zijn geheel
JUMPEN:
	LD	A,(JOYRICHT)
	AND	1
	JP	Z,INITVAL2
	LD	HL,(JUMPPOINT)
	LD	A,(HL)
	CP	255
	JP	Z,INITVAL2
	INC	HL
	LD	(JUMPPOINT),HL
	LD	C,A
	PUSH	BC
	CALL	OPADRESS
	CALL	LOSLAAT
	;hoeveel puntjes kan FRANC naar boven springen?
	LD	A,(XOFFSET)
	CP	14
	JR	NC,OFJUMPENB
	LD	A,(ONDERFRANC+2)
	AND	11100000B
	CP	128
	JR	Z,OFJUMPENC	;kop door blokje, springen beperkt
OFJUMPENB:
	LD	A,(XOFFSET)
	CP	3
	JP	C,OFJUMPEND	;kan springen zonder voorwaarden
	LD	A,(ONDERFRANC+3)
	AND	11100000B
	CP	128
	JP	Z,OFJUMPENC
OFJUMPEND:
	LD	A,8	;maximaal aantal puntjes springen
	JR	OFJUMPENE
OFJUMPENC:
	LD	A,(YOFFSET)
	SUB	8
	CP	9
	JR	C,OFJUMPENE
	XOR	A
OFJUMPENE:
	POP	BC
	CP	C
	JR	NC,OFJUMPENF
	LD	C,A
OFJUMPENF:
	LD	A,C
	NEG
	LD	C,A
	CALL	VERTFRANC
	CALL	MOVEHORI
	JP	REGSTAND

REGBROS:
	LD	HL,(VOETADRES)
	LD	DE,1
	LD	A,(XOFFSET)
	XOR	15
	LD	B,A
	CP	8
	JR	NC,REGBROSB
	INC	HL
	LD	DE,-1
	LD	A,(XOFFSET)
	LD	B,A
REGBROSB:
	LD	A,(HL)
	CP	132
	JR	NZ,REGBROSE
REGBROSF:
	LD	DE,(REGBROSAD)
	LD	A,D
	CP	H
	JR	NZ,REGBROSD
	LD	A,E
	CP	L
	JR	NZ,REGBROSD
	LD	A,(REGBROST)
	OR	A
	RET	Z
	DEC	A
	LD	(REGBROST),A
	RET
REGBROSD:
	LD	(REGBROSAD),HL
	LD	A,9
	LD	(REGBROST),A
	RET
REGBROSE:
	ADD	HL,DE
	AND	11100000B
	CP	128
	LD	C,8
	JR	Z,REGBROSE2
	LD	C,2
REGBROSE2:
	LD	A,B
	XOR	15
	CP	C
	JR	C,REGBROSC
	LD	A,(HL)
	CP	132
	JR	Z,REGBROSF
REGBROSC:
	LD	A,(REGBROST)
	OR	A
	RET	Z
	LD	A,255
	LD	(REGBROST),A
	LD	(REGBROSAD+1),A
	RET
REGBROSAD:	DW	0	;adres van BROS
REGBROST:	DB	7	;als '0' dan bros wissen

	;geeft RETURN als FRANC niet moet vallen, anders init valroutine
OFVALLEN:
	LD	A,(LIFTDATA+8)
	AND	1
	RET	NZ
	LD	A,(LIFTDATA+17)
	AND	1
	RET	NZ
	LD	A,(XOFFSET)
	CP	14
	JR	NC,OFVALLENB
	LD	A,(ONDERFRANC+6)
	AND	11100000B
	CP	128
	RET	Z
OFVALLENB:
	LD	A,(XOFFSET)
	CP	3
	JP	C,INITVAL
	LD	A,(ONDERFRANC+7)
	AND	11100000B
	CP	128
	RET	Z
	;nu moet FRANC vallen
INITVAL:
	POP	AF
INITVAL2:
	LD	A,2
	LD	(FRANCSTAT),A
	LD	HL,VALDATA
	LD	(VALPOINT),HL
	XOR	A
	LD	(VALTELLER),A
	JP	REGSTAND

	;initialiseren van JUMP functie
INITJUMP:
	LD	A,1
	LD	(FRANCSTAT),A
	LD	(JOYLETOP),A
	LD	A,(SCHOENG)
	LD	HL,JUMPDATA1
	OR	A
	JR	Z,INITJUMPB
	LD	HL,JUMPDATA2
INITJUMPB:
	LD	(JUMPPOINT),HL
	LD	HL,PSGEFF3
	CALL	0001BH
	CALL	REGBROS
	LD	A,(REGBROST)
	CP	10
	JP	NC,REGSTAND
	XOR	A
	LD	(REGBROST),A
	JP	REGSTAND

	;geeft RETURN als FRANC niet moet lopen, anders init looproutine
OFLOPEN:
	LD	A,(LIFTDATA+8)
	AND	1
	JR	NZ,INITLOOPC
	LD	A,(LIFTDATA+17)
	AND	1
	JR	NZ,INITLOOPC
	LD	A,(XOFFSET)
	CP	14
	JR	NC,OFLOPENB
	LD	A,(ONDERFRANC+6)
	AND	11100000B
	CP	128
	JP	Z,INITLOOP
OFLOPENB:
	LD	A,(XOFFSET)
	CP	3
	RET	C
	LD	A,(ONDERFRANC+7)
	AND	11100000B
	CP	128
	RET	NZ
	;nu moet FRANC lopen
INITLOOP:
	POP	AF
	LD	A,(VALTELLER)
	CP	56
	JR	C,INITLOOPB
	;kontval data instellen
	SUB	56
	SRL	A
	SRL	A
	ADD	A,4
	LD	B,A
	CALL	POWERDEC
	XOR	A
	LD	(KONTTEL),A
	LD	HL,PSGEFF29
	CALL	0001BH
	LD	A,5
INITLOOPF:
	LD	(FRANCSTAT),A
	CALL	OPPLATEAU
	JP	REGSTAND
INITLOOPC:
	POP	AF
	XOR	A
	LD	(FRANCSTAT),A
	JP	REGSTAND
INITLOOPB:
	XOR	A
	JR	INITLOOPF
	;regelt het bewegen in horizontale richting
MOVEHORI:
	LD	A,(JOYRICHT)
	AND	12
	JP	Z,ROTSNOTEL
	CP	12
	JP	Z,ROTSNOTEL
	CP	8
	JP	Z,MOVER
MOVEL:
	LD	A,1
	LD	(FRANCRICH),A
	LD	A,(XOFFSET)
	CP	14
	JR	Z,MOVEL4
	LD	C,255
	CP	10
	JP	NZ,HORIFRANC
	LD	HL,(VOETADRES)
	LD	DE,-16
	ADD	HL,DE
	CALL	DIENHORI
	LD	C,255
	JP	HORIFRANC
MOVEL4:
	CALL	MOVEBEREIK
	LD	C,0
MOVEL2:
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	NZ,MOVEL3
	INC	C
MOVEL3:
	INC	HL
	INC	HL
	DJNZ	MOVEL2
	LD	A,C
	OR	A
	LD	C,255
	JP	Z,HORIFRANC
	CP	2
	RET	NC
	LD	A,(FRANCSTAT)
	OR	A
	RET	NZ
	LD	HL,(VOETADRES)
	LD	DE,-16
	ADD	HL,DE
	LD	A,(HL)
	CP	153
	RET	NZ
	DEC	HL
	LD	A,(HL)
	AND	11111100B
	JP	Z,ROTSLINKS
	RET

MOVER:
	XOR	A
	LD	(FRANCRICH),A
	LD	A,(XOFFSET)
	CP	2
	JR	Z,MOVER4
	LD	C,1
	CP	6
	JP	NZ,HORIFRANC
	LD	HL,(VOETADRES)
	LD	DE,-15
	ADD	HL,DE
	CALL	DIENHORI
	LD	C,1
	JP	HORIFRANC
MOVER4:
	CALL	MOVEBEREIK
	LD	C,0
	INC	HL
MOVER2:
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	NZ,MOVER3
	INC	C
MOVER3:
	INC	HL
	INC	HL
	DJNZ	MOVER2
	LD	A,C
	OR	A
	LD	C,1
	JP	Z,HORIFRANC
	CP	2
	RET	NC
	LD	A,(FRANCSTAT)
	OR	A
	RET	NZ
	LD	HL,(VOETADRES)
	LD	DE,-15
	ADD	HL,DE
	LD	A,(HL)
	CP	153
	RET	NZ
	INC	HL
	LD	A,(HL)
	AND	11111100B
	JP	Z,ROTSRECHTS
	RET

	;uitvoer: HL=bovenste adres om te checken. B=aantal adressen
MOVEBEREIK:
	LD	A,(YOFFSET)
	OR	A
	JR	Z,MOVEBEREI2
	CP	8
	JR	NC,MOVEBEREI3
	LD	HL,ONDERFRANC+2
	LD	B,3
	RET
MOVEBEREI3:
	LD	HL,ONDERFRANC+4
	LD	B,2
	RET
MOVEBEREI2:
	LD	HL,ONDERFRANC+2
	LD	B,2
	RET

	;wist YOFFSET en zet sprites netjes op plateau-tje
OPPLATEAU:
	LD	A,(YOFFSET)
	LD	C,A
	XOR	A
	LD	(YOFFSET),A
	LD	HL,SPRITEATR+24
	LD	A,(DRAAGDIEN)
	LD	DE,-4
	LD	B,A
OPPLATEAU2:
	LD	A,(HL)
	SUB	C
	LD	(HL),A
	ADD	HL,DE
	DJNZ	OPPLATEAU2
	RET

	;beweegt franc horizontaal. C=optelbyte
HORIFRANC:
	LD	HL,SPRITEATR+25
HORIFRANC3:
	LD	A,(DRAAGDIEN)
	LD	B,A
	LD	DE,-4
HORIFRANC2:
	LD	A,(HL)
	ADD	A,C
	LD	(HL),A
	ADD	HL,DE
	DJNZ	HORIFRANC2
ROTSNOTEL:
	XOR	A
	LD	(VOORROTS),A
	RET

	;beweegt franc verticaal. C=optelbyte
VERTFRANC:
	LD	HL,SPRITEATR+24
	CALL	HORIFRANC3
	LD	B,C
	BIT	7,C
	JR	Z,VERTFRANC2
	LD	A,(SPRITEATR+12)
	CP	32
	JP	C,SCROLL
	RET
VERTFRANC2:
	LD	A,(SPRITEATR+20)
	CP	112
	JP	NC,SCROLL
	RET

	;als FRANC stilstaat moet hij ongeveer in midden komen
TOMIDDEN:
	LD	A,(LIFTDATA+8)
	AND	1
	RET	NZ
	LD	A,(LIFTDATA+17)
	AND	1
	RET	NZ
	LD	A,(SPRITEATR+12)
	LD	B,255
	CP	64
	JP	C,SCROLL
	LD	B,1
	CP	89
	RET	C
	JP	SCROLL
	;haalt een achttal bytes waar FRANC op kan staan
	;berekent tevens XOFFSET en YOFFSET
OPADRESS:
	LD	A,(SPRITEATR+20)
	SUB	16
	LD	IX,ADDSPR
	ADD	A,(IX+0)
	ADD	A,(IX+1)
	LD	C,A
	AND	240
         ;	ADD	A,(IX+2)
	LD	E,A
	LD	A,C
	AND	15
	LD	(YOFFSET),A
	LD	D,0
	LD	HL,(FRANFIADR)
	ADD	HL,DE
	;HL=adres boven franc (zonder x)
	LD	A,(SPRITEATR+21)
	LD	B,A
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	OR	L
	LD	L,A
	LD	A,B
	AND	15
	LD	(XOFFSET),A
	LD	DE,ONDERFRANC
	LD	B,4
OPADRES2:
	PUSH	BC
	LD	BC,2
	LDIR
	LD	C,14
	ADD	HL,BC
	POP	BC
	DJNZ	OPADRES2
	LD	BC,-16
	ADD	HL,BC
	LD	(VOETADRES),HL
	RET

KONTVAL:
	LD	A,(FRANCNR)
	CP	140
	JR	NC,KONTVAL2
	;kontval initialiseren
	LD	(KONTFRNR),A
	LD	HL,FRCOLDATA3
	CALL	FRANCOLOR
	LD	B,140
	LD	A,(DRAAGDIEN)
	CP	6
	JR	NZ,KONTVALB
	LD	A,(HEBDEKSEL)
	LD	HL,TRCOLDATA5
	LD	BC,08D70H
	OR	A
	JR	Z,KONTVALC
	LD	HL,TRCOLDATA6
	LD	BC,08E78H
KONTVALC:
	PUSH	BC
	CALL	DIENCOLOR
	POP	BC
	LD	A,C
	LD	(SPRITEATR+6),A
	ADD	A,4
	LD	(SPRITEATR+10),A
KONTVALB:
	LD	A,B
	LD	(FRANCNR),A
	RET
KONTVAL2:
	CALL	TOMIDDEN
	LD	HL,KONTTEL
	INC	(HL)
	LD	A,(HL)
	CP	99
	JR	Z,KONTVALSTP
	AND	7
	LD	C,1
	CP	3
	JP	Z,VERTFRANC
	LD	C,255
	CP	7
	JP	Z,VERTFRANC
	RET
	;stoppen met kontval
KONTVALSTP:
	XOR	A
	LD	(FRANCSTAT),A
	LD	HL,FRCOLDATA1
	CALL	FRANCOLOR
	LD	A,(KONTFRNR)
	LD	(FRANCNR),A
	LD	A,(DRAAGDIEN)
	CP	6
	RET	NZ
KONTVALST2:
	CALL	STDIENBL	;juiste standje van dienblad terug
	LD	HL,TRCOLDATA1
	LD	A,(HEBDEKSEL)
	OR	A
	JP	Z,DIENCOLOR
	LD	HL,TRCOLDATA2
	JP	DIENCOLOR

ROTSLINKS:
	LD	(ROTSDESTI),HL
	LD	E,L
	INC	HL
	LD	A,-2
	JR	ROTSINIT

ROTSRECHTS:
	LD	(ROTSDESTI),HL
	LD	E,L
	DEC	HL
	LD	A,2
ROTSINIT:
	LD	(ROTSSOURC),HL
	LD	(ROTSOPTEL),A
	LD	A,(VOORROTS)
	INC	A
	LD	(VOORROTS),A
	CP	12
	RET	NZ
	PUSH	HL
	LD	L,E
	CALL	DIENHORI
	POP	HL
	XOR	A
	LD	(VOORROTS),A
	INC	A
	LD	(ROTSSTAT),A
	LD	A,L
	SLA	A
	SLA	A
	SLA	A
	SLA	A
	LD	(SPRITEATR+105),A
	LD	(SPRITEATR+109),A
	LD	A,(BLOKSUBY)
	LD	B,A
	LD	A,L
	AND	240
	SUB	B
	LD	BC,(FRANR23)
	SUB	C
	LD	(SPRITEATR+104),A
	LD	(SPRITEATR+108),A
	XOR	A
	LD	(ROTSTEL),A
	RET

ROTSDESTI:	DW	0	;naar adres
ROTSSOURC:	DW	0	;van adres
ROTSOPTEL:	DB	0	;bij x optellen
ROTSSTAT:	DB	0	;0=niets,1=links/rechts,2=onder
ROTSTEL:	DB	0	;teller

SPUGEN:
	LD	A,(SPUUGFLAG)
	OR	A
	RET	Z
	LD	A,(SPRITEATR)
	ADD	A,17
	LD	IX,ADDSPR
	ADD	A,(IX+0)
	ADD	A,(IX+1)
	AND	240
	;	ADD	A,(IX+2)
	LD	E,A
	LD	D,0
	LD	HL,(FRANFIADR)
	ADD	HL,DE
	;HL=adres boven franc (zonder x)
	LD	A,(SPRITEATR+1)
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	OR	L
	LD	L,A
	LD	A,(HL)
	CP	128
	JR	NC,SPUGEND
	LD	A,(SPUUGFLAG)
	LD	B,A
	LD	A,(SPUUGSPD)
	BIT	1,B
	JR	Z,SPUGENB
	NEG
SPUGENB:
	LD	B,A
	LD	A,(SPRITEATR+1)
	ADD	A,B
	LD	(SPRITEATR+1),A
	LD	HL,(SPUUGPOINT)
	LD	A,(HL)
	BIT	7,A
	JR	NZ,SPUGENC
	INC	HL
	LD	(SPUUGPOINT),HL
SPUGENC:
	AND	127
	LD	B,A
	LD	A,(SPRITEATR)
	ADD	A,B
	LD	(SPRITEATR),A
	CP	192
	RET	C
SPUGEND:
	LD	A,219
	LD	(SPRITEATR),A
	XOR	A
	LD	(SPUUGFLAG),A
	RET

OFBUKKEN:
	CALL	OPADRESS
	LD	A,(LIFTDATA+8)
	AND	1
	RET	NZ
	LD	A,(LIFTDATA+17)
	AND	1
	RET	NZ
	LD	A,(FRANCNR)
	LD	(KONTFRNR),A
	LD	HL,(VOETADRES)
	LD	DE,1
	LD	A,(XOFFSET)
	CP	8
	JR	C,OFBUKKENB
	INC	HL
	LD	DE,-1
OFBUKKENB:
	CALL	OFBUKKENC
	JR	C,OFBUKKENB2
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,OFBUKKEND
OFBUKKENB2:
	ADD	HL,DE
	CALL	OFBUKKENC
	RET	C
	LD	A,(HL)
	AND	11100000B
	CP	128
	RET	NZ
OFBUKKEND:
	LD	DE,0100AH
	LD	BC,08840H
	LD	A,(FRANCRICH)
	OR	A
	JR	Z,OFBUKKENE
	LD	DE,0F0F6H
	LD	BC,08A48H
OFBUKKENE:
	LD	A,L
	SLA	A
	SLA	A
	SLA	A
	SLA	A
	LD	(SPRITEATR+21),A
	LD	(SPRITEATR+25),A
	LD	A,4
	LD	(FRANCSTAT),A
	LD	A,15
	LD	(BUKTELLER),A
	XOR	A
	LD	(BUK1WAIT),A
	LD	HL,(BLADADRES)
	LD	A,(DRAAGDIEN)
	CP	6
	JR	Z,OFBUKKENF
	;vergelijk adres waar dienblad op staat
	LD	A,(DIENADRES)
	CP	L
	JR	NZ,OFBUKKENG
	LD	A,(DIENADRES+1)
	CP	H
	JR	NZ,OFBUKKENG
	;droeg geen dienblad, pakt er een.
	LD	A,(DIENSTUK)
	OR	A
	JR	NZ,OFBUKKENG
	CALL	OFBUKINCL
	LD	A,6
	LD	(DRAAGDIEN),A
	RET
	;draagt dienblad en legt neer
OFBUKKENF:
	LD	(DIENADRES),HL
	CALL	INITDIENV2
	CALL	OFBUKINCL
	RET
	;draagt geen dienblad, bukt zomaar
OFBUKKENG
	CALL	OFBUKEXCL
	LD	A,3
	LD	(FRANCSTAT),A
	RET
	;draagt dienblad
OFBUKINCL:
	LD	A,(SPRITEATR+21)
	ADD	A,E
	LD	(SPRITEATR+17),A
	LD	(SPRITEATR+13),A
	LD	A,(SPRITEATR+21)
	ADD	A,D
	LD	(SPRITEATR+5),A
	LD	(SPRITEATR+9),A
	LD	A,(SPRITEATR+20)
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
	LD	A,B
	INC	A
	LD	(FRANCNR),A
	LD	A,(HEBDEKSEL)
	OR	A
	LD	A,C
	JR	Z,OFBUKINCL2
	ADD	A,16
	LD	(SPRITEATR+6),A
	LD	(SPRITEATR+7),A
	ADD	A,4
	LD	(SPRITEATR+10),A
	LD	(SPRITEATR+11),A
	LD	HL,FRCOLDATA2
	CALL	FRANCOLOR
	LD	HL,TRCOLDATA4
	JP	DIENCOLOR
OFBUKINCL2:
	LD	(SPRITEATR+6),A
	LD	(SPRITEATR+7),A
	ADD	A,4
	LD	(SPRITEATR+10),A
	LD	(SPRITEATR+11),A
	LD	HL,FRCOLDATA2
	CALL	FRANCOLOR
	LD	HL,TRCOLDATA3
	JP	DIENCOLOR

	;draagt geen dienblad
OFBUKEXCL:
	LD	A,(SPRITEATR+21)
	ADD	A,D
	LD	(SPRITEATR+17),A
	LD	(SPRITEATR+13),A
	LD	A,(SPRITEATR+12)
	ADD	A,8
	LD	(SPRITEATR+12),A
	LD	(SPRITEATR+16),A
	LD	A,B
	LD	(FRANCNR),A
	LD	HL,FRCOLDATA2
	JP	FRANCOLOR

	;kijkt of kan bukken. c=1 als niet kan
OFBUKKENC:
	PUSH	HL
	LD	BC,-16
	ADD	HL,BC
	LD	A,(FRANCRICH)
	OR	A
	LD	BC,17
	JR	Z,OFBUKKENC2
	LD	BC,15
OFBUKKENC2:
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,OFBUKKENC3
	CP	192
	JR	NC,OFBUKKENC3
	PUSH	BC
	LD	BC,-16
	ADD	HL,BC
	POP	BC
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,OFBUKKENC3
	CP	192
	JR	NC,OFBUKKENC3
	ADD	HL,BC
	LD	(BLADADRES),HL
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,OFBUKKENC3
	CP	192
	JR	NC,OFBUKKENC3
	LD	BC,-16
	ADD	HL,BC
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,OFBUKKENC2
	CP	192
	JR	NC,OFBUKKENC3
	POP	HL
	OR	A
	RET
OFBUKKENC3:
	POP	HL
	SCF
	RET
BLADADRES:	DW	0

BUKKENZD:
	CALL	STDIENBL	;bukken zonder dienblad
BUKKEN:
	LD	A,(BUK1WAIT)	;bukken met dienblad
	OR	A
	JP	NZ,BUKKEN2
	LD	A,(BUKTELLER)
	OR	A
	JR	Z,BUKKENB
	DEC	A
	LD	(BUKTELLER),A
	JP	STDIENBL
BUKKENB:
	LD	A,(JOYRICHT)
	AND	2
	JP	NZ,STDIENBL
	LD	A,(FRANCSTAT)
	CP	3
	JR	Z,BUKKENC
	LD	A,(DRAAGDIEN)
	CP	6
	JR	Z,BUKKENC
	LD	A,(SPRITEATR+4)
	INC	A
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
BUKKENC:
	LD	A,(SPRITEATR+21)
	LD	(SPRITEATR+17),A
	LD	(SPRITEATR+13),A
	LD	A,(SPRITEATR+20)
	SUB	16
	LD	(SPRITEATR+16),A
	LD	(SPRITEATR+12),A
	LD	A,1
	LD	(BUK1WAIT),A
	LD	A,(DRAAGDIEN)
	CP	6
	JR	NZ,BUKKEN4
	LD	A,(SPRITEATR+17)
	LD	(SPRITEATR+5),A
	LD	(SPRITEATR+9),A
	LD	A,(SPRITEATR+12)
	SUB	16
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
	JP	STDIENBL
BUKKEN4:
	LD	B,128
	LD	A,(DIENSTUK)
	OR	A
	JR	NZ,BUKKEN5
	LD	A,(HEBDEKSEL)
	LD	B,96
	OR	A
	JR	Z,BUKKEN5
	LD	B,104
BUKKEN5:
	LD	A,B
	LD	(SPRITEATR+6),A
	LD	(SPRITEATR+7),A
	ADD	A,4
	LD	(SPRITEATR+10),A
	LD	(SPRITEATR+11),A
	RET
BUKKEN2:
	LD	HL,FRCOLDATA1
	CALL	FRANCOLOR
	LD	A,(KONTFRNR)
	LD	(FRANCNR),A
	XOR	A	;status0=lopen
	LD	(FRANCSTAT),A
	CALL	STDIENBL
	LD	A,(DIENSTUK)
	OR	A
	RET	NZ
	LD	A,(HEBDEKSEL)
	OR	A
	LD	HL,TRCOLDATA1
	JP	Z,DIENCOLOR
	LD	HL,TRCOLDATA2
	JP	DIENCOLOR

	;initialiseert vallen dienblad
INITDIENV2:
	LD	A,4
	LD	(DRAAGDIEN),A
	LD	HL,DIENDATA
	LD	(DIENPOINT),HL
	XOR	A
	LD	(DIENYOFFS),A
	LD	(DIENVALTEL),A
	RET

MOVEDIEN:
	NOP
	LD	A,(DRAAGDIEN)
	CP	6
	RET	Z
	LD	A,(FRANCSTAT)
	CP	4
	RET	Z
	CALL	BLADDOWN
	LD	DE,(FRANFIADR)
	LD	HL,(DIENADRES)
	LD	A,H
	CP	D
	JR	C,MOVEDIEN3
	JR	NZ,MOVEDIEN2
	LD	A,L
	CP	E
	JR	C,MOVEDIEN3
MOVEDIEN2:
	LD	DE,(FRANLAADR)
	LD	A,H
	CP	D
	JR	C,MOVEDIEN4
	JR	NZ,MOVEDIEN3
	LD	A,L
	CP	E
	JR	C,MOVEDIEN4
MOVEDIEN3:
	LD	A,219
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
	RET
	;dienblad is op scherm
MOVEDIEN4:
	LD	A,(BLOKSUBY)
	LD	B,A
	LD	A,L
	AND	240
	SUB	B
	LD	B,A
	LD	A,(DIENYOFFS)
	ADD	A,B
	LD	BC,(FRANR23)
	SUB	C
	SUB	B
	INC	A
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
	RET

	;dienblad naar beneden als kan
BLADDOWN:
	LD	A,(SPRITEATR+5)
	LD	B,A
	AND	15
	JR	Z,BLADDOWNF
	LD	A,(DIENADD)
	BIT	0,A
	JR	NZ,BLADDOWNF2
	ADD	A,B
	LD	(SPRITEATR+5),A
	LD	(SPRITEATR+9),A
	RET
BLADDOWNF2:
	ADD	A,B
	LD	(SPRITEATR+5),A
	LD	(SPRITEATR+9),A
	LD	HL,BLADDOWNX
	INC	(HL)
	BIT	0,(HL)
	RET	Z
BLADDOWNF:
	LD	HL,(DIENPOINT)
	LD	A,(HL)
	BIT	7,A
	JR	NZ,BLADDOWNB
	INC	HL
	LD	(DIENPOINT),HL
BLADDOWNB:
	AND	127
	LD	B,A
	LD	A,(DIENYOFFS)
	ADD	A,B
	LD	B,A
	LD	HL,(DIENADRES)
	LD	DE,16
BLADDOWNE:
	ADD	HL,DE
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,BLADDOWNC
	LD	A,B
	CP	16
	JR	C,BLADDOWND
	LD	(DIENADRES),HL
	SUB	16
	LD	B,A
	LD	A,(DIENVALTEL)
	INC	A
	LD	(DIENVALTEL),A
	JR	BLADDOWNE
	;voelt grond onder dienblad
BLADDOWNC:
	LD	A,(HEBDEKSEL)
	OR	A
	JR	NZ,BLADDOWNC2
	LD	A,(DIENVALTEL)
	CP	6
	JR	C,BLADDOWNC2
	CALL	SETSTUK
BLADDOWNC2:
	XOR	A
	LD	(DIENYOFFS),A
	LD	(DIENVALTEL),A
	LD	HL,DIENDATA
	LD	(DIENPOINT),HL
	RET
BLADDOWND:
	LD	A,B
	LD	(DIENYOFFS),A
	RET
BLADDOWNX:
	DB	0

	;routine die dienblad naar links/rechts beweegt
	;invoer: HL=adres waar rotsblok/franc naar toe wil
	;z=0 als gelukt
DIENHORI:
	LD	A,(DRAAGDIEN)
	CP	4
	RET	NZ
	LD	A,(FRANCSTAT)
	OR	A
	RET	NZ
	LD	A,(DIENSTUK)
DIENHORI3:
	OR	A
	RET	NZ
	LD	A,(DIENYOFFS)
	OR	A
	RET	NZ
	LD	DE,(DIENADRES)
	OR	A
	SBC	HL,DE
	RET	NZ
	LD	DE,1
	LD	A,(FRANCRICH)
	OR	A
	JR	Z,DIENHORI2
	LD	DE,-1
DIENHORI2:
	LD	HL,(DIENADRES)
	ADD	HL,DE
	LD	A,(HL)
	AND	11100000B
	CP	128
	JR	Z,DIENHORI3
	LD	A,L
	AND	15
	CP	15
	JR	Z,DIENHORI3
	INC	A
	CP	1
	JR	Z,DIENHORI3
	LD	(DIENADRES),HL
	SLA	E
	LD	A,(SPRITEATR+5)
	ADD	A,E
	LD	(SPRITEATR+5),A
	LD	(SPRITEATR+9),A
	LD	A,E
	LD	(DIENADD),A
	XOR	A
	RET

	;stelt kapot dienblad in
SETSTUK:
	LD	A,(DIENSTUK)
	OR	A
	RET	NZ
	LD	A,(CHEATADR)
	OR	A
	RET	NZ
	LD	HL,PSGEFF1
	CALL	0001BH
	XOR	A
	LD	(DIENVALTEL),A
	LD	A,1
	LD	(DIENSTUK),A
	LD	A,128
	LD	(SPRITEATR+6),A
	ADD	A,4
	LD	(SPRITEATR+10),A
	LD	HL,TRCOLDATA7
	JP	DIENCOLOR

LOSLAAT:
	NOP
	LD	A,(DRAAGDIEN)
	CP	6
	RET	NZ
	LD	A,(FRANCSTAT)
	CP	3
	RET	NC
	LD	HL,ONDERFRANC
	LD	A,(YOFFSET)
	CP	8
	JR	C,LOSLAATB
	LD	HL,ONDERFRANC+2
LOSLAATB:
	LD	A,(XOFFSET)
	XOR	15
	INC	A
	CALL	LOSLAATC
	INC	HL
	LD	A,(XOFFSET)
	CALL	LOSLAATC
	RET
LOSLAATC:
	CP	7
	RET	C
	LD	A,(HL)
	AND	11100000B
	CP	128
	RET	NZ
	POP	AF
INITDIENV:
	CALL	INITDIENV2
	CALL	OPADRESS
	LD	A,(YOFFSET)
	ADD	A,8
	LD	B,A
	AND	15
	LD	(DIENYOFFS),A
	LD	HL,(VOETADRES)
	LD	DE,-48
	BIT	4,B
	JR	Z,INITDIENVB
	LD	E,-32
INITDIENVB:
	ADD	HL,DE
	LD	B,255
	LD	A,(XOFFSET)
	OR	A
	JR	Z,INITDIENV4
	LD	A,(FRANCRICH)
	OR	A
	JR	Z,INITDIENV4
	LD	B,1
	INC	HL
INITDIENV4:
	LD	A,B
	LD	(DIENADD),A
	LD	(DIENADRES),HL
	LD	HL,PSGEFF6
	CALL	0001BH
	LD	A,(HEBDEKSEL)
	LD	HL,TRCOLDATA1
	BIT	0,A
	JP	Z,DIENCOLOR
	LD	HL,TRCOLDATA2
	JP	DIENCOLOR

	;kijkt of op item staat of op een deur.
PAKITEM:
	LD	HL,(VOETADRES)
	LD	BC,(XOFFSET)
	LD	B,3
	LD	A,(YOFFSET)
	CP	4
	JR	NC,PAKITEMB
	LD	DE,-16
	ADD	HL,DE
	DEC	B
PAKITEMB:
	CP	12
	JR	C,PAKITEMC
	DEC	B
PAKITEMC:
	CALL	PAKITEMD
	INC	HL
	CALL	PAKITEME
	LD	DE,-17
	ADD	HL,DE
	DJNZ	PAKITEMC
	RET
PAKITEMD:
	LD	A,C
	CP	12
	RET	NC
	LD	A,(HL)
	CP	192
	JP	NC,DOOR
	AND	11100000B
	CP	32
	JP	Z,ITEM
	RET
PAKITEME:
	LD	A,C
	CP	4
	RET	C
	LD	A,(HL)
	CP	192
	JP	NC,DOOR
	AND	11100000B
	CP	32
	JP	Z,ITEM
	RET

	;staat op item!
ITEM:
	POP	AF
	LD	A,(HL)
	PUSH	AF
	CALL	SETACHTER
	POP	AF
	AND	00011111B
	SRL	A
	SRL	A
	CP	1
	JR	Z,ANTIGIF
	CP	2
	JR	Z,HAWATER
	CP	3
	JR	Z,HABOM
	CP	4
	JR	Z,HAMBURGER
	CP	5
	JR	Z,SNOEPJE
	CP	6
	JR	Z,HADEKSEL
	CP	7
	JR	Z,HASCHOEN
	RET

ANTIGIF:
	XOR	A
	LD	(VERGIF),A
	LD	HL,PSGEFF2
	CALL	0001BH
	RET

HAWATER:
	LD	B,8
	CALL	SPUUGINC
	LD	HL,PSGEFF11
	CALL	0001BH
	RET

HABOM:
	LD	A,(BOMMENG)
	ADD	A,1
	DAA
	LD	(BOMMENG),A
	LD	HL,PSGEFF2
	CALL	0001BH
	RET

HAMBURGER:
	LD	B,10
	CALL	POWERINC
	LD	HL,PSGEFF11
	CALL	0001BH
	RET

SNOEPJE:
	LD	B,1
	CALL	POWERINC
	LD	HL,PSGEFF11
	CALL	0001BH
	RET

HADEKSEL:
	LD	A,(DEKSELG)
	ADD	A,015H
	DAA
	JR	NC,HADEKSEL2
	LD	A,099H
HADEKSEL2:
	LD	(DEKSELG),A
	LD	HL,PSGEFF10
	CALL	0001BH
	RET

HASCHOEN:
	LD	A,(SCHOENG)
	ADD	A,015H
	DAA
	JR	NC,HASCHOEN2
	LD	A,099H
HASCHOEN2:
	LD	(SCHOENG),A
	LD	HL,PSGEFF10
	CALL	0001BH
	RET

DOOR:
	XOR	A
	LD	(VALTELLER),A
	CALL	SPUGENOFF
	CALL	DOORB
	LD	DE,16
	ADD	HL,DE
	CALL	DOORB
	LD	DE,-32
	ADD	HL,DE
	CALL	DOORB
	LD	DE,48
	ADD	HL,DE
	CALL	DOORB
	LD	DE,-64
	ADD	HL,DE
	CALL	DOORB

DOORB:
	LD	A,(HL)
	AND	11110000B
	CP	208
	JR	Z,DOORLEFT
	CP	240
	RET	NZ
DOORRIGHT:
	LD	A,(HL)
	AND	15
	LD	E,A
	LD	D,0
	LD	IX,JOBDATA+80
	ADD	IX,DE
	LD	A,(IX+0)
	LD	(DOORMUSNR),A
	LD	A,230
	LD	(DOORI+1),A
	LD	A,4
	JR	DOORLEFT2

DOORLEFT:
	LD	A,(HL)
	AND	15
	LD	E,A
	LD	D,0
	LD	IX,JOBDATA+64
	ADD	IX,DE
	LD	A,(IX+0)
	LD	(DOORMUSNR),A
	LD	A,10
	LD	(DOORI+1),A
	LD	A,8
DOORLEFT2:
	LD	(DOORL+1),A
	CALL	DOORC
	LD	SP,(STACK)
	XOR	A
	LD	(BESTUR),A
	LD	(LOSLAAT),A
	JP	HOOFDLUS2

DOORC:
	PUSH	HL
	PUSH	HL
	LD	B,4
	CALL	00009H
	LD	A,0C9H
	LD	(BESTUR),A
	LD	(LOSLAAT),A
	LD	A,(DRAAGDIEN)
	CP	6
	LD	A,219
	JR	NZ,DOORE
	LD	(SPRITEATR+4),A
	LD	(SPRITEATR+8),A
DOORE:
	LD	(SPRITEATR+12),A
	LD	(SPRITEATR+16),A
	LD	(SPRITEATR+20),A
	LD	(SPRITEATR+24),A
	LD	B,30
DOORD:
	PUSH	BC
	CALL	INTERTIME
	CALL	SPUGEN
	CALL	MOVEDIEN
	CALL	SYMBOLEN
	CALL	COPYBROS	;bros verwijderen als nodig
	CALL	COPYROTS
	CALL	NEWBLOK
	CALL	MLIFT
	CALL	INITNEWV
	CALL	NEWBLOK
	CALL	VIJBEZ
	CALL	BEWEGING
	POP	BC
	DJNZ	DOORD
	EI
	CALL	INTERTIME
	LD	HL,PSGEFF27
	CALL	0001BH
	LD	DE,PALLETLEEG
	LD	HL,JOBDATA
	LD	A,4
	CALL	LETFADE
	POP	HL
	LD	A,(HL)
	XOR	1
	LD	HL,04000H
	LD	BC,03000H
	CPIR
	DEC	HL
	POP	DE
	PUSH	HL
	LD	BC,02404H
	OR	A
	SBC	HL,DE
	JR	NC,DOORF
	LD	BC,024FCH
DOORF:
	PUSH	BC
	EI
	CALL	INTERTIME
	POP	BC
	PUSH	BC
	LD	B,C
	CALL	SCROLL
	CALL	SPUGEN
	CALL	MOVEDIEN
	CALL	SYMBOLEN
	CALL	NEWBLOK
	CALL	MLIFT
	CALL	INITNEWV
	CALL	NEWBLOK
	CALL	VIJBEZ
	CALL	NEWBLOK
	CALL	NEWBLOK
	CALL	BEWEGING
	POP	BC
	DJNZ	DOORF
	EI
	CALL	INTERTIME
	CALL	INTERTIME
	DI
	LD	HL,MUSICINT
	LD	(00039H),HL
	XOR	A
	LD	(FRANR23),A
	LD	BC,00017H
	CALL	WRTVDP
	LD	BC,0BE13H
	CALL	WRTVDP
	POP	HL
	EI
	CALL	NEWPLACE
	CALL	OPADRESS
	CALL	OPPLATEAU
	EI
	CALL	INTERTIME
	DI
	LD	A,219
	LD	(SPRITEATR),A
	XOR	A
	LD	(SPUUGFLAG),A
	LD	HL,PALLETLEEG
	LD	DE,JOBDATA
	LD	A,2
	CALL	LETFADE
	DI
	LD	A,(DOORMUSNR)
	LD	B,A
	CALL	INITMUSIC
	LD	HL,STANDINT
	LD	(00039H),HL
	EI
	LD	A,(DRAAGDIEN)
	LD	B,A
	LD	HL,SPRITEATR+25
	LD	DE,-4
DOORI:
	LD	A,0
	LD	(HL),A
	ADD	HL,DE
	DJNZ	DOORI
	CALL	STDIENBL
	LD	B,10
	CALL	PAUSE
	CALL	SPUGENON
	LD	B,6
DOORK:
	PUSH	BC
	EI
	CALL	INTERTIME
	CALL	INTERTIME
DOORL:
	LD	A,4
	LD	(JOYRICHT),A
	XOR	A
	LD	(JOYFIRENU),A
	CALL	BESTUR+1
	CALL	COPYFRANC
	CALL	SYMBOLEN
	CALL	COPYBROS	;bros verwijderen als nodig
	CALL	COPYROTS
	CALL	NEWBLOK
	CALL	INITNEWV
	CALL	MLIFT
	CALL	NEWBLOK
	CALL	VIJBEZ
	POP	BC
	DJNZ	DOORK
	RET
DOORMUSNR:
	DB	0	;nieuw muziekje

VUURBOM:
	XOR	A
	LD	(KNOPPEN),A
	LD	A,(FRANCSTAT)
	CP	3
	JP	NC,HOOFDLUS1
	LD	A,(BOMMENG)
	SUB	1
	JP	C,HOOFDLUS1
	DAA
	LD	(BOMMENG),A
	LD	A,0C9H
	LD	(BESTUR),A
	LD	HL,(VOETADRES)
	LD	A,(FRANCRICH)
	OR	A
	JR	NZ,VUURBOM2
	;RECHTS vuren
	INC	HL
	LD	A,(XOFFSET)
	CP	3
	JR	C,VUURBOM3
	INC	HL
	JR	VUURBOM3
	;LINKS vuren
VUURBOM2:
	LD	A,(XOFFSET)
	CP	14
	JR	NC,VUURBOM3
	DEC	HL
VUURBOM3:
	LD	A,(YOFFSET)
	CP	9
	JR	NC,VUURBOM4
	LD	DE,-16
	ADD	HL,DE
VUURBOM4:
	PUSH	HL
	LD	B,3
VUURBOMA:
	PUSH	BC
	LD	HL,PALLETVOL
	LD	DE,JOBDATA
	LD	A,2
	CALL	LETFADE
	LD	HL,PSGEFF14
	CALL	0001BH
	LD	B,8
	CALL	PAUSE
	POP	BC
	DJNZ	VUURBOMA
	LD	HL,PALLETVOL
	LD	DE,JOBDATA
	LD	A,7
	CALL	LETFADE
	LD	HL,PSGEFF14
	CALL	0001BH
	POP	HL
	CALL	VUURBOM5
	LD	DE,-16
	ADD	HL,DE
	CALL	VUURBOM5
	LD	DE,-16
	ADD	HL,DE
	LD	A,(HL)
	AND	11111000B
	CP	10010000B
	JR	NZ,VUURBOM6
	CALL	VUURBOM5
	LD	DE,-16
	ADD	HL,DE
VUURBOM6:
	LD	A,(HL)
	CP	153
	JR	NZ,VUURBOM7
	CALL	ADRTOGET
	LD	(HL),A
	CALL	BLOKTOSCR
	PUSH	HL
VUURBOM8:
	LD	DE,16
	ADD	HL,DE
	LD	A,(HL)
	CP	128
	JR	C,VUURBOM8
	LD	DE,-16
	ADD	HL,DE
	LD	(HL),153
	CALL	BLOKTOSCR
	POP	HL
	LD	DE,-16
	ADD	HL,DE
	JR	VUURBOM6
VUURBOM7:
	CALL	INTERTIME
	XOR	A
	LD	(BESTUR),A
	JP	HOOFDLUS2

VUURBOM5:
	LD	A,(HL)
	CP	154
	RET	NC
	CP	152
	RET	Z
	CP	128
	RET	C
	EX	AF,AF'
	LD	A,(WORLDNR)
	CP	6
	JP	NZ,VUURBOMF
	EX	AF,AF'
	AND	11111000B
	CP	144
	JP	NZ,VUURBOMF
	LD	(HL),193
	CALL	BLOKTOSCR
	LD	(HL),0
	LD	BC,-16
	ADD	HL,BC
	LD	(HL),2
	CALL	BLOKTOSCR
	LD	BC,-16
	ADD	HL,BC
	LD	(HL),192
	CALL	BLOKTOSCR
	LD	(HL),2
	DI
	LD	HL,FRCOLDATA5
	CALL	FRANCOLOR
	LD	C,32
	CALL	HORIFRANC
	CALL	SPUGENOFF
	EI
	LD	B,0
	CALL	GADOOD2
VUURBOMG:
	LD	B,1
	CALL	GADOOD2
	XOR	A
	LD	(JOYFIRENU),A
	LD	A,4
	LD	(JOYRICHT),A
	CALL	BESTUR+1
	LD	A,(SPRITEATR+21)
	OR	A
	JR	NZ,VUURBOMG
	LD	HL,JOBDATA
	LD	DE,PALLETVOL
	LD	A,4
	CALL	LETFADE
	LD	B,36
	CALL	GADOOD2
	JP	ENDOF6	;einde van veld6

VUURBOMF:
	CALL	ADRTOGET
	LD	(HL),A
	PUSH	HL
	CALL	PUTBLOK
	POP	HL
	RET

	;invoer:HL=adres die veranderd is
PUTBLOK:
	CALL	BLOKTOSCR
	PUSH	HL
	CALL	PUTBLOKB
	POP	HL
	PUSH	HL
	LD	BC,16
	ADD	HL,BC
	CALL	PUTBLOKB
	POP	HL
	LD	BC,-16
	ADD	HL,BC

PUTBLOKB:
	LD	A,(HL)
	CP	128
	JP	C,PUTBLOKM
	CP	152
	JP	Z,PUTBLOKR
	JP	NC,PUTBLOKM
	LD	BC,16
	ADD	HL,BC
	LD	A,H
	CP	070H
	JR	Z,PUTBLOKC
	LD	A,(HL)
	AND	11111100B
	CALL	Z,MAKESHAD
	CP	64
	CALL	Z,MAKESHAD
	CP	128
	JR	C,PUTBLOKC
	CP	152
	JR	NC,PUTBLOKC
	LD	A,(HL)
	OR	2
	LD	(HL),A
	CALL	BLOKTOSCR
PUTBLOKC:
	LD	BC,-32
	ADD	HL,BC
	LD	A,H
	CP	03FH
	RET	Z
	LD	A,(HL)
	CP	128
	RET	C
	CP	152
	RET	NC
	LD	A,(HL)
	OR	1
	LD	(HL),A
	JP	BLOKTOSCR

PUTBLOKM:
	LD	BC,16
	ADD	HL,BC
	LD	A,(HL)
	AND	11111100B
	CP	4
	CALL	Z,CLEARSHAD
	CP	68
	CALL	Z,CLEARSHAD
	CP	128
	JR	C,PUTBLOKN
	CP	152
	JR	NC,PUTBLOKN
	LD	A,(HL)
	AND	11111101B
	LD	(HL),A
	CALL	BLOKTOSCR
PUTBLOKN:
	LD	BC,-32
	ADD	HL,BC
	LD	A,(HL)
	CP	128
	RET	C
	CP	152
	RET	NC
	LD	A,(HL)
	AND	11111110B
	LD	(HL),A
	JP	BLOKTOSCR
PUTBLOKR:
	LD	BC,16
	ADD	HL,BC
	LD	A,(HL)
	AND	11111100B
	CALL	Z,MAKESHAD
	CP	64
	CALL	Z,MAKESHAD
	CP	128
	JR	C,PUTBLOKS
	CP	152
	JR	NC,PUTBLOKS
	LD	A,(HL)
	AND	253
	LD	(HL),A
	CALL	BLOKTOSCR
PUTBLOKS:
	LD	BC,-32
	ADD	HL,BC
	LD	A,(HL)
	CP	128
	RET	C
	CP	152
	RET	NC
	LD	A,(HL)
	AND	254
	LD	(HL),A
	JP	BLOKTOSCR

MAKESHAD:
	PUSH	AF
	LD	A,(HL)
	ADD	A,4
	LD	(HL),A
	CALL	BLOKTOSCR
	POP	AF
	RET
CLEARSHAD:
	PUSH	AF
	LD	A,(HL)
	SUB	4
	LD	(HL),A
	CALL	BLOKTOSCR
	POP	AF
	RET

BLOKTOSCR:
	PUSH	HL
	CALL	BLOKONSCR
	POP	HL
	RET

	;allerlei vijanden-routines aanroepen
BEWEGING:
	CALL	SPIEZEN
	CALL	DRUPPEL
	JP	KANON

	;als power op is...
GADOOD:
	LD	A,(FRANCSTAT)
	CP	1
	JP	Z,HOOFDLUS1
	CP	2
	JP	Z,HOOFDLUS1
	LD	SP,(STACK)
	CALL	SPUGENOFF
	LD	A,0C9H
	LD	(BESTUR),A
	LD	A,(FRANCSTAT)
	PUSH	AF
	XOR	A
	LD	(FRANCSTAT),A
	LD	A,143
	LD	(FRANCNR),A
	EI
	CALL	INTERTIME
	CALL	COPYFRANCX
	LD	HL,(SPRITEATR+20)
	LD	A,L
	SUB	16
	LD	L,A
	LD	(SPRITEATR+12),HL
	LD	(SPRITEATR+16),HL
	DI
	LD	HL,PALLETVOL
	LD	DE,JOBDATA
	LD	A,2
	CALL	LETFADE
	CALL	00006H
	LD	HL,FRCOLDATA4
	CALL	FRANCOLOR
	POP	AF
	CP	4
	JR	Z,GADOOD9
	LD	A,(DRAAGDIEN)
	CP	6
	JR	NZ,GADOOD3
GADOOD9:
	DI
	CALL	INITDIENV
	CALL	KONTVALST2
GADOOD3:
	DI
	LD	HL,WACHT
	LD	(SPRITECALL+1),HL
	LD	HL,0D7A3H
	LD	BC,1750
	DI
	CALL	INITSTMUS
	LD	HL,SPRTOVRM
	LD	(SPRITECALL+1),HL
	LD	HL,PSGEFF26
	CALL	0001BH
	LD	B,0
	CALL	GADOOD2
	LD	DE,PALLETLEEG
	LD	HL,JOBDATA
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	GADOOD2
	CALL	SPUGENON
	LD	HL,800
	LD	(CONTINUEX+1),HL
	JP	CONTINUE

GADOOD2:
	PUSH	BC
	EI
	CALL	INTERTIME
	CALL	MOVEDIEN
	CALL	STDIENBL
	CALL	COPYFRANC
	CALL	NEWBLOK
	CALL	SPUGEN
	CALL	INITNEWV
	CALL	NEWBLOK
	CALL	VIJBEZ
	CALL	NEWBLOK
	CALL	MLIFT	;beweeg lift
	CALL	NEWBLOK
	CALL	SPIEZEN
	CALL	DRUPPEL
	CALL	KANON
	POP	BC
	DJNZ	GADOOD2
	RET
WACHT:
	LD	B,128
WACHT2:
	EX	(SP),HL
	EX	(SP),HL
	DJNZ	WACHT2
	RET

LOOPTOE:
	LD	A,0C9H
	LD	(BESTUR),A
	EI
	CALL	INTERTIME
	CALL	00006H
	LD	A,(00003H)
	PUSH	AF
	LD	A,0C9H
	LD	(00003H),A
	CALL	SPUGENOFF
	LD	HL,WACHT
	LD	(SPRITECALL+1),HL
	EI
	CALL	INTERTIME
	LD	HL,0DE38H
	LD	BC,6200
	CALL	INITSTMUS
	LD	HL,SPRTOVRM
	LD	(SPRITECALL+1),HL
	EI
	POP	AF
	LD	(00003H),A
LOOPTOE2:
	LD	A,(FRANCSTAT)
	OR	A
	JR	Z,LOOPTOE3
	LD	B,1
	CALL	GADOOD2
	JR	LOOPTOE2
LOOPTOE3:
	LD	A,(SPRITEATR+21)
	CP	132
	JR	Z,LOOPTOE4
	LD	B,4
	JR	NC,LOOPTOE5
	LD	B,8
LOOPTOE5:
	LD	A,B
	LD	(JOYRICHT),A
	XOR	A
	LD	(JOYFIRENU),A
	CALL	BESTUR+1
	LD	B,1
	CALL	GADOOD2
	JR	LOOPTOE3
LOOPTOE4:
	LD	A,1
	LD	(FRANCRICH),A
	CALL	INTERTIME
	LD	A,0C9H
	LD	(MOVEDIEN),A
	LD	A,(DRAAGDIEN)
	LD	(EINDGOED),A
	CP	6
	JR	NZ,LOOPTOE6
	LD	HL,0788CH
	LD	(SPRITEATR+4),HL
	LD	(SPRITEATR+8),HL
	LD	A,4
	LD	(DRAAGDIEN),A
LOOPTOE6:
	LD	A,1
	LD	(STANDNR),A
	CALL	REGSTAND
	CALL	REGSTAND
	LD	B,120
	CALL	GADOOD2
	LD	DE,PALLETLEEG
	LD	HL,JOBDATA
	LD	A,3
	CALL	LETFADE
	LD	B,30
	CALL	GADOOD2
	JP	CONVER

	INCLUDE	"subs.asm"
	INCLUDE	"praat.asm"
	INCLUDE	"vij.asm"
	
;----------------------------------------------------------------------------
; Fill with zero's to get binary file size divisible by 128 bytes
; That's what GEN80 used to do automatically
	
	DS (128-($%128))*($%128>0)*-1