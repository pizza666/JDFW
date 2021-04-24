MAPWIDTH        = 100               ;Map: Anz. Tiles in X-Richtung
MAPHEIGHT       = 15                ;Map: Anz. Tiles in Y-Richtung
TILECOUNT       = 128               ;Anzahl der Tiles insgesamt
TILEWIDTH       = 4                 ;Tile: Anz. Zeichen (Breite)
TILEHEIGHT      = 4                 ;Tile: Anz. Zeichen (Höhe)
TILESIZE        = TILEWIDTH*TILEHEIGHT ;Tile: Anz. der Zeichen fürs ganze Tile
SCREENTILES_X   = 10                ;SCR: Anz. Tiles in X-Richtung
SCREENTILES_Y   = 5                 ;SCR: Anz. Tiles in Y-Richtung
SCREENRAM       = $0400             ;SCR: Adresse des Bildschirmspeichers
COLORRAM        = $d800             ;SCR: Adresse des Farb-RAMs

ZP_TILESY       = $02               ;Hilfsvariablen auf der Zeropage
ZP_TILESX       = $03
ZP_TILENO       = $04
ZP_TILEHEIGHT   = $05

ZP_MAPADR       = $10               ;Hilfsadressen (2 Bytes) auf der Zeropage
ZP_SCREENADR    = $12
ZP_COLORRAMADR  = $14
ZP_TILEADR      = $16



!zone main
;*** Startadresse
*=$0801
;** BASIC-Zeile: 2018 SYS 2062
 !word main-2, 2018
 !byte $9e
 !text " 2062"
 !byte $00,$00,$00

main
 lda #147                           ;Bildschrim löschen
 jsr $ffd2
 lda #6                             ;blau für
 sta $d020                          ;Rahmen und
 sta $d021                          ;Hintergrund
 lda $d018                          ;Zeichensatz
 and #%11110001
 ora #%00001000                     ;nach $2000
 sta $d018                          ;legen
 lda $d016                          ;Multicolor
 ora #%00010000                     ;Textmodus
 sta $d016                          ;setzen
 lda #15                            ;hellgrau
 sta $d022                          ;für erste MC-Farbe
 lda #14                            ;hellblau
 sta $d023                          ;für die zweite MC-Farbe
 jsr drawMap                        ;Bildschirmausgabe
- lsr $0400,x
  inx
 jmp -                              ;Endlosschleife



!zone drawMap
drawMap
 lda #<map                          ;Adresse der Map
 sta ZP_MAPADR                      ;auf die Zeropage
 lda #>map
 sta ZP_MAPADR+1

 lda #0                             ;Zähler Tiles in Y-Richtung
 sta ZP_TILESY                      ;auf der Zeropage merken
.loop
 lda #SCREENTILES_X-1               ;Anz. Tiles für BS in X-Richtung (-1)
 sta ZP_TILESX                      ;auf der Zeropage merken
.loop1
 ldy ZP_TILESX                      ;Position des nächsten Tiles ins Y-Reg.
 lda (ZP_MAPADR),Y                  ;Tile-Nr. aus der 'map.raw' holen
 jsr drawTile                       ;Tile zeichnen
 dec ZP_TILESX                      ;Zähler für Tiles in X-Richtung verringern
 bpl .loop1                         ;solange positiv -> nochmal

 lda #MAPWIDTH                      ;Start für die nächste Map-Zeile errechnen
 clc                                ;Carry löschen
 adc ZP_MAPADR                      ;LSB der MAP-Startadresse addieren
 sta ZP_MAPADR                      ;und speichern
 lda #0
 adc ZP_MAPADR+1                    ;ggf. Carry zum MSB der MAP-Startadresse addieren
 sta ZP_MAPADR+1                    ;und speichern
 inc ZP_TILESY                      ;Zähler für Tiles in Y-Richtung erhöhen
 lda ZP_TILESY                      ;zum Prüfen in den Akku
 cmp #SCREENTILES_Y                 ;mit der Anz. Tiles in Y-Richtung vergleichen
 bne .loop                          ;solange ungleich -> nochmal
 rts                                ;zurück zum Aufrufer


