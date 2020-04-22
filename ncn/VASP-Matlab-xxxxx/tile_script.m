trigonal_tile = [];
[copper(2,1:3),0,0,0,0]
temp_shift = repmat([copper(i(j),1:3),0,0,0,0],78,1)
for j = 1:9
    temp_shift = repmat([copper(i(j),1:3),0,0,0,0],78,1);
    trigonal_tile = [trigonal_tile; total + temp_shift];
end

trigonal_tile = [copper; trigonal_tile];
plot_all(trigonal_tile)