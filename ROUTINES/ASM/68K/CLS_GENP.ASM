; *************************************************************************
; ***            CLEAR a part of screen in one bitplane                 ***
; *************************************************************************
; ***               GT Turbo/CVS and Zorro 2/NoExtra                    ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
;	a0.l : destination address                                              *
; ------------------------------------------------------------------------*
; call : Code_generate with d0.w register to 0 (filler)                   *
; *************************************************************************
NB_LIGNE_GENERE equ	200-1 ; Width, number of line                         *
NB_BLOC_SUPP    equ	20-1  ; Height, calculate as 20 x 16 blocs by line    *
PLAN_CLS        equ	0     ; Bitplane, which bitplane to clear             *
; *************************************************************************

Generate_code:
	lea Code_generate,a0
	move.w	#NB_LIGNE_GENERE,d7               ; Nombre de lignes
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6                    ; Nombre de blocs
	move.w	d4,d5
	add.w	#PLAN_CLS,d5                        ; Plan choisit
Genere_une_ligne:
	move.w	#$3140,(a0)+                      ; Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+                          ; et voila l'offset $xx
	addq.w	#8,d5                             ; pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4                             ; ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)                       ; Et un RTS !!
	rts

Code_generate:
	ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		; Place pour le code genere
									   									      ; pour l'effacement de l'element
	ds.w	1                                   ; Place pour le rts
rien:
	ds.b	10000                               ; Au cas ou ??
	even