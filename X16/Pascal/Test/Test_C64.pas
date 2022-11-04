program test;
  uses Commodore64;
var
    i,j,k:word;
begin
    k:=0;
    for i:=0 to 2 do
        for j:=0 to 2 do
            k := k + 1;
            k := k + 2;
            k := k + 3;
            k := k + 4;
            k := k + 5;
        end;
    end;
end.
