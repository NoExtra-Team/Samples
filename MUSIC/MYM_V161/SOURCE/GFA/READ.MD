# Replayer of a SNDH file with musics

(https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/GFA/PLAY_TC)<br>
PLAY_TC.LST
Play sndh music with Timer C
- add path to load files
- bload inline buffers
- add number of the musdic to replay
- add sentence to quit program
- add comments

GWEMSNDH.S
SNDH Replayer under interrupts with TIMER C
- add compilation options
- put sections
- add cut sound after de-init music
- add number of the musdic
- add comments

(https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/GFA/PLAY_VBL)<br>
PLAY_VBL.LST
SNDH Replayer under interrupts with Vbl $4D2.w
- load a SNDH file
- play the music without asm routs

Nota : used DEVPAC v3.0 to compile asm code and GFA BASIC v3.5 to merge listing
