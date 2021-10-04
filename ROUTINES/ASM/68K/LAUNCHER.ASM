*********************************************************************
***                  LOADER / LAUNCHER / PROGRAM                  ***
*********************************************************************
***                         ZORRO 2/NOEXTRA                       ***
*********************************************************************
SET_FLOPPY    equ	1    ; 0 =  Use only for floppy driver access     *
*********************************************************************
gemdos        equ	1                                                 *
crawcin       equ	7                                                 *
cconws        equ	9                                                 *
dgdrive       equ	$19                                               *
dspath        equ	$3b                                               *
fclose        equ	$3e                                               *
mfree         equ	$49                                               *
mshrink       equ	$4a                                               *
pexec         equ	$4b                                               *
*********************************************************************
Launch_it:
 IFEQ SET_FLOPPY
* Set the drive
	move.w     #dgdrive,-(sp);Dgetdrive
	trap       #gemdos       ;Recup le num‚ro
	addq.w     #2,sp         ;du lecteur actif
	and.w      #$f,d0        ;0=A, B=1, etc...
	add.b      #"A",d0       ;Additionne la lettre
	move.b     d0,Emp        ;et on modifie Emp pour qu'il pointe le bon lecteur
* Set the path
	pea        Emp           ;
	move.w     #dspath,-(sp) ;Dsetpath
	trap       #gemdos       ;
	addq.w     #6,sp         ;
 ENDC
* Set memories
	movea.l    4(sp),a5      ;Donner espace m‚moire
	move.l     12(a5),d0     ;Longueur du code
	add.l      20(a5),d0     ;+ Longueur du segment donn‚es
	add.l      28(a5),d0     ;+ Longueur du segment BSS +
	addi.l     #$1100,d0     ;Basepage (256 Bytes)
	move.l     d0,d1         ;Longueur plus
	add.l      a5,d1         ;adresse
	andi.l     #-2,d1        ;(arrondie)
	movea.l    d1,sp         ;donne pointeur pile
	move.l     a5,mstart     ;
* Set space stack
	move.l     d0,-(sp)      ;Longueur de l'espace m‚moire n‚cessaire
	move.l     mstart,-(sp)  ;Adresse de la zone m‚moire
	clr.w      -(sp)         ;octet "dummy" sans importance
	move.w     #mshrink,-(sp);
	trap       #gemdos       ;
	adda.l     #12,sp        ;
* Launch program
	pea        environ       ;Postchargement du programme
	pea        params        ;
	pea        Prog          ;
	clr.w      -(sp)         ;Nul -> Charger et lancer imm‚diatement
	move.w     #pexec,-(sp)  ;
	trap       #gemdos       ;
	adda.l     #16,sp        ;
* Error ?
	tst.w      d0            ;Erreur?
	bmi.s      error         ;
* Close file
	move.w     d0,-(sp)      ;Fermer le fichier.
	move.w     #fclose,-(sp) ;
	trap       #gemdos       ;
	addq.l     #4,sp         ;
* Release memory
	move.l     mstart,-(sp)  ;Libère la mémoire utilisée
	move.w     #mfree,-(sp)  ;
	trap       #gemdos       ;
	adda.l     #12,sp        ;
* End
no_more:
	clr.w      -(sp)         ;pterm0 - end...
	trap       #gemdos       ;
	rts

error:
* Set User Mode
	clr.l      -(sp)         ;Set super stack equal
	move.w     #$20,-(sp)    ; to user stack before call
	trap       #gemdos       ;
	addq.l     #6,sp		     ;correct stack
	move.l     d0,Save_stack;save old supervisor stack value

	move.w     #$0700,$ffff8240.w ;red alert

	pea        errtext       ;Affichage du message d'erreur
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp
					
	move.w     #crawcin,-(sp);Attendre appui touche...
	trap       #gemdos
	addq.l     #2,sp
	
	move.w     #$777,$ffff8240.w

* Set Super Mode
	move.l     Save_stack,-(sp);
	move.w     #$20,-(sp)    ;
	trap       #gemdos       ;back to user mode
	addq.l     #6,sp         ;correct stack

	bra.w      no_more       ;Quittez !
	rts

Prog:
	dc.b 'E:\Random\77.PRG',0
errtext:
	dc.b "PROBLEMS TO LOAD...",13,10,10,0
params:
	dc.b $0                   ;aucun paramŠtre et
environ:
	dc.b $0                   ;aucun environnement
mstart:
	dc.l $0
 IFEQ SET_FLOPPY
Emp:
	dc.b 'Z:\',0             ;path - chemin d'accès
 ENDC
Save_stack:
	dc.l $0
	even

