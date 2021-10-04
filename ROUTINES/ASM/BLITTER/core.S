; *************************************************************************
; ***       CORE.S : example to use BLITTER with a graphic file         ***
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

	lea	save_pal(pc),a0              ; Save adresses parameters
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

	move.l	logic(pc),a0
	jsr	clear_screen_4_bitplanes_full ; clear logical screen

	move.l	#picture,a0              ; image source
	move.l	logic(pc),a1             ; screen destination
	move.w	#120,d0                  ; pos X = 120 in the screen
	move.w	#70,d1                   ; pos Y = 70 in the screen
	move.w	#3,d2                    ; bitplanes = 3
	move.w	#80,d3                   ; WIDTH of sprite
	move.w	#71,d4                   ; HEIGHT of sprite
	jsr	put_sprite_on_screen         ; put a sprite 4 bitplanes

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

	include	"CLR4PBF.ASM"            ; clear a 320x200 screen size in 4 bitplanes
	include "SPRITE.ASM"             ; display a sprite in 4 bitplanes

	SECTION DATA

BINARY:	even
	INCBIN	"SPRITE.PI1"
palette equ BINARY+02
picture equ BINARY+34

	SECTION BSS

old_stack:ds.l 1
save_pal: ds.l 8
logic:	  ds.l 1
video:	  ds.b SIZE_OF_SCREEN+256
	even
