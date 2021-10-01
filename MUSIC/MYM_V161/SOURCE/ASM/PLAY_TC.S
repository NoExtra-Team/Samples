;
;       Timer C replayer for unpacked SNDH files
;       Special example for Frequent and Nerve/Ephidrena
;
;       gwEm 2005, 2006, 2013, 2019, 2020, 2021
;

R_FREQ  equ     200                     ; SNDH replay frequency here (200Hz in this example)
S_TUNE  equ     2                       ; SNDH sub-tune number

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

        moveq   #S_TUNE,d0              ; select sub-tune 2
        jsr     MUSIC+0                 ; init music

        move.l  $114.w,oldtc            ; store old timer C vector
        move.l  #timer_c,$114.w         ; steal timer C

        lea     display(pc),a0          ; display text
        pea     (a0)                    ;
        move    #9,-(a7)                ;
        trap    #1                      ;

        move.w  #7,-(sp)                ; wait for a key
        trap    #1                      ;
        addq.l  #2,sp                   ;

        jsr     MUSIC+4                 ; de-init music

        move.l  oldtc,$114.w            ; restore timer C

        lea     $ffff8800.w,a0          ; Cut sound
        move.l  #$8000000,(a0)          ; Voice A
        move.l  #$9000000,(a0)          ; Voice B
        move.l  #$a000000,(a0)          ; Voice C

        move.l  oldusp,-(sp)            ; user mode
        move.w  #$20,-(sp)              ;
        trap    #1                      ;
        addq.l  #6,sp                   ;

        clr.w   -(sp)                   ; pterm()
        move.w  #$4c,-(sp)              ;
        trap    #1                      ;

timer_c sub.w   #R_FREQ,tccount         ; you can use any replay rate here less than or equal to 200Hz
        bgt.s   .nocall                 ; dont call zak this time
        add.w   #200,tccount            ; syntheses any freq from 200hz system tick

        move.w  sr,-(sp)                ; store status word - system friendly, but not needed in a demo i guess
        move.w  #$2500,sr               ; enable timer interrupts
        jsr     MUSIC+8                 ; call music
        move.w  (sp)+,sr                ; restore status word

.nocall move.l  oldtc,-(sp)             ; go to old vector (system friendly ;) )
        rts

        SECTION DATA

display:dc.b    "Press a key to quit..."
        dc.b    13,10,0
; uncompress SNDH file to include (this one needs 50Hz replay)
MUSIC:  incbin  "\MYM_V161\SOURCE\ASM\MUS\MULTSNDH.SND"
        even

        SECTION BSS

oldtc:  ds.l    1
oldusp: ds.l    1
tccount ds.w    1

        END