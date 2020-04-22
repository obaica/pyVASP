function  f  = check_outcar(path)

%% using Cartesian
[xyz, uv] = process(path, 'p');
all = view_cell(path, xyz, uv, [1 1 1]);
xyz_axes = [min(all(:,1))-3,max(all(:,1))+3, min(all(:,2))-3, max(all(:,2))+3, min(all(:,3))-3, max(all(:,3))+3]
[l,w] = size(all)

xyz_axes = [-30,0,0,16,0,12]

file = [path '\OUTCAR'];
fid=fopen(file);
flag = ' POSITION                                       TOTAL-FORCE (eV/Angst)';
match = 0;
coord_list = all;
clf('reset')
counter = 0;


while (~feof(fid))
   line = fgetl(fid)
   if strmatch(flag,line)==1
       counter = counter + 1;
       fgetl(fid);
       for i = 1:l
           coord = fgetl(fid);
           [x,r] = strtok(coord);
           [y,r] = strtok(r);
           [z,r] = strtok(r);
           coord_list(i,1:3) = [str2num(x) str2num(y) str2num(z)];
       end
        clf()
        plot_all(coord_list);
        axis(xyz_axes);
        %camlight right; lighting phong; view(90,30);
        f(counter) = getframe
   end
end

% figure()
% plot_all(coord_list)

end