% Hybrid functional calculations        = F
% Spin-Polarized calculations           = F

%
fprintf('\n');
read_nskip;

% -----------------------------------------------------
% prepared for read eigen value
fprintf('\n\n>> Reading Eigen Energy from OUTCAR');
if ispc
    outcar = [vasp,'\OUTCAR'];
else
    outcar = [vasp,'/OUTCAR'];
end
file   = fopen(outcar,'rt');
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
if ispin==1
    fgetl(file);
else
    fgetl(file);
    fgetl(file);
    fgetl(file);
end


% Start reading eigen energy
for i=1:nkpts
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
    for i=1:nkpts
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
x=[1:nkpts];
for i=1:nbands
    if (nbands-i)>=ncb
        plot(x,band(:,i),'r','linewidth',1);
    else
        plot(x,band(:,i),'b','linewidth',1);
    end
    hold on;
end


% Setup for plotting
maxx = max(band);
minn = min(band);
axis([1,nkpts,min(minn)-1,max(maxx)+1]);


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

s = 1;
plot_vertical = 0;
k2x = 1;
k3x = 1;
k4x = 1;
y=[-100:20:100];
for i = 1:nkpts 
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
fclose(file);

if ispc
    fig_band = [vasp,'\band.png'];
else
    fig_band = [vasp,'/band.png'];
end
print(fig_band,'-dpng');
% -------------------------------------------------


clear i j k line temp bandx file figband;