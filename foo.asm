/*-------------------------------------------------------
Decoding 4x4 tile based map
Full screen
by A. Volkers, 2011
Load your graphics data to the following addresses:
charset:      $2000
tiles:        $3000
map:        $3800
attributes:     $3900

respectively change the code...

-> KickAssembler
-------------------------------------------------------*/
.pc = $1000 

.const tiledatamem  = 48    //hi-byte start address tile data (=$3000)

!var mapdata    = $02   //16bit address map data for decoder
.var tiledata   = $04   //16bit address tile data for decoder
.var tileX    = $fc   //tile columns
.var tileY    = $fd   //tile rows
.var NumberTilesX = $fe   //number of tiles from left to right
.var NumberTilesY = $ff   //number of tiles from top to bottom
.var map    = $20   //16bit address map data for main program
.var attribs    =   $22   //16bit address attributes (=colour)
.var screen   = $24   //16bit screen address
.var mapX   =   $26   //map width

  lda #$0a    //in this case: map width=number of tiles left-right
  sta mapX    //change for required map width...
        
  lda #$00
  sta map
  lda #$38
  sta map+1   //map: $3800
        
  lda #$00      
  sta attribs
  lda #$39
  sta attribs+1   //attributes: $3900
        
  lda #$00
  sta screen
  lda #$04
  sta screen+1    //screen: $0400
        
  lda #$09    //set colours
  sta $d021
  lda #$00
  sta $d020
  lda #$0b
  sta $d022
  lda #$01
  sta $d023
    
  lda #$18    
  sta $d018   //screen mem= $0400, char mem= $2000
  lda #$d8
  sta $d016   //multicolour
        
  jsr decoder
        
  lda #$08    //black
  ldx #$00    //use required code here
!:  sta $d800,x   //to colour the screen
  sta $d900,x
  sta $da00,x
  sta $db00,x
  inx
  bne !-
        jmp*  
  
decoder:lda map       
  sta mapdata     
  lda map+1
  sta mapdata+1   //set actual map pointer
        
  lda #$04    //4 rows per tile   
  sta tileY       
  lda #$03    //4 columns per tile
  sta tileX       
              
  lda #$0a    //number of tiles left-right
  sta NumberTilesX  //#$08 in case of 5x5 tiles
        
  lda #$05    //number of tiles top-bottom
  sta NumberTilesY  //=20 screen rows     
        
  lda screen    //prepare for printing
  sta printchar+1     
  lda screen+1
  sta printchar+2     
        
readmap:ldy #$00
  lda (mapdata),y   //read actual tile number from map data
  
  and #$0f    //calculate tile address
  asl     //use lo-/hi-byte-tables for 5x5 tiles instead
  asl
  asl
  asl
  sta tiledata    //lo-byte tile data
  lda (mapdata),y
  and #$f0
  lsr
  lsr
  lsr
  lsr
  clc
        adc #tiledatamem
  sta tiledata+1    //hi-byte tile data
        
  ldx #$03    //4 columns, #$04 for 5x5 tiles
  ldy tileX
readchar:lda (tiledata),y   //read actual char from tile data
printchar:sta $ffff,x   //print actual char
  dey
  dex
  bpl readchar
        
  inc mapdata   //read next tile from map
  bne !+
  inc mapdata+1
        
!:  lda printchar+1   //add four columns
  clc     //to print next tile
  adc #$04
  sta printchar+1
  bcc !+
  inc printchar+2

!:  dec NumberTilesX  //all tiles left-right done?
  bne readmap       
        
  lda #$0a    //reset number of tiles left-right
  sta NumberTilesX
  lda tileX   //next tile row
  clc
  adc #$04
  sta tileX
  lda mapdata   //reset map pointer
  sec
  sbc #$0a
  sta mapdata
  bcs !+
  dec mapdata+1

!:  dec tileY   //all tile rows done?
  bne readmap
        
  lda #$04    //reset tileY 
  sta tileY
  lda #$03    //reset tileX
  sta tileX     
  lda mapdata   //next map row
  clc
  adc mapX        
  sta mapdata
  bcc !+
  inc mapdata+1     

!:  dec NumberTilesY  //all tiles top-bottom done?
  beq !+
  jmp readmap 
!:  rts 