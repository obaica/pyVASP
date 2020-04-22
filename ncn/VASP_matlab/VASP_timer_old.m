fprintf('---------------------------------------------------------\n');
fprintf(' (0) : Time Calculation\n');

fprintf('\n');
vasp_input;

% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_time.log'];
else
    log = [vasp,'/MATLAB_time.log'];
end
diary(log);
diary on;

% Read input tolerance from user

tic;

% Read data from VASP --------------------------
if ispc
    out1 = dir([vasp,'\output.*']);
    output = [vasp,'\',out1.name];
else
    out1 = dir([vasp,'/output.*']);
    output = [vasp,'/',out1.name];
end
clear out1;

% read start time
file  = fopen(output,'rt');
for i=1:3
    fgetl(file);
end
temp  = fgetl(file);
disp(temp);
fclose(file);

% read stop time
file  = fopen(output,'rt');
i = 1;
while ~feof(file)
    fgetl(file);
    i = i+1;
end
fclose(file);

file  = fopen(output,'rt');
for i=1:i-2
    fgetl(file);
end
temp  = fgetl(file);
disp(temp);
fclose(file);

break

















clear vasp;

fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;