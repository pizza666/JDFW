*=$0801
 !byte $0e, $08, $0A, $00, $9E, $20, $28, $32, $30, $36, $34, $29, $00, $00
 
*=$0810
        ; prints a 32 bit value to the screen
printdec
        jsr hex2dec

        ldx #9
l1      lda result,x
        bne l2
        dex             ; skip leading zeros
        bne l1

l2      lda result,x
        ora #$30

				
				; insert other print routine here
        jsr $ffd2
				
				
        dex
        bpl l2
        rts

        ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec
        ldx #0
l3      jsr div10
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
l4      rol
        cmp #10
        bcc skip
        sbc #10
skip    rol value
        rol value+1
        rol value+2
        rol value+3
        dey
        bpl l4
        rts
				

value   !byte 255,255,0,0

result  !byte 0,0,0,0,0,0,0,0,0,0