;*** VIC-II Speicher-Konstanten
VICBANKNO               = 0                             ;Nr. (0 - 3) der 16KB Bank                              | Standard: 0
VICSCREENBLOCKNO        = 1                             ;Nr. (0 -15) des 1KB-Blocks für den Textbildschirm      | Standard: 1
VICCHARSETBLOCKNO       = 2                             ;Nr. (0 - 7) des 2KB-Blocks für den Zeichensatz         | Standard: 2
VICBITMAPBBLOCKNO       = 1                             ;Nr. (0 - 1) des 8KB-Blocks für die BITMAP-Grafik       | Standard: 0
VICBASEADR              = VICBANKNO*16384               ;Startadresse der gewählten VIC-Bank                    | Standard: $0000
VICCHARSETADR           = VICBASEADR+VICCHARSETBLOCKNO*2048 ;Adresse des Zeichensatzes                          | Standard: $1000 ($d000)
VICSCREENRAM            = VICBASEADR+VICSCREENBLOCKNO*1024  ;Adresse des Bildschirmspeichers
VICBITMAPADR            = VICBASEADR+VICBITMAPBBLOCKNO*8192 ;Adresse der BITMAP
VICCOLORRAM             = $d800

;*** Startadresse
*=$0801
;** BASIC-Zeile: 2018 SYS 2062
 !word main-2, 2018
 !byte $9e
 !text " 2062"
 !byte $00,$00,$00

main
 ;Bitmap-Modus aktivieren
 lda $d011                          ;VIC-II Register 17 in den Akku
 ora #%00100000                     ;Bitmap-Modus
 sta $d011                          ;aktivieren

 lda $d016                          ;VIC-II Register 22 in den Akku
 ora #%00010000                     ;Multi-Color über Bit-4
 sta $d016                          ;aktivieren

 ;*** Start des Bitmapspeichers festlegen
 lda $d018                          ;VIC-II Register 24 in den Akku holen
 and #%11110111                     ;Mit Bit-3
 ora #VICBITMAPBBLOCKNO*8           ;den Beginn des
 sta $d018                          ;Bitmapspeichers festlegen

 jsr showKoala                      ;Koala-Bild anzeigen

 jmp *                              ;Endlosschleife


!zone showKoala
;*** Unkomprimiertes Koalabild anzeigen
;*** Offset (hex): Inhalt
;*** 0000 - 1F3f : Bitmap 8000 Bytes
;*** 1f40 - 2327 : Bildschirmspeicher 1000 Bytes
;*** 2328 - 270f : Farb-RAM 1000 Bytes
;*** 2710        : Hintergrundfarbe 1 Byte
showKoala
 ldx #$00
.loop
 lda VICBITMAPADR+$1F40,X           ;Farbe für Bildschirm-Speicher lesen
 sta VICSCREENRAM,X                 ;und schreiben
 lda VICBITMAPADR+$2328,X           ;Farbe für COLOR-RAM lesen
 sta VICCOLORRAM,X                  ;und schreiben
 lda VICBITMAPADR+$2040,X           ;für die nächsten drei Pages wiederholen
 sta VICSCREENRAM+256,X
 lda VICBITMAPADR+$2428,X
 sta VICCOLORRAM+256,X
 lda VICBITMAPADR+$2140,X
 sta VICSCREENRAM+512,X
 lda VICBITMAPADR+$2528,X
 sta VICCOLORRAM+512,X
 lda VICBITMAPADR+$2240,X
 sta VICSCREENRAM+768,X
 lda VICBITMAPADR+$2628,X
 sta VICCOLORRAM+768,X
 dex                                ;Schleifenzähler verringern
 bne .loop                          ;solange ungleich 0 -> .loop
 lda VICBITMAPADR+$2710             ;Hintergrundfarbe holen
 sta $d021                          ;und setzen
 rts                                ;zurück zum Aufrufer

*=$2000                             ;Zieladresse für das Bild
 !bin "alien.kla"