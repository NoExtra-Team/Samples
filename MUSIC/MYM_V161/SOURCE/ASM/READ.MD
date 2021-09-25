# Replayer of a SNDH file with musics

PLAY_TC.S
Play music with TIMER C
- put sections
- init music before launch timer C
- display a sentence to quit the program
- add cut sound after de-init music

PLAY_VBI.S (renamed from PLAY_VBL.S old file)
Play music under interrupt level 4
- put sections
- init first music by default
- init music before launch VBL
- managed VBL instructions
- add cut sound after de-init music

PLAY_VBL.S (new routine!)
Play music with VBL $70.w

PLAY_INT.S (new routine!)
Play music under one of seven VBL as $4D2

PLAY_ICE.S (new routine!)
Decompact routine to Play music under Interruptions
