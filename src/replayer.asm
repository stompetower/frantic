; ================================================================================
; ANMA replayer for music (PSG & FM/OPLL) and sound effects.
;                                                  (for the Z80 based MSX system)
; ================================================================================
; Music for this replayer is made with ANMA's tracker RED.
; Sound effects for this replayer have a data format explained at the very bottom 
; of this file.
; ================================================================================
; Chips supported:
;	- General Instrument AY-3-8910 (or compatible)
;	- Yamaha YM2413 OPLL FM sound chip (or compatible)
; Used in: 
;	- game Frantic
;	- game Troxx
;	- demo RELAX (=Squeek Demo 3)
;	(other ANMA products used a similar but earlier version of this replayer)
; ================================================================================
; General notes:
;   - PSG (=Programmable Sound Generator) refers to the AY-3-8910 sound chip (*).
;   - FM, FM/OPLL, OPLL all refer to the Yamaha YM2413 sound chip (*).
;                                                (*) or compatible
;   - if a PSG sound effect is active, it temporarily takes over channel PSG1.
;   - if a OPLL/FM sound effect is active, it temporarily takes over channel FM1.
;   - effect data (for music) is another concept than sound effect data.
; ================================================================================
; Credits:
;   - Andre Ligthart wrote the original source code in 1991/1992 (but it was lost)
;   - Thom Zwagers reverse engineered this code (based on binary and old sources)
;   - Andre Ligthart added most of the comments
; ================================================================================

    ORG  00000H

;----------------------------------------------------------------------------
; entries to routines, to be called from external code
;----------------------------------------------------------------------------	
    JP INITMUSDAT	; start/initialize new music/song
    JP REPLAYROUT	; interrupt routine for playing music
    JP ALLMUSICOFF	; turn off music all at once
    JP SETVOLUDEC	; start fading out music volume
    JP SETVOLUINC	; start fading in music volume
    JP SETMAXVOLU	; set max volume for PSG and FM (balance), call before song init
    JP SETVOLUMES	; set volumes for PSG and FM, call while playing music
    JP VOLUMESOFF	; turn off volume on all channels PSG and FM
    JP VOLONAGAIN	; restore volume on all channels PSG and FM
    JP SETPSGEFF	; start new PSG sound effect
    JP SETFMPEFF	; start new FM sound effect
    JP SETBOTHEFF	; start new (PSG+FM) sound effect
    JP EFFPSGBEG	; interrupt routine for playing PSG sound effects
    JP EFFFMPBEG	; interrupt routine for playing FM sound effects
    JP CLEAREFFEC	; stops playing sound effect (PSG and FM) immediately
    JP MUSADRES		; prepare music data (relative offsets -> absolute RAM addresses)
    JP OTHERSPEED	; change music tempo
;----------------------------------------------------------------------------

EFFPSGFLG:
    DB 0			; if value <> 0, then there is a PSG sound effect playing
EFFFMPFLG:
    DB 0			; if value <> 0, then there is a FM sound effect playing
EFFPSGBUF:
    DW 0			; points to PSG sound effect data while playing sound effect

;----------------------------------------------------------------------------
; General Z80 interrupt handler
;----------------------------------------------------------------------------
    NOP			; fill-up to ensure next instruction will be at 00038H exactly
    JP 0D000H	; jump to interrupt handler (external code may change the JP address)


;----------------------------------------------------------------------------
; Start and stop PSG and FM sound effects
;----------------------------------------------------------------------------

; start new sound effect for both PSG and FM/OPLL
; input: DE=start address PSG effect-data
;        HL=start address FM effect-data
SETBOTHEFF:
    LD A,2
    LD (EFFPSGFLG),A
    LD (EFFPSGBUF),DE
    JR SETFMPEFF

; start new PSG sound effect
; input: HL=start address PSG effect-data
SETPSGEFF:
    LD A,2
    LD (EFFPSGFLG),A
    LD (EFFPSGBUF),HL
    RET

; start new FM/OPLL sound effect
; input: HL=start address FM effect-data
SETFMPEFF:
    LD A,2
    LD (EFFFMPFLG),A
    LD (EFFFMPBUF),HL
    RET

; stops playing sound effect (PSG and FM) immediately
CLEAREFFEC:
    CALL EFFPSGEND
    JP EFFFMPEND

;----------------------------------------------------------------------------
; interrupt routine for playing PSG sound effects
; for info about data format of ANMA sound effect, see bottom of this file.
; (in this data format, byte values 248 until 255 have a special meaning)
;----------------------------------------------------------------------------
EFFPSGBEG:
	LD	A,(EFFPSGFLG)
	OR	A			; A=0 => nothing to do
	RET	Z
	DEC	A			; A=1 => busy playing sound effect
	JR	Z,EFFPSGBEGB
	DEC A			; A=2 => new sound effect
	RET NZ

EFFPSGNEW:			; initialize new sound effect
    LD	A,1
    LD (EFFPSGFLG),A
    LD IX,(EFFPSGBUF)
	; below: restore counters in sound effect data (used by loops)  
EFFPSGNEWB:
    LD A,(IX+0)
    CP 251			; end of sound effect?
    RET Z
    CP 255			; outer loop starts here in sound effect data
    JP Z,EFFPSGNEWC
    CP 250			; inner loop starts here in sound effect data
    JP Z,EFFPSGNEWC
    INC IX
    JP EFFPSGNEWB

EFFPSGNEWC:
    LD A,(IX+6)		; a copy of the loop 'from value' resides here
    LD (IX+1),A		; the loop 'from value' (counts up or down)
    INC IX
    JP EFFPSGNEWB
	; below: process PSG sound effect, based on ANMA's sound effect data language
EFFPSGBEGB:			
    LD HL,(EFFPSGBUF)
EFFPSGOPN:   
    LD A,(HL)		; read byte from sound effect data...
    INC A
    JR Z,EFFPSGFOR	; if 255, start outer loop (255,from,to,up/down,step,reg,from_copy)
    INC A
    JR Z,EFFPSGSND	; if 254, set PSG register (254,reg,data,..,..)
    INC A
    JR Z,EFFPSGINT	; if 253, wait one interrupt
    INC A
    JR Z,EFFPSGNXT	; if 252, go to next iteration of outer loop
    INC A
    JP Z,EFFPSGEND	; if 251, end of sound effect
    INC A
    JR Z,EFFPSGFOR	; if 250, start inner loop (250,from,to,up/down,step,reg,from_copy)
    INC A
    JR Z,EFFPSGNX2	; if 249, go to next iteration of inner loop
    INC A
    RET NZ
EFFPSGCHG:   		; if 248, add/subtract to PSG register (248,reg,amount XOR 64)
    INC HL
    LD A,(HL)		; PSG register
    LD C,A
    CALL READPSG	; read current value of PSG register
    INC HL
    LD D,A
    LD A,(HL)		; amount to add/subtract
    XOR 64			; toggle bit 6 back: amount is stored with toggled bit 6
    ADD A,D			;          (to prevent 'reserved' data bytes in range '248-255')
    LD B,A
    CALL WRTPSG		; write changed value to PSG register
    INC HL
    JP EFFPSGOPN

EFFPSGFOR:   		; start inner/outer loop (iterate PSG register value)
    PUSH HL      
    POP IX
    INC HL
    LD A,(IX+5)		; PSG register
    LD B,(HL)		; PSG value
    CALL WRTPSG2
    LD E,(IX+4)		; how many up/down per iteration
    LD A,(IX+3)		; iterate upwards (0) or downwards (1)
    CP 1
    LD A,B
    JR Z,EFFPSGFORB
    ADD A,E			; iterate upwards, so do ADD
    JR EFFPSGFORC

EFFPSGFORB:  
    SUB E			; iterate down, so do SUB
EFFPSGFORC:  
    LD (HL),A
    LD BC,6
    ADD HL,BC		; HL now points to data after the 'FOR' (things to do within the loop)
    JP EFFPSGOPN

EFFPSGSND:   		; set PSG register to a value
    INC HL
EFFPSGSNDB:  
    LD A,(HL)		; A = PSG register
    INC HL
    LD B,(HL)		; B = value
    CALL WRTPSG2	; PSG reg(A) = B
    INC HL
    LD A,(HL)
    CP 248			; < 248 means: set another PSG register 
    JP C,EFFPSGSNDB
    JP EFFPSGOPN

EFFPSGINT:			; quit sound effect processing, proceed at next interrupt
    INC HL
    LD (EFFPSGBUF),HL
    RET

EFFPSGNXT:			; outer loop 'next': go to next iteration
    PUSH HL
    LD A,255
    LD B,A
    CPDR			; search backwards for 255, which indicates start of outer loop
    INC HL			; after this: (HL) = 255
    PUSH HL
    POP IX
    LD A,(IX+1)		; 'from' value of the loop
    CP (IX+2)		; 'to' value of the loop
    JP Z,EFFPSGNXTB	; equal? then loop is finished
    POP BC			; do not 'POP HL' so that HL points to start of loop (next iteration)
    JP EFFPSGOPN

EFFPSGNXTB:  		; loop is finished
    LD A,(IX+6)		; copy of original 'from' value
    LD (IX+1),A		; restore loop variable to original 'from' value
    POP HL
    INC HL			; HL now points to data right after the loop
    JP EFFPSGOPN

EFFPSGNX2:			; inner loop 'next': go to next iteration
    PUSH HL
    LD A,250
    LD B,A
    CPDR			; search backwards for 250, which indicates start of inner loop
    INC HL			; after this: (HL) = 250
    PUSH HL
    POP IX
    LD A,(IX+1)		; 'from' value of the loop
    CP (IX+2)		; 'to' value of the loop
    JP Z,EFFPSGNX2B	; equal? then loop is finished
    POP BC			; do not 'POP HL' so that HL points to start of loop (next iteration)
    JP EFFPSGOPN

EFFPSGNX2B:  		; loop is finished
    LD A,(IX+6)		; copy of original 'from' value
    LD (IX+1),A		; restore loop variable to original 'from' value
    POP HL
    INC HL			; HL now points to data right after the loop
    JP EFFPSGOPN

EFFPSGEND:			; end of PSG sound effect (defined by 251)
    XOR A
    LD (EFFPSGFLG),A
    RET

;----------------------------------------------------------------------------
; interrupt routine for playing FM/OPLL sound effects
; for info about data format of ANMA sound effect, see bottom of this file.
; (in this data format, byte values 248 until 255 have a special meaning)
;----------------------------------------------------------------------------
EFFFMPBEG:
    LD IY,OPLLREGS	; array that holds RAM-copy of each FM/OPLL register value
    LD	A,(EFFFMPFLG)
    OR	A			; A=0 => nothing to do
    RET	Z
    DEC	A			; A=1 => busy playing sound effect
    JR Z,EFFFMPBEGB
    DEC A			; A=2 => new sound effect
    RET NZ
EFFFMPNEW:
    LD	A,1			; initialize new sound effect
    LD (EFFFMPFLG),A
    LD IX,(EFFFMPBUF)
	; below: restore counters in sound effect data (used by loops)  
EFFFMPNEWB:
    LD A,(IX+0)
    CP 251			; end of sound effect?
    RET Z
    CP 255			; outer loop starts here in sound effect data
    JP Z,FFFMPNEWC
    CP 250			; inner loop starts here in sound effect data
    JP Z,FFFMPNEWC
    INC IX
    JP EFFFMPNEWB

FFFMPNEWC:
    LD A,(IX+6)		; a copy of the loop 'from value' resides here
    LD (IX+1),A		; the loop 'from value' (counts up or down)
    INC IX
    JP EFFFMPNEWB
	; below: process FM sound effect, based on ANMA's sound effect data language
EFFFMPBEGB:
    LD HL,(EFFFMPBUF)
EFFFMPOPN:
    LD A,(HL)		; read byte from sound effect data...
    INC A
    JR Z,EFFFMPFOR	; if 255, start outer loop (255,from,to,up/down,step,reg,from_copy)
    INC A
    JR Z,EFFFMPSND	; if 254, set FM/OPLL register (254,reg,data,..,..)
    INC A
    JR Z,EFFFMPINT	; if 253, wait one interrupt
    INC A
    JR Z,EFFFMPNXT	; if 252, go to next iteration of outer loop
    INC A
    JP Z,EFFFMPEND	; if 251, end of sound effect
    INC A
    JR Z,EFFFMPFOR	; if 250, start inner loop (250,from,to,up/down,step,reg,from_copy)
    INC A
    JR Z,EFFFMPNX2	; if 249, go to next iteration of inner loop
    INC A
    RET NZ
EFFFMPCHG:   		; if 248, add/subtract to/from FM register (248,reg,amount XOR 64)
    INC	HL
    LD A,(HL)		; FM/OPLL register
    LD B,A
    CALL READFMP	; read current value of FM register (copy in RAM)
    INC HL
    LD C,A
    LD A,(HL)		; amount to add/subtract
    XOR 64			; toggle bit 6 back: amount is stored with toggled bit 6
    ADD A,C			;          (to prevent 'reserved' data bytes in range '248-255')
    LD E,A
    LD A,B
    CALL WRTFMP		; write changed value to FM/OPLL register
    INC HL
    JP EFFFMPOPN

EFFFMPFOR:   		; start inner/outer loop (iterate FM/OPLL register value)
    PUSH HL
    POP IX
    INC HL
    LD A,(IX+5)		; A = register
    LD E,(HL)		; E = value
    CALL WRTFMP
    LD B,(IX+4)		; how many up/down per iteration
    LD A,(IX+3)		; iterate upwards (0) or downwards (1)
    CP 1
    LD A,E
    JR Z,EFFFMPFORB
    ADD A,B			; iterate upwards, so do ADD
    JR EFFFMPFORC

EFFFMPFORB:  
    SUB B			; iterate down, so do SUB
EFFFMPFORC:  
    LD (HL),A
    LD BC,6			; HL now points to data after the 'FOR' (things to do within the loop)
    ADD HL,BC
    JP EFFFMPOPN

EFFFMPSND:   		; set FM/OPLL register to a value
    INC HL
EFFFMPSNDB:  
    LD A,(HL)		; A = FM/OPLL register
    INC HL
    LD E,(HL)		; E = value
    CALL WRTFMP		; FM reg(A) = E
    INC HL
    LD A,(HL)
    CP 248			; < 248 means: set another FM/OPLL register 
    JP C,EFFFMPSNDB
    JP EFFFMPOPN

EFFFMPINT:			; quit sound effect processing, proceed at next interrupt 
    INC HL
    LD (EFFFMPBUF),HL
    RET

EFFFMPNXT:			; outer loop 'next': go to next iteration   
    PUSH HL
    LD A,255
    LD B,A
    CPDR			; search backwards for 255, which indicates start of outer loop
    INC HL			; after this: (HL) = 255
    PUSH HL
    POP IX
    LD A,(IX+1)		; 'from' value of the loop
    CP (IX+2)		; 'to' value of the loop
    JP Z,EFFFMPNXTB	; equal? then loop is finished
    POP BC			; do not 'POP HL' so that HL points to start of loop (next iteration)
    JP EFFFMPOPN

EFFFMPNXTB:  		; loop is finished
    LD A,(IX+6)		; copy of original 'from' value
    LD (IX+1),A		; restore loop variable to original 'from' value
    POP HL
    INC HL			; HL now points to data right after the loop
    JP EFFFMPOPN

EFFFMPNX2:			; inner loop 'next': go to next iteration
    PUSH HL
    LD A,250
    LD B,A
    CPDR			; search backwards for 250, which indicates start of inner loop
    INC HL			; after this: (HL) = 250
    PUSH HL
    POP IX
    LD A,(IX+1)		; 'from' value of the loop
    CP (IX+2)		; 'to' value of the loop
    JP Z,EFFFMPNX2B	; equal? then loop is finished
    POP BC			; do not 'POP HL' so that HL points to start of loop (next iteration)
    JP EFFFMPOPN

EFFFMPNX2B:  		; loop is finished
    LD A,(IX+6)		; copy of original 'from' value
    LD (IX+1),A		; restore loop variable to original 'from' value
    POP HL
    INC HL			; HL now points to data right after the loop
    JP EFFFMPOPN

EFFFMPEND:			; end of FM/OPLL sound effect (defined by 251)
    XOR A
    LD (EFFFMPFLG),A
    LD BC,(REPVARDATA+25+3)	; B = (REPVARDATA+25+4) = music instrument and volume of channel FM1
	LD C,48					; Reg. 48 (instrument and volume of channel FM1)
    JP WRTOPLL				; Restore instrument and volume of music (due to end of sound effect)

EFFFMPBUF:
    DW 0			; points to FM/OPLL sound effect data while playing sound effect

;----------------------------------------------------------------------------
; FM/OPLL registers:
; - write to register and buffer value in RAM
; - read from buffered value in RAM, not from FM/OPLL register
;----------------------------------------------------------------------------

; write to FM/OPLL (FMPAC) register, also store a copy of the value in RAM
; input: A = register, E = value, ensure that IY = OPLLREGS
WRTFMP:
    OUT (07CH),A   
    LD (WRTFMPB+2),A  	; modify instruction below (index 0 becomes FM/OPLL register)...
WRTFMPB:
    LD (IY+0),E			; modified to: LD (IY+[writtenValue]),E  ->  store value of FM register
    NOP
    NOP
    PUSH AF
    LD A,E
    OUT (07DH),A
    POP AF
    RET

; read value of FM/OPLL register (from a copy in RAM)
; input: A = register, ensure that IY = OPLLREGS
READFMP:
    LD (READFMPB+2),A  	; modify instruction below (index 0 becomes FM/OPLL register)...
READFMPB:
    LD A,(IY+0)			; modified to: LD A,(IY+[writtenValue])  ->  read value of FM register
    RET

; values written to FM/OPLL chip (by some routines like WRTFMP) are stored here:
OPLLREGS:
    DS	60 				; (OPLLREGS+0) = register 0, (OPLLREGS+1) = register 1, etc...

	
;----------------------------------------------------------------------------
; Routines about setting volume and speed of music
;----------------------------------------------------------------------------
	
; Set max volume for PSG and FM (balance), call this before song initialization
; input: B=vol.decrease FM  (Max volume = 15-B . For example use 1 for max volume 14)
;        C=vol.decrease PSG (Max volume = 15-C . For example use 1 for max volume 14)
SETMAXVOLU:
    LD A,B
    LD (CPDECVOLUFM+1),A  ; modify instruction: CP 0 -> CP [modifiedValue]
    LD (REPDECVOLUFM),A   ; value in (REPDECVOLUFM) will change during fading music volume
    LD A,C
    LD (CPDECVOLUPSG+1),A  ; modify instruction: CP 0 -> CP [modifiedValue]
    LD (REPDECVOLUPSG),A   ; value in (REPDECVOLUPSG) will change during fading music volume
    RET

