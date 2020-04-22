% -----------------------------------------------------
% Show all Eigen for all High-symmetry point
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end
fgetl(file);

% if (hse=='F'&&ispin==1)
%    fgetl(file);
% elseif (hse=='F'&&ispin==2)
%    for i=1:3
%        fgetl(file);
%    end
% elseif (hse=='T')
%     for i=1:(nskip*(nbands+3))
%        fgetl(file);
%    end
% end



fprintf('\n\nEigin Energy >>>');

s = 1;
plot_vertical = 0;
k2x = 1;
k3x = 1;
k4x = 1;
for i = nskip+1:nkpts 
    fgetl(file);
    temp = fgetl(file);
    for k=1:10
        [text{k},temp] = strtok(temp);
    end
    k2 = str2double(text{4});
    k3 = str2double(text{5});
    k4 = str2double(text{6});
    VASP_KPT;
    if plot_vertical>0
        fprintf('\n>> %s (%f %f %f) : %f %f',labels{s},k2,k3,k4,bandx{i,nvb},bandx{i,nvb+1});
        plot_vertical = 0;
        k2x = k2;
        k3x = k3;
        k4x = k4;
        s = s+1;
    end
    for j=1:nbands+1
        fgetl(file);
    end
end
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% Finding VBM
vbm = bandx{nskip+1,nbands-ncb};
n_vbm = nskip;
for n = nskip+1:nkpts
    if bandx{n,nbands-ncb} >= vbm
        vbm = bandx{n,nbands-ncb};
        n_vbm = n;
    end
end

% Finding location of VBM
file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end

if (hse=='F'&&ispin==1)
    fgetl(file);
elseif (hse=='F'&&ispin==2)
    for i=1:3
        fgetl(file);
    end
elseif (hse=='T')
    for i=1:(nskip*(nbands+3))
        fgetl(file);
    end
end

for i= nskip+1:n_vbm-1
    for j=1:3
        fgetl(file);
    end
    for j=1:nbands
        fgetl(file);
    end
end
fgetl(file);
temp=fgetl(file);
for k=1:10
    [k_vbm{k},temp] = strtok(temp);
end

% Getting Occupation
fgetl(file);
for k=1:nvb
    fgetl(file);
end
text=fgetl(file);
for k=1:10
    [temp{k},text] = strtok(text);
end
occ = temp{3};

fclose(file);


% Reporting VBM
fprintf('\n');
fprintf('\nVBM at k-point %s (%s %s %s) = %f',k_vbm{2},k_vbm{4},k_vbm{5},k_vbm{6},vbm);
% -----------------------------------------------------


% -----------------------------------------------------
% Finding CBM
cbm = bandx{nskip+1,nbands-ncb+1};
n_cbm = nskip;
for n= nskip+1:nkpts
    if bandx{n,nbands-ncb+1} <= cbm
        cbm = bandx{n,nbands-ncb+1};
        n_cbm = n;
    end
end

% Finding location of CBM
file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end

if (hse=='F'&&ispin==1)
    fgetl(file);
elseif (hse=='F'&&ispin==2)
    for i=1:3
        fgetl(file);
    end
elseif (hse=='T')
    for i=1:(nskip*(nbands+3))
        fgetl(file);
    end
end

for i= nskip+1:n_cbm-1
    for j=1:3
        fgetl(file);
    end
    for j=1:nbands
        fgetl(file);
    end
end
fgetl(file);
temp=fgetl(file);
for k=1:10
    [k_cbm{k},temp] = strtok(temp);
end

% Getting Occupation
fgetl(file);
for k=1:nvb
    fgetl(file);
end
text=fgetl(file);
for k=1:10
    [temp{k},text] = strtok(text);
end
occ = temp{3};

fclose(file);

% Reporting CBM
fprintf('\nCBM at k-point %s (%s %s %s) = %f',k_cbm{2},k_cbm{4},k_cbm{5},k_cbm{6},cbm);
fprintf('\nEnergy gap : Eg = %f \n\n',cbm-vbm);
% -----------------------------------------------------
