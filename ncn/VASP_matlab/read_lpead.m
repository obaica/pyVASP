% Read LPEAD value --------------------------
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
    tline = strfind(temp,'LPEAD');
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
lpead = text{2};
fclose(file);


fprintf('\nLinear Sternheimer Equation     LPEAD = %s',lpead);



clear text temp file line tline;