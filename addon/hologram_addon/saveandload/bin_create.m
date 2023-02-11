function bin_create(input,filename)
     fileID = fopen([filename '_real.bin'],'w');
     fwrite(fileID,real(input),'single'); 
     fclose(fileID); 
     
     fileID = fopen([filename '_imag.bin'],'w');
     fwrite(fileID,imag(input),'single'); 
     fclose(fileID);      
end