; Set volumes for PSG and FM. Call this while playing music.
; Volume decrease (set using SETMAXVOLU to balance PSG / FM volumes) is automatically subtracted.
; input: B=volume FM
;        C=volume PSG
SETVOLUMES:
    LD HL,CPDECVOLUPSG+1 	; (CPDECVOLUPSG+1) is 0 unless changed by SETMAXVOLU (=vol.decrease PSG)
    LD A,C					; desired PSG volume
    XOR 0Fh					; A = (15 - desired PSG volume). 
    ADD A,(HL)				; Result is total decrease from max volume. 
    CP 16					; This total volume decrease should be between 0 and 15
    JR C,SETVOLUMESB		; Go on if A < 16
    LD A,15					; otherwise, make it 15 (max volume decrease)
SETVOLUMESB:
    LD (REPDECVOLUPSG),A    ; store here how much should be decreased from PSG volumes
    LD HL,CPDECVOLUFM+1 	; (CPDECVOLUFM+1) is 0 unless changed by SETMAXVOLU (=vol.decrease FM)
    LD A,B					; desired FM volume
    XOR 0Fh					; A = (15 - desired FM volume). 
    ADD A,(HL)				; Result is total decrease from max volume. 
    CP 16					; This total volume decrease should be between 0 and 15
    JR C,SETVOLUMESC		; Go on if A < 16
    LD A,15					; otherwise, make it 15 (max volume decrease)
SETVOLUMESC:
    LD (REPDECVOLUFM),A		; store here how much should be decreased from FM volumes
    JP REPLAYROUU			; perform the change in PSG and OPLL volume registers

; Change music tempo
; input: A=amount of interrupts between steps (shortest note, same as a line in tracker RED)
OTHERSPEED:
    LD (REPSPEED),A
    RET

; Turn off volume on all channels PSG and FM.
; Call VOLONAGAIN to restore.
VOLUMESOFF:
	; prepare loop to buffer PSG volumes
    LD BC,0308H		; 3 channels (B), start at PSG reg 8 (C)
    LD HL,PSGVOLUBUF; 3-byte buffer to store PSG volumes
VOLBUFLOOP:
    LD A,C
    CALL READPSG	; read volume...
    LD (HL),A		; ...and store
    INC HL
    INC C
    DJNZ VOLBUFLOOP ; iterate until PSG channel 3 done
	; prepare loop to set PSG volumes to 0	
    LD BC,0308H		; 3 channels (B), start at reg 8 (C)
    XOR A
SETVOLZERO:
    CALL WRTPSG3	; set PSG volume to 0
    INC C
    DJNZ SETVOLZERO ; iterate until PSG channel 3 done
    LD BC,040FH		; FM/OPLL reg15=4 will mute all FM channels
    JP WRTOPLL

PSGVOLUBUF:
    DB 0,0,0		; to store volumes of PSG channels 1,2,3
     
; Restore volume on all channels PSG and FM.	 
VOLONAGAIN:
    LD HL,PSGVOLUBUF; the stored PSG volumes
    LD BC,0308H		; 3 channels (B), start at reg 8 (C)
VOLONLOOP:
    LD A,(HL)
    CALL WRTPSG3	; restore PSG volume
    INC HL			; next position in buffer
    INC C			; next PSG register
    DJNZ VOLONLOOP	; iterate until PSG channel 3 done
    LD BC,000FH		; FM/OPLL reg15=0 will unmute all FM channels
    JP WRTOPLL

;----------------------------------------------------------------------------------------
; The data below (70 bytes) is used by some effect routines (e.g. COPYVAR)
; to store data while processing certain effects. 
; This data is accessed using 'IX-BOS+i' , where IX = REPMUSDATA + channelOffset
;                        ( i = 0/1/2/3/4 , channelOffset = 0/5/10/15/./././65 )
;----------------------------------------------------------------------------------------
EFFROUTBUF:
    DB	0,0,0,0,0   ;PSG channel 1
    DB	0,0,0,0,0   ;PSG channel 2
    DB	0,0,0,0,0   ;PSG channel 3
    DB	0,0,0,0,0   ;FM/OPLL Drums channel
    DB	0,0,0,0,0   ;channel to set FM/OPLL Instrument-0
    DB	0,0,0,0,0   ;FM/OPLL channel 1
    DB	0,0,0,0,0   ;FM/OPLL channel 2
    DB	0,0,0,0,0   ;FM/OPLL channel 3
    DB	0,0,0,0,0   ;FM/OPLL channel 4
    DB	0,0,0,0,0   ;FM/OPLL channel 5
    DB	0,0,0,0,0   ;FM/OPLL channel 6
    DB	0,0,0,0,0   ;FM/OPLL channel 7
    DB	0,0,0,0,0   ;FM/OPLL channel 8
    DB	0,0,0,0,0   ;FM/OPLL channel 9

;----------------------------------------------------------------------------------------

; BOS: bytes that the EFFROUTBUF structure is below REPMUSDATA in memory
; If IX points to REPMUSDATA, then IX-BOS points to EFFROUTBUF
BOS:	EQU		(REPMUSDATA - EFFROUTBUF)		; BOS = 81


;----------------------------------------------------------------------------
; The data below (11 bytes) is general data about the song.
; It is copied to here from the song data when starting a new song (INITMUSDAT)
;----------------------------------------------------------------------------
REPMUSMODE:  
    DB	0			; 9 FM channels and no drums (0) / 6 FM channels with drums (1)
REPDRUMFRQ:  
    DB	100,100,100	; Frequencies of drums (to set pitch of base, snare, tom)
REPSPEED:    
    DB	10			; Speed of music (number of interrupts per step)
REPLASTLIN:  
    DW	63			; Number of last step of song
REPNEWLINE:  
    DW	0			; Step to start when song is repeated
REPHERHAAL:  
    DB	1			; Do repeat after end of song (1) or not (0)
REPSTARTIN:  
    DB	0			; Initial Volume (=high nibble) & Instrument (=low nibble)
					; for all channels (set in tracker RED with CTRL-TAB)

;----------------------------------------------------------------------------------------
; The data below (70 bytes) is per-channel data of the song.
; It is copied to here from the song data when starting a new song (INITMUSDAT)
; It is also copied to here from (another part of) the song data when the song
; must be repeated (song might start at another point after repeat).
;----------------------------------------------------------------------------------------
REPMUSDATA:
    DB	0,0,0,0,0   ;PSG channel 1
    DB	0,0,0,0,0   ;PSG channel 2
    DB	0,0,0,0,0   ;PSG channel 3
    DB	0,0,0,0,0   ;FM/OPLL Drums channel
    DB	0,0,0,0,0   ;channel to set FM/OPLL Instrument-0
    DB	0,0,0,0,0   ;FM/OPLL channel 1
    DB	0,0,0,0,0   ;FM/OPLL channel 2
    DB	0,0,0,0,0   ;FM/OPLL channel 3
    DB	0,0,0,0,0   ;FM/OPLL channel 4
    DB	0,0,0,0,0   ;FM/OPLL channel 5
    DB	0,0,0,0,0   ;FM/OPLL channel 6
    DB	0,0,0,0,0   ;FM/OPLL channel 7
    DB	0,0,0,0,0   ;FM/OPLL channel 8
    DB	0,0,0,0,0   ;FM/OPLL channel 9

	; Above data structure contains 5 bytes for each channel:
	;    byte 0 :  is this channel on (1) or off (0).
	;    byte 1 :  this is a counter (after how many steps should the next note be played?)
	;    byte 2 :  memory map where data of this channel resides [NOT USED, see below...]
	;    byte 3/4: location of the current note of this track within song data
	; (when counter becomes 0, new note should be played and RAM location is upped by 4)
	; (byte 2 / memory map is only used in version of replayer made for tracker RED)
;----------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
; The data below (70 bytes) is used by the replayer to store per-channel data
; needed for efficient processing.
; Sometimes this data is accessed using 'IX+VOS+i' , where IX = REPMUSDATA + channelOffset
;                             ( i = 0/1/2/3/4 , channelOffset = 0/5/10/15/./././65 )
;----------------------------------------------------------------------------------------
REPVARDATA:
    DB	0,0,0,0,0   ;PSG channel 1
    DB	0,0,0,0,0   ;PSG channel 2
    DB	0,0,0,0,0   ;PSG channel 3
    DB	0,0,0,0,0   ;FM/OPLL Drums channel
    DB	0,0,0,0,0   ;channel to set FM/OPLL Instrument-0
    DB	0,0,0,0,0   ;FM/OPLL channel 1
    DB	0,0,0,0,0   ;FM/OPLL channel 2
    DB	0,0,0,0,0   ;FM/OPLL channel 3
    DB	0,0,0,0,0   ;FM/OPLL channel 4
    DB	0,0,0,0,0   ;FM/OPLL channel 5
    DB	0,0,0,0,0   ;FM/OPLL channel 6
    DB	0,0,0,0,0   ;FM/OPLL channel 7
    DB	0,0,0,0,0   ;FM/OPLL channel 8
    DB	0,0,0,0,0   ;FM/OPLL channel 9

	; Above data structure contains 5 bytes for each channel:
	;    byte 0/1: current location within effect declaration, for example 'EFFPSG3'
	;    byte 2  : copy of sound chip register that holds the pitch (coarse pitch/octave)
	;    byte 3  : copy of sound chip register that holds the pitch (fine pitch)
	;    byte 4  : copy of sound chip register that holds volume & instrument (PSG: volume only)
;----------------------------------------------------------------------------------------

; VOS: bytes that the REPVARDATA structure is above REPMUSDATA in memory
; If IX points to REPMUSDATA, then IX+VOS points to REPVARDATA
VOS:	EQU		(REPVARDATA - REPMUSDATA)			; VOS = 70


;----------------------------------------------------------------------------
; Routines that initiate fading in/out music volume
;----------------------------------------------------------------------------

; Start fading out music volume
; input: B=fading speed
SETVOLUDEC:
    LD A,1
SETVOLUDCB:
    LD (CHANGEVOL),A
    LD C,B
    LD (CHGVOLWERK),BC	; (CHGVOLWERK) = (CHGVOLTIME) = fading speed (B)
    RET

; Start fading in music volume
; input: B=fading speed
SETVOLUINC:
    LD A,255
    JR SETVOLUDCB

;----------------------------------------------------------------------------
; Below a list of all PSG effects. These are just pointers to the data that
; describes each effect. When playing a song, everything is done with effects,
; even playing normal notes.
; The most basic effects are 3 (play note) and 4 (play note with volume/instrument).
; There are also effects for sliding, vibration, arpeggio, PSG drums, and more.
; All these effects correspond to the effects in the tracker RED (ANMA's music
; Recorder & EDitor), except that the notation in RED is hexadecimal.
; So, for example EFFPSG46 corresponds to effect '2E' in the tracker RED.
;----------------------------------------------------------------------------
PSGEFFECTS:
    DW EFFECT0 ; (empty effect, do nothing)
    DW EFFPSG1 ; turn off this channel abruptly
    DW EFFPSG2 ; turn off this channel quickly, but not abruptly
	; Standard effects, very often used:
    DW EFFPSG3 ; play a note (same volume as last note)
    DW EFFPSG4 ; play a note with specified volume
    DW EFFPSG5 ; play note with volume, decrease volume every x interrupts
	; miscellaneous effects:
    DW EFFPSG6 ; fade out volume: decrease volume every x interrupts
    DW EFFPSG7 ; play note, turn off volume after x interrupts, then on after x interrupts, repeat
    DW EFFPSG8 ; play note, turn off volume after x interrupts
    DW EFFPSG9 ; stop current effect
	; Pitch/frequency slide effects (between 10 and 25)
    DW EFFPSG10 ; play note, slide pitch UP by x every interrupt (also set volume)
    DW EFFPSG11 ; slide pitch UP by x every interrupt (also set volume)
    DW EFFPSG12 ; play note, slide pitch UP by (x+16) every interrupt (also set volume)
    DW EFFPSG13 ; slide pitch UP by (x+16) every interrupt (also set volume)
    DW EFFPSG14 ; play note, slide pitch UP by 1 every x interrupts (also set volume)
    DW EFFPSG15 ; slide pitch UP by 1 every x interrupts (also set volume)
    DW EFFPSG16 ; play note, slide pitch DOWN by x every interrupt (also set volume)
    DW EFFPSG17 ; slide pitch DOWN by x every interrupt (also set volume)
    DW EFFPSG18 ; play note, slide pitch DOWN by (x+16) every interrupt (also set volume)
    DW EFFPSG19 ; slide pitch DOWN by (x+16) every interrupt (also set volume)
    DW EFFPSG20 ; play note, slide pitch DOWN by 1 every x interrupts (also set volume)
    DW EFFPSG21 ; slide pitch DOWN by 1 every x interrupts (also set volume)
    DW EFFPSG22 ; just once, slide pitch UP by x (also set volume)
    DW EFFPSG23 ; just once, slide pitch UP by (x+16) (also set volume)
    DW EFFPSG24 ; just once, slide pitch DOWN by x (also set volume)
    DW EFFPSG25 ; just once, slide pitch DOWN by (x+16) (also set volume)
	; miscellaneous effects:
    DW EFFPSG26 ; same as EFFPSG4 (for FM/OPLL there is a difference)
    DW EFFPSG27 ; only change volume
	; pitch/frequency vibration effects (between 28 and 35):
    DW EFFPSG28 ; play note, vibrate every x interrupts with pitch offset 2 (also set volume)
    DW EFFPSG29 ; vibrate every x interrupts with pitch offset 2 (also set volume)
    DW EFFPSG30 ; play note, vibrate every x interrupts with pitch offset 5 (also set volume)
    DW EFFPSG31 ; vibrate every x interrupts with pitch offset 5 (also set volume)
    DW EFFPSG32 ; play note, vibrate every x interrupts with pitch offset 12 (also set volume)
    DW EFFPSG33 ; vibrate every x interrupts with pitch offset 12 (also set volume)
    DW EFFPSG34 ; play note, vibrate every x interrupts with pitch offset 20 (also set volume)
    DW EFFPSG35 ; vibrate every x interrupts with pitch offset 20 (also set volume)
	; pitch/frequency waving effects (between 36 and 43):
    DW EFFPSG36 ; play note, slide down 1 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG37 ; slide down 1 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG38 ; play note, slide down 2 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG39 ; slide down 2 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG40 ; play note, slide down 4 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG41 ; slide down 4 during x interrupts, then up, repeat (also set volume)
    DW EFFPSG42 ; play note, slide down 1 every 1 in 2 interrupts for x times, then up, repeat (also set volume)
    DW EFFPSG43 ; slide down 1 every 1 in 2 interrupts for x times, then up, repeat (also set volume)
	; Arpeggio effects (fast alternating real note pitches)
    DW EFFPSG44 ; arpeggio without repeating (notes that alternate can be controlled)
    DW EFFPSG45 ; arpeggio (keeps repeating) (notes that alternate can be controlled)
    DW EFFPSG46 ; arpeggio (keeps repeating), also decrease volume (notes that alternate can be controlled)
    DW EFFPSG47 ; arpeggio (keeps repeating), also decrease volume slowly (notes that alternate can be controlled)
	; Change song speed
    DW EFFPSG48 ; set speed of song (to change speed while playing song)
	; Volume waving effects (between 49 and 54):
    DW EFFPSG49 ; play note, decrease volume with 1 for x interrupts, then increase, repeat
    DW EFFPSG50 ; decrease volume with 1 for x interrupts, then increase, repeat
    DW EFFPSG51 ; play note, decrease volume with 1 every 1 in 2 interrupts (x times), then increase, repeat
    DW EFFPSG52 ; decrease volume with 1 every 1 in 2 interrupts (x times), then increase, repeat
    DW EFFPSG53 ; play note, decrease volume with 1 every 1 in 4 interrupts (x times), then increase, repeat
    DW EFFPSG54 ; decrease volume with 1 every 1 in 4 interrupts (x times), then increase, repeat
	; Volume increase effects
    DW EFFPSG55 ; play note with volume, increase volume every x interrupts
    DW EFFPSG56 ; only increase volume every x interrupts
	; Volume decrease and vibrate effects (between 57-59):
    DW EFFPSG57 ; decrease volume with 3 after x interrupts, then increase with 2 after x interrupts, repeat
    DW EFFPSG58 ; decrease volume with 4 after x interrupts, then increase with 2 after x interrupts, repeat
    DW EFFPSG59 ; decrease volume with 6 after x interrupts, then increase with 3 after x interrupts, repeat
	; Out-of-pitch effect:
    DW EFFPSG60 ; play note with small pitch deviation (x), also set volume (to create richer synth-like sounds)
	; unused effects:
    DW EFFPSG61 ; (unused, do nothing)
    DW EFFPSG62 ; (unused, do nothing)
    DW EFFPSG63 ; (unused, do nothing)
	; Special PSG effects (mostly drums):
    DW EFFPSG64 ; special PSG noise-drum (use on PSG1 only) - bring volume down very quick
    DW EFFPSG65 ; special PSG noise-drum (use on PSG1 only) - ...less quick
    DW EFFPSG66 ; special PSG noise-drum (use on PSG1 only) - ...not very quick
    DW EFFPSG67 ; special PSG noise-drum (use on PSG1 only) - ...slowly
    DW EFFPSG68 ; special PSG noise-drum (use on PSG1 only) - turn off after 2 interrupts
    DW EFFPSG69 ; special PSG noise-drum (use on PSG1 only) - ...after 3 interrupts
    DW EFFPSG70 ; special PSG noise-drum (use on PSG1 only) - ...after 5 interrupts
    DW EFFPSG71 ; special PSG noise-drum (use on PSG1 only) - ...after 8 interrupts
    DW EFFPSG72 ; special PSG drum (kind of base drum)
    DW EFFPSG73 ; special PSG noise-drum (use on PSG1 only)
    DW EFFPSG74 ; special PSG noise-drum (use on PSG1 only) - noise with high pitch
    DW EFFPSG75 ; special PSG noise-drum (use on PSG1 only) - noise (short) with high pitch
    DW EFFPSG76 ; special PSG noise-drum (use on PSG1 only) - kind of snare drum (noise and pitch can be set)
    DW EFFPSG77 ; special PSG noise-drum (use on PSG1 only) - another snare drum
    DW EFFPSG78 ; play note, decrease volume by 1 for x interrupts, keep playing note at lower volume
    DW EFFPSG79 ; special PSG noise-drum (use on PSG1 only) - slide noise freq. down
    DW EFFPSG80 ; special PSG noise-drum (use on PSG1 only) - slide noise freq. up
    DW EFFPSG81 ; special PSG drum (kind of base drum)

	
