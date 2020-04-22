fprintf('\n');

% -----------------------------------------------------
% Read number of KPT in wannier90
fprintf('\n>> Reading NKPTS from wannier90_band.kpt');
if ispc
    outcar = [vasp,'\wannier90_band.kpt'];
else
    outcar = [vasp,'/wannier90_band.kpt'];
end
file  = fopen(outcar,'rt');
temp  = fgetl(file);
nkpts = str2double(temp);
fprintf('\nnumber of k-points              NKPTS = %d',nkpts);
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% Read number of NBANDS in wannier90
fprintf('\n>> Reading NBANDS from wannier90.wout');
if ispc
    outcar = [vasp,'\wannier90.wout'];
else
    outcar = [vasp,'/wannier90.wout'];
end
file  = fopen(outcar,'rt');
tline = 0;
line  = 0;
while(1)
    temp  = fgetl(file);
    tline = strfind(temp,'Number of Wannier Functions');
    line  = line+1;
    if (tline~=0)
        break;
    end
end
fclose(file);

file   = fopen(outcar,'rt');
for i=1:line
    fgetl(file);
end
temp = fgetl(file);
for k=1:10
    [text{k},temp] = strtok(temp);
end
nbands = str2double(text{8});
fprintf('\nnumber of bands                NBANDS = %d',nbands);
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% Read eigen value from wannier90
fprintf('\n>> Reading Eigen Energy from wannier90_band.dat');
if ispc
    outcar = [vasp,'\wannier90_band.dat'];
else
    outcar = [vasp,'/wannier90_band.dat'];
end
file  = fopen(outcar,'rt');

% Start reading eigen energy
for i=1:nbands     
    for j=1:nkpts
        temp = fgetl(file);
        for k=1:2
            [text{k},temp] = strtok(temp);
        end
        bandx{i,j} = str2double(text{2});
    end
    fgetl(file);
end
    
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% Finding VBM / CBM
fprintf('\n>> Reading wannier90.win');
if ispc
    win = [vasp,'\wannier90.win'];
else
    win = [vasp,'/wannier90.win'];
end
file  = fopen(win,'rt');

find_line = 0;
line  = 0;
while(1)
    temp  = fgetl(file);
    find_line = strfind(temp,'begin kpoint_path');
    if (find_line~=0)
        break;
    end
    line  = line+1;
end

n=1;
temp  = fgetl(file);
for k=1:8
    [text{k},temp] = strtok(temp);
end
kpt{n} = text{1};
sym_point(n,1) = str2double(text{2});
sym_point(n,2) = str2double(text{3});
sym_point(n,3) = str2double(text{4});

n=2;
kpt{n} = text{5};
sym_point(n,1) = str2double(text{6});
sym_point(n,2) = str2double(text{7});
sym_point(n,3) = str2double(text{8});

find_line = 0;
while(1)
    temp  = fgetl(file);
    find_line = strfind(temp,'end kpoint_path');
    if (find_line~=0)
        break;
    end
    n=n+1;
    for k=1:8
        [text{k},temp] = strtok(temp);
    end
    kpt{n} = text{5};
    sym_point(n,1) = str2double(text{6});
    sym_point(n,2) = str2double(text{7});
    sym_point(n,3) = str2double(text{8});
end
n_kpt = n;
fclose(file);


fprintf('\n>> Reading wannier90_band.kpt');
if ispc
    bandkpt = [vasp,'\wannier90_band.kpt'];
else
    bandkpt = [vasp,'/wannier90_band.kpt'];
end
file  = fopen(bandkpt,'rt');
fgetl(file);


kline = 0;
i=1;
while(1)
    temp  = fgetl(file);
    for k=1:4
        [text{k},temp] = strtok(temp);
    end
    kk(1) = str2double(text{1});
    kk(2) = str2double(text{2});
    kk(3) = str2double(text{3});
    kline = kline+1;
    if ( kk(1)==sym_point(i,1) && kk(2)==sym_point(i,2) && kk(3)==sym_point(i,3) )
        k_line(i) = kline;
        i = i+1;
        if i>n_kpt
            break;
        end
    end
