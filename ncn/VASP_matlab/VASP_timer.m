fprintf('---------------------------------------------------------\n');
fprintf(' (1) : Time Calculator\n');

fprintf('\n');
vasp_input;

% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_Timer.log'];
else
    log = [vasp,'/MATLAB_Timer.log'];
end
diary(log);
diary on;
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

file  = fopen(output,'rt');
k = 1;
while ~feof(file)
    fgetl(file);
    k = k + 1;
end
fclose(file);

file  = fopen(output,'rt');
i = 1;
while ~feof(file)
    temp  = fgetl(file);
   if i == 4 | i == k - 1 
    [text,temp] = strtok(temp);
    [text,temp] = strtok(temp);
    [text,temp] = strtok(temp);
    [text,temp] = strtok(temp);
    if i == 4
    start = temp;
    end
    if i == k - 1
    finish = temp;
    end
    [text,temp] = strtok(temp);
    if i == 4
    month{1} = text;
    end
    if i == k - 1
    month{2} = text;
    end
    [text,temp] = strtok(temp);
    d(i)   = str2double(text);
    [text,temp] = strtok(temp,':');
    h(i)   = str2double(text);
    [text,temp] = strtok(temp,':');
    m(i)   = str2double(text);
    [text,temp] = strtok(temp,'[: ]');
    s(i)   = str2double(text);
    [text,temp] = strtok(temp);
    [text,temp] = strtok(temp);
    y(i) = str2double(text);
   end
    i = i+1;
end
fclose(file);

year(1) = y(4);
year(2) = y(k - 1);
for i = 1:12
    if i==1|i==3|i==5|i==7|i==8|i==10|i==12
        days(i) = 31;
    elseif i==4|i==6|i==9|i==11
        days(i) = 30;
    end
end
for i = 1:2
    if month{i} == 'Jan'
    month{i} = 1;
elseif month{i} == 'Feb'
    month{i} = 2;
elseif month{i} == 'Mar'
    month{i} = 3;
elseif month{i} == 'Apr'
   month{i} = 4;
elseif month{i} == 'May'
    month{i} = 5;  
elseif month{i} == 'Jun'
    month{i} = 6; 
elseif month{i} == 'Jul'
    month{i} = 7; 
elseif month{i} == 'Aug'
    month{i} = 8; 
elseif month{i} == 'Sep'
    month{i} = 9; 
elseif month{i} == 'Oct'
    month{i} = 10;  
elseif month{i} == 'Nov'
    month{i} = 11;   
elseif month{i} == 'Dec'
    month{i} = 12;end
end
 months1 = month{1};
 months2 = month{2};
for i = 1:2
    r = 1;
    for j = 2:13
        total_day(year(i),1) = 0;
          if mod(year(i),4) == 0
             days(2) = 29;
               total_day(year(i),j) = total_day(year(i),j-1) + days(r);
              elseif  mod(year(i),4) ~= 0
               days(2) = 28;
               total_day(year(i),j) = total_day(year(i),j-1) + days(r);
          end
         r = r + 1; 
    end
end
%calculation of time
year(1) = y(4);
year(2) = y(k - 1);
if s(4) < s(k - 1)
    second = s(k - 1) - s(4);
elseif s(4) > s(k - 1)
    second = s(k - 1) - s(4) + 60;
    m(k - 1) = m(k - 1) - 1;
elseif s(4) == s(k - 1)
    second = 0;
end
if m(4) < m(k - 1)
    minute = m(k - 1) - m(4);
elseif m(4) > m(k - 1)
    minute = m(k - 1) - m(4) + 60;
    h(k - 1) = h(k - 1) - 1;
elseif m(4) == m(k - 1)
    minute = 0;
end
if h(4) < h(k - 1)
    hour = h(k - 1) - h(4);
elseif h(4) > h(k - 1)
    hour = h(k - 1) - h(4) + 24;
    d(k - 1) = d(k - 1) - 1;
elseif h(4) == h(k - 1)
    hour = 0;
end
if d(4) < d(k - 1)
    day = d(k - 1) - d(4);
elseif d(4) > d(k - 1)
    day = d(k - 1) - d(4) + days(month{1});
    month{2} = month{2} - 1;
elseif d(4) == d(k - 1)
    day = 0;
end 
if month{1} < month{2}
    months = month{2} - month{1};
elseif month{1} > month{2}
    months = month{2} - month{1} + 12;
   year(2) = year(2) - 1;
elseif month{1} == month{2}
    months = 0;
end
if year(1) < year(2)
    years = year(2) - year(1);
elseif year(1) == year(2)
    years = 0;
end
% calculation of second
year(1) = y(4);
year(2) = y(k - 1);
sum_days1 = 0;
for i = year(1):year(2)
if mod(i,4) == 0
sum_days1 = sum_days1 + 366;
elseif mod(i,4) ~= 0
sum_days1 = sum_days1 + 365;
end
end
if month{1}==1
     month{1}=2;
     total_day(year(1),months1 ) = 0;
 end
 if month{2}==1
     month{2}=2;
     total_day(year(2),months2 ) = 0;
 end
sum_days = sum_days1 - (total_day(year(1),months1) + d(4))...
- ((total_day(year(2),13)- total_day(year(2),months2)) - d(k - 1)); 
total_second = (sum_days*24*3600) + (hour*3600) + (minute*60) + second;
%  ---------------------------------------
clear data i file line temp text;
fprintf('\n');
%  ---------------------------------------
clear vasp;
fprintf('Starting     : %s\n',start);
fprintf('Finished     : %s\n\n',finish);
fprintf('\t\tTime spent\n');
fprintf('Year         : %0.f\n',years);
fprintf('Month        : %.0f\n',months);
fprintf('Day          : %0.f\n',day);
fprintf('Hour         : %0.f\n',hour);
fprintf('minute       : %0.f\n',minute);
fprintf('second       : %0.f\n\n',second);
fprintf('total day    : %0.f\n',sum_days);
fprintf('total second : %0.f sec\n',total_second);
fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;