;----------------------------------------------------------------------------
; Below a list of all FM/OPLL effects. These are just pointers to the data that
; describes each effect. When playing a song, everything is done with effects,
; even playing normal notes.
; Most effects are functional equivalent to the PSG effects. 
; Some special PSG drum/noise effects are not possible/needed with FM/OPLL.
;----------------------------------------------------------------------------
FMPEFFECTS:  
    DW EFFECT0 ; (empty effect, do nothing)
    DW EFFFM1  ; functional equivalent to EFFPSG1
    DW EFFFM2  ; functional equivalent to EFFPSG2 (but SUSTAIN bit of OPLL/FM is used)
    DW EFFFM3  ; functional equivalent to EFFPSG3
    DW EFFFM4  ; functional equivalent to EFFPSG4
    DW EFFFM5  ; functional equivalent to EFFPSG5
    DW EFFFM6  ; functional equivalent to EFFPSG6
    DW EFFFM7  ; functional equivalent to EFFPSG7
    DW EFFFM8  ; functional equivalent to EFFPSG8
    DW EFFFM9  ; functional equivalent to EFFPSG9
    DW EFFFM10 ; functional equivalent to EFFPSG10
    DW EFFFM11 ; functional equivalent to EFFPSG11
    DW EFFFM12 ; functional equivalent to EFFPSG12
    DW EFFFM13 ; functional equivalent to EFFPSG13
    DW EFFFM14 ; functional equivalent to EFFPSG14
    DW EFFFM15 ; functional equivalent to EFFPSG15
    DW EFFFM16 ; functional equivalent to EFFPSG16
    DW EFFFM17 ; functional equivalent to EFFPSG17
    DW EFFFM18 ; functional equivalent to EFFPSG18
    DW EFFFM19 ; functional equivalent to EFFPSG19
    DW EFFFM20 ; functional equivalent to EFFPSG20
    DW EFFFM21 ; functional equivalent to EFFPSG21
    DW EFFFM22 ; functional equivalent to EFFPSG22
    DW EFFFM23 ; functional equivalent to EFFPSG23
    DW EFFFM24 ; functional equivalent to EFFPSG24
    DW EFFFM25 ; functional equivalent to EFFPSG25
    DW EFFFM26 ; sets pitch of a real note without 'starting' a new note
    DW EFFFM27 ; functional equivalent to EFFPSG27
    DW EFFFM28 ; functional equivalent to EFFPSG28
    DW EFFFM29 ; functional equivalent to EFFPSG39
    DW EFFFM30 ; functional equivalent to EFFPSG30
    DW EFFFM31 ; functional equivalent to EFFPSG31
    DW EFFFM32 ; functional equivalent to EFFPSG32
    DW EFFFM33 ; functional equivalent to EFFPSG33
    DW EFFFM34 ; functional equivalent to EFFPSG34
    DW EFFFM35 ; functional equivalent to EFFPSG35
    DW EFFFM36 ; functional equivalent to EFFPSG36
    DW EFFFM37 ; functional equivalent to EFFPSG37
    DW EFFFM38 ; functional equivalent to EFFPSG38
    DW EFFFM39 ; functional equivalent to EFFPSG39
    DW EFFFM40 ; functional equivalent to EFFPSG40
    DW EFFFM41 ; functional equivalent to EFFPSG41
    DW EFFFM42 ; functional equivalent to EFFPSG42
    DW EFFFM43 ; functional equivalent to EFFPSG43
    DW EFFFM44 ; functional equivalent to EFFPSG44
    DW EFFFM45 ; functional equivalent to EFFPSG45
    DW EFFFM46 ; functional equivalent to EFFPSG46
    DW EFFFM47 ; functional equivalent to EFFPSG47
    DW EFFFM48 ; functional equivalent to EFFPSG48
    DW EFFFM49 ; functional equivalent to EFFPSG49
    DW EFFFM50 ; functional equivalent to EFFPSG50
    DW EFFFM51 ; functional equivalent to EFFPSG51
    DW EFFFM52 ; functional equivalent to EFFPSG52
    DW EFFFM53 ; functional equivalent to EFFPSG53
    DW EFFFM54 ; functional equivalent to EFFPSG54
    DW EFFFM55 ; functional equivalent to EFFPSG55
    DW EFFFM56 ; functional equivalent to EFFPSG56
    DW EFFFM57 ; functional equivalent to EFFPSG57
    DW EFFFM58 ; functional equivalent to EFFPSG58
    DW EFFFM59 ; functional equivalent to EFFPSG59
    DW EFFFM60 ; functional equivalent to EFFPSG60
    DW EFFFM61 ; (empty effect, do nothing)
    DW EFFFM62 ; (empty effect, do nothing)
    DW EFFFM63 ; (empty effect, do nothing)
    DW EFFFM64 ; special FM effect: change volume/instrument without 'starting' new note
    DW EFFFM65 ; (empty effect, do nothing)
    DW EFFFM66 ; (empty effect, do nothing)
    DW EFFFM67 ; (empty effect, do nothing)
    DW EFFFM68 ; (empty effect, do nothing)
    DW EFFFM69 ; (empty effect, do nothing)
    DW EFFFM70 ; (empty effect, do nothing)
    DW EFFFM71 ; (empty effect, do nothing)
    DW EFFFM72 ; (empty effect, do nothing)
    DW EFFFM73 ; (empty effect, do nothing)
    DW EFFFM74 ; (empty effect, do nothing)
    DW EFFFM75 ; (empty effect, do nothing)
    DW EFFFM76 ; (empty effect, do nothing)
    DW EFFFM77 ; (empty effect, do nothing)
    DW EFFFM78 ; (empty effect, do nothing)
    DW EFFFM79 ; (empty effect, do nothing)
    DW EFFFM80 ; (empty effect, do nothing)
    DW EFFFM81 ; (empty effect, do nothing)

;----------------------------------------------------------------------------
; Some general data (mostly variables) needed while playing a song
;----------------------------------------------------------------------------
REPMUSADR:	
    DW	0		; location where song data (current song) starts
REPACTSTEP:  
    DW	0		; current step/row of song while playing (starting at 0)
REPCOUNTER:  
    DB	0		; counts down from (REPSPEED) to zero. If zero, a new step/row of song is due.
REPDECVOLUPSG:  
    DB	0		; PSG volume decrease. Used to lower max PSG volume. Also used during volume fade in/out
REPDECVOLUFM:   
    DB 0		; FM volume decrease. Used to lower max FM volume. Also used during volume fade in/out
CHANGEVOL:
    DB	0		; fade in/out music volume: 1 = fading out, 255 = fading in, 0 = no fading
CHGVOLWERK:  
    DB	0		; counter during fading in/out
CHGVOLTIME:  
    DB	0		; speed of fading in/out music volume (how many interrupts per fading step)
RUISFREQ:	
    DB	0		; a copy of PSG noise frequency (PSG register 6), prevents reading PSG register

;----------------------------------------------------------------------------
; Initialization of new song to play
;----------------------------------------------------------------------------

; Initialize new song
; input: HL = address where song data starts (right after 'MUSC' token that precedes the song data)
INITMUSDAT:
    DI
    LD (REPMUSADR),HL
    LD DE,REPMUSMODE		; copy 81 bytes from header of song data:
    LD BC,81				;   -> 11 of 81 bytes is general facts of song (copied to REPMUSMODE)
    LDIR					;   -> 70 of 81 bytes is per-channel data (copied to REPMUSDATA)
    XOR A
    LD (CHANGEVOL),A		; no fading in/out of music volume
    INC A
    LD (REPCOUNTER),A		; (REPCOUNTER) = 1 means new step/row will be due
    LD A,(CPDECVOLUPSG+1)	; A=0, unless changed by SETMAXVOLU (to set lower PSG volume)
    LD (REPDECVOLUPSG),A	; Max PSG volume = 15-A (can change during song, e.g. during fade in/out)
    LD A,(CPDECVOLUFM+1)	; A=0, unless changed by SETMAXVOLU (to set lower FM volume)
    LD (REPDECVOLUFM),A		; Max FM volume = 15-A (can change during song, e.g. during fade in/out)
    LD HL,0
    LD (REPACTSTEP),HL		; row/step counter of song, starting at 0
    CALL INITMUSDAZ			; set dummy 'EFFECT0' on all channels.
    LD BC,0B807H			; PSG reg7= 10 111 000  -> noise off, tone on 
    CALL WRTPSG
	; below: clear PSG registers 0 - 5
    LD BC,00600H			; counter=6, start at PSG register 0
INITMUSINC:					; start loop
    XOR A
    CALL WRTPSG3			; PSG reg(C) = A
    INC C
    DJNZ INITMUSINC
	; below: set initial instrument & volume for all FM channels
    LD IX,REPVARDATA+25		; points to channel FM1 in data structure REPVARDATA
    LD DE,5
    LD A,(REPSTARTIN)		; initial volume (=high nibble) & instrument (=low nibble)
    RRC  A					; (volume is used for both PSG and FM, instrument only for FM)
    RRC  A
    RRC  A
    RRC  A					; low/high nibble now swapped, instrument is now at high nibble (bit 4-7)
    XOR 15					; invert volume bits, because for OPLL chip: max volume=0, min volume=15
    LD BC,0930H				; start loop here (9 FM channels, start at register 030H)
INITMUSINA:
    PUSH AF
    CALL WRTVOLUFMB			; Write instrument & volume to FM reg(C)
    POP AF
    LD (IX+4),A				; also store a copy in REPVARDATA for this FM channel
    INC C					; next channel
    ADD IX,DE				; next position within REPVARDATA (+5 bytes)
    DJNZ INITMUSINA			; iterate until all 9 FM channels done
    XOR 15					; invert volume bits back to normal (as PSG chip wants to see)
    AND 15					; clear instrument (high nibble), keep volume (low nibble)
	; below: set initial volume for all PSG channels
    LD BC,0308H				; start loop here (3 PSG channels, start at register 8)
    LD IX,REPVARDATA		; points to channel PSG1 in data structure REPVARDATA
INITMUSINB:
    PUSH BC
    PUSH AF
    LD B,A
    CALL WRTVOLUPSG			; write volume to PSG register
    POP AF
    POP BC
    LD (IX+4),A				; also store a copy in REPVARDATA for this PSG channel
    INC C					; next channel
    ADD IX,DE				; next position within REPVARDATA (+5 bytes)
    DJNZ INITMUSINB			; iterate until all 3 PSG channels done
    LD BC,000EH
    CALL WRTOPLL			; reset FM drums register
    LD BC,000FH
    CALL WRTOPLL			; reg15 = 0 (unmute FM channels)
    LD A,(REPMUSMODE)		; song with drums (1) or without drums (0)
    OR A
    RET Z					; finished if song has no drums (9 FM channels instead)
	; below: set drums frequencies/pitches
	; (when drums are used, channels FM 7/8/9 are not available, but the pitch settings on
	;  these channels have effect on how the base drum, the snare drum and the tom will sound.
	;  In ANMA's tracker RED it is set by keyboard shortcuts CTRL-F9, CAPS-F9 and CTRL-CAPS-F9.
	;  In RED there is 8 bit for each pitch, but the OPLL chip needs 12 bit, so some bit
	;  manipulation is done below so that the available 8 bits are used effectively)
    LD IX,REPDRUMFRQ
    LD L,(IX+0)	; pitch value to set (for base, snare or tom)
    LD H,(IX+1)	; pitch value to set (for base, snare or tom)
    LD E,(IX+2)	; pitch value to set (for base, snare or tom)
INITDRMFRQ:
    LD D,016H			; register 016H is fine pitch of FM channel 7
    LD A,L
    CALL INITDRMFRB
    INC D				; fine pitch of FM channel 8
    LD A,H
    CALL INITDRMFRB
    INC D				; fine pitch of FM channel 9
    LD A,E
	; below: set fine & course pitch of FM channel 7/8/9 (used by OPLL drums)
	; (an 8-bit input value (A) is used to set 12-bit fine/coarse OPLL pitch registers)
INITDRMFRB:
    PUSH AF
    SLA  A
    SLA  A
    SLA  A				; use 5 of the 8 bits for fine pitch
    LD B,A
    LD C,D				; C = register 016H/017H/018H (fine pitch FM 7/8/9)
    CALL WRTOPLL		; FM reg(C) = B
    POP AF
    SRL  A
    SRL  A
    SRL  A
    SRL  A				; use 3 of the 8 bits for course pitch...
    AND  14				; ... so keep only bits 1/2/3
    OR 1				; ???
    LD B,A
    LD C,D
    SET  5,C			; switch to course pitch register...
    RES  4,C			; ... so that C = register 026H/027H/028H
    JP WRTOPLL			; FM reg(C) = B
	; below: set dummy 'EFFECT0' on all channels.
INITMUSDAZ:
    LD HL,REPVARDATA
    LD B,14				; 14 channels (9xFM, 3xPFG, drums, Instrument0)
STEP5:
    LD (MODIFY+2),HL    ; Modify address where DE (='EFFECT0') is stored, see below...
    LD DE,EFFECT0
MODIFY:      			; instruction below will be modified by code...
    LD (REPVARDATA),DE	; ... it will be REPVARDATA, REPVARDATA+5, REPVARDATA+10, etc...
    LD DE,5				; ... until REPVARDATA+65. Goal is to set 'EFFECT0' as the current
    ADD HL,DE			; ... effect on all channels. This is a dummy effect and does nothing.
    DJNZ STEP5			; loop until all 14 channels are done.
    RET

;----------------------------------------------------------------------------
; Turn off all channels
;----------------------------------------------------------------------------
ALLMUSICOFF:
    DI
    XOR A
    LD (CHANGEVOL),A	; no fading in/out of volume
    LD BC,0B807H		; PSG reg7=0B8 = 10 111 000 -> noise off, tone on
    CALL WRTPSG
    LD BC,040FH			; FM reg15=4 -> mute all FM channels
    CALL WRTOPLL
    LD C,0				; start at PSG register 0
    LD D,6				; counter for loop
ALMUSICOFB:
    LD B,0
    CALL WRTPSG			; PSG registers 0-5 are cleared in a loop
    INC C
    DEC D
    JR NZ,ALMUSICOFB
    LD BC,8
    CALL WRTPSG			; PSG reg8=0 -> volume PSG1 off
    LD IX,REPVARDATA+25 ; data about channel FM1
    LD DE,5
    LD H,9				; loop for 9 FM channels
    LD C,32				; start at OPLL/FM register 020H (coarse pitch FM1)
ALMUSICOFC:
    LD B,(IX+2)			; get coarse pitch of FM channel
    SET  5,B			; set SUSTAIN bit...
    CALL WRTOPLL		; ... this ensures currently played note will stop quickly
    ADD IX,DE			; data of next FM channel
    INC C				; next OPLL/FM register
    DEC H
    JR NZ,ALMUSICOFC	; loop until all 9 FM channels done
    JP INITMUSDAZ		; set dummy 'EFFECT0' on all channels.

;----------------------------------------------------------------------------------------------
; Below is the main interrupt routine to play the song. Things to do here:
; - check if a new step is due (a step is like a line in the tracker RED -> shortest note)
;   - if so, check if end of song is reached and repeat song if it must
;   - if not a new step:
;     - check if volume fading is going on and a if a volume change is due.
;     - if so, handle the volume change
;     - if not, handle music effects (some need action every interrupt like slides/vibrations)
; output: B=0 -> playing, no new step/note
;         B=1 -> playing, new step/note processed
;         B=2 -> end of song
;         B=3 -> song-repeat occurred
;         B=4 -> busy fading music
;         B=5 -> finished fading music
;----------------------------------------------------------------------------------------------
REPLAYROUT:
    LD HL,REPCOUNTER
    DEC (HL)			; decrease counter...
    JP Z,REPLAYROUX		; if 0, it's time to proceed to the next step/line of music.
    LD HL,CHANGEVOL 
    BIT 0,(HL)			; is there fading in/out of music volume going on?
    JP Z,REPINTERRU		; no fading in/out? Then JP and handle music-effects between steps
    INC HL				; after this, HL = CHGVOLWERK (a counter needed for fading in/out)
    DEC (HL)			; if (CHGVOLWERK) = 0, one step of fade in/out needs to be done
    JP NZ,REPINTERRU	; not yet time for a new step of fade in/out? Then JP and handle effects
	; ok, it's time to do one step of fade-in or fade-out of music
    INC HL				; after this, HL = CHGVOLTIME (holds speed of fading in/out)
    LD A,(HL)
    DEC HL				; after this, HL = CHGVOLWERK again
    LD (HL),A			; copy speed (number of interrupts) to (CHGVOLWERK) which is counter
    DEC HL				; after this, HL = CHANGEVOL again
    LD A,(REPDECVOLUPSG); current PSG volume fading level (value to be decreased from max PSG volume of 15)
    LD D,0
    ADD A,(HL)			; if fading out, then A = A+1.  If fading in, then A = A+255 = A-1
    CP 16
    JR NC,NODECVOLUPSG	; A >= 16 or A = 255 (overflow) -> fading in/out of PSG music is finished
CPDECVOLUPSG:			; the CP below can be modified by code (to set fixed max PSG volume, see SETMAXVOLU)
    CP 0				; if modified, max PSG volume is lower than 15 ('CP 2' means max volume = 15-2 = 13)
    JR C,NODECVOLUPSG	; A < [0 or modified value] means volume would go too high -> fading in is finished
    LD (REPDECVOLUPSG),A; new PSG volume fading level (max volume is now: 15-A)
    INC D				; D=1 to remember that 1 step of fading in/out (PSG) is just done.
NODECVOLUPSG:    
    LD A,(REPDECVOLUFM)	; current FM volume fading level (value to be decreased from max FM volume of 15)
    ADD A,(HL)			; if fading out, then A = A+1.  If fading in, then A = A+255 = A-1
CPDECVOLUFM:			; the CP below can be modified by code (to set fixed max FM volume, see SETMAXVOLU)
    CP 0				; if modified, max FM volume is lower than 15 ('CP 2' means max volume = 15-2 = 13)
    JR C,NODECVOLUFM	; A < [0 or modified value] means volume would go too high -> fading in is finished
    CP 16
    JR C,REPLAYROUV		; if A < 16, then change FM volume fading level
