program Logo;
uses X16, Text;

var
  Logo: array of byte = (
    $9C, $12, $DF, $92, $20, $20, $20, $20, $20, $12, $E9, $92, $0D,
    $9A, $12, $F4, $DF, $92, $20, $20, $20, $12, $E9, $E7, $92, $0D,
    $9F, $12, $A1, $A0, $DF, $92, $20, $12, $E9, $A0, $F6, $92, $0D,
    $1E, $20, $B7, $12, $FB, $92, $20, $12, $EC, $92, $B7, $20, $0D,
    $9E, $20, $EF, $12, $FE, $92, $20, $12, $FC, $92, $EF, $20, $0D,
    $81, $E7, $12, $20, $92, $A9, $92, $20, $DF, $12, $A0, $92, $F4, $0D,
    $1C, $AA, $A9, $20, $20, $20, $DF, $92, $F5, $05, $0D, 0);
  
BEGIN
  Print( @Logo);

  {$RTS} 
END.  

