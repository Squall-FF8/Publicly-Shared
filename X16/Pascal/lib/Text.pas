{ =============================
  Screen routines for the CommanderX16
  created in 11/23/2022
  ==============================}
unit Text;

interface  


  // Print null terminated string from A/Y
procedure Print(AddressHi:byte registerA; AddressLo: byte registerY);
  // Print null terminated string
procedure Print(Str: word);

  // Print a byte in hex format
procedure Print_Hex8(Value: byte registerA);
  // Print a 24-bit in hex format
procedure Print_Hex24(Low:byte registerA; Middle: byte registerX; High: byte registerY);
  // Read and prints the 24bit timer in hex
procedure Print_Timer;

  // Print new line 
procedure NewLine;


implementation

var
  Hex_Digits: array of char = '0123456789ABCDEF';
  
procedure Print(AddressHi:byte registerA; AddressLo: byte registerY);
begin
  asm 
          STA loop + 2
          STY loop + 1
          LDY #0
 loop:    LDA $FFFF, Y
          BEQ finish
          JSR __ChrOut
          INY
          BRA loop
 finish: 
   end 
end;

procedure Print(Str: word);
begin
  asm 
          LDY #0
 loop:    LDA (Str), Y
          BEQ finish
          JSR __ChrOut
          INY
          BRA loop
 finish: 
   end 
end;


procedure Print_Hex8(Value: byte registerA);
begin
  asm 
          PHA
          LSR
          LSR
          LSR
          LSR
          TAX
          LDA Hex_Digits, X
          JSR __ChrOut
          PLA
          AND #$0F
          TAX
          LDA Hex_Digits, X
          JSR __ChrOut
  end; 
end;

procedure Print_Hex24(Low:byte registerA; Middle: byte registerX; High: byte registerY);
begin
  asm 
          PHA
          PHX
          TYA
          JSR Print_Hex8
          PLA
          JSR Print_Hex8
          PLA
          JSR Print_Hex8
  end; 
end; 


procedure Print_Timer;
begin
  asm 
          JSR __RdTim
          JSR Print_Hex24 
  end; 
end; 


procedure NewLine;
begin
  asm 
          LDA #$8D
          JSR __ChrOut 
  end; 
end; 
  
end.