NODECVOLUFM:    		; if here, then fading in/out FM volume is finished
    BIT 0,D				; is fading in/out PSG volume also finished?
    JR NZ,REPLAYROUU	; no? go further and change the real volume registers.
    LD (HL),0			; yes? Set (CHANGEVOL) = 0, this means no fading in/out anymore
    LD B,5				; tell caller fading in/out of music volume is done
    RET

REPLAYROUV:
    LD (REPDECVOLUFM),A	; new FM volume fading level (max volume is now: 15-A)
	; if here, max volume of PSG and/or FM has changed (due to a step of fading in/out of volume)
	; the change was only in RAM, now perform the change in PSG and OPLL volume registers...
REPLAYROUU:
    LD A,(REPMUSDATA)	; PSG channel 1 on/of
    BIT 0,A			
    JR Z,REPLAYROOF		; PSG channel 1 off? Then skip lines below
    LD A,(EFFPSGFLG)	; if <>0 then PSG sound effect playing (always on channel 1)
    OR A
    JR NZ,REPLAYROOF	; Skip lines below because sound effect is busy on channel 1
    LD BC,(REPVARDATA+3); Result: B = current volume PSG1
    LD C,8				; PSG1 volume register
    CALL WRTVOLUPSG		; write PSG volume of channel 1
REPLAYROOF:
    LD IX,REPMUSDATA+5  ; buffered data about PSG channel 2 starts here
    LD DE,5
    LD H,2				; counter, 2 PSG channels to do
    LD C,9
REPLAYROUW:  			; loop starts here (PSG 2, then PSG 3)
    BIT 0,(IX+0)
    JR Z,REPLAYROUY		; skip if PSG channel is off
    LD B,(IX+VOS+4)		; REPMUSDATA + VOS = REPVARDATA. Result: B = current volume
    PUSH BC
    CALL WRTVOLUPSG		; write volume to PSG register
    POP BC
REPLAYROUY:
    ADD IX,DE			; next channel (+5 bytes)
    INC C				; increase PSG volume register
    DEC H
    JR NZ,REPLAYROUW	; iterate until all PSG channels done
    LD A,(REPMUSDATA+25); buffered data about FM channel 1 starts here
    BIT 0,A				; FM channel 1 off? Then skip lines below
    JR Z,REPLAYROUZ
    LD A,(EFFFMPFLG)	; if <>0 then FM sound effect playing (always on channel 1)
    OR A
    JR NZ,REPLAYROUZ	; Skip lines below because sound effect is busy on channel 1
    LD BC,(REPVARDATA+25+3); B = (REPVARDATA+25+4) = volume of FM channel 1
    LD C,48				; FM channel 1 volume register
    CALL WRTVOLUFMB		; write FM volume of channel 1
REPLAYROUZ:
    LD IX,REPMUSDATA+30	; buffered data about FM channel 2 starts here
    LD H,8				; counter, 8 FM channels to do
    LD C,49				; FM channel 2 volume register
REPLAYROUQ:  			; loop starts here (FM channel 2, until channel 9)
    BIT 0,(IX+0)
    JR Z,REPLAYROUP		; skip if FM channel is off
    LD B,(IX+VOS+4)		; REPMUSDATA + VOS = REPVARDATA. Result: B = current volume
    CALL WRTVOLUFMB		; write volume to FM register
REPLAYROUP:
    ADD IX,DE			; next channel
    INC C				; increase FM volume register
    DEC H
    JR NZ,REPLAYROUQ	; iterate until all FM channels done
    LD A,(REPDECVOLUFM)
    LD BC,000Fh			; prepare to set FM reg15=0  (unmute all FM channels)
    CP 15				; if (REPDECVOLUFM) = 15, this means max FM volume = 15-15 = 0
    JR NZ,REPLAYROUO	; ...if not 15, then unmute all FM channels
    LD B,04h			; ...otherwise mute all FM channels by FM reg15=4
REPLAYROUO:
    CALL WRTOPLL		; write value B to register C of OPLL/FM chip
    LD B,4				; tell caller that still busy fading music
    RET
	; below: check for end of song. If so, end the song or handle necessary repeat
	; If no end of song or repeat, then jump to code to handle new step/row.
REPLAYROUX:
    LD A,(REPSPEED)		; speed of song (number of interrupts per step)
    LD (HL),A			; (REPCOUNTER) = speed of song
    LD HL,(REPACTSTEP)	; current step of song
    LD DE,(REPLASTLIN)	; last step of song
    OR A				; clear carry flag
    SBC  HL,DE			; zero if current step = last step
    JR NZ,REPLAYB		; not end-of-song? go to REPLAYB (handle new step/line of song)
    LD A,(REPHERHAAL)	; song has ended. Should song be repeated?
    OR A
    JR Z,REPLAYC		; no repeat -> go to REPLAYC (end of song)
    LD HL,(REPNEWLINE)	; repeat song: which step to start (can be other than 0)
    LD (REPACTSTEP),HL	; make it the current step
    LD HL,(REPMUSADR)	; HL = RAM address where music data starts
    LD DE,81			; go to offset 81 (11 + 70) within music data...
    ADD HL,DE			; ...here is per-channel data needed to repeat the song...
    LD DE,REPMUSDATA
    LD BC,70			; ...there is 5 bytes for each of the 14 channels (=70 bytes)
    LDIR				; copy to internal structure REPMUSDATA
    LD A,1
    LD (REPCOUNTER),A	; (REPCOUNTER) = 1 means a new step is due
    LD B,3				; tell caller that the song has been repeated
    RET
	; below: song has ended
REPLAYC:
    LD B,2				; tell caller that the song has ended
    RET

;----------------------------------------------------------------------------------------------
; The routine REPLAYB below is called when a new step/row is due (like a line in tracker RED)
; Things to do here:
; - Increase step number (to be able to later detect end-of-song)
; - for each channel call a routine to handle the new step. There are separate routines for:
;   - channel FM1 (sound effect can be active on this channel)         (see REPINITFMP1)
;   - other FM channels                                                (see REPINITFMP)
;   - channel PSG1 (sound effect can be active on this channel)        (see REPINITPSA)
;   - other PSG channels                                               (see REPINITPSG)
;   - Drum channel                                                     (see REPINITDRM)
;   - Instrument-0 channel                                             (see REPINITIN0)
;----------------------------------------------------------------------------------------------
; Here some info about how song data is stored (needed to understand routines below):
;----------------------------------------------------------------------------------------------
; For all PSG and FM/OPLL channels, each note takes 4 bytes and is coded like this in song data:
;                 byte 0:   byte 1:   byte 2:   byte 3:
;                 eeeeeeee  iiiivvvv  nnnnnnnn  cccccccc
;    e = 8 bits => number of effect (e.g. effect nr. 5 plays a note and decreases volume)
;    i = 4 bits => instrument (if FM channel) (but can be any data like counters, amounts, ...)
;    v = 4 bits => volume (but can be any data, depending of effect number...)
;    n = 8 bits => the note to play (e.g.: C#4)
;    c = 8 bits => counter (how many steps/lines to skip before the next note is due?)
;----------------------------------------------------------------------------------------------
; For the drum channel (DR in tracker RED), a beat takes 4 bytes and is coded like this in song data:
;                 byte 0:   byte 1:   byte 2:   byte 3:
;                 vvvvvvvv  vvvvvvvv  vvvvdddd  dxccccccc
;    v = 20 bits => volume (4 bits for each of the 5 drum types)
;    d =  5 bits => flag per drum used (Base, Snare, Tom, Top Cymbal, High hat)
;    x =  1 bit  => if 0, do nothing (only skip more steps/rows -> used when drums are >64 lines apart)
;    c =  6 bits => counter (how many steps/lines to skip before the next beat is due?)
;----------------------------------------------------------------------------------------------
; For Instrument-0 channel (IN in tracker RED), a Instr-0 change takes 10 bytes and is coded like this:
; byte 0:  byte 1:  byte 2:  byte 3:  byte 4:  byte 5:  byte 6:  byte 7:  byte 8:  byte 9:
; xxxxxxxx iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii cccccccc
;    x =  8 bits => if value is 0, do nothing (only use counter to skip more steps/rows)
;    i = 64 bits => OPLL instrument-0 data (goes into OPLL registers 0-7)
;    c =  8 bits => counter (how many steps/lines to skip before the next Instr-0 change is due?)
;----------------------------------------------------------------------------------------------
REPLAYB:
	LD HL,(REPACTSTEP)
    INC HL				; increase step number of song
    LD (REPACTSTEP),HL
    LD BC,4				; each note takes 4 bytes in song data (except for Instrument-0 channel)
    LD IX,REPMUSDATA
	; 3 PSG channels (see P1, P2, P3 in tracker RED)
    CALL REPINITPSA		; PSG1 (different code, because there might be a sound effect active)
    LD IX,REPMUSDATA+5
    CALL REPINITPSG		; PSG2
    LD IX,REPMUSDATA+10
    CALL REPINITPSG		; PSG3
	; Drums channel (see 'DR' in tracker RED)
    LD IX,REPMUSDATA+15
    CALL REPINITDRM
	; channel Instrument-0 (see 'IN' in tracker RED)
    LD IX,REPMUSDATA+20
    CALL REPINITIN0
	; 9 OPLL/FM channels (see F1, F2, F3, ..., F9 in tracker RED)
    LD IX,REPMUSDATA+25
    CALL REPINITFMP1	; FM1 (different code, because there might be a sound effect active)
    LD IX,REPMUSDATA+30
    CALL REPINITFMP		; FM2
    LD IX,REPMUSDATA+35
    CALL REPINITFMP		; FM3
    LD IX,REPMUSDATA+40
    CALL REPINITFMP		; FM4
    LD IX,REPMUSDATA+45
    CALL REPINITFMP		; FM5
    LD IX,REPMUSDATA+50
    CALL REPINITFMP		; FM6
    LD IX,REPMUSDATA+55
    CALL REPINITFMP		; FM7
    LD IX,REPMUSDATA+60
    CALL REPINITFMP		; FM8
    LD IX,REPMUSDATA+65
    CALL REPINITFMP		; FM9
    LD B,1				; tell caller that music proceeded to a new step/note
    RET

	; below: handle new step for channel FM1 (track 'F1' in tracker RED)
REPINITFMP1:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)			; until this counter hits zero...
    RET NZ				; ...there is no new note/effect to play on this channel
    LD L,(IX+3)				
    LD H,(IX+4)			; HL = song data location of former note
    ADD HL,BC			; Add 4 to HL, so HL = location of new note to play
    LD (IX+3),L			; ... store in REPMUSDATA
    LD (IX+4),H
    LD E,(HL)			; E = effect index
    ADD HL,BC
    DEC HL
    LD D,(HL)			; D = step/row count before next new note needs to be played
    LD (IX+1),D			; ... store in REPMUSDATA
    SLA  E				; E = E * 2
    RET Z				; if E = 0 (dummy effect), nothing more to do. 
    LD A,(EFFFMPFLG)	; <> 0 means there is an active sound effect on FM1 
    OR A
    JR NZ,REPINITFMP1B	; active sound effect? go to REPINITFMP1B
    LD D,0
    LD HL,FMPEFFECTS	; get effect data location from here: FMPEFFECTS + (effect index * 2)
    ADD HL,DE			; HL = address where pointer to effect data can be found
    LD E,(HL)
    INC HL
    LD D,(HL)			; DE = address where effect data is located
    LD (IX+VOS),E		; store address of effect data, see also REPVARDATA
    LD (IX+VOS+1),D		; ( REPMUSDATA + VOS = REPVARDATA )
    RET
REPINITFMP1B:
    LD HL,EFFECT0		; sound effect active on FM1. Set dummy effect EFFECT0 instead
    LD (IX+VOS),L		; ... which does nothing (but will abort currently active effect).
    LD (IX+VOS+1),H
    RET

	; below: handle new step for channels FM2 - FM9 (track 'F2', .., 'F9' in tracker RED)
REPINITFMP:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)			; until this counter hits zero...
    RET NZ				; ...there is no new note/effect to play on this channel
    LD L,(IX+3)
    LD H,(IX+4)			; HL = song data location of former note
    ADD HL,BC			; Add 4 to HL, so HL = location of new note to play
    LD (IX+3),L			; ... store in REPMUSDATA
    LD (IX+4),H             
    LD E,(HL)			; E = effect index
    ADD HL,BC
    DEC HL
    LD D,(HL)			; D = step/row count before next new note needs to be played
    LD (IX+1),D			; ... store in REPMUSDATA
    SLA  E				; E = E * 2
    RET Z				; if E = 0 (dummy effect), nothing more to do. 
    LD D,0
    LD HL,FMPEFFECTS	; get effect data location from here: FMPEFFECTS + (effect index * 2)
    ADD HL,DE			; HL = address where pointer to effect data can be found
    LD E,(HL)
    INC HL
    LD D,(HL)			; DE = address where effect data is located
    LD (IX+VOS),E		; store address of effect data, see also REPVARDATA
    LD (IX+VOS+1),D		; ( REPMUSDATA + VOS = REPVARDATA )
    RET

	; below: handle new step for channels PSG2 - PSG3 (track 'P2' / 'P3' in tracker RED)
REPINITPSG:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)			; until this counter hits zero...
    RET NZ				; ...there is no new note/effect to play on this channel
    LD L,(IX+3)
    LD H,(IX+4)			; HL = song data location of former note
    ADD HL,BC			; Add 4 to HL, so HL = location of new note to play
    LD (IX+3),L			; ... store in REPMUSDATA
    LD (IX+4),H
    LD E,(HL)			; E = effect index
    ADD HL,BC
    DEC HL
    LD D,(HL)			; D = step/row count before next new note needs to be played
    LD (IX+1),D			; ... store in REPMUSDATA
    SLA  E				; E = E * 2
    RET Z				; if E = 0 (dummy effect), nothing more to do. 
    LD D,0
    LD HL,PSGEFFECTS	; get effect data location from here: PSGEFFECTS + (effect index * 2)
    ADD HL,DE			; HL = address where pointer to effect data can be found
    LD E,(HL)
    INC HL
    LD D,(HL)			; DE = address where effect data is located
    LD (IX+VOS),E		; store address of effect data, see also REPVARDATA
    LD (IX+VOS+1),D		; ( REPMUSDATA + VOS = REPVARDATA )
    RET

	; below: handle new step for channel PSG1 (track 'P1' in tracker RED)
REPINITPSA:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)			; until this counter hits zero...
    RET NZ				; ...there is no new note/effect to play on this channel
    LD L,(IX+3)
    LD H,(IX+4)			; HL = song data location of former note
    ADD HL,BC			; Add 4 to HL, so HL = location of new note to play
    LD (IX+3),L			; ... store in REPMUSDATA
    LD (IX+4),H
    LD E,(HL)			; E = effect index
    ADD HL,BC
    DEC HL
    LD D,(HL)			; D = step/row count before next new note needs to be played
    LD (IX+1),D			; ... store in REPMUSDATA
    SLA  E				; E = E * 2
    RET Z				; if E = 0 (dummy effect), nothing more to do. 
    LD A,(EFFPSGFLG)	; <> 0 means there is an active sound effect on PSG1 
    OR A
    JR NZ,REPINITPSB	; active sound effect? go to REPINITPSB
    LD D,0
    LD HL,PSGEFFECTS	; get effect data location from here: PSGEFFECTS + (effect index * 2)
    ADD HL,DE			; HL = address where pointer to effect data can be found
    LD E,(HL)
    INC HL
    LD D,(HL)			; DE = address where effect data is located
    LD (IX+VOS),E		; store address of effect data, see also REPVARDATA
    LD (IX+VOS+1),D		; ( REPMUSDATA + VOS = REPVARDATA )
    RET
REPINITPSB:
    LD HL,EFFECT0		; sound effect active on PSG1. Set dummy effect EFFECT0 instead
    LD (IX+VOS),L		; ... which does nothing (but will abort currently active effect).
    LD (IX+VOS+1),H
    RET

	; below: handle new step for drums (track 'DR' in tracker RED)
REPINITDRM:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)          ; until this counter hits zero...
    RET NZ              ; ...there is nothing to do regarding drums
    LD L,(IX+3)         
    LD H,(IX+4)         ; HL = song data location of former drum beat
    ADD HL,BC           ; Add 4 to HL, so HL = location of new drum beat to play
    LD (IX+3),L         ; ... store in REPMUSDATA
    LD (IX+4),H         
    ADD HL,BC
    DEC HL
    LD A,(HL)			; A = counter (bit 0-5), see below for for bit 6, see PUTDRUMS for bit 7
    LD D,A
    AND  63				; keep counter part (bit 0-5), clear bit 6-7
    JR NZ,REPINITDRMB
    LD A,64				; ... and if this counter = 0, we actually mean 64 
REPINITDRMB:
    LD (IX+1),A			; ... store counter in REPMUSDATA
    BIT 6,D				; bit 6 dictates whether drums should be played anyway...
    RET Z				; ... if 0, do nothing (just use the counter to skip more steps/rows)
    LD DE,EFFDRUM		; ... if 1, set the effect (EFFDRUM) that will play the drums
    LD (IX+VOS),E
    LD (IX+VOS+1),D
    RET

	; below: handle new step for Instrument-0 (track 'IN' in tracker RED)
REPINITIN0:
    BIT 0,(IX+0)
    RET Z				; this channel is off, nothing to do.
    DEC (IX+1)			; until this counter hits zero...
    RET NZ				; ...there is nothing to do regarding Instrument-0
    LD L,(IX+3)
    LD H,(IX+4)			; HL = song data location of former Instrument-0 change
    LD DE,10
    ADD HL,DE			; Add 10 to HL, so HL = location of new Instrument-0 data
    LD (IX+3),L         ; ... store in REPMUSDATA
    LD (IX+4),H
    LD A,(HL)			; get first byte (Instrument-0 should be changed only if A<>0)
    ADD HL,DE
    DEC HL
    LD D,(HL)			; D = step/row count before next change to OPLL Instrument-0
    LD (IX+1),D			; ... store counter in REPMUSDATA
    OR A
    RET Z				; first byte = 0, so do nothing (just use the counter to skip more steps/rows)
    LD DE,EFFINSTRU		; otherwise set the effect (EFFINSTRU) that will change OPLL instrument-0
    LD (IX+VOS),E
    LD (IX+VOS+1),D
    RET


