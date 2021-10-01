; *************************************************************************
; ***                     COPY 32ko bytes in memory                     ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
;	a0 : address source                                                     *
;	a1 : address destination                                                *
; *************************************************************************
scr_copy:
	move.l	#1000-1,d7       ; Loop 1000 times (8 * 4 * 1000 = 32000)
.scr_loop:
	movem.l	(a0)+,d0-d6/a2   ; Move 8 long words into registers
	movem.l	d0-d6/a2,(a1)    ; Move them to screen 1
	add.l	#8*4,a1            ; Update two pointers to destination
	dbf	d7,.scr_loop         ; Loop until d7 less than 0
	rts