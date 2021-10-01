**************************************************************************************
*	SND_TC_S.S
*
*	Assembler SNDH sound player routs from Gwem/Swe
*
*	[c] 2021 NoExtra-Team
**************************************************************************************

**************************************************************************************
;	EXPORTS / IMPORTS
**************************************************************************************

	export	Asm_SndhPlay
	export	Asm_SndhStop

	import	iSndhTune
	import	iSndhNumberOfMusic

**************************************************************************************
;	EQUATES
**************************************************************************************

FREQ_TC equ 200                  ; Frequency set to 200 Hz

**************************************************************************************
	TEXT
**************************************************************************************

Asm_SndhPlay:
	lea     sndhpoi(pc),a1          ;
	move.l  iSndhTune,(a1)+         ; SNDH Replayer file
	lea     oldcon(pc),a1           ;
	move.b  $484.w,(a1)+            ;
	clr.b   $484.w                  ; keyclick off
	lea     $ffff8800.w,a0          ; Cut sound
	move.l  #$8000000,(a0)          ; Voice A
	move.l  #$9000000,(a0)          ; Voice B
	move.l  #$a000000,(a0)          ; Voice C
	move.w  iSndhNumberOfMusic,d0   ; number of music to play
	move.l  sndhpoi(pc),a0          ;
	jsr     (a0)                    ; sndh init
	lea     oldvbl(pc),a0           ;
	move.l  $70.w,(a0)              ; store old vbl
	lea     vbl(pc),a0              ;
	move.l  a0,$70.w                ; new vbl
	rts

Asm_SndhStop:
	move.l  oldvbl(pc),$70.w	      ; restore timer c
	move.l	sndhpoi(pc),a0          ;
	jsr     4(a0)                   ; sndh deinit
	move.b	oldcon(pc),$484.w       ; restore key click
	lea     $ffff8800.w,a0          ; Cut sound
	move.l  #$8000000,(a0)          ; Voice A
	move.l  #$9000000,(a0)          ; Voice B
	move.l  #$a000000,(a0)          ; Voice C
	rts 

vbl:
	movem.l	a0-a6/d0-d7,-(sp)       ; save registers
	move.w	sr,-(sp)                ; store status reg
	move.w	#$2300,sr               ; enable interrupts
	move.l	sndhpoi(pc),a0          ;
	jsr     8(a0)                   ; call sndh interrupt routine
	move.w	(sp)+,sr                ; restore status register
	movem.l	(sp)+,a0-a6/d0-d7       ; resttore registers
	move.l	oldvbl(pc),-(sp)        ; system friendly ;)
	rts

**************************************************************************************
	DATA
**************************************************************************************

tccount:
	dc.w	FREQ_TC

**************************************************************************************
	BSS
**************************************************************************************

oldvbl:
	ds.l	1
sndhpoi:
	ds.l	1 
oldcon:
	ds.l	1
	even

**************************************************************************************
	END
**************************************************************************************