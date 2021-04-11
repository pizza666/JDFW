!source "..\_includes\system_const.asm"
*=$801
!basic $80d

; consts

WALLMASK1				= $00fb	; 1st wallmask register
WALLMASK2				= $00fc ; 2nd wallmask registesr
WALLMASKT				= $00fe ; temporary wallmask

; drawing consts


*=$80d
							; black screen and clear
							lda #00
							sta VIC_BORDERCOLOR
							sta VIC_BACKGROUNDCOLOR
							
							; activate multicolor
							;lda #16
							;ora $d016
							;sta $d016
							
							;
							lda #09
						  sta $d022
							lda #06
							sta $D023
							
							jsr clearScreen
							jsr drawBordesH   ; draw the borders and
							jsr drawBorderV   ; decorations
							jsr drawDiamonds  ;
							
							;															
							;			123	  possible map positions											
							;     465   draw walls in ascending
						  ;			798	  order to get correct  														
							;			AxB	  canvas layers		 								
							;															
							;			87654321														
							lda #%11000000
							sta WALLMASK1
							;			-----AB9
							lda #%00000001
							sta WALLMASK2
							; load inital walls (for testing)

							; draw the initial canvase
							jsr initCanvas
							
																	
							; start the game loop
							
gameloop			ldy #5
delay			    lda $d012
			        cmp #$ff
		         	bne delay
		         	dey
		         	bne delay

							lda #$7f
key_1					sta $dc00
							lda $dc01
							and #1
							bne key_2		
							lda #1
							eor WALLMASK1
							sta WALLMASK1
							lda #$31
							sta SCREEN+$65														
							jsr initCanvas												
key_2					lda $dc01
							and #8
							bne key_3
							lda #2
							eor WALLMASK1
							sta WALLMASK1						
							lda #$32
							sta SCREEN+$65
							jsr initCanvas
key_3					lda #$fd
							sta $dc00
							lda $dc01
							and #1
							bne key_4
							lda #4
							eor WALLMASK1
							sta WALLMASK1						
							lda #$33
							sta SCREEN+$65
							jsr initCanvas	
key_4					lda $dc01
							and #8
							bne key_5
							lda #8
							eor WALLMASK1
							sta WALLMASK1						
							lda #$34
							sta SCREEN+$65
							jsr initCanvas
key_5					lda #$fb
							sta $dc00
							lda $dc01
							and #1
							bne key_6
							lda #16
							eor WALLMASK1
							sta WALLMASK1						
							lda #$35
							sta SCREEN+$65
							jsr initCanvas
key_6					lda $dc01
							and #8
							bne key_7
							lda #32
							eor WALLMASK1
							sta WALLMASK1						
							lda #$36
							sta SCREEN+$65
							jsr initCanvas	
key_7					lda #$f7
							sta $dc00
							lda $dc01
							and #1
							bne key_8
							lda #64
							eor WALLMASK1
							sta WALLMASK1						
							lda #$37
							sta SCREEN+$65
							jsr initCanvas
key_8					lda #$f7
							sta $dc00
							lda $dc01
							and #8
							bne key_9
							lda #128
							eor WALLMASK1
							sta WALLMASK1						
							lda #$38
							sta SCREEN+$65
							jsr initCanvas
key_9					lda #$ef
							sta $dc00
							lda $dc01
							and #1
							bne key_0		
							lda #1
							eor WALLMASK2
							sta WALLMASK2
							lda #$39
							sta SCREEN+$65														
							jsr initCanvas									
key_0					sta $dc00
							lda $dc01
							and #8
							bne gameloopEnd		
							lda #0
							sta WALLMASK1
							sta WALLMASK2
							lda #$30
							sta SCREEN+$65														
							jsr initCanvas									
gameloopEnd		jmp gameloop							
						

!zone vars
; #  variables go here
; ######################################

ceilingColor	!byte	COLOR_DARKGREY
floorColor		!byte COLOR_BLUE

!zone subRoutines
; #  sub routines here
; ######################################

; drawing stuff - TODO fixing and shorten this with indirect addressing?

initCanvas		jsr drawHorizon	
							jsr drawCeiling
							jsr drawFloor
drawCanvas		lda WALLMASK1
							sta WALLMASKT
							lsr WALLMASKT
							bcc +
							jsr drawWall1
+						  lsr WALLMASKT
							bcc +
							jsr drawWall2														
