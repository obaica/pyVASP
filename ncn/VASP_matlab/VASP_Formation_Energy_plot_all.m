%from x0 to x1 choose ?
    fprintf('\n\n');
    fig_all=figure(100);
    set(fig_all,'position', [300, 300, 500, 450]);
    x0=0;
    while(1)
        temp = input('Intersection [0:quit] : ','s');
        if temp=='0'
            break;
        end
        x1 = str2double(temp);
        xx = linspace(x0,x1,20);
        fprintf('from %0.4f - %0.4f ',x0,x1);
        temp = input('Select charge  : ','s');
        chg_read = str2double(temp);
        for ll=1:nchg
            if chg_read==chg(ll)
                l=ll;
            end
        end
        yy = (chg(l)*xx)+c(l);
        if oxy==1
            plot(xx',yy,'color',col(cc,:),'LineStyle','--');
        else
            plot(xx',yy,'color',col(cc,:));
        end
        hold on;
        x0=x1;
    end
    x1 = 2;
    xx = linspace(x0,x1,20);
    fprintf('from %0.4f - %0.4f ',x0,x1);
    temp = input('Select charge  : ','s');
    chg_read = str2double(temp);
        for ll=1:nchg
            if chg_read==chg(ll)
                l=ll;
            end
        end
    yy = (chg(l)*xx)+c(l);
    if oxy==1
        plot(xx',yy,'color',col(cc,:),'LineStyle','--');
    else
        plot(xx',yy,'color',col(cc,:));
    end
    cc   = cc+1;
    nleg = nleg+1;