# Replayer of SNDH file with musics

<img src="https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/GFA/PLAY_TC.png" width="200" height="100"/><br>
## PLAY_TC.LST
Play sndh music with Timer C<br>
- add path to load files<br>
- bload inline buffers<br>
- add number of the musdic to replay<br>
- add sentence to quit program<br>
- add comments<br>

<img src="https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/GFA/PLAYER.ASM/GWEMSNDH.png" width="200" height="100"/><br>
## GWEMSNDH.S
SNDH Replayer under interrupts with TIMER C<br>
- add compilation options<br>
- put sections<br>
- add cut sound after de-init music<br>
- add number of the musdic<br>
- add comments<br>

<img src="https://github.com/NoExtra-Team/Samples/blob/master/MUSIC/MYM_V161/SOURCE/GFA/PLAY_VBL.png" width="200" height="100"/><br>
## PLAY_VBL.LST
SNDH Replayer under interrupts with Vbl $4D2.w<br>
- load a SNDH file<br>
- play the music without asm routs<br>

### Nota
Use DEVPAC v3.0 to compile assembler code and GFA BASIC v3.5 to merge listing

### Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.