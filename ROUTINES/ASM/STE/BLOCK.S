; *************************************************************************
; ***        BLOCK.S : example to use BLITTER with memory block         ***
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

	jsr	Launch_Blitter               ; Lauch Blitter for operations

	move.l	logic(pc),a0             ; screen destination
	move.w	#4-1,d0                  ; number of bitplanes to clear
	move.w	#SIZE_OF_SCREEN,d1       ; size or length of memory block
	jsr	clear_block_blit             ; clear screen in 4 bitplanes

	move.l	#picture,a0              ; image source
	move.l	logic(pc),a1             ; screen destination
	move.w	#4-1,d0                  ; number of bitplanes to display
	move.w	#SIZE_OF_SCREEN,d1       ; size or length of memory block
	jsr	rcopy_block_blit             ; recopy 32k of memory to screen in 4 bitplanes

	* more faster operations here :)
	move.l	logic(pc),a0             ; screen destination
	move.w	#SIZE_OF_SCREEN,d0       ; size or length of memory block
	jsr	clear_block_blit_full        ; Fill à screen - part of memory - with "0"

	move.l	#picture,a0              ; image source
	move.l	logic(pc),a1             ; screen destination
	move.w	#SIZE_OF_SCREEN,d0       ; memory block size or length
	jsr	rcopy_block_blit_full        ; recopy a block of memory to screen

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

	include	"HARDWARE.ASM"           ; test Blitter and STE hardware
	include	"BLK_BLIT.ASM"           ; copy memory block via Blitter

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
