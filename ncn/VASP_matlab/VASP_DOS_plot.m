clear;
clf;

% -----------------------------------------------------
% Read data from VASP
fprintf('\n');
fprintf('\n>> Read Total DOS from DOS');
nedos = 301;
vasp = 'D:\Google Drive\VASP_works\HCNH22PbX3\HCNH22PbI3\04-DOS';
% vasp = 'D:\Google @KMITL\VASP_works\CH3NH3PbX3\CH3NH3PbI3\MALI_00_00\GGA-PBE\03_BAND';

% -----------------------------------------------------
if ispc
    doscar  = [vasp,'\TDOS.txt'];
else
    doscar  = [vasp,'/TDOS.txt'];
end
file  = fopen(doscar,'rt');

for i=1:nedos
    temp = fgetl(file);
    [text,temp]  = strtok(temp);
    TDOS(i,1)    = str2double(text);
    [text,temp]  = strtok(temp);
    TDOS(i,2)    = str2double(text);
    [text,temp]  = strtok(temp);
    TDOS(i,3)    = str2double(temp);
end
fclose(file);
% -----------------------------------------------------

% -----------------------------------------------------
if ispc
    doscar  = [vasp,'\DOS_FA.txt'];
else
    doscar  = [vasp,'/DOS_FA.txt'];
end
file  = fopen(doscar,'rt');

for i=1:nedos
    temp = fgetl(file);
    [text,temp]  = strtok(temp);
    DOS_MA(i,1)  = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_MA(i,2)  = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_MA(i,3)  = str2double(text);
    DOS_MA(i,4)  = str2double(temp);
end
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
if ispc
    doscar  = [vasp,'\DOS_Pb.txt'];
else
    doscar  = [vasp,'/DOS_Pb.txt'];
end
file  = fopen(doscar,'rt');

for i=1:nedos
    temp = fgetl(file);
    [text,temp]  = strtok(temp);
    DOS_Pb(i,1)  = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_Pb(i,2)  = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_Pb(i,3)  = str2double(text);
    DOS_Pb(i,4)  = str2double(temp);
end
fclose(file);
% -----------------------------------------------------


% -----------------------------------------------------
if ispc
    doscar  = [vasp,'\DOS_I.txt'];
else
    doscar  = [vasp,'/DOS_I.txt'];
end
file  = fopen(doscar,'rt');

for i=1:nedos
    temp = fgetl(file);
    [text,temp]  = strtok(temp);
    DOS_I(i,1)   = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_I(i,2)   = str2double(text);
    [text,temp]  = strtok(temp);
    DOS_I(i,3)   = str2double(text);
    DOS_I(i,4)   = str2double(temp);
end
fclose(file);
% -----------------------------------------------------

cmap = colormap(hsv(3));

% ----------------------------
figure(1);
subplot(3,1,1);
plot(DOS_MA(:,1),DOS_MA(:,2),'-','Color',cmap(1,:));
hold on;
plot(DOS_MA(:,1),DOS_MA(:,3),'-','Color',cmap(3,:));
hold on;
plot(TDOS(:,1),TDOS(:,2),'k:');
axis([-10,7,0,10]);
xx=gca;
set(xx,'XTick',[-10:1:8]);
set(xx,'YTick',[0:2:10]);
title('HC(NH2)2');
ylabel('DOS');

subplot(3,1,2);
plot(DOS_Pb(:,1),DOS_Pb(:,2),'-','Color',cmap(1,:));
hold on;
plot(DOS_Pb(:,1),DOS_Pb(:,3),'-','Color',cmap(3,:));
hold on;
plot(DOS_Pb(:,1),DOS_Pb(:,4),'-','Color',cmap(2,:));
hold on;
plot(TDOS(:,1),TDOS(:,2),'k:');
axis([-10,7,0,10]);
xx=gca;
set(xx,'XTick',[-10:1:8]);
set(xx,'YTick',[0:2:10]);
title('Pb');
ylabel('DOS');


subplot(3,1,3);
plot(DOS_I(:,1),DOS_I(:,2),'-','Color',cmap(1,:));
hold on;
plot(DOS_I(:,1),DOS_I(:,3),'-','Color',cmap(3,:));
hold on;
plot(DOS_I(:,1),DOS_I(:,4),'-','Color',cmap(2,:));
hold on;
plot(TDOS(:,1),TDOS(:,2),'k:');
axis([-10,7,0,10]);
xx=gca;
set(xx,'XTick',[-10:1:8]);
set(xx,'YTick',[0:2:10]);
title('I');
ylabel('DOS');
legend({'s-dos','p-dos','d-dos'},'Orientation','horizontal','Position',[0.5,0,0,0.1]);
legend('boxoff');
