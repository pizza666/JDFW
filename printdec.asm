printdec	sta value
					stx PLOTX
					sty PLOTY
					
					jsr hex2dec

        	ldx #9
l1      	lda result,x
	        bne l2
	        dex             ; skip leading zeros
	        bne l1

l2      	lda result,x
	        ora #$30
					stx PRINTX
					sta PRINTA
					
					ldx PLOTX
					ldy PLOTY
					clc
					jsr PLOT
					inc PLOTY
					
					ldx PRINTX
					lda PRINTA
					jsr PRINT		; print decimal / integer
					
 	        dex
	        bpl l2
	        rts
								
        ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec
        	ldx #0
l3      	jsr div10
        	sta result,x
	        inx
        	cpx #10
        	bne l3
        	rts

        ; divides a 32 bit value by 10
        ; remainder is returned in akku
div10
        	ldy #32         ; 32 bits
        	lda #0
        	clc
l4      	rol
        	cmp #10
        	bcc skip
	        sbc #10
skip    	rol value
        	rol value+1
        	rol value+2
        	rol value+3
        	dey
        	bpl l4
					rts

!zone vars_printdec
PLOTX					!byte	10
PLOTY					!byte	10			
PRINTA				!byte 0		
PRINTX				!byte	0						
value   			!byte 0,0,0,0
result  			!byte 0,0,0,0,0,0,0,0,0,0			