{Description of the unit.}
unit Utils;

interface

  // r0: word - Source
  // r1: word - Destination
  // r2: word - Count
  // note: only works for NON-OVERLAPPING memory regions!
  procedure Copy;
  
  // r1: word - Destination
  // r2: word - Count
  procedure FillChar(Value: byte registerA);
  procedure FillChar(Dest: word; Count: byte registerY; Value: byte registerA);
  
  
implementation


procedure Copy;
begin
    asm 
          LDX r2 + 1
          BEQ next
          
          LDY #0
  loop1:  LDA (r0), Y
          STA (r1), Y
          INY
          BNE loop1
          INC r0 + 1
          INC r1 + 1
          DEX
          BNE loop1
          
  next:   LDX r2
          BEQ stop
  loop2:  LDA (r0), Y
          STA (r1), Y
          INY
          DEX
          BNE loop2
  stop:     	 
    end; 
end; 


procedure FillChar(Value: byte registerA);
begin
    asm 
          LDX r2 + 1
          BEQ next
          
          LDY #0
  loop1:  STA (r1), Y
          INY
          BNE loop1
          INC r1 + 1
          DEX
          BNE loop1
          
  next:   LDY r2
          BEQ stop
  loop2:  DEY
          STA (r1), Y
          BNE loop2
  stop:     	 
    end; 
end; 


procedure FillChar(Dest: word; Count: byte registerY; Value: byte registerA);
begin
  
end; 

end.
