# Replayer of a SNDH file with musics

<img src="https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/ASM/PLAY_VBL.png" width="200" height="100"/><br>
## PLAY_TC.S
Play music with TIMER C
- put sections
- init music before launch timer C
- display a sentence to quit the program
- add cut sound after de-init music

## PLAY_VBI.S (renamed from PLAY_VBL.S old file)
Play music under interrupt level 4
- put sections
- init first music by default
- init music before launch VBL
- managed VBL instructions
- add cut sound after de-init music

## PLAY_VBL.S (new routine!)
Play music with VBL $70.w

## PLAY_INT.S (new routine!)
Play music under one of seven VBL as $4D2

<img src="https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/ASM/NewDepack.png" width="200" height="100"/><br>
## PLAY_ICE.S (new routine!)
Decompact routine to Play music under Interruptions

### Nota
Use DEVPAC v2.0 to compile assembler code 

### Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
