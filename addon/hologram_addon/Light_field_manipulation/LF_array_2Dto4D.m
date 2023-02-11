function LF_array_4D = LF_array_2Dto4D(LF_array_2D,block_u,block_v)

LF_array_4D = zeros(size(LF_array_2D,1)/block_v,   size(LF_array_2D,2)/block_u,  block_v, block_u, size(LF_array_2D,3));

for cnt = 1:size(LF_array_2D,3)    
 temp = reshape(LF_array_2D(:,:,cnt) , size(LF_array_2D,1)/block_v,  block_v, size(LF_array_2D,2)/block_u, block_u);
 LF_array_4D(:,:,:,:,cnt) = permute(temp, [1 3 2 4]); 
end

end