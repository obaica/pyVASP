fprintf('---------------------------------------------------------\n');
fprintf(' (3) : Lattice minimization\n');

fprintf('\n');
vasp_input;
tic;

% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_Lattice.log'];
else
    log = [vasp,'/MATLAB_Lattice.log'];
end
diary(log);
diary on;
% -----------------------------------------------------


% -----------------------------------------------------
% Read data
fprintf('\n>> Reading data from VASP');
if ispc
    data  = [vasp,'\data'];
else
    data  = [vasp,'/data'];
end
file  = fopen(data,'rt');
i=1;
while ~feof(file)
    temp  = fgetl(file);
    [text,temp] = strtok(temp);
    xx(i)       = str2double(text);
    [text,temp] = strtok(temp);
    energy(i)   = str2double(text);
    i = i+1;
end
fclose(file);
num_data = i-1;
fprintf(' .... COMPLETED !!');

fprintf('\nno.  Lattice Const.     TOTEN');
i = 1;
while i<=num_data
    fprintf('\n%2d      %0.2f         %f',i,xx(i),energy(i));
    i = i+1;
end
% -----------------------------------------------------


% -----------------------------------------------------
%  Plotting lattice
fprintf('\n\n>> Minimization lattice constant ');
h = figure;
plot(xx,energy,'b.-','MarkerSize',20);
title('Lattice Minimization');
xlabel('Lattice Constant (A)');
ylabel('Energy (eV)');


%  Polynomial Fitting
fit = polyfit(xx,energy,3);
yy = polyval(fit,xx);
hold on;
plot(xx,yy,'r--');


%  Diff
fit2(1)=3*fit(1);
fit2(2)=2*fit(2);
fit2(3)=1*fit(3);
x0 = roots(fit2);
y0(1) = (fit(1)*x0(1)^3) + (fit(2)*x0(1)^2) + (fit(3)*x0(1)) + fit(4);
y0(2) = (fit(1)*x0(2)^3) + (fit(2)*x0(2)^2) + (fit(3)*x0(2)) + fit(4);

fprintf(' .... COMPLETED !!');

fprintf('\n\nE = %0.4f*x^3 + %0.4f*x^2 + %0.4f*x + %0.4f\n',fit(1),fit(2),fit(3),fit(4));

fprintf('\n');
if (y0(1)<y0(2))
     fprintf('Minimum point is %0.4f A\n',x0(1));
     hold on;
     plot(x0(1),y0(1),'r.','MarkerSize',20);
else 
     fprintf('Minimum point is %0.4f A\n',x0(2));
     hold on;
     plot(x0(2),y0(2),'r.','MarkerSize',20);
end

pic = [vasp,'\MATLAB_Lattice'];
print(pic,'-dpng');
% -----------------------------------------------------


clear vasp h pic data file i line temp text eergy fit fit2 num_data xx x0 yy y0;

fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;