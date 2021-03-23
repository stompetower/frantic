#!/usr/bin/python

"""
Convert AMU file (RED music tracker) into Text

use for RED v1 .AMU file:
   python amu2txt.py 1 input output

use for RED v2 .AMU file:
   python amu2txt.py 2 input output
   
"""

import sys

# RED v1: visibility flags for all 80 effects (note,volume,data): bit 0/1/2 for FM/OPLL, bit 4/5/6 for PSG
visibility1 = [0,0,0,17,55,119,68,119,119,0,119,102,119,102,119,102,119,102,119,102, \
    119,102,102,102,102,102,51,34,119,102,119,102,119,102,119,102,119,102,119,102, \
    119,102,119,102,119,119,119,119,102,119,102,119,102,119,102,119,68,119,119,119, \
    0,0,0,0,102,96,96,96,96,96,96,96,32,96,96,96,112,0,112,96,96]

# RED v2: visibility flags for all 81 effects (note,volume,data): bit 0/1/2 for FM/OPLL, bit 4/5/6 for PSG
visibility2 = [0,0,0,17,55,119,68,119,119,0,119,102,119,102,119,102,119,102,119,102, \
    119,102,102,102,102,102,51,34,119,102,119,102,119,102,119,102,119,102,119,102, \
    119,102,119,102,119,119,119,119,102,112,96,112,96,112,96,119,68,119,119,119, \
    119,0,0,0,102,96,96,96,96,96,96,96,32,96,96,96,112,0,112,96,96,0]
    
# RED v1: all custom FM/OPLL instruments
instruments1 = [ \
    "--------","PIANO---","PIPEORGN","XYLOPHON","SANTOOL-","CLAVICOD","HARPSCD-","KOTO----","TAIKO---","ENGINE--", \
    "UFO-----","SYNBELL-","CHIME---","SYNPERCU","SYNRHYTH","HARMDRUM","COWBELL-","CLOSEHIH","SNAREDRM","BASSDRUM", \
    "PIANO2--","SANTOOL2","BRASS---","FLUTE---","CLAVICD2","CLAVICD3","KOTO2---","PIPEORG2","POHDSPLA","ROHDSPLA", \
    "ORCH-L--","ORCH-R--","SYNVIOL-","SYNORGAN","SYNBRASS","SHAMISEN","MAGICAL-","HUWAWA--","WNDERFLT","HARDROCK", \
    "MACHINE-","MACHINEV","COMIC---","SE-COMIC","SE-LASER","SE-NOISE","SE-STAR-","SE-STAR2","ENGINE2-","SYNTH1--", \
    "SYNTH2--","SYNTH3--","SYNTH4--","STHSWEEP","SYNTHSF1","SYNTHSF2","SYNTHSF3","SYNTLEAD","HEAVSYNT","LEADSYNT", \
    "SYNTSTR1","SYNTSTR2","SMADSYNT","NEWSYNTH","WOWSYNTH","SYNTPIAN","PIANO3--","PIANO4--","PIANO5--","ELPIANO1", \
    "ELPIANO2","ELPIANO3","ELPIANO4","ACIDPIAN","SPACPIAN","DX7PIANO","TOYPIANO","ORGAN---","ELORGAN1","ELORGAN2", \
    "ELORGAM3","PORGAN1-","PORGAN2-","PIPEORGN","FUNKORGN","SF-ORGAN","STHBASS1","STHBASS2","SLAPBAS1","SLAPBAS2", \
    "SLAPBAS3","ELBASS1-","ELBASS2-","RASPBASS","BASS1---","BASS2---","SHRTBASS","COOLBASS","BASELINE","HOUSBASE", \
    "STRINGS1","STRINGS2","HEAVYSTR","PLUCKED1","PLUCKED2","PLUCKED3","ELTRONS1","ELTRONS2","VIOLIN--","SAXOPHO1", \
    "SAXOPHO2","SAXOPHO3","CLARINET","FLUTE1--","FLUTE2--","BLEUSFLU","SYNTHFLU","PICOLLO-","OBOE----","BASSOON-", \
    "HARMONIC","BAGPIPE1","BAGPIPE2","GLOCKSP1","GLOCKSP2","SPACGLCK","MG-BELLS","BELL1---","BELL2---","BELL3---", \
    "HANDBELL","SPACBEL1","SPACBEL2","BLUESGUI","SPANGUIT","ESPGUITR","FUZZGUIT","AM-FUZZ-","MARIMBA1","MARIMBA2", \
    "MARIMBA3","MARIMBA4","MARIMBA5","XYLOPHO1","XYLOPHO2","VIBRAPH1","VIBRAPH2","STEELDRM","BRASS2--","WAHBRASS", \
    "BELLBRAS","HEAVBRAS","TRUMPET1","TRUMPET2","WAVESYNT","NEWWAVE1","TROMBONE","HORN----","TUBA1---","TUBA2---", \
    "KOTO----","BANJO---","HARP----","MOUTHARP","SITAR---","MEATYJOB","WAY OUT-","NICESOUN","ALIEN1--","ALIEN2--", \
    "ALIEN3--","ALIEN4--","STRANGE1","STRANGE2","STRANGE3","SE-STAR3","TERMINAT","COSMIC--","XENON---","INVASION", \
    "MSX-PSG-","BASSDRUM","SNARDRUM","OPNHIHAT","CLSHIHAT","BELLPERC","SICHOR--","HARPSICH","CELESTA-","ACCORDIO", \
    "LOHO1---","LOHO2---","FLIPFLAP","PLUTO---"]
    
