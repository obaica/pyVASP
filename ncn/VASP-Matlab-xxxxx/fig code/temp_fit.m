o2_fit = zeros(100,5);
x_space = linspace(-1,5);
counter = 0;
figure()
hold on
for x = 1:5
    [coeff,temp] = polyfit0(o2(1:end-1,x+counter), o2(1:end-1,x+counter+1),1)
    plot(o2(:,x+counter), o2(:,x+counter+1), 'o');
    o2_fit(:,x) = x_space*coeff;
    plot(x_space, o2_fit(:,x));
    counter = counter+1
end
