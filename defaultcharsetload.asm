; basic ASM loader
*=$0801   ; starting address of the program
!basic

!zone CONSTS
; imports
!source "_includes\const_memmap.asm"
!source "_includes\const_colors.asm"
!source "_includes\const_kernal.asm"
; local const

 			ldx #0
loop	lda charScreen,x
			sta SCREEN,x
			inx
			cpx #254
			bne loop
			
			ldx #0
			lda #$50
loop2			lda #$50
							cmp $d012
							bne loop2		
			ror SCREEN,x
			inx
			cpx #254
			bne loop2		
			
			ldx #0	       ; X = 0
.loop
txa  	         ; copy X to A
sta $0400, x   ; put A at $0400+X
sta $d800, x   ; put A as a color at $d800+x. Color RAM only considers the lower 4 bits,
               ; so even though A will be > 15, this will wrap nicely around the 16 available colors
inx 	         ; X=X+1
cpx #27        ; have we written enough chars?
bne .loop

screen_on_vblank
      dec $d019                                    ; set interrupt handled flag
      dec xscroll                                  ; decrement xscroll

      bmi update_screen                            ; if xscroll falls below 0, we need to shift screen and color RAM

      lda $d016                                    ; $d016 is a VIC-II control register which contains the horizontal scroll value
      and #$F8                                     ; h-scroll is the lower 3 bits, so mask them off
      clc                                          ; clear carry flag
      adc xscroll                                  ; add xscroll (value always fits inside the lower 3 bits)
      sta $d016                                    ; store value in register

      jmp irq_handler_exit

update_screen
        lda #7                                       ; reset xscroll
        sta xscroll

        jsr screen_shift                             ; shift contents of screen RAM left by 1 byte
        jsr color_shift                              ; and same with color RAM
        jsr level_render_last_col                    ; draw new column at right edge of screen
        jmp irq_handler_exit


charScreen
!media "bgBrown.charscreen",char
!source "_includes\wait.asm"