+						  lsr WALLMASKT
							bcc +
							jsr drawWall3	
+							lsr WALLMASKT
							bcc +
							jsr drawWall4
+							lsr WALLMASKT
							bcc +
							jsr drawWall5
+							lsr WALLMASKT
							bcc +
							jsr drawWall6
+							lsr WALLMASKT
							bcc +
							jsr drawWall7
+							lsr WALLMASKT
							bcc +
							jsr drawWall8	
+						  lda WALLMASK2		; next wallmask byte here
							sta WALLMASKT
							lsr WALLMASKT
							bcc .end
							jsr drawWall9								
.end					rts
							

drawWall1			ldx #5		
							lda #$a0
							ldy #COLOR_DARKGREY
drawWall1L		sta SCREEN+$0119,x
							sta SCREEN+$0119+40,x
							sta SCREEN+$0119+80,x
							pha
							tya
							sta SCREENCOLOR+$0119,x
							sta SCREENCOLOR+$0119+40,x
							sta SCREENCOLOR+$0119+80,x
							pla
							dex
							bpl drawWall1L
							rts

drawWall2			ldx #5		
							lda #$a0
							ldy #COLOR_DARKGREY
-							sta SCREEN+$011F,x
							sta SCREEN+$011F+40,x
							sta SCREEN+$011F+80,x
							pha
							tya
							sta SCREENCOLOR+$011F,x
							sta SCREENCOLOR+$011F+40,x
							sta SCREENCOLOR+$011F+80,x
							pla
							dex
							bpl -
							rts
							
drawWall3			ldx #5		
							lda #$a0
							ldy #COLOR_DARKGREY
drawWall3L		sta SCREEN+$0125,x
							sta SCREEN+$0125+40,x
							sta SCREEN+$0125+80,x
							pha
							tya
							sta SCREENCOLOR+$0125,x
							sta SCREENCOLOR+$0125+40,x
							sta SCREENCOLOR+$0125+80,x
							pla
							dex
							bpl drawWall3L
							rts			
							
drawWall4			lda #$a0
							ldx #3
							ldy #COLOR_LIGHTGREY
dW4L					sta SCREEN+$00c9,x
							sta SCREEN+$00c9+40,x
							sta SCREEN+$00c9+80,x
							sta SCREEN+$00c9+120,x
							sta SCREEN+$00c9+160,x
							sta SCREEN+$00c9+200,x
							sta SCREEN+$00c9+240,x
							pha
							tya
							sta SCREENCOLOR+$00c9,x
							sta SCREENCOLOR+$00c9+40,x
							sta SCREENCOLOR+$00c9+80,x
							sta SCREENCOLOR+$00c9+120,x
							sta SCREENCOLOR+$00c9+160,x
							sta SCREENCOLOR+$00c9+200,x
							sta SCREENCOLOR+$00c9+240,x
							pla
							dex
							bpl dW4L							
							lda #$a0
							ldx #1
							ldy #COLOR_GREY
dW4L2					sta SCREEN+$00c9+4+40,x		;  []
							sta SCREEN+$00c9+4+80,x
							sta SCREEN+$00c9+4+120,x
							sta SCREEN+$00c9+4+160,x
							sta SCREEN+$00c9+4+200,x															
							pha
							tya
							sta SCREENCOLOR+$00c9+4+40,x					
							sta SCREENCOLOR+$00c9+4+80,x
							sta SCREENCOLOR+$00c9+4+120,x
							sta SCREENCOLOR+$00c9+4+160,x
							sta SCREENCOLOR+$00c9+4+200,x
							pla
							dex
							bpl dW4L2							
							lda #$df
							sta SCREEN+$00c9+4				; \
							sta SCREEN+$00c9+4+41			;  \							
							lda #$69							
							sta SCREEN+$00c9+4+201    ; /
							sta SCREEN+$00c9+4+240    ;/														
							lda #COLOR_GREY
							sta SCREENCOLOR+$00c9+4
							sta SCREENCOLOR+$00c9+4+240							
							rts	
							
drawWall5			lda #$a0
							ldx #3
							ldy #COLOR_LIGHTGREY
