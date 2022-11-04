////////////////////////////////////////////
// New program created in 06.06.20}
////////////////////////////////////////////
unit IRQ;

interface

const
  VSYNC = $01;
  
var
  IRQ        : word absolute $314;
  IRQ_Flag   : byte absolute $30;
  IRQ_Kernel : word;
  
  procedure InitIRQ(Flags: byte registerA);  
  procedure RestoreIRQ;  
 
  
implementation

  
procedure IRQ_Handler;
begin
  asm
    LDA #VSYNC
    STA vIRQ
    STA IRQ_Flag 
    JMP (IRQ_Kernel)
    ;RTI	 
  end 
end;

  
procedure InitIRQ(Flags: byte registerA);
begin
  {$SEI}
  vIrqCtrl   := Flags; 
  IRQ_Flag   := 0;
  IRQ_Kernel := IRQ;
  IRQ        := addr(IRQ_Handler);
  {$CLI} 
end;  

procedure RestoreIRQ;
begin
  IRQ := IRQ_Kernel;
end;

  
end.
