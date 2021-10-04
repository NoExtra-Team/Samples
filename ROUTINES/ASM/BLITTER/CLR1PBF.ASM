; *************************************************************************
; ***        Clear a screen 320x200 in one bitplane with BLITTER        ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
; *************************************************************************
clear_screen_1_bitplane_full:
	move.w #0,$ffff8a20.w            ; source x inc
	move.w #0,$ffff8a22.w            ; source y inc
	move.w #-1,$ffff8a28.w           ; endmask 1
	move.w #-1,$ffff8a2a.w           ; endmask 2
	move.w #-1,$ffff8a2c.w           ; endmask 3
	move.w #8,$ffff8a2e.w            ; dest x inc
	move.w #8,$ffff8a30.w            ; dest y inc
	move.l a0,$ffff8a32.w            ; destination address
	move.w #(160/8),$ffff8a36.w      ; x count (n words per line to copy)
	move.w #200,$ffff8a38.w          ; y count (n lines to copy)
	move.b #%00000001,$ffff8a3a.w    ; blit hop (halftone mix)
	move.b #%00000000,$ffff8a3b.w    ; blit op (logic op)
	move.b #%11000000,$ffff8a3c.w    ; blitter control, start blitter
	rts
