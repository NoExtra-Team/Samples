; *************************************************************************
; ***      Clear a part of screen in four bitplanes with BLITTER        ***
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
clear_screen_4_bitplanes:
.height:
  sub.w	d1,d3                       ; d3=dy=y2-y1.
  addq.w	#$1,d3                    ; d3=nb of h_lines to clear.
  move.w	d1,d4                     ; Multiply y1 by $a0.
  add.w	d1,d1                       ;
  add.w	d1,d1                       ;
  add.w	d4,d1                       ;
  lsl.w	#$5,d1                      ;
  add.w	d1,a0                       ; a0 points on the first line to clear.
.width:                             ; Calculate the x_size and then the
  and.w	#$fff0,d0                   ; d0=x1-x1 mod(16).
  and.w	#$fff0,d2                   ; d2=x2-x2 mod(16).
  sub.w	d0,d2                       ; d2=(nb of words-1)*16.
  lsr.w	#$1,d0
  add.w	d0,a0                       ; a0 points on the first word.
  lsr.w	#$2,d2                      ; d2=nb of words-4.
  addq.w	#$4,d2                    ; d2=nb of words to clear.
  move.w	#$51,d0
  sub.w	d2,d0                       ; d0=inc_y_dest.
  lsl.w	#$1,d0                      ; It must be given in bytes.
.init_blitter:
	move.l  #-1,$ffff8a28.w           ; endmask 1
	move.w  #-1,$ffff8a2a.w           ; endmask 2
  move.w  #2,$ffff8a2e.w            ; offsetxd   
  move.w  d0,$ffff8a30.w	          ; offsetyd   
  move.l  a0,$ffff8a32.w            ; destination address
  move.w  d2,$ffff8a36.w            ; width
	move.w  d3,$ffff8a38.w            ; height
 	move.w  #%1000000000,$ffff8a3a.w  ; blit hop (halftone mix)
	move.b  #%11000000,$ffff8a3c.w    ; blitter control, start blitter
	rts
