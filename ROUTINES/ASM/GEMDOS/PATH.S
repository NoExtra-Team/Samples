; *************************************************************************
; ***              LOAD a file in the real PATH to be LOAD              ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
dgdrive          equ $19       ; Get the current drive                    *
dgpath           equ $47       ; Get the current path                     *
gemdos           equ 1         ; Trap #1                                  *
; *************************************************************************

	SECTION TEXT

Begin:
	clr.l      -(sp)         ; set supervisor mode (not necessary...)
	move.w     #32,-(sp)      
	trap       #1         
	addq.l     #6,sp
	move.l     d0,old_stack     

*--------------------------*
* Get the drive // DGETDRV *
*--------------------------*
; OUPUT in d0
; 0:Drive A
; 1:Drive B
; 2:Drive C
; 3:Drive D (etc.) 
	move.w     #dgdrive,-(sp); Dgetdrive
	trap       #gemdos       ; Recup le num‚ro
	addq.w     #2,sp         ; du lecteur actif
	and.w      #$f,d0        ; 0=A, B=1, etc...
	add.b      #"A",d0       ; Additionne la lettre pour le bon lecteur
	move.b     d0,Drive      ; et on modifie Drive pour qu'il pointe le bon lecteur

*--------------------------*
* Get the path // DGETPATH *
*--------------------------*
; INPUT in buffer - size 128 bits
; 0:Current drive (A, B, C, D, E, etc.)
; 1:Drive A
; 2:Drive B
; 3:Drive C (etc.) 
	move.w     #0,-(sp)      ; current drive used selected
	pea        Folder
	move.w     #dgpath,-(sp)
	trap       #gemdos
	addq.l     #8,sp

; Add the name of the file to load
	lea	Folder,a0            ; seeking character '0'
.find:
	move.b     (a0)+,d0
	cmp.b      #$0,d0
	bne.s      .find
	subq.w     #1,a0         ; position move before the '0'
	lea        Chemin,a1     ; add the name of the file
.fill:
	move.b     (a1)+,(a0)+
	cmp.l      #ending,a1
	bne.s      .fill

; Display drive + path + file to load from a buffer
	pea        Path          ; display final path and file
	move       #9,-(a7)
	trap       #1
	move.w     #7,-(sp)      ; wait for a key press
	trap       #1   
	addq.l     #2,sp

	move.l     old_stack(pc),-(sp) ; set user mode
	move.w     #32,-(sp)
	trap       #1
	addq.l     #6,sp

	clr.w      -(sp)          ; Pterm()
	trap       #1             ; EXIT program

	SECTION DATA

Path: ; path - chemin d'accès complet
Drive:
	dc.b	'Z:'
Folder:
	dcb.b	128,$7e            ; filled with bad characters '~'
	even

Chemin:
	dc.b	"\DATAS.HMD",0     ; name of the data to load - '0' mandatory at the end
	even
ending

	SECTION BSS

old_stack:
	ds.l 1
	even

	END
