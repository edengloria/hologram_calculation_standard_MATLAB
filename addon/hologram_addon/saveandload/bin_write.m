function bin_write(input,filename,output_size,input_posi);
     input_size = size(input);
     count1 = output_size(1)*(input_posi(2)-1)+input_posi(1)-1;
     fileID3 = fopen([filename '_real.bin'],'r+'); 
     fwrite(fileID3,real(input(:,1)),[num2str(input_size(1)) '*single'],4*(count1)); 
     fwrite(fileID3,real(input(:,2:end)),[num2str(input_size(1)) '*single'],4*(output_size(1)-input_size(1))); 
     dummy = fclose(fileID3); 
     
     
     
      fileID4 = fopen([filename '_imag.bin'],'r+'); 
     fwrite(fileID3,imag(input(:,1)),[num2str(input_size(1)) '*single'],4*(count1)); 
     fwrite(fileID3,imag(input(:,2:end)),[num2str(input_size(1)) '*single'],4*(output_size(1)-input_size(1))); 
      dummy = fclose(fileID4); 
end