dW5L					sta SCREEN+$00d7,x
							sta SCREEN+$00d7+40,x
							sta SCREEN+$00d7+80,x
							sta SCREEN+$00d7+120,x
							sta SCREEN+$00d7+160,x
							sta SCREEN+$00d7+200,x
							sta SCREEN+$00d7+240,x
							pha
							tya
							sta SCREENCOLOR+$00d7,x
							sta SCREENCOLOR+$00d7+40,x
							sta SCREENCOLOR+$00d7+80,x
							sta SCREENCOLOR+$00d7+120,x
							sta SCREENCOLOR+$00d7+160,x
							sta SCREENCOLOR+$00d7+200,x
							sta SCREENCOLOR+$00d7+240,x
							pla
							dex
							bpl dW5L
							
							lda #$a0
							ldx #1
							ldy #COLOR_GREY
dW5L2					sta SCREEN+$00d5+40,x								;  []
							sta SCREEN+$00d5+80,x
							sta SCREEN+$00d5+120,x
							sta SCREEN+$00d5+160,x
							sta SCREEN+$00d5+200,x																			
							pha
							tya
							sta SCREENCOLOR+$00d5+40,x								
							sta SCREENCOLOR+$00d5+80,x
							sta SCREENCOLOR+$00d5+120,x
							sta SCREENCOLOR+$00d5+160,x
							sta SCREENCOLOR+$00d5+200,x
							pla
							dex
							bpl dW5L2
							
							lda #$e9
							sta SCREEN+$00d6						;  /
							sta SCREEN+$00d6+39					; /
							
							lda #$5f							
							sta SCREEN+$00d6+199    ; \
							sta SCREEN+$00d6+240    ;  \
														
							lda #COLOR_GREY
							sta SCREENCOLOR+$00d6+199
							sta SCREENCOLOR+$00d6+240
							sta SCREENCOLOR+$00d6
							sta SCREENCOLOR+$00d6+39
							
							rts									

drawWall6			lda #$a0
							ldx #9
							ldy #COLOR_LIGHTGREY
dW6L					lda #$a0
							cpx #0
							bne .lastCol
							lda #$e5
.lastCol		  cpx #9
							bne .midCol
							lda #$e7
.midCol				sta SCREEN+$00cd,x
							sta SCREEN+$00cd+40,x
							sta SCREEN+$00cd+80,x
							sta SCREEN+$00cd+120,x
							sta SCREEN+$00cd+160,x
							sta SCREEN+$00cd+200,x
							sta SCREEN+$00cd+240,x
							tya
							sta SCREENCOLOR+$00cd,x
							sta SCREENCOLOR+$00cd+40,x
							sta SCREENCOLOR+$00cd+80,x
							sta SCREENCOLOR+$00cd+120,x
							sta SCREENCOLOR+$00cd+160,x
							sta SCREENCOLOR+$00cd+200,x
							sta SCREENCOLOR+$00cd+240,x
							dex
							bpl dW6L
							rts
							
drawWall9			lda #$a0
							ldx #15
							ldy #COLOR_WHITE
-							lda #$a0
							cpx #0
							bne +
							lda #$e5
+		  				cpx #15
							bne +
							lda #$e7
+							sta SCREEN+$0052,x
							sta SCREEN+$0052+40,x
							sta SCREEN+$0052+80,x
							sta SCREEN+$0052+120,x
							sta SCREEN+$0052+160,x
							sta SCREEN+$0052+200,x
							sta SCREEN+$0052+240,x
							sta SCREEN+$0052+280,x
							sta SCREEN+$0052+320,x
							sta SCREEN+$0052+360,x
							sta SCREEN+$0052+400,x
							sta SCREEN+$0052+440,x
							sta SCREEN+$0052+480,x						
							tya
							sta SCREENCOLOR+$0052,x
							sta SCREENCOLOR+$0052+40,x
							sta SCREENCOLOR+$0052+80,x
							sta SCREENCOLOR+$0052+120,x
							sta SCREENCOLOR+$0052+160,x
							sta SCREENCOLOR+$0052+200,x
							sta SCREENCOLOR+$0052+240,x
							sta SCREENCOLOR+$0052+280,x
							sta SCREENCOLOR+$0052+320,x
							sta SCREENCOLOR+$0052+360,x
							sta SCREENCOLOR+$0052+400,x
							sta SCREENCOLOR+$0052+440,x
							sta SCREENCOLOR+$0052+480,x
							dex
							bpl -
							rts							
							
							
							
