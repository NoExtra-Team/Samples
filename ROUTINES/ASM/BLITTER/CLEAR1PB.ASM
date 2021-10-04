; *************************************************************************
; ***        Clear a part of screen in one bitplane with BLITTER        ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
;	d0.w = x1                                                               *
;	d1.w = y1                      + x1-----------                          *
;	d2.w = x2                      y1-------------+ x2                      *
;	d3.w = y2                                     y2                        *
; *************************************************************************
clear_screen_1_bitplane:
.height:
  sub.w	d1,d3                    ; d3.w=y2-y1=dy.
  addq.w	#$1,d3                 ; d3=nombre de lignes.
  move.w	d1,d4                  ;
  add.w	d1,d1                    ;
  add.w	d1,d1                    ;
  add.w	d4,d1                    ;
  lsl.w	#$5,d1                   ; d1=y1*160.
  add.w	d1,a0                    ; a0 pointe sur la premiere ligne.
.width:                          ; Calculate the x_size and then the
  and.w	#$fff0,d0                ; d0=x1-x1 mod(16).
  and.w	#$fff0,d2                ; d2=x2-x2 mod(16).
  sub.w	d0,d2                    ;
  lsr.w	#$1,d0                   ;
  add.w	d0,a0                    ; a0 pointe sur le premier mot.
  lsr.w	#$1,d2                   ;
  move.w	d2,d4                  ; d4 sera le nb d' octets a passer.
  lsr.w	#$3,d2                   ;
  add.w	#$1,d2                   ; d2=nombre de mots par ligne.  
  neg.w	d4                       ;
  add.w	#$a0,d4                  ; d4=nb d' octets a passer.
.init_blitter:
	move.w #-1,$ffff8a28.w         ; endmask 1
	move.w #-1,$ffff8a2a.w         ; endmask 2
	move.w #-1,$ffff8a2c.w         ; endmask 3
	move.w #8,$ffff8a2e.w          ; dest x inc
	move.w d4,$ffff8a30.w          ; dest y inc
	move.l a0,$ffff8a32.w          ; destination address
	move.w d2,$ffff8a36.w          ; x count (n words per line to copy)
	move.w d3,$ffff8a38.w          ; y count (n lines to copy)
	move.b #%00000001,$ffff8a3a.w  ; blit hop (halftone mix)
	move.b #%00000000,$ffff8a3b.w  ; blit op (halftone mix)
	move.b #%11000000,$ffff8a3c.w  ; blitter control, start blitter
	rts
