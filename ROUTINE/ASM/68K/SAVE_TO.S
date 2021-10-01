; *************************************************************************
; ***                    SAVE datas to a binary file                    ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************

****************
* MAIN PROGRAM *
****************

Begin:
	lea	data,a0
	bsr	f_create
	move.l	#fin-debut,d0
	lea	debut,a0
	bsr	f_write                      ; create new file
	bsr	f_close

	clr.w	-(sp)                      ; exit program
	trap	#1

***********************
* SUBROUTINES SECTION *
***********************

f_create:
	move.w	#0,-(sp)
	move.l	a0,-(sp)
	move.w	#$3c,-(sp)
	trap	#1
	add.l	#8,sp
	move.w	d0,handle
	rts

f_write:
	move.l	a0,-(sp)
	move.l	d0,-(sp)
	move.w	handle,-(sp)
	move.w	#$40,-(sp)
	trap	#1
	add.l	#12,sp
	rts

f_close:
	move.w	handle,-(sp)
	move.w	#$3e,-(sp)
	trap	#1
	addq.l	#4,sp
	rts

*****************
* DATAS SECTION *
*****************

handle:	;	handle of the file
	dc.w	0
data:	;	Path and name of the file to save
	dc.b	"E:\\DATA.DAT",0
	even

********************
* DATAS TO INCLUDE *
********************

debut:

; Put your datas here!

fin:
	even
