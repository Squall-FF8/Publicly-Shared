////////////////////////////////////////////
// New program created in 12/2/2022}
////////////////////////////////////////////
program PETSCII_ART;
uses Commodore64;

var
  ScreenControl   : byte absolute $D011;
  MemorySetup     : byte absolute $D018;
  BorderColor     : byte absolute $D020;
  BackgroundColor : byte absolute $D021;
  
  Characters : array of byte = ({$BIN2CSV chars.bin});
  Colors     : array of byte = ({$BIN2CSV colors.bin});
  
  vram_Char  : array[1000] of byte absolute $400;
  vram_Color : array[1000] of byte absolute $D800;
  
  i: word;
  
begin
  ScreenControl   := $0B;
  MemorySetup     := $14; 
  BorderColor     := $00;
  BackgroundColor := $00;
  
  for i:= 0 to 999 do
    vram_Char[i] := Characters[i];
    vram_Color[i] := Colors[i];
  end;
  
  repeat  
  until 1=0; 
end.
