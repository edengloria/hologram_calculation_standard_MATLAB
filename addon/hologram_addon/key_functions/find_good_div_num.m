function division_num_out = find_good_div_num(division_num,size_to_be_divided)

division_list = [1 2 4 8 10 16 20 32 40 50 64 80 100 128 160 200 256 320 400 512 640 800 1024 1600 2048 3200 4096];
division_list =division_list.*(mod(size_to_be_divided./division_list,1) == 0);

division_num_out = division_list(find(division_list >= division_num,1));