function LF_array_2D = LF_array_4Dto2D(LF_array_4D)

LF_array_2D = zeros(size(LF_array_4D,1)*size(LF_array_4D,3),size(LF_array_4D,2)*size(LF_array_4D,4),size(LF_array_4D,5));

for cnt = 1:size(LF_array_4D,5)
 temp = permute(squeeze(LF_array_4D(:,:,:,:,cnt)) ,[1 3 2 4]);
 LF_array_2D(:,:,cnt) = reshape(temp,size(LF_array_4D,1)*size(LF_array_4D,3),size(LF_array_4D,2)*size(LF_array_4D,4)); 
end

end