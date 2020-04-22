function all = fscript(p,sc)

%p = 'C:\Users\Chen\Documents\dca\isochain_loose';
format long
[xyz, res, uv] = process(p, 'c');
figure()
all = view_cell(p, xyz, uv, sc);
%%edits%%
% figure()
% i = find(all(:,3)>-5&all(:,3)<5);
% new_all = all(i,:);
% figure()
% plot_all(new_all)

i = find(all(:,3)>10&all(:,3)<25);
new_all = all(i,:);
figure()
plot_all(new_all)

%make_pos(all)
%supercell(p, new_all, uv, supercell)

end