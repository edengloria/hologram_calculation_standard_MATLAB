function matrix_out = folded_toeplitz_2D(matrix_in,mn)

% [Ny  Nx]     = size(matrix_in);
[Nx  Ny]     = size(matrix_in);

M            = (Nx -1)/4;
N            = (Ny -1)/4;
NBx          = 2 * M + 1;
NBy          = 2 * N + 1;
L=NBx*NBy;
%type2 faster!! good!
tt1 = clock;
inner_toeplitz = zeros(NBy,NBy,Nx);
for m=1:Nx
inner_toeplitz(:,:,m) = folded_toeplitz_1D(matrix_in(m,:));
end
outer_toeplitz = folded_toeplitz_1D(1:Nx);
for m=1:NBx
    for n=1:NBx
        matrix_out((m-1)*NBy+1:m*NBy,(n-1)*NBy+1:n*NBy) = inner_toeplitz(:,:,outer_toeplitz(m,n));
    end
end
disp(['       done.  elapsed time : ' num2str(etime(clock,tt1))]); 

%type1 conventional
% tt2 = clock;
% for k=1:NBx
%     for l=1:NBy
%         od_ind1=(k-1)*NBy+l;
%         for kk=1:NBx
%             for ll=1:NBy
%                 od_ind2=(kk-1)*NBy+ll;
%                 matrix_out2(od_ind1,od_ind2)=matrix_in(k-kk+NBx,l-ll+NBy); %	Toeplits matrix of index modulation
% %                 matrix_out(od_ind2,od_ind1)=matrix_in(l-ll+NBy,k-kk+NBx); %	Toeplits matrix of index modulation
%             end;
%         end;
%     end;
% end;
% disp(['       done.  elapsed time : ' num2str(etime(clock,tt2))]); 
% sum(sum(abs(matrix_out-matrix_out2)))