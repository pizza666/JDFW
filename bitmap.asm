*=$801
!basic

!source "const_kernal.asm"

*=$80d
;lda #%00111011
;sta $d011
lda $d016
ora #8
sta $d016


lda $d018
ora #%100
sta $d018
;	
;			ldx #255
;loop  lda bitmap,x
;			sta $0400,x
;			dex
;		  bne loop	


rts

*=$2000
bitmap
CHARS
!byte $00,$24,$00,$00,$42,$42,$3c,$00
!byte $18,$3c,$66,$7e,$66,$66,$66,$00
!byte $7c,$66,$66,$7c,$66,$66,$7c,$00
!byte $3c,$66,$60,$60,$60,$66,$3c,$00
!byte $78,$6c,$66,$66,$66,$6c,$78,$00
!byte $7e,$60,$60,$78,$60,$60,$7e,$00
!byte $7e,$60,$60,$78,$60,$60,$60,$00
!byte $3c,$66,$60,$6e,$66,$66,$3c,$00
!byte $66,$66,$66,$7e,$66,$66,$66,$00
!byte $3c,$18,$18,$18,$18,$18,$3c,$00
!byte $1e,$0c,$0c,$0c,$0c,$6c,$38,$00
!byte $66,$6c,$78,$70,$78,$6c,$66,$00
!byte $60,$60,$60,$60,$60,$60,$7e,$00
!byte $63,$77,$7f,$6b,$63,$63,$63,$00
!byte $66,$76,$7e,$7e,$6e,$66,$66,$00
!byte $3c,$66,$66,$66,$66,$66,$3c,$00
!byte $7c,$66,$66,$7c,$60,$60,$60,$00
!byte $3c,$66,$66,$66,$66,$3c,$0e,$00
!byte $7c,$66,$66,$7c,$78,$6c,$66,$00
!byte $3c,$66,$60,$3c,$06,$66,$3c,$00
!byte $7e,$18,$18,$18,$18,$18,$18,$00
!byte $66,$66,$66,$66,$66,$66,$3c,$00
!byte $66,$66,$66,$66,$66,$3c,$18,$00
!byte $63,$63,$63,$6b,$7f,$77,$63,$00
!byte $66,$66,$3c,$18,$3c,$66,$66,$00
!byte $66,$66,$66,$3c,$18,$18,$18,$00
!byte $7e,$06,$0c,$18,$30,$60,$7e,$00
!byte $3c,$30,$30,$30,$30,$30,$3c,$00
!byte $0c,$12,$30,$7c,$30,$62,$fc,$00
!byte $3c,$0c,$0c,$0c,$0c,$0c,$3c,$00
!byte $00,$18,$3c,$7e,$18,$18,$18,$18
!byte $00,$10,$30,$7f,$7f,$30,$10,$00
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $18,$18,$18,$18,$00,$00,$18,$00
!byte $66,$66,$66,$00,$00,$00,$00,$00
!byte $66,$66,$ff,$66,$ff,$66,$66,$00
!byte $18,$3e,$60,$3c,$06,$7c,$18,$00
!byte $62,$66,$0c,$18,$30,$66,$46,$00
!byte $3c,$66,$3c,$38,$67,$66,$3f,$00
!byte $06,$0c,$18,$00,$00,$00,$00,$00
!byte $0c,$18,$30,$30,$30,$18,$0c,$00
!byte $30,$18,$0c,$0c,$0c,$18,$30,$00
!byte $00,$66,$3c,$ff,$3c,$66,$00,$00
!byte $00,$18,$18,$7e,$18,$18,$00,$00
!byte $00,$00,$00,$00,$00,$18,$18,$30
!byte $00,$00,$00,$7e,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$18,$18,$00
!byte $00,$03,$06,$0c,$18,$30,$60,$00
!byte $3c,$66,$6e,$76,$66,$66,$3c,$00
!byte $18,$18,$38,$18,$18,$18,$7e,$00
!byte $3c,$66,$06,$0c,$30,$60,$7e,$00
!byte $3c,$66,$06,$1c,$06,$66,$3c,$00
!byte $06,$0e,$1e,$66,$7f,$06,$06,$00
!byte $7e,$60,$7c,$06,$06,$66,$3c,$00
!byte $3c,$66,$60,$7c,$66,$66,$3c,$00
!byte $7e,$66,$0c,$18,$18,$18,$18,$00
!byte $3c,$66,$66,$3c,$66,$66,$3c,$00
!byte $3c,$66,$66,$3e,$06,$66,$3c,$00
!byte $00,$00,$18,$00,$00,$18,$00,$00
!byte $00,$00,$18,$00,$00,$18,$18,$30
!byte $0e,$18,$30,$60,$30,$18,$0e,$00
!byte $00,$00,$7e,$00,$7e,$00,$00,$00
!byte $70,$18,$0c,$06,$0c,$18,$70,$00
!byte $3c,$66,$06,$0c,$18,$00,$18,$00
!byte $00,$00,$00,$ff,$ff,$00,$00,$00
!byte $08,$1c,$3e,$7f,$7f,$1c,$3e,$00
!byte $18,$18,$18,$18,$18,$18,$18,$18
!byte $00,$00,$00,$ff,$ff,$00,$00,$00
!byte $00,$00,$ff,$ff,$00,$00,$00,$00
!byte $00,$ff,$ff,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$ff,$ff,$00,$00
!byte $30,$30,$30,$30,$30,$30,$30,$30
!byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
!byte $00,$00,$00,$e0,$f0,$38,$18,$18
!byte $18,$18,$1c,$0f,$07,$00,$00,$00
!byte $18,$18,$38,$f0,$e0,$00,$00,$00
!byte $c0,$c0,$c0,$c0,$c0,$c0,$ff,$ff
!byte $c0,$e0,$70,$38,$1c,$0e,$07,$03
!byte $03,$07,$0e,$1c,$38,$70,$e0,$c0
!byte $ff,$ff,$c0,$c0,$c0,$c0,$c0,$c0
!byte $ff,$ff,$03,$03,$03,$03,$03,$03
!byte $00,$3c,$7e,$7e,$7e,$7e,$3c,$00
!byte $00,$00,$00,$00,$00,$ff,$ff,$00
!byte $36,$7f,$7f,$7f,$3e,$1c,$08,$00
!byte $60,$60,$60,$60,$60,$60,$60,$60
!byte $00,$00,$00,$07,$0f,$1c,$18,$18
!byte $c3,$e7,$7e,$3c,$3c,$7e,$e7,$c3
!byte $00,$3c,$7e,$66,$66,$7e,$3c,$00
!byte $18,$18,$66,$66,$18,$18,$3c,$00
!byte $06,$06,$06,$06,$06,$06,$06,$06
!byte $08,$1c,$3e,$7f,$3e,$1c,$08,$00
!byte $18,$18,$18,$ff,$ff,$18,$18,$18
!byte $c0,$c0,$30,$30,$c0,$c0,$30,$30
!byte $18,$18,$18,$18,$18,$18,$18,$18
!byte $00,$00,$03,$3e,$76,$36,$36,$00
!byte $ff,$7f,$3f,$1f,$0f,$07,$03,$01
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
!byte $00,$00,$00,$00,$ff,$ff,$ff,$ff
!byte $ff,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$00,$00,$ff
!byte $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
!byte $cc,$cc,$33,$33,$cc,$cc,$33,$33
!byte $03,$03,$03,$03,$03,$03,$03,$03
!byte $00,$00,$00,$00,$cc,$cc,$33,$33
!byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80
!byte $03,$03,$03,$03,$03,$03,$03,$03
!byte $18,$18,$18,$1f,$1f,$18,$18,$18
!byte $00,$00,$00,$00,$0f,$0f,$0f,$0f
!byte $18,$18,$18,$1f,$1f,$00,$00,$00
!byte $00,$00,$00,$f8,$f8,$18,$18,$18
!byte $00,$00,$00,$00,$00,$00,$ff,$ff
!byte $00,$00,$00,$1f,$1f,$18,$18,$18
!byte $18,$18,$18,$ff,$ff,$00,$00,$00
!byte $00,$00,$00,$ff,$ff,$18,$18,$18
!byte $18,$18,$18,$f8,$f8,$18,$18,$18
!byte $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
!byte $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0
!byte $07,$07,$07,$07,$07,$07,$07,$07
!byte $ff,$ff,$00,$00,$00,$00,$00,$00
!byte $ff,$ff,$ff,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$ff,$ff,$ff
!byte $03,$03,$03,$03,$03,$03,$ff,$ff
!byte $00,$00,$00,$00,$f0,$f0,$f0,$f0
!byte $0f,$0f,$0f,$0f,$00,$00,$00,$00
!byte $18,$18,$18,$f8,$f8,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$00,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$0f,$0f,$0f,$0f
!byte $c3,$99,$91,$91,$9f,$99,$c3,$ff
!byte $e7,$c3,$99,$81,$99,$99,$99,$ff
!byte $83,$99,$99,$83,$99,$99,$83,$ff
!byte $c3,$99,$9f,$9f,$9f,$99,$c3,$ff
!byte $87,$93,$99,$99,$99,$93,$87,$ff
!byte $81,$9f,$9f,$87,$9f,$9f,$81,$ff
!byte $81,$9f,$9f,$87,$9f,$9f,$9f,$ff
!byte $c3,$99,$9f,$91,$99,$99,$c3,$ff
!byte $99,$99,$99,$81,$99,$99,$99,$ff
!byte $c3,$e7,$e7,$e7,$e7,$e7,$c3,$ff
!byte $e1,$f3,$f3,$f3,$f3,$93,$c7,$ff
!byte $99,$93,$87,$8f,$87,$93,$99,$ff
!byte $9f,$9f,$9f,$9f,$9f,$9f,$81,$ff
!byte $9c,$88,$80,$94,$9c,$9c,$9c,$ff
!byte $99,$89,$81,$81,$91,$99,$99,$ff
!byte $c3,$99,$99,$99,$99,$99,$c3,$ff
!byte $83,$99,$99,$83,$9f,$9f,$9f,$ff
!byte $c3,$99,$99,$99,$99,$c3,$f1,$ff
!byte $83,$99,$99,$83,$87,$93,$99,$ff
!byte $c3,$99,$9f,$c3,$f9,$99,$c3,$ff
!byte $81,$e7,$e7,$e7,$e7,$e7,$e7,$ff
!byte $99,$99,$99,$99,$99,$99,$c3,$ff
!byte $99,$99,$99,$99,$99,$c3,$e7,$ff
!byte $9c,$9c,$9c,$94,$80,$88,$9c,$ff
!byte $99,$99,$c3,$e7,$c3,$99,$99,$ff
!byte $99,$99,$99,$c3,$e7,$e7,$e7,$ff
!byte $81,$f9,$f3,$e7,$cf,$9f,$81,$ff
!byte $c3,$cf,$cf,$cf,$cf,$cf,$c3,$ff
!byte $f3,$ed,$cf,$83,$cf,$9d,$03,$ff
!byte $c3,$f3,$f3,$f3,$f3,$f3,$c3,$ff
!byte $ff,$e7,$c3,$81,$e7,$e7,$e7,$e7
!byte $ff,$ef,$cf,$80,$80,$cf,$ef,$ff
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $e7,$e7,$e7,$e7,$ff,$ff,$e7,$ff
!byte $99,$99,$99,$ff,$ff,$ff,$ff,$ff
!byte $99,$99,$00,$99,$00,$99,$99,$ff
!byte $e7,$c1,$9f,$c3,$f9,$83,$e7,$ff
!byte $9d,$99,$f3,$e7,$cf,$99,$b9,$ff
!byte $c3,$99,$c3,$c7,$98,$99,$c0,$ff
!byte $f9,$f3,$e7,$ff,$ff,$ff,$ff,$ff
!byte $f3,$e7,$cf,$cf,$cf,$e7,$f3,$ff
!byte $cf,$e7,$f3,$f3,$f3,$e7,$cf,$ff
!byte $ff,$99,$c3,$00,$c3,$99,$ff,$ff
!byte $ff,$e7,$e7,$81,$e7,$e7,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$e7,$e7,$cf
!byte $ff,$ff,$ff,$81,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$e7,$e7,$ff
!byte $ff,$fc,$f9,$f3,$e7,$cf,$9f,$ff
!byte $c3,$99,$91,$89,$99,$99,$c3,$ff
!byte $e7,$e7,$c7,$e7,$e7,$e7,$81,$ff
!byte $c3,$99,$f9,$f3,$cf,$9f,$81,$ff
!byte $c3,$99,$f9,$e3,$f9,$99,$c3,$ff
!byte $f9,$f1,$e1,$99,$80,$f9,$f9,$ff
!byte $81,$9f,$83,$f9,$f9,$99,$c3,$ff
!byte $c3,$99,$9f,$83,$99,$99,$c3,$ff
!byte $81,$99,$f3,$e7,$e7,$e7,$e7,$ff
!byte $c3,$99,$99,$c3,$99,$99,$c3,$ff
!byte $c3,$99,$99,$c1,$f9,$99,$c3,$ff
!byte $ff,$ff,$e7,$ff,$ff,$e7,$ff,$ff
!byte $ff,$ff,$e7,$ff,$ff,$e7,$e7,$cf
!byte $f1,$e7,$cf,$9f,$cf,$e7,$f1,$ff
!byte $ff,$ff,$81,$ff,$81,$ff,$ff,$ff
!byte $8f,$e7,$f3,$f9,$f3,$e7,$8f,$ff
!byte $c3,$99,$f9,$f3,$e7,$ff,$e7,$ff
!byte $ff,$ff,$ff,$00,$00,$ff,$ff,$ff
!byte $f7,$e3,$c1,$80,$80,$e3,$c1,$ff
!byte $e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7
!byte $ff,$ff,$ff,$00,$00,$ff,$ff,$ff
!byte $ff,$ff,$00,$00,$ff,$ff,$ff,$ff
!byte $ff,$00,$00,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$00,$00,$ff,$ff
!byte $cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf
!byte $f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3
!byte $ff,$ff,$ff,$1f,$0f,$c7,$e7,$e7
!byte $e7,$e7,$e3,$f0,$f8,$ff,$ff,$ff
!byte $e7,$e7,$c7,$0f,$1f,$ff,$ff,$ff
!byte $3f,$3f,$3f,$3f,$3f,$3f,$00,$00
!byte $3f,$1f,$8f,$c7,$e3,$f1,$f8,$fc
!byte $fc,$f8,$f1,$e3,$c7,$8f,$1f,$3f
!byte $00,$00,$3f,$3f,$3f,$3f,$3f,$3f
!byte $00,$00,$fc,$fc,$fc,$fc,$fc,$fc
!byte $ff,$c3,$81,$81,$81,$81,$c3,$ff
!byte $ff,$ff,$ff,$ff,$ff,$00,$00,$ff
!byte $c9,$80,$80,$80,$c1,$e3,$f7,$ff
!byte $9f,$9f,$9f,$9f,$9f,$9f,$9f,$9f
!byte $ff,$ff,$ff,$f8,$f0,$e3,$e7,$e7
!byte $3c,$18,$81,$c3,$c3,$81,$18,$3c
!byte $ff,$c3,$81,$99,$99,$81,$c3,$ff
!byte $e7,$e7,$99,$99,$e7,$e7,$c3,$ff
!byte $f9,$f9,$f9,$f9,$f9,$f9,$f9,$f9
!byte $f7,$e3,$c1,$80,$c1,$e3,$f7,$ff
!byte $e7,$e7,$e7,$00,$00,$e7,$e7,$e7
!byte $3f,$3f,$cf,$cf,$3f,$3f,$cf,$cf
!byte $e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7
!byte $ff,$ff,$fc,$c1,$89,$c9,$c9,$ff
!byte $00,$80,$c0,$e0,$f0,$f8,$fc,$fe
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
!byte $ff,$ff,$ff,$ff,$00,$00,$00,$00
!byte $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$00
!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
!byte $33,$33,$cc,$cc,$33,$33,$cc,$cc
!byte $fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
!byte $ff,$ff,$ff,$ff,$33,$33,$cc,$cc
!byte $00,$01,$03,$07,$0f,$1f,$3f,$7f
!byte $fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
!byte $e7,$e7,$e7,$e0,$e0,$e7,$e7,$e7
!byte $ff,$ff,$ff,$ff,$f0,$f0,$f0,$f0
!byte $e7,$e7,$e7,$e0,$e0,$ff,$ff,$ff
!byte $ff,$ff,$ff,$07,$07,$e7,$e7,$e7
!byte $ff,$ff,$ff,$ff,$ff,$ff,$00,$00
!byte $ff,$ff,$ff,$e0,$e0,$e7,$e7,$e7
!byte $e7,$e7,$e7,$00,$00,$ff,$ff,$ff
!byte $ff,$ff,$ff,$00,$00,$e7,$e7,$e7
!byte $e7,$e7,$e7,$07,$07,$e7,$e7,$e7
!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
!byte $1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
!byte $f8,$f8,$f8,$f8,$f8,$f8,$f8,$f8
!byte $00,$00,$ff,$ff,$ff,$ff,$ff,$ff
!byte $00,$00,$00,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$00,$00,$00
!byte $fc,$fc,$fc,$fc,$fc,$fc,$00,$00
!byte $ff,$ff,$ff,$ff,$0f,$0f,$0f,$0f
!byte $f0,$f0,$f0,$f0,$ff,$ff,$ff,$ff
!byte $e7,$e7,$e7,$07,$07,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$ff,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$f0,$f0,$f0,$f0



