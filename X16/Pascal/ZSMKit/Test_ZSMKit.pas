////////////////////////////////////////////
// New program created in 10/19/2023}
////////////////////////////////////////////
program Test_ZSMKit;
uses X16, ZSMKit;

const
  ZSM_BANK = 2;  // ZSMKit workspace bank
  ZSM_DATA = 3;  // Song data
  Priority = 0;

var
  ZSM_Code: array[] of char = 'ZSMKIT8C00.BIN';
  ZSM_Song: array[] of char = 'MUSIC.ZSM';
  
begin
  LoadFileInRAM(@ZSM_Code, ZSM_Code.Length, ZSM_BASE);
  LoadFileInBRAM(@ZSM_Song, ZSM_Song.Length, ZSM_DATA);

  zsm_InitEngine(ZSM_BANK);
  zsm_SetISR;
  
  RAM_BANK := ZSM_DATA;
  zsm_SetMem(Priority, RAM_WIN.Low, RAM_WIN.High);
  
  zsm_Play(Priority);
  {$RTS} 
end.
