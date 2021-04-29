!source "..\_includes\system_const.asm"
*=$801
!basic $80d

; #  conts go here - outsourcing
; #  if it gets to large
; ######################################

; zero pages (use thrifty)
WALLMASK1				= $02 				; 1st wallmask register
WALLMASK2				= $03 ; 2nd wallmask registesr
WALLMASKT				= $04 ; temporary wallmask

; name our zero pages
LOB_DATA				= $40		; we use this for data addressing
HIB_DATA				= $41
LOB_SCREEN			= $fb 	; this for screen positioning
HIB_SCREEN			= $fc
CHARDATA_W			= $a7
CHARDATA_H			= $a8
		

; map const
MAPWIDTH				= 8
MAPHIGHT				= 8
W							  = $d6		;normal wall
S								= $20		;normal floor/sky
MAPOFFSET				= $b6		
MAPPOS 					= SCREEN+MAPOFFSET
MAPCOLOR				= SCREENCOLOR+MAPOFFSET
NORTH						= %10001000 ; $88 - 136
EAST						= %01000100 ; $44 - 68
SOUTH						= %00100010 ; $22 - 34
WEST						= %00010001 ; $11 - 17
ICON_NORTH			= 28
ICON_EAST				= 29
ICON_SOUTH			= 30
ICON_WEST				= 31

; keyboard
KEYROWS 				=	$dc00			; peek
KEYCOLS					= $dc01 		; poke
 														;+----+---------+-------------------------------------------------------------------------------------------------------+
 														;|    |         |                                Peek from $dc01 (code in paranthesis):                                 |
 														;|row:| $dc00:  +------------+------------+------------+------------+------------+------------+------------+------------+
 														;|    |         | 128  BIT 7 | 64 BIT 6   | 32 BIT 5   | 16 BIT 4   | 8  BIT 3   | 4  BIT 2   | 2  BIT 1   | 1  BIT 0   |
 														;+----+---------+------------+------------+------------+------------+------------+------------+------------+------------+
KEYROW_1				= %11111110 ; (254/$fe) 		| DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
KEYROW_2				= %11111101	; (253/$fd)     |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
KEYROW_3				= %11111011 ; (251/$fb)     |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
KEYROW_4				= %11110111 ; (247/$f7)     |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
KEYROW_5				= %11101111 ; (239/$ef)     |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
KEYROW_6				= %11011111 ; (223/$df)     |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
KEYROW_7				= %10111111 ; (191/$bf)     |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
KEYROW_8				= %01111111 ; (127/$7f)     | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
														;+----+---------+------------+------------+------------+------------+------------+------------+------------+------------+
; drawing consts

*=$80d
!zone initGame
							; black screen and clear
							lda #00
							sta VIC_BORDERCOLOR
							sta VIC_BACKGROUNDCOLOR
							
							; activate multicolor
							;lda #16
							;ora $d016
							;sta $d016
							
							; use charset $2000
							lda #$18		
							sta VIC_MEMSETUP
							
							;
							lda #09
						  sta $d022
							lda #06
							sta $d023
							
							jsr clearScreen
							jsr drawBordesH   ; draw the borders and
							jsr drawBorderV   ; decorations
							jsr drawDiamonds  ;
							jsr drawMap;
							
							;															
							;			123	         possible map positions											
							;     465          draw walls in ascending
						  ;			798	         order to get correct  														
							;			AxB	         canvas layers		 								

; wall naming for drawing if pd=means north
W3 = %00000001  ; WALLMASK1
W2 = %00000100  ; WALLMASK1
W1 = %01000000  ; WALLMASK1
W0 = %00000010  ; WALLMASK2

N3 = %00000010  ; WALLMASK1
N2 = %01000000  ; WALLMASK1
N1 = %00000001  ; WALLMASK2
							
E3 = %00000100  ; WALLMASK1
E2 = %10010000  ; WALLMASK1
E1 = %00000000  ; WALLMASK1
E0 = %00000100	; WALLMASK2


		
							;			87654321														
							lda #%00000000
							sta WALLMASK1
							;			-----BA9
							lda #%00000000
							sta WALLMASK2
							; load inital walls (for testing)

							; draw the initial canvase
							jsr getWalls
							jsr setWalls
							jsr initCanvas
																							
							; start the game loop

