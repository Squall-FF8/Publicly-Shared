{ =============================
  Screen routines for the CommanderX16
  created in 11/23/2022
  ==============================}
unit Text;

interface

  // Check these sites:
  // https://en.wikipedia.org/wiki/PETSCII
  //https://github.com/commanderx16/x16-docs/blob/master/X16%20Reference%20-%2002%20-%20Editor.md

const
    // Screen Modes
  Text80x60 = $00;
  Text80x30 = $01;
  Text40x60 = $02;
  Text40x30 = $03;
  Text40x15 = $04;
  Text20x30 = $05;
  Text20x15 = $06;
  Graphics320x240 = $80;
  
    // Char Modes
  ASCII_mode   = $0F;
  PETSCII_mode = $8F; 
  
    // Colors
  COLOR_White     = $05;
  COLOR_Red       = $1C;
  COLOR_Green     = $1E;
  COLOR_Blue      = $1F;
  COLOR_Orange    = $81;
  COLOR_Black     = $90;
  COLOR_Brown     = $95;
  COLOR_LightRed  = $96;
  COLOR_DarkGray  = $97;
  COLOR_MiddleGray = $98;
  COLOR_LightGreen = $99;
  COLOR_LightBlue = $9A;
  COLOR_LightGray = $9B;
  COLOR_Purple    = $9C;
  COLOR_Yellow    = $9E;
  COLOR_Cyan      = $9F;


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
  // Sets char modes (used by ChrOut)
procedure CharMode(Mode: byte RegisterA);
  // Sets char modes (used by ChrOut)
procedure ScreenMode(Mode: byte RegisterA);

  // Sets the Foreground color
procedure SetFgColor(Color: byte registerA);
  // Sets the Background color
procedure SetBgColor(Color: byte registerX);
  // Sets the Background color
procedure SetColors(ColorFg: byte registerA; ColorBG: byte registerX);


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


procedure CharMode(Mode: byte RegisterA);
begin
  asm 
          JSR __ChrOut  ; A already has the code
  end; 
end;


procedure ScreenMode(Mode: byte RegisterA);
begin
  asm
          CLC           ; Sets the mode 
          JSR SCREEN_Mode  ; A already has the code
  end; 
end;


procedure SetFgColor(Color: byte registerA);
begin
  asm 
          JSR __ChrOut  ; A already has the code
  end; 
end;

procedure SetBgColor(Color: byte registerX);
begin
  asm
          LDA #1        ; Swap Bg/Fg
          JSR __ChrOut
          TXA           ; Set BG
          JSR __ChrOut
          LDA #1        ; Swap Bg/Fg
          JSR __ChrOut
  end; 
end;

procedure SetColors(ColorFg: byte registerA; ColorBG: byte registerX);
begin
  asm
          JSR __ChrOut  ; Set Fg
          LDA #1        ; Swap Bg/Fg
          JSR __ChrOut
          TXA           ; Set BG
          JSR __ChrOut
          LDA #1        ; Swap Bg/Fg
          JSR __ChrOut
  end; 
end;

  
end.
