% Calculate formation energy
x   = [0:0.1:2];


    fprintf('\n---------------------------------------------------------------');
    fprintf('\nO antisite/N vacancy complex defect\n');
    tt=strcat('O antisite/N vacancy complex defect');
    leg2{nleg}=strcat('O antisite/N vacancy');
    
    temp = input('Number of charge state : ','s');
    nchg = str2double(temp);
    y    = zeros(length(x),nchg);
    figure('position', [0, 0, 350, 450]);
    k=1;
    
    for l=1:nchg
        fprintf('\n');
        temp = input('Charge state : ','s');
        chg(l) = str2double(temp);
        leg{l} = temp;
        vasp_input;
        read_etoten;
        e_defect(k,l) = toten;  
        
        fprintf('>> O antisite/N vacancy (charge %d) defect total energy  : %0.6f eV\n',chg(l),e_defect(k,l));
        c(l) = e_defect(k,l) - e_bulk_SC + 2*e_chm(2) - e_chm(3) + (chg(l)*VBM);
        
        y(:,l) = (chg(l)*x)+c(l);
        plot(x,y(:,l),'color',col(l,:));
        title(tt);
        hold on;
    end
    legend(leg);
    
    
    VASP_Formation_Energy_cal_intersection;
    VASP_Formation_Energy_plot_all;