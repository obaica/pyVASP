% Read KPOINTS --------------------------
if ispc
    kpt = [vasp,'\KPOINTS'];
else
    kpt = [vasp,'/KPOINTS'];
end
file   = fopen(kpt,'rt');

for i=1:3
    fgetl(file);
end

skip  = 1;
nskip = 0;

while skip>0
    temp  = fgetl(file);
    for i=1:10
        [text{i},temp] = strtok(temp);
    end
    skip = str2double(text{4});
    nskip = nskip+1;
end
nskip = nskip-1;

fclose(file);
clear text temp skip file kpt;