////////////////////////////////////////////
// New program created in 11/12/2022}
////////////////////////////////////////////
program NewProgram;
uses x16, VERA, Window;

var
  i, X, c: byte;
  Colors: array of byte = ($04, $0E, $03, $05, $07, $08);
  Letter: array of char = 'COLORS';

begin
  vControl := 0;  // VERA_DATA1 will be used. DC_SEL= 0

  winPosition(50, 0, 80);
  winInit;
  winClear(Color0);

  winRectangle(1, 1, 190, 126);  
  winRectangle(4, 4, 184, 120);

  dSetPos($10, 44, 10);
  winPrint(@'3rd LAYER FOR X16 +'#0);
  dSetPos($10, 16, 28);
  winPrint(@'Variable Width Font!  by Squall'#0);
  dSetPos($10, 16, 52);
  winPrint(@'- custom char Width'#0);
  dSetPos($10, 16, 64);
  winPrint(@'- custom font Height (12px)'#0);
  dSetPos($10, 16, 76);
  winPrint(@'- uses 2 bpp encoding'#0);
  dSetPos($10, 16, 88);
  winPrint(@'- many '#0);
  dSetPos($10, 25, 106);
  winPrint(@'*special:   '#127' Silver Helmet'#0);
  
  X := 60;
  for i := 0 to 5 do
    c := Colors[i];
    winSetColor(c, 3);
    dSetPos($10, X, 89);
    winCharOut(ord(Letter[i]));
    X := X + 10;
  end;

  VERA_DC_VIDEO :=  VERA_DC_VIDEO or (1 << 6);  // Enable Sprites

  {$RTS} 
end.
