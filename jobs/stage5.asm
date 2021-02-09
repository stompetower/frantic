	;pallet tijdens speelveld

STAGE5:
	DB	003H,000H,027H,004H,000H,003H,042H,002H
	DB	011H,001H,033H,007H,050H,004H,055H,005H
	DB	022H,002H,070H,006H,000H,005H,077H,007H
	DB	000H,002H,074H,004H,027H,001H,000H,000H

PALLET:
	DB	000H,000H,055H,007H,050H,003H,070H,005H
	DB	031H,001H,003H,000H,042H,002H,055H,005H
	DB	075H,005H,000H,000H,005H,002H,077H,007H
	DB	000H,000H,033H,003H,063H,003H,000H,001H

	;muziek bij linker deuren 0-F
	DB	1,0, 1,0, 1,0, 1,0, 1,0, 1,0, 1,0, 1,0

	;muziek bij rechter deuren 0-F
	DB	0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1

	;muziek die bij starten moet worden ingesteld
	DB	0

	;nr. van het veld
	DB	5

	;op welk adres moet FRANC starten
	DW  0409CH

    ;data t.b.v. pratende kop
    DB	0,64         ;mond 1
	DB	16,64        ;mond 2
	DB	32,64        ;mond 3
	DB	16,64        ;mond 2
	DB	16,15        ;breedte x, breedte y
	DB	09+192,38    ;x-offset,y-offset t.o.v. links-boven van kop

	;tekst bij begin van earl cramp. 3 betekent stoppen
	DB	"CAN YOU BRING SOME ASPERIN TO  ",0
	DB	"FLOW ED ROB?? I THINK HE IS A  ",0
	DB	"BIT SICK !!  HAHAHA !! ANYWAY, ",0
	DB	"BRING THIS GLAS OF WATER AND   ",0
	DB	"THE MEDICINE TO HIM QUICKLY !! ",3
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
	DB	"YOU MUST GO ON AND FIND",0
	DB	"THE WEAKER SPOT IN THE ",0
	DB	"WALL !!                ",1
	DB	"DO YOU KNOW WHICH SIDE?",2
	DB	"THE LEFT SIDE....      ",3

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
			
	DB 22H, 41H, 01H, 01H, 25H
	DB 39H, 41H, 02H, 01H, 3CH
	DB 0DBH, 41H, 03H, 06H, 89H
	DB 33H, 42H, 06H, 02H, 00H
	DB 68H, 42H, 04H, 01H, 62H
	DB 65H, 43H, 05H, 05H, 00H
	DB 6BH, 44H, 07H, 01H, 64H
	DB 8DH, 44H, 08H, 03H, 00H
	DB 0E1H, 44H, 09H, 04H, 00H
	DB 05H, 45H, 0AH, 01H, 0CH
	DB 85H, 45H, 0CH, 01H, 8BH
	DB 0C3H, 45H, 0BH, 03H, 00H
	DB 3CH, 47H, 0CH, 01H, 36H
	DB 24H, 49H, 0DH, 01H, 21H
	DB 3AH, 49H, 0EH, 04H, 00H
	DB 8AH, 49H, 0FH, 01H, 8EH
	DB 0D1H, 49H, 10H, 01H, 0D7H
	DB 39H, 4AH, 11H, 02H, 00H
	DB 0C1H, 4AH, 12H, 04H, 00H
	DB 0D6H, 4AH, 13H, 04H, 00H
	DB 25H, 4BH, 14H, 05H, 00H
	DB 0B6H, 4CH, 15H, 05H, 00H
	DB 0A5H, 4BH, 16H, 04H, 00H
	DB 0ABH, 4BH, 17H, 04H, 00H
	DB 0A4H, 4FH, 18H, 05H, 00H
	DB 0F8H, 4FH, 19H, 05H, 00H
	DB 49H, 50H, 1AH, 04H, 00H
	DB 93H, 50H, 1BH, 04H, 00H
	DB 82H, 51H, 1CH, 06H, 4CH
	DB 0BAH, 51H, 1EH, 01H, 0B4H
	DB 0AH, 52H, 1FH, 02H, 00H
	DB 42H, 52H, 1CH, 06H, 0CCH
	DB 45H, 52H, 1DH, 05H, 00H
	DB 0BAH, 52H, 20H, 05H, 00H
	DB 1AH, 53H, 21H, 04H, 00H
	DB 0C3H, 53H, 22H, 05H, 00H
	DB 77H, 54H, 23H, 04H, 00H
	DB 97H, 55H, 24H, 05H, 00H
	DB 24H, 57H, 25H, 05H, 00H
	DB 2AH, 57H, 26H, 05H, 00H
	DB 72H, 57H, 27H, 04H, 00H
	DB 8EH, 57H, 28H, 05H, 00H
	DB 0EAH, 57H, 29H, 05H, 00H
	DB 31H, 58H, 2AH, 05H, 00H
	DB 0C8H, 58H, 2BH, 04H, 00H
	DB 0F4H, 58H, 2CH, 04H, 00H
	DB 38H, 59H, 2DH, 05H, 00H
	DB 66H, 5AH, 2EH, 02H, 00H
	DB 84H, 5BH, 30H, 05H, 00H
	DB 07H, 5CH, 31H, 04H, 00H
	DB 03H, 5CH, 32H, 04H, 00H
	DB 57H, 5CH, 33H, 05H, 00H
	DB 0A4H, 5CH, 34H, 01H, 0ABH
	DB 66H, 5DH, 36H, 05H, 00H
	DB 69H, 5DH, 37H, 05H, 00H
	DB 0FDH, 5DH, 35H, 06H, 53H
	DB 59H, 5EH, 38H, 03H, 00H
	DB 27H, 5FH, 39H, 02H, 00H
	DB 2DH, 5FH, 35H, 06H, 0D3H
	DB 0A3H, 61H, 3CH, 01H, 0ABH
	DB 0DAH, 61H, 3AH, 07H, 86H
	DB 0FDH, 62H, 3DH, 01H, 0F5H
	DB 25H, 63H, 3BH, 06H, 06H
	DB 0A5H, 67H, 46H, 05H, 00H
	DB 0C9H, 69H, 47H, 01H, 0CCH
	DB 7AH, 6AH, 48H, 01H, 7DH
	DB 0E2H, 6AH, 49H, 01H, 0EBH
	DB 17H, 6BH, 4AH, 04H, 00H
	DB 0D5H, 6BH, 4CH, 01H, 0DAH
	DB 0E6H, 6BH, 4BH, 04H, 00H
	DB 0A2H, 6CH, 4DH, 01H, 0A5H
	DB 37H, 6DH, 4EH, 04H, 00H
	DB 73H, 6DH, 4FH, 05H, 00H
	DB 6CH, 6EH, 50H, 01H, 65H 

	DB	000H,0C0H,236,0,0
	