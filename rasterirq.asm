*=$801
!basic $80e

!source "_includes\system_const.asm"

STARTBLACK =				0
STARTRED		 =				104
STARTGOLD	 =				208


main
		sei																					; disable interrupts so we can configre them
		lda #<rasterIrq									; write our routine address to the irq vector
		sta IRQ_VECTOR_LO							; low byte to the irq vector
		lda #>rasterIrq       		
		sta IRQ_VECTOR_HI							; hi byte to the irq vecotr
		
		lda #STARTBLACK									; we will have our first interrupt at 0
		sta VIC_RASTERROWPOS				; write it to the raster line interrupt register
		
		lda VIC_CONTROLREG1					; clear bit #8 of rasterline
		and #%01111111
		sta VIC_CONTROLREG1
		
		lda VIC_IRQMASK									; enable raster interrupts w/ bit #0
		ora #%00000001				
		sta VIC_IRQMASK
		cli																					; enable interrupts
		rts

*=$1000	
rasterIrq
		lda VIC_IRQSTATUS							; we ack the raster line interrupt (technically we ack all interrupts here)
		bmi doRasterIrq									; N=bit#7 is set? this means the irq came from VICII
		lda $dc0d															; ack the CIA irqs
		cli	
		jmp $ea31															; return to basic rom
doRasterIrq	
		sta VIC_IRQSTATUS							; raster line is bit #0
		lda VIC_RASTERROWPOS				; load the rasterline
		bne doRed															; go to red if we aren't 0
		lda #COLOR_BLACK
		sta VIC_BORDERCOLOR
		sta VIC_BACKGROUNDCOLOR
		lda #STARTRED											; next time we irq on the "red line"
		sta VIC_RASTERROWPOS
		jmp rasterIrqExit
doRed
		cmp #STARTRED											; "red line"?
  bne doGold														; go gold!
		lda #COLOR_RED										; load red
		sta VIC_BACKGROUNDCOLOR	; store in background and
		sta VIC_BORDERCOLOR					; border color
		lda #STARTGOLD										; wirte gold line to irq raster line reg
		sta VIC_RASTERROWPOS
		jmp rasterIrqExit
doGold
		lda #COLOR_YELLOW							; we load yellow
		sta VIC_BACKGROUNDCOLOR ;
		sta VIC_BORDERCOLOR
		lda #STARTBLACK									; load black line again
		sta VIC_RASTERROWPOS				; we hold on black next time again
rasterIrqExit
		pla																					; pull a from stac
		tay																					; restore as y
		pla																					; pull a from stack
		tax																					; return as x
		pla																					; pull a from stac
		rti																					; return from irq
		