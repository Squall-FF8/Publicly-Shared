////////////////////////////////////////////
// New program created in 10/20/2023}
////////////////////////////////////////////
unit ZSMKit;
  
interface

const
  ZSM_BASE = $8C00;  // Initial address for the BLOB

  __zsm_init_engine   = ZSM_BASE + $00;
  __zsm_tick          = ZSM_BASE + $03;
  __zsm_play          = ZSM_BASE + $06;
  __zsm_stop          = ZSM_BASE + $09;
  __zsm_rewind        = ZSM_BASE + $0C;
  __zsm_close         = ZSM_BASE + $0F;
  __zsm_fill_buffers  = ZSM_BASE + $12;
  __zsm_setlfs        = ZSM_BASE + $15;
  __zsm_setfile       = ZSM_BASE + $18;
  __zsm_loadpcm       = ZSM_BASE + $1B;
  __zsm_setmem        = ZSM_BASE + $1E;
  __zsm_setatten      = ZSM_BASE + $21;
  __zsm_setcb         = ZSM_BASE + $24;
  __zsm_clearcb       = ZSM_BASE + $27;
  __zsm_getstate      = ZSM_BASE + $2A;
  __zsm_setrate       = ZSM_BASE + $2D;
  __zsm_getrate       = ZSM_BASE + $30;
  __zsm_setloop       = ZSM_BASE + $33;
  __zsm_opmatten      = ZSM_BASE + $36;
  __zsm_psgatten      = ZSM_BASE + $39;
  __zsm_pcmatten      = ZSM_BASE + $3C;
  __zsm_set_int_rate  = ZSM_BASE + $3F;

  __zcm_setmem        = ZSM_BASE + $4B;
  __zcm_play          = ZSM_BASE + $4E;
  __zcm_stop          = ZSM_BASE + $51;
  __zsmkit_setisr     = ZSM_BASE + $54;
  __zsmkit_clearisr   = ZSM_BASE + $57;

  
{ INPUT:  A = designated RAM bank to use for ZSMKit engine state
  Initializes the memory locations used by ZSMKit's engine and calls
  audio_init using the X16's AUDIO API to reset its state..
  Needs to be called once before any other ZSMKit function. }  
  procedure zsm_InitEngine(Bank: byte registerA);
  
{ INPUT:  A = 0 advance music data and PCM
          A = 1 advance PCM only
          A = 2 advance music data only
  advances songs and plays the notes}  
  procedure zsm_Tick(Flag: byte registerA);
  
{ INPUT:  X = Slot
  Sets up the song to start playing back on the next tick if
  the song is valid and ready to play }  
  procedure zsm_Play(Slot: byte registerX);
  
{ INPUT:  X = Slot
  Pauses playback of a song. Playback can optionally be resumed from that point later with zsm_play. }  
  procedure zsm_Stop(Slot: byte registerX);

{ INPUT:  X = Slot
  Stops playback of a song (if it is already playing) and resets its pointer to the beginning of the song.
  Playback can then be started again with zsm_play.}  
  procedure zsm_Rewind(Slot: byte registerX);
  
{ INPUT:  X = Slot
  Stop and closes streaming songs, sets slot to unused/not playable.}  
  procedure zsm_Close(Slot: byte registerX);

{ If the slot has a song being streamed from a file, top the buffer off if appropriate.
  Must be called from the main loop since it deals with file I/O}  
  procedure zsm_FillBuffers;

{ INPUT:  X = Slot (0..3)
          A = LFN/SA logical file number/secondary address
          Y = IEC device
  Sets the logical file number, secondary address, and IEC device for a particular slot }
  procedure zsm_SetLfs(Slot: byte registerX; LFN: byte registerA; Device: byte registerY);
  
