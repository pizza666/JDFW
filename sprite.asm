; basic ASM loader
*=$0801   ; starting address of the program
!basic

!zone CONSTS
; imports
!source "_includes\const_memmap.asm"
!source "_includes\const_colors.asm"
!source "_includes\const_kernal.asm"
; local const


VIC					 			= $d000
SPRITEPOINTER0		= $07f8
SPR0_X			 			= $d000
SPR0_Y			 			= $d001
SPR_X_9BIT	 			= $d010
SPR0_COLOR   			= $d027
SPR0_ENABLE  			= $d015
SPR_RAM			 			= 828
SPR_CMODE		 			= $d01c
SPR_MC1			 			= $d025
SPR_MC2			 			= $d026
SPR0_COLOR   			= $d027
JOY2				 			= $dc00
SPR_LEFT					= 42
SPR_RIGHT					= 40
SPR_JUMP					= 41



!zone main

; blackout
lda #GREEN
sta $d020
lda #BLUE
sta $d021
lda #147
jsr $ffd2

lda #SPR_LEFT
sta SPRITEPOINTER0
lda #1
sta SPR0_ENABLE
lda #1
sta SPR_CMODE

lda #$A0
sta $0400+940
sta $0400+941
sta $0400+980
sta $0400+981

sta $0400+880
sta $0400+881
sta $0400+960
sta $0400+961

; insert coin
lda #$57
sta $0400+935
lda #COLOR_YELLOW
sta $d800+935


loadsprite		ldx #62
loop					lda spriteTiles,x
							sta SPR_RAM,x								
							dex		
							bne loop
							
							lda sprFaceC
							sta SPR0_COLOR
							lda sprFaceMC1
							sta SPR_MC1
							lda sprFaceMC2
							sta SPR_MC2							
							lda sprFaceY
							sta SPR0_Y
							lda sprFaceX
							sta SPR0_X

							
						
									
gameloop			lda #$50
							cmp $d012
							bne gameloop														
fall					ldy sprFaceY
							cpy #230
							beq jump
						  lda $d01f
			        bne jump
							inc sprFaceY
							inc sprFaceY
							lda #SPR_LEFT
							sta SPRITEPOINTER0
jump					lda jumpstate
							beq up
							lda #SPR_JUMP
							sta SPRITEPOINTER0
							dec sprFaceY
							dec sprFaceY
							dec sprFaceY
							dec sprFaceY
							dec jumpstate
		  				bne left
up						lda JOY2		
							and #1
							bne left
							lda jumpstate
					    bne left											
							lda #20
							sta jumpstate											
;down					lda JOY2
;							and #2
;							bne left
;							ldy sprFaceY
;							cpy #230
;							beq left
;							inc sprFaceY
left					lda JOY2
							and #4
							bne right
							lda #SPR_LEFT
							sta SPRITEPOINTER0
							lda $d01f
							bne right
							dec sprFaceX
							lda sprFaceX
							cmp #$ff
							bne right
							lda sprFaceX+1
							sbc #%00000001
							sta sprFaceX+1												
right					lda JOY2		
							and #8
							bne fire
							lda #SPR_RIGHT
							sta SPRITEPOINTER0
							lda $d01f
							bne fire
							inc sprFaceX
							bne fire
							lda sprFaceX+1
							ora #%00000001
							sta sprFaceX+1
fire					lda JOY2
							and #16
							bne done
							inc $d020
done					ldy sprFaceY
							sty SPR0_Y
							ldx sprFaceX
							stx SPR0_X
							ldx sprFaceX+1
							stx SPR_X_9BIT

							lda sprFaceY							
							ldx #2
							ldy #2
							jsr printdec
														
							;lda sprFaceX-24/8*sprFaceY-50/8																			
							
							lda <sprFaceX
							lda >sprFaceX
							ldx #2
							ldy #10
							jsr printdec
							
							
							;jsr djrr
							;bcs gameloop
							;dec $d020
							jmp gameloop			
							


							  												

							
;djrr    lda JOY2     ; get input from port 2 only
;djrrb           			; this routine reads and decodes the        ; joystick/firebutton input data in
;        lsr           ; the accumulator. this least significant
;        bcs djr0      ; 5 bits contain the switch closure
;        lda jumpstate
;				bne djr0
;				dey
;				dec jumpstate
;        ; information. if a switch is closed then it
;				lda JOY2
;djr0    lsr           ; produces a zero bit. if a switch is open then
;        bcs djr1      ; it produces a one bit. The joystick dir-
;        iny           ; ections are right, left, forward, backward
;djr1    lsr           ; bit3=right, bit2=left, bit1=backward,
;        bcs djr2      ; bit0=forward and bit4=fire button.
;        dex           ; at rts time dx and dy contain 2's compliment
;djr2    lsr           ; direction numbers i.e. $ff=-1, $00=0, $01=1.
;        bcs djr3      ; dx=1 (move right), dx=-1 (move left),
;        inx           ; dx=0 (no x change). dy=-1 (move up screen),
;djr3    lsr           ; dy=0 (move down screen), dy=0 (no y change).
;        stx joyx      ; the forward joystick position corresponds
;        sty joyy      ; to move up the screen and the backward
;        rts           ; position to move down screen.									

!source "_includes\wait.asm"
!source "printdec.asm"
!source "_includes\system_const.asm"

;data
jumpstate		!byte 0
maxy				!byte	230		; this is the bottom border this has to be set to a different value based on the sprite position
;joyx 				!byte 100
;joyy 				!byte 100			

sprFaceC		!byte 13
sprFaceMC1	!byte 10
sprFaceMC2	!byte 2
sprFaceX		!byte 100,0
sprFaceY		!byte 200
calc16Bit		!word $0000

*=$a00
!align 63,0
spriteTiles
 !media "creatures.spriteproject",sprite,0,3
