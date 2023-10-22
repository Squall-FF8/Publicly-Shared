////////////////////////////////////////////
// Test Emulator IO Registers
//   created on 10/22/2023
////////////////////////////////////////////
program Emu_Regs;
uses X16, EmuIO, Text;

var
  d: dword;
  
begin
  Print(@#$9A' -= EMULATOR IO REGISTERS TEST =-'#$8D#$8D#0);

  Print(@#$9A'RUNS ON EMULATOR: '#$99#0);
  Print_Hex8(IsEmulator);
  NewLine;

  Print(@#$9A'EMULATOR VERSION: '#$99#0);
  BSOUT(EMUIO_VERSION1);
  BSOUT(EMUIO_VERSION2);
  NewLine;

  Print(@#$9A'DEBUGER ENABLED:  '#$99#0);
  Print_Hex8(EMUIO_ENABLE_DEBUG);
  NewLine;

  Print(@#$9A'VIDEO LOGGING:    '#$99#0);
  Print_Hex8(EMUIO_LOG_VIDEO);
  NewLine;

  Print(@#$9A'KEYBOARD LOGGING: '#$99#0);
  Print_Hex8(EMUIO_LOG_KEYBOARD);
  NewLine;

  Print(@#$9A'ECHO MODE:        '#$99#0);
  Print_Hex8(EMUIO_ECHO_MODE);
  NewLine;

  Print(@#$9A'GIF CONTROL:      '#$99#0);
  Print_Hex8(EMUIO_GIF_CONTROL);
  NewLine;

  Print(@#$9A'WAV CONTROL:      '#$99#0);
  Print_Hex8(EMUIO_WAV_CONTROL);
  NewLine;

  Print(@#$9A'CPU COUNTER:      '#$99#0);
  EMUIO_RESET_COUNTER := 0;
  EMU_GetCounter(@d);
  Print_Hex32( (@d).High, (@d).Low);
  NewLine;

  Print(@#$9A'KEYMAP INDEX:     '#$99#0);
  Print_Hex8(EMUIO_KEYMAP);
  NewLine;
  
  Print(@#$9A'PRINT TO CONSOLE: '#$99'...'#$8D#$8D#0);
  EMU_Print(@'Hello Worlld'#0);

  Print(@#$96'  *ALL VALUES ARE IN HEX     '#$05#0);

  {$RTS} 
end.
