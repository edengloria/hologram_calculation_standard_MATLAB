function holo_save(filename2,complex_sum,px,py,lambda,Nx,Ny,theta_ref,phi_ref,image_center);
% 저장 속도 대폭 향상 -> complex_sum 은 분리하여 bin file로 저장하고, 나머지만 matfile로 저장
 save([filename2 '.mat'],'px','py','lambda','Nx','Ny','theta_ref','phi_ref','image_center','-v7.3','-nocompression');
 if strcmp(complex_sum,'not used') == 1
 % already saved
 else
 fileID_r = fopen([filename2 '_real.bin'],'w'); fileID_i = fopen([filename2 '_imag.bin'],'w');
 fwrite(fileID_r,real(complex_sum),'single'); fwrite(fileID_i,imag(complex_sum),'single');  
 fclose(fileID_r); fclose(fileID_i);
 end
end