; *************************************************************************
; ***                      SAVE and RESTORE Program                     ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
PROTECT:
	LEA       OLD_ERROR,A0
	MOVE.L    8.W,(A0)+ 
	MOVE.L    $C.W,(A0)+
	MOVE.L    $14.W,(A0)+ 
	MOVE.L    #BUS_ERROR,8.W         ; Save for Bus error
	MOVE.L    #ADRESS_ERROR,$C.W     ; Save for address access error
	MOVE.L    #DIV0,$14.W            ; Sav division by zero
	RTS

DEPROTECT:
	LEA       OLD_ERROR,A0
	MOVE.L    (A0)+,8.W 
	MOVE.L    (A0)+,$C.W
	MOVE.L    (A0)+,$14.W
SORTIE: 	                         ;	the end of the program
	RTS

BUS_ERROR:
	MOVE.L    #$20425553,$200.W 
	MOVE.L    10(A7),$204.W 
	MOVE.L    #SORTIE,2(A7) 
	MOVE.W    #$2700,(A7) 
	RTE 

ADRESS_ERROR:
	MOVE.L    #$20414452,$200.W 
	MOVE.L    10(A7),$204.W 
	MOVE.L    #SORTIE,2(A7) 
	MOVE.W    #$2700,(A7) 
	RTE 

DIV0:
	MOVE.L    #$44495630,$200.W 
	MOVE.L    2(A7),$204.W
	MOVE.L    #SORTIE,2(A7) 
	MOVE.W    #$2700,(A7) 
	RTE 

OLD_ERROR:
	DCB.W	6,$0 
