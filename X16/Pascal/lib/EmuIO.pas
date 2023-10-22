{ =============================
   Emulator I/O Registers (.r45)
   created on 10/22/2023
   https://github.com/X16Community/x16-emulator/tree/r45#emulator-io-registers
  ==============================}
unit EmuIO;
  
interface

var
  EMUIO_ENABLE_DEBUG  : byte absolute $9FB0;  // 0:disable, 1:enable 
  EMUIO_LOG_VIDEO     : byte absolute $9FB1;  // 0:disable, 1:enable
  EMUIO_LOG_KEYBOARD  : byte absolute $9FB2;  // 0:disable, 1:enable
  EMUIO_ECHO_MODE     : byte absolute $9FB3;  // 0:disable, 1:enanle raw, 2:enable cooked, 3:Enable ISO
  EMUIO_SAVE_ON_EXIT  : byte absolute $9FB4;  // 0:disable, 1:enanle
  EMUIO_GIF_CONTROL   : byte absolute $9FB5;  // 0:pause, 1:capture frame, 2:activate/resume
  EMUIO_WAV_CONTROL   : byte absolute $9FB6;  // 0:pause, 1:enable, 2:autostart
  EMUIO_COMMAND_KEY   : byte absolute $9FB7;  // 0:allow, 1not allow

    // READ ONLY!
  EMUIO_CPU_COUNTER1  : byte absolute $9FB8;  // CPU Clock Counter bits 0..7
  EMUIO_CPU_COUNTER2  : byte absolute $9FB9;  // CPU Clock Counter bits 8..15
  EMUIO_CPU_COUNTER3  : byte absolute $9FBA;  // CPU Clock Counter bits 16..23
  EMUIO_CPU_COUNTER4  : byte absolute $9FBB;  // CPU Clock Counter bits 24..31

    // WRITE ONLY!
  EMUIO_RESET_COUNTER : byte absolute $9FB8;  // Resets the cpu clock counter to 0
  EMUIO_OUTPUT_HEX1   : byte absolute $9FB9;  // Outputs "User debug 1: $xx"
  EMUIO_OUTPUT_HEX2   : byte absolute $9FBA;  // Outputs "User debug 2: $xx"
  EMUIO_OUTPUT_CHAR   : byte absolute $9FBB;  // Outputs the character to the console.

  EMUIO_KEYMAP        : byte absolute $9FBD;  // Returns the keymap index
  EMUIO_VERSION1      : byte absolute $9FBE;  // If we run on emulator, returns $31 ("1")
  EMUIO_VERSION2      : byte absolute $9FBF;  // If we run on emulator, returns $36 ("6")

implementation


end. 
