	;pallet tijdens speelveld
STAGE4:
	DB	003H,000H,027H,004H,053H,003H,042H,002H
	DB	040H,003H,033H,007H,050H,004H,055H,005H
	DB	030H,002H,070H,006H,000H,005H,077H,007H
	DB	065H,007H,074H,004H,027H,001H,000H,000H

PALLET:
	DB	000H,000H,000H,000H,005H,000H,007H,000H
	DB	031H,001H,000H,000H,042H,002H,055H,005H
	DB	075H,005H,000H,000H,000H,004H,077H,007H
	DB	003H,000H,033H,003H,063H,003H,000H,002H

	;muziek bij linker deuren 0-F
	DB	1,0, 1,0, 1,0, 1,0, 1,0, 1,0, 1,0, 1,0

	;muziek bij rechter deuren 0-F
	DB	0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1

	;muziek die bij starten moet worden ingesteld
	DB	0

	;nr. van het veld
	DB	4

	;op welk adres moet FRANC starten
	DW	04055H

	;data t.b.v. pratende kop
	DB	0,64         ;mond 1
	DB	15,64        ;mond 2
	DB	30,64        ;mond 3
	DB	15,64        ;mond 2
	DB	15,12        ;breedte x, breedte y
	DB	12+192,42    ;x-offset,y-offset t.o.v. links-boven van kop

	;tekst bij begin van earl cramp. 3 betekent stoppen
	DB	"NOW YOU ARE INSTRUCTED TO SERVE",0
	DB	"HERR HOLZSTEIN A PORT...       ",0
	DB	"HE DOESN'T SPEAK ENGLISH, SO   ",0
	DB	"DON'T TALK TO HIM AT ALL!!     ",0
	DB	"ALRIGHT, HURRY UP!!            ",3
	DB	"                               ",0
	DB	"                               ",0
	DB   "                               ",0

	;gesprek bij einde van veld tussen franc en de gast
	;franc begint te praten. Als '0' aan einde van regel dan
	;pratende praat gewoon door. Als '1' dan FRANC gaat praten
	;als '2' dan gast gaat praten, 3 betekent stoppen
	DB	"EEHH, GUTEN TAG HERR   ",0
	DB	"HOLZSTEIN! BITTE, EHH, ",0
	DB	"IHR, EH EHH....        ",2
	DB	"WHAT ARE YOU SAYING ?? ",0
	DB	"CAN YOU SPEAK ENGLISH  ",0
	DB	"PLEASE ??              ",1
	DB	"EARL CRAMP TOLD ME THAT",0
	DB	"YOU DIDN'T SPEAK       ",0
	DB	"ENGLISH...             ",2
	DB	"I SEE... EARL CRAMP IS ",0
	DB	"ALWAYS MAKING JOKES !! ",1
	DB	"WE MUST MAKE A PLAN TO ",0
	DB	"ESCAPE FROM EARL CRAMP!",2
	DB	"I KNOW THAT THE HOUSE  ",0
	DB	"IS VERY MYSTERIOUS...  ",0
	DB	"MAYBE YOU CAN TALK TO  ",0
	DB	"FLOW ED ROB...         ",3
	DB	"                       ",0
	DB	"                       ",0
	DB	"                       ",0

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

	DB	09AH,041H,1,4,0
	DB	002H,042H,2,6,64+8
	DB	082H,042H,2,6,192+8
	DB	0E4H,042H,3,1,0E9H
	DB	067H,045H,4,4,0
	DB	0B9H,045H,5,5,0
	DB	066H,046H,6,5,0
	DB	033H,047H,7,7,64+20
	DB	06DH,047H,8,6,64+17
	DB	095H,047H,9,1,091H
	DB	0BAH,047H,10,1,0BEH
	DB	001H,048H,11,1,006H
	DB	049H,048H,12,1,04EH
	DB	073H,048H,7,7,192+20
	DB	07DH,048H,8,6,192+17
	DB	049H,04CH,13,4,0
	DB	099H,04CH,14,4,0
	DB	0E7H,04CH,15,4,0
	DB	02AH,04DH,16,4,0
	DB	045H,04DH,17,5,0
	DB	002H,04EH,18,5,0
	DB	047H,04EH,20,5,0
	DB	04CH,04EH,21,4,0
	DB	0C9H,04EH,25,1,0CDH
	DB	0E7H,04EH,22,4,0
	DB	037H,04FH,23,5,0
	DB	038H,04FH,24,5,0
	DB	083H,051H,25,6,64+12
	DB	043H,052H,25,6,192+12
	DB	0C2H,052H,35,1,0C7H
	DB	0D7H,052H,36,1,0DBH
	DB	044H,054H,27,1,04BH
	DB	025H,055H,28,5,0
	DB	02AH,055H,29,5,0
	DB	064H,056H,31,1,06CH
	DB	085H,056H,30,5,0
	DB	0E5H,056H,33,1,0EBH
	DB	005H,057H,32,4,0
	DB	0D7H,057H,34,5,0
	DB	063H,05BH,37,1,06CH
	DB	096H,05BH,38,3,0
	DB	0FAH,05BH,39,2,0
	DB	0F8H,05BH,40,2,0
	DB	034H,05CH,41,2,0
	DB	09AH,05CH,42,2,0
	DB	098H,05CH,43,2,0
	DB	077H,05DH,44,5,0
	DB	08DH,05DH,45,5,0
	DB	0A1H,05DH,46,5,0
	DB	01AH,05EH,47,3,0
	DB	0A2H,05EH,48,1,0ABH
	DB	036H,05FH,49,4,0
	DB	094H,05FH,50,4,0
	DB	004H,060H,51,3,0
	DB	054H,062H,52,1,05DH
	DB	0EDH,062H,53,6,64+21
	DB	009H,063H,54,4,0
	DB	066H,063H,55,5,0
	DB	0C6H,063H,56,3,0
	DB	03DH,064H,53,6,192+21
	DB	04DH,064H,99,7,64+21
	DB	097H,064H,57,4,0
	DB	065H,065H,58,5,0
	DB	09DH,065H,99,7,192+21
	DB	032H,068H,59,3,0
	DB	094H,068H,60,1,097H
	DB	099H,068H,61,1,09CH
	DB	024H,06AH,62,4,0
	DB	038H,06AH,63,1,039H
	DB	08BH,06AH,64,2,0
	DB	019H,06BH,65,1,01BH
	DB	068H,06BH,66,4,0
	DB	0C8H,06BH,67,5,0
	DB	076H,06DH,68,4,0
	DB	004H,06EH,69,1,006H
	DB	0B6H,06EH,70,4,0
	DB	059H,06FH,71,5,0

	DB	000H,0C0H,236,0,0
	