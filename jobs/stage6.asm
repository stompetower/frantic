	;pallet tijdens speelveld

STAGE6:
	DB	003H,000H,027H,004H,077H,003H,042H,002H
	DB   033H,000H,033H,007H,050H,004H,055H,005H
	DB   033H,003H,070H,006H,000H,005H,077H,007H
	DB   055H,001H,074H,004H,027H,001H,000H,000H

PALLET:
	DB	000H,000H,055H,007H,050H,003H,070H,005H
	DB   031H,001H,003H,000H,042H,002H,055H,005H
	DB   075H,005H,000H,000H,005H,002H,077H,007H
	DB   000H,000H,033H,003H,063H,003H,000H,001H

	;muziek bij linker deuren 0-F
	DB	0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0

	;muziek bij rechter deuren 0-F
	DB	0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0

	;muziek die bij starten moet worden ingesteld
	DB	0

	;nr. van het veld
	DB	6

	;op welk adres moet FRANC starten
	DW	04032H

	;data t.b.v. pratende kop
	DB	0,64         ;mond 1
	DB	18,64        ;mond 2
	DB	36,64        ;mond 3
	DB	18,64        ;mond 2
	DB	18,13        ;breedte x, breedte y
	DB	09+192,38    ;x-offset,y-offset t.o.v. links-boven van kop

	;tekst bij begin van earl cramp. 3 betekent stoppen
	DB	" WAT EEN LELIJK EINDE          ",0
	DB	"                               ",0
	DB	"                               ",0
	DB	"                               ",0
	DB	"                               ",0
	DB	"                               ",0
	DB	"                               ",0
	DB	"MOOI SPEL HE ??                ",0

	;gesprek bij einde van veld tussen franc en de gast
	;franc begint te praten. Als '0' aan einde van regel dan
	;pratende praat gewoon door. Als '1' dan FRANC gaat praten
	;als '2' dan gast gaat praten, 3 betekent stoppen
	DB	"HAI, FLOW ED ROB !!  I ",0
	DB	"CAME TO BRING YOU YOUR ",0
	DB	"MEDICINE.              ",2
	DB	"AAHH, YOU BRING ME A   ",0
	DB	"MEDICINE SO I BECOME   ",0
	DB	"WEAKER AND WEAKER EVERY",0
	DB	"DAY !! WHO ARE YOU ??  ",1
	DB	"I AM CAPTURED BY EARL  ",0
	DB	"CRAMP... I HEARD ABOUT ",0
	DB	"YOU... CAN YOU HELP ME ",0
	DB	"AND THE OTHER CAPTURED ",0
	DB	"GUESTS ??              ",2
	DB	"YES. I CAN'T LEAVE THIS",0
	DB	"DUNGEON, BUT YOU CAN.  ",1
	DB	"WHAT SHOULD I DO ??    ",2
	DB	"YOU MUST GO TO         ",0
	DB	"THE WIZZARD 'OWLENSKY'.",0
	DB	"TELL HIM THAT THE WE   ",0
	DB	"CAN ESCAPE AT THE LEFT ",0
	DB	"SIDE OF THE BUILDING.. ",3

	;data van vijanden

	DW	03000H
	DB	0,0,0
	DW	03000H
	DB	0,0,0
	DW	03000H
	DB	0,0,0

	;DB  LOWadr,HIGHadr,UNIEKEcode,VIJnr,EXTRAinfo

	;VIJnr= 1 voor vogel, EXTRAinfo=tweede LOWadr
	;     = 2 voor rat
	;     = 3 voor kangaroe
	;     = 4 voor spin
	;     = 5 voor knager
	;     = 6 voor lift1, EXTRAinfo=aantal(0-63),+64 voor verticaal
	;                               +128 voor naar boven, naar links
	;     = 7 voor lift2, EXTRAinfo= idem lift1

	DB	0D6H,041H,1,5,0
	DB	057H,042H,2,2,0
	DB	05BH,042H,3,2,0
	DB	096H,042H,4,2,0
	DB	09DH,042H,5,2,0

	DB	000H,0C0H,236,0,0