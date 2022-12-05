{ ==================================
  Demo program - SID player (c64)
  Created: 12/5/2022
  Song:    What It Takes, by Jimmy Nielsen (Shogun)
  URL:     https://csdb.dk/sid/?id=57014
   ================================== }
program PlaySID;
uses Commodore64;

var
  CIA_Interrupt : byte absolute $DC0D;
  ScreenControl : byte absolute $D011;
  RasterLine    : byte absolute $D012;
  InterruptFlag : byte absolute $D019;
  InterruptMask : byte absolute $D01A;

  IRQ: word absolute $314;
  SID: array of byte = ({$BIN2CSV What_It_Takes.sid});
  
  Src, Dst, Count: word ZeroPage;
  
  procedure Copy;
  begin
    asm 
          LDY #0
          LDX Count + 1
          BEQ next
          
  loop1:  LDA (Src), Y
          STA (Dst), Y
          INY
          BNE loop1
          INC Src + 1
          INC Dst + 1
          DEX
          BNE loop1
          
  next:   LDX Count
          BEQ stop
  loop2:  LDA (Src), Y
          STA (Dst), Y
          INY
          DEX
          BNE loop2
  stop:     	 
    end; 
  end;
   
begin
  Src   := @SID + $7E;
  Dst   := $17FE {@SID + $7C};
  Count := SID.Length - $7E;
  Copy;
  
  CIA_Interrupt := $7F;  // stops IRQs from CIA
  asm 
          LDA SID + $0A     ; get address of Init
          STA init + 2
          LDA SID + $0B
          STA init + 1
          LDA SID + $0C     ; get address of Play
          STA play + 2
          LDA SID + $0D
          STA play + 1
          
	        LDA #0            ; start with first song
  init:   JSR $0000         ; Init SID player
          SEI
          LDA #1
          STA InterruptMask ; enable raster interrupts
          LDA #$64
          STA RasterLine    ; raise IRQ in that line
          LDA ScreenControl
          AND #$7F          ; Clear bit 7
          STA ScreenControl ; 9th bit of RasterLine
          LDA #<IRQ_Handler ; Hijack IRQ vector
          STA IRQ
          LDA #>IRQ_Handler
          STA IRQ + 1
          CLI
          RTS
          
  IRQ_Handler:          
          INC InterruptFlag ; ack the interrupt
  play:   JSR $0000         ; Play
          JMP $EA31  
  end; 
end.
