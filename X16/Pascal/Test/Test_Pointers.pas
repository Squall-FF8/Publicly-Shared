////////////////////////////////////////////
// New program created in 12/9/2022}
////////////////////////////////////////////
program TestPointers;
uses X16, Text;

  procedure Pass;
  begin
    Print(@' PASS'#13#0);
  end; 

  procedure Fail;
  begin
    Print(@' FAIL'#13#0);
  end; 


var
  b: byte;
  w: word;
  pb: ^byte;
  pw: ^word;
  
begin
  b := $10;
  w := $1234;

  pb := word($10);
  Print(@'ASSIGN <256 CONST ADDRESS:'#0);
  if pb = word($10) then Pass; else Fail end;  

  pb := $1012;
  Print(@'ASSIGN >256 CONST ADDRESS:'#0);
  if pb = $1012 then Pass; else Fail end;  

  w := $20;
  pb := w;
  Print(@'ASSIGN <256 WORD VAR ADDRESS:'#0);
  if pb = word($20) then Pass; else Fail end;  

  w := $2030;
  pb := w;
  Print(@'ASSIGN >256 WORD VAR ADDRESS:'#0);
  if pb = word($2030) then Pass; else Fail end;  

  pb := @b;
  Print(@'POINTS TO BYTE VARIABLE:'#0);
  if pb^ = b then Pass; else Fail end;  

  pw := @w;
  Print(@'POINTS TO WORD VARIABLE:'#0);
  if pw^ = w then Pass; else Fail end;  

  pb^ := $10;
  Print(@'ASSIGN A CONST BYTE TO BYTE PTR:'#0);
  if pb^ = $10 then Pass; else Fail end;  

  pb^ := b;
  Print(@'ASSIGN A VAR BYTE TO BYTE PTR:'#0);
  if pb^ = b then Pass; else Fail end;  

  pw^ := word($10);
  Print(@'ASSIGN A CONST BYTE TO WORD PTR:'#0);
  if pw^ = $10 then Pass; else Fail end;  

  pw^ := $1011;
  Print(@'ASSIGN A CONST WORD TO WORD PTR:'#0);
  if pw^ = $1011 then Pass; else Fail end;  

  pw^ := w;
  Print(@'ASSIGN A VAR WORD TO WORD PTR:'#0);
  if pw^ = w then Pass; else Fail end;  

  pb := $1000;
  pb := pb + $345;
  Print(@'ADDITION WITH A CONST:'#0);
  if pb = $1345 then Pass; else Fail end;  

  pb := $1000;
  pb := pb + b;
  Print(@'ADDITION WITH A VAR:'#0);
  if pb = $1010 then Pass; else Fail end;  

  //pb := $1345;
  //pb := pb - $345;
  //Print(@'SUBSTRACTION WITH A CONST:'#0);
  //if pb = $1000 then Pass; else Fail end;  

  //pb := $1010;
  //pb := pb - b;
  //Print(@'SUBSTRACTION WITH A VAR:'#0);
  //if pb = $1010 then Pass; else Fail end;
  
  //pb := $1234;
  //Print(@'SUBSTRACTION WITH A CONST:'#0);
  //if pb <= $1234 then Pass; else Fail end;  
    
  pb := $FF0;
  pb += $10;
  Print(@'+= WITH A CONST:'#0);
  if pb = $1000 then Pass; else Fail end;  

  pb := $FF0;
  pb += b;
  Print(@'+= WITH A VARIABLE:'#0);
  if pb = $1000 then Pass; else Fail end;  

  {$RTS} 
end.
