
close all; %
addpath('./data');
addpath('./util');
load('img.mat');
figure;imagesc(img); colormap gray;axis off;title('Raw Image');
k = 4; %default
[res1,res2,res3,res4] = visual_attention_rw_2(img,k);
figure;imagesc(res1); colormap gray;axis off;title('Facet Kernel Map');
figure;imagesc(res2); colormap gray;axis off;title('NLCD_{cp} Map');
figure;imagesc(res3); colormap gray;axis off;title('NLCD_{hg} Map');
figure;imagesc(res4); colormap gray;axis off;title('Weighted Map');
