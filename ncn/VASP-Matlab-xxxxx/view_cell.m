function everything = view_cell(path, coord_list, unit_vectors, supercell)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ELEMENT INFORMATION TABLES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% e_table = ['C '; 'H '; 'N ';'Cu']
% r_table = [.73; .31; .71; 1.28];
e_table = ['Cu C  H  N '];
r_table = [1.28; .73; .31; .71];
c_table = [[.6,.8,.8]; [1,0,0]; [0,0,1]; [0,1,1]; [1,0,1]; [1,1,0]; [1,1,1]];

%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESS POSCAR FILE %%
%%%%%%%%%%%%%%%%%%%%%%%%%

[length,width] =size(coord_list);
poscar = [path, '\POSCAR'];
fid3=fopen(poscar); %open poscar
l = fgetl(fid3);
flag = 0;
counter = 1;
while flag == 0 % copy these lines
    l = fgetl(fid3);
    if l(1) == 'S'
        l=m
        flag = 1;
    end
    m=l;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXTENSION TO SUPERCELL %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unit = coord_list;
counter1 = 1;
counter2 = 1;
counter3 = 1;
if max(supercell)>1
    coord_list_copy = coord_list;
    for i=1:supercell(1)-1
        [length,width] =size(coord_list_copy);
        x = repmat(unit_vectors(1,:),length,1);
        temp_coord_list = coord_list_copy+i*x;
        coord_list = [coord_list; temp_coord_list];
        counter1 = counter1+1;
    end
    coord_list_copy = coord_list;
    for j=1:supercell(2)-1
        [length,width] =size(coord_list_copy);
        y = repmat(unit_vectors(2,:),length,1);
        coord_list_copy;
        temp_coord_list = coord_list_copy+j*y;
        coord_list = [coord_list; temp_coord_list];
        counter2 = counter2+1;
    end
    coord_list_copy = coord_list;
    for k=1:supercell(3)-1
        [length,width] =size(coord_list);
        z = repmat(unit_vectors(3,:),length,1);
        temp_coord_list = coord_list+k*z;
        coord_list = [coord_list; temp_coord_list];
        counter3 = counter3+1;
    end
end
counter = (counter1)*(counter2)*(counter3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET RADII FROM POTCAR AND POSCAR %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%grab elements from potcar
potcar = [path, '\POTCAR'];
fid2=fopen(potcar);
elements = [];
while(~feof(fid2))
    line = fgetl(fid2);
    [len,wid] = size(line);
    if wid>6
        if strmatch('PAW_PBE',line(2:8))
            e = line(10:11);
            elements = [elements; e];
        end
    end
end

%%grab radii from potcar
[n_e, junk]  = size(elements);
radii = [];
colors = [];
e_n = [];
for i=1:n_e
    [temp,m] = strtok(m);
    j = (strfind(e_table, elements(i,:))-1)/3+1;
    r = r_table(j);
    radii = [radii r.*ones(1,str2num(temp))];
    rgb = r*[c_table(mod(i,7),1)*ones(str2num(temp),1) c_table(mod(i,7),2)*ones(str2num(temp),1) c_table(mod(i,7),3)*ones(str2num(temp),1)];
    colors = [colors; rgb];
end

temp_radii = radii;
temp_colors = colors;

for i=1:counter-1
    radii = [radii temp_radii];
    colors = [colors; temp_colors];
end

colors = colors/max(max(colors));
fclose('all');

%%%%%%%%%%%%%%%%%%%%%
%% PLOT EVERYTHING %%
%%%%%%%%%%%%%%%%%%%%%

size(radii);
size(colors);
size(coord_list);
bubbleplot3(coord_list(:,1), coord_list(:,2), coord_list(:,3), radii, colors)
camlight right; lighting phong; view(90,90);
% figure()
% scatter3(coord_list(:,1), coord_list(:,2), coord_list(:,3))

everything = [coord_list, transpose(radii), colors];
unit = [unit, transpose(temp_radii), temp_colors];

end