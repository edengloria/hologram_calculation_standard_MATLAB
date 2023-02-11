
     load([filename '.mat']);  %complex_sum 을 빼고 불러온다 % 2020/08/23
     if ~exist('complex_sum','var')
     if CPU_max_Nx*2 >= Nx
     fileID_r = fopen([filename '_real.bin'],'r'); fileID_i = fopen([filename '_imag.bin'],'r');
     complex_sum = fread(fileID_r,[Ny Nx],'single=>single') + 1j*fread(fileID_i,[Ny Nx],'single=>single');
     fclose(fileID_r); fclose(fileID_i);
     else
     complex_sum = 'not used';    
     end
     end