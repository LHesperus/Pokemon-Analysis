clc
clear 
close all

%% 
n=12;
xy=[1000 1000];
w_th=250;
hp_h = imread('h.png');hp_h = imresize(hp_h,xy);hp_h(hp_h>w_th)=255;hp_h(hp_h<=w_th)=0;
hp_p = imread('p.png');hp_p = imresize(hp_p,xy);hp_p(hp_p>w_th)=255;hp_p(hp_p<=w_th)=0;
hp_0 = imread('0.png');hp_0 = imresize(hp_0,xy);hp_0(hp_0>w_th)=255;hp_0(hp_0<=w_th)=0;
hp_1 = imread('1.png');hp_1 = imresize(hp_1,xy);hp_1(hp_1>w_th)=255;hp_1(hp_1<=w_th)=0;
hp_2 = imread('2.png');hp_2 = imresize(hp_2,xy);hp_2(hp_2>w_th)=255;hp_2(hp_2<=w_th)=0;
hp_3 = imread('3.png');hp_3 = imresize(hp_3,xy);hp_3(hp_3>w_th)=255;hp_3(hp_3<=w_th)=0;
hp_4 = imread('4.png');hp_4 = imresize(hp_4,xy);hp_4(hp_4>w_th)=255;hp_4(hp_4<=w_th)=0;
hp_5 = imread('5.png');hp_5 = imresize(hp_5,xy);hp_5(hp_5>w_th)=255;hp_5(hp_5<=w_th)=0;
hp_6 = imread('6.png');hp_6 = imresize(hp_6,xy);hp_6(hp_6>w_th)=255;hp_6(hp_6<=w_th)=0;
hp_7 = imread('7.png');hp_7 = imresize(hp_7,xy);hp_7(hp_7>w_th)=255;hp_7(hp_7<=w_th)=0;
hp_8 = imread('8.png');hp_8 = imresize(hp_8,xy);hp_8(hp_8>w_th)=255;hp_8(hp_8<=w_th)=0;
hp_9 = imread('9.png');hp_9 = imresize(hp_9,xy);hp_9(hp_9>w_th)=255;hp_9(hp_9<=w_th)=0;
hp_div = imread('div.png');hp_div = imresize(hp_div,xy);hp_div(hp_div>w_th)=255;hp_div(hp_div<=w_th)=0;





save('hp_model.mat','hp_h','hp_p','hp_div','hp_0','hp_1','hp_2','hp_3','hp_4','hp_5','hp_6','hp_7','hp_8','hp_9');
hp_model=load('hp_model.mat');
save('aaa.mat','hp_model')
aaa=load('aaa.mat')