!zone gameloop							
gameloop			
waitraster		lda VIC_RASTERROWPOS
			        cmp #$50
		         	bne waitraster

							; TODO refactor the key loop with lsr maybe							
							
							lda #KEYROW_8				; #8
key_1					sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_2		
							lda #1
							eor WALLMASK1
							sta WALLMASK1
							lda #$31
							sta SCREEN+$65														
							jsr initCanvas												
key_2					lda KEYCOLS
							and #8
							bne key_Q
							lda #2
							eor WALLMASK1
							sta WALLMASK1						
							lda #$32
							sta SCREEN+$65
							jsr initCanvas
key_Q					lda KEYCOLS
							and #64			
							bne key_3
							lda pd		; rotate player left
							asl
							rol pd
							jsr setDirection
							jsr getWalls
							jsr setWalls
							jsr initCanvas
							jsr drawMap
							jsr drawPlayer											
key_3					lda #KEYROW_2				; #2
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_W
							lda #4
							eor WALLMASK1
							sta WALLMASK1						
							lda #$33
							sta SCREEN+$65
							jsr initCanvas	
key_W					lda KEYCOLS
							and #2
							bne key_A
							lda #$17
							sta SCREEN+$65
							jsr movePlayerF
							jsr getWalls
							jsr setWalls
							jsr initCanvas
							jsr drawMap
							jsr drawPlayer								
key_A					lda KEYCOLS
							and #4
							bne key_4
							lda #$01
							sta SCREEN+$65
							jsr initCanvas
							jsr movePlayerW
							jsr drawMap
							jsr drawPlayer						
key_4					lda KEYCOLS
							and #8
							bne key_S
							lda #8
							eor WALLMASK1
							sta WALLMASK1						
							lda #$34
							sta SCREEN+$65
							jsr initCanvas
key_S					lda KEYCOLS
							and #32
							bne key_E							
							lda #$13
							sta SCREEN+$65
							jsr initCanvas
							jsr movePlayerS
							jsr drawMap
							jsr drawPlayer
key_E					lda KEYCOLS
							and #64			
							bne key_5
							lda pd	; rotate player right
							lsr
							ror pd
							jsr setDirection
							jsr getWalls
							jsr setWalls
							jsr initCanvas
							jsr drawMap
							jsr drawPlayer			
key_5					lda #KEYROW_3			; # 3
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_D
							lda #16
							eor WALLMASK1
							sta WALLMASK1						
							lda #$35
							sta SCREEN+$65
							jsr initCanvas
key_D					lda KEYCOLS
							and #4
							bne key_6
							lda #$04
							sta SCREEN+$65
							jsr initCanvas
							jsr movePlayerE
							jsr drawMap
							jsr drawPlayer
key_6					lda KEYCOLS
							and #8
							bne key_7
							lda #32
							eor WALLMASK1
							sta WALLMASK1						
							lda #$36
							sta SCREEN+$65
							jsr initCanvas	
key_7					lda #KEYROW_4			; #4
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_8
							lda #64
							eor WALLMASK1
							sta WALLMASK1						
							lda #$37
							sta SCREEN+$65
							jsr initCanvas
key_8					lda KEYCOLS
							and #8
							bne key_B
							lda #128
							eor WALLMASK1
							sta WALLMASK1						
							lda #$38
							sta SCREEN+$65
							jsr initCanvas
key_B					lda KEYCOLS
							and #16
							bne key_9
							lda #4
							eor WALLMASK2
							sta WALLMASK2						
							lda #$02
							sta SCREEN+$65
							jsr initCanvas												
key_9					lda #KEYROW_5		; #5
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_0		
							lda #1
							eor WALLMASK2
							sta WALLMASK2
							lda #$39
							sta SCREEN+$65														
							jsr initCanvas									
