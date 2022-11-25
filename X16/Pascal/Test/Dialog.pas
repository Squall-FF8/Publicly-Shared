////////////////////////////////////////////
// New program created in 11/12/2022}
////////////////////////////////////////////
program NewProgram;
uses x16, VERA;

const
  spr1_VRAM = $1000;
  spr2_VRAM = $2000;
  spr1_Addr = $FF20;
  
  Color0 = $C6;  // Blue-ish (Transparent)
  Color1 = $01;  // White
  Color2 = $10;  // Black
  Color3 = $18;  // Gray
  
  fntHeight = 12;  // in pixels
  
var
    // internal variables
  _X: byte;  // X position of the Cursor
  _Y: byte;  // Y position of the Cursor
  vAddress: word;  // Address in VRAM of the Cursor

  fntColors:   array of byte = (Color0, Color1, Color2, Color3);
  fntWidth:    array of byte = (7);  // in pixels
  fntColumn:   array of byte = (2);  // 1 column = 1 byte
  fntOffsetHi: array of byte = (0);
  fntOffsetLo: array of byte = (0);
  fntData:     array of byte = (
    $00, $00, $0D, $0D, $0D, $0D, $0D, $0D, $55, $0D, $FD, $0D, $0D, $0D, $0D, $0D,
    $0D, $0D, $0D, $0D, $0F, $0F, $00, 00 );
  
  procedure dSetPos(Bank: byte registerA;  X: byte registerX; Y: byte registerY);
    // Address = $1000 (1 + x div 64) + $3000 (y div 64) + (x mod 64) + (y mod 64) * 64
  const
    tmp = $02;
  begin
    asm
        STA vAddrBank
        
	      TXA
        AND #%11000000  ; X div 64
        LSR
        LSR
        CLC
        ADC #$10         ; add $1000
        CPY #64
        BCC skip
        CLC
        ADC #$30         ; add $3000 if y >=64
  skip: STA tmp
  
        TXA
        AND #%00111111  ; X mod 64
        STA tmp + 1
        
        TYA
        STZ tmp + 2
        ;AND #%00111111  ; Y mod 64
        ASL
        ASL
        ASL
        ROL tmp + 2 
        ASL
        ROL tmp + 2
        ASL
        ROL tmp + 2 
        ASL
        ROL tmp + 2     ; x 64
        
        CLC
        ADC tmp + 1
        STA vAddrLo
        
        LDA tmp
        ADC tmp +2
        STA vAddrHi
    end; 
  end; 
  
  procedure dLineH(Color: byte registerX; Width: byte registerY);
  const
    dY  = $FC0;
  begin
    asm
 loop0: LDA #%00111111  
 loop1: STX vData1
        DEY
        BEQ fin
        BIT vAddrLo
        BNE loop1
        
        CLC
        LDA vAddrLo
        ADC #dY.Low
        STA vAddrLo
        LDA vAddrHi
        ADC #dY.High
        STA vAddrHi
        BRA loop0
 fin:       
    end; 
  end;
  

  procedure dLineV(Color: byte registerX; Width: byte registerY);
  const
    dY  = $2000;
  begin
    asm
        LDA vAddrHi
 loop0: AND #%11110000
        CLC
        ADC #$10
 loop1: STX vData1
        DEY
        BEQ fin
        CMP vAddrHi
        BNE loop1
        
        CLC
        ;LDA vAddrLo
        ;ADC #dY.Low
        ;STA vAddrLo
        LDA vAddrHi
        ADC #dY.High
        STA vAddrHi
        BRA loop0
 fin:       
    end; 
  end;
  
  procedure dRectangle(X, Y, W, H: byte);
  begin
    dSetPos($10, X, Y);
    dLineH(Color1, W-1);
    vAddrBank := $70;
    dLineV(Color1, H);
    dSetPos($70, X, Y+1);
    dLineV(Color1, H-2);
    vAddrBank := $10;
    dLineH(Color1, W-1);
  end; 
  
var
  // Sprites
  spr1_Attr: []byte = [$80, $80, 100, 0, 100, 0, $0C, $F0,
                       $00, $81, 164, 0, 100, 0, $0C, $F0,
                       $80, $81, 228, 0, 100, 0, $0C, $F0,
                       $00, $82, 100, 0, 164, 0, $0C, $F0,
                       $80, $82, 164, 0, 164, 0, $0C, $F0,
                       $00, $83, 228, 0, 164, 0, $0C, $F0];
  i: byte;
begin
  vControl := 0;  // VERA_DATA1 will be used. DC_SEL= 0
  vSetAddress($11, spr1_Addr.High, spr1_Addr.Low);
  vCopy((@spr1_Attr).High, (@spr1_Attr).Low, spr1_Attr.Length);

  vSetAddress($10, spr1_VRAM.High, spr1_VRAM.Low);
  vFill256(Color0, 96);

  dRectangle(1, 1, 190, 126);  
  dRectangle(10, 10, 172, 108);
  
  _X := 80;
  _Y := 80;
  dSetPos($10, 80, 80);

  VERA_DC_VIDEO :=  VERA_DC_VIDEO or (1 << 6);  // Enable Sprites

  {$RTS} 
end.
