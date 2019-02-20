function [out1, out2, out3, out4] = visual_attention_rw_2(img,k)
addpath('./util');
img = double(img)/255;
h = [1 1 1;1 0 1;1 1 1];
img_1 = ordfilt2(img,8,h);
con_idx = img./img_1;
tmp = ones(size(img));
tmp(logical(con_idx>1)) = 0;
img = img.*tmp+img_1.*(1-tmp);
h = fspecial('average',2);
img = imfilter(img,h,'conv','same','replicate');

im = img;
L = [-4 -1 0 -1 -4; -1 2 3 2 -1; 0 3 4 3 0;  -1 2 3 2 -1; -4 -1 0 -1 -4];
img_dog = conv2(mirror_matrix(im,3),L,'valid');


%% Th detection 

Th = mean(mean(img_dog))+ k * sqrt(var(img_dog(:)));
img_idx = ones(size(img_dog));
img_idx(img_dog < Th)= 0;
out1 = img_dog;
out1(img_dog < Th) = 0;
out1 = out1 ./(max(out1(:))+0.000001);

patch = 11;
im_m = mirror_matrix(im,(patch+1)/2);
im_out = zeros(size(im_m));
out2 = im_out;
out3 = im_out;
[p_idx_r,p_idx_c] = find(img_idx==1);
im_v = im(img_idx==1);
[~,I] = sort(im_v,'descend');
p_idx_r = p_idx_r(I);
p_idx_c = p_idx_c(I);

FLAG = zeros(size(im_out));

for i = 1 : length(p_idx_r)

    r_pos = p_idx_r(i) + (patch-1)/2;
    c_pos = p_idx_c(i) + (patch-1)/2;
    if FLAG(r_pos,c_pos) == 1
        continue;
    end
    img = im_m(r_pos-(patch-1)/2 : r_pos+(patch-1)/2, ...
               c_pos-(patch-1)/2 : c_pos+(patch-1)/2);
 
    [X, Y]=size(img);   
    
    s1x=(patch+1)/2; s1y=(patch+1)/2;  
    img_2 = img;
    img_2(:,1) = 1;
    img_2(:,end) = 1;
    img_2(1,:) = 1;
    img_2(end,:) = 1;
    
    idx = find(img_2==1);
    [mask,prob] = random_walker(img,[sub2ind([X Y],s1y,s1x),idx'],[1,2*ones(1,length(idx))],200);
    prob_t   = prob(:,:,1);
    if sum(sum(logical(mask == 1))) == 1
        im_out(r_pos,c_pos) = 0;
        FLAG(r_pos,c_pos) = 1;
        continue;
    end
    mask(s1x,s1y) = 2; 
    prob_res = mean(prob_t(mask==1));
    prob_res = prob_res/mean(prob_t(mask~=1));
    mask(s1x,s1y) = 1; 
    iten_res = local(mask,img);
    [idx_r,idx_c] = find(mask==1);
    for j = 1 : length(idx_r) 
        if FLAG(r_pos -(patch-1)/2 + idx_r(j) - 1, c_pos -(patch-1)/2 + idx_c(j) - 1) == 1
           continue;
        end
        im_out(r_pos -(patch-1)/2 + idx_r(j) - 1, c_pos -(patch-1)/2 + idx_c(j) - 1) ...
               = prob_res  * iten_res ^ 6;
        out2(r_pos -(patch-1)/2 + idx_r(j) - 1, c_pos -(patch-1)/2 + idx_c(j) - 1) = prob_res;
        out3(r_pos -(patch-1)/2 + idx_r(j) - 1, c_pos -(patch-1)/2 + idx_c(j) - 1) = iten_res^6;
        FLAG(r_pos -(patch-1)/2 + idx_r(j) - 1, c_pos -(patch-1)/2 + idx_c(j) - 1) = 1;
        
    end

end
out2 = out2((patch-1)/2+1:end-(patch-1)/2,(patch-1)/2+1:end-(patch-1)/2);
out3 = out3((patch-1)/2+1:end-(patch-1)/2,(patch-1)/2+1:end-(patch-1)/2);
out2 = out2 ./(max(out2(:))+0.000001);
out3 = out3 ./(max(out3(:))+0.000001);

im_out = im_out((patch-1)/2+1:end-(patch-1)/2,(patch-1)/2+1:end-(patch-1)/2);
im_out = im_out .* img_dog;
im_out = im_out ./(max(im_out(:))+0.000001);

out4 = im_out;

end



function inten = local(mask,img)

[X,Y] = size(mask);
tgt_mean = mean(img(mask==1));
 

mask((X+1)/2,(Y+1)/2) = 2;
[r_seq,~]  = find(mask ==1);
if isempty(r_seq)
    inten = 0;
    return;
end

mask((X+1)/2,(Y+1)/2) = 1;
mask(mask==2) = 0;
 
SE = strel('disk',2);
img_mid = imdilate(mask,SE);
 

SE = strel('disk',2);
img_ex = imdilate(img_mid,SE);
 

diff2 = img_ex - img_mid;

tmp = img(logical(diff2==1));
if max(max(tmp)) >= tgt_mean
    inten =  0;
else
    inten =  tgt_mean/(max(max(tmp)));
 
end

end