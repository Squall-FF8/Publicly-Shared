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
  // Print a 32-bit pointed by A/Y in hex
procedure Print_Hex32(AddressHi:byte registerA; AddressLo: byte registerY);
  // Read and prints the 24bit timer in hex
procedure Print_Timer;
  // Print a byte in decimal format
procedure Print_Dec8(Value: byte registerA);
  // Print a byte in decimal format (with leading zeroes). Fastest!
procedure Print_Dec8z(Value: byte registerA);
  // Print a byte in hex format (with leading zeroes).
procedure Print_Dec16z(Value: word);

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

procedure HexToDec65535(Value: word);


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

procedure Print_Hex32(AddressHi:byte registerA; AddressLo: byte registerY);
  var temp: byte absolute $02;
begin
  asm
          STY temp
          STA temp + 1
          LDY #3
  loop:   LDA (temp), Y
          JSR Print_Hex8
          DEY
          BPL loop
  end; 
end; 

procedure Print_Timer;
begin
  asm 
          JSR __RdTim
          JSR Print_Hex24 
  end; 
end; 


procedure Print_Dec8(Value: byte registerA);
begin
  asm 
          LDX #1
          STX varC
          INX
          LDY #$40
  L1:     STY varB
          LSR
  L2:     ROL
          BCS L3
          CMP varA,X
          BCC L4
  L3:     SBC varA,X
          SEC
  L4:     ROL varB
          BCC L2
          TAY
          CPX varC
          LDA varB
          BCC L5
          BEQ L6
          STX varC
  L5:     EOR #$30
          JSR __ChrOut
  L6:     TYA
          LDY #$10
          DEX
          BPL L1
          RTS

  varA:   DB  128,160,200
  varB:   DB  0
  varC:   DB  0
  end; 
end; 


procedure Print_Dec8z(Value: byte registerA);
  {based on: http://forum.6502.org/viewtopic.php?f=2&t=2656&start=15}
  var outchar: byte;
      Table: array of byte  = [1, 2, 4, 8, 10, 20, 40, 80, 100, 200];
begin
  asm 
          LDX #9        ; 10-1. Table is 10 elements. Start with last
          LDY #$4C      ; $13 * 4
  A1:     STY outchar
  A2:     CMP Table, X
          BCC A3
          SBC Table, x
  A3:     ROL outchar
          DEX
          BCC A2
          TAY
          LDA outchar
          JSR __ChrOut
          TYA
          LDY #$13
          CPX #$FF
          BNE A1

  ;Table:  DB 1, 2, 4, 8, 10 ,20 ,40 ,80 ,100 ,200
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


procedure Print_Dec16z(Value: word);
begin
  asm 
		      lda #$30	; clear the result buffer
		      ldy #$04
  clear:  sta result,y
		      dey
		      BPL clear
          ;BRA prn
		      ldx #$4f
loop1:
		      clc
		      rol Value
		      rol Value + 1
		      bcs calculate	; when bit drops off, decimal value must be added
				                ; if not, go to the next bit
		      txa
				  sec
				  sbc #$05
				  tax
		      bpl loop1
          
          LDX #4
          LDY #0
  loopP:  LDA result, Y
          JSR __ChrOut
          INY
          DEX
          BPL loopP
          
		      rts

calculate:
		      clc
		      ldy #$04
loop2:
		      lda table,x ; get decimal equivalent of bit in ASCII numbers
		      adc #$00    ; add carry, is set if the former addition ≥10
          beq zero    ; skip (speed up) when there's nothing to add
		      adc result,y	; add to whatever result we already have
		      cmp #$3a	; ≥10 with the addition?
		      bcc notten      ; if not, skip the subtraction
		      sbc #$0a	; subtract 10 
notten:
		      sta result,y
zero:
		      dex
		      dey
		      bpl loop2	; loop until all 5 digits have been
		      jmp loop1
table:                          ; decimal values for every bit in 16-bit figure
          DB 0,0,0,0,1 ; %0000000000000001
          DB 0,0,0,0,2 ; %0000000000000010
          DB 0,0,0,0,4 ; %0000000000000100
          DB 0,0,0,0,8 ; %0000000000001000
          DB 0,0,0,1,6 ; %0000000000010000
          DB 0,0,0,3,2 ; %0000000000100000
          DB 0,0,0,6,4 ; %0000000001000000
          DB 0,0,1,2,8 ; %0000000010000000
          DB 0,0,2,5,6 ; %0000000100000000
          DB 0,0,5,1,2 ; %0000001000000000
          DB 0,1,0,2,4 ; %0000010000000000
          DB 0,2,0,4,8 ; %0000100000000000
          DB 0,4,0,9,6 ; %0001000000000000
          DB 0,8,1,9,2 ; %0010000000000000
          DB 1,6,3,8,4 ; %0100000000000000
          DB 3,2,7,6,8 ; %1000000000000000

result:
          DB 0,0,0,0,0 ; this is where the result will be 
  end; 
end; 


procedure HexToDec65535(Value: word);
  const ASCII_OFFSET = $30;
  var dec: array[5] of byte;
      temp: byte;
      Mult24Tab: array of byte = (
        $00,$18,$30,$48,$60,$78,$90,$A8,$C0,$D8,
        $F0,$09,$21,$39,$51,$69,$81,$99,$B1,$C9,
        $E1,$F9,$12,$2A,$42,$5A,$72,$8A,$A2,$BA,
        $D2,$EA,$03,$1B,$33,$4B,$63,$7B,$93,$AB,
        $C3,$DB,$F3,$0C,$24,$3C,$54,$6C,$84,$9C,
        $B4,$CC,$E4,$FC,$15,$2D,$45,$5D,$75,$8D,
        $A5,$BD,$D5,$ED,$06,$1E);
      Mod100Tab: array of byte = (0, 56, 12, 68);
      ShiftedBcdTab: array of byte = (
        $00,$01,$02,$03,$04,$08,$09,$0A,$0B,$0C,
        $10,$11,$12,$13,$14,$18,$19,$1A,$1B,$1C,
        $20,$21,$22,$23,$24,$28,$29,$2A,$2B,$2C,
        $30,$31,$32,$33,$34,$38,$39,$3A,$3B,$3C,
        $40,$41,$42,$43,$44,$48,$49,$4A,$4B,$4C);

begin
  asm 
    ;Hex to Decimal (0-65535) conversion
    ;by Omegamatrix
    ;
    ;HexToDec99     ; 37 cycles
    ;HexToDec255    ; 52-57 cycles
    ;HexToDec999    ; 72-77 cycles
    ;HexToDec65535  ; 157-162 cycles

    ;sta    Value                 ;3  @9
    ;stx    Value+1               ;3  @12
    tax                          ;2  @14
    lsr                          ;2  @16
    lsr                          ;2  @18   integer divide 1024 (result 0-63)

    cpx    #$A7                  ;2  @20   account for overflow of multiplying 24 from 43,000 ($A7F8) onward,
    adc    #0                    ;2  @22   we can just round it to $A700, and the divide by 1024 is fine...
    tay                          ;2  @24
    lda    Mult24Tab+1,Y         ;4  @28   could use LAX...
    tax                          ;2  @30
    and    #$F8                  ;2  @32
    adc    Value                ;3  @35
    txa                          ;2  @37
    and    #$07                  ;2  @39
    adc    Value+1               ;3  @42
    ror                          ;2  @44
    lsr                          ;2  @46
    tay                          ;2  @48   integer divide 1,000 (result 0-65)

    lsr                          ;2  @50   split the 1,000 and 10,000 digit
    tax                          ;2  @52
    lda    ShiftedBcdTab,X       ;4  @56
    tax                          ;2  @58
    rol                          ;2  @60
    and    #$0F                  ;2  @62
    ora    #ASCII_OFFSET         ;IF ASCII_OFFSET
    sta    dec+3          ;3  @65
    txa                          ;2  @67
    lsr                          ;2  @69
    lsr                          ;2  @71
    lsr                          ;2  @73
    ora    #ASCII_OFFSET         ;IF ASCII_OFFSET
    sta    dec+4       ;3  @76


    ;at this point we have a number 0-65 that we have to times by 24,
    ;add to original sum, and Mod 1024 to get the remainder 0-999

    lda    Mult24Tab,Y           ;4  @80   could use LAX...
    tax                          ;2  @82
    and    #$F8                  ;2  @84
    clc                          ;2  @86
    adc    Value                ;3  @89
    sta    temp                  ;3  @92
    txa                          ;2  @94
    adc    Value+1               ;3  @97
Start100s:
    and    #$03                  ;2  @99
    tax                          ;2  @101   0,1,2,3
    cmp    #2                    ;2  @103
    rol                          ;2  @105   0,2,5,7
    ora    #ASCII_OFFSET         ;IF ASCII_OFFSET
    tay                          ;2  @107   Y = Hundreds digit

    lda    temp                  ;3  @110
    adc    Mod100Tab,X           ;4  @114  adding remainder of 256, 512, and 256+512 (all mod 100)
    bcs    doSub200             ;2³ @116/117

try200:
    cmp    #200                  ;2  @118
    bcc    try100               ;2³ @120/121
doSub200:
    iny                          ;2  @122
    iny                          ;2  @124
    sbc    #200                  ;2  @126
try100:
    cmp    #100                  ;2  @128
    bcc    HexToDec99            ;2³ @130/131
    iny                          ;2  @132
    sbc    #100                  ;2  @134
HexToDec99: ;SUBROUTINE
    lsr                          ;2  @136
    tax                          ;2  @138
    lda    ShiftedBcdTab,X       ;4  @142
    tax                          ;2  @144
    rol                          ;2  @146
    and    #$0F                  ;2  @148
    ora    #ASCII_OFFSET         ;IF ASCII_OFFSET
    sta    dec+0               ;3  @151
    txa                          ;2  @153
    lsr                          ;2  @155
    lsr                          ;2  @157
    lsr                          ;2  @159
    ora    #ASCII_OFFSET         ;IF ASCII_OFFSET
    ;rts                          ;6  @165   A = tens digit
          STA dec+1
          STY dec+2
          LDX #4
  loop:   LDA dec, X
          JSR __ChrOut
          DEX
          BPL loop
          RTS



HexToDec255: ;SUBROUTINE
  ;IF ASCII_OFFSET
  ;  ldy    #ASCII_OFFSET         ;2  @8
  ;  bne    .try200               ;3  @11    always branch
  ;ELSE
    ldy    #0                    ;2  @8
    beq    try200               ;3  @11    always branch
  ;ENDIF

HexToDec999: ;SUBROUTINE
    stx    temp                  ;3  @9
    jmp    Start100s             ;3  @12 
  end; 
end;

  
end.
