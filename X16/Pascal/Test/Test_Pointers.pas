////////////////////////////////////////////
// New program created in 12/9/2022}
////////////////////////////////////////////
program TestPointers;
uses X16, Text;
{$STRING NULL_TERMINATED}

  procedure Pass;
  begin
    Print(@' '#$1E'PASS'#05#13);
  end; 

  procedure Fail;
  begin
    Print(@' '#$1C'FAIL'#05#13);
  end; 


var
  b: byte;
  w: word;
  pb, pb1: ^byte;
  pw, pw1: ^word;
  p, q: pointer;
  
begin
  b := $10;
  w := $1234;

  pb := word($10);
  Print(@'ASSIGN <256 CONST ADDRESS:');
  if pb = word($10) then Pass; else Fail end;  

  pb := $1012;
  Print(@'ASSIGN >256 CONST ADDRESS:');
  if pb = $1012 then Pass; else Fail end;  

  w := $20;
  pb := w;
  Print(@'ASSIGN <256 WORD VAR ADDRESS:');
  if pb = word($20) then Pass; else Fail end;  

  w := $2030;
  pb := w;
  Print(@'ASSIGN >256 WORD VAR ADDRESS:');
  if pb = word($2030) then Pass; else Fail end;  

  pb := @b;
  Print(@'POINTS TO BYTE VARIABLE:');
  if pb^ = b then Pass; else Fail end;  

  pw := @w;
  Print(@'POINTS TO WORD VARIABLE:');
  if pw^ = w then Pass; else Fail end;  

  pb^ := $10;
  Print(@'ASSIGN A CONST BYTE TO BYTE PTR:');
  if pb^ = $10 then Pass; else Fail end;  

  pb^ := b;
  Print(@'ASSIGN A VAR BYTE TO BYTE PTR:');
  if pb^ = b then Pass; else Fail end;  

  pw^ := word($10);
  Print(@'ASSIGN A CONST BYTE TO WORD PTR:');
  if pw^ = $10 then Pass; else Fail end;  

  pw^ := $1011;
  Print(@'ASSIGN A CONST WORD TO WORD PTR:');
  if pw^ = $1011 then Pass; else Fail end;  

  pw^ := w;
  Print(@'ASSIGN A VAR WORD TO WORD PTR:');
  if pw^ = w then Pass; else Fail end;  

  pb := $1000;
  pb := pb + $345;
  Print(@'ADDITION WITH A CONST:');
  if pb = $1345 then Pass; else Fail end;  

  pb := $1000;
  pb := pb + b;
  Print(@'ADDITION WITH A VAR:');
  if pb = $1010 then Pass; else Fail end;  

  pb := $1345;
  pb := pb - $345;
  Print(@'SUBSTRACTION WITH A CONST:');
  if pb = $1000 then Pass; else Fail end;  

  pb := $1010;
  pb := pb - b;
  Print(@'SUBSTRACTION WITH A VAR:');
  if pb = $1000 then Pass; else Fail end;
  
  pb := $1234; pb1 := $2000;
  Print(@'COMPARE BYTE PTR:');
  if pb <= pb1 then Pass; else Fail end;  
    
  pw := $1234; pw1 := $2000;
  Print(@'COMPARE WORD PTR:');
  if pw <= pw1 then Pass; else Fail end;

  p := $1234; q := $2000;
  Print(@'COMPARE WORD PTR:');
  if p <= q then Pass; else Fail end;
    
  pb := $FF0;
  pb += $10;
  Print(@'+= WITH A CONST:');
  if pb = $1000 then Pass; else Fail end;  

  pb := $FF0;
  pb += b;
  Print(@'+= WITH A VARIABLE:');
  if pb = $1000 then Pass; else Fail end;  

  {$RTS} 
end.
