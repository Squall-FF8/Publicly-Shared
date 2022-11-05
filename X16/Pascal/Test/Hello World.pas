program Test;
uses X16, VERA;

var
  i: byte;
  str: array[] of char = 'HELLO WORLD';
BEGIN
  for i := 0 to 10 do
    ChrOut(str[i]);
  end;

  {$RTS} 
END.  

