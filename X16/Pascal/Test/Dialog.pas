////////////////////////////////////////////
// New program created in 11/12/2022}
////////////////////////////////////////////
program NewProgram;
uses x16, VERA, Window;

begin
  vControl := 0;  // VERA_DATA1 will be used. DC_SEL= 0

  winPosition(50, 0, 80);
  winInit;
  winClear(Color0);

  winRectangle(1, 1, 190, 126);  
  winRectangle(10, 10, 172, 108);
  
  //_X := 80;
  //_Y := 80;
  dSetPos($10, 25, 30);
  winCharOut(1);
  dSetPos($10, 30, 30);
  winCharOut(0);
  dSetPos($10, 37, 30);
  winCharOut(2);

  VERA_DC_VIDEO :=  VERA_DC_VIDEO or (1 << 6);  // Enable Sprites

  {$RTS} 
end.
