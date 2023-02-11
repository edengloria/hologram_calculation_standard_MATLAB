function output = bin_read(filename,input_size,output_size,output_posi);

     fileID1 = fopen([filename '_real.bin'],'r'); 
     dummy = fread(fileID1,output_posi(2)-1,'single=>single',4*(input_size(1)-1));
     dummy = fread(fileID1,output_posi(1)-1,'single=>single'); 
     output = fread(fileID1,[output_size(1) output_size(2)],[num2str(output_size(1)) '*single=>single'],4*(input_size(1)-output_size(1))); 
     dummy = fclose(fileID1); 
    
     
      fileID2 = fopen([filename '_imag.bin'],'r'); 
      dummy = fread(fileID2,output_posi(2)-1,'single=>single',4*(input_size(1)-1));
      dummy = fread(fileID2,output_posi(1)-1,'single=>single'); 
      output = output + 1j*fread(fileID2,[output_size(1) output_size(2)],[num2str(output_size(1)) '*single=>single'],4*(input_size(1)-output_size(1))); 
      dummy = fclose(fileID2); 
     
end