fprintf('\n');
fprintf('---------------------------------------------------------\n');
fprintf(' (6) : Optical response\n');

fprintf('\n');

h = 6.62607004E-34;
c = 2.99792458E8;
ev = 1.60217653E-19;

vasp_input;
tic;

% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_OPTIC.log'];
else
    log = [vasp,'/MATLAB_OPTIC.log'];
end
diary(log);
diary on;

read_nbands;
read_nedos;
fprintf('\n');


% -----------------------------------------------------
% read img dielectric function
fprintf('\n>> Reading IMAGINARY DIELECTRIC FUNCTION from OUTCAR');
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
    tline = strfind(temp,'IMAGINARY DIELECTRIC FUNCTION');
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
fgetl(file);

for i=1:nedos/10
    temp = fgetl(file);
    for j=1:7
        [text{j},temp] = strtok(temp);
        img_ev{i,j} = str2double(text{j});
    end
end
fclose(file);

img = zeros(size(img_ev,1),8);
img = img_ev;
img{1,8} = 1E5;
for i=2:nedos/10
    img{i,8} = (h*c*1E9)/(img_ev{i,1}*ev);
end

if ispc
    xls_optic = [vasp,'\dielectric_img.csv'];
else
    xls_optic = [vasp,'/dielectric_img.csv'];
end
csvwrite(xls_optic,img);

fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Read real dielectric function
fprintf('\n>> Reading REAL DIELECTRIC FUNCTION from OUTCAR');
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
    tline = strfind(temp,'REAL DIELECTRIC FUNCTION');
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
fgetl(file);

for i=1:nedos/10
    temp = fgetl(file);
    for j=1:7
        [text{j},temp] = strtok(temp);
        real_ev{i,j} = str2double(text{j});
    end
end
fclose(file);

real = zeros(size(real_ev,1),8);
real = real_ev;
real{1,8} = 1E5;
for i=2:nedos/10
    real{i,8} = (h*c*1E9)/(real_ev{i,1}*ev);
end

if ispc
    xls_optic = [vasp,'\dielectric_real.csv'];
else
    xls_optic = [vasp,'/dielectric_real.csv'];
end
csvwrite(xls_optic,real);

fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate REFRACTIVE INDEX n = sqrt(e1+ sqrt(e1^2 + e2^2)) / sqrt(2)
for i=1:nedos/10
    ref_index{i,1}=img{i,1};
    for k=2:7
        ref_index{i,k}=sqrt(real{i,k} + sqrt(real{i,k}.*real{i,k} + img{i,k}.*img{i,k}))/sqrt(2);
    end
    ref_index{i,8}=img{i,8};
end

if ispc
    xls_optic = [vasp,'\Refractive_index.csv'];
else
    xls_optic = [vasp,'/Refractive_index.csv'];
end
csvwrite(xls_optic,ref_index);
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate EXTINCTION k = sqrt(-e1+ sqrt(e1^2 + e2^2)) / sqrt(2)
for i=1:nedos/10
    extinc{i,1}=img{i,1};
    for k=2:7
        extinc{i,k}=sqrt(-real{i,k} + sqrt(real{i,k}.*real{i,k} + img{i,k}.*img{i,k}))/sqrt(2);
    end
    extinc{i,8}=img{i,8};
end

if ispc
    xls_optic = [vasp,'\Extinction.csv'];
else
    xls_optic = [vasp,'/Extinction.csv'];
end
csvwrite(xls_optic,extinc);
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate EELS eels = e2 / (e1^2 + e2^2)
for i=1:nedos/10
    eels{i,1}=img{i,1};
    for k=2:7
        eels{i,k}=img{i,k}./(real{i,k}.*real{i,k} + img{i,k}.*img{i,k});
    end
    eels{i,8}=img{i,8};
end

if ispc
    xls_optic = [vasp,'\EELS.csv'];
else
    xls_optic = [vasp,'/EELS.csv'];
