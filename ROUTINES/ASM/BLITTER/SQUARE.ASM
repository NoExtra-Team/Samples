; *************************************************************************
; ***   Square 100x160 one bitplane  on the 2nd bitplane with BLITTER   ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
; ------------------------------------------------------------------------*
WIDHT  equ 100 ; largeur                                                  *
HEIGHT equ 160 ; hauteur                                                  *
; *************************************************************************
put_square_one_bitplane:
	move.w  #-1,$ffff8a28.w               ; endmask 1
	move.w  #-1,$ffff8a2a.w               ; endmask 2
	move.w  #-1,$ffff8a2c.w               ; endmask 3

 	move.b  #1,$ffff8a3a.w                ; blit hop (halftone mix)
  move.b  #15,$ffff8a3b.w               ; oplog - on efface avec la couleur du plan sélectionné avec des $ff

  move.w  #0,$ffff8a20.w                ; offsetxs
  move.w  #0,$ffff8a22.w                ; offsetys
  move.w  #8,$ffff8a2e.w                ; offsetxd   
  move.w  #(160-8*(WIDHT/16)),$ffff8a30.w	; offsetyd   
  move.w  #(WIDHT/16)+1,$ffff8a36.w     ; longueur

	move.w  #HEIGHT,$ffff8a38.w           ; hauteur
	move.l  a0,$ffff8a32.w                ; ecran	destination
  move.b  #$c0,$ffff8a3c.w              ; launch blitter !
  rts
