if (k2 == k2x & k3 == k3x & k4 == k4x )
    plot_vertical=0;
elseif (k2 == 0.0 & k3 == 0.0 & k4 == 0.0 )
    labels(s) = {'G'};
    plot_vertical=1;
elseif (k2 == 0.5 & k3 == 0.0 & k4 == 0.0 )
    labels(s) = {'X'};
    plot_vertical=1;
elseif (k2 == 0.0 & k3 == 0.5 & k4 == 0.0 )
    labels(s) = {'X'};      % check
    plot_vertical=1;   
elseif (k2 == 0.0 & k3 == 0.0 & k4 == 0.5 )
    labels(s) = {'X'};      % check
    plot_vertical=1;
elseif (k2 == 0.5 & k3 == 0.5 & k4 == 0.0 )
    labels(s) = {'M'};
    plot_vertical=1;
elseif (k2 == 0.5 & k3 == 0.0 & k4 == 0.5 )
    labels(s) = {'M'};      % check
    plot_vertical=1;
elseif (k2 == 0.0 & k3 == 0.5 & k4 == 0.5 )
    labels(s) = {'M'};      % check
    plot_vertical=1;
elseif (k2 == 0.5 & k3 == 0.5 & k4 == 0.5 )
    labels(s) = {'R'};
    plot_vertical=1;
%elseif (k2 == 0.375 & k3 == 0.375 & k4 == 0.0 )
%    labels(s) = {'K'};
%    plot_vertical=1;
end