function everything = supercell(p, all, uv, supercell)

coord_list = all(:,1:3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXTENSION TO SUPERCELL %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
counter1 = 1;
counter2 = 1;
counter3 = 1;
if max(supercell)>1
    coord_list_copy = coord_list;
    for i=1:supercell(1)-1
        [length,width] =size(coord_list_copy)
        x = repmat(unit_vectors(1,:),length,1)
        temp_coord_list = coord_list_copy+i*x;
        coord_list = [coord_list; temp_coord_list];
        counter1 = counter1+1;
    end
    coord_list_copy = coord_list;
    for j=1:supercell(2)-1
        [length,width] =size(coord_list_copy);
        y = repmat(unit_vectors(2,:),length,1);
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
counter = (counter1)*(counter2)*(counter3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET RADII FROM POTCAR AND POSCAR %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%grab elements from potcar
p
potcar = [p, '\POTCAR']
fid2=fopen(potcar);
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


%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESS POSCAR FILE %%
%%%%%%%%%%%%%%%%%%%%%%%%%

[length,width] =size(coord_list);
poscar = [path, '\POSCAR'];
fid3=fopen(poscar); %open poscar
l = fgetl(fid3);
for i=2:6 % copy these lines
    l = fgetl(fid3);
end
% elements

%%grab radii from poscar
[n_e, junk]  = size(elements);
radii = [];
colors = [];
e_n = [];
for i=1:n_e
    [temp,l] = strtok(l);
    elements(i,:)
    %r = r_table(find(e_table(:,1:2)==elements(i,1:2),1))
    r = r_table(i);
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

colors = colors/ max(max(colors));
fclose('all');

%%%%%%%%%%%%%%%%%%%%%
%% PLOT EVERYTHING %%
%%%%%%%%%%%%%%%%%%%%%

% output = [coord_list(:,1), coord_list(:,2), coord_list(:,3), transpose(radii), colors]
% size(output)

figure()
bubbleplot3(coord_list(:,1), coord_list(:,2), coord_list(:,3), radii)
camlight right; lighting phong; view(60,30);
title(path)
figure()
scatter3(coord_list(:,1), coord_list(:,2), coord_list(:,3))

everything = [coord_list, transpose(radii), colors];
unit = [unit, transpose(temp_radii), temp_colors];

end