program Test;
uses X16, VERA, Utils, Text;

var
  b: byte;
  w, w1, w2: word;
  d, d1: dword;
  
  procedure PrintD;
  begin
    NewLine;
    Print_Hex32((@d).High, (@d).Low);
  end;
   
begin
  w := $1122;
  //d := $11223344;
  d := $100;
  d1 := 0;
  //PrintD;
  //d1 := d;
  d := d + w;
  PrintD;
  d := d1 + $44332211;
  PrintD;
  d := d + d1;
  PrintD;

  //w := 8191;
  //w2 := 8187;
  //w1 := w mod w2; 
  //w1 := w mod word(8188);
  //HexToDec65535(w1);
  //HexToDec65535(w mod word(8188));
  //HexToDec65535(word(12345));
  //Print_Dec8z(123);
{  w := 32768;
  w1 := w div word(8192);
  w2 := 32768 div w1;
  Print_Dec16z(32768 div w1);
}  
  {$RTS} 
END.  
