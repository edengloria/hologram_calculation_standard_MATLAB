function holo_save(filename2,complex_sum,px,py,lambda,Nx,Ny,theta_ref,phi_ref,image_center);
% ���� �ӵ� ���� ��� -> complex_sum �� �и��Ͽ� bin file�� �����ϰ�, �������� matfile�� ����
 save([filename2 '.mat'],'px','py','lambda','Nx','Ny','theta_ref','phi_ref','image_center','-v7.3','-nocompression');
 if strcmp(complex_sum,'not used') == 1
 % already saved
 else
 fileID_r = fopen([filename2 '_real.bin'],'w'); fileID_i = fopen([filename2 '_imag.bin'],'w');
 fwrite(fileID_r,real(complex_sum),'single'); fwrite(fileID_i,imag(complex_sum),'single');  
 fclose(fileID_r); fclose(fileID_i);
 end
end