# RED v2: all custom FM/OPLL instruments
instruments2 = [ \
    "--------","JARRE1--","ORGAN4--","BCALIOPE","ASYNCHOR","MARIMBA2","SYNTH3--","SYNTH4--","BASS2---","BELL2---", \
    "FLUTE2--","SYNTH5--","SWELBELL","SYNTHBEL","TOM3----","BELL3---","FLUTE4--","PLOK----","SYNTH7--","LEAD1---", \
    "LEAD2---","PIANO---","CLAVICOD","HARPSCD-","SYNPERCU","FLUTE---","KOTO2---","HUWAWA--","HARDROCK","SYNTH3--", \
    "SYNTH4--","SYNTLEAD","SYNTSTR2","NEWSYNTH","ACIDPIAN","PIPEORGN","FUNKORGN","ELTRONS1","ELTRONS2","VIOLIN--", \
    "SAXOPHO2","SAXOPHO3","MG-BELLS","AM-FUZZ-","BRASS2--","HEAVBRAS","TRUMPET1","TRUMPET2","INVASION","PIPEORGN", \
    "XYLOPHON","SANTOOL-","KOTO----","TAIKO---","SYNBELL-","CHIME---","SYNRHYTH","PIANO2--","SANTOOL2","BRASS---", \
    "CLAVICD2","CLAVICD3","PIPEORG2","POHDSPLA","ROHDSPLA","ORCH-L--","ORCH-R--","SYNVIOL-","SYNORGAN","SYNBRASS", \
    "SHAMISEN","MAGICAL-","WNDERFLT","MACHINE-","MACHINEV","SYNTH1--","SYNTH2--","STHSWEEP","SYNTHSF1","SYNTHSF2", \
    "SYNTHSF3","HEAVSYNT","LEADSYNT","SYNTSTR1","SMADSYNT","WOWSYNTH","SYNTPIAN","PIANO3--","PIANO4--","PIANO5--", \
    "ELPIANO1","ELPIANO2","ELPIANO3","ELPIANO4","SPACPIAN","DX7PIANO","TOYPIANO","ORGAN---","ELORGAN1","ELORGAN2", \
    "ELORGAM3","PORGAN1-","PORGAN2-","SF-ORGAN","STHBASS1","STHBASS2","SLAPBAS1","SLAPBAS2","SLAPBAS3","ELBASS1-", \
    "ELBASS2-","RASPBASS","BASS1---","BASS2---","SHRTBASS","COOLBASS","BASELINE","HOUSBASE","STRINGS1","STRINGS2", \
    "HEAVYSTR","PLUCKED1","PLUCKED2","PLUCKED3","SAXOPHO1","CLARINET","FLUTE1--","FLUTE2--","BLEUSFLU","SYNTHFLU", \
    "PICOLLO-","OBOE----","BASSOON-","HARMONIC","BAGPIPE1","BAGPIPE2","GLOCKSP1","GLOCKSP2","SPACGLCK","BELL1---", \
    "BELL2---","BELL3---","HANDBELL","SPACBEL1","SPACBEL2","BLUESGUI","SPANGUIT","ESPGUITR","FUZZGUIT","MARIMBA1", \
    "MARIMBA2","MARIMBA3","MARIMBA4","MARIMBA5","XYLOPHO1","XYLOPHO2","VIBRAPH1","VIBRAPH2","WAHBRASS","BELLBRAS", \
    "WAVESYNT","NEWWAVE1","TROMBONE","HORN----","TUBA1---","TUBA2---","KOTO----","BANJO---","HARP----","SITAR---", \
    "MEATYJOB","WAY OUT-","NICESOUN","ALIEN1--","ALIEN2--","ALIEN3--","ALIEN4--","STRANGE1","STRANGE2","STRANGE3", \
    "SE-STAR3","TERMINAT","COSMIC--","XENON---","MSX-PSG-","BELLPERC","SICHOR--","HARPSICH","CELESTA-","ACCORDIO", \
    "LOHO1---","LOHO2---","FLIPFLAP","PLUTO---"]    