drawWall7			lda #$a0
							ldy #COLOR_WHITE
							sta SCREEN+$0051
							sta SCREEN+$0051+40
							sta SCREEN+$0051+41	
							sta SCREEN+$0051+80
							sta SCREEN+$0051+81
							sta SCREEN+$0051+82
							ldx#3
dW7L					lda #$a0
							sta SCREEN+$0051+120,x
							sta SCREEN+$0051+160,x
							sta SCREEN+$0051+200,x
							sta SCREEN+$0051+240,x
							sta SCREEN+$0051+280,x
							sta SCREEN+$0051+320,x
							sta SCREEN+$0051+360,x
							dex
							bpl dW7L
							sta SCREEN+$0051+400
							sta SCREEN+$0051+401
							sta SCREEN+$0051+402		
							sta SCREEN+$0051+440
							sta SCREEN+$0051+441
							sta SCREEN+$0051+480				
							lda #$df
							sta SCREEN+$0051+1
							sta SCREEN+$0051+42
							sta SCREEN+$0051+83							
							lda #$69
							sta SCREEN+$0051+403
							sta SCREEN+$0051+442
							sta SCREEN+$0051+481
							tya
							sta SCREENCOLOR+$0051
							sta SCREENCOLOR+$0051+40								
							sta SCREENCOLOR+$0051+80
							sta SCREENCOLOR+$0051+120
							sta SCREENCOLOR+$0051+160
							sta SCREENCOLOR+$0051+200
							sta SCREENCOLOR+$0051+240
							sta SCREENCOLOR+$0051+280
							sta SCREENCOLOR+$0051+320
							sta SCREENCOLOR+$0051+360
							sta SCREENCOLOR+$0051+400					
							sta SCREENCOLOR+$0051+440
							sta SCREENCOLOR+$0051+480						
							ldy #COLOR_LIGHTGREY
							tya
							ldx #2
dW7C					sta SCREENCOLOR+$0052+120,x
							sta SCREENCOLOR+$0052+160,x
							sta SCREENCOLOR+$0052+200,x
							sta SCREENCOLOR+$0052+240,x
							sta SCREENCOLOR+$0052+280,x
							sta SCREENCOLOR+$0052+320,x
							sta SCREENCOLOR+$0052+360,x
							dex
							bpl dW7C
							sta SCREENCOLOR+$0051+1
							sta SCREENCOLOR+$0051+42
							sta SCREENCOLOR+$0051+83
							sta SCREENCOLOR+$0051+403
							sta SCREENCOLOR+$0051+442
							sta SCREENCOLOR+$0051+481						
							sta SCREENCOLOR+$0051+41	
							sta SCREENCOLOR+$0051+81
							sta SCREENCOLOR+$0051+82
							sta SCREENCOLOR+$0051+401
							sta SCREENCOLOR+$0051+402				
							sta SCREENCOLOR+$0051+441
							rts															
										
drawWall8			lda #$a0
							ldy #COLOR_WHITE
							sta SCREEN+$0062
							sta SCREEN+$0062+39
							sta SCREEN+$0062+40
							sta SCREEN+$0062+78
							sta SCREEN+$0062+79
							sta SCREEN+$0062+80				
							sta SCREEN+$0062+399
							sta SCREEN+$0062+398
							sta SCREEN+$0062+400					
							sta SCREEN+$0062+440
							sta SCREEN+$0062+439
							sta SCREEN+$0062+479
							sta SCREEN+$0062+480


							ldx#3
dW8L					lda #$a0
							sta SCREEN+$005f+120,x
							sta SCREEN+$005f+160,x
							sta SCREEN+$005f+200,x
							sta SCREEN+$005f+240,x
							sta SCREEN+$005f+280,x
							sta SCREEN+$005f+320,x
							sta SCREEN+$005f+360,x
							dex
							bpl dW8L
							
							lda #$e9
							sta SCREEN+$005f+2
							sta SCREEN+$005f+41
							sta SCREEN+$005f+80								
							lda #$5f
							sta SCREEN+$005f+400
							sta SCREEN+$005f+441
							sta SCREEN+$005f+482
							tya
							sta SCREENCOLOR+$0062
							sta SCREENCOLOR+$0062+40									
							sta SCREENCOLOR+$0062+80
							sta SCREENCOLOR+$0062+120
							sta SCREENCOLOR+$0062+160
							sta SCREENCOLOR+$0062+200
							sta SCREENCOLOR+$0062+240
							sta SCREENCOLOR+$0062+280
							sta SCREENCOLOR+$0062+320
							sta SCREENCOLOR+$0062+360
							sta SCREENCOLOR+$0062+400						
							sta SCREENCOLOR+$0062+440
							sta SCREENCOLOR+$0062+480							
							ldy #COLOR_LIGHTGREY
							tya
							ldx #2
