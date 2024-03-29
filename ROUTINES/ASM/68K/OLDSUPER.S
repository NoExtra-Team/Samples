; *************************************************************************
; ***                 Launch a proggy in SUPER mode                     ***
; ***                       ATARI ST / FALCON                           ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
Debut:
	move.w	#-1,-(sp)
	move.w	#88,-(sp)
	trap	#14
	addq.l	#4,sp
	cmp.w	#88,d0
	bne.s	.ItsAFalcon
	lea	main,sp
	move.w	#4,-(sp)
	trap	#14

	move.w	d0,(sp)
	cmp.w	#2,d0
	beq.s	.Skip
	clr.w	-(sp)
	pea	-1.w
	pea	-1.w
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

.Skip:
	pea	.Main000(pc)
	move.w	#38,-(sp)
	trap	#14
	addq.l	#6,sp

	pea	-1.w
	pea	-1.w
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

.TheEnd:
	move.w	#$22,-(sp)
	trap	#14
	addq.w	#2,sp
	move.l	d0,a0
	clr.l	$6c(a0)

	clr.w	-(sp)
	trap	#1

.ItsAFalcon:
	move.w	d0,-(sp)
	moveq	#1,d1
	move.w	d1,-(sp)
	move.w	d1,-(sp)
	clr.w	-(sp)
	move.w	#8,-(sp)
	move.w	#$8b,-(sp)
	trap	#14
	move.w	#3,(sp)
	move.w	#4,-(sp)
	move.w	#$82,-(sp)
	move.w	#3,(sp)
	move.w	#5,-(sp)
	move.w	#$82,-(sp)
	lea	18(sp),sp
	moveq	#$30,d0
	and.w	(sp),d0
	or.w	#$82,d0
	move.w	d0,-(sp)
	move.w	#88,-(sp)
	trap	#14
	addq.l	#4,sp

	pea	.Main030(pc)
	move.w	#38,-(sp)
	trap	#14
	addq.l	#6,sp

	move.w	#88,-(sp)
	trap	#14
	addq.l	#4,sp
	bra.s	.TheEnd

.Main030:
	move.l	$4ba.w,a0
	lea	200(a0),a0
.Wait030:
	cmp.l	$4ba.w,a0
	bgt.s	.Wait030	
	move.w	#$808,d0
	dc.l	$4e7b0002		; "movec d0,CACR"
.Main000:
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,.Colors	
	move.l	usp,a0
	pea	(a0)
	move.l	$fffffa06.w,-(sp)
	move.l	$fffffa12.w,-(sp)
	move.l	$70.w,-(sp)
	move.l	$68.w,-(sp)
	move.l	#.HBL,$68.w
	move.l	#.VBL,$70.w
	clr.l	$fffffa06.w
	clr.l	$fffffa0a.w
	clr.l	$fffffa0e.w
	clr.l	$fffffa12.w
	bsr.s	.FlushKB
	move.w	$ffff8260.w,-(sp)
	stop	#$2300
	stop	#$2300
	clr.b	$ffff8260.w
	bsr	Main_proggy
	move.w	#$2700,sr
	bsr.s	.FlushKB
	move.l	#.VBL,$70.w
	clr.l	$fffffa06.w
	clr.l	$fffffa0a.w
	clr.l	$fffffa0e.w
	clr.l	$fffffa12.w
	stop	#$2300
	stop	#$2300
	move.w	(sp)+,$ffff8260.w
	move.w	#$2700,sr
	move.l	(sp)+,$68.w
	move.l	(sp)+,$70.w
	move.l	(sp)+,$fffffa12.w
	move.l	(sp)+,$fffffa06.w
	bset	#3,$fffffa17.w
	movem.l	.Colors(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.l	(sp)+,a0
	move.l	a0,usp
	move.w	(sp)+,sr
	rts

.FlushKB:
	moveq	#-96,d0
	and.b	$fffffc00.w,d0
	beq.s	.EndFlush
	move.b	$fffffc02.w,d0
	bra.s	.FlushKB
.EndFlush:
	rts	

.VBL:
	addq.w	#1,.Vsync
.HBL:
	rte
.Vsync	dc.w	0
.Colors	ds.w	16
	even

Main_proggy:
