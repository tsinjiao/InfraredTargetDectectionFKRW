function result = visual_attention_rw(img)
addpath('./util');
img = double(img)/255;
h = [1 1 1;1 0 1;1 1 1];
img_1 = ordfilt2(img,8,h);
con_idx = img./img_1;
tmp = ones(size(img));
tmp(logical(con_idx>1)) = 0;
img = img.*tmp + img_1.*(1-tmp);

h = fspecial('average',2);
img = imfilter(img,h,'conv','same','replicate');

k = 4;
[result,~] = rw_tgt_detect_main_2(img,k);


end