dW8C					sta SCREENCOLOR+$005f+120,x
							sta SCREENCOLOR+$005f+160,x
							sta SCREENCOLOR+$005f+200,x
							sta SCREENCOLOR+$005f+240,x
							sta SCREENCOLOR+$005f+280,x
							sta SCREENCOLOR+$005f+320,x
							sta SCREENCOLOR+$005f+360,x
							dex
							bpl dW8C							
							sta SCREENCOLOR+$0062+39
							sta SCREENCOLOR+$0062+78
							sta SCREENCOLOR+$0062+79				
							sta SCREENCOLOR+$0062+399
							sta SCREENCOLOR+$0062+398					
							sta SCREENCOLOR+$0062+439
							sta SCREENCOLOR+$0062+479

							sta SCREENCOLOR+$005f+2
							sta SCREENCOLOR+$005f+41
							sta SCREENCOLOR+$005f+80
							
							sta SCREENCOLOR+$005f+400
							sta SCREENCOLOR+$005f+441
							sta SCREENCOLOR+$005f+482

							rts								
							
drawHorizon		ldx #17
							lda #$e6
							ldy #COLOR_DARKGREY
							jmp drawHorizonL																				
; a=character y=color x=position							
drawHorizonL	sta SCREEN+$0119,x
							sta SCREEN+$0119+40,x
							sta SCREEN+$0119+80,x
							pha
							tya
							sta SCREENCOLOR+$0119,x
							sta SCREENCOLOR+$0119+40,x
							sta SCREENCOLOR+$0119+80,x
							pla
							dex
							bpl drawHorizonL
							rts							
							
drawBordesH		ldx #39											
drawBorderHL	lda #$c3
							sta SCREEN,x					; 1st border
							sta SCREEN+640,x 			; mid border
							sta SCREEN+960,x			; last border
							lda #COLOR_BROWN
							sta SCREENCOLOR,x
							sta SCREENCOLOR+640,x
							sta SCREENCOLOR+960,x										
							dex
							bpl drawBorderHL				; stay positve :)
							rts							
							
drawBorderV		lda #$c2
							;left
							sta SCREEN+40					
							sta SCREEN+80
							sta SCREEN+120
							sta SCREEN+160
							sta SCREEN+200
							sta SCREEN+240
							sta SCREEN+280
							sta SCREEN+320
							sta SCREEN+360
							sta SCREEN+400
							sta SCREEN+440
							sta SCREEN+480
							sta SCREEN+520
							sta SCREEN+560
							sta SCREEN+600
							sta SCREEN+680
							sta SCREEN+720
							sta SCREEN+760
							sta SCREEN+800
							sta SCREEN+840
							sta SCREEN+880
							sta SCREEN+920
							; middle
							sta SCREEN+40+19			
							sta SCREEN+80+19
							sta SCREEN+120+19
							sta SCREEN+160+19
							sta SCREEN+200+19
							sta SCREEN+240+19
							sta SCREEN+280+19
							sta SCREEN+320+19
							sta SCREEN+360+19
							sta SCREEN+400+19
							sta SCREEN+440+19
							sta SCREEN+480+19
							sta SCREEN+520+19
							sta SCREEN+560+19
							sta SCREEN+600+19
							; right
							sta SCREEN+40+39			
							sta SCREEN+80+39
							sta SCREEN+120+39
							sta SCREEN+160+39
							sta SCREEN+200+39
							sta SCREEN+240+39
							sta SCREEN+280+39
							sta SCREEN+320+39
							sta SCREEN+360+39
							sta SCREEN+400+39
							sta SCREEN+440+39
							sta SCREEN+480+39
							sta SCREEN+520+39
							sta SCREEN+560+39
							sta SCREEN+600+39
							sta SCREEN+680+39
							sta SCREEN+720+39
							sta SCREEN+760+39
							sta SCREEN+800+39
							sta SCREEN+840+39
							sta SCREEN+880+39
							sta SCREEN+920+39							