end
csvwrite(xls_optic,eels);
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate Reflectivity R = (n-1)^2 + k^2 / (n+1)^2 + k^2
for i=1:nedos/10
    reflec{i,1}=img{i,1};
    for k=2:7
        reflec{i,k}=( power(ref_index{i,k}-1,2) + power(extinc{i,k},2) )/ ( power(ref_index{i,k}+1,2) + power(extinc{i,k},2) );
    end
    reflec{i,8}=img{i,8};
end

if ispc
    xls_optic = [vasp,'\Reflectivity.csv'];
else
    xls_optic = [vasp,'/Reflectivity.csv'];
end
csvwrite(xls_optic,reflec);
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate Absorption Coeff. A = 2wk/c = 4*Pi*k/wavelength
for i=1:nedos/10
    abs{i,1}=img{i,1};
    for k=2:7
        abs{i,k}=( (4.*pi.*extinc{i,k}) / img{i,8} );
    end
    abs{i,8}=img{i,8};
end

if ispc
    xls_optic = [vasp,'\Absorption.csv'];
else
    xls_optic = [vasp,'/Absorption.csv'];
end
csvwrite(xls_optic,abs);
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting dielectric function in eV
fprintf('\n>> Plotting Dielectric function in eV');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(img(:,1)),cell2mat(img(:,ii)),'r','linewidth',1);
    hold on;
    fig = plot(cell2mat(real(:,1)),cell2mat(real(:,ii)),'b','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    xlabel('Energy (eV)');
    ylabel('Dielectric function');
    legend({'Imaginary','Real'},'FontSize',12)

    if ii==2
        title('Optical response : X-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_x.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_x.png'];
        end
    elseif ii==3
        title('Optical response : Y-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_y.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_y.png'];
        end
    elseif ii==4
        title('Optical response : Z-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_z.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_z.png'];
        end
    elseif ii==5
        title('Optical response : XY-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_xy.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_xy.png'];
        end
    elseif ii==6
        title('Optical response : YZ-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_yz.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_yz.png'];
        end
    elseif ii==7
        title('Optical response : ZX-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_ev_zx.png'];
        else
            fig_optic = [vasp,'/dielectric_ev_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting dielectric function in nm
fprintf('\n>> Plotting Dielectric function in nm.');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(img(:,8)),cell2mat(img(:,ii)),'r','linewidth',1);
    hold on;
    fig = plot(cell2mat(real(:,8)),cell2mat(real(:,ii)),'b','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    l = axis;
    axis([1 1000 l(3) l(4)]);
    xlabel('Wavelength (nm.)');
    ylabel('Dielectric function');
    legend({'Imaginary','Real'},'FontSize',12)

    if ii==2
        title('Optical response : X-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_x.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_x.png'];
        end
    elseif ii==3
        title('Optical response : Y-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_y.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_y.png'];
        end
    elseif ii==4
        title('Optical response : Z-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_z.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_z.png'];
        end
    elseif ii==5
        title('Optical response : XY-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_xy.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_xy.png'];
        end
    elseif ii==6
        title('Optical response : YZ-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_yz.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_yz.png'];
        end
    elseif ii==7
        title('Optical response : ZX-axis');
        if ispc
            fig_optic = [vasp,'\dielectric_nm_zx.png'];
        else
            fig_optic = [vasp,'/dielectric_nm_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting REFRACTIVE INDEX in eV
fprintf('\n>> Plotting Refractive index in eV');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(ref_index(:,1)),cell2mat(ref_index(:,ii)),'r','linewidth',1);
    hold on;
    fig = plot(cell2mat(extinc(:,1)),cell2mat(extinc(:,ii)),'b','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    xlabel('Energy (eV)');
    ylabel('Refractive Index');
    legend({'Refractive Index','Extinction Coeff.'},'FontSize',12)

    if ii==2
        title('Refractive Index : X-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_x.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_x.png'];
        end
    elseif ii==3
        title('Refractive Index : Y-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_y.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_y.png'];
        end
    elseif ii==4
        title('Refractive Index : Z-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_z.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_z.png'];
        end
    elseif ii==5
        title('Refractive Index : XY-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_xy.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_xy.png'];
        end
    elseif ii==6
        title('Refractive Index : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_yz.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_yz.png'];
        end
    elseif ii==7
        title('Refractive Index : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_ev_zx.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_ev_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting REFRACTIVE INDEX in nm
fprintf('\n>> Plotting Refractive index in nm.');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(ref_index(:,8)),cell2mat(ref_index(:,ii)),'r','linewidth',1);
    hold on;
    fig = plot(cell2mat(extinc(:,8)),cell2mat(extinc(:,ii)),'b','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    l = axis;
    axis([1 1000 l(3) l(4)]);
    xlabel('Wavelength (nm.)');
    ylabel('Refractive Index');
    legend({'Refractive Index','Extinction Coeff.'},'FontSize',12)

    if ii==2
        title('Refractive Index : X-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_x.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_x.png'];
        end
    elseif ii==3
        title('Refractive Index : Y-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_y.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_y.png'];
        end
    elseif ii==4
        title('Refractive Index : Z-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_z.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_z.png'];
        end
    elseif ii==5
        title('Refractive Index : XY-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_xy.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_xy.png'];
        end
    elseif ii==6
        title('Refractive Index : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_yz.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_yz.png'];
        end
    elseif ii==7
        title('Refractive Index : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Refractive_Index_nm_zx.png'];
        else
            fig_optic = [vasp,'/Refractive_Index_nm_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting EELS in eV
fprintf('\n>> Plotting Electron Energy Loss Spectroscopy in eV');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(eels(:,1)),cell2mat(eels(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    xlabel('Energy (eV)');
    ylabel('EELS');
    legend({'EELS'},'FontSize',12)

    if ii==2
        title('EELS : X-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_x.png'];
        else
            fig_optic = [vasp,'/EELS_ev_x.png'];
        end
    elseif ii==3
        title('EELS : Y-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_y.png'];
        else
            fig_optic = [vasp,'/EELS_ev_y.png'];
        end
    elseif ii==4
        title('EELS : Z-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_z.png'];
        else
            fig_optic = [vasp,'/EELS_ev_z.png'];
        end
    elseif ii==5
        title('EELS : XY-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_xy.png'];
        else
            fig_optic = [vasp,'/EELS_ev_xy.png'];
        end
    elseif ii==6
        title('EELS : YZ-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_yz.png'];
        else
            fig_optic = [vasp,'/EELS_ev_yz.png'];
        end
    elseif ii==7
        title('EELS : ZX-axis');
        if ispc
            fig_optic = [vasp,'\EELS_ev_zx.png'];
        else
            fig_optic = [vasp,'/EELS_ev_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting EELS in nm
fprintf('\n>> Plotting Electron Energy Loss Spectroscopy in nm.');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(eels(:,8)),cell2mat(eels(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    l = axis;
    axis([1 1000 l(3) l(4)]);
    xlabel('Wavelength (nm.)');
    ylabel('EELS');
    legend({'EELS'},'FontSize',12)

    if ii==2
        title('EELS : X-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_x.png'];
        else
            fig_optic = [vasp,'/EELS_nm_x.png'];
        end
    elseif ii==3
        title('EELS : Y-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_y.png'];
        else
            fig_optic = [vasp,'/EELS_nm_y.png'];
        end
    elseif ii==4
        title('EELS : Z-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_z.png'];
        else
            fig_optic = [vasp,'/EELS_nm_z.png'];
        end
    elseif ii==5
        title('EELS : XY-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_xy.png'];
        else
            fig_optic = [vasp,'/EELS_nm_xy.png'];
        end
    elseif ii==6
        title('EELS : YZ-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_yz.png'];
        else
            fig_optic = [vasp,'/EELS_nm_yz.png'];
        end
    elseif ii==7
        title('EELS : ZX-axis');
        if ispc
            fig_optic = [vasp,'\EELS_nm_zx.png'];
        else
            fig_optic = [vasp,'/EELS_nm_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting Reflectivity in eV
fprintf('\n>> Plotting Reflectivity in eV');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(reflec(:,1)),cell2mat(reflec(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    xlabel('Energy (eV)');
    ylabel('Reflectivity');
    legend({'Reflectivity'},'FontSize',12)

    if ii==2
        title('Reflectivity : X-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_x.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_x.png'];
        end
    elseif ii==3
        title('Reflectivity : Y-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_y.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_y.png'];
        end
    elseif ii==4
        title('Reflectivity : Z-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_z.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_z.png'];
        end
    elseif ii==5
        title('Reflectivity : XY-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_xy.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_xy.png'];
        end
    elseif ii==6
        title('Reflectivity : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_yz.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_yz.png'];
        end
    elseif ii==7
        title('Reflectivity : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_ev_zx.png'];
        else
            fig_optic = [vasp,'/Reflectivity_ev_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting Reflectivity in nm
fprintf('\n>> Plotting Reflectivity in nm.');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(reflec(:,8)),cell2mat(reflec(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    l = axis;
    axis([1 1000 l(3) l(4)]);
    xlabel('Wavelength (nm.)');
    ylabel('Reflectivity');
    legend({'Reflectivity'},'FontSize',12)

    if ii==2
        title('Reflectivity : X-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_x.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_x.png'];
        end
    elseif ii==3
        title('Reflectivity : Y-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_y.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_y.png'];
        end
    elseif ii==4
        title('Reflectivity : Z-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_z.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_z.png'];
        end
    elseif ii==5
        title('Reflectivity : XY-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_xy.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_xy.png'];
        end
    elseif ii==6
        title('Reflectivity : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_yz.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_yz.png'];
        end
    elseif ii==7
        title('Reflectivity : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Reflectivity_nm_zx.png'];
        else
            fig_optic = [vasp,'/Reflectivity_nm_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting Absorption in eV
fprintf('\n>> Plotting Absorption Coeff. in eV');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(abs(:,1)),cell2mat(abs(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    xlabel('Energy (eV)');
    ylabel('Absorption coeff.');
    legend({'Absorption coeff.'},'FontSize',12)

    if ii==2
        title('Absorption : X-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_x.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_x.png'];
        end
    elseif ii==3
        title('Absorption : Y-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_y.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_y.png'];
        end
    elseif ii==4
        title('Absorption : Z-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_z.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_z.png'];
        end
    elseif ii==5
        title('Absorption : XY-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_xy.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_xy.png'];
        end
    elseif ii==6
        title('Absorption : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_yz.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_yz.png'];
        end
    elseif ii==7
        title('Absorption : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_ev_zx.png'];
        else
            fig_optic = [vasp,'/Absorption_ev_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Plotting Absorption in nm
fprintf('\n>> Plotting Absorption Coeff. in nm.');
for ii=2:7
    fig = figure('position', [0, 0, 600, 400]);
    fig = plot(cell2mat(abs(:,8)),cell2mat(abs(:,ii)),'r','linewidth',1);
    hold on;
    plot(xlim,[0 0],'k--');
   
    l = axis;
    axis([1 1000 l(3) l(4)]);
    xlabel('Wavelength (nm.)');
    ylabel('Absorption Coeff.');
    legend({'Absorption Coeff.'},'FontSize',12)

    if ii==2
        title('Absorption : X-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_x.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_x.png'];
        end
    elseif ii==3
        title('Absorption : Y-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_y.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_y.png'];
        end
    elseif ii==4
        title('Absorption : Z-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_z.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_z.png'];
        end
    elseif ii==5
        title('Absorption : XY-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_xy.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_xy.png'];
        end
    elseif ii==6
        title('Absorption : YZ-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_yz.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_yz.png'];
        end
    elseif ii==7
        title('Absorption : ZX-axis');
        if ispc
            fig_optic = [vasp,'\Absorption_nm_zx.png'];
        else
            fig_optic = [vasp,'/Absorption_nm_zx.png'];
        end
    end
    
    print(fig_optic,'-dpng');
end
close all;
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


clear abs eels extinc fig fig_optic file i ii img img_ev j k l real real_ev ref_index reflec temp text tline vasp xls_optic
fprintf('\n');
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;