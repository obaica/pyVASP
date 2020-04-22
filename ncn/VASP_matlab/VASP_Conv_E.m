fprintf('---------------------------------------------------------\n');
fprintf(' (1) : Convergence energy\n');

fprintf('\n');
vasp_input;

% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_Conv_E.log'];
else
    log = [vasp,'/MATLAB_Conv_E.log'];
end
diary(log);
diary on;
tic;
% -----------------------------------------------------


% -----------------------------------------------------
% Read data from VASP
fprintf('\n>> Read data from OUTCAR');
if ispc
    data  = [vasp,'\data'];
else
    data  = [vasp,'/data'];
end
file  = fopen(data,'rt');
i = 1;
while ~feof(file)
    temp  = fgetl(file);
    [text,temp] = strtok(temp);
    xx(i)       = str2double(text);
    [text,temp] = strtok(temp);
    energy(i)   = str2double(text);
    i = i+1;
end
num_data = i-1;
fclose(file);
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Calculate delta energy
i = 1;
while i<num_data
    Deng(i+1) = energy(i+1) - energy(i);
    x2(i) = xx(i+1);
    i = i+1;
end

fprintf('\nno.  ENCUT      TOTEN        delta');
i = 1;
while i<=num_data
    fprintf('\n%2d    %3d    %f    %f',i,xx(i),energy(i),abs(Deng(i)));
    i = i+1;
end
i = 1;
while i<num_data
    Deng(i) = Deng(i+1);
    i = i+1;
end
Deng(num_data) = [];
% -----------------------------------------------------


% -----------------------------------------------------
% Read input tolerance from user
tolerance = input('\n\nInput Precision (eV) : ');
% -----------------------------------------------------


% -----------------------------------------------------
%  Plotting data
fprintf('\n>> Plotting data');
h=figure;
[ax,h1,h2] = plotyy(xx,energy,x2,abs(Deng));
set(h1,'marker','.','markersize',20,'color','blue');
set(h2,'marker','.','markersize',20,'color','red');

title('Convergence ENCUT');
xlabel('ENCUT (eV)');
ylabel(ax(1),'Energy(eV)','color','blue');
ylabel(ax(2),'\DeltaEnergy(eV)','color','red');

hold(ax(2),'on');
x3 = xx(1):10:xx(num_data);
y3 = linspace(tolerance,tolerance,length(x3)); 
plot(ax(2),x3,y3,'k--');

pic  = [vasp,'\MATLAB_Conv_E'];
print(pic,'-dpng');
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


clear tolerance vasp h h1 h2 ax pic data i a num_data file line temp text xx energy x2 Deng x3 y3;

fprintf('\n');
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;