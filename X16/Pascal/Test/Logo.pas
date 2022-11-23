program Logo;
uses X16;

procedure Print(AddressHi:byte registerA; AddressLo: byte registerY; Count: byte registerX);
begin
  asm 
	      STA loop + 2
        STY loop + 1
        LDY #0
 loop:  LDA $FFFF, Y
        JSR __ChrOut
        INY
        DEX
        BNE loop
 finish: 
  end 
end; 

var
  st1: array[] of byte = ($9C, $12, $DF, $92, $20, $20, $20, $20, $20, $12, $E9, $92, $0D);
  st2: array[] of byte = ($9A, $12, $F4, $DF, $92, $20, $20, $20, $12, $E9, $E7, $92, $0D);
  st3: array[] of byte = ($9F, $12, $A1, $A0, $DF, $92, $20, $12, $E9, $A0, $F6, $92, $0D);
  st4: array[] of byte = ($1E, $20, $B7, $12, $FB, $92, $20, $12, $EC, $92, $B7, $20, $0D);
  st5: array[] of byte = ($9E, $20, $EF, $12, $FE, $92, $20, $12, $FC, $92, $EF, $20, $0D);
  st6: array[] of byte = ($81, $E7, $12, $20, $92, $A9, $92, $20, $DF, $12, $A0, $92, $F4, $0D);
  st7: array[] of byte = ($1C, $AA, $A9, $20, $20, $20, $DF, $92, $F5, $05, $0D);
  
BEGIN
  Print( (@st1).High, (@st1).Low, st1.Length );
  Print( (@st2).High, (@st2).Low, st2.Length );
  Print( (@st3).High, (@st3).Low, st3.Length );
  Print( (@st4).High, (@st4).Low, st4.Length );
  Print( (@st5).High, (@st5).Low, st5.Length );
  Print( (@st6).High, (@st6).Low, st6.Length );
  Print( (@st7).High, (@st7).Low, st7.Length );

  {$RTS} 
END.  

