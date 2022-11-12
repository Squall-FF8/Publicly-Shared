program Test;
uses X16, VERA, Utils;

var
  i: byte;
  str: array[] of char = 'HELLO WORLD';
  
BEGIN
  for i := 0 to 10 do
    ChrOut(str[i]);
  end;
  
  r0 := $1000;
  r1 := $2000;
  Copy($40);
  
  r1 := $2000;
  r2 := $300;
  FillChar(10);
  
  FillChar($2000, 20, 10);

  r0 := $1000;
  r1 := $2000;
  r2 := $300;
  Copy;


  {$RTS} 
END.  

