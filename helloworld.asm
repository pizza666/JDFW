*=$0801
 !byte $0e, $08, $0A, $00, $9E, $20, $28, $32, $30, $36, $34, $29, $00, $00

*=$0810

  lda #>helloworld
  sta $26
  lda #<helloworld
  sta $25

  jsr PrintStr
  jsr NewLine

  rts

PrintStr:
  ldy #0
PrintStr_again:
  lda($25),y
  cmp #0
  beq PrintStr_Done
  jsr PrintChar
  iny
  jmp PrintStr_again
PrintStr_Done:
  rts

NewLine:
  lda #13
  jmp PrintChar

PrintChar:
  cmp #96
  bcc PrintCharOK
  and #%11011111
PrintCharOK
  jmp $ffd2

PrintChar2:
  cmp #64
  bcc PrintCharOKB
  eor #%00100000
PrintCharOKB:
  jmp $ffd2


helloworld !text "Hello World", 0
