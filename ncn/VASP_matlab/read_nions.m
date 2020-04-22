% Read NIONS from OUTCAR --------------------------
outcar = [vasp,'\OUTCAR'];
file   = fopen(outcar,'rt');
tline = 0;
line_temp = 0;
line  = 0;
while ~feof(file)
    temp  = fgetl(file);
    tline = strfind(temp,'NIONS');
    if (tline~=0)
       line = line_temp;
    end
    line_temp = line_temp+1;
end
fclose(file);

outcar = [vasp,'\OUTCAR'];
file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end
temp  = fgetl(file);
for i=1:20
    [text{i},temp] = strtok(temp);
end
nions = str2double(text{12});

fclose(file);
clear text tline temp file;