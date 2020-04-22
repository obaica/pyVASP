% Calculate formation energy
x   = [0:0.1:2];


    fprintf('\n---------------------------------------------------------------');
    if defect=='oi'
        fprintf('\n%s interstitial defect\n',chm{natoms+1});
        tt=strcat(chm{natoms+1},' interstitial defect');
        leg2{nleg}=strcat(chm{natoms+1},' interstitial');
    elseif defect=='oa'
        fprintf('\n%s antisite defect\n',chm{natoms+1});
        tt=strcat(chm{natoms+1},' antisite defect');
        leg2{nleg}=strcat(chm{natoms+1},' antisite');
    end
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
        if defect=='oi'
            fprintf('>> %s interstitial (charge %d) defect total energy  : %0.6f eV\n',chm{natoms+1},chg(l),e_defect(k,l));
            c(l) = e_defect(k,l) - e_bulk_SC - e_chm(natoms+1) + (chg(l)*VBM);
        elseif defect=='oa'
            fprintf('>> %s antisite (charge %d) defect total energy  : %0.6f eV\n',chm{natoms+1},chg(l),e_defect(k,l));
            c(l) = e_defect(k,l) - e_bulk_SC + e_chm(natoms) - e_chm(natoms+1) + (chg(l)*VBM);
        end
        y(:,l) = (chg(l)*x)+c(l);
        plot(x,y(:,l),'color',col(l,:));
        title(tt);
        hold on;
    end
    legend(leg);
    
    
    VASP_Formation_Energy_cal_intersection;
    VASP_Formation_Energy_plot_all;