end
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% Show all Eigen for all High-symmetry point
fprintf('\n\nEigin Energy >>>');
nvb=4;
for i=1:n_kpt;
    fprintf('\n>> %s (%f %f %f) : %f %f',kpt{i},sym_point(i,1),sym_point(i,2),sym_point(i,3),bandx{nvb,k_line(i)},bandx{nvb+1,k_line(i)});
end
% -----------------------------------------------------


% -----------------------------------------------------
% Finding VBM
vbm = bandx{nvb,1};
n_vbm = 1;
for n = 1:nkpts
    if bandx{nvb,n} >= vbm
        vbm = bandx{nvb,n};
        n_vbm = n;
    end
end

% Finding location of VBM
if ispc
    bandkpt = [vasp,'\wannier90_band.kpt'];
else
    bandkpt = [vasp,'/wannier90_band.kpt'];
end
file  = fopen(bandkpt,'rt');
fgetl(file);
for i=1:n_vbm
    temp = fgetl(file);
end
for k=1:4
    [text{k},temp] = strtok(temp);
end

% Reporting VBM
fprintf('\n');
fprintf('\nVBM at k-point (%s %s %s) = %f',text{1},text{2},text{3},vbm);
% -----------------------------------------------------


% -----------------------------------------------------
% Finding CBM
cbm = bandx{nvb+1,1};
n_cbm = 1;
for n = 1:nkpts
    if bandx{nvb+1,n} <= cbm
        cbm = bandx{nvb+1,n};
        n_cbm = n;
    end
end

% Finding location of VBM
if ispc
    bandkpt = [vasp,'\wannier90_band.kpt'];
else
    bandkpt = [vasp,'/wannier90_band.kpt'];
end
file  = fopen(bandkpt,'rt');
fgetl(file);
for i=1:n_cbm
    temp = fgetl(file);
end
for k=1:4
    [text{k},temp] = strtok(temp);
end

% Reporting CBM
fprintf('\nCBM at k-point (%s %s %s) = %f',text{1},text{2},text{3},cbm);
fprintf('\nEnergy gap : Eg = %f \n\n',cbm-vbm);
% -----------------------------------------------------


% -----------------------------------------------------
% Shift eigen energy
for i=1:nbands
    for j=1:nkpts
       band(i,j) = bandx{i,j}-vbm;
    end
end
% -----------------------------------------------------


% -----------------------------------------------------
% saving eigen energy to csv
if ispc
    csv_band = [vasp,'\band.csv'];
else
    csv_band = [vasp,'/band.csv'];
end
csvwrite(csv_band,band);
% -----------------------------------------------------


% -----------------------------------------------------
% Setup for figure size
fig=figure('position', [0, 0, 450, 550]);
x = 1:nkpts;
for i=1:nbands
    if (nbands-i)>=nvb
       fig = plot(x ,band(i,x),'r','linewidth',1);
    else
       fig = plot(x ,band(i,x),'b','linewidth',1);
    end
    hold on;
end
hold on;
plot(x,0,'k--');

% Setup for plotting
maxx = max(band);
minn = min(band);
axis([1,nkpts,min(minn)-1,max(maxx)+1]);

y=[min(minn)-10:1:max(maxx)+10];
for i=1:n_kpt
    hold on;
    x = linspace(k_line(i),k_line(i),length(y));
    plot(x,y,'k--');
end

ylabel('Energy (eV)');
set(gca,'XTick',k_line);
set(gca,'XTickLabel',kpt);

if ispc
    fig_band = [vasp,'\band.png'];
else
    fig_band = [vasp,'/band.png'];
end
print(fig_band,'-dpng');
% -----------------------------------------------------