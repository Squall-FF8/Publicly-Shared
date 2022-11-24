program Test;
uses X16, Text;

BEGIN
  Print(@#$9A'HELLO '#$99'WORLD'#0);

  {$RTS} 
END.  