;----------------------------------------------------------------------------------------------
; The routine REPINTERRU below is called (almost) every interrupt to handle effects.
; Some effects need manipulation of chip-registers (almost) every interrupt.
; For efficiency reasons, REPINTERRU is not called when:
;   - a new step/row is handled ( every (REPSPEED) interrupts )
;   - a volume up/down step is processed during volume fade in/out
;   (this prevents spikes of CPU clock cycle consumption within a single interrupt)
;----------------------------------------------------------------------------------------------
REPINTERRU:
    LD A,(REPMUSDATA)		; channel PSG1
    OR A
    JR Z,REPINTERR2			; skip if this channel is off
    LD A,(EFFPSGFLG)
    OR A					; active sound effect on PSG1?
    JR NZ,REPINTERR2		; ... if yes, then skip lines below
    LD IX,REPMUSDATA
    LD IY,(REPVARDATA)		; IY = location of effect data (current position)
    LD DE,00008H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA),IY		; store location of effect data (new position)
REPINTERR2:
    LD A,(REPMUSDATA+5)		; channel PSG2
    OR A
    JR Z,REPINTERR3			; skip if this channel is off
    LD IX,REPMUSDATA+5
    LD IY,(REPVARDATA+5)	; IY = location of effect data (current position)
    LD DE,00209H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+5),IY	; store location of effect data (new position)
REPINTERR3:
    LD A,(REPMUSDATA+10)	; channel PSG3
    OR A
    JR Z,REPINTERR4			; skip if this channel is off
    LD IX,REPMUSDATA+10
    LD IY,(REPVARDATA+10)	; IY = location of effect data (current position)
    LD DE,0040AH			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+10),IY	; store location of effect data (new position)
REPINTERR4:
    LD A,(REPMUSDATA+15)	; channel Drums
    OR A
    JR Z,REPINTERR5			; skip if this channel is off
    LD IX,REPMUSDATA+15
    LD IY,(REPVARDATA+15)	; IY = location of effect data (current position)
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+15),IY	; store location of effect data (new position)
REPINTERR5:
    LD A,(REPMUSDATA+20)	; channel Instrument-0
    OR A
    JR Z,REPINTERR6			; skip if this channel is off
    LD IX,REPMUSDATA+20
    LD IY,(REPVARDATA+20)	; IY = location of effect data (current position)
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+20),IY	; store location of effect data (new position)
REPINTERR6:
    LD A,(REPMUSDATA+25)	; channel FM1
    OR A
    JR Z,REPINTERR7			; skip if this channel is off
    LD A,(EFFFMPFLG)
    OR A					; active sound effect on FM1?
    JR NZ,REPINTERR7		; ... if yes, then skip lines below
    LD IX,REPMUSDATA+25
    LD IY,(REPVARDATA+25)	; IY = location of effect data (current position)
    LD DE,01030H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+25),IY	; store location of effect data (new position)
REPINTERR7:
    LD A,(REPMUSDATA+30)	; channel FM2
    OR A
    JR Z,REPINTERR8			; skip if this channel is off
    LD IX,REPMUSDATA+30
    LD IY,(REPVARDATA+30)	; IY = location of effect data (current position)
    LD DE,01131H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+30),IY	; store location of effect data (new position)
REPINTERR8:
    LD A,(REPMUSDATA+35)	; channel FM3
    OR A
    JR Z,REPINTERR9			; skip if this channel is off
    LD IX,REPMUSDATA+35
    LD IY,(REPVARDATA+35)	; IY = location of effect data (current position)
    LD DE,01232H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+35),IY	; store location of effect data (new position)
REPINTERR9:
    LD A,(REPMUSDATA+40)	; channel FM4
    OR A
    JR Z,REPINTERRA			; skip if this channel is off
    LD IX,REPMUSDATA+40
    LD IY,(REPVARDATA+40)	; IY = location of effect data (current position)
    LD DE,01333H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+40),IY	; store location of effect data (new position)
REPINTERRA:
    LD A,(REPMUSDATA+45)	; channel FM5
    OR A
    JR Z,REPINTERRB			; skip if this channel is off
    LD IX,REPMUSDATA+45
    LD IY,(REPVARDATA+45)	; IY = location of effect data (current position)
    LD DE,01434H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+45),IY	; store location of effect data (new position)
REPINTERRB:
    LD A,(REPMUSDATA+50)	; channel FM6
    OR A
    JR Z,REPINTERRC			; skip if this channel is off
    LD IX,REPMUSDATA+50
    LD IY,(REPVARDATA+50)	; IY = location of effect data (current position)
    LD DE,01535H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+50),IY	; store location of effect data (new position)
REPINTERRC:
    LD A,(REPMUSDATA+55)	; channel FM7
    OR A
    JR Z,REPINTERRD			; skip if this channel is off
    LD IX,REPMUSDATA+55
    LD IY,(REPVARDATA+55)	; IY = location of effect data (current position)
    LD DE,01636H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+55),IY	; store location of effect data (new position)
REPINTERRD:
    LD A,(REPMUSDATA+60)	; channel FM8
    OR A
    JR Z,REPINTERRE			; skip if this channel is off
	LD IX,REPMUSDATA+60
    LD IY,(REPVARDATA+60)	; IY = location of effect data (current position)
    LD DE,01737H			; D = register for pitch, E = register for volume
    CALL REPGOFORIT			; process current active effect on this channel
    LD (REPVARDATA+60),IY	; store location of effect data (new position)
REPINTERRE:
    LD A,(REPMUSDATA+65)	; channel FM9
    OR A
    JR Z,REPINTERRG			; skip if this channel is off
    LD IX,REPMUSDATA+65
    LD IY,(REPVARDATA+65)	; IY = location of effect data (current position)
    LD DE,01838H			; D = register for pitch, E = register for volume
	CALL REPGOFORIT			; process current active effect on this channel
	LD (REPVARDATA+65),IY	; store location of effect data (new position)
REPINTERRG:
	LD B,0					; tell caller that music is still playing (but no new step/note)
	RET

;----------------------------------------------------------------------------
; The routine REPGOFORIT below will call effect routines (there are many, see below)
; until the effect routine instructs that work is done for this interrupt. The
; effect routine can do such 'done for this interrupt' instruction by POPping
; the return address form the stack before doing 'RET'.
;----------------------------------------------------------------------------

REPGOFORIT:
    CALL REPGOFORI2
    JR REPGOFORIT		; looks like endless loop, but extra 'POP' in effect routine breaks it

REPGOFORI2:
    LD L,(IY+0)
    LD H,(IY+1)			; HL = location of effect routine
    JP (HL)				; if routine at HL does the extra 'POP', execution will
						; continue at the CALLER of REPGOFORIT.


;----------------------------------------------------------------------------
; Effect data
;-----------------------------------------------------------------------------
; Below a list of all effects. This is the 'effect data' (not 'effect routines',
; not 'sound effect data'). It's only about music. The effect data below mainly refer to 
; effect routines that implement the effects that are supported by this replayer,
; but there is also data in between if needed by a certain effect routine.
; Note that everything regarding music (also normal notes) is implemented using
; effect routines.
;-----------------------------------------------------------------------------
; Not all effects can be applied on all channels. The rules are:
; - EFFECT0 : does nothing and can be used on any channel
; - EFFDRUM : the only effect for the drums channel (just activates the drums)
; - EFFINSTRU : the only effect for Instrument-0 channel (sets how Instrument-0 will sound)
; - EFFPSG1 ... EFFPSG81 : all PSG effects (same numbers in tracker RED -> but in HEX)
; - EFFFM1 ... EFFFM81 : all OPLL/FM effects (same numbers in tracker RED -> but in HEX)
;-----------------------------------------------------------------------------
EFFECT0:	DW ENDLESS				; dummy effect that does nothing
EFFDRUM:	DW PUTDRUMS,ENDLESS		; only used to set/activate a drum beat
EFFINSTRU:	DW PUTINSTRU0,ENDLESS	; only used to set OPLL instrument-0 (OPLL User Tone Registers 0-7)
    
; below : all PSG effects (1-81)
EFFPSG1:    DW PSGOFF,ENDLESS
EFFPSG2:    DW WAITINT,WAITINT,PSGDECVOLU,WAITINT,JUMPBACK
			DB 8
EFFPSG3:    DW PSGNOT,ENDLESS
EFFPSG4:    DW PSGNOTVOLU,ENDLESS
EFFPSG5:    DW PSGNOTVOLU
EFFPSG6:    DW COPYVAR,ISTIJD,PSGDECVOLU,JUMPBACK
			DB 4
EFFPSG7:	DW PSGNOTVOLU,COPYVAR,ISTIJD,SETPSGVOLU
			DB 0
			DW ISTIJD,PSGVOLUME,JUMPBACK
			DB 9
EFFPSG8:	DW PSGNOTVOLU,COPYVAR,ISTIJD,SETPSGVOLU
			DB 0
EFFPSG9:	DW ENDLESS
EFFPSG10:	DW PSGNOT
EFFPSG11:	DW COPYVAR,PSGVOLUME,PSSLIDEUPA,JUMPBACK
			DB 2
EFFPSG12:	DW PSGNOT
EFFPSG13:	DW COPYVAR,PSGVOLUME,PSSLIDEUPB,JUMPBACK
			DB 2
EFFPSG14:	DW PSGNOT
EFFPSG15:	DW COPYVAR,PSGVOLUME,ISTIJD,PSSLIDEUPC,JUMPBACK
			DB 4
EFFPSG16:	DW PSGNOT
EFFPSG17:	DW COPYVAR,PSGVOLUME,PSSLIDEDOA,JUMPBACK
			DB 2
EFFPSG18:	DW PSGNOT
EFFPSG19:	DW COPYVAR,PSGVOLUME,PSSLIDEDOB,JUMPBACK
			DB 2
EFFPSG20:	DW PSGNOT
EFFPSG21:	DW COPYVAR,PSGVOLUME,ISTIJD,PSSLIDEDOC,JUMPBACK
			DB 4
EFFPSG22:	DW COPYVAR,PSGVOLUME,PSSLIDEUPA,ENDLESS
EFFPSG23:	DW COPYVAR,PSGVOLUME,PSSLIDEUPB,ENDLESS
EFFPSG24:	DW COPYVAR,PSGVOLUME,PSSLIDEDOA,ENDLESS
EFFPSG25:	DW COPYVAR,PSGVOLUME,PSSLIDEDOB,ENDLESS
EFFPSG26:	EQU EFFPSG4
EFFPSG27:	DW PSONLYVOLU,ENDLESS
EFFPSG28:	DW PSGNOT
EFFPSG29:	DW COPYVAR,PSGVOLUME,PSSLIDEDOD
			DB 2
			DW ISTIJD,PSSLIDEUPD
			DB 2
			DW ISTIJD,JUMPBACK
			DB 10
EFFPSG30:	DW PSGNOT
EFFPSG31:	DW COPYVAR,PSGVOLUME,PSSLIDEDOD
			DB 5
			DW ISTIJD,PSSLIDEUPD
			DB 5
			DW ISTIJD,JUMPBACK
			DB 10	   
EFFPSG32:	DW PSGNOT

EFFPSG33:    DW COPYVAR,PSGVOLUME,PSSLIDEDOD
       DB 12
       DW ISTIJD,PSSLIDEUPD
       DB 12
       DW ISTIJD,JUMPBACK
       DB 10
EFFPSG34:    DW PSGNOT
EFFPSG35:    DW COPYVAR,PSGVOLUME,PSSLIDEDOD
       DB 20
       DW ISTIJD,PSSLIDEUPD
       DB 20
       DW ISTIJD,JUMPBACK
       DB 10
EFFPSG36:    DW PSGNOT
EFFPSG37:    DW COPYVAR,PSGVOLUME,PSSLIDEDOC,ISTIJD2
       DB 2
       DW PSSLIDEUPC,ISTIJD2
       DB 2
       DW JUMPBACK
       DB 10
EFFPSG38:    DW PSGNOT
EFFPSG39:    DW COPYVAR,PSGVOLUME,PSSLIDEDOD
       DB 2
       DW ISTIJD2
       DB 3
       DW PSSLIDEUPD
       DB 2
       DW ISTIJD2
       DB 3
       DW JUMPBACK
       DB 12
EFFPSG40:    
    DW PSGNOT
EFFPSG41:    
    DW COPYVAR,PSGVOLUME,PSSLIDEDOD
    DB 4
    DW ISTIJD2
    DB 3
    DW PSSLIDEUPD
    DB 4
    DW ISTIJD2
    DB 3
    DW JUMPBACK
    DB 12
EFFPSG42:    DW PSGNOT
EFFPSG43:    DW COPYVAR,PSGVOLUME,PSSLIDEDOC,WAITINT,ISTIJD2
       DB 4
       DW PSSLIDEUPC,WAITINT,ISTIJD2
       DB 4
       DW JUMPBACK
       DB 14
EFFPSG44:    DW COPYVAR2,WAITINT,PSGVOLUME,PSGFASTNT,PSGFASTNT,PSGFASTNT
       DW PSGOFF,ENDLESS
EFFPSG45:    DW COPYVAR2,WAITINT,PSGVOLUME,PSGFASTNT,JUMPBACK
       DB 2
EFFPSG46:    DW COPYVAR2,WAITINT,PSGVOLUME,PSGFASTNT,PSGFASTNT
       DW PSGDECVOLU,JUMPBACK
       DB 6
EFFPSG47:    DW COPYVAR2,WAITINT,PSGVOLUME,PSGFASTNT,PSGFASTNT,PSGFASTNT
       DW PSGFASTNT,PSGFASTNT,PSGFASTNT,PSGDECVOLU,JUMPBACK
       DB 14
EFFPSG48:    DW SETSPEEDP,ENDLESS
EFFPSG49:    DW PSGNOTVOLU
EFFPSG50:    DW COPYVAR,PSGDECVOLU,ISTIJD2
       DB 2
       DW PSGINCVOLU,ISTIJD2
       DB 2
       DW JUMPBACK
       DB 10
EFFPSG51:    DW PSGNOTVOLU
EFFPSG52:    DW COPYVAR,PSGDECVOLU,WAITINT,ISTIJD2
       DB 4
       DW PSGINCVOLU,WAITINT,ISTIJD2
       DB 4
       DW JUMPBACK
       DB 14
EFFPSG53:    DW PSGNOTVOLU
EFFPSG54:    DW COPYVAR,PSGDECVOLU,WAITINT,WAITINT,WAITINT,ISTIJD2
       DB 8
       DW PSGINCVOLU,WAITINT,WAITINT,WAITINT,ISTIJD2
       DB 8
       DW JUMPBACK
       DB 22
EFFPSG55:    DW PSGNOTVOLU
EFFPSG56:    DW COPYVAR,ISTIJD,PSGINCVOLU,JUMPBACK
       DB 4
EFFPSG57:    DW PSGNOTVOLU,COPYVAR,ISTIJD,WAITINT,PSSLIDEVOL
       DB 253
       DW ISTIJD,WAITINT
       DW PSSLIDEVOL
       DB 2
       DW JUMPBACK
       DB 14
EFFPSG58:    DW PSGNOTVOLU,COPYVAR,ISTIJD,WAITINT,PSSLIDEVOL
       DB 252
       DW ISTIJD,WAITINT
       DW PSSLIDEVOL
       DB 2
       DW JUMPBACK
       DB 14
EFFPSG59:    DW PSGNOTVOLU,COPYVAR,ISTIJD,WAITINT,PSSLIDEVOL
       DB 250
       DW ISTIJD,WAITINT
       DW PSSLIDEVOL
       DB 3
       DW JUMPBACK
       DB 14
EFFPSG60:    DW COPYVAR,PSGNOTVOLU,PSSLIDEUPA,ENDLESS
EFFPSG61:    EQU    EFFECT0
EFFPSG62:    EQU    EFFECT0
EFFPSG63:    EQU    EFFECT0
EFFPSG64:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,PSGDECVOLU,JUMPBACK
       DB 2
EFFPSG65:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,PSGDECVOLU,WAITINT,JUMPBACK
       DB 4
EFFPSG66:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,PSGDECVOLU,WAITINT,WAITINT
       DW JUMPBACK
       DB 6
EFFPSG67:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,PSGDECVOLU
       DW WAITINT,WAITINT,WAITINT,WAITINT,JUMPBACK
       DB 10
EFFPSG68:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,JUMP,EFFHULP+14
EFFPSG69:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,JUMP,EFFHULP+12
EFFPSG70:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,JUMP,EFFHULP+8
EFFPSG71:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,JUMP,EFFHULP+2
EFFPSG72:    DW ONLYTOON,WAITINT,PSONLYVOLU,PUTPSGFREQ,0D003H,WAITINT
       DW PUTPSGFREQ,00007H,PSSLIDEVOL
       DB 248
       DW WAITINT,PUTPSGFREQ,00009H,PSSLIDEVOL
       DB 253
       DW PUTPSGFREQ,0000CH,WAITINT,PSGDECVOLU,SETPSGVOLU
       DB 0
       DW ENDLESS
EFFPSG73:    DW COPYVAR,ONLYRUIS,PSGVOLUME,SETRUISFRQ,WAITINT
       DW SLIDERUIS
       DB 6
       DW WAITINT,ONLYRUIS,PSSLIDEVOL
       DB 252
       DW WAITINT,PSGDECVOLU,SETPSGVOLU
       DB 0
       DW ENDLESS
EFFPSG74:    DW COPYVAR,PSGVOLUME,TOONRUIS,PUTPSGFREQ,00B00H,SETRUISFRQ
       DW WAITINT,PUTPSGFREQ,00A00H,SLIDERUIS
       DB 254
       DW PSSLIDEVOL
       DB 253
       DW WAITINT,PSGDECVOLU,PSSLIDEVOL
       DB 2
       DW SLIDERUIS
       DB 252
       DW WAITINT,PSSLIDEVOL
       DB 253
       DW WAITINT,JUMPBACK
       DB 5
EFFPSG75:    DW COPYVAR,PUTPSGFREQ,00D00H,PSONLYVOLU,SETRUISFRQ,TOONRUIS
       DW WAITINT,PUTPSGFREQ,00B00H,PSSLIDEVOL
       DB 254
       DW WAITINT,SETPSGVOLU
       DB 0
       DW ENDLESS
