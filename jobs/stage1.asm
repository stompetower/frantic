	;pallet tijdens speelveld
STAGE1:
	DB	003H,000H,027H,004H,021H,001H,042H,002H
	DB	033H,003H,033H,007H,050H,004H,055H,005H
	DB	053H,003H,070H,006H,000H,005H,077H,007H
	DB	022H,002H,074H,004H,027H,001H,000H,000H

	;pallet van koppen
	DB	000H,000H,000H,004H,010H,004H,000H,002H
	DB	031H,001H,000H,000H,042H,002H,055H,005H
	DB	075H,005H,000H,000H,022H,002H,077H,007H
	DB	021H,006H,033H,003H,063H,003H,011H,001H

	;muziek bij linker deuren 0-F
	DB   0,0, 0,1, 1,1, 1,0, 0,0, 0,1, 1,1, 1,0

	;muziek bij rechter deuren 0-F
	DB	1,1, 1,0, 0,0, 0,1, 1,1, 1,0, 0,0, 0,1

	;muziek die bij starten moet worden ingesteld
	DB	0

	;nr. van het veld
	DB	1

	;op welk adres moet FRANC starten
	DW	04043H

	;data t.b.v. pratende kop
	DB	0,64         ;mond 1
	DB	8,64         ;mond 2
	DB	16,64        ;mond 3
	DB	8,64         ;mond 2
	DB	8,8          ;breedte x, breedte y
	DB	14+192,32    ;x-offset,y-offset t.o.v. links-boven van kop

	;tekst bij begin van earl cramp. 3 betekent stoppen
	DB	"DOWNSTAIRS A GUEST FROM HOLLAND",0
	DB	"IS WAITING FOR A RED WINE.     ",0
	DB	"PLEASE BRING IT TO HIM....     ",0
	DB	"OTHERWISE....   HAHAHAHA !!    ",0
	DB	"AND REMEMBER:                  ",0
	DB	"DON'T TALK TO HIM !!           ",3
	DB	"                               ",0
	DB	"                               ",0

	;gesprek bij einde van veld tussen franc en de gast
	;franc begint te praten. Als '0' aan einde van regel dan
	;pratende praat gewoon door. Als '1' dan FRANC gaat praten
	;als '2' dan gast gaat praten, 3 betekent stoppen
	DB	"HELLO, HERE IS YOUR RED",0
	DB	"WHINE.                 ",2
	DB	"THANK YOU VERY MUCH.   ",1
	DB	"I AM CAPTURED BY EARL  ",0
	DB	"CRAMP !! CAN YOU PLEASE",0
	DB	"GIVE ME SOME ADVICE ?? ",2
	DB	"PSSS, DON'T TALK LOUD !",0
	DB	"EARL CRAMP CAN HEAR US.",1
	DB	"HOW CAN I LEAVE THIS   ",0
	DB	"HORRIBLE PLACE ??      ",2
	DB	"I DON'T KNOW HOW TO    ",0
	DB	"LEAVE, BECAUSE ALL THE ",0
	DB	"'GUESTS' ARE CAPTURED  ",0
	DB	"BY EARL CRAMP...       ",1
	DB	"CAN YOU HELP ME ??     ",2
	DB	"WE CAN'T HELP YOU...   ",0
	DB	"PLEASE TALK TO THE     ",0
	DB	"OTHER GUESTS, MAYBE    ",0
	DB	"THEY CAN GIVE YOU SOME ",0
	DB	"ADVISE !!              ",3

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


	DB	0D5H,044H,1,4,0
	DB	086H,046H,5,1,08DH
	DB	066H,047H,2,4,0
	DB	0D7H,047H,3,2,0
	DB	0DDH,047H,4,4,0
	DB	0D3H,049H,6,1,0DBH
	DB	015H,04AH,7,1,01CH
	DB	0C4H,04CH,8,2,0
	DB	0CAH,04CH,9,4,0
	DB	047H,04FH,10,3,0
	DB	0ACH,050H,11,4,0
	DB	0E5H,051H,12,2,0
	DB	01AH,052H,13,2,0
	DB	068H,052H,14,2,0
	DB	0B6H,052H,15,2,0
	DB	036H,053H,16,1,03DH
	DB	014H,054H,17,1,01CH
	DB	0D6H,054H,18,1,0DCH
	DB	01EH,055H,20,3,0
	DB	084H,055H,21,4,0
	DB	07AH,057H,22,1,072H
	DB	0B8H,057H,23,1,0BDH
	DB	023H,058H,24,1,027H
	DB	0F9H,058H,25,2,0
	DB	012H,05AH,26,1,016H
	DB	0A2H,05AH,27,1,0A6H
	DB	084H,05BH,28,4,0
	DB	08CH,05BH,29,4,0
	DB	061H,05BH,30,3,0
	DB	0D6H,05CH,33,4,0
	DB	013H,05DH,31,1,01DH
	DB	077H,05DH,32,1,07BH
	DB	0A8H,05DH,34,2,0
	DB	004H,05EH,35,2,0
	DB	094H,05FH,36,3,0
	DB	0C8H,060H,37,3,0
	DB	0F7H,06EH,38,5,0

	DB	000H,0C0H,236,0,0