function everything = plot_all(everything)

coord_list = everything(:,1:3);
radii = everything(:,4);
colors = everything (:,5:end);
colors = colors/ max(max(colors));

%%%%%%%%%%%%%%%%%%%%%
%% PLOT EVERYTHING %%
%%%%%%%%%%%%%%%%%%%%%

% output = [coord_list(:,1), coord_list(:,2), coord_list(:,3), transpose(radii), colors]
% size(output)

bubbleplot3(coord_list(:,1), coord_list(:,2), coord_list(:,3), radii, colors);
camlight right; lighting phong; view(80,20);
% figure()
% scatter3(coord_list(:,1), coord_list(:,2), coord_list(:,3))

end