EFFPSG76:    DW COPYVAR,WAITINT,PSGNOTVOLU,PSSLIDEVOL
       DB 254
       DW SETRUISFRQ,ONLYRUIS,WAITINT,PSGDECVOLU,WAITINT
       DW PSGDECVOLU,WAITINT,WAITINT,WAITINT,SLIDERUIS
       DB 255
       DW PSGDECVOLU,WAITINT,PSGDECVOLU,WAITINT,SETPSGVOLU
       DB 0
       DW ENDLESS
EFFPSG77:    DW WAITINT,SETPSGTIME,04200H,PUTPSGFREQ,0B001H,SETVOLU16
       DW ONLYTOON,SOUND,00D0AH,WAITINT,WAITINT,ONLYRUIS,SOUND
       DW 00608H,SETPSGVOLU
       DB 10
       DW PSGDECVOLU,JUMPBACK
       DB 2
EFFPSG78:    DW COPYVAR,WAITINT,PSGNOTVOLU,WAITINT,WAITINT,WAITINT
       DW PSGDECVOLU,WAITINT,ISTIJD2
       DB 4
       DW ENDLESS
EFFPSG79:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,WAITINT,SLIDERUIS
       DB 2
       DW PSGDECVOLU,JUMPBACK
       DB 5
EFFPSG80:    DW COPYVAR,PSGVOLUME,ONLYRUIS,SETRUISFRQ,WAITINT,SLIDERUIS
       DB 254
       DW PSGDECVOLU,JUMPBACK
       DB 5
EFFPSG81:    DW ONLYTOON,SOUND,00800H,SETPSGTIME,00003H,WAITINT
       DW PUTPSGFREQ,0D003H,SETVOLU16,SOUND,00D09H,WAITINT
       DW PUTPSGFREQ,00006H,WAITINT,SOUND,00107H,WAITINT
       DW SOUND,00108H,WAITINT,SETPSGVOLU
       DB 0
       DW ENDLESS

EFFHULP:     DW WAITINT,WAITINT,WAITINT,WAITINT,WAITINT,WAITINT,WAITINT
       DW WAITINT,SETPSGVOLU
       DB 0
       DW ENDLESS

; below : all OPLL/FM effects (1-81)
EFFFM1:      DW FMOFF1,ENDLESS
EFFFM2:      DW FMOFF2,ENDLESS
EFFFM3:      DW FMNOTE,ENDLESS
EFFFM4:      DW FMNOTVOLIN,ENDLESS
EFFFM5:      DW FMNOTEVOLU
EFFFM6:      DW COPYVAR,ISTIJD,FMDECVOLU,JUMPBACK
       DB 4
EFFFM7:      DW FMNOTEVOLU,COPYVAR,ISTIJD,SETFMVOLU
       DB 15
       DW ISTIJD,FMVOLUME,JUMPBACK
       DB 9
EFFFM8:      DW FMNOTEVOLU,COPYVAR,ISTIJD,SETFMVOLU
       DB 15
EFFFM9:      DW ENDLESS
EFFFM10:     DW FMNOTE
EFFFM11:     DW COPYVAR,FMVOLUME,FMSLIDEUPA,JUMPBACK
       DB 2
EFFFM12:     DW FMNOTE
EFFFM13:     DW COPYVAR,FMVOLUME,FMSLIDEUPB,JUMPBACK
       DB 2
EFFFM14:     DW FMNOTE
EFFFM15:     DW COPYVAR,FMVOLUME,ISTIJD,FMSLIDEUPC,JUMPBACK
       DB 4
EFFFM16:     DW FMNOTE
EFFFM17:     DW COPYVAR,FMVOLUME,FMSLIDEDOA,JUMPBACK
       DB 2
EFFFM18:     DW FMNOTE
EFFFM19:     DW COPYVAR,FMVOLUME,FMSLIDEDOB,JUMPBACK
       DB 2
EFFFM20:     DW FMNOTE
EFFFM21:     DW COPYVAR,FMVOLUME,ISTIJD,FMSLIDEDOC,JUMPBACK
       DB 4
EFFFM22:     DW COPYVAR,FMVOLUME,FMSLIDEUPA,ENDLESS
EFFFM23:     DW COPYVAR,FMVOLUME,FMSLIDEUPB,ENDLESS
EFFFM24:     DW COPYVAR,FMVOLUME,FMSLIDEDOA,ENDLESS
EFFFM25:     DW COPYVAR,FMVOLUME,FMSLIDEDOB,ENDLESS
EFFFM26:     DW FMSTOPFREQ,ENDLESS
EFFFM27:     DW FMONLYVOLU,ENDLESS
EFFFM28:     DW FMNOTE
EFFFM29:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 3
       DW ISTIJD,FMSLIDEUPD
       DB 3
       DW ISTIJD,JUMPBACK
       DB 10
EFFFM30:     DW FMNOTE
EFFFM31:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 8
       DW ISTIJD,FMSLIDEUPD
       DB 8
       DW ISTIJD,JUMPBACK
       DB 10
EFFFM32:     DW FMNOTE
EFFFM33:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 15
       DW ISTIJD,FMSLIDEUPD
       DB 15
       DW ISTIJD,JUMPBACK
       DB 10
EFFFM34:     DW FMNOTE
EFFFM35:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 30
       DW ISTIJD,FMSLIDEUPD
       DB 30
       DW ISTIJD,JUMPBACK
       DB 10
EFFFM36:     DW FMNOTE
EFFFM37:     DW COPYVAR,FMVOLUME,FMSLIDEDOC,ISTIJD2
       DB 2
       DW FMSLIDEUPC,ISTIJD2
       DB 2
       DW JUMPBACK
       DB 10
EFFFM38:     DW FMNOTE
EFFFM39:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 2
       DW ISTIJD2
       DB 3
       DW FMSLIDEUPD
       DB 2
       DW ISTIJD2
       DB 3
       DW JUMPBACK
       DB 12
EFFFM40:     DW FMNOTE
EFFFM41:     DW COPYVAR,FMVOLUME,FMSLIDEDOD
       DB 4
       DW ISTIJD2
       DB 3
       DW FMSLIDEUPD
       DB 4
       DW ISTIJD2
       DB 3
       DW JUMPBACK
       DB 12
EFFFM42:     DW FMNOTE
EFFFM43:     DW COPYVAR,FMVOLUME,FMSLIDEDOC,WAITINT,ISTIJD2
       DB 4
       DW FMSLIDEUPC,WAITINT,ISTIJD2
       DB 4
       DW JUMPBACK
       DB 14
EFFFM44:     DW COPYVAR2,WAITINT,FMVOLUME,FMFASTNT,FMFASTNTB,FMFASTNTB
       DW FMOFF1,ENDLESS
EFFFM45:     DW COPYVAR2,WAITINT,FMVOLUME,FMFASTNT,FMFASTNTB,JUMPBACK
       DB 2
EFFFM46:     DW COPYVAR2,WAITINT,FMVOLUME,FMFASTNT,FMFASTNTB,FMFASTNTB
       DW FMDECVOLU,JUMPBACK
       DB 6
EFFFM47:     DW COPYVAR2,WAITINT,FMVOLUME,FMFASTNT,FMFASTNTB,FMFASTNTB
       DW FMFASTNTB,FMFASTNTB,FMFASTNTB,FMFASTNTB,FMDECVOLU
       DW JUMPBACK
       DB 14
EFFFM48:     DW SETSPEEDF,ENDLESS
EFFFM49:     EQU    EFFECT0
EFFFM50:     EQU    EFFECT0
EFFFM51:     EQU    EFFECT0
EFFFM52:     EQU    EFFECT0
EFFFM53:     EQU    EFFECT0
EFFFM54:     EQU    EFFECT0
EFFFM55:     DW FMNOTEVOLU
EFFFM56:     DW COPYVAR,ISTIJD,FMINCVOLU,JUMPBACK
       DB 4
EFFFM57:     DW FMNOTEVOLU,COPYVAR,ISTIJD,WAITINT,FMSLIDEVOL
       DB 253
       DW ISTIJD,WAITINT
       DW FMSLIDEVOL
       DB 2
       DW JUMPBACK
       DB 14
EFFFM58:     DW FMNOTEVOLU,COPYVAR,ISTIJD,WAITINT,FMSLIDEVOL
       DB 252
       DW ISTIJD,WAITINT
       DW FMSLIDEVOL
       DB 2
       DW JUMPBACK
       DB 14
EFFFM59:     DW FMNOTEVOLU,COPYVAR,ISTIJD,WAITINT,FMSLIDEVOL
       DB 250
       DW ISTIJD,WAITINT
       DW FMSLIDEVOL
       DB 3
       DW JUMPBACK
       DB 14
EFFFM60:     DW COPYVAR,FMNOTEVOLU,FMSLIDEUPA,ENDLESS
EFFFM61:     EQU    EFFECT0
EFFFM62:     EQU    EFFECT0
EFFFM63:     EQU    EFFECT0
EFFFM64:     DW INSTRUMENT,ENDLESS
EFFFM65:     EQU    EFFECT0
EFFFM66:     EQU    EFFECT0
EFFFM67:     EQU    EFFECT0
EFFFM68:     EQU    EFFECT0
EFFFM69:     EQU    EFFECT0
EFFFM70:     EQU    EFFECT0
EFFFM71:     EQU    EFFECT0
EFFFM72:     EQU    EFFECT0
EFFFM73:     EQU    EFFECT0
EFFFM74:     EQU    EFFECT0
EFFFM75:     EQU    EFFECT0
EFFFM76:     EQU    EFFECT0
EFFFM77:     EQU    EFFECT0
EFFFM78:     EQU    EFFECT0
EFFFM79:     EQU    EFFECT0
EFFFM80:     EQU    EFFECT0
EFFFM81:     EQU    EFFECT0

;----------------------------------------------------------------------------
; Effect routines
;-----------------------------------------------------------------------------
; Below are all the 'effect routines' referenced in the 'effect data' above.
; The effect data above describe which 'effect routines' are used and in which
; order. This way each effect (like playing notes, drums, slides, vibrations, etc)
; is implemented.
;-----------------------------------------------------------------------------
; Examples of a few 'effect routines':
; - PSGNOT     : just play the note (without effects) on the PSG channel
; - FMNOTVOLIN : play the note on the FM channel and also set volume & instrument
; - WAITINT    : wait one interrupt before going on
; - JUMPBACK   : go back within the effect data (to create repeating effects)
; - ENDLESS    : do nothing anymore (end of effect)
;-----------------------------------------------------------------------------
; Input for every 'effect routine':
; - IY = location of effect data (current position) 
; - IX = location where song data (current channel) can be found ( = REPMUSDATA + offset)
; - D = register for pitch  (not for Drums / Instr-0 channel)
; - E = register for volume (not for Drums / Instr-0 channel)
; Output of every 'effect routine':
; - IY should point to the next position within effect data 
; - POP the return address from the stack if no more action is needed during THIS
;   interrupt (this works as an implicit WAITINT-'effect routine').
;-----------------------------------------------------------------------------
; Most effect routines use data that is available (note, volume, etc.) from the
; song data and/or buffered data. This can be accessed by using the IX register. 
; Otherwise, some effect routines use data that is added to the 'effect data'. 
; Example:  SOUND,00800H, NEXT_ROUTINE,...
; The effect routine 'SOUND' uses the data '00800H'. This works like doing
; SOUND 8,0 in MSX-BASIC. In this example, IY should be incremented by 4 to
; ensure that IY always points to a location where the address of the next
; effect routine can be found (NEXT_ROUTINE in this example).
;-----------------------------------------------------------------------------

; Effect routine: set PSG envelope frequency (used for some PSG drums)
SETPSGTIME:
	LD C,11		; PSG reg 11 -> Envelope Freq. LSB
	LD B,(IY+3)	; get LSB from effect data
	CALL WRTPSG
	INC C		; PSG reg 12 -> Envelope Freq. MSB
	LD B,(IY+2)	; get MSB from effect data
	CALL WRTPSG
	LD BC,4
	ADD IY,BC	; IY = new location within effect data
	RET

; Effect routine: set a PSG register (fixed value), like 'SOUND reg,val' in MSX-BASIC
SOUND:
	LD B,(IY+2)		; value
	LD C,(IY+3)		; PSG register
	CALL WRTPSG		; PSG reg(C)=B
	LD BC,4
	ADD IY,BC		; IY = new location within effect data
	RET

; Effect routine: Slide PSG volume up/down with a value provided in effect data
PSSLIDEVOL:
	LD A,(IX+VOS+4)	; current PSG volume
	LD B,(IY+2)		; how much up/down (e.g. 254 means: -2)
	ADD A,B
	CP 16
	JR C,PSSLIDEVOB	; below 16 is okay
	CP 200
	LD A,15
	JR C,PSSLIDEVOB	; A between 16 and 199? Use max volume 
	XOR A			; A between 200 and 255? use min volume
PSSLIDEVOB:
	LD (IX+VOS+4),A	; store new current volume
	INC IY
	INC IY
	INC IY			; IY = new location within effect data
	LD B,A			; new volume
	LD C,E			; PSG register for volume
	JP WRTVOLUPSG

; Effect routine: Slide FM/OPLL volume up/down with a value provided in effect data
FMSLIDEVOL:
	LD A,(IX+VOS+4)	; current FM volume
	AND  240
	LD C,A			; C = instrument part (=high nibble), not to be changed
	LD A,(IX+VOS+4)
	AND  0Fh		; A = volume part (inverted, so 0=max volume, 15=min volume)
	LD B,(IY+2)		; how much up/down (e.g. 254 means: -2)
	SUB B
	CP 16
	JR C,FMSLIDEVOB
	CP 200
	LD A,15			; use min volume (overflow)
	JR C,FMSLIDEVOB
	XOR A			; use max volume (overflow)
FMSLIDEVOB:
	OR C			; combine new volume with instrument nibble
	LD (IX+VOS+4),A	; store new current volume
	INC IY
	INC IY
	INC IY			; IY = new location within effect data
	LD B,A			; B = instrument & volume to set
	LD C,E			; C = FM register for instrument & volume
	JP WRTVOLUFMB

; Effect routine: sets specific PSG pitch/frequency, provided within effect data
; (used for some PSG drums)
PUTPSGFREQ:
	LD C,D			; register for fine pitch
	LD B,(IY+3)		; get new fine pitch value
	LD (IX+VOS+3),B	; store new value
	CALL WRTPSG	
	INC C			; register for course pitch
	LD B,(IY+2)		; get new course pitch value
	LD (IX+VOS+2),B	; store new value
	CALL WRTPSG
	LD BC,4
	ADD IY,BC		; IY = new location within effect data
	RET

; Effect routine: jump to other location within effect data (to limit redundancy in effect data)
JUMP:
	LD L,(IY+2)
	LD H,(IY+3)
	PUSH HL
	POP IY			; IY = new location within effect data
	RET

; Effect routine: turn on both tone and noise on channel PSG1
TOONRUIS:
	LD BC,0B007H    ; reg7=0B0 = 10 110 000 -> noise on (channel 1 only), tone on
	JR ONLYRUISB

; Effect routine: turn off both tone and noise on channel PSG1
NOTOONRUIS:
	LD BC,0BF07H    ; reg7=0BF = 10 111 111 -> noise off, tone off
	JR ONLYRUISB

; Effect routine: turn on tone (but turn off noise) on channel PSG1
ONLYTOON:
	LD BC,0B807H    ; reg7=0B8 = 10 111 000 -> noise off, tone on
	JR ONLYRUISB

; Effect routine: turn on noise (but turn off tone) on channel PSG1
ONLYRUIS:
	LD BC,0B107H    ; reg7=0B1 = 10 110 001 -> noise on (channel 1 only), tone only on channel 2/3
	
ONLYRUISB:
	INC IY
	INC IY
	JP WRTPSG

; Effect routine: set PSG "envelope enable bit" (bit 4 for volume reg), except when (REPDECVOLUPSG) >=4
; (PSG chip can control volume itself, called envelope. This effect is used for few PSG drums)
SETVOLU16:
	INC IY
	INC IY
	LD A,(REPDECVOLUPSG)	; PSG volume decrease
	CP 4
	LD B,16
	JR C,SETVOLU16B	; if A < 4, keep value 16 for B (this will set 'envelope enable bit')
	LD B,0			; if A >= 4, use 0 for B
SETVOLU16B:
	LD C,E			; register for PSG volume
	LD (IX+VOS+4),B	; store volume
	JP WRTPSG		; write volume

; Effect routine: set PSG noise value
SETRUISFRQ:
	LD B,(IX-BOS)	; the noise value (4-bit value)
	DEC B			; ???
	SLA  B			; times 2 (make it 5-bit, as the PSG expects)
	LD A,B
	LD (RUISFREQ),A	; store current noise frequency
	LD C,6			; PSG register for noise freq.
	INC IY
	INC IY			; IY = new location within effect data
	JP WRTPSG		; set PSG noise frequency

; Effect routine: Slide PSG noise freq. up/down with a value provided in effect data
SLIDERUIS:
	LD A,(RUISFREQ)	; current noise freq.
	LD B,(IY+2)		; how much up/down (e.g. 254 means: -2)
	ADD A,B
	CP 32			; check for overflow
	JR C,SLIDERUISC
	LD A,1FH		; max value
	CP 50			; check for overflow
	JR C,SLIDERUISC
	XOR A			; min value
SLIDERUISC:
	LD (RUISFREQ),A	; store new noise freq.
	INC IY
	INC IY
	INC IY			; IY = new location within effect data
	LD B,A
	LD C,6			; PSG register for noise freq.
	JP WRTPSG		; set PSG noise frequency

; Effect routine: Slide up FM/OPLL pitch X units, where X is provided by song data
FMSLIDEUPA:  
	LD L,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	JR FMFREQUP		; use this value to slide up FM/OPLL pitch

; Effect routine: Slide up FM/OPLL pitch X+16 units, where X is provided by song data
FMSLIDEUPB:
	LD A,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	ADD A,16		; Add 16
	LD L,A			; use this value to slide up FM/OPLL pitch
	JR FMFREQUP

; Effect routine: Slide up FM/OPLL pitch 1 unit
FMSLIDEUPC:
	LD L,1			; use this value to slide up FM/OPLL pitch
	JR FMFREQUP
	  
; Effect routine: Slide up FM/OPLL pitch X unit, where X is provided by effect data
FMSLIDEUPD:
	LD L,(IY+2)		; get value from effect data
	INC IY
