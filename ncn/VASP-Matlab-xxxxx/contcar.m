function [coord_list, restricted, radii, colors] = contcar()

fid=fopen('CONTCAR.txt');
unit_vectors = [];
coord_list = [];
restricted = [];
counter = 0;

fgetl(fid); % skip some lines
fgetl(fid);

%% build the unit cell vectors
for i=1:3
    temp = fgetl(fid);
    [v1, temp] = strtok(temp); %x
    [v2, temp] = strtok(temp); %y
    [v3, temp] = strtok(temp); %z
    unit_vectors = [unit_vectors; str2num(v1) str2num(v2) str2num(v3)];
end

%% get the coordinates and scale them by the unit vectors
while(~feof(fid))
    line = fgetl(fid);
    if strmatch('Direct',line)==1
        coord = fgetl(fid);
        [length,width] = size(coord);
        while (width>10)
            formatted_coord = strrep(coord, '-', ' -'); %make spacing correct for delim
            formatted_coord = strrep(formatted_coord, '   ', '  '); %make spacing correct for delim
            %formatted_coord = strrep(formatted_coord, 'T', ' 1'); %change to int
            %formatted_coord = strrep(formatted_coord, 'F', ' 0'); %change to int
            [x,y,z,r1,r2,r3] = strread(formatted_coord, '%f%f%f%c%c%c', 'delimiter', '  ');
            coord_list = [coord_list; unit_vectors(1,:)*x + unit_vectors(2,:)*y + unit_vectors(3,:)*z]; %multiply by unit vectors to scale correctly
            restricted = [restricted; '   ' r1 '  ' r2 '  ' r3]; %store T/F restrictions
            coord = fgetl(fid);
            [length,width] = size(coord);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET RADII FROM POTCAR AND POSCAR %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[length,width] =size(coord_list);
poscar = [num2str(coord_list) restricted];

fid3=fopen('POSCAR.txt'); %open poscar
l = fgetl(fid3);
for i=2:6 % copy these lines
    l = fgetl(fid3);
end

%%grab elements from potcar
fid2=fopen('POTCAR.txt');
elements = [];
while(~feof(fid2))
    line = fgetl(fid2);
    [len,wid] = size(line);
    if wid>6
        if strmatch('PAW_PBE',line(2:8))
            [e, junk] = strtok(line(9:end));
            [junk,check_size] = size(e);
            if check_size<2
                e = [e ' '];
            end
            elements = [elements; e];
        end
    end
end

% elements

%%grab radii from poscar
[n_e, junk]  = size(elements);
radii = [];
colors = [];
for i=1:n_e
    [temp,l] = strtok(l);
    r = r_table(find(e_table==elements(i),1));
    radii = [radii r.*ones(1,str2num(temp))];
    rgb = r*[c_table(mod(i,7),1)*ones(str2num(temp),1) c_table(mod(i,7),2)*ones(str2num(temp),1) c_table(mod(i,7),3)*ones(str2num(temp),1)];
    colors = [colors; rgb];
end

temp_radii = radii;
temp_colors = colors;

for i=1:counter
    radii = [radii temp_radii];
    colors = [colors; temp_colors];
end

end