;
;       VBL replayer for unpacked SNDH files
;       Special example from Zorro2^NoExtra
;
;       Depending on your tune - all timers now free ;)
;
;       gwEm 2005, 2006, 2013, 2019, 2020, 2021
;

        SECTION TEXT

        move.l  4(sp),a5                ; address to basepage
        move.l  $0c(a5),d0              ; length of text segment
        add.l   $14(a5),d0              ; length of data segment
        add.l   $1c(a5),d0              ; length of bss segment
        add.l   #$1000,d0               ; length of stackpointer
        add.l   #$100,d0                ; length of basepage
        move.l  a5,d1                   ; address to basepage
        add.l   d0,d1                   ; end of program
        and.l   #-2,d1                  ; make address even
        move.l  d1,sp                   ; new stackspace

        move.l  d0,-(sp)                ; mshrink()
        move.l  a5,-(sp)                ;
        move.w  d0,-(sp)                ;
        move.w  #$4a,-(sp)              ;
        trap    #1                      ;
        lea     12(sp),sp               ;  

        clr.l   -(sp)                   ; supervisor mode
        move.w  #$20,-(sp)              ;
        trap    #1                      ;
        addq.l  #6,sp                   ;
        move.l  d0,oldusp               ; store old user stack pointer

        moveq   #1,d0                   ; Choice of the music (1 is default)
        jsr     MUSIC+0                 ; Init SNDH music

        move.l  $70.w,oldvbl            ; store old VBL
        move.l  #vbl,$70.w              ; steal VBL

        lea     display(pc),a0          ; display text
        pea     (a0)                    ;
        move    #9,-(a7)                ;
        trap    #1                      ;

m_loop  bsr     waitVbl                 ; Waiting after the VBL
        cmp.b   #$39,$fffffc02.w        ; SPACE key pressed ?
        bne.s   m_loop                  ;

        jsr     MUSIC+4                 ; End SNDH music
        lea     $ffff8800.w,a0          ; Cut sound
        move.l  #$8000000,(a0)          ; Voice A
        move.l  #$9000000,(a0)          ; Voice B
        move.l  #$a000000,(a0)          ; Voice C

        move.l  oldvbl,$70.w            ; restore VBL

        move.l  oldusp,-(sp)            ; user mode
        move.w  #$20,-(sp)              ;
        trap    #1                      ;
        addq.l  #6,sp                   ;

        clr.w   -(sp)                   ; pterm()
        move.w  #$4c,-(sp)              ;
        trap    #1                      ;

vbl     st      vsync                   ; Wait a little...
        movem.l	d0-d7/a0-a6,-(a7)       ;
        jsr     (MUSIC+8)               ; Play SNDH routine
        movem.l	(a7)+,d0-d7/a0-a6       ;
        rte

waitVbl move.l	a0,-(a7)                ; Vbl synchronisation
        lea     vsync,a0                ;
        sf      (a0)                    ;
.loop:	tst.b   (a0)                    ;
        beq.s  .loop                    ;
        move.l  (a7)+,a0                ;
        rts

        SECTION DATA

display:dc.b    "Press space key to quit..."
        dc.b    13,10,0
; uncompress SNDH file to include (this one needs 50Hz replay)
MUSIC:  incbin  "\MYM_V161\SOURCE\ASM\MUS\TEST_STE.SND"
        even

        SECTION BSS

vsync   ds.w    1
oldvbl: ds.l    1
oldusp: ds.l    1

        END