key_0					lda KEYCOLS
							and #8
							bne printdebugs		
							lda #0
							sta WALLMASK1
							sta WALLMASK2
							lda #$30
							sta SCREEN+$65														
							jsr initCanvas
							lda #2
							sta px
							sta py
							jsr drawMap
							jsr drawPlayer
							
printdebugs		jsr clearValues					
							;jsr initCanvas
							lda py					   ; player y debug
							sta value
							jsr printdec
							lda resultstr							
							sta SCREEN+$6a
							lda resultstr+1
							sta SCREEN+$69
							lda resultstr+2
							sta SCREEN+$68
							lda #$19
							sta SCREEN+$67
							
							jsr clearValues
							
							lda px						; player x debug
							sta value
							jsr printdec
							lda resultstr							
							sta SCREEN+$6f
							lda resultstr+1
							sta SCREEN+$6e
							lda resultstr+2
							sta SCREEN+$6d
							lda #$18
							sta SCREEN+$6c
						
							jsr clearValues
							
							lda pd						; player x debug
							sta value
							jsr printdec
							lda resultstr							
							sta SCREEN+$74
							lda resultstr+1
							sta SCREEN+$73
							lda resultstr+2
							sta SCREEN+$72
							lda #$04
							sta SCREEN+$71		
							
							; little hack to get player on map for now
							; we should rewrite the kernal routinges
							
							;clc
							;ldy px
							;ldx py
							;jsr PLOT
							;lda #$da
							;jsr PRINT
							
gameloopEnd		jmp gameloop							
						

!zone vars
; #  variables go here
; ######################################

ceilingColor	!byte	COLOR_DARKGREY
floorColor		!byte COLOR_BLUE
px						!byte 1,0,0,0				; player x coordinate
py						!byte 2,0,0,0				; player y coordinate
pd						!byte %10001000		; player direction
pIco					!byte	ICON_NORTH			; which icon to use for the player on map


!zone subRoutines
; #  sub routines here
; ######################################

; rotating and moving

; drawing stuff - TODO fixing and shorten this with indirect addressing

drawMap				lda #MAPWIDTH
							sta CHARDATA_W
							lda #MAPHIGHT
							sta CHARDATA_H
							lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							lda #<MAPPOS				; get low byte of the mappos (screen ram w/ offset)
							sta LOB_SCREEN			; store in zpage
							lda #>MAPPOS				; same for...
							sta HIB_SCREEN
							jsr drawChars
							jsr drawPlayer
							rts
							
getWalls			lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
						  ldy py
							dey
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey							
							bpl -
							
							; row in front of the player
							ldy px						; load the player x
							lda (LOB_DATA),y
							sta northWall1
							
							ldy px				; load the player x
							iny						; this gives us the field to the north east of the player
							lda (LOB_DATA),y
							sta eastWall2
							
							ldy px				; load the player x
							dey						; this gives us the field to the north west of the player
							lda (LOB_DATA),y
							sta westWall2
							
							; last row (the row where the player is in)
							; so add one more mapwidth to the data
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							
							ldy px				; load the player x
							iny						; this gives us the field to the east of the player
							lda (LOB_DATA),y
							sta eastWall1
							
							ldy px				; load the player x
							dey						; this gives us the field to the west of the player
							lda (LOB_DATA),y
							sta westWall1
							
				      rts	
					
eastWall1  		!byte 0
westWall1	 		!byte 0		
northWall1 		!byte 0

eastWall2	 		!byte 0
westWall2	 		!byte 0


;																													
;					1 2 3	  possible map positions
;     		4 6 5   draw walls in ascendin
;					7 9 8	  order to get correct
;					B x A	  canvas layers			 					
;																													
;			 87654321																				
;lda #%00000000
;sta WALLMASK1
;					-----BA9
;lda #%00000000
;sta WALLMASK2

setWalls			lda #0					; first we clear all walls
							sta WALLMASK1
							sta WALLMASK2

							lda eastWall1		; #1 east wall east to ppos
							cmp #W
							bne ++
							lda pd
							cmp #NORTH
							bne +
							lda #E0
+							cmp #SOUTH
							bne +
							lda #W0
+							cmp #EAST
							bne +
							lda #N1
+							cmp #WEST
							bne +
							lda #0						
