;*******************************************************************************
;*** Farben                                                                  ***
;*******************************************************************************
COLOR_BLACK         = $00           ;schwarz
COLOR_WHITE         = $01           ;weiß
COLOR_RED           = $02           ;rot
COLOR_CYAN          = $03           ;türkis
COLOR_PURPLE        = $04           ;lila
COLOR_GREEN         = $05           ;grün
COLOR_BLUE          = $06           ;blau
COLOR_YELLOW        = $07           ;gelb
COLOR_ORANGE        = $08           ;orange
COLOR_BROWN         = $09           ;braun
COLOR_PINK          = $0a           ;rosa
COLOR_DARKGREY      = $0b           ;dunkelgrau
COLOR_GREY          = $0c           ;grau
COLOR_LIGHTGREEN    = $0d           ;hellgrün
COLOR_LIGHTBLUE     = $0e           ;hellblau
COLOR_LIGHTGREY     = $0f           ;hellgrau
 
;*******************************************************************************
;*** Die VIC II Register  -  ANFANG                                          ***
;*******************************************************************************
VICBASE             = $d000         ;(RG) = Register-Nr.
SPRITE0X            = $d000         ;(00) X-Position von Sprite 0
SPRITE0Y            = $d001         ;(01) Y-Position von Sprite 0
SPRITE1X            = $d002         ;(02) X-Position von Sprite 1
SPRITE1Y            = $d003         ;(03) Y-Position von Sprite 1
SPRITE2X            = $d004         ;(04) X-Position von Sprite 2
SPRITE2Y            = $d005         ;(05) Y-Position von Sprite 2
SPRITE3X            = $d006         ;(06) X-Position von Sprite 3
SPRITE3Y            = $d007         ;(07) Y-Position von Sprite 3
SPRITE4X            = $d008         ;(08) X-Position von Sprite 4
SPRITE4Y            = $d009         ;(09) Y-Position von Sprite 4
SPRITE5X            = $d00a         ;(10) X-Position von Sprite 5
SPRITE5Y            = $d00b         ;(11) Y-Position von Sprite 5
SPRITE6X            = $d00c         ;(12) X-Position von Sprite 6
SPRITE6Y            = $d00d         ;(13) Y-Position von Sprite 6
SPRITE7X            = $d00e         ;(14) X-Position von Sprite 7
SPRITE7Y            = $d00f         ;(15) Y-Position von Sprite 7
SPRITESMAXX         = $d010         ;(16) Höhstes BIT der jeweiligen X-Position
                                    ;        da der BS 320 Punkte breit ist reicht
                                    ;        ein BYTE für die X-Position nicht aus!
                                    ;        Daher wird hier das 9. Bit der X-Pos
                                    ;        gespeichert. BIT-Nr. (0-7) = Sprite-Nr.
SPRITEACTIV         = $d015         ;(21) Bestimmt welche Sprites sichtbar sind
                                    ;        Bit-Nr. = Sprite-Nr.
SPRITEDOUBLEHEIGHT  = $d017         ;(23) Doppelte Höhe der Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
SPRITEDEEP          = $d01b         ;(27) Legt fest ob ein Sprite vor oder hinter
                                    ;        dem Hintergrund erscheinen soll.
                                    ;        Bit = 1: Hintergrund vor dem Sprite
                                    ;        Bit-Nr. = Sprite-Nr.
SPRITEMULTICOLOR    = $d01c         ;(28) Bit = 1: Multicolor Sprite 
                                    ;        Bit-Nr. = Sprite-Nr.
SPRITEDOUBLEWIDTH   = $d01d         ;(29) Bit = 1: Doppelte Breite des Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
SPRITESPRITECOLL    = $d01e         ;(30) Bit = 1: Kollision zweier Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
                                    ;        Der Inhalt wird beim Lesen gelöscht!!
SPRITEBACKGROUNDCOLL= $d01f         ;(31) Bit = 1: Sprite / Hintergrund Kollision
                                    ;        Bit-Nr. = Sprite-Nr.
                                    ;        Der Inhalt wird beim Lesen gelöscht!
SPRITEMULTICOLOR0   = $d025         ;(37) Spritefarbe 0 im Multicolormodus
SPRITEMULTICOLOR1   = $d026         ;(38) Spritefarbe 1 im Multicolormodus
SPRITE0COLOR        = $d027         ;(39) Farbe von Sprite 0
SPRITE1COLOR        = $d028         ;(40) Farbe von Sprite 1
SPRITE2COLOR        = $d029         ;(41) Farbe von Sprite 2
SPRITE3COLOR        = $d02a         ;(42) Farbe von Sprite 3
SPRITE4COLOR        = $d02b         ;(43) Farbe von Sprite 4
SPRITE5COLOR        = $d02c         ;(44) Farbe von Sprite 5
SPRITE6COLOR        = $d02d         ;(45) Farbe von Sprite 6
SPRITE7COLOR        = $d02e         ;(46) Farbe von Sprite 7
 
