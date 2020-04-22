function [closest, lateral, dir] = lateral_offset(i, radius, all)
format short
everything = all(find(all(:,4)==radius),:);
[row,col] = find(all(:,4)==radius);
index = find(all(:,4)==radius);
everything(:,1) = everything(:,1) - all(i,1);
everything(:,2) = everything(:,2) - all(i,2);
everything(:,3) = everything(:,3) - all(i,3);
v = [(sum(everything(:,1:3).^2,2)).^.5 row];
[w,j] = sort(v,1,'ascend');
closest = v(j(2:4),2)
c = center(all(closest(1),1:3),all(closest(2),1:3),all(closest(3),1:3), 'incenter');
dir = (transpose(c)-all(i,1:3))*-1;
offset = sum((transpose(c)-all(i,1:3)).^2)^.5;
lateral = sum((transpose(c(1:2))-all(i,1:2)).^2)^.5;

all(closest,5:6) = .2;
figure();
plot_all(all);

end