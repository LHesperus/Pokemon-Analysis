clc
clear 
close all

%% 
xy=[1000 1000];
w_th=250;
sd_0 = imread('sd0.jpg');sd_0 = imresize(sd_0,xy);sd_0(sd_0>w_th)=255;sd_0(sd_0<=w_th)=0;
sd_1 = imread('sd1.jpg');sd_1 = imresize(sd_1,xy);sd_1(sd_1>w_th)=255;sd_1(sd_1<=w_th)=0;
sd_2 = imread('sd2.jpg');sd_2 = imresize(sd_2,xy);sd_2(sd_2>w_th)=255;sd_2(sd_2<=w_th)=0;
sd_3 = imread('sd3.jpg');sd_3 = imresize(sd_3,xy);sd_3(sd_3>w_th)=255;sd_3(sd_3<=w_th)=0;
sd_4 = imread('sd4.jpg');sd_4 = imresize(sd_4,xy);sd_4(sd_4>w_th)=255;sd_4(sd_4<=w_th)=0;
sd_5 = imread('sd5.jpg');sd_5 = imresize(sd_5,xy);sd_5(sd_5>w_th)=255;sd_5(sd_5<=w_th)=0;
sd_6 = imread('sd6.jpg');sd_6 = imresize(sd_6,xy);sd_6(sd_6>w_th)=255;sd_6(sd_6<=w_th)=0;
sd_7 = imread('sd7.jpg');sd_7 = imresize(sd_7,xy);sd_7(sd_7>w_th)=255;sd_7(sd_7<=w_th)=0;
sd_8 = imread('sd8.jpg');sd_8 = imresize(sd_8,xy);sd_8(sd_8>w_th)=255;sd_8(sd_8<=w_th)=0;
sd_9 = imread('sd9.jpg');sd_9 = imresize(sd_9,xy);sd_9(sd_9>w_th)=255;sd_9(sd_9<=w_th)=0;
save('sd_model.mat','sd_0','sd_1','sd_2','sd_3','sd_4','sd_5','sd_6','sd_7','sd_8','sd_9');