# write data (7+2 chars) for PSG or FM track
def writePF(d, isPSG):
    d = bytearray(d)
    e = d[0] # effect number
    if not isPSG: d[1] = d[1] ^ 0b1111 # inverse FM volume bits
    dhex = d.hex().upper()
    if e == 1:
        f.write("OFF1-") # special notation for effect 1
    elif e == 2:
        f.write("OFF2-") # special notation for effect 2
    else:
        sh = 4 if isPSG else 0 # if PSG, shift 4 extra
        v = visibility[e] # 6 visibility bits (3 for FM, 3 for PSG)
        vNote = (v >> sh) & 1 # note visible?
        vVol = (v >> (sh+1)) & 1 # volume visible?
        vData = (v >> (sh+2)) & 1 # data visible?
        if vNote:
            f.write(chr( ((d[2] & 0b11100) >> 2) + 65 )) # note, like C/D/E/etc
            f.write("#" if d[2] & 2 == 2 else " ") # optional sharp sign
            f.write(chr( ((d[2] & 0b11100000) >> 5) + 49)) # octave nr
        else: 
            f.write("---") # note n.a. for this effect
        f.write(dhex[3] if vVol else "-")
        f.write(dhex[2] if vData else "-")
    f.write(dhex[0:2]) # effect number
    f.write("  ")

# write data (5+2 chars) for DR track
def writeDR(d):
    d = bytearray(d)
    for i in range(3): d[i] = d[i] ^ 0xff # inverse bits
    dhex = d.hex().upper().replace("0","-")
    li=[5,3,0,1,2] # order for Base,Snare,Tom,TopCymbal,HighHat
    for i in li: f.write(dhex[i])
    f.write("  ")

# write data (10 chars) for IN track
def writeIN(d):
    dhex = d.hex().upper()
    f.write(dhex) # instrument number in hex
    f.write(instruments[d[0]]) # name in 8 chars

def chunks(lst, n):
    # Yield successive n-sized chunks from lst.
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def writeLine(): # line with only dash('-') symbols
    f.write("-"*5)
    for t in range(14): 
        if trOn[t]: f.write("-"*(trWidths[t]+2))
    f.write('\n')

