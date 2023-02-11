function Function_2DFFT_CPUover(filename_in,filename_out);
global GPU_max_Nx Ny Nx;
filename_temp = 'FFT_temp';

%% 분할 FFT 도입하자
decision_factor = GPU_max_Nx;
div_num = 2^ceil(log2((Nx)^2/(decision_factor*1.2)^2));
div_num = find_good_div_num(div_num,Nx);

bin_create_zero(Ny*Nx,filename_temp);    

disp(['       division_num : ' num2str(div_num)]);
t3=clock;
for cnt1 = 1:1:div_num
disp(['       Iteration part 1 : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =  Nx/(div_num);

temp = bin_read(filename_in,[Ny Nx],[Ny length(Nx_div*(cnt1-1)+1:Nx_div*cnt1)],[1 Nx_div*(cnt1-1)+1]); 
temp = ifftshift(  fft(  fftshift(    gpuArray(temp)  ,1) ) ,1);
bin_write(gather(temp),filename_temp,[Ny Nx],[1 Nx_div*(cnt1-1)+1]);     
end    

%%
% bin_delete(filename_in);

decision_factor = GPU_max_Nx;
div_num = 2^ceil(log2((Nx)^2/(decision_factor*1.2)^2));
div_num = find_good_div_num(div_num,Nx);

%%
bin_create_zero(Ny*Nx,filename_out);  
 
for cnt1 = 1:1:div_num
disp(['       Iteration part 2 : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =   Nx/(div_num);
  
temp = bin_read(filename_temp,[Ny Nx],[length(Nx_div*(cnt1-1)+1:Nx_div*cnt1) Nx],[Nx_div*(cnt1-1)+1 1]); 
temp = ifftshift(fft(fftshift(gpuArray(temp).',1)),1).';

bin_write(gather(temp),filename_out,[Ny Nx],[Nx_div*(cnt1-1)+1 1]);     

end

% bin_delete(filename_temp);

 disp(['  "Loop 1&2" calculation time : ' num2str(etime(clock,t3))]);

%%
end