{ INPUT:  X = Slot (0..3)
          A/Y = pointer (lo hi) in low RAM to null-terminated filename
  This is an alternate song-loading method. It sets up a slot to stream a ZSM file from disk (SD card). 
  Sets the filename for the slot, opens it, and parses the header.
  Must only be called from main loop routines. }  
  procedure zsm_SetFile(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 

{ INPUT:  X = Slot (0..3)
          A/Y = load address (lo hi)
          $00 = RAM bank (bdefore calling the routine!)
  OUTPUT: A/Y = next memory location after end of load, 
          $00 = RAM bank
  For streamed ZSM files that have PCM data, this routine can be used to load the PCM data into memory at the specified memory location.
  Sets the start of memory for the slot, reads it, and parses the header.
  Must only be called from main loop routines. }  
  procedure zsm_LoadPCM(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
  
{ INPUT:  X = Slot (0..3)
          A/Y = data pointer (lo hi)
          $00 = ram bank (bdefore calling the routine!)
  Sets the start of memory for the slot, reads it, and parses the header
  Must only be called from main loop routines. }  
  procedure zsm_SetMem(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 

{ INPUT:  X = Slot
          A = Attenuation value $00: full volume .. $3F: full mute.
  Changes the master volume of a priority slot by setting an attenuation value. }  
  procedure zsm_SetAtten(Slot: byte registerX; Atten: byte registerA);

{ INPUT:  X = Slot (0..3)
          A/Y = pointer to callback (lo hi)
          $00 = ram bank (bdefore calling the routine!)
  Sets up a callback address. The callback is triggered whenever a song loops 
  or ends on its own, or a synchronization message is processed in the ZSM data. }  
  procedure zsm_SetCallback(Slot: byte registerX; AddressLo: byte registerA; AddressHi: byte registerY); 

{ INPUT:  X = Slot (0..3)
  Clears the callback assigned to the slot. }  
  procedure zsm_ClearCallback(Slot: byte registerX); 

{ INPUT:  X = Slot (0..3)
  OUTPUT: C = Is playing 1:Yes, 0:No
          Z = Is available 1: No, 0: Yes
          A/Y = Loop counter (lo hi) - the number of times the song has looped. 
  Returns the playback state of a priority slot. }  
  procedure zsm_GetState(Slot: byte registerX);

{ INPUT:  X = Slot (0..3)
          A/Y = tick rate (lo hi)
  Sets the current tick rate of the song. }  
  procedure zsm_SetRate(Slot: byte registerX; RateLo: byte registerA; RateHi: byte registerY); 

{ INPUT:  X = Slot (0..3)
  OUTPUT: A/Y = tick rate (lo hi)  !!! THIS NEED PASCAL RETURN!!!
  Returns the current tick rate of the song. }  
  procedure zsm_GetRate(Slot: byte registerX); 

{ INPUT:  X = Slot (0..3)
          C = whether to loop 1:Yes, 0:No
  If carry is set, enable the looping behaivor. If carry is clear, disable looping. }  
  procedure zsm_SetLoop(Slot: byte registerX); 

{ INPUT:  X = Slot (0..3)
          Y = channel (YM)
          A = Attenuation value $00:full volume .. $3F:full mute.
  Changes the volume of an individual OPM channel for a priority slot by setting an attenuation value. }  
  procedure zsm_OpmAtten(Slot: byte registerX; Channel: byte registerY; Atten: byte registerA); 

{ INPUT:  X = Slot (0..3)
          Y = channel (PSG)
          A = Attenuation value $00:full volume .. $3F:full mute.
  Changes the volume of an individual PSG channel for a priority slot by setting an attenuation value. }  
  procedure zsm_PsgAtten(Slot: byte registerX; Channel: byte registerY; Atten: byte registerA); 

{ INPUT:  X = Slot (0..3)
          A = Attenuation value $00:full volume .. $3F:full mute.
  Changes the volume of PCM by setting an attenuation value. }  
  procedure zsm_PcmAtten(Slot: byte registerX; Atten: byte registerA); 

{ INPUT:  A = new rate (integer portion in Hz)
          Y = new rate (fractional portion in 1/256th Hz)
  Sets a new global interrupt rate in Hz. }  
  procedure zsm_SetInterruptRate(RateLo: byte registerA; RateHi: byte registerY); 


{ INPUT:  X = Slot (0 .. 31)
          A/Y = data pointer (lo hi)
          $00 = ram bank (bdefore calling the routine!)
  Sets the start of memory for a digital sample (ZCM format) }  
  procedure zcm_SetMem(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 

{ INPUT:  X = Slot (0 .. 31)
          A = Volume (1 .. 15)
  Begins playback of a ZCM digital sample }  
  procedure zcm_Play(Slot: byte registerX; Volume: byte registerA);

{ Stops playback of a ZCM if one is playing
  Does not stop the PCM channel if a ZSM's PCM event is playing }
  procedure zcm_Stop;


{ Sets up a default ISR handler and injects it before the existing ISR }  
  procedure zsm_SetISR;

{ Clears the default ISR handler if it exists and restores the previous one }  
  procedure zsm_ClearISR;

  
implementation


procedure zsm_InitEngine(Bank: byte registerA);  
begin
  asm 
    JSR __zsm_init_engine
  end 
end; 

procedure zsm_Tick(Flag: byte registerA);
begin
  asm 
    JSR __zsm_tick
  end 
end; 

procedure zsm_Play(Slot: byte registerX);
begin
  asm 
    JSR __zsm_play
  end 
end; 

procedure zsm_Stop(Slot: byte registerX);
begin
  asm 
    JSR __zsm_stop
  end 
end; 

procedure zsm_Rewind(Slot: byte registerX);
begin
  asm 
    JSR __zsm_rewind
  end 
end; 

procedure zsm_Close(Slot: byte registerX);
begin
  asm 
    JSR __zsm_close
  end 
end;

procedure zsm_FillBuffers; 
begin
  asm 
    JSR __zsm_fill_buffers
  end 
end;

procedure zsm_SetLfs(Slot: byte registerX; LFN: byte registerA; Device: byte registerY);
begin
  asm 
    JSR __zsm_setlfs
  end 
end;

procedure zsm_SetFile(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
begin
  asm 
    JSR __zsm_setfile
  end 
end;

procedure zsm_LoadPCM(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
begin
  asm 
    JSR __zsm_loadpcm
  end 
end;

procedure zsm_SetMem(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
begin
  asm 
    JSR __zsm_setmem
  end 
end; 

procedure zsm_SetAtten(Slot: byte registerX; Atten: byte registerA);
begin
  asm 
    JSR __zsm_setatten
  end 
end; 

procedure zsm_SetCallback(Slot: byte registerX; AddressLo: byte registerA; AddressHi: byte registerY); 
begin
  asm 
    JSR __zsm_setcb
  end 
end;

procedure zsm_ClearCallback(Slot: byte registerX); 
begin
  asm 
    JSR __zsm_clearcb
  end 
end;

procedure zsm_GetState(Slot: byte registerX);
begin
  asm 
    JSR __zsm_getstate
  end 
end;

procedure zsm_SetRate(Slot: byte registerX; RateLo: byte registerA; RateHi: byte registerY); 
begin
  asm 
    JSR __zsm_setrate
  end 
end;

procedure zsm_GetRate(Slot: byte registerX); 
begin
  asm 
    JSR __zsm_getrate
  end 
end;

procedure zsm_SetLoop(Slot: byte registerX); 
begin
  asm 
    JSR   __zsm_setloop
  end 
end;

procedure zsm_OpmAtten(Slot: byte registerX; Channel: byte registerY; Atten: byte registerA); 
begin
  asm 
    JSR   __zsm_opmatten
  end 
end;

procedure zsm_PsgAtten(Slot: byte registerX; Channel: byte registerY; Atten: byte registerA); 
begin
  asm 
    JSR   __zsm_psgatten
  end 
end;

procedure zsm_PcmAtten(Slot: byte registerX; Atten: byte registerA); 
begin
  asm 
    JSR   __zsm_pcmatten
  end 
end;

procedure zsm_SetInterruptRate(RateLo: byte registerA; RateHi: byte registerY); 
begin
  asm 
    JSR   __zsm_set_int_rate
  end 
end;



procedure zcm_SetMem(Slot: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
begin
  asm 
    JSR __zcm_setmem
  end 
end; 

procedure zcm_Play(Slot: byte registerX; Volume: byte registerA);
begin
  asm 
    JSR __zcm_play
  end 
end; 

procedure zcm_Stop;
begin
  asm 
    JSR __zcm_stop
  end 
end; 
  


procedure zsm_SetISR;  
begin
  asm 
    JSR __zsmkit_setisr
  end 
end; 

procedure zsm_ClearISR;
begin
  asm 
    JSR __zsmkit_clearisr
  end 
end; 

end.
