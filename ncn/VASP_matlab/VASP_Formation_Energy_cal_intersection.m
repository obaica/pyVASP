%calculate intersection n-1 fac
    for m=1:nchg
        for n=1:nchg
            if (m>n)
                xx=(c(n)-c(m))/(chg(m)-chg(n));
                if (xx>=0)&(xx<=2)
                    fprintf('\nIntersection %d/%d : %0.4f',chg(m),chg(n),xx);
                    yy = (chg(m)*xx)+c(m);
                    plot(xx,yy,'k.','MarkerSize',10);
                    hold on;
                end
            end
        end
    end
    hold off;