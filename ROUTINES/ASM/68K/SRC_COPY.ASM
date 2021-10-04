; *************************************************************************
; ***                     COPY 32ko bytes in memory                     ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
;	a0.l : source address                                                   *
;	a1.l : destination address                                              *
; *************************************************************************
scr_copy:
	move.l	#1000-1,d7       ; Loop 1000 times (8 x 4 x 1000 = 32000)
.scr_loop:
	movem.l	(a0)+,d0-d6/a2   ; Move 8 long words into registers
	movem.l	d0-d6/a2,(a1)    ; Move them to screen 1
	add.l	#8*4,a1            ; Update two pointers to destination
	dbf	d7,.scr_loop         ; Loop until d7 less than 0
	rts