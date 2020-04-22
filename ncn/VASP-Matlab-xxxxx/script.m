sc = [1,2,1];

p = 'C:\Users\Chen\Documents\dca\isochain2_flat_straight';
format long
type = 'c';

if strmatch(type, 'c')
    sc(3) = 2
end

[xyz, uv] = process(p, type);
f1 = figure();
all = view_cell(p, xyz, uv, sc);

%%edits%%
% figure()
% i = find(all(:,3)>-5&all(:,3)<7);
% new_all = all(i,:);
% figure()
% plot_all(new_all)

low = uv(3,3)*2/3;
high = uv(3,3)+low;

if sc(3)>1
    %close(f1)
    i = find(all(:,3)>low&all(:,3)<high);
    new_all = all(i,:);
    f2 = figure();
    plot_all(new_all);
end
    
%make_pos(all)
%supercell(p, new_all, uv, supercell)