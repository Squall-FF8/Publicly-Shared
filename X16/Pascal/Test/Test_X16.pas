program Test;
uses X16, VERA, Utils;

var
  a: byte;
  w: word;
  p: ^byte;
  q: ^byte {= $1011};
  q1: pointer;
  q2: pointer;
begin
  for a := 1 to 10 do
  end;
  q1 :=  q2;
  a :=  ord('H');
  p := @a + 2;
  p := $1011;
  p^ := a;
  p^ := 10;
  //q := p;
  //q^ := $2021;
  //ChrOUT(chr(a));


  {$RTS} 
END.  
