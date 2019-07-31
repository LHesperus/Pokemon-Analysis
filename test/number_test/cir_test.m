%%
clc
clear
close all

%%  get HP part
pic = imread('007_CP132_HP28_SD600_8071_9.png');
imshow(pic);
% get pic size
x=size(pic,2);%横向
y=size(pic,1);%纵向

xy=[0 0  x 0.5*y ];
pic_1 = imcrop(pic,xy);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.jpg');
pic_1 = rgb2gray(pic_1);% to gray
figure
imshow(pic_1)
%% 二值化
w_th=230;
pic_1(pic_1>=w_th)=255;
pic_1(pic_1<w_th)=0;
figure;imshow(pic_1)

%% 找到圆弧
x1=size(pic_1,2);%横向
y1=size(pic_1,1);%纵向
flag=0;
for ii=y1:-1:2
    w_n=sum(sum(pic_1(ii-1:ii,1:round(0.3*x1))==255));
    if  w_n<=round(0.5*0.3*x1)
        flag=1;
    end
    if w_n>=2&&w_n<round(0.1*0.3*x1)&&flag==1
        figure
        imshow(pic_1(1:ii-1,1:round(0.3*x1)));
        y_left=ii-1;
        for  jj=1:round(0.3*x1)
            w_nn=sum(pic_1(ii-1,jj:jj+1)==255);
            if w_nn>0
                x_left=jj+1;
            end
        end
        
        break;
    end
end

x_cen=round(x/2);
y_cen=y_left;
x_right=x-x_left;
y_right=y_left;
radius=round((x_right-x_left)/2);
figure;imshow(pic);
hold on
plot(x_left,y_left,'r^')
hold on
plot(x_cen,y_cen,'r^')
hold on
plot(x_right,y_right,'r^')
%% 非圆弧区域涂白
l_th=25;
for ii=1:x1
    for jj=1:y1
        pos_value= sqrt((ii-x_cen)^2+(jj-y_cen)^2);
        if pos_value> (radius+l_th)||pos_value <(radius-l_th)
            pic_1(jj,ii)=255;
        end
    end
end


%% 截取圆弧部分
pic_2=pic_1(y_left-radius-l_th:y_left+l_th,:);
figure
%imshow(pic_2)
x2=size(pic_2,2);%横向
y2=size(pic_2,1);%纵向
pic_2_temp=pic_2;
pic_2=imresize(pic_2,[500,1000]);
imshow(pic_2)
pic_2=edge(pic_2, 'Canny');
hold on


[centers, radii, metric] = imfindcircles(pic_2,[1 round(0.03*x)]);

centersStrong5 = centers; 
radiiStrong5 = radii;
metricStrong5 = metric;
viscircles(centersStrong5, radiiStrong5,'EdgeColor','r');
saa

[~,cen_pos]=max(radii);
plot(centers(cen_pos,1),centers(cen_pos,2),'r^')
hold off

figure
imshow(pic_2_temp)
hold on
plot(centers(:,1)*x2/1000,centers(:,2)*y2/500,'r^');