% Hybrid functional calculations        = T
% Spin-Polarized calculations           = F

read_nskip;
fprintf('\n');

% -----------------------------------------------------
% prepared for read eigen value
fprintf('\n>> Reading Eigen Energy from OUTCAR');
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file  = fopen(outcar,'rt');
tline = 0;
line  = 0;
while(1)
    temp  = fgetl(file);
    tline = strfind(temp,'E-fermi');
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
fgetl(file);

% Start reading eigen energy
for i=1:(nskip*(nbands+3))
        fgetl(file);
    end
     
    for i = nskip + 1:nkpts
        for j=1:3
            fgetl(file);
        end
        for j=1:nbands
            temp = fgetl(file);
            for k=1:10
                [text{k},temp] = strtok(temp);
            end
            bandx{i,j} = str2double(text{2});
        end
    end
    
fclose(file);
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Finding VBM / CBM
VASP_BAND_VBMCBM;
% -----------------------------------------------------


% -----------------------------------------------------
% Shift eigen energy
    for i=nskip + 1:nkpts
       for j=1:nbands
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
x = nskip + 1:nkpts;
for i=1:nbands
    if (nbands-i)>=ncb
       fig = plot(x ,band(x,i),'r','linewidth',1);
    else
       fig = plot(x ,band(x,i),'b','linewidth',1);
    end
    hold on;
end
hold on;
plot(x,0,'k--');

% Setup for plotting
maxx = max(band);
minn = min(band);
axis([nskip + 1,nkpts,min(minn)-1,max(maxx)+1]);

% Label x-ticker 
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
for i=1:(nskip*(nbands+3))
    fgetl(file);
end
s = 1;
plot_vertical = 0;
k2x = 1;
k3x = 1;
k4x = 1;
y=[-100:20:100];
for i = nskip+1:nkpts 
    fgetl(file);
    temp = fgetl(file);
    for k=1:10
        [text{k},temp] = strtok(temp);
    end
    k2 = str2double(text{4});
    k3 = str2double(text{5});
    k4 = str2double(text{6});
    VASP_KPOINTS_vertical;
    for j=1:nbands+1
        fgetl(file);
    end
end
ylabel('Energy (eV)');
set(gca,'XTick',k_point);
set(gca,'XTickLabel',labels);
 
if ispc
    fig_band = [vasp,'\band.png'];
else
    fig_band = [vasp,'/band.png'];
end
print(fig_band,'-dpng');
% -----------------------------------------------------

   
fclose(file);