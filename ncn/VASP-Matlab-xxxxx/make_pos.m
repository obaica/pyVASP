function everything = make_pos(everything, uv, elements, slab)

[l,w] =size(everything);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WRITE NEW POSCAR FILE %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long
fileID = fopen('POSCAR','w');
fprintf(fileID,'temp \n');
fprintf(fileID,'1.0 \n');
for i=1:3
    fprintf(fileID, '%s %s %s\n', num2str(uv(i,1)), num2str(uv(i,2)), num2str(uv(i,3)));
end
fprintf(fileID, '%s \n', elements);
e = unique(everything(:,4), 'stable');
nums = [];
for i=1:length(e)
    j = find(everything(:,4)==e(i));
    nums = [nums length(j)];
end
fprintf(fileID, '%s \n', num2str(nums));
fprintf(fileID,'Selective Dynamics \n');
fprintf(fileID,'Cartesian \n');
for i=1:l
    if slab(1)==1
        fprintf(fileID, '%s \t \t \t T   T   T\n', num2str(everything(i,1:3)));
    else
        if everything(i,4) == 1.28
            fprintf(fileID, '%s \t \t \t F   F   F\n', num2str(everything(i,1:3)));
        else
            fprintf(fileID, '%s \t \t \t T   T   T\n', num2str(everything(i,1:3)));
        end
    end
end
fclose(fileID);

end