!zone drawTile
drawTile
 sta ZP_TILENO                  ;Tile-Nr. in der Zeropage merken
 ldy ZP_TILESY                  ;Tile-zeile (Y-Richtung) ins Y-Reg.
 lda screenRow_LSB,Y            ;LSB aus Hilfstabelle holen
 sta ZP_SCREENADR               ;und auf die Zeropage damit
 sta ZP_COLORRAMADR             ;auch fürs ColorRAM merken
 lda screenRow_MSB,Y            ;MSB aus der Hilfstabelle holen
 sta ZP_SCREENADR+1             ;und auf der Zeropage merken
 ldx ZP_TILESX                  ;Offset in X-Richtung
 lda screenCol_Offset,X         ;aus der Hilfstabelle holen
 clc                            ;Carry-Flag löschen
 adc ZP_SCREENADR               ;und zum LSB addieren
 sta ZP_SCREENADR               ;Ergebnis merken
 sta ZP_COLORRAMADR             ;auch für das ColorRAM
 lda ZP_SCREENADR+1             ;MSB von der Zeropage holen
 adc #0                         ;ggf. das C-Flag addieren
 sta ZP_SCREENADR+1             ;und speichern
 adc #$D4                       ;MSB-Offset fürs ColorRAM addieren
 sta ZP_COLORRAMADR+1           ;und ab auf die Zero-Page
 ldx ZP_TILENO                  ;Tile-Nr. ins X-Register
 lda tilePos_LSB,X              ;damit die Startadresse holen
 sta ZP_TILEADR                 ;und auf der Zero-Page speichern
 lda tilePos_MSB,X
 sta ZP_TILEADR+1
 lda #TILEHEIGHT                ;Tilehöhe
 sta ZP_TILEHEIGHT              ;auf der Zeropage merken
.loop1
 ldy #TILEWIDTH-1               ;Tilebreite (-1) in Y-Register
.loop2
 lda (ZP_TILEADR),Y             ;Zeichen vom Tile holen
 sta (ZP_SCREENADR),Y           ;und ausgeben
 ldx ZP_TILENO                  ;Tile-Nr. ins X-Register
 lda colors,X                   ;damit die Farbe holen
 sta (ZP_COLORRAMADR),Y         ;und ins Farb-RAM kopieren
 dey                            ;Y verringern
 bpl .loop2                     ;solange positiv -> nochmal zu @loop2
 lda #40                        ;Start der nächsten Bildschirmzeile berechnen
 clc                            ;Carry löschen
 adc ZP_SCREENADR               ;40 Zeichen zum LSB der Bildschirmadresse addieren
 sta ZP_SCREENADR               ;und merken
 sta ZP_COLORRAMADR             ;auch fürs COLORRAM
 lda ZP_SCREENADR+1             ;ggf. Carry zum
 adc #0                         ;MSB addieren
 sta ZP_SCREENADR+1             ;Ergebnis speichern
 adc #$D4                       ;Offset fürs Farb-RAM addieren
 sta ZP_COLORRAMADR+1           ;und speichern
 lda #TILEWIDTH                 ;Anz. Zeichen in X-Richtung
 adc ZP_TILEADR                 ;zur Startadresse der Tiles addieren
 sta ZP_TILEADR                 ;und speichern
 lda #0
 adc ZP_TILEADR+1
 sta ZP_TILEADR+1
 dec ZP_TILEHEIGHT              ;Tilehöhe verringern
 bne .loop1                     ;falls nicht 0 -> nochmal zu @loop1
 rts                            ;zurück zum Aufrufer


screenRow_LSB                       ;Hilfstabelle (LSB)
 !for row = 0 to SCREENTILES_Y-1    ;Hier wird für jede Tilezeile, die auf dem
   !byte <(SCREENRAM+40*TILEHEIGHT*row) ;Bildschirm ausgegeben wird, das LSB der
 !end                               ;Startadresse gespeichert.

screenRow_MSB                       ;Hilfstabelle (MSB)
 !for row = 0 to SCREENTILES_Y-1    ;Wie eben, nur für das MSB
   !byte >(SCREENRAM+40*TILEHEIGHT*row)
 !end

screenCol_Offset                    ;Hilfstabelle
 !for col = 0 to SCREENTILES_X-1    ;Hier steht der Offset vom linken Rand
   !byte TILEWIDTH*col              ;für jede Tilespalte, die auf dem Bildschirm
 !end                               ;ausgegeben wird.

tilePos_LSB
  !for x = 0 to TILECOUNT-1
    !byte <(tiles+x*TILESIZE)
  !end
tilePos_MSB
  !for x = 0 to TILECOUNT-1
    !byte >(tiles+x*TILESIZE)
  !end


tiles
 !bin "d_tiles.bin"

colors
 !bin "d_attrib.bin"

map
 !bin "d_map.bin"

*=$2000
characters
 !bin "d_chars.bin"