;
; GFA basic inline for SNDH replay
;
; original by swe/yescrew
; ripped and improved a little by gwEm
;   (still not perfect, but...)
;
;   Fixed version by Zorro2^NoExtra
; - Use DEVPAC v3.00 to compile ASM -
;

        OPT	CHKPC                       ; make sure PC relative code
        OPT	o+                          ; optimisations on
        OPT x+                          ; Extended debug ON

        SECTION TEXT

FREQ_TC equ 200                         ; Frequency set to 200 Hz

        bra.w   start                   ; player+2
        bra.w	  stop                    ; player+4

start   lea     sndhpoi(pc),a1          ;
        move.l  a6,(a1)+                ; gfa register 14 = start of sndh
        lea     sndhfrq(pc),a1          ;
        move.w  d7,(a1)+                ; gfa register 7  = replay freq
        move.b  $484.w,(a1)+            ;
        clr.b   $484.w                  ; keyclick off
        move.l  #$08000000,$ffff8800.w  ; die
        move.l  #$09000000,$ffff8800.w  ; die
        move.l  #$0A000000,$ffff8800.w  ; die ;)
        move.w  d6,d0                   ; gfa register 6  = number of music to play
        move.l  sndhpoi(pc),a0          ;
        jsr     (a0)                    ; sndh init
        lea     oldtc(pc),a0            ;
        move.l  $114.w,(a0)             ; store old timer c
        lea     newtc(pc),a0            ;
        move.l  a0,$114.w               ; new timer c vector
        rts

stop	  move.l  oldtc(pc),$114.w	      ; restore timer c
      	move.l	sndhpoi(pc),a0          ;
      	jsr     4(a0)                   ; sndh deinit
        move.b	oldcon(pc),$484.w       ; restore key click
        lea     $ffff8800.w,a0          ; Cut sound
        move.l  #$8000000,(a0)          ; Voice A
        move.l  #$9000000,(a0)          ; Voice B
        move.l  #$a000000,(a0)          ; Voice C
      	rts 

newtc   movem.l	a0-a6/d0-d7,-(sp)       ;
        lea    tccount(pc),a0		        ; synthese any replay rate from timer c
        move.w sndhfrq(pc),d0		        ;
        sub.w	d0,(a0)                   ;
        bgt.s	.nosndh                   ;
        add.w	#FREQ_TC,(a0)             ;
.dosndh move.w	sr,-(sp)                ; store status reg
        move.w	#$2300,sr               ; enable interrupts
        move.l	sndhpoi(pc),a0          ;
        jsr     8(a0)                   ; call sndh interrupt routine
        move.w	(sp)+,sr                ; restore status register
.nosndh movem.l	(sp)+,a0-a6/d0-d7       ;
      	move.l	oldtc(pc),-(sp)         ; system friendly ;)
      	rts

        SECTION DATA

tccount	dc.w	FREQ_TC

        SECTION BSS

oldtc   ds.l	1
sndhpoi	ds.l	1 
sndhfrq	ds.w	1
oldcon	ds.b	1
        even

        END
