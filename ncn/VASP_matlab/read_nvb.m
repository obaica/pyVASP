% Read E-fermi value --------------------------
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file  = fopen(outcar,'rt');

line = 0;

while(1)
    temp  = fgetl(file);
    tline = strfind(temp,'NELECT');
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
nvb = str2double(text{3});
fclose(file);

if SOC=='F'
    nvb = nvb/2;
end

ncb=nbands-nvb;
fprintf('\nnumber of valence bands           NVB = %d',nvb);
fprintf('\nnumber of conduction bands        NCB = %d',ncb);




clear text temp skip file tline line;