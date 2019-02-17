
close all; %
addpath('./data');
addpath('./util');
load('img.mat');
i = 1;
figure;imagesc(img);colormap(gray);axis off;title('Raw Image');
result = visual_attention_rw(img);
figure;imagesc(result);colormap(gray);axis off;title('Weighted Map');
