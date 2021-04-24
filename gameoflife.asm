!zone BASIC
; basic ASM loader
*=$0801   ; starting address of the program
!basic main

!zone CONSTS
; imports
!source "_includes\const_memmap.asm"
!source "_includes\const_colors.asm"
!source "_includes\const_kernal.asm"
; local const
; chars (SCREEN)
SPACE   		= $20
HEART   		= $53
; chars (PETSII)

!zone main
main
init_screen lda #BLACK
            sta BGCOLOR
						lda #DGREY
            sta BOCOLOR
            ldx #0
						jsr clear

CELL        = 41

            ;lda #HEART
            ; write a cell
						;sta SCREEN+CELL

            ; set all nb
            ;sta SCREEN+CELL+1
            ;sta SCREEN+CELL-1

            ;sta SCREEN+CELL-39
            ;sta SCREEN+CELL-40
            ;sta SCREEN+CELL-41

            ;sta SCREEN+CELL+39
            ;sta SCREEN+CELL+40
            ;sta SCREEN+CELL+41
!zone bitmapoutput	
						
	
						ldy #0				; clear pos vars
						sty CPOS_BYTE
						ldx #0
						stx CPOS						
loadcposby	ldy CPOS_BYTE
loadcpos		ldx CPOS
loadmask		lda MASK						
andbitmap		and BITMAPOUT,y																									
						bne wrchar
						beq shift
wrchar		  lda #HEART						
						sta SCREEN,x																							
shift				inc CPOS
						lsr MASK
						bcs maskdone
						jmp loadcposby					  	
maskdone		inc CPOS_BYTE
						lda #%10000000
						sta MASK
				    ldy MAXCHARS
				    cpy CPOS
				    bne loadcposby



!zone COUNT	; counting neighbours					
; implement loop for cell counts here
CELL        = 41
						ldx value
count				
count_nw	  lda SCREEN+CELL-41
						cmp #HEART
						bne count_n
						inx
count_n			lda SCREEN+CELL-40
						cmp #HEART
						bne count_ne
						inx
count_ne		lda SCREEN+CELL-39
						cmp #HEART
						bne count_w
						inx  				 	
count_w			lda SCREEN+CELL-1
						cmp #HEART
						bne count_e
						inx
count_e			lda SCREEN+CELL+1
						cmp #HEART
						bne count_sw
						inx
count_sw	  lda SCREEN+CELL+39
						cmp #HEART
						bne count_s
						inx						
count_s	  	lda SCREEN+CELL+40
						cmp #HEART
						bne count_se
						inx	
count_se	  lda SCREEN+CELL+41
						cmp #HEART
						bne count_end
						inx
count_end		txa							; speicher die anzahl in a

						ldx #24					; x pos für ausgabe
						ldy #38					; y pos für ausgabe					
						jsr printdec		; ausgeben			


						ldx #0
						stx screenpos
						stx bitpos
					  stx bytepos

initbm			lda #%10000000
						sta MASK
						ldx #0	
						stx bitpos		
getScreen		ldy screenpos
						lda SCREEN,y
						cmp #HEART
						bne nextbit									
addbit		  ldy bytepos
						lda bitmapin,y
						clc								
						adc MASK
						sta bitmapin,y						
nextbit			inc screenpos
						inx
						stx bitpos
						lsr MASK
						cpx #7
						bne getScreen								
nextbyte		inc bytepos
						ldy bytepos
						cpy #30
						bne initbm
				
	
						lda #5
						lda bitmapin,x		; load bitmap for print
						ldx #20						; x pos für ausgabe
						ldy #20						; y pos für ausgabe					
						jsr printdec		; ausgeben	
						
						jsr wait
						
						rts 						; back to basic		
			
!zone vars_main ; variablen
MASK			!byte %10000000
MAXCHARS	!byte 240
NBCOUNT		!byte 0		
bitpos		!byte 0
screenpos !byte 0
bytepos		!byte 0
CPOS			!byte 0
CPOS_BYTE !byte 0
CBITMAP 	!byte $00
BITMAPOUT !byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %11100000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000																					
bitmapin	!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					!byte %00000000,%00000000,%00000000,%00000000,%00000000
					
!zone SUBS	; load sub routines here     					
!source "_includes\wait.asm"
!source "printdec.asm"

clear       lda #SPACE
            sta SCREEN,x
            sta SCREEN+$100,x
            sta SCREEN+$200,x
            sta SCREEN+$300,x
            inx
            bne clear
						rts