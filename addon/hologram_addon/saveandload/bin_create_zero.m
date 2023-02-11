function bin_create_zero(size_num,filename)
global CPU_max_Nx;

division_num = ceil(size_num/(CPU_max_Nx*2.5).^2);
division_num = find_good_div_num(division_num,size_num);

if division_num == 1
     fileID = fopen([filename '_real.bin'],'w');
     fwrite(fileID,zeros(size_num,1,'single'),'single'); 
     fclose(fileID); 
else 
     fileID = fopen([filename '_real.bin'],'a+');
     temp = zeros(size_num/division_num,1,'single');
     for cnt = 1:division_num
     fwrite(fileID,temp,'single');
     end
     fclose(fileID); 
end

     st = copyfile([filename '_real.bin'], [filename '_imag.bin']);     
end