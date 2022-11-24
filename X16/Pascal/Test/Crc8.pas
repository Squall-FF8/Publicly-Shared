////////////////////////////////////////////
// New program created in 11/23/2022}
////////////////////////////////////////////
program CRC8;
uses X16, Text;

var
  crc: byte;

  procedure Crc8(Data, Length: word);
  begin
    crc := 0;
    crc := $a2;
  end; 

begin
  Print(@'CALCULATING...'#0);
  SetTim(0,0,0);
  crc8($E000, $2000);
  Print_Hex8(crc);
  NewLine;
  //RDTIM;
  //Print_Hex24;
  Print_Timer;
  Print(@' JIFFIES'#0);
    
  {$RTS} 
end.
