////////////////////////////////////////////
// New program created in 11/23/2022}
////////////////////////////////////////////
program Logo2;
uses X16, VERA;

  procedure Plot(X: byte registerX; Y: byte registerY);
    const
      Screen = $B000;  
  begin
    asm
          TXA
          ASL
          STA vAddrLo
          TYA
          CLC
          ADC #>Screen
          STA vAddrHi
          RTS
    end; 
  end;
  
  procedure Print_Attrib(AddressHi:byte registerA; AddressLo: byte registerY; Attribute: byte registerX);
  begin
    asm 
	        STA loop + 2
          STY loop + 1
          LDY #0
 loop:    LDA $FFFF, Y
          BEQ finish
          STA vData1
          STX vData1
          INY
          BRA loop
 finish: 
    end 
  end;

  procedure Print_Logo(AddressHi:byte registerA; AddressLo: byte registerY);
    const
      ptr = $30;
      tmp = $32;
      row = $33;
  begin
    asm
          STY ptr
	        STA ptr + 1
          LDA vAddrLo
          STA tmp
          LDA #7
          STA row
          LDY #0
 loop1:   LDA (ptr), Y
          TAX
          INY
 loop2:   LDA (ptr), Y
          BEQ next
          STA vData1
          STX vData1
          INY
          BRA loop2
 next:    LDA tmp
          STA vAddrLo
          INC vAddrHi
          INY
          DEC row
          BNE loop1
    end 
  end;
  
var
  logo: array of byte = (
    $64,  $DF, $20, $20, $20, $20, $20, $E9, $00, 
    $6E,  $F4, $DF, $20, $20, $20, $E9, $E7, $00, 
    $63,  $F5, $A0, $DF, $20, $E9, $A0, $F6, $00, 
    $65,  $20, $77, $FB, $20, $EC, $77, $20, $00, 
    $67,  $20, $6F, $FE, $20, $FC, $6F, $20, $00, 
    $68,  $67, $A0, $69, $20, $5F, $A0, $74, $00, 
    $62,  $76, $69, $20, $20, $20, $5F, $75, $00); 
 
begin
  vControl := 0;    // VERA_DATA1 will be used. DC_SEL= 0
  vAddrBank := $11; // vBank = 1; increment 1

  Plot(10, 10);
  Print_Logo( (@logo).High, (@logo).Low );
  
  {$RTS} 
end.