+							ora WALLMASK2
							sta WALLMASK2
							
++						lda westWall1		; #1 west wall east to ppos
							cmp #W
							bne ++
							lda pd
							cmp #NORTH
							bne +
							lda #2
+							cmp #SOUTH
							bne +
							lda #4
+							cmp #WEST
							bne +
							lda #1
+							cmp #EAST
							bne +
							lda #0
+							ora WALLMASK2
							sta WALLMASK2
							
++					  lda northWall1		; #1 north wall east to ppos
							cmp #W
							bne ++
							lda pd
							cmp #NORTH
							bne +
							lda #1
+							cmp #EAST
							bne +
							lda #2
+							cmp #WEST
							bne +
							lda #4
+							cmp #SOUTH
							bne +
							lda #0						
+							ora WALLMASK2
							sta WALLMASK2

++						lda eastWall2			; #2 east wall east to ppos
							cmp #W
							bne ++
							lda pd
							cmp #NORTH
							bne +
							lda #128
+							cmp #EAST
							bne +
							lda #64
+							cmp #SOUTH
							bne +
							lda #0							
+							ora WALLMASK1
							sta WALLMASK1

++						lda westWall2				; #2 west wall east to ppos
							cmp #W
							bne ++
							lda pd
							cmp #NORTH
							bne +
							lda #64
+							cmp #WEST
							bne +
							lda #128							
+							cmp #SOUTH
							bne +
							lda #0
+							cmp #EAST
							bne +
							lda #0							
+							ora WALLMASK1
							sta WALLMASK1
							
++						rts
	
							
setDirection	lda pd
							cmp #NORTH
							bne +
							ldx #ICON_NORTH
							stx pIco
+							cmp #EAST
							bne +
							ldx #ICON_EAST
							stx pIco
+							cmp #SOUTH
							bne +
							ldx #ICON_SOUTH
							stx pIco
+							cmp #WEST
							bne +
							ldx #ICON_WEST
							stx pIco
+							rts

!zone movePlayer
movePlayerF		lda pd							; move player forward in pd (player direction) TODO maybe cycle optimization needed
							cmp #NORTH
							bne +
							jsr movePlayerN
+							cmp #EAST
							bne +
							jsr movePlayerE
+							cmp #SOUTH
							bne +
							jsr movePlayerS
+							cmp #WEST
							bne +
							jsr movePlayerW
+							rts

							
movePlayerE		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -						
							ldy px
							iny
							lda (LOB_DATA),y
							cmp #W
							beq +
							inc px
+							rts

movePlayerW		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -					
							ldy px
							dey
							lda (LOB_DATA),y
							cmp #W
							beq +
							dec px
+							rts

movePlayerN		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							;dey
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bne -					
							ldy px
							lda (LOB_DATA),y
							cmp #W
							beq +
							dec py
+							rts


movePlayerS		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							iny
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -					
							ldy px
							lda (LOB_DATA),y
							cmp #W
							beq +
							inc py
+							rts							
													
drawPlayer		lda #<MAPPOS				; we set our position back to the actuial map position
							sta LOB_SCREEN			;
							lda #>MAPPOS				;
							sta HIB_SCREEN

							ldy py							; we load the player y position
-							lda LOB_SCREEN		
							clc									
							adc #40							; add 40 ( screen row has 40 chars/bytes)
							sta LOB_SCREEN							
							lda HIB_SCREEN      ; carry is not clear
 							adc #0              ; we add it to the high byte of the screen
 							sta HIB_SCREEN      ; and store it
							dey
							bpl -								; at the end we should have the y position in first row
							ldy px							; now we load x	
							lda pIco						; player icon
							sta (LOB_SCREEN),y
							rts

drawChars			ldx #0							; x = 0 for our row number
							dec CHARDATA_W