; Used by effect routines to slide up FM/OPLL pitch
FMFREQUP:
	LD A,(IX+VOS+3)	; fine pitch
	ADD A,L
	LD (IX+VOS+3),A	; store new fine pitch
	PUSH AF
	LD B,A			; B = new fine pitch
	LD C,D			; C = register for fine pitch
	CALL WRTOPLL	; write fine pitch to OPLL chip
	POP AF
	JR NC,FMFREQUPC	; no overflow after add to fine pitch? then skip lines below...
	LD A,(IX+VOS+2)	; ... otherwise increase coarse pitch by 1...
	AND  0Fh
	OR A
	JR Z,FMFREQUPB
	INC A
FMFREQUPB:
	INC A
	LD (IX+VOS+2),A
	LD B,A			; B = new course pitch
	SET  4,B		; set OPLL KEY bit
	LD C,E			; C = register for instrument & volume
	RES  4,C		; C = register for coarse pitch
	CALL WRTOPLL	; write course pitch to OPLL chip
FMFREQUPC:
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET


; Effect routine: Slide down FM/OPLL pitch X units, where X is provided by song data	
FMSLIDEDOA:
	LD L,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	JR FMFREQDOWN	; use this value to slide down FM/OPLL pitch

; Effect routine: Slide down FM/OPLL pitch X+16 units, where X is provided by song data
FMSLIDEDOB:
	LD A,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	ADD A,16		; Add 16
	LD L,A			; use this value to slide down FM/OPLL pitch
	JR FMFREQDOWN

; Effect routine: Slide down FM/OPLL pitch 1 unit
FMSLIDEDOC:
	LD L,1			; use this value to slide down FM/OPLL pitch
	JR FMFREQDOWN

; Effect routine: Slide down FM/OPLL pitch X unit, where X is provided by effect data
FMSLIDEDOD:
	LD L,(IY+2)		; get value from effect data
	INC IY
; Used by effect routines to slide down FM/OPLL pitch
FMFREQDOWN:
	LD A,(IX+VOS+3)	; fine pitch
	SUB L           
	LD (IX+VOS+3),A	; store new fine pitch
	PUSH AF         
	LD B,A			; B = new fine pitch
	LD C,D			; C = register for fine pitch
	CALL WRTOPLL	; write fine pitch to OPLL chip
	POP AF          
	JR NC,FMFREQDOWC; no overflow after sub from fine pitch? then skip lines below...
	LD A,(IX+VOS+2) ; ... otherwise decrease coarse pitch by 1...
	AND  15
	CP 1
	JR Z,FMFREQDOWB
	DEC A
FMFREQDOWB:
	DEC A
	LD (IX+VOS+2),A
	LD B,A			; B = new course pitch
	SET  4,B		; set OPLL KEY bit
	LD C,E			; C = register for instrument & volume
	RES  4,C		; C = register for coarse pitch
	CALL WRTOPLL	; write course pitch to OPLL chip
FMFREQDOWC:
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: Slide up PSG pitch X units, where X is provided by song data
PSSLIDEUPA:
	LD L,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	JR PSGFREQUP	; use this value to slide up PSG pitch

; Effect routine: Slide up PSG pitch X+16 units, where X is provided by song data
PSSLIDEUPB:
	LD A,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	ADD A,16		; Add 16
	LD L,A			; use this value to slide up PSG pitch
	JR PSGFREQUP

; Effect routine: Slide up PSG pitch 1 unit
PSSLIDEUPC:
	LD L,1			; use this value to slide up PSG pitch
	JR PSGFREQUP

; Effect routine: Slide up PSG pitch X unit, where X is provided by effect data
PSSLIDEUPD:
	LD L,(IY+2)		; get value from effect data
	INC IY
; Used by effect routines to slide up PSG pitch
PSGFREQUP:
	LD A,L			; For PSG, a higher pitch value means lower pitch, 
	NEG				; ... so negate pitch value
	LD L,A			
	LD H,255		; ... and prepare a 16-bit value (HL) to add to pitch
	JR PSGFREQDOB
	   
; Effect routine: Slide down PSG pitch X units, where X is provided by song data	
PSSLIDEDOA:
	LD L,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	JR PSGFREQDOW	; use this value to slide down PSG pitch

; Effect routine: Slide down PSG pitch X+16 units, where X is provided by song data
PSSLIDEDOB:
	LD A,(IX-BOS)	; get value from song data (placed by COPVAR effect routine)
	ADD A,16		; Add 16
	LD L,A			; use this value to slide down PSG pitch
	JR PSGFREQDOW

; Effect routine: Slide down PSG pitch 1 unit
PSSLIDEDOC:
	LD L,1			; use this value to slide down PSG pitch
	JR PSGFREQDOW

; Effect routine: Slide down PSG pitch X unit, where X is provided by effect data
PSSLIDEDOD:
	LD L,(IY+2)		; get value from effect data
	INC IY
; Used by effect routines to slide down PSG pitch
PSGFREQDOW:
	LD H,0
PSGFREQDOB:
	LD C,(IX+VOS+3)	; get current PSG pitch (fine pitch)
	LD B,(IX+VOS+2)	; get current PSG pitch (coarse pitch)
	ADD HL,BC		; add or subtract pitch units
	LD (IX+VOS+3),L	; store new pitch
	LD (IX+VOS+2),H
	LD B,L			; B = value for PSG coarse pitch
	LD C,D			; C = register for coarse pitch
	CALL WRTPSG		; write to PSG
	LD B,H			; B = value for PSG fine pitch
	INC C			; C = register for fine pitch
	CALL WRTPSG		; write to PSG
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: turn off FM channel (quickly, but not abruptly)
FMOFF2:
	LD A,(IX+VOS+2)	; current value for coarse pitch
	AND  15
	OR 32			; SUSTAIN bit on -> turn off more slowly
	JR FMOFF1B

; Effect routine: turn off FM channel (abruptly)
FMOFF1:
	LD A,(IX+VOS+2)	; current value for coarse pitch
	AND  15
FMOFF1B:
	LD B,A
	LD C,E			; C = register for instrument & volume
	RES  4,C		; C = register for coarse pitch
	CALL WRTOPLL	; write to coarse pitch -> turn off FM channel
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: set PSG volume to a value provided within the effect data
SETPSGVOLU:
	LD B,(IY+2)		; new volume within effect data
	LD (IX+VOS+4),B	; store for later use
	INC IY
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	LD C,E			; C = PSG register for volume
	JP WRTVOLUPSG

; Effect routine: set FM/OPLL volume to a value provided within the effect data
SETFMVOLU:
	LD A,(IX+VOS+4)
	AND  240
	LD B,A			; B = instrument (high nibble) which should not change
	LD A,(IY+2)
	AND  15			; A = new volume (low nibble)
	OR B			; A = instrument & volume
	LD (IX+VOS+4),A	; store
	LD B,A
	LD C,E			; C = register for instrument & volume
	INC IY
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	JP WRTVOLUFMB

; Effect routine: set OPLL pitch/volume/instrument of new note without starting new note with KEY bit
FMSTOPFREQ:
	CALL FMONLYVOLB
	JR FMNOTE3

; Effect routine: play new FM/OPLL note and also set volume (not a new instrument)
FMNOTEVOLU:
	CALL FMONLYVOLB
	JR FMNOTE2
	
; Effect routine: only set new FM/OPLL volume
FMONLYVOLU:
	CALL FMONLYVOLB	; set new volume
	LD (IX-BOS+2),B
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; used by effect routines to set FM/OPLL volume
FMONLYVOLB:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD A,(IX+VOS+4)	; current instrument & volume
	AND  240
	LD B,A			; B = current instrument (=high nibble) which will not change
	LD A,(HL)		
	AND  15			; A = new volume
	OR B			; A = instrument (high nibble) and new volume (low nibble)
	LD (IX+VOS+4),A	; store
	LD B,A
	LD C,E			; register for instrument & volume
	JP WRTVOLUFMB	; write to OPLL

; Effect routine: play FM/OPLL note and also set instrument & volume
FMNOTVOLIN:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD B,(HL)		; B = instrument (high nibble) and volume (low nibble)
	LD C,E
	LD (IX+VOS+4),B	; store
	CALL WRTVOLUFMB	; set instrument and volume
	JR FMNOTE2		; play the note

; Effect routine: play FM arpeggio note (very short note) and prepare for next note
; (use this one time after new note is played, use FMFASTNTB to continue the arpeggio effect)
FMFASTNT:
	LD C,E
	RES  4,C		; C = register for coarse pitch
	LD B,0
	CALL WRTOPLL	; reset KEY bit, reset SUSTAIN bit (needed to start new note on FM/OPLL)
	LD A,(IX-BOS+4)
	LD (FMFASTNT2+2),A	; modify instruction below...
FMFASTNT2:
	LD C,(IX+0)		; modified to: LD C,(IX-BOS+[x])  , this will fetch the note to play
	CALL NEXTTOON	; set note to play next interrupt for the arpeggio effect
	JP FMNOTE4

; Effect routine: play FM arpeggio note (very short note) and prepare for next note
; (use this repeatedly after FMFASTNT is used to start the new note)
FMFASTNTB:
	LD A,(IX-BOS+4)
	LD (FMFASTNTB2+2),A	; modify instruction below...
FMFASTNTB2:
	LD C,(IX+0)		; modified to: LD C,(IX-BOS+[x])  , this will fetch the note to play
	CALL NEXTTOON	; set note to play next interrupt for the arpeggio effect
	JP FMNOTE4

; Effect routine: Play FM/OPLL note
FMNOTE:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
FMNOTE2:
	LD C,E			; C = register for instrument & volume
	RES  4,C		; C = register for coarse pitch
	LD B,0			; KEY bit = 0, SUSTAIN bit = 0, coarse pitch = 0
	CALL WRTOPLL	; write to OPLL
FMNOTE3:
	INC HL
	LD C,(HL)		; C = note to play
FMNOTE4:
	LD B,0
	LD HL,FMTONEN	; table with 2 byte value for each note
	ADD HL,BC		; HL now points to the right pitch values
	LD B,(HL)		; B = value for fine pitch
	LD C,D			; C = register for fine pitch
	LD (IX+VOS+3),B
	CALL WRTOPLL	; write fine pitch
	LD C,E			; C = register for instrument & volume
	RES  4,C		; C = register for coarse pitch
	INC HL			
	LD B,(HL)		; B = value for coarse pitch
	LD (IX+VOS+2),B
	SET  4,B		; set KEY bit
	CALL WRTOPLL	; write coarse pitch & KEY bit
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: change speed of song (set from a PSG channel)
SETSPEEDP:
	LD B,0			; no need to toggle bits of low nibble
	JR SETSPEED

; Effect routine: change speed of song (set from a FM/OPLL channel)
SETSPEEDF:
	LD B,15			; used to toggle bits of low nibble
SETSPEED:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD A,(HL)		; A = data that contains new speed, not in the right form yet
	XOR B			; only for FM/OPLL: toggle bits of low nibble back to normal
	RRC A			; ... (low nibble is toggled in music data for FM channels)
	RRC A			; also swap high nibble and low nibble
	RRC A			; ... (for better readability of speed value in tracker RED)
	RRC A			; ...
	ADD A,3			; 3 is minimum value (=max speed = 3 interrupts per step)
	CP 3
	JR NC,SETSPEED2	
	LD A,0FFh		; if overflow, use max value (=min speed)
SETSPEED2:
	LD (REPSPEED),A	; new song speed (interrupts per step)
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET
	   
; Effect routine: jump back X bytes within effect data
; (needed to create repeating effects, like vibrations)
JUMPBACK:
	LD A,(IY+2)		; number of bytes to jump back
	NEG
	LD C,A
	LD B,255		; now BC is negative number of bytes (e.g.: 0FFFEH = -2)
	ADD IY,BC		; IY = new location within effect data
	RET

; Effect routine: wait one interrupt before going on with processing effect
WAITINT:
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: decrease volume of OPLL/FM channel by 1
FMDECVOLU:
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	LD A,(IX+VOS+4)
	AND  15			; current volume (inverted, so 0 = max volume)
	CP 15
	RET Z			; quit, if already minimum volume
	LD B,(IX+VOS+4)	; B = current instrument (=high nibble) & volume (=low nibble)
	INC B			; decrease volume
	LD (IX+VOS+4),B	; store
	LD C,E			; OPLL register for instrument & volume
	JP WRTVOLUFMB	; write to OPLL

; Effect routine: increase volume of OPLL/FM channel by 1
FMINCVOLU:
	INC IY
	INC IY			; IY = new location within effect data
	POP AF			; extra POP: no more action this interrupt
	LD A,(IX+VOS+4)
	LD B,A			; B = current instrument (=high nibble) & volume (=low nibble)
	AND  15			; current volume (inverted, so 0 = max volume)
	RET Z			; quit, if already maximum volume
	DEC B			; otherwise increase volume
	LD (IX+VOS+4),B	; store
	LD C,E			; OPLL register for instrument & volume
	JP WRTVOLUFMB	; write to OPLL

; Effect routine: decrease volume of PSG channel by 1
PSGDECVOLU:
	POP AF			; extra POP: no more action this interrupt
PSGDECVOLB:
	INC IY
	INC IY			; IY = new location within effect data
	LD A,(IX+VOS+4)
	AND  15			; current volume
	RET Z			; quit, if already minimum volume
	DEC A			; otherwise decrease volume by 1
	LD (IX+VOS+4),A	; store
	LD B,A			; B = new volume
	LD C,E			; C = PSG register for volume
	JP WRTVOLUPSG	; write to PSG

; Effect routine: increase volume of PSG channel by 1
PSGINCVOLU:
	POP AF			; extra POP: no more action this interrupt
PSGINCVOLB:
	INC IY
	INC IY			; IY = new location within effect data
	LD A,(IX+VOS+4)
	AND  15			; current volume
	CP 15
	RET Z			; quit if already maximum volume
	INC A			; otherwise increase volume by 1
	LD (IX+VOS+4),A	; store
	LD B,A			; B = new volume
	LD C,E			; C = PSG register for volume
	JP WRTVOLUPSG	; write to PSG

; Effect routine: decrease counter and only proceed within effect data if counter hits zero
ISTIJD:
	DEC (IX-BOS+1)	; decrease counter (set by COPYVAR)
	JR Z,ISTIJDB
	POP AF			; extra POP: no more action this interrupt
	RET
ISTIJDB:
	LD A,(IX-BOS)
	LD (IX-BOS+1),A	; restore counter
	INC IY
	INC IY			; IY = next location within effect data
	RET

; Effect routine: decrease counter and only proceed within effect data if counter hits zero
; Otherwise (counter <> 0), jump back within effect data
ISTIJD2:
	DEC (IX-BOS+1)	; decrease counter (set by COPYVAR)
	JP NZ,JUMPBACK	; if not time yet (<> 0), jump back within effect data
	LD A,(IX-BOS)
	LD (IX-BOS+1),A	; restore counter
	INC IY
	INC IY
	INC IY			; IY = next location within effect data
	RET

; Effect routine: copy/buffer data to be used by other effect routines
COPYVAR:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD A,(HL)		; data that belongs to note (often volume & instrument, can be any data...)
	LD (IX-BOS+2),A	; store in buffer
	SRL  A
	SRL  A
	SRL  A
	SRL  A			; A is between 0 and 15 (used as a counter with many effects, see RED tracker)
	INC A
	LD (IX-BOS),A	; store this counter+1
	LD (IX-BOS+1),A	; store this counter+1 again (this will count down using effect routine ISTIJD)
	INC HL
	LD A,(HL)		; A = note to be played
	LD (IX-BOS+3),A	; store copy of note
	INC IY
	INC IY			; IY = next location within effect data
	RET

; Effect routine: copy/buffer some data to prepare for Arpeggio effect
; (arpeggio: three notes are alternated every interrupt)
COPYVAR2:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD B,(HL)		; arpeggio data (two nibbles -> how far is second & third note from first?)
	INC HL
	LD A,(HL)		; note from song data
	LD C,A
	LD (IX-BOS+3),A	; first fast alternating note (arpeggio)
	AND  00011000B
	JR NZ,COPYVAR2B
	LD A,32      
	ADD A,C			; ensure bit 3 and 4 are not both zero (???)
	LD C,A
COPYVAR2B:
	LD A,B
	SRL  A			; bring high nibble to bit 1/2/3/4
	SRL  A
	SRL  A			
	AND  00011110B	; how many notes to add to first note to get second note?
	ADD A,C
	CALL COPYVAR2C
	LD (IX-BOS+1),A	; second fast alternating note (arpeggio)
	LD A,B
	AND  15
	SLA  A			; bring low nibble to bit 1/2/3/4 (how many notes to add to get third note?)
	ADD A,C
	CALL COPYVAR2C
	LD (IX-BOS),A	; third fast alternating note (arpeggio)
	LD (IX-BOS+4),-BOS+3	; ref to first arpeggio note to play
	INC IY
	INC IY			; IY = next location within effect data
	RET
	; below: (???) correct note offset after calculating second/third arpeggio note
COPYVAR2C:
	BIT 3,A
	RET NZ
	BIT 4,A
	RET NZ
	SUB 32
	RET

; Used by effect routines (arpeggio effects) to go to the next (very short) note.
; Three notes are alternated very quickly. The offsets to locate these three notes
; are IX-BOS+3, IX-BOS+1 and IX-BOS+0 . One of these offsets is stored in (IX-BOS+4).
NEXTTOON:
	LD A,(IX-BOS+4)	; offset to arpeggio note that has already played
	DEC A			; next offset
	CP -BOS+2		; skip this one, not a valid offset to locate arpeggio note
	JR NZ,NEXTTOONB
	DEC A			; next offset
NEXTTOONB:
	CP -BOS-1		; overflow?
	JR NZ,NEXTTOONC
	LD A,-BOS+3		; offset to locate first arpeggio note
NEXTTOONC:
	LD (IX-BOS+4),A	; store offset that will be used to play next (very short) note
	RET

; Effect routine: Set volume of PSG channel (COPYVAR must have run before)
PSGVOLUME:
	LD A,(IX-BOS+2)	; get value set by COPYVAR
	AND  15			; keep low nibble (=volume)
	LD B,A
	LD C,E			; register for volume
	LD (IX+VOS+4),B	; store in REPVARDATA structure
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	JP WRTVOLUPSG	; set PSG volume

; Effect routine: Set volume of FM/OPLL channel (COPYVAR must have run before)	
FMVOLUME:
	LD A,(IX+VOS+4)
	AND  240		; A = instrument (not to be changed)
	LD B,A
	LD A,(IX-BOS+2)	; get value set by COPYVAR
	AND  15			; volume part to change
	OR B			; instrument & volume
	LD B,A
	LD C,E			; OPLL register for instrument & volume
	LD (IX+VOS+4),B	; store in REPVARDATA structure	
	INC IY
	INC IY
	POP AF			; extra POP: no more action this interrupt
	JP WRTVOLUFMB	; set OPLL volume
	   
