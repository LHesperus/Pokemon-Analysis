%%
clc
clear
close all

%%  get SD part
pic = imread('007_CP132_HP28_SD600_8071_9.png');
imshow(pic);
% get pic size
x=size(pic,2);%����
y=size(pic,1);%����
xy=[0.15*x 0.7*y  0.55*x 0.2*y ];
pic_1 = imcrop(pic,xy);%cut

figure,imshow(pic_1);
pic_1 = rgb2gray(pic_1);% to gray
pic_1=imresize(pic_1,[1000,1000]);
figure
imshow(pic_1)

w_th=220;
pic_1(pic_1>w_th)=255;

pic_1(pic_1<=w_th)=0;
figure
imshow(pic_1)

%% ��С����
y=size(pic_1,1);%����
for ii=1:y%�ҵ��м�
    b_n=sum(sum(pic_1(ii:ii+2,1:10)==0));
    if b_n>10
        pic_1=pic_1(ii:ii+333,:);
        break;
    end
end
figure;imshow(pic_1)
x=size(pic_1,2);%����
%�ҵ�����
flag=0;
for ii=1:x
    b_n=sum(sum(pic_1(:,ii:ii+2)==0));
    if b_n==0
        flag=1;
    end
    if b_n>10 &&flag==1
        pic_1=pic_1(:,ii:ii+round(0.3*x));
        break;
    end
end
figure;imshow(pic_1)
%% ��һ����С��Χ
x=size(pic_1,2);%����
y=size(pic_1,1);%����
flag=0;
for ii=1:x%�ҵ��������
    b_n=sum(sum(pic_1(:,ii:ii+3)==0));
    if b_n==0
        flag=1;
    end
    if b_n>10 &&flag==1
        pic_1=pic_1(:,ii:end);
        break;
    end
end
figure;imshow(pic_1)
x=size(pic_1,2);%����
if x>200
    x=200;
end
for ii=x:-1:1%�ҵ��ұ�����
    b_n=sum(sum(pic_1(:,ii-2:ii)==0));
    if b_n>10 
        pic_1=pic_1(:,1:ii);
        break;
    end
end
figure;imshow(pic_1)

%% ȥ�����¿հ�
y=size(pic_1,1);
flag=0;
for ii=1:y
    b_n=sum(sum(pic_1(ii:ii+2,:)==0));
    if b_n>30&&flag==0
        flag=1;
        ii_temp=ii;
    end
    if b_n==0 && flag==1
        pic_1=pic_1(ii_temp:ii,:);
        break;
    end
end
figure;imshow(pic_1)
%% �ж��ַ������ָ�
x=size(pic_1,2);%�ַ�����
if x>=100&&x<140 %3���ַ�
        ch_len=round(x/3);
        pic_sd1=imresize(pic_1(:,1:ch_len),[1000 1000]);
        pic_sd2=imresize(pic_1(:,ch_len+1:2*ch_len),[1000 1000]);
        pic_sd3=imresize(pic_1(:,2*ch_len:end),[1000 1000]);
        figure;imshow(pic_sd1)
        figure;imshow(pic_sd2)
        figure;imshow(pic_sd3)
end
if x>=140&&x<200%4���ַ�
        ch_len=round(x/4);
        pic_sd1=imresize(pic_1(:,1:ch_len),[1000 1000]);
        pic_sd2=imresize(pic_1(:,ch_len+1:2*ch_len),[1000 1000]);
        pic_sd3=imresize(pic_1(:,2*ch_len+1:3*ch_len),[1000 1000]);
        pic_sd4=imresize(pic_1(:,3*ch_len:end),[1000 1000]);
        figure;imshow(pic_sd1)
        figure;imshow(pic_sd2)
        figure;imshow(pic_sd3)
        figure;imshow(pic_sd4)
end
imwrite(pic_sd1,'1.jpg');
if x<150||x>=250
    disp('error')
end
%% test cut size
% %img_path = './train/';
% img_path = './val/';
% img_dir = dir([img_path,'*CP*']);
% img_num = length(img_dir);
% 
% for ii=1:img_num
%   ii
% x=size(pic,2);%����
% y=size(pic,1);%����
% xy=[0.4*x 0.7*y  0.4*x 0.2*y ];
% pic = imread([img_path,img_dir(ii).name]);
% pic = imresize(pic,[1780 1070]);
% %% cut imag
% pic_1 = imcrop(pic,xy);%cut
% pic_1= rgb2gray(pic_1);%pic_1=edge(pic_1, 'Canny');
% imshow(pic_1)
% pic_1(pic_1>w_th)=255;
% 
% pic_1(pic_1<=w_th)=0;
% figure
% imshow(pic_1)
% 
% 
% pause(1)
% end