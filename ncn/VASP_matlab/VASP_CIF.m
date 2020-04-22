fprintf('\n');
fprintf('---------------------------------------------------------\n');
fprintf(' (8) : CIF creation\n');

fprintf('\n');
vasp_input;
tic;


% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_CIF.log'];
else
    log = [vasp,'/MATLAB_CIF.log'];
end
diary(log);
diary on;
% -----------------------------------------------------


% -----------------------------------------------------
% Read CONTCAR
fprintf('\n>> Reading CONTCAR');
if ispc
    contcar = [vasp,'\CONTCAR'];
    cif     = [vasp,'\CONTCAR.cif'];
else
    contcar = [vasp,'/CONTCAR'];
    cif     = [vasp,'/CONTCAR.cif'];
end
cont  = fopen(contcar,'rt');
cif   = fopen(cif,'wt');


temp  = fgetl(cont);
fprintf(cif,'data_%s\n',temp);
fprintf(cif,'loop_\n');
fprintf(cif,'_audit_creation_method   nanoHPC\n');


lattice  = str2double(fgetl(cont));
for i=1:3
    temp = fgetl(cont);
    for j=1:3
        [text{j},temp] = strtok(temp);
        temp2{i,j}  = str2double(text{j});
    end
end
t_vector = cell2mat(temp2);
for i=1:3
    vector_ax{i} = lattice * t_vector(1,i);
    vector_bx{i} = lattice * t_vector(2,i);
    vector_cx{i} = lattice * t_vector(3,i);
end
vector_a = cell2mat(vector_ax);
vector_b = cell2mat(vector_bx);
vector_c = cell2mat(vector_cx);

fprintf(cif,'_cell_length_a        %f\n',norm(vector_a,2));
fprintf(cif,'_cell_length_b        %f\n',norm(vector_b,2));
fprintf(cif,'_cell_length_c        %f\n',norm(vector_c,2));
fprintf(cif,'_cell_angle_alpha     %f\n',acosd(dot(vector_b,vector_c)/(norm(vector_b,2)*norm(vector_c,2))));
fprintf(cif,'_cell_angle_beta      %f\n',acosd(dot(vector_c,vector_a)/(norm(vector_c,2)*norm(vector_a,2))));
fprintf(cif,'_cell_angle_gamma     %f\n',acosd(dot(vector_a,vector_b)/(norm(vector_a,2)*norm(vector_b,2))));
fprintf(cif,'_symmetry_space_group_name_H-M    P 1\n');
% fprintf(cif,'_loop\n');

fprintf(cif,'loop_\n');
fprintf(cif,'_atom_site_type_symbol\n');
fprintf(cif,'_atom_site_fract_x\n');
fprintf(cif,'_atom_site_fract_y\n');
fprintf(cif,'_atom_site_fract_z\n');


temp = fgetl(cont);
i=0;
for j=1:10
    [atom{j},temp] = strtok(temp);
    if atom{j} ~= ' '
        i=i+1;
    end
    n_atomtype = i;
end
temp = fgetl(cont);
for j=1:n_atomtype
    [text{j},temp] = strtok(temp);
    natom{j} = str2double(text{j});
end
fgetl(cont);


sum_atom = 0;
for i=1:n_atomtype
    sum_atom = sum_atom + natom{i};
end
k = 1;
for i=1:n_atomtype
    for j=1:natom{i}
        atom2{k} = atom{i};
        k = k+1;
    end
end

for i=1:sum_atom
    temp = fgetl(cont);
    for j=1:3
        [text{j},temp] = strtok(temp);
        xyz{i,j}       = str2double(text{j});
    end
end


for i=1:sum_atom
    fprintf(cif,'%s %f %f %f\n',atom2{i},xyz{i,1},xyz{i,2},xyz{i,3});
end


fclose(cont);
fclose(cif);
% -----------------------------------------------------


fprintf(' .... COMPLETED !!');


fprintf('\n');
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;