--						ldy CHARDATA_W			; y = mapwidth-1 is the last byte of a map data row
- 						lda (LOB_DATA),y		; store the data indirect addressed with y
						  sta (LOB_SCREEN),y  ; in the screen position
							dey									; decrement y
							bpl -								; is y still positive branc to -							
							
							lda LOB_SCREEN			; were done with the row and load the low byte of the screen
							clc									; clear the carry
							adc #40							; add 40 ( screen row has 40 chars/bytes)
							sta LOB_SCREEN							
							lda HIB_SCREEN      ; carry is not clear
 							adc #0              ; we add it to the high byte of the screen
 							sta HIB_SCREEN      ; and store it
							
							lda LOB_DATA
							clc
							adc CHARDATA_W			; next row
							sta LOB_DATA
							inc LOB_DATA
							lda HIB_DATA        ; carry is not clear
 							adc #0
							sta HIB_DATA
							inx
							cpx CHARDATA_H
							bne --
							rts						
!zone canvas
initCanvas		jsr drawHorizon
							jsr drawCeiling
							jsr drawFloor
							lda WALLMASK1
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
							bcc +		
							jsr drawWall9
+							lsr WALLMASKT
							bcc +
							jsr drawWallA	
+							lsr WALLMASKT
							bcc +
							jsr drawWallB							
+							rts					

!zone drawCanvas						; single routines for drawing walls, floor and ceiling
drawWall1			ldx #5		
							lda #$a0
							ldy #COLOR_DARKGREY
-							sta SCREEN+$0119,x
							sta SCREEN+$0119+40,x
							sta SCREEN+$0119+80,x
							pha
							tya
							sta SCREENCOLOR+$0119,x
							sta SCREENCOLOR+$0119+40,x
							sta SCREENCOLOR+$0119+80,x
							pla
							dex
							bpl -
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
-							sta SCREEN+$0125,x
							sta SCREEN+$0125+40,x
							sta SCREEN+$0125+80,x
							pha
							tya
							sta SCREENCOLOR+$0125,x
							sta SCREENCOLOR+$0125+40,x
							sta SCREENCOLOR+$0125+80,x
							pla
							dex
							bpl -
							rts
							
drawWall4			lda #$a0
							ldx #3
							ldy #COLOR_LIGHTGREY
-							sta SCREEN+$00c9,x
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
							bpl -							
							lda #$a0
							ldx #1
							ldy #COLOR_GREY
-							sta SCREEN+$00c9+4+40,x		;  []
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
							bpl -							
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

drawWallA			lda #$a0
							sta SCREEN+$0051
							sta SCREEN+$0051+40
							sta SCREEN+$0051+80
							sta SCREEN+$0051+120
							sta SCREEN+$0051+160
							sta SCREEN+$0051+200
							sta SCREEN+$0051+240
							sta SCREEN+$0051+280
							sta SCREEN+$0051+320
							sta SCREEN+$0051+360
							sta SCREEN+$0051+400
							sta SCREEN+$0051+440
							sta SCREEN+$0051+480
							lda #$df
							sta SCREEN+$0029
							lda #$69
							sta SCREEN+$0259
							lda #COLOR_WHITE
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
							sta SCREENCOLOR+$0029
							sta SCREENCOLOR+$0259
							rts					
							
