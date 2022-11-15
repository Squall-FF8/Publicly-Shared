{Description of the unit.}
unit Utils;

interface

  // r0: word - Source
  // r1: word - Destination
  // r2: word - Count
  // note: only works for NON-OVERLAPPING memory regions!
  procedure Copy;
  // Source      - r0: word 
  // Destination - r1: word
  // note: shhorter and much faster verion. Only for Count <256!
  procedure Copy(Count: byte registerY);
  
  // r1: word - Destination
  // r2: word - Count
  procedure FillChar(Value: byte registerA);
  procedure FillChar(Dest: word; Count: byte registerY; Value: byte registerA);
  
  
implementation


procedure Copy;
begin
    asm 
          LDY #0
          LDX r2 + 1
          BEQ next
          
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


procedure Copy(Count: byte registerY);
begin
    asm
          CPY #0
          BEQ stop
          DEY
  loop:   LDA (r0), Y
          STA (r1), Y
          DEY
          BNE loop
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
    asm 
          CPY #0
          BEQ stop
  loop:   DEY
          STA (r1), Y
          BNE loop
  stop:     	 
    end; 
end; 


end.
