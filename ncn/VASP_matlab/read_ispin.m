% Read ISPIN --------------------------
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file  = fopen(outcar,'rt');
tline = 0;
line  = 0;
while(1)
    temp  = fgetl(file);
    tline = strfind(temp,'ISPIN');
    line  = line+1;
    if (tline~=0)
        break;
    end
end
fclose(file);

if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
for i=1:line-1
    fgetl(file);
end

temp  = fgetl(file);
for i=1:10
    [text{i},temp] = strtok(temp);
end
ispin = str2double(text{3});
fclose(file);

if ispin == 1 
    fprintf('\nSpin-Polarized calculations     ISPIN = F');
else
    fprintf('\nSpin-Polarized calculations     ISPIN = T');
end

clear text temp skip file tline line;