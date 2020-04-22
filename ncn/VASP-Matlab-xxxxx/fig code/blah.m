vis_sub = dark_and_vis;
pot = dark_and_vis(:,1);
vis_sub(:,1) = dark_and_vis(:,4*2)-dark_and_vis(:,8*2);
vis_sub(:,2) = dark_and_vis(:,2*2)-dark_and_vis(:,5*2);
vis_sub(:,3) = dark_and_vis(:,1*2)-dark_and_vis(:,6*2);
vis_sub(:,4) = dark_and_vis(:,3*2)-dark_and_vis(:,7*2);
figure()
hold on
for i=1:4
    plot(pot,vis_sub(:,i))
end