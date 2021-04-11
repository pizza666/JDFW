*=$0801   ; starting address of the program 
!byte $0c,$08,$e2,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00 ; 2018 SYS 2062

ZEICHENRAM = $0400
FARBRAM = $d800         ;Start des Farb-RAMs
FARBNR  = $00           ;Schwarz ($00) als Zeichenfarbe
ZEICHEN = $08 ; H


lda #ZEICHEN
ldx #$ff

charloop:   
        sta ZEICHENRAM-1,x
        dex
        bne charloop

lda #FARBNR
ldx #$ff        
        
farbloop:
      sta FARBRAM-1,x
      dex
      bne farbloop
      rts