; *************************************************************************
; ***               CORE.S : example to use 68k code                    ***
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

	jsr	PROTECT

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
	jsr	clear_blit                   ; clear logical screen

	move.l	#picture,a0              ; image source
	move.l	logic(pc),a1             ; screen destination
	jsr	scr_copy                     ; copy a 320x200 Degas picture in 4 bitplanes
	                                 ; in the logic screen

;------------------------------------------------------------------<

	move.w   #7,-(sp)                ; wait for a key press
	trap   #1   
	addq.l   #2,sp

	lea	save_pal(pc),a0              ; Restore adresses parameters
	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;

	jsr	DEPROTECT

	move.l   old_stack(pc),-(sp)     ; set user mode
	move.w   #32,-(sp)
	trap   #1
	addq.l   #6,sp

	clr.w   -(sp)                    ; Pterm()
	trap    #1                       ; EXIT program

	include	"PROTECT.ASM"            ; protect the code from BOMBS!
	include	"CLEARFUL.ASM"           ; clear a 320x200 screen size in 4 bitplanes
	include "SRC_COPY.ASM"           ; copy a Degas picture to screen

	SECTION DATA

BINARY:	even
	INCBIN	"K_SQUARE.PI1"
palette equ BINARY+02
picture equ BINARY+34

	SECTION BSS

old_stack:ds.l 1
save_pal: ds.l 8
logic:	  ds.l 1
video:	  ds.b SIZE_OF_SCREEN+256
	even
