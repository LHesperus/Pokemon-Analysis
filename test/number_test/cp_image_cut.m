%%
clc
clear
close all

%%
pic = imread('007_CP132_HP28_SD600_8071_9.png');
imshow(pic);
% get pic size
x=size(pic,1);
y=size(pic,2);
xy=[0.2*x 0.05*y 0.2*x 0.14*y];
pic_1 = imcrop(pic,xy);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.jpg');
I = rgb2gray(pic_1);% to gray
figure
imshow(I)
% I(I==255)=0;
% imshow(I)

flag=0;
yy=zeros(1,size(I,2));
for ii=1:size(I,2)-4
    yy(ii+1)=sum(sum(I(:,ii:ii+2)==255));
    if yy(ii+1)>2&&yy(ii)==0        
        flag=1;
        pos=ii;
    end
    if (yy(ii+1)==0)&&(flag==1)
        I=I(:,pos:ii);
        break;
    end
end



imshow(I)
flag=0;
for ii=1:size(I,1)-2
    xx=sum(sum(I(ii:ii+2,:)==255));
    if xx>2
        flag=1;
        I=I(ii:end,:);
        break;
    end
end

imshow(I)
for ii=1:size(I,1)
    xx=sum(sum(I(ii:ii+2,:)==255));
    if xx==0 
        I=I(1:ii,:);
        break;
    end
end
imshow(I)
aa
%% test cut size
% %img_path = './train/';
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);

for ii=1:img_num
  ii
pic = imread([img_path,img_dir(ii).name]);
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
x=size(pic,1);
y=size(pic,2);
pic_1 = imcrop(pic,xy);%cut
%pic_1= rgb2gray(pic_1);pic_1=edge(pic_1, 'Canny');
imshow(pic_1)
pause(1)
end