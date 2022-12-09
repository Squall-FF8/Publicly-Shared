program Test;
uses Commodore64;
//uses x16;

var
  a: byte;
  w, w1: word;
  p: ^byte;
  q: ^word {= $1011};
  q1: pointer;
  q2: pointer;
begin
  p^ := 0;
  q := @w;
  w1 := $5678;
  q^ := w1 + 3;
  //q^ := w1;
{  for a := 1 to 10 do
  end;
  q1 :=  q2;
  a :=  ord('H');
  p := @a + 2;
  p := $1011;
  p^ := a;
  q := p;}
  //q^ := $2021;
  //ChrOUT(chr(a));
  asm RTS end 
end.
