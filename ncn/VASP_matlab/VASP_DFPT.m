fprintf('\n');
fprintf('---------------------------------------------------------\n');
fprintf(' (6) : Density Functional Perturbation Theory (DFPT)\n');

fprintf('\n');
vasp_input;
tic;


% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_DFPT.log'];
else
    log = [vasp,'/MATLAB_DFPT.log'];
end
diary(log);
diary on;
% -----------------------------------------------------


% -----------------------------------------------------
% Read data
read_leps;
read_lrpa;
% read_lpead;
read_nbands;
fprintf('\n');

% read MICROSCOPIC STATIC DIELECTRIC TENSOR
fprintf('\n>> Reading MICROSCOPIC STATIC DIELECTRIC TENSOR from OUTCAR');
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
    tline = strfind(temp,'HEAD OF MICROSCOPIC STATIC DIELECTRIC TENSOR');
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
fprintf(' .... COMPLETED !!');
for i=1:3
    temp = fgetl(file);
    fprintf('\n%s',temp);
end
fclose(file);


% -----------------------------------------------------

br







% Read real dielectric function ---------------------------------
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



% Plotting dielectric function in eV -------------------------------
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



% Plotting dielectric function in nm -------------------------------
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


fprintf('\n');
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;