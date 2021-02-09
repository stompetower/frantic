	;pallet tijdens speelveld
STAGE2:
	DB	003H,000H,027H,004H,000H,001H,042H,002H
	DB	000H,003H,033H,007H,050H,004H,055H,005H
	DB	021H,001H,070H,006H,000H,005H,077H,007H
	DB	004H,000H,074H,004H,027H,001H,000H,000H

	DB	000H,000H,061H,001H,042H,002H,051H,001H
	DB	031H,001H,022H,002H,042H,002H,055H,005H
	DB	075H,005H,053H,003H,040H,000H,077H,007H
	DB	064H,004H,033H,003H,063H,003H,020H,000H

	;muziek bij linker deuren 0-F
	DB	0,0, 0,1, 1,1, 1,0, 0,0, 0,1, 1,1, 1,0

	;muziek bij rechter deuren 0-F
	DB	1,1, 1,0, 0,0, 0,1, 1,1, 1,0, 0,0, 0,1

	;muziek die bij starten moet worden ingesteld
	DB	0

	;nr. van het veld
	DB	2

	;op welk adres moet FRANC starten
	DW	04038H

	;data t.b.v. pratende kop
	DB	0,64         ;mond 1
	DB	18,64        ;mond 2
	DB	36,64        ;mond 3
	DB	18,64        ;mond 2
	DB	18,10        ;breedte x, breedte y
	DB	12+192,44    ;x-offset,y-offset t.o.v. links-boven van kop

	;tekst bij begin van earl cramp. 3 betekent stoppen
	DB	"I AM HAPPY TO HAVE A GUEST FROM",0
	DB	"THE BIGGEST FIRE-DEPARTMENT OF ",0
	DB	"LONDON... I THINK HE IS A BIT  ",0
	DB	"GRUMPY. SO BRING HIM A POT OF  ",0
	DB	"BEER QUICKLY!                  ",3
	DB	"                               ",0
	DB	" ANDRE EN MARTIJN              ",0
	DB	"                               ",0

	;gesprek bij einde van veld tussen franc en de gast
	;franc begint te praten. Als '0' aan einde van regel dan
	;pratende praat gewoon door. Als '1' dan FRANC gaat praten
	;als '2' dan gast gaat praten, 3 betekent stoppen
	DB	"I AM COMING TO BRING   ",0
	DB	"YOU A POT OF BEER.     ",2
	DB	"FINE, I AM VERY THIRSTY",0
	DB	"AND HUNGRY.            ",1
	DB	"I DON'T HAVE SOMETHING ",0
	DB	"TO EAT FOR YOU, SORRY..",0
	DB	"BUT CAN YOU PLEASE HELP",0
	DB	"ME TO ESCAPE FROM THIS ",0
	DB	"HORRIBLE PLACE?        ",2
	DB	"SO YOU DON'T HAVE      ",0
	DB	"SOMETHING TO EAT?      ",1
	DB	"NO, I AM SORRY...      ",2
	DB	"WELL, DO YOUR JOB,     ",0
	DB	"NOTHING MORE... I DON'T",0
	DB	"SAY ANYTHING...        ",3
	DB	"                       ",0
	DB	"                       ",0
	DB	"  MARTIJN EN ANDRE     ",0
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

	DB	09AH,040H,1,3,0
	DB	0CAH,041H,2,4,0
	DB	058H,042H,3,2,0
	DB	0CBH,042H,4,1,0C8H
	DB	003H,043H,5,1,009H
	DB	027H,043H,6,1,023H
	DB	094H,043H,7,6,11+64
	DB	044H,044H,7,6,11+128+64
	DB	046H,044H,9,7,7
	DB	081H,044H,10,4,0
	DB	09EH,044H,11,4,0
	DB	0A8H,045H,12,3,0
	DB	0F3H,045H,13,1,0FDH
	DB	053H,047H,8,6,12+64
	DB	05CH,047H,14,7,8+64
	DB	0A1H,047H,40,1,0AEH
	DB	0DCH,047H,14,7,8+64+128
	DB	0EEH,047H,41,1,0E1H
	DB	013H,048H,8,6,12+128+64
	DB	0D4H,049H,15,5,0
	DB	0D2H,04BH,17,1,0DAH
	DB	086H,04CH,16,3,0
	DB	0C7H,04CH,18,4,0
	DB	006H,04DH,19,2,0
	DB	038H,04DH,20,5,0
	DB	067H,04EH,21,7,8+64
	DB	0E7H,04EH,21,7,8+192
	DB	037H,04FH,22,4,0
	DB	0B2H,04FH,23,2,0
	DB	0BAH,04FH,24,2,0
	DB	016H,050H,25,6,7
	DB	0D4H,050H,26,7,2+64
	DB	0F4H,050H,26,7,2+192
	DB	068H,052H,27,4,0
	DB	023H,053H,28,5,0
	DB	0DDH,053H,29,6,30+64
	DB	019H,054H,31,2,0
	DB	0BDH,055H,29,6,30+192
	DB	0C5H,055H,30,4,0
	DB	0E3H,057H,32,4,0
	DB	0FAH,057H,33,1,0FDH
	DB	029H,058H,34,3,0
	DB	078H,058H,35,4,0
	DB	0B6H,058H,36,1,0B2H
	DB	0DDH,058H,37,1,0DAH
	DB	0E4H,059H,38,6,8
	DB	01CH,05AH,39,7,4+64
	DB	05CH,05AH,39,7,4+192
	DB	0A3H,05AH,42,1,0A8H
	DB	022H,05BH,44,1,027H
	DB	04BH,05BH,43,4,0
	DB	041H,05CH,45,4,0
	DB	06EH,05CH,46,4,0
	DB	0F4H,05EH,47,1,0FDH
	DB	0AAH,05FH,48,1,0A2H
	DB	0A2H,062H,49,4,0
	DB	001H,063H,51,4,0
	DB	0ACH,063H,53,5,0
	DB	0E4H,063H,54,6,10+64
	DB	084H,064H,54,6,10+192
	DB	0C5H,064H,55,5,0
	DB	081H,065H,56,1,088H
	DB	0F6H,065H,58,2,0
	DB	009H,066H,59,2,0
	DB	01CH,066H,57,2,0

	DB	000H,0C0H,236,0,0