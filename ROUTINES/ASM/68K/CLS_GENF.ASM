; *************************************************************************
; ***           CLEAR a 320x200 screen in four bitplane                 ***
; *************************************************************************
; ***                        Zorro 2/NoExtra                            ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
;	a0.l : destination address                                              *
; ------------------------------------------------------------------------*
; note : call GenerateClsRout before call ClearScreenFast                 *
; *************************************************************************
ClearScreenFast:
	lea 160*200(a0),a0
	moveq #0,d0
	move.l d0,d1
	move.l d0,d2
	move.l d0,d3
	move.l d0,d4
	move.l d0,d5
	move.l d0,d6
	move.l d0,d7
	move.l d0,a1
	move.l d0,a2
	move.l d0,a3
	move.l d0,a4
	move.l d0,a5
	move.l d0,a6
	jmp FastClsMem(pc)

GenerateClsRout:
	lea FastClsMem,a0
	movem.l ClearReg(pc),d0-d1
	move #571-1,d3
.loop:
	move.l d0,(a0)+
	dbf d3,.loop
	move.l d1,(a0)+
	move.w #$4E75,(a0)
	rts

ClearReg:
	movem.l d0-d7/a1-a6,-(a0)
	movem.l d0-d5,-(a0)

FastClsMem:
	ds.l 580
	even