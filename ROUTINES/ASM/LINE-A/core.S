; *************************************************************************
; ***        CORE.S : example to use LINE-A with a graphic file         ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************

	opt	X+

	SECTION TEXT

SIZE_OF_SCREEN equ 160*200         ; only one screen used

Begin:
	clr.l   -(sp)                    ; set supervisor mode
	move.w   #32,-(sp)      
	trap   #1         
	addq.l   #6,sp
	move.l   d0,old_stack     

	lea	save_pal,a0                  ; Save adresses parameters
	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)

	movem.l	palette,d0-d7            ; put palettte
	movem.l	d0-d7,$ff8240

	move.l	#video+256,d0            ; Create logical video screen
	clr.b	d0                         ;
	move.l	d0,logic                 ;
	lsr.w	#8,d0                      ;
	move.l	d0,$ffff8200.w           ; Put logic screen in monitor
	clr.b	$ffff820d.w                ;

;------------------------------------------------------------------>

	move.l	#picture,a0              ; image source
	move.l	logic,a1                 ; screen destination
	move.w	#0,d0                    ; pos X in the picture
	move.w	#0,d1                    ; pos Y in the picture
	move.w	#164,d2                  ; WIDTH of sprite
	move.w	#200,d3                  ; HEIGHT of sprite
	move.w	#4,d4                    ; Number of plane
	jsr	DoBLiTTER__Copy_Buffer       ; put a sprite 4 bitplanes

	move.l	#picture,a0              ; image source
	move.w	#8,d2                    ; pos X in the picture
	move.w	#3,d3                    ; pos Y in the picture
	move.w	#164-8,d4                ; WIDTH of bloc
	move.w	#196-3,d5                ; HEIGHT of bloc
	move.w	#4,d6                    ; Number of plane
	move.l	logic,a1                 ; screen destination
	move.w	#160,d0                  ; pos X in the screen
	move.w	#3,d1                    ; pos Y in the screen
	bsr	DoBLiTTER__Operation         ; put a sprite 4 bitplanes

;------------------------------------------------------------------<

	move.w   #7,-(sp)                ; wait for a key press
	trap   #1   
	addq.l   #2,sp

	lea	save_pal(pc),a0              ; Restore adresses parameters
	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;

	move.l   old_stack(pc),-(sp)     ; set user mode
	move.w   #32,-(sp)
	trap   #1
	addq.l   #6,sp

	clr.w   -(sp)                    ; Pterm()
	trap    #1                       ; EXIT program

	include "COPYBLIT.ASM"           ; display a sprite in 4 bitplanes
	include "OPERBLIT.ASM"           ; display a sprite in 4 bitplanes

	SECTION DATA

BINARY:	even
	INCBIN	"GUERRIER.PI1"	         ; from Dieu^HMD - size of sprite = 164 x 197
palette equ BINARY+02
picture equ BINARY+34

	SECTION BSS

old_stack:ds.l 1
save_pal: ds.l 8
logic:	  ds.l 1
video:	  ds.b SIZE_OF_SCREEN+256
	even

	END