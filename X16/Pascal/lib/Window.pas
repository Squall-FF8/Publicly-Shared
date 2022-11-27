{ =============================
  Virtual Window Layer for CommanderX16
  Created by piecing together 6 sprites 3x2, 64x64 pixels, 8bpp
  created in 11/26/2022
  ==============================}
unit Window;

interface

  procedure winInit;
  procedure winClear(Color: byte);
  procedure winPosition(Xlo: byte registerA; Xhi: byte registerX; Y: byte registerY);
  
  procedure dSetPos(Bank: byte registerA;  X: byte registerX; Y: byte registerY);
  procedure dLineH(Color: byte registerX; Width: byte registerY);
  procedure dLineV(Color: byte registerX; Width: byte registerY);
  procedure winRectangle(X, Y, W, H: byte);
  procedure winCharOut(Code: byte registerX);

  
implementation

const
  spr_VRAM = $1000;  // Sprites initial address in VRAM
  spr_Addr = $FF20;  // Sprites definition in VRAM. Start with sprite #100
  
  Color0 = $C6;  // Blue-ish (Transparent)
  Color1 = $10;  // Black
  Color2 = $18;  // Gray
  Color3 = $01;  // White
  
  fntHeight = 12;  // in pixels
  
var
    // internal variables
  _X: byte;  // X position of the Cursor
  _Y: byte;  // Y position of the Cursor
  vAddress: word;  // Address in VRAM of the Cursor

  fntColors:   array of byte = (Color0, Color1, Color2, Color3);
  fntWidth:    array of byte = (7, 4, 12);  // in pixels
  fntColumn:   array of byte = (2, 1);  // 1 column = 1 byte
  fntOffsetHi: array of byte = (0, $00, $00);
  fntOffsetLo: array of byte = (0, $18, $24);
  fntLength:   array of byte = (24, 12, 36);
  fntData:     array of byte = (
    $00, $00, $D0, $D0, $D0, $D0, $D0, $D0, $FF, $D0, $D5, $D0,  // H
    $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0, $50, $50, $00, $00,
    $0D, $34, $34, $D0, $D0, $D0, $D0, $D0, $D0, $34, $34, $0D,  // (
    $55, $55, $54, $6A, $BA, $A4, $6A, $BA, $A4, $6A, $BA, $A4,  // shield
    $6A, $9A, $A4, $7F, $57, $f4, $6A, $9A, $A4, $1A, $BA, $90,
    $06, $BA, $40, $01, $B9, $00, $00, $74, $00, $00, $10, $00 );
  
  // Sprites
  spr_Attr: []byte = [
    $80, $80, 100, 0, 100, 0, $0C, $F0,
    $00, $81, 164, 0, 100, 0, $0C, $F0,
    $80, $81, 228, 0, 100, 0, $0C, $F0,
    $00, $82, 100, 0, 164, 0, $0C, $F0,
    $80, $82, 164, 0, 164, 0, $0C, $F0,
    $00, $83, 228, 0, 164, 0, $0C, $F0];


procedure winInit;
begin
  vSetAddress($11, spr_Addr.High, spr_Addr.Low);
  vCopy((@spr_Attr).High, (@spr_Attr).Low, spr_Attr.Length);
end; 


procedure winClear(Color: byte);
begin
  vSetAddress($10, spr_VRAM.High, spr_VRAM.Low);
  vFill256(Color, 96);
end; 


procedure winPosition(Xlo: byte registerA; Xhi: byte registerX; Y: byte registerY);
begin
  asm 
          STA spr_Attr + 2 
          STA spr_Attr + 26
          STX spr_Attr + 3
          STX spr_Attr + 27
          STY spr_Attr + 4
          STY spr_Attr + 12
          STY spr_Attr + 20

          CLC
          ADC #64
          STA spr_Attr + 10
          STA spr_Attr + 34
          BCC skip
          INX
 skip:    STX spr_Attr + 11
          STX spr_Attr + 35

          CLC
          ADC #64
          STA spr_Attr + 18
          STA spr_Attr + 42
          BCC skip1
          INX
 skip1:   STX spr_Attr + 19
          STX spr_Attr + 43
          
          TYA
          CLC
          ADC #64
          STA spr_Attr + 28
          STA spr_Attr + 36
          STA spr_Attr + 44
  end; 
end; 




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
  
  procedure winRectangle(X, Y, W, H: byte);
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

  
procedure winCharOut(Code: byte registerX);
  var addr: word absolute $02;  // ptr to the data
      tmp:  byte absolute $04;  // contain font pixels 
      len:  byte absolute $05;  // length of font data
      col:  byte absolute $06;  // columns (aka bytes per row)
      w:    byte absolute $07;  // width in pixels
      chr:  byte absolute $08;  // code of a char
      ind:  byte absolute $09;  // index to byte from font data
      vram: word absolute $0A;  // temp store for VRAM address
begin
  asm
          LDA vAddrLo
          STA vram
          LDA vAddrHi
          STA vram + 1
          CLC
          LDA fntOffsetLo, X
          ADC #<fntData
          STA addr
          LDA fntOffsetHi, X
          ADC #>fntData
          STA addr + 1
          LDA fntLength, X
          STA len
          STX chr
          STZ ind

 loop3:   LDX chr
          ;LDA fntColumn, X
          ;STA col
          LDA fntWidth, X
          STA w

 loop2:   LDY ind
          LDA (addr), Y
          STA tmp
          LDY #4              ; max 4 pixels in a byte
 loop1:   LDA #0
          ASL tmp
          ROL
          ASL tmp
          ROL
          TAX
          LDA fntColors, X
          STA vData1
          DEC w
          BEQ NewRow
          DEY
          BNE loop1

          INC ind
          BRA loop2

 NewRow:  INC ind
          LDY ind
          CPY len
          BCS finish
          CLC
          LDA vram
          ADC #64
          STA vram
          STA vAddrLo
          BCC loop3
          INC vram +1
          INC vAddrHi
          BRA loop3
 finish: 
  end; 
end;

  
end.
