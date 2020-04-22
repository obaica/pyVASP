% Read E-fermi value --------------------------
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
tline = 0;
line_temp = 0;
line  = 0;
while ~feof(file)
    temp  = fgetl(file);
    tline = strfind(temp,'E-fermi');
    if (tline~=0)
       line = line_temp;
    end
    line_temp = line_temp+1;
end
fclose(file);

if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end
temp  = fgetl(file);
for i=1:10
    [text{i},temp] = strtok(temp);
end
efermi = str2double(text{3});
fprintf('\nFermi energy (eV)              EFERMI = %f',efermi);


fclose(file);
clear text tline temp file;