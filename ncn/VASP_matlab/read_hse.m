% Read HSE calculation --------------------------
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
tline = 0;
line  = 0;
while(1)
    temp  = fgetl(file);
    tline = strfind(temp,'LHFCALC');
    line  = line+1;
    if (tline~=0)
        break;
    end
end
fclose(file);

file   = fopen(outcar,'rt');
for i=1:line-1
    fgetl(file);
end

temp  = fgetl(file);
for i=1:10
    [text{i},temp] = strtok(temp);
end
hse = text{3};
fprintf('\nHybrid functional calculations        = %s',hse);
fclose(file);

clear text temp skip file line tline;