function [v] = readObj(fname)

v = []; 

fid = fopen(fname);

% parse .obj file 
while 1    
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end  % exit at end of file 
     ln = sscanf(tline,'%s',1); % line type 
     %disp(ln)
    switch ln
        case 'v'   % mesh vertexs
            v = [v; sscanf(tline(2:end),'%f')'];
    end
end
fclose(fid);

% set up matlab object 
% obj.v = v; 
% v=v;