; Effect routine: Play PSG note set also set volume
PSGNOTVOLU:
	CALL PSONLYVOLB
	JR PSGNOT2

; Effect routine: set PSG volume to value provided in song data
PSONLYVOLU:
	CALL PSONLYVOLB
PSONLYVOLV:
	LD (IX-BOS+2),0	; modified by code to: LD (IX-BOS+2),[volume]
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; used by effect routine to set PSG volume
PSONLYVOLB:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD A,(HL)
	AND  15			; A = PSG volume
	LD (PSONLYVOLV+3),A 
	LD B,A
	LD C,E			; PSG register for volume
	LD (IX+VOS+4),B
	JP WRTVOLUPSG	; set PSG volume

; Effect routine: Set OPLL instrument+volume without starting new note
INSTRUMENT:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
	LD A,(HL)		; A = instrument (=high nibble) and volume (=low nibble)
	LD (IX+VOS+4),A
	LD (IX-BOS+2),A
	LD B,A
	LD C,E			; C = register for instrument & volume
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	JP WRTVOLUFMB	; set instrument & volume

; Effect routine: play PSG arpeggio note (very short note) and prepare for next note
PSGFASTNT:
	LD A,(IX-BOS+4)
	LD (PSGFASTNT2+2),A	; modify instruction below...
PSGFASTNT2:
	LD C,(IX+0)		; modified to: LD C,(IX-BOS+[x])  , this will fetch the note to play
	CALL NEXTTOON	; set note to play next interrupt for the arpeggio effect
	JP PSGNOT3

; Effect routine: Play PSG note
PSGNOT:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	INC HL
PSGNOT2:
	INC HL
	LD C,(HL)		; C = note to play
PSGNOT3:
	LD B,0
	LD HL,PSGTONEN
	ADD HL,BC		; HL points to exact pitch values for this note
	LD B,(HL)
	LD C,D			; register for fine pitch
	LD (IX+VOS+3),B	; store fine pitch in REPVARDATA
	CALL WRTPSG		; set fine pitch
	INC C			; register for coarse pitch
	INC HL
	LD B,(HL)
	LD (IX+VOS+2),B	; store coarse pitch in REPVARDATA
	CALL WRTPSG		; set coarse pitch
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	;below: ensure there is tone (not noise) on channel PSG1
PSGRUISOFF:
	LD A,D
	OR A			; check for channel PSG1 (register for pitch=0) ...
	RET NZ			; ... if not, quit (there is never noise on PSG2 / PSG3)
	LD BC,0B807H    ; reg7=0B8 = 10111000 -> noise off, tone on
	JP WRTPSG

; Effect routine: turn off PSG channel by setting pitch to 0
PSGOFF:
	LD C,D			; register for fine pitch
	LD B,0
	CALL WRTPSG
	INC C			; register for coarse pitch
	CALL WRTPSG
	LD (IX+VOS+2),B	; update pitch in REPVARDATA
	LD (IX+VOS+3),B
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: Set OPLL instrument-0 (change how instrument 0 sounds)
; (this is done by changing registers 0-7 of the OPLL chip)
PUTINSTRU0:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location (new instrument 0 data)
	LD BC,00800H	; change 8 registers, start at register 0
PUTINSTR0B:
	INC HL
	LD A,(HL)
	CALL WRTOPLL3	; OPLL reg(C) = A
	INC C			; next register
	DJNZ PUTINSTR0B	; until all 8 registers done
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: do nothing (end of effect)
ENDLESS:
	POP AF			; extra POP: no more action this interrupt
	RET

; Effect routine: activate beat on Drums channel
PUTDRUMS:
	LD L,(IX+3)
	LD H,(IX+4)		; HL = song data location
	LD BC,0000EH
	CALL WRTOPLL	; set all rhythm bits off
	LD C,038H		; OPLL register for volume of drums
	LD B,(HL)
	CALL WRTVOLUFMA	; OPLL reg(C) = B  -> drum volumes
	INC HL
	DEC C			; OPLL register 037H, also for volume of drums
	LD B,(HL)
	CALL WRTVOLUFMA	; OPLL reg(C) = B  -> drum volumes
	INC HL
	DEC C			; OPLL register 036H, also for volume of drums
	LD B,(HL)
	CALL WRTVOLUFMB	; OPLL reg(C) = B  -> drum volumes
	LD A,B			; only low nibble is volume, high nibble contains 4 of the 5 drum flags
	LD B,4
PUTDRUMSB:
	SRL  A
	DJNZ PUTDRUMSB	; after this loop: now low nibble has 4 of the 5 drum flags
	INC HL
	LD C,(HL)		; bit 7 of C has the 5th drum flag
	SLA  C			; 5th drum flag -> Carry
	RL   A			; A has now all of the 5 drum flags (indicates which drums should sound)
	OR 32			; bit 5 of register 14 on (this means: activate drums/rhythm)
	LD B,A
	LD A,14			; register for drums/rhythm (bit4=base, bit3=snare, etc.)
	CALL WRTOPLL2	; OPLL reg(A) = B, 
	INC IY
	INC IY			; IY = next location within effect data
	POP AF			; extra POP: no more action this interrupt
	RET
;----------------------------------------------------------------------------
; End of Effect routines
;-----------------------------------------------------------------------------
	
;----------------------------------------------------------------------------
; Below all pitch values the sound chips need to generate normal pure
; notes, like C4, C#4, D4, etc.
;----------------------------------------------------------------------------

; Pitch data for PSG chip (8 octaves)
PSGTONEN:
	DB 242,7,128,7,20,7,93,13,93,13,156,12,231,11,60,11
	DB 155,10,2,10,2,10,115,9,235,8,107,8,0,0,0,0
	DB 249,3,192,3,138,3,175,6,175,6,78,6,244,5,158,5
	DB 78,5,1,5,1,5,186,4,118,4,54,4,0,0,0,0
	DB 253,1,224,1,197,1,87,3,87,3,39,3,250,2,207,2
	DB 167,2,129,2,129,2,93,2,59,2,27,2,0,0,0,0
	DB 254,0,240,0,227,0,172,1,172,1,148,1,125,1,104,1
	DB 83,1,64,1,64,1,46,1,29,1,13,1,0,0,0,0
	DB 127,0,120,0,113,0,214,0,214,0,202,0,190,0,180,0
	DB 170,0,160,0,160,0,151,0,143,0,135,0,0,0,0,0
	DB 64,0,60,0,57,0,107,0,107,0,101,0,95,0,90,0
	DB 85,0,80,0,80,0,76,0,71,0,67,0,0,0,0,0
	DB 32,0,30,0,28,0,53,0,53,0,50,0,48,0,45,0
	DB 42,0,40,0,40,0,38,0,36,0,34,0,0,0,0,0
	DB 16,0,15,0,14,0,27,0,27,0,25,0,24,0,22,0
	DB 21,0,20,0,20,0,19,0,18,0,17,0,0,0,0,0

; Pitch data for FM/OPLL chip (8 octaves)
FMTONEN:
	DB 34,1,51,1,69,1,172,0,172,0,182,0,193,0,205,0
	DB 217,0,230,0,230,0,244,0,2,1,17,1,0,0,0,0
	DB 34,3,51,3,69,3,89,1,89,1,109,1,131,1,154,1
	DB 178,1,204,1,204,1,232,1,2,3,17,3,0,0,0,0
	DB 34,5,51,5,69,5,89,3,89,3,109,3,131,3,154,3
	DB 178,3,204,3,204,3,232,3,2,5,17,5,0,0,0,0
	DB 34,7,51,7,69,7,89,5,89,5,109,5,131,5,154,5
	DB 178,5,204,5,204,5,232,5,2,7,17,7,0,0,0,0
	DB 34,9,51,9,69,9,89,7,89,7,109,7,131,7,154,7
	DB 178,7,204,7,204,7,232,7,2,9,17,9,0,0,0,0
	DB 34,11,51,11,69,11,89,9,89,9,109,9,131,9,154,9
	DB 178,9,204,9,204,9,232,9,2,11,17,11,0,0,0,0
	DB 34,13,51,13,69,13,89,11,89,11,109,11,131,11,154,11
	DB 178,11,204,11,204,11,232,11,2,13,17,13,0,0,0,0
	DB 34,15,51,15,69,15,89,13,89,13,109,13,131,13,154,13
	DB 178,13,204,13,204,13,232,13,2,15,17,15,0,0,0,0


;-----------------------------------------------------------------------------
; The routines below do direct writes to PSG and OPLL chips (OUT instructions)
; OPLL registers are never read from, only written to.
; There is one routine that reads from PSG (IN instruction)
;-----------------------------------------------------------------------------

; input: C=register, B=value
WRTOPLL:
	LD A,C
	OUT (07CH),A      
	EX (SP),HL
	EX (SP),HL
	LD A,B
	NOP
	OUT (07DH),A      
	RET

; input: A=register, B=value
WRTOPLL2:
	OUT (07CH),A      
	EX (SP),HL
	EX (SP),HL
	PUSH AF
	LD A,B
	OUT (07DH),A      
	POP AF
	RET

; input: C=register, A=value
WRTOPLL3:
	PUSH AF
	LD A,C
	OUT (07CH),A      
	EX (SP),HL
	EX (SP),HL
	POP AF
	NOP
	OUT (07DH),A      
	RET

; Set volumes for OPLL drums. Decrease each volume with (REPDECVOLUFM)
; (volume is decreased when volume fading is going on or FM/PSG balance is set)
; When OPLL drum mode is on, registers 036H - 038H are used for drum volumes (4 bit each)
; input: C = register, B = volume1 (=high nibble) & volume2 (=low nibble)
; beware: the bits of each volume nibble is inverted (so 0 = max volume, 15= min volume)
WRTVOLUFMA:
	LD A,B
	AND  0Fh			; drum volume (inverted, so 0=max volume) (low nibble)
	LD DE,(REPDECVOLUFM); E = volume decrease for FM
	ADD A,E				; now A is total volume (inverted), but overflow is possible
	BIT 4,A				; overflow?
	JR Z,WRTVOLFMA2
	LD A,15				; if overflow, use minimum volume (inverted)
WRTVOLFMA2:
	LD D,A
	LD A,C				; OPLL register for drum volumes
	OUT (7Ch),A
	SLA  E
	SLA  E
	SLA  E
	SLA  E				; E = volume decrease for FM ( x 16)
	LD A,B
	AND  0F0h			; drum volume (high nibble)
	ADD A,E				; now A is total (inverted) volume (high nibble), but overflow is possible
	JR NC,WRTVOLFMA3
	LD A,0F0h			; if overflow, use minimum volume (inverted)
WRTVOLFMA3:
	OR D				; combine the 2 volumes (high nibble and low nibble)
	OUT (7Dh),A      	; write to OPLL chip
	RET

; Set volume & instrument for OPLL/FM channel. Decrease volume with (REPDECVOLUFM)
; (volume is decreased when volume fading is going on or FM/PSG balance is set)
; input: C = register, B = instrument (=high nibble) & volume (=low nibble)
; beware: the bits of volume nibble is inverted (so 0 = max volume, 15= min volume)
WRTVOLUFMB:
	PUSH DE
	LD A,C
	OUT (07CH),A 
	LD A,B				; A = inverted volume (0 = max volume, 15=off)
	AND 0Fh				; keep low nibble (volume part)
	LD DE,(REPDECVOLUFM); E = volume decrease for FM
	ADD A,E				; now A is total volume (inverted), but overflow is possible
	BIT 4,A				; overflow?
	JR Z,WRTVOLFMB2
	LD A,15				; if overflow, use minimum volume (inverted)
WRTVOLFMB2:
	LD D,A
	LD A,B
	AND 240				; keep high nibble (= instrument part)
	OR D				; combine volume (low nibble) and instrument (high nibble)
	OUT (07DH),A      	; write to OPLL chip
	POP DE
	RET

; Set volume for PSG channel. Decrease volume with (REPDECVOLUPSG)
; (volume is decreased when volume fading is going on or FM/PSG balance is set)
; input: C = register, B = volume (=low nibble)
WRTVOLUPSG:
	LD A,C
	OUT (0A0H),A
	LD A,B				; A = volume
	LD BC,(REPDECVOLUPSG); C = volume decrease for PSG
	SUB C				; now A is total volume, but overflow is possible
	BIT 7,A				; overflow?
	JR Z,WRTVOLUPS2
	XOR A				; if overflow, use minimum volume
WRTVOLUPS2:
	OUT (0A1H),A      	; write volume to PSG chip
	RET

; input: C = register, B = value
WRTPSG:
	LD A,C
	OUT (0A0H),A
	LD A,B
	OUT (0A1H),A
	RET
	   
; input: A = register, B = value
WRTPSG2:
	OUT (0A0H),A
	PUSH AF
	LD A,B
	OUT (0A1H),A
	POP AF
	RET

; input: C = register, A = value
WRTPSG3:
	PUSH AF
	LD A,C
	OUT (0A0H),A
	POP AF
	OUT (0A1H),A
	RET

; Read from PSG register
; input: A = register
; output: A = value
READPSG:
	OUT (0A0H),A
	IN A,(0A2H)
	RET

;----------------------------------------------------------------------------
; Prepare song data that is loaded from disk. Some data structures in the header
; of the song data contain relative offsets that need to be converted to absolute
; RAM addresses. So MUSADRES is typically only called once after the song data has
; been loaded.
; input: HL = start here searching for song data (token 'MUSC')
;        BC = length of search, so search until HL+BC
;----------------------------------------------------------------------------
; Some more details:
; There is an identifier 'MUSC' that precedes the real song data to indicate that
; song data will follow. This routine will search for this identifier.
; When 'MUSC' is found, then relative offsets are converted to absolute RAM addresses
; for all of the 14 channels (9 x FM, 3 x PSG, 1 x drums, 1 x Instr0). This is done
; twice (in two data structures).
;----------------------------------------------------------------------------
; Info about data structures following the identifier 'MUSC':
; If 'MUSC' is at offset 0, then this is the data that follows:
; offset   4: general song info (speed, mode, repeat, etc), total 11 bytes
; offset  15: per-channel data (14 x 5 bytes); here are offsets to be converted.
; offset  85: idem (14 x 5 bytes), this data is used after song repeat.
; offset 155: from here, data of the first channel/track (the real notes, etc).
;----------------------------------------------------------------------------
MUSADRES:
	LD A,"M"		; 'M' is first char of identifier to look for.
	CPIR			; search for 'M' in (HL). Go on until found or BC=0
	LD A,B
	OR C
	RET Z			; quit if BC=0 (that means no more 'M' found)
	PUSH HL
	LD DE, MUSADRDAT; points to 'USC' (=rest of identifier)
MUSCLOOP:
	LD A,(DE)
	OR A
	JR Z,MUSCFOUND	; identifier 'MUSC' found!
	CP (HL)
	JR NZ,MUSCWRONG	; no identifier 'MUSC' here
	INC HL
	INC DE
	JR MUSCLOOP
MUSCWRONG:
	POP HL
	JR MUSADRES		; search again for 'M', starting at HL
	; below: 'MUSC' was found, now do the conversion...
MUSCFOUND:
	PUSH BC			; BC is needed later to search for more (there might be another 'MUSC')
	LD B,14			; number of channels (9xFM, 3xPSG, 1xdrums, 1xInstr0)
	LD DE,4
	OR A			; clear Carry flag, needed for SBC below
	SBC  HL,DE		; HL = HL-4 = song data base address (where "MUSC" was found)
	PUSH HL
	POP IX			; IX = song data base address
	EX DE,HL		; DE = song data base address, HL = 4
TRACKLOOP:
	LD L,(IX+15+3)	; IX+15 points to a data structure that is the same as 'REPMUSDATA'
	LD H,(IX+15+4)	; HL = relative offset to channel data
	ADD HL,DE		; HL = base address + offset = absolute RAM address
	LD (IX+18),L	; store absolute RAM address (low byte)...
	LD (IX+19),H	; ... and high byte
	LD L,(IX+85+3)	; IX+85 points to a data structure that is the same as 'REPMUSDATA'
	LD H,(IX+85+4)	; HL = relative offset to channel data (used after repeat)
	ADD HL,DE		; HL = base address + offset = absolute RAM address
	LD (IX+88),L	; store absolute RAM address (low byte)...
	LD (IX+89),H	; ... and high byte
	PUSH DE
	LD DE,5
	ADD IX,DE		; next channel in data structure
	POP DE
	DJNZ TRACKLOOP	; loop until all 14 channels are done
	POP BC
	POP HL
	JR MUSADRES		; there might be another song, search for more in RAM

MUSADRDAT:
	DB "USC", 0		; part of identifier ('MUSC' is complete identifier, see above)

EINDE:
	NOP

;----------------------------------------------------------------------------
; Fill with zero's to get binary file size divisible by 128 bytes
; That's what GEN80 used to do automatically
	
	DS (128-($%128))*($%128>0)*-1

;============================================================================	   
; Short explanation ANMA sound effect data format:
;============================================================================
; This is an example of a sound effect:
;   PSGSNDEFF1:   DB  254,7,184,8,14, 255,1,4,0,1,1,1, 250,15,240,0,15,0,15
;                 DB  253, 248,1,65, 253, 248,1,0BFH, 249, 252, 254,8,0, 251
;----------------------------------------------------------------------------
; This is how you should read this sound effect data:
;		255 = start outer loop (255,from,to,up/down,step,register,from)
;		254 = set register (254,register,data,..,..)
;		253 = wait interrupt
;		252 = the 'next' of outer loop
;		251 = end of sound effect
;		250 = start inner loop (250,from,to,up/down,step,register,from)
;		249 = the 'next' of inner loop
;		248 = add/subtract from register (248,register,amount XOR 64)
;----------------------------------------------------------------------------
; Analysis of example sound effect above:
;	- Set register 7 to 184, and also register 8 to 14
;	- Start outer loop from 1 to 4 with (+1 each iteration) on register 1
;		- Start inner loop from 15 to 250 (+15 each iteration) on register 0
;			- Wait 1 interrupt
;			- Add (65 XOR 64 = 1) to register 1
;			- Wait 1 interrupt
;			- Add (0BFH XOR 64 = -1) to register 1       
;		- Next iteration of inner loop
;	- Next iteration of outer loop
;	- Set register 8 to 0
;	- End of sound effect
;============================================================================







