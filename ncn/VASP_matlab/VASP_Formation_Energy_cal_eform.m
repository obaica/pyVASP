% Calculate formation energy
x   = [0:0.1:2];


for k=1:natoms
    fprintf('\n---------------------------------------------------------------');
    if defect=='v'
        fprintf('\nNative %s vacancy defect\n',chm{k});
        tt=strcat(chm{k},' vacancy defect');
        leg2{nleg}=strcat(chm{k},' vacancy');
    elseif defect=='i'
        fprintf('\nNative %s interstitial defect\n',chm{k});
        tt=strcat(chm{k},' interstitial defect');
        leg2{nleg}=strcat(chm{k},' interstitial');
    elseif defect=='a'
        fprintf('\nNative %s antisite defect\n',chm{k});
        tt=strcat(chm{k},' antisite defect');
        leg2{nleg}=strcat(chm{k},' antisite');
    end
    temp = input('Number of charge state : ','s');
    nchg = str2double(temp);
    y    = zeros(length(x),nchg);
    figure('position', [0, 0, 350, 450]);
    
    for l=1:nchg
        fprintf('\n');
        temp = input('Charge state : ','s');
        chg(l) = str2double(temp);
        leg{l} = temp;
        vasp_input;
        read_etoten;
        e_defect(k,l) = toten;  
        if defect=='v'
            fprintf('>> %s vacancy (charge %d) defect total energy  : %0.6f eV\n',chm{k},chg(l),e_defect(k,l));
            c(l) = e_defect(k,l) - e_bulk_SC + e_chm(k) + (chg(l)*VBM);
        elseif defect=='i'
            fprintf('>> %s interstitial (charge %d) defect total energy  : %0.6f eV\n',chm{k},chg(l),e_defect(k,l));
            c(l) = e_defect(k,l) - e_bulk_SC - e_chm(k) + (chg(l)*VBM);
        elseif defect=='a'
            fprintf('>> %s antisite (charge %d) defect total energy  : %0.6f eV\n',chm{k},chg(l),e_defect(k,l));
            if k==1
                kk=k+1;
            elseif k==2
                kk=k-1;
            end
            c(l) = e_defect(k,l) - e_bulk_SC - e_chm(k) + e_chm(kk) + (chg(l)*VBM);
        end
        y(:,l) = (chg(l)*x)+c(l);
        plot(x,y(:,l),'color',col(l,:));
        title(tt);
        hold on;
    end
    legend(leg);
    
    
    VASP_Formation_Energy_cal_intersection;
    VASP_Formation_Energy_plot_all;
end