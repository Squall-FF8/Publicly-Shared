////////////////////////////////////////////
// New program created in 11/12/2022}
////////////////////////////////////////////
program NewProgram;
uses x16, VERA;

const
  spr1_VRAM = $1000;
  spr2_VRAM = $2000;
  spr1_Addr = $FC08;
  spr2_Addr = $FC10;
  
  Color0 = $C6;  // Blue-ish (Transparent)
  Color1 = $01;  // White
  Color2 = $10;  // Black
  Color3 = $18;  // Gray
  
  procedure dSetPos(Bank: byte registerA;  X: byte registerX; Y: byte registerY);
    // Address = $1000 (1 + x div 64) + $3000 (y div 64) + (x mod 64) + (y mod 64) * 64
  const
    tmp = $22;
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
  
  procedure dLineH(Color: byte registerA;  X1: byte registerX; X2: byte registerY);
  const
    dY  = $FC0;
    _X2  = $22;
    Col  = $23;
    stop = $24;
  begin
    asm
        STA Col
        STY _X2
        
        TXA
        AND #%11000000
        CLC
        ADC #%01000000
 loop0: CMP _X2
        BCC skip
        LDA _X2
 skip:  STA stop
  
        LDA Col
 loop1: STA vData1
        INX
        CPX stop
        BNE loop1
        CPX _X2
        BCS fin
        
        CLC
        LDA vAddrLo
        ADC #dY.Low
        STA vAddrLo
        LDA vAddrHi
        ADC #dY.High
        STA vAddrHi
        
        CLC
        LDA stop
        ADC #64
        BRA loop0
 fin:       
    end; 
  end;
   
  procedure dLineV(Color: byte registerA;  Y1: byte registerX; Y2: byte registerY);
  const
    dY  = $2000;
    _Y2  = $22;
    Col  = $23;
    stop = $24;
  begin
    asm
        STA Col
        STY _Y2
        
        TXA
        AND #%11000000
        CLC
        ADC #%01000000
 loop0: CMP _Y2
        BCC skip
        LDA _Y2
 skip:  STA stop
  
        LDA Col
 loop1: STA vData1
        INX
        CPX stop
        BNE loop1
        CPX _Y2
        BCS fin
        
        CLC
        LDA vAddrLo
        ADC #dY.Low
        STA vAddrLo
        LDA vAddrHi
        ADC #dY.High
        STA vAddrHi
        
        CLC
        LDA stop
        ADC #64
        BRA loop0
 fin:       
    end; 
  end;
  
var
  // Sprites
  spr1_Attr: []byte = [$80, $80, 100, 0, 100, 0, $0C, $F0,
                       $00, $81, 164, 0, 100, 0, $0C, $F0,
                       $80, $81, 228, 0, 100, 0, $0C, $F0,
                       $00, $82, 100, 0, 164, 0, $0C, $F0,
                       $80, $82, 164, 0, 164, 0, $0C, $F0,
                       $00, $83, 228, 0, 164, 0, $0C, $F0];
  w: pointer;
  i: byte;
begin
asm
  LDX #2 
	JMP (table, X)
  table: DW  dLineV, dLineH, dSetPos
end; 
  vControl := 0;  // VERA_DATA1 will be used. DC_SEL= 0
  vSetAddress($11, spr1_Addr.High, spr1_Addr.Low);
  w := @spr1_Attr;
  vCopy(w.High, w.Low, spr1_Attr.Length);

  vSetAddress($10, spr1_VRAM.High, spr1_VRAM.Low);
  vFill256(Color0, 96);
  
  //vSetAddress($10, $59, $24);
  //for i := 0 to 191 do 
  //dSetPos($10, i, 1);
  //vFill(Color1, 1);
  //end;

  dSetPos($10, 1, 1);
  dLineH(Color1, 1, 190);
  dSetPos($10, 1, 126);
  dLineH(Color1, 1, 190);
  
  dSetPos($70, 1, 1);
  dLineV(Color1, 1, 126);
  dSetPos($70, 190, 1);
  dLineV(Color1, 1, 126);

  
  VERA_DC_VIDEO :=  VERA_DC_VIDEO or (1 << 6);  // Enable Sprites

  {$RTS} 
end.
