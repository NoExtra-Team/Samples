; *************************************************************************
; ***                     Put Sprite with BLITTER                       ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = source address                                                   *
; a1.l = destination address                                              *
; d0.w = position X of the final destination screen (0..320)              *
; d1.w = position Y of the final destination screen (0..200)              *
; d2.w = number of bitplane to display (0..3)                             *
; d3.w = width of sprite                                                  *
; d4.w = height of sprite                                                 *
; *************************************************************************
put_sprite_on_screen:
	move.w  #-1,$ffff8a28.w               ; endmask 1
	move.w  #-1,$ffff8a2a.w               ; endmask 2
	move.w  #-1,$ffff8a2c.w               ; endmask 3

  move.b  #2,$ffff8a3a.w                ; op
  move.b  #3,$ffff8a3b.w                ; oplog - en mode TRANSFERT
	clr.b	$ffff8a3d.w                     ; skew est lance par defaut en "non partage du bus de donnee"

  move.w  #8,$ffff8a20.w                ; offsetxs
  move.w  #8,$ffff8a2e.w                ; offsetxd

	move.w	d3,d5                         ;
	lsr.w	#4,d5                           ; 
	move.w  d5,$ffff8a36.w                ; longueur = WIDTH/16

	lsl.w	#3,d5                           ; 8*(WIDTH/16)
  move.w	#160,d3                       ;
  sub.w	d5,d3                           ; 160-8*(WIDTH/16)
  add.w	#8,d3                           ; 160-8*(WIDTH/16)+8

  move.w  d3,$ffff8a22.w                ; offsetys = 160-8*(WIDHT/16)+8
  move.w  d3,$ffff8a30.w                ; offsetyd = 160-8*(WIDHT/16)+8

	moveq 	#0,d3                         ; calcul de la position finale dans l'ecran
	lsl.w	  #5,d1                         ; Y*32
	add.w	  d1,d1                         ; 
	add.w	  d1,d1                         ; Y*32*160
	move.w	d1,d3                         ; position Y
	lsr.w   #4,d0                         ; X/16
	lsl.w   #3,d0                         ; X/16*8
	add.w   d0,d3                         ; position Y
	add.l   d3,a1                         ; position sur l'écran final

.recopy:
	move.w  d4,$ffff8a38.w                ; HEIGHT
  move.l  a0,$ffff8a24.w                ; ecran source
  move.l  a1,$ffff8a32.w                ; ecran	destination
  move.b  #$c0,$ffff8a3c.w              ; launch blitter !
	addq.w  #2,a0                         ; plus one bitplane
	addq.w  #2,a1                         ; plus one bitplane
	dbra    d2,.recopy
  rts
