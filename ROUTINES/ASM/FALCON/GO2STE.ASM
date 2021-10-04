; ***************************************
; ***     Compatible STE Hardware     ***
; ***            for FALCON           ***
; ***************************************
; ***         Zorro 2/NoExtra         ***
; ***************************************
Begin:
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

	pea	.mainProgram(pc)
	move.w	#38,-(sp)
	trap	#14
	addq.l	#6,sp

	move.w	#88,-(sp)
	trap	#14
	addq.l	#4,sp
	
	move.w	#$22,-(sp)
	trap	#14
	addq.w	#2,sp
	move.l	d0,a0
	clr.l	$6c(a0)

	clr.w	-(sp)
	trap	#1

.mainProgram:
	move.b	#$45,$ffff8007.w
	rts