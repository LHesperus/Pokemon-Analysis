clc
clear 
close all

%% 
n=12;
xy=[1000 1000];
w_th=250;
cp_c = imread('c.png');cp_c = imresize(cp_c,xy);cp_c(cp_c>w_th)=255;cp_c(cp_c<=w_th)=0;
cp_p = imread('p.png');cp_p = imresize(cp_p,xy);cp_p(cp_p>w_th)=255;cp_p(cp_p<=w_th)=0;
cp_0 = imread('0.png');cp_0 = imresize(cp_0,xy);cp_0(cp_0>w_th)=255;cp_0(cp_0<=w_th)=0;
cp_1 = imread('1.png');cp_1 = imresize(cp_1,xy);cp_1(cp_1>w_th)=255;cp_1(cp_1<=w_th)=0;
cp_2 = imread('2.png');cp_2 = imresize(cp_2,xy);cp_2(cp_2>w_th)=255;cp_2(cp_2<=w_th)=0;
cp_3 = imread('3.png');cp_3 = imresize(cp_3,xy);cp_3(cp_3>w_th)=255;cp_3(cp_3<=w_th)=0;
cp_4 = imread('4.png');cp_4 = imresize(cp_4,xy);cp_4(cp_4>w_th)=255;cp_4(cp_4<=w_th)=0;
cp_5 = imread('5.png');cp_5 = imresize(cp_5,xy);cp_5(cp_5>w_th)=255;cp_5(cp_5<=w_th)=0;
cp_6 = imread('6.png');cp_6 = imresize(cp_6,xy);cp_6(cp_6>w_th)=255;cp_6(cp_6<=w_th)=0;
cp_7 = imread('7.png');cp_7 = imresize(cp_7,xy);cp_7(cp_7>w_th)=255;cp_7(cp_7<=w_th)=0;
cp_8 = imread('8.png');cp_8 = imresize(cp_8,xy);cp_8(cp_8>w_th)=255;cp_8(cp_8<=w_th)=0;
cp_9 = imread('9.png');cp_9 = imresize(cp_9,xy);cp_9(cp_9>w_th)=255;cp_9(cp_9<=w_th)=0;

save('cp_model.mat','cp_c','cp_p','cp_0','cp_1','cp_2','cp_3','cp_4','cp_5','cp_6','cp_7','cp_8','cp_9');

