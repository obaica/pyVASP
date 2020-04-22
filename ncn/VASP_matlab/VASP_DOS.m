fprintf('---------------------------------------------------------\n');
fprintf(' (5) : DOS analysis\n');

fprintf('\n');
vasp_input;

% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_DOS.log'];
else
    log = [vasp,'/MATLAB_DOS.log'];
end
diary(log);
diary on;
tic;
% -----------------------------------------------------


% -----------------------------------------------------
% Read data from VASP
read_nedos;
read_ispin;
read_efermi;

fprintf('\n');
fprintf('\n>> Read Total DOS from DOSCAR');
if ispc
    doscar  = [vasp,'\DOSCAR'];
else
    doscar  = [vasp,'/DOSCAR'];
end
file  = fopen(doscar,'rt');

temp  = fgetl(file);
[text,temp] = strtok(temp);
nion        = str2double(text);

for i=1:5
    fgetl(file);
end
for i=1:nedos
    temp = fgetl(file);
    [text,temp] = strtok(temp);
    TDOS(i,1)   = str2double(text);
    [text,temp] = strtok(temp);
    TDOS(i,2)   = str2double(text);
    TDOS(i,3)   = str2double(temp);
end
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
% Shift eigen energy
for i=1:nedos
    temp = TDOS(i,1);
    TDOS(i,1) = temp-efermi;
end
% -----------------------------------------------------
% saving eigen energy to csv
if ispc
    csv_dos = [vasp,'\TDOS.txt'];
else
    csv_dos = [vasp,'/TDOS.txt'];
end
save(csv_dos,'TDOS','-ASCII');
% -----------------------------------------------------


% -----------------------------------------------------
%  Plotting TDOS
fprintf('\n>> Plotting total DOS');
plot(TDOS(:,1),TDOS(:,2));
title('Total DOS');
xlabel('Energy (eV)');
ylabel('Total DOS','color','blue');

if ispc
    pic  = [vasp,'\MATLAB_TDOS'];
else
    pic  = [vasp,'/MATLAB_TDOS'];
end
print(pic,'-dpng');
fprintf(' .... COMPLETED !!');
% -----------------------------------------------------


% -----------------------------------------------------
%  Reading PDOS
fprintf('\n>> Read Partial DOS from DOSCAR');
for i=1:nion
    fgetl(file);
    for j=1:nedos
        temp = fgetl(file);
        k=1;
        [text,temp] = strtok(temp);
    	dosx(j,k)   = str2double(text)-efermi;    %energy
       
        k=k+1;
        [text,temp] = strtok(temp);
        dosx(j,k)   = str2double(text);           % s-orbital
        
        k=k+1;
       % sump = 0;
        [text,temp] = strtok(temp);
        dosx(j,k)   = str2double(text);           % p-orbital
       % sump = sump + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sump = sump + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sump = sump + str2double(text);
        
        k=k+1;
       % sumd = 0;
        [text,temp] = strtok(temp);
        dosx(j,k)   = str2double(text);           % d-oebital
       % sumd = sumd + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sumd = sumd + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sumd = sumd + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sumd = sumd + str2double(text);
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = str2double(text);
       % sumd = sumd + str2double(text);
        
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = sump;
       % k=k+1;
       % [text,temp] = strtok(temp);
       % dosx(j,k)   = sumd;
    end
    
    % -----------------------------------------------------
    % saving eigen energy to csv
    nn=num2str(i);
    if ispc
        csv_dos = [vasp,'\',nn,'_dos.txt'];
    else
        csv_dos = [vasp,'/',nn,'_dos.txt'];
    end
    save(csv_dos,'dosx','-ASCII');
    % -----------------------------------------------------

end
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
% SUMDOS
summ = 'y';
while(summ == 'y')
    fprintf('\n');
    start=input('Start atom to sum : ');
    stop =input('Stop atom to sum : ');
    name =input('Input sum DOS name : ','s');

    num = (stop-start)+1;
    sumdos=zeros(nedos,4);
    
    for i=1:num
        nn=start+i-1;
        if ispc
            dos  = [vasp,'\',num2str(start+i-1),'_dos.txt'];
        else
            dos  = [vasp,'/',num2str(start+i-1),'_dos.txt'];
        end
        file  = fopen(dos,'rt');

        for i=1:nedos
            temp = fgetl(file);
            [text,temp] = strtok(temp);
            sumdos(i,1) = str2double(text);    % energy
            [text,temp] = strtok(temp);
            sd          = str2double(text);
            sumdos(i,2) = sumdos(i,2)+sd;      % s-orbital
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            % [text,temp] = strtok(temp);
            [text,temp] = strtok(temp);
            sd          = str2double(text);
            sumdos(i,3) = sumdos(i,3)+sd;      % p-orbital
            sd          = str2double(temp);
            sumdos(i,4) = sumdos(i,4)+sd;      % d-orbital
        end

        if ispc
            sum_dos = [vasp,'\DOS_',name,'.txt'];
        else
            sum_dos = [vasp,'/DOS_',name,'.txt'];
        end
        save(sum_dos,'sumdos','-ASCII');
    end
    summ=input('SUMDOS again? [y] : ','s');
end



fprintf('\n');
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;