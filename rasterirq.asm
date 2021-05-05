!source "_includes\system_const.asm"
*=$801
!basic $80d

STARTBLACK =				0
STARTRED		 =				42
STARTGOLD	 =				208
HELLOSCREENPOS = SCREEN+821
HELLOSCREENPOSCOLOR = SCREENCOLOR+841
BANK=2

main

		;lda #%00011011
		;eor #%0010000		
		;sta $d011 						; we make sure text mode is enabled at the beginning
		jsr $e544
		
		lda #0
		sta $d020
		
	 	lda $d016
		ora #%00100000																; activate multicolor
		sta $d016

		sei										; disable interrupts so we can configre them
		lda #<rasterIrq				; write our routine address to the irq vector
		sta IRQ_VECTOR_LO			; low byte to the irq vector
		lda #>rasterIrq     	  		
		sta IRQ_VECTOR_HI			; hi byte to the irq vecotr
		
		lda #STARTBLACK				; we will have our first interrupt at 0
		sta VIC_RASTERROWPOS	; write it to the raster line interrupt register
		
		lda VIC_CONTROLREG1		; clear bit #8 of rasterline
		and #%01111111
		sta VIC_CONTROLREG1
		
		lda VIC_IRQMASK				; enable raster interrupts w/ bit #0
		ora #%00000001				
		sta VIC_IRQMASK
		cli										; enable interrupts

loop jmp loop
		
		rts

hello !scr "hello world",0
		
		
*=$1000	
rasterIrq
		lda VIC_IRQSTATUS				; we ack the raster line interrupt (technically we ack all interrupts here)
		bmi doRasterIrq					; N=bit#7 is set? this means the irq came from VICII
		lda $dc0d								; ack the CIA irqs
		cli					          	
		jmp $ea31								; return to basic rom
doRasterIrq	              	
		sta VIC_IRQSTATUS				; raster line is bit #0
		lda VIC_RASTERROWPOS		; load the rasterline
		bne doRed																; go to red if we aren't 0
		lda #COLOR_BLACK
		;sta VIC_BORDERCOLOR
		sta VIC_BACKGROUNDCOLOR
		lda #STARTRED						; next time we irq on the "red line"
		sta VIC_RASTERROWPOS
		jmp rasterIrqExit
doRed
		cmp #STARTRED							; "red line"?
  bne doGold									; go gold!
		lda #COLOR_RED						; load red
		;sta VIC_BACKGROUNDCOLOR	; store in background and
		
		lda #%00111011						; enable bitmap mode
		sta $d011
		
		lda $d018
		ora #8
		sta $d018
		
		lda $d016
		ora #%00100000																; activate multicolor
		sta $d016
		
		lda bitmapColor
		sta SCREEN
		
		lda #STARTGOLD						; wirte gold line to irq raster line reg
		sta VIC_RASTERROWPOS
		jmp rasterIrqExit
		
		
doGold
		lda #COLOR_GREY						; we load yellow
		sta VIC_BACKGROUNDCOLOR
		;sta VIC_BORDERCOLOR
		
		;lda $d011
		;eor #%0010000						; flip back to text mode
		LDA #%00011011						;	enable text  mode
		STA $D011
		
		lda $d016
		eor #%00100000																		; activate multicolor
		sta $d016
		
		
		lda #%10101								; $15 = 21
		sta $d018
		
		lda #$ff
		sta $2000
		
		
		 	lda #<hello
 	sta $fb
 	lda #>hello
 	sta $fc
 	
 	lda #<HELLOSCREENPOS
 	sta $40
 	lda #>HELLOSCREENPOS
 	sta $41
		
		lda #<HELLOSCREENPOSCOLOR
		sta $03
		lda #>HELLOSCREENPOSCOLOR
		sta $04
 	
 	ldy #0
-	lda ($fb),y
  beq +
 	sta ($40),y
		lda #0
		sta ($03),y
 	iny
 	jmp -
+
		
		lda #STARTBLACK					; load black line again
		sta VIC_RASTERROWPOS		; we hold on black next time again
rasterIrqExit
		pla											; pull a from stac
		tay											; restore as y
		pla											; pull a from stack
		tax											; return as x
		pla											; pull a from stac
		rti											; return from irq
		
*=$2000
bitmap
!media "bitmap_rasterirq.graphicscreen",bitmaphiresscreen
bitmapColor
!media "bitmap_rasterirq.graphicscreen",screen