def writeNames(): # line with track names (P1, F2, DR, etc)
    f.write(" "*5)
    for t in range(14):
        if trOn[t]: f.write("  "+trkNames[t]+" "*(trWidths[t]-2))
    f.write('\n')

def getRowNr(r): # row number like '01-63'
    return '{0:02d}-{1:02d}'.format(r//64,r%64)

file_in = sys.argv[2]
file_out = sys.argv[3]

# differences between RED v1 and v2
redV = sys.argv[1] # version (1 or 2)
instruments = instruments1 if redV=="1" else instruments2
visibility = visibility1 if redV=="1" else visibility2

with open(file_in, 'rb') as f:
    data = f.read()

with open(file_out, 'wt') as f:
    # get song properties from binary data
    songName = data[128:128+19]
    composer = data[108:108+19]
    lastLine = int.from_bytes(data[150:152],byteorder='little')
    doRepeat = data[152] == 1
    repeatLine = int.from_bytes(data[153:155],byteorder='little')
    speed = int(data[148])
    fmMode = int(data[149])
    freqBase =  int(data[155])
    freqSnare =  int(data[156])
    freqTom =  int(data[157])
    startVoluInstr = data[158:159].hex().upper()
    # get the real song data for each track
    trData = list(chunks(data[0x100:0x1a100], 0x2000)) # 8192 bytes per track
    trDataIN = data[0x1a100:0x1b100] # but only 4096 for track IN
    # per track data
    trWidths = [7,7,7,7,7,7,7,7,7,7,7,7,5,10] # width in chars per track
    trkNames = ["P1","P2","P3","F1","F2","F3","F4","F5","F6","F7","F8","F9","DR","IN"]
    trOn = [0]*14 # which tracks are used in this song?
    trOn[0:3] = list(data[32:35]) # P1,P2,P3
    trOn[3:12] = list(data[48:57]) # F1,F2,F3,F4,F5,F6,F7,F8,F9
    trOn[12:13] = list(data[35:36]) # DR
    trOn[13:14] = list(data[46:47]) # IN
    # Write block with song properties  
    writeLine()
    f.write("Song name : " + songName.decode("utf-8") + "\n")
    f.write("Composer  : " + composer.decode("utf-8") + "\n")
    f.write("Last Row  : " + getRowNr(lastLine) + "\n")
    f.write("Repeat    : ")
    f.write("Yes (from row: " + getRowNr(repeatLine) + ")\n" if doRepeat else "No\n")
    f.write("Speed     : " + str(speed) + "\n")
    f.write("FM mode   : ")
    f.write("With drums (max 6 FM channels)\n" if fmMode==1 else "No drums (max 9 FM channels)\n")
    if fmMode==1: f.write("Drum pitch settings  : {0:d},{1:d},{2:d} (Base, Snare, Tom)\n".format(freqBase,freqSnare,freqTom))
    f.write("Init with Volume     : " + startVoluInstr[0] + " (all channels)\n")
    f.write("Init with Instrument : " + startVoluInstr[1] + " (all FM/OPLL channels)\n")
    # Write data lines
    for r in range(lastLine+1):
        if r%64 == 0: # start of new pattern?
            writeLine()
            writeNames()
            writeLine()
        i = r*4
        f.write(getRowNr(r) + "  ") # row nr like '01-63'
        for t in range(3): # PSG tracks
            if trOn[t]: writePF(trData[t][i:i+4], True)
        for t in range(3,12): # FM/OPLL tracks
            if trOn[t]: writePF(trData[t][i:i+4], False)
        if trOn[12]: writeDR(trData[12][i:i+4]) # DR track
        if trOn[13]: writeIN(trDataIN[r*2:r*2+1]) # IN track
        f.write('\n')
    # finished
    writeLine()
    f.write("End of song\n")



