ld = zeros(4,4);
counter = 1;

%%isochain_loose
sc = [1,1,2];
p = 'C:\Users\Chen\Documents\dca\isochain_loose';
format long
[xyz, res, uv] = process(p, 'c');
figure()
all = view_cell(p, xyz, uv, sc);
i = find(all(:,3)>10&all(:,3)<25);
new_all = all(i,:);
figure()
plot_all(new_all)
test = new_all;
test = [new_all(1:65,:); new_all(69:end,:)]
test = [new_all(66,:); test]
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;
test(1,:) = new_all(67,:);
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;
test(1,:) = new_all(68,:);
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;

%%isochain_float
sc = [1,1,2];
p = 'C:\Users\Chen\Documents\dca\isochain_float';
[xyz, res, uv] = process(p, 'c');
figure()
all = view_cell(p, xyz, uv, sc);
i = find(all(:,3)>10&all(:,3)<25);
new_all = all(i,:);
figure()
plot_all(new_all)
test = new_all;
test = [new_all(1:65,:); new_all(69:end,:)]
test = [new_all(66,:); test]
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;
test(1,:) = new_all(67,:);
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;
test(1,:) = new_all(68,:);
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;

%% isotrigonal float
sc = [2,2,1];
p = 'C:\Users\Chen\Documents\dca\isotrigonal_float';
[xyz, res, uv] = process(p, 'c');
figure()
all = view_cell(p, xyz, uv, sc);
test = [all(1:526,:); all(528:end,:)];
test = [all(527,:); test];
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;


%% isotrigonal
sc = [2,2,1];
p = 'C:\Users\Chen\Documents\dca\isotrigonal';
[xyz, res, uv] = process(p, 'c');
figure()
all = view_cell(p, xyz, uv, sc);
test = [all(1,:); all(3:end,:)];
test = [all(2,:); test];
[c,l,d] = lateral_offset(1,1.28,test);
ld(counter,:) = [l d];
counter = counter + 1;

'isochain_loose, isochain_float, isotrigonal, isotrigonal_float'
ld