;*******************************************************************************
;*** Die VIC II Register  -  ENDE                                            ***
;*******************************************************************************
*=$0801   ; starting address of the program 

;*** BASIC-Zeile (loader)
 !word main-2
 !word 2018
 !text $9E," 2062",$00,$00,$00

; konstanten
SCREENRAM = $0400
FARBRAM   = $d800         ;Start des Farb-RAMs
FARBNR    = $00           ;Schwarz ($00) als Zeichenfarbe
ZEICHEN   = $7f ; H
SPRITE0DATA         = SCREENRAM+$03f8   ;Sprite-Pointer für die
                                        ;Adresse der Sprite-0-Daten
SPRITE1DATA         = SCREENRAM+$03f9   ;wie eben, nur für Sprite-1

lda #ZEICHEN
ldx #$ff

!zone main
main
      lda #<spritedata                   ;LSB der Spritedaten holen
      sta calc16Bit                      ;im 'Hilfsregister' speichern
      lda #>spritedata                   ;MSB auch
      sta calc16Bit+1                    ;ins 'Hilfregister'
      ldx #$06                           ;Schleifenzähler fürs Teilen durch 64
.loop
      lsr calc16Bit+1                    ;MSB nach rechts 'shiften'
      ror calc16Bit                      ;LSB nach rechts 'rotieren', wg. Carry-Flag!
      dex                                ;Schleifenzähler verringern
      bne .loop                          ;wenn nicht 0, nochmal
 
      ldx calc16Bit                      ;Im LSB des 'Hilfsregisters' steht der 64-Byte-Block
      stx SPRITE0DATA                    ;In der zuständigen Speicherstelle ablegen
      inx                                ;Das 2. Sprite folgt direkt dahinter, also +1
      stx SPRITE1DATA                    ;und dem VIC II mitteilen
      
      ;keiner vergrößerung
      lda #%00000000
      sta SPRITEDOUBLEHEIGHT
      sta SPRITEDOUBLEWIDTH
      
      ;sprite 1 ist multicolor
      lda #%0000010
      sta SPRITEMULTICOLOR
      
      ; alle sprintes noch vorn
      lda #%00000000
      sta SPRITEDEEP
      
      ; farbe für sprite 0
      lda #COLOR_BLACK
      sta SPRITE0COLOR
      
      ; haupt farbe für sprite1
      lda #COLOR_GREEN
      sta SPRITE1COLOR
      
      ; multicolor-0 für sprite1
      lda #COLOR_RED
      sta SPRITEMULTICOLOR0
      
      ; multicolor-1 für sprite1
      lda #COLOR_YELLOW
      sta SPRITEMULTICOLOR1
      
      ; x positionen 
      ldx #$00 ; clear x
      stx SPRITESMAXX
      ldx #$24
      stx SPRITE0X
      ldx #$40
      stx SPRITE1X
      
      ; y position
      ldy #$32
      sty SPRITE0Y
      sty SPRITE1Y
      
      lda #%00000011
      sta SPRITEACTIV
      
move
      inc SPRITE1Y
      lda SPRITE1Y
      cmp #$fa
      bne move_0
      lda #$ce
      sta move
move_0
      cmp #$1d
      bne move_1
      lda #$ee
      sta move
move_1
sleep
      ldx #$02
sleepx
      ldy #$00
sleepy
      dey
      bne sleepy
      dex
      bne sleepx
            
      jmp move

      rts
      
      ;*** Hilfsregister für 16-Operartionen
calc16Bit
 !byte $00, $00
 
;*** Mittels !align 63,0', den Assembler anweisen, den Beginn 
;*** der Daten an eine durch 64 teilbare Adresse zulegen.
!align 63,0
 
spritedata
; Hi-Res-Sprite
!byte  $ff,$ff,$ff
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $ff,$08,$ff
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $ff,$08,$ff
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $81,$08,$81
!byte  $81,$10,$81
!byte  $ff,$ff,$ff
!byte  $00                          ;auf 64 Bytes auffüllen
 
; Multicolor-Sprite
!byte  $aa,$55,$ff
!byte  $aa,$55,$ff
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $82,$41,$c3
!byte  $aa,$55,$ff
!byte  $aa,$55,$ff
!byte  $00                          ;auf 64 Bytes auffüllen