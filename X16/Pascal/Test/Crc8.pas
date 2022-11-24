////////////////////////////////////////////
// New program created in 11/23/2022}
////////////////////////////////////////////
program CRC8;
uses X16, Text;

var
  crc: byte;

  {procedure Crc8(Data, Length: pointer);
  begin
    crc := 0;
    crc := $a2;
  end;}
   
  procedure Crc8(Data, Length: pointer);
  begin
    asm
          STZ crc
 loop1:   LDA crc
          EOR (Data)
          STA crc
          LDX #8
 loop2:   ASL
          BCC skip
          EOR #$1D
 skip:    STA crc
          DEX
          BNE loop2
          
          INC Data
          BNE skip2
          INC Data + 1
 
  skip2:  LDA Length
          BNE skip3
          DEC Length +1
          BMI finish
 skip3:   DEC Length
          BRA loop1
 finish:              
    end;
  end; 

begin
  Print(@'CALCULATING...'#0);
  SetTim(0,0,0);
  //crc8($E000, $2000);
  crc8($E000, $1FFF);  // the procedure does Length + 1 loops
  Print_Hex8(crc);
  NewLine;
  //RDTIM;
  //Print_Hex24;
  Print_Timer;
  Print(@' JIFFIES'#0);
    
  {$RTS} 
end.
