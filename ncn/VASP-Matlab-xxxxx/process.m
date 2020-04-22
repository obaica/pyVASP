function [coord_list, unit_vectors] = process(path, car_type)

if car_type == 'c'
    file = [path '/CONTCAR'];
end
if car_type == 'p'
    file = [path '/POSCAR'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ELEMENT INFORMATION TABLES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e_table = ['C '; 'N '; 'H '; 'Cu'];
r_table = [.73; .71; .31; 1.28];
c_table = [[0,1,0]; [1,0,0]; [0,0,1]; [0,1,1]; [1,0,1]; [1,1,0]; [1,1,1]];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET COORDINATES FROM CONTCAR %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid=fopen(file);
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

flag = 'Selective';
%% get the coordinates and scale them by the unit vectors
while(~feof(fid))
    line = fgetl(fid);
    if strmatch(flag,line(1:9))==1
        line = fgetl(fid);
        d=1;
        if strmatch(line(1),'C')==1
            d =0;
        end
        coord = fgetl(fid);
        [length,width] = size(coord);
        while (width>10)
            [x,r] = strtok(coord);
            [y,r] = strtok(r);
            [z,r] = strtok(r);
            [r1,r] = strtok(r);
            [r2,r] = strtok(r);
            [r3,r] = strtok(r);
            if d==0
                coord_list = [coord_list; str2num(x) str2num(y) str2num(z)];
            else
                coord_list = [coord_list; unit_vectors(1,:)*str2num(x) + unit_vectors(2,:)*str2num(y) + unit_vectors(3,:)*str2num(z)]; %multiply by unit vectors to scale correctly
            end
            coord = fgetl(fid);
            [length,width] = size(coord);
        end
    end
end

fclose(fid);

end