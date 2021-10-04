; ***************************************
; ***        Test STE Hardware        ***
; ***************************************
; ***         Zorro 2/NoExtra         ***
; ***************************************
Launch_Blitter:
	move.w	#-1,-(sp)           ; View configuration
	move.w	#64,-(sp)           ; Mode BLIT
	trap	#14
	addq	#4,sp
	btst	#1,d0                 ; Check if blitter exists
	beq.s	.no_blit              ; if not straight out
	bset	#0,d0                 ; Activated
	move	d0,-(sp)
	move.w	#64,-(sp)           ; Mode BLIT
	trap	#14
	addq	#4,sp
	lea.l $ffff8a00.w,a1        ; Clear addresses!
	rept 8
	clr.l (a1)+
	endr
.no_blit:	
	rts

DoTest_STE:
	move.l	$5a0,a0             ; test STE hardware
	cmp.l	#$0,a0
	beq	.no_STE                 ; Pas de cookie_jar donc un vieux ST
	move.l	$14(a0),d0
	cmp.l	#$0,d0                ; _MCH=0 alors c' est un ST-STf.
	beq	.no_STE
; then it's ok !
	rts

DoTest_Blitter:
	move.w	#$80,-(a7)          ; disable and get status
	move.w	#64,-(a7)           ; blitmode
	trap	#14
	addq	#4,a7
	btst	#1,d0                 ; check blitter exists
	beq	.no_BLiTTER             ; if not straight out
; then it's ok !
	rts

.no_STE:
	move.l	#no_STE,message
	bsr	display_message
.no_BLiTTER:
	move.l	#no_BLiTTER,message
	bsr	display_message
	rts

display_message:
	move.l	#message,-(a7)
	move.w	#9,-(a7)
	trap	#1
	addq	#6,a7
	rts

noSTE:
	dc.b	'No STE found !',10,13,10,13
noBLiTTER:
	dc.b	'No Blitter.',10,13,10,13
	even
