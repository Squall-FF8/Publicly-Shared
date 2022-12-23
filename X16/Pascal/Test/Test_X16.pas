program Test;
uses X16, VERA, Utils, Text;

var
  w, w1, w2: word;
begin
  w := 8191;
  //w2 := 8187;
  //w1 := w mod w2; 
  //w1 := w mod word(8188);
  //HexToDec65535(w1);
  HexToDec65535(w mod word(8188));
  //HexToDec65535(word(12345));
  //Print_Dec8z(123);
{  w := 32768;
  w1 := w div word(8192);
  w2 := 32768 div w1;
  Print_Dec16z(32768 div w1);
}  
  {$RTS} 
END.  