borderColorV	lda #COLOR_BROWN
							;left
							sta SCREENCOLOR+40							
							sta SCREENCOLOR+80
							sta SCREENCOLOR+120
							sta SCREENCOLOR+160
							sta SCREENCOLOR+200
							sta SCREENCOLOR+240
							sta SCREENCOLOR+280
							sta SCREENCOLOR+320
							sta SCREENCOLOR+360
							sta SCREENCOLOR+400
							sta SCREENCOLOR+440
							sta SCREENCOLOR+480
							sta SCREENCOLOR+520
							sta SCREENCOLOR+560
							sta SCREENCOLOR+600
							sta SCREENCOLOR+680
							sta SCREENCOLOR+720
							sta SCREENCOLOR+760
							sta SCREENCOLOR+800
							sta SCREENCOLOR+840
							sta SCREENCOLOR+880
							sta SCREENCOLOR+920					
							; middle
							sta SCREENCOLOR+40+19						
							sta SCREENCOLOR+80+19
							sta SCREENCOLOR+120+19
							sta SCREENCOLOR+160+19
							sta SCREENCOLOR+200+19
							sta SCREENCOLOR+240+19
							sta SCREENCOLOR+280+19
							sta SCREENCOLOR+320+19
							sta SCREENCOLOR+360+19
							sta SCREENCOLOR+400+19
							sta SCREENCOLOR+440+19
							sta SCREENCOLOR+480+19
							sta SCREENCOLOR+520+19
							sta SCREENCOLOR+560+19
							sta SCREENCOLOR+600+19
							; right
							sta SCREENCOLOR+40+39						
							sta SCREENCOLOR+80+39
							sta SCREENCOLOR+120+39
							sta SCREENCOLOR+160+39
							sta SCREENCOLOR+200+39
							sta SCREENCOLOR+240+39
							sta SCREENCOLOR+280+39
							sta SCREENCOLOR+320+39
							sta SCREENCOLOR+360+39
							sta SCREENCOLOR+400+39
							sta SCREENCOLOR+440+39
							sta SCREENCOLOR+480+39
							sta SCREENCOLOR+520+39
							sta SCREENCOLOR+560+39
							sta SCREENCOLOR+600+39
							sta SCREENCOLOR+680+39
							sta SCREENCOLOR+720+39
							sta SCREENCOLOR+760+39
							sta SCREENCOLOR+800+39
							sta SCREENCOLOR+840+39
							sta SCREENCOLOR+880+39
							sta SCREENCOLOR+920+39
							rts
							
drawDiamonds	lda	#$da
							sta SCREEN
							sta SCREEN+19
							sta SCREEN+39
							sta SCREEN+640
							sta SCREEN+659
							sta SCREEN+679	
							sta SCREEN+$03c0
							sta SCREEN+$03e7
							rts
							
drawCeiling		ldx #17
drawCeilingL	lda #$7e
							sta SCREEN+$0029,x
							sta SCREEN+$0029+40,x
							sta SCREEN+$0029+80,x
							sta SCREEN+$0029+120,x
							sta SCREEN+$0029+160,x
							sta SCREEN+$0029+200,x	
							lda ceilingColor
							sta SCREENCOLOR+$0029,x
							sta SCREENCOLOR+$0029+40,x
							sta SCREENCOLOR+$0029+80,x
							sta SCREENCOLOR+$0029+120,x
							sta SCREENCOLOR+$0029+160,x
							sta SCREENCOLOR+$0029+200,x	
							dex
							bpl drawCeilingL
							rts
							
drawFloor			ldx #17
drawFloorL		lda #$ff
							sta SCREEN+$0191,x
							sta SCREEN+$0191+40,x
							sta SCREEN+$0191+80,x
							sta SCREEN+$0191+120,x
							sta SCREEN+$0191+160,x
							sta SCREEN+$0191+200,x
							lda floorColor
							sta SCREENCOLOR+$0191,x
							sta SCREENCOLOR+$0191+40,x
							sta SCREENCOLOR+$0191+80,x
							sta SCREENCOLOR+$0191+120,x
							sta SCREENCOLOR+$0191+160,x
							sta SCREENCOLOR+$0191+200,x
							dex
							bpl drawFloorL
							rts
						
clearScreen		lda #147
							jsr PRINT
							rts						
; we include external subroutes
!source "..\_includes\wait.asm"	

!zone data