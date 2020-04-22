% Read NBANDS value --------------------------
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
    tline = strfind(temp,'NBANDS');
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
for i=1:20
    [text{i},temp] = strtok(temp);
end
nkpts = str2double(text{4});
nbands = str2double(text{15});

fclose(file);

fprintf('\nnumber of k-points              NKPTS = %d',nkpts);
fprintf('\nnumber of bands                NBANDS = %d',nbands);

clear text temp file line tline;