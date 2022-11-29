////////////////////////////////////////////
// New program created in 11/12/2022}
////////////////////////////////////////////
program NewProgram;
uses x16, VERA, Window;

var
  i, X: byte;

begin
  vControl := 0;  // VERA_DATA1 will be used. DC_SEL= 0

  winPosition(50, 0, 80);
  winInit;
  winClear(Color0);

  winRectangle(1, 1, 190, 126);  
  winRectangle(10, 10, 172, 108);
  
  dSetPos($10, X, 30);
  TestText;
  //_X := 80;
  //_Y := 80;
{  X := 10;
  for i := 16 to 31 do
    dSetPos($10, X, 30);
    winCharOut(32+i);
    X := X + 6;
  end; } 
  //dSetPos($10, 30, 30);
  //winCharOut(34);
  //dSetPos($10, 37, 30);
  //winCharOut(35);

  VERA_DC_VIDEO :=  VERA_DC_VIDEO or (1 << 6);  // Enable Sprites

  {$RTS} 
end.
