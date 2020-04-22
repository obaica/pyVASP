function dE = check_oszicar(path)

file = [path '\OSZICAR'];
fid=fopen(file);
flag1 = '   ';
flag2 = ' F=';
counter = 1;

while (~feof(fid))
   flag = [flag1 num2str(counter) flag2];
   line = fgetl(fid);
   if strmatch(flag,line(1:7))==1
       [t, r] = strtok(line);
       for i = 1:6
           [t,r] = strtok(r)
       end
       dE(counter) = str2num(r(3:end));
       counter = counter + 1;
   end
end

figure()
semilogy(abs(dE))

end