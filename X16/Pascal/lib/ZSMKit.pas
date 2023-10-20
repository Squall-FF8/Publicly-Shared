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
  
{ INPUT: A = designated RAM bank to use for ZSMKit engine state
  Initializes the memory locations used by ZSMKit's engine and calls
  audio_init using the X16's AUDIO API to reset its state..
  Needs to be called once before any other ZSMKit function. }  
  procedure zsm_InitEngine(Bank: byte registerA);
  
{ INPUT: X = priority
  Sets up the song to start playing back on the next tick if
  the song is valid and ready to play }  
  procedure zsm_Play(Priority: byte registerX);
  
{ INPUT:  X = priority
          A/Y = data pointer,
          $00 = ram bank (bdefore calling the routine!)
  Sets the start of memory for the priority, reads it,
  and parses the header
  Must only be called from main loop routines. }  
  procedure zsm_SetMem(Priority: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
  

{ Sets up a default ISR handler and injects it before the existing ISR }  
  procedure zsm_SetISR;

  
implementation


procedure zsm_InitEngine(Bank: byte registerA);  
begin
  asm 
    JSR __zsm_init_engine
  end 
end; 

procedure zsm_SetISR;  
begin
  asm 
    JSR __zsmkit_setisr
  end 
end; 

procedure zsm_SetMem(Priority: byte registerX; DataLo: byte registerA; DataHi: byte registerY); 
begin
  asm 
    JSR __zsm_setmem
  end 
end; 

procedure zsm_Play(Priority: byte registerX);
begin
  asm 
    JSR __zsm_play
  end 
end; 


  
end.
