function [A_out] = mirror_matrix(A,sz)

A_out = padarray(A,[sz sz],'both','symmetric');
A_out(end-sz+1,:,:) = [];
A_out(:,end-sz+1,:) = [];
A_out(:,sz,:) = [];
A_out(sz,:,:) = [];

end