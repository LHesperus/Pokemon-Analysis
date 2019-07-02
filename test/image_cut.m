%%
clc
clear
close all

%%
pic = imread('001_CP13_HP10_SD200_6259_10.png');
imshow(pic);
% get pic size
x=size(pic,1);
y=size(pic,2);

pic_1 = imcrop(pic,[0.15*x 0.25*y 0.3*x 0.45*y]);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.jpg');

%%