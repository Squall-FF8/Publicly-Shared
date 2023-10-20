unit VERA;  
interface

const
  iVSYNC  = $01;
  iLINE   = $02;
  iSPRCOL = $04;
  iAFLOW  = $08;
  
  // VRAM Addresses
  VRAM_BITMAP  = $0000;  // Bank 0
  VRAM_TEXT    = $B000;  // Bank 1 
  VRAM_PETSCII = $F000;  // Bank 1
  
  VRAM_PSG     = $F9C0;  // Bank 1
  VRAM_PALETTE = $FA00;  // Bank 1
  VRAM_SPRITES = $FC00;  // Bank 1
  
type
  tSprite = object
    VRAM: word;
    X, Y: word;
    Prop: byte;
    Attr: byte;
  end;  

var
  // X16 I/O Registers. Official Naming
  VERA_ADDR_LO       : byte absolute $9F20;
  VERA_ADDR_MID      : byte absolute $9F21;
  VERA_ADDR_HI       : byte absolute $9F22;
  VERA_DATA1         : byte absolute $9F23;
  VERA_DATA2         : byte absolute $9F24;
  VERA_CTRL          : byte absolute $9F25;
  VERA_IEN           : byte absolute $9F26;  
  VERA_ISR           : byte absolute $9F27;
  VERA_IRQLINE       : byte absolute $9F28;
  VERA_DC_VIDEO      : byte absolute $9F29;
  VERA_DC_HSCALE     : byte absolute $9F2A;
  VERA_DC_VSCALE     : byte absolute $9F2B;
  VERA_DC_BORDER     : byte absolute $9F2C;
  VERA_DC_HSTART     : byte absolute $9F29;
  VERA_DC_HSTOP      : byte absolute $9F2A;
  VERA_DC_VSTART     : byte absolute $9F2B;
  VERA_DC_VSTOP      : byte absolute $9F2C;
  VERA_L0_CONFIF     : byte absolute $9F2D;
  VERA_L0_MAPBASE    : byte absolute $9F2E;
  VERA_L0_TILEBASE   : byte absolute $9F2F;
  VERA_L0_HSCROLL_LO : byte absolute $9F30;
  VERA_L0_HSCROLL_HI : byte absolute $9F31;
  VERA_L0_VSCROLL_LO : byte absolute $9F32;
  VERA_L0_VSCROLL_HI : byte absolute $9F33;
  VERA_L1_CONFIF     : byte absolute $9F34;
  VERA_L1_MAPBASE    : byte absolute $9F35;
  VERA_L1_TILEBASE   : byte absolute $9F36;
  VERA_L1_HSCROLL_LO : byte absolute $9F37;
  VERA_L1_HSCROLL_HI : byte absolute $9F38;
  VERA_L1_VSCROLL_LO : byte absolute $9F39;
  VERA_L1_VSCROLL_HI : byte absolute $9F3A;
  VERA_AUDIO_CTRL    : byte absolute $9F3B;
  VERA_AUDIO_RATE    : byte absolute $9F3C;
  VERA_AUDIO_DATA    : byte absolute $9F3D;
  VERA_SPI_DATA      : byte absolute $9F3E;
  VERA_SPI_CTRL      : byte absolute $9F3F;
    
  // My Naming
  vAddrLo       : byte absolute $9F20;
  vAddrHi       : byte absolute $9F21;
  vAddrBank     : byte absolute $9F22;
  vData1        : byte absolute $9F23;
  vData2        : byte absolute $9F24;
  vControl      : byte absolute $9F25;
  vIrqCtrl      : byte absolute $9F26;  
  vIRQ          : byte absolute $9F27;
  vAddress      : word absolute $9F20; // for some cute code
  
  L0_HScroll : word absolute VERA_L0_HSCROLL_LO;
  L0_VScroll : word absolute VERA_L0_VSCROLL_LO;
  L1_HScroll : word absolute VERA_L1_HSCROLL_LO;
  L1_VScroll : word absolute VERA_L1_VSCROLL_LO;
  
  
procedure vSetAddress(Bank: byte; Address: word);  
procedure vSetAddress(Bank: byte registerA; High: byte registerX; Low: byte registerY);
procedure vSetAddress(High: byte registerX; Low: byte registerY);

procedure vPoke(Bank: byte; Address: word; Value: byte);  
procedure vPoke2(Bank: byte; Address: word; Value: byte);  

procedure vCopy(AddrHi: byte registerA; AddrLo: byte registerY; Num: byte registerX);
procedure vFill256(Color: byte registerA; Num256: byte registerX);
procedure vFill(Color: byte registerA; Count: byte registerX);


implementation  


procedure vSetAddress(Bank: byte; Address: word);
begin
  vAddrBank := Bank;
  vAddress  := Address;
end;

procedure vSetAddress(Bank: byte registerA; High: byte registerX; Low: byte registerY);  
begin
  vAddrBank := Bank;
  vAddrHi   := High;
  vAddrLo   := Low;
end;

procedure vSetAddress(High: byte registerX; Low: byte registerY);
begin
  vAddrHi   := High;
  vAddrLo   := Low;
end;


procedure vPoke(Bank: byte; Address: word; Value: byte);  
begin
  vAddrBank := Bank;
  vAddress  := Address;
  vData1    := Value;
end;

procedure vPoke2(Bank: byte; Address: word; Value: byte);  
begin
  vAddrBank := Bank;
  vAddress  := Address;
  vData2    := Value;
end;


procedure vCopy(AddrHi: byte registerA; AddrLo: byte registerY; Num: byte registerX);
  var tmp: word absolute $02;
begin
  asm 
      STA loop + 2
      STY Loop + 1
      LDY #0
loop: LDA $FFFF, Y
      STA vData1
      INY
      DEX
      BNE loop      
  end 
end;

procedure vFill256(Color: byte registerA; Num256: byte registerX);
begin
  asm
      LDY #$00
loop: STA VERA_DATA1
      INY
      BNE loop
      DEX
      BNE loop
  end 
end; 

procedure vFill(Color: byte registerA; Count: byte registerX);
begin
  asm
loop: STA VERA_DATA1
      DEX
      BNE loop
  end 
end; 
 
end.
