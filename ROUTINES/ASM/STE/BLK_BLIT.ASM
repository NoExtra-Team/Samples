; *************************************************************************
; ***                 Copy memory block with BLITTER                    ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = source address                                                   *
; a1.l = destination address                                              *
; d0.w = number of bitplane to display (0..3)                             *
; d1.w = length of block                                                  *
; *************************************************************************
rcopy_block_blit:
  move.w  #8,$ffff8a20.w           ; offsetxs
  move.w  #8,$ffff8a2e.w           ; offsetxd

  move.b  #2,$ffff8a3a.w           ; hop
  move.b  #3,$ffff8a3b.w           ; oplog - transfert mode
	clr.b	$ffff8a3d.w                ; skew est lancé par defaut en "non partage du bus de donnees"

	divs	#8,d1                      ; size of block / 8 bits

.recopy:
  move.l  a0,$ffff8a24.w           ; ecran source
  move.l  a1,$ffff8a32.w           ; ecran destination
	move.w  d1,$ffff8a36.w           ; WIDTH
	move.w  #1,$ffff8a38.w           ; HEIGHT
  move.b  #$c0,$ffff8a3c.w         ; launch blitter !
	addq.w  #2,a0                    ; plus one bitplane
	addq.w  #2,a1                    ; plus one bitplane
	dbra    d0,.recopy
	rts

; *************************************************************************
; ***                 Clear memory block with BLITTER                   ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
; d0.w = number of bitplane to display (0..3)                             *
; d1.w = length of block                                                  *
; *************************************************************************
clear_block_blit:
  move.w  #8,$ffff8a20.w           ; offsetxs

  move.b  #0,$ffff8a3a.w           ; hop
  move.b  #0,$ffff8a3b.w           ; oplog - fill to zero
	clr.b	$ffff8a3d.w                ; skew est lancé par defaut en "non partage du bus de donnees"

	divs	#8,d1                      ; size of block / 8 bits

.clean:
  move.l  a0,$ffff8a32.w           ; ecran destination
	move.w  d1,$ffff8a36.w           ; WIDTH
	move.w  #1,$ffff8a38.w           ; HEIGHT
  move.b  #$c0,$ffff8a3c.w         ; launch blitter !
	addq.w  #2,a0                    ; plus one bitplane
	addq.w  #2,a1                    ; plus one bitplane
	dbra    d0,.clean
	rts