drawWallB			lda #$a0
							sta SCREEN+$0062
							sta SCREEN+$0062+40
							sta SCREEN+$0062+80
							sta SCREEN+$0062+120
							sta SCREEN+$0062+160
							sta SCREEN+$0062+200
							sta SCREEN+$0062+240
							sta SCREEN+$0062+280
							sta SCREEN+$0062+320
							sta SCREEN+$0062+360
							sta SCREEN+$0062+400
							sta SCREEN+$0062+440
							sta SCREEN+$0062+480
							lda #$e9
							sta SCREEN+$003a
							lda #$5f
							sta SCREEN+$026a
							lda #COLOR_WHITE
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
							sta SCREENCOLOR+$003a
							sta SCREENCOLOR+$026a
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
-							lda #$a0
							sta SCREEN+$0051+120,x
							sta SCREEN+$0051+160,x
							sta SCREEN+$0051+200,x
							sta SCREEN+$0051+240,x
							sta SCREEN+$0051+280,x
							sta SCREEN+$0051+320,x
							sta SCREEN+$0051+360,x
							dex
							bpl -
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
-							sta SCREENCOLOR+$0052+120,x
							sta SCREENCOLOR+$0052+160,x
							sta SCREENCOLOR+$0052+200,x
							sta SCREENCOLOR+$0052+240,x
							sta SCREENCOLOR+$0052+280,x
							sta SCREENCOLOR+$0052+320,x
							sta SCREENCOLOR+$0052+360,x
							dex
							bpl -
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
-							lda #$a0
							sta SCREEN+$005f+120,x
							sta SCREEN+$005f+160,x
							sta SCREEN+$005f+200,x
							sta SCREEN+$005f+240,x
							sta SCREEN+$005f+280,x
							sta SCREEN+$005f+320,x
							sta SCREEN+$005f+360,x
							dex
							bpl -					
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
-							sta SCREENCOLOR+$005f+120,x
							sta SCREENCOLOR+$005f+160,x
							sta SCREENCOLOR+$005f+200,x
							sta SCREENCOLOR+$005f+240,x
							sta SCREENCOLOR+$005f+280,x
							sta SCREENCOLOR+$005f+320,x
							sta SCREENCOLOR+$005f+360,x
							dex
							bpl -							
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
							;jmp drawHorizonL																											
-							sta SCREEN+$0119,x
							sta SCREEN+$0119+40,x
							sta SCREEN+$0119+80,x
							pha
							tya
							sta SCREENCOLOR+$0119,x
							sta SCREENCOLOR+$0119+40,x
							sta SCREENCOLOR+$0119+80,x
							pla
							dex
							bpl -
							rts	
drawCeiling		ldx #17
-							lda #$7e
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
							bpl -
							rts
							
drawFloor			ldx #17
-							lda #$ff
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
							bpl -
							rts	
							

!zone drawUI							
drawBordesH		ldx #39											
-							lda #$c3
							sta SCREEN,x					; 1st border
							sta SCREEN+640,x 			; mid border
							sta SCREEN+960,x			; last border
							lda #COLOR_BROWN
							sta SCREENCOLOR,x
							sta SCREENCOLOR+640,x
							sta SCREENCOLOR+960,x										
							dex
							bpl -				; stay positve :)
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
							lda #COLOR_BROWN
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
						
!zone clearingRoutines						
clearScreen		lda #147
							jsr PRINT
							rts
					
clearValues		lda #$30
							sta resultstr
							sta resultstr+1
							sta resultstr+2
							sta result
							lda #0
							sta value
							sta value+1
							sta value+2
							sta result
							sta result+1
							sta result+2
							rts							
!zone math							
printdec			jsr hex2dec			
        			ldx #9
l1      			lda result,x
        			bne l2
        			dex             ; skip leading zeros
        			bne l1
l2      			lda result,x
        			ora #$30							
							; insert other print routine here
        			sta resultstr,x										
        			dex
        			bpl l2
        			rts
        		  ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec       ldx #0
l3      		  jsr div10
        		  sta result,x
        		  inx
        		  cpx #10
        		  bne l3
        		  rts
       			  ; divides a 32 bit value by 10
       			  ; remainder is returned in akku
div10         ldy #32         ; 32 bits
           	  lda #0
           	  clc
l4         	  rol
           	  cmp #10
           	  bcc skip
           	  sbc #10
skip       	  rol value
           	  rol value+1
           	  rol value+2
           	  rol value+3
           	  dey
           	  bpl l4
           	  rts				

value   		!byte 0,0,0,0
result  		!byte 0,0,0,0,0,0,0,0,0,0
resultstr		!text "00000000"			

!zone externalSubRoutines							
; we include external subroutes
!source "..\_includes\wait.asm"	

!zone data
map						!byte W,W,W,S,W,W,S,W
							!byte W,S,W,S,S,S,S,W
							!byte W,S,W,S,S,S,S,W
							!byte W,S,S,S,S,S,S,S
							!byte W,S,S,W,S,W,S,S
							!byte W,S,S,S,S,W,S,S
							!byte W,S,S,S,S,W,S,S
							!byte W,W,W,W,W,W,W,W
*=$2000
!media 	"dungeon.charsetproject",char