; *************************************************************************
; ***          Clear a screen 320x200 each bitplanes with BLITTER       ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
; *************************************************************************
clear_screen_bitplanes_full:
	move.w  #-1,$ffff8a28.w               ; endmask 1
	move.w  #-1,$ffff8a2a.w               ; endmask 2
	move.w  #-1,$ffff8a2c.w               ; endmask 3

 	move.b  #1,$ffff8a3a.w                ; blit hop (halftone mix)
  move.b  #0,$ffff8a3b.w                ; oplog - on efface avec des $0

  move.w  #8,$ffff8a2e.w                ; offsetxd   
  move.w  #(160-8*(320/16)),$ffff8a30.w	; offsetyd   
  move.w  #(320/16)+1,$ffff8a36.w       ; longueur

	move.l  #3,d0                         ; Tous les plans
clear:
	move.w  #200,$ffff8a38.w              ; hauteur
  move.l  a0,$ffff8a32.w                ; ecran	destination
  move.b  #$c0,$ffff8a3c.w              ; launch blitter !
	addq.w  #2,a0                         ; plus one bitplane
	dbra    d0,clear
	rts
