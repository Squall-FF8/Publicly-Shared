////////////////////////////////////////////
// Test Emulator IO Registers
//   created on 10/22/2023
////////////////////////////////////////////
program Emu_Regs;
uses X16, EmuIO, Text;
  
begin
  Print(@#$9A'EMULATOR VERSION: '#$99#0);
  BSOUT(EMUIO_VERSION1);
  BSOUT(EMUIO_VERSION2);

  {$RTS} 
end.
