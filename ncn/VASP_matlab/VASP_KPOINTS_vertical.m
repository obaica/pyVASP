VASP_KPT;

if plot_vertical>0
    % k_point(s) = str2double(text{2});  
    k_point(s) = i-num;
    x = linspace(k_point(s),k_point(s),length(y));
    hold on;
    plot(x,y,'k--');
    s = s+1;
    plot_vertical = 0;
    k2x = k2;
    k3x = k3;
    k4x = k4;
end