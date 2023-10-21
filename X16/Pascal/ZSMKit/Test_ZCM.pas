////////////////////////////////////////////
// New program created in 10/19/2023}
////////////////////////////////////////////
program Test_ZCM;
uses X16, ZSMKit;

const
  ZSM_BANK = 2;  // ZSMKit workspace bank
  ZSM_DATA = 3;  // Song data
  Slot = 0;
  Volume = 10;

var
  ZSM_Code: array[] of char = 'ZSMKIT8C00.BIN';
  ZCM_Song: array[] of char = 'TEST.ZCM';
  
begin
  LoadFileInRAM(@ZSM_Code, ZSM_Code.Length, ZSM_BASE);
  LoadFileInBRAM(@ZCM_Song, ZCM_Song.Length, ZSM_DATA);

  zsm_InitEngine(ZSM_BANK);
  zsm_SetISR;
  
  RAM_BANK := ZSM_DATA;
  zcm_SetMem(Slot, RAM_WIN.Low, RAM_WIN.High);
  
  zcm_Play(Slot, Volume);
  {$RTS} 
end.
