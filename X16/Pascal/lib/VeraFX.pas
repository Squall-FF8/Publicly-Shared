{ =============================
   VERA FX (.r45)
   created on 10/23/2023
   https://github.com/X16Community/x16-docs/blob/master/VERA%20FX%20Reference.md
  ==============================}
unit VeraFX;
  
interface

const
  // DCSEL preclaculate constant
  DCSEL_FX_CONTROL  = 2 << 1; // Control, TileBase, MapBase, Mult
  DCSEL_FX_INCR     = 3 << 1; // X/Y Increments
  DCSEL_FX_POS      = 4 << 1; // X/Y Position
  DCSEL_FX_POLY     = 5 << 1; // X/Y Position (S), Polygon Fill
  DCSEL_FX_CACHE    = 6 << 1; // X/Y Position (S), Polygon Fill

    // How and when ADDR1 is updated.
  FX_ADDR1MODE_VERA     = 0;  // Traditional VERA behavior
  FX_ADDR1MODE_LINE     = 1;  // Line draw helper
  FX_ADDR1MODE_POLYGON  = 2;  // Polygon filler helper
  FX_ADDR1MODE_AFFINE   = 3;  // Affine helper
  
    // Map Size affects both the width and height of the tile map.
  FX_MAP_2x2      = 0;
  FX_MAP_8x8      = 1;
  FX_MAP_32x32    = 2;
  FX_MAP_128x128  = 3;

var
  FX_CONTROL     : byte absolute $9F29;  //  DCSEL=2
  FX_TILEBASE    : byte absolute $9F2A;  //  DCSEL=2
  FX_MAPBASE     : byte absolute $9F2B;  //  DCSEL=2
  FX_MULT        : byte absolute $9F2C;  //  DCSEL=2
  
  FX_X_INCR_L    : byte absolute $9F29;  //  DCSEL=3 
  FX_X_INCR_H    : byte absolute $9F2A;  //  DCSEL=3 
  FX_Y_INCR_L    : byte absolute $9F2B;  //  DCSEL=3 
  FX_Y_INCR_H    : byte absolute $9F2C;  //  DCSEL=3 

  FX_X_POS_L     : byte absolute $9F29;  //  DCSEL=4 
  FX_X_POS_H     : byte absolute $9F2A;  //  DCSEL=4 
  FX_Y_POS_L     : byte absolute $9F2B;  //  DCSEL=4 
  FX_Y_POS_H     : byte absolute $9F2C;  //  DCSEL=4 
  
  FX_X_POS_S     : byte absolute $9F29;  //  DCSEL=5 
  FX_Y_POS_S     : byte absolute $9F2A;  //  DCSEL=5 
  FX_POLY_FILL_L : byte absolute $9F2B;  //  DCSEL=5 
  FX_POLY_FILL_H : byte absolute $9F2B;  //  DCSEL=5 
  
  
  FX_CACHE_L     : byte absolute $9F29;  //  DCSEL=6 
  FX_CACHE_M     : byte absolute $9F2A;  //  DCSEL=6 
  FX_CACHE_H     : byte absolute $9F2B;  //  DCSEL=6 
  FX_CACHE_U     : byte absolute $9F2C;  //  DCSEL=6

  FX_ACCUM_RESET : byte absolute $9F29;  //  DCSEL=6, read 
  FX_ACCUM       : byte absolute $9F2A;  //  DCSEL=6, read
  
  procedure FX_IsAvailable: boolean; 

    // r10 = W1 * W2 (32 bit)
  procedure FX_Multiply(w1, w2: word);
 
   
implementation


procedure FX_IsAvailable: boolean;
begin
  asm 
	        LDX VERA_CTRL       ; keep the reg
          LDA #DCSEL_VERSION
          STA VERA_CTRL
          LDA #0              ; by defual - return false
          
          LDY VERA_DC_VER0
          CPY #$56            ; V
          BNE finish

          LDY VERA_DC_VER1
          CPY #0              ; 0
          BNE true
          
          LDY VERA_DC_VER2
          CPY #3              ; 3
          BCC finish
          BNE true

          LDY VERA_DC_VER3
          CPY #1              ; 1
          BCC finish
          
 true:    LDA #$FF         
 finish:  STX VERA_CTRL
  end; 
end;


  procedure FX_Multiply(w1, w2: word);
    const vAddr = $F9BC; // End of VRAM
          vBank = $1;
          Result = $16;  // r10
  begin
    asm 
	        LDA #DCSEL_FX_CONTROL
          STA VERA_CTRL
          STZ FX_CONTROL    ; Addr1Mode = 0 (normal behavior)
          
          LDA #%00010000    ; Enable multiplier
          STA FX_MULT
          
          LDA #DCSEL_FX_CACHE
          STA VERA_CTRL     ; switch to cache
          
          LDA w1            ; fills the cashe
          STA FX_CACHE_L
          LDA w1 + 1
          STA FX_CACHE_M
          LDA w2
          STA FX_CACHE_H
          LDA w2 + 1
          STA FX_CACHE_U
          
          LDA FX_ACCUM_RESET  ; Reset Accumulator
          
	        LDA #DCSEL_FX_CONTROL
          STA VERA_CTRL
          LDA #%01000000    ; Enable Cache Write
          STA FX_CONTROL 
          
          LDA #<vAddr       ; address in VRAM for result
          STA VERA_ADDR_LO
          LDA #>vAddr
          STA VERA_ADDR_MID
          LDA #vBank
          STA VERA_ADDR_HI  ; no increment  
          
          STZ VERA_DATA1    ; multiply and write rresult in VRAM
          
          LDA #%00010001    ; precalculated Bank and Inc 1
          STA VERA_ADDR_HI 
          
          LDA VERA_DATA1
          STA Result  
          LDA VERA_DATA1
          STA Result +1  
          LDA VERA_DATA1
          STA Result +2 
          LDA VERA_DATA1
          STA Result +3
          
          STZ FX_CONTROL    ; Disable Cashe Writes
          STZ VERA_CTRL     ; reset DCSEL
    end; 
  end; 
 

end. 
