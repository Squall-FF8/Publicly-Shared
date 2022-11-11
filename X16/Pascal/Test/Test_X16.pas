program Test;
uses X16, VERA, Utils;

var
  i: byte;
  str: array[] of char = 'HELLO WORLD';
  
  
  procedure Copy1(Src, Dst, Count: word);
  begin
    asm 
          LDX Count + 1
          BEQ next
          
          LDY #0
  loop1:  LDA Src, Y
          STA Dst, Y
          INY
          BNE loop1
          INC Src + 1
          INC Dst + 1
          DEX
          BNE loop1
          
  next:   LDX Count
          BEQ stop
  loop2:  LDA Src, X
          STA Dst, X
          DEX
          BNE loop2
  stop:     	 
    end; 
  end; 
  
BEGIN
  for i := 0 to 10 do
    ChrOut(str[i]);
  end;
  
  r1 := $2000;
  r2 := $300;
  FillChar(10);
  FillChar($2000, 20, 10);

  r0 := $1000;
  r1 := $2000;
  r2 := $300;
  Copy;

  Copy1($1000, $2000, $300);

  {$RTS} 
END.  

