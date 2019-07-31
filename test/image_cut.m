%%
clc
clear
close all

%%
pic = imread('001_CP13_HP10_SD200_6259_10.png');
imshow(pic);
% get pic size
x=size(pic,2);
y=size(pic,1);
xy=[0.30*x 0.16*y 0.4*x 0.24*y]
pic_1 = imcrop(pic,xy);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.jpg');

%%
%img_path = './train/';
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);

for ii=1:img_num
  ii
pic = imread([img_path,img_dir(ii).name]);
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
x=size(pic,2);
y=size(pic,1);
pic_1 = imcrop(pic,xy);%cut
%pic_1= rgb2gray(pic_1);pic_1=edge(pic_1, 'Canny');
imshow(pic_1)
end