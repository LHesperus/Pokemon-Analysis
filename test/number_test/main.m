%%
clc
clear
close all
  % gray ==  255 is white
%%
pic = imread('007_CP132_HP28_SD600_8071_9.png');
imshow(pic);
% get CP  picture
x=size(pic,2);
y=size(pic,1);
xy=[0.3*x 0.05*y 0.30*x 0.12*y];
pic_cp = imcrop(pic,xy);%cut
pic_cp=rgb2gray(pic_cp);% to gray
pic_cp=imresize(pic_cp,[500,1000]);

%%  去噪（小白点）没写
w_th=220;
pic_cp(pic_cp>w_th)=255;
pic_cp(pic_cp<=w_th)=0;
figure;imshow(pic_cp)
%% 将数字底部与圆弧分开
w_th=3;
for nn=1:100
    y=size(pic_cp,1);
    flag=0;
    flag2=0;
    for ii=1:y-2
        w_n=sum(sum(pic_cp(ii:ii+2,:)==255));
        if w_n>w_th
             flag=1;
        end
        if w_n<w_th&&flag==1
            pic_cp_temp=pic_cp(1:ii+2,:);
            flag2=1;
            break;
        end
    end
    if flag==1&&flag2==0
        w_th=w_th+1;
    end

end
pic_cp=pic_cp_temp;


figure;imshow(pic_cp);title('CP part')
imwrite(pic_cp,'cp.jpg');

I=pic_cp;
figure
imshow(I);title('gray picture')

%% separate chapter
hor_intv=2;   % horizontal interval
ver_intv=2;   % vertical interval
w_th=1;		  % white threshold
for cha=1:7
    %水平扫
	flag=0;     
	yy=zeros(1,size(I,2));
	for ii=1:size(I,2)-hor_intv
		yy(ii+1)=sum(sum(I(:,ii:ii+hor_intv)==255));
		if yy(ii+1)>=w_th&&yy(ii)==0       
			flag=1;
			pos=ii;
		end
		if (yy(ii+1)==0)&&(flag==1)
            I_temp=I(:,ii+w_th+1:end);
			I=I(:,pos:ii);           
			break;
		end
	end
	% 无符号后退出循环
	if flag==0   % no chapter
        disp(cha)
        disp('finish');
		break;
	end
	
% 	figure;imshow(I)
% 	figure;imshow(I_temp)
    %自上至下竖直扫，得到字符上界限
	flag=0;
	for ii=1:size(I,1)-ver_intv
		xx=sum(sum(I(ii:ii+ver_intv,:)==255));
		if xx>w_th
			flag=1;
			I=I(ii:end,:);
			break;
		end
	end
	
% 	figure;imshow(I)
    %自上至下竖直扫，得到字符下界
	for ii=1:size(I,1)-ver_intv
		xx=sum(sum(I(ii:ii+ver_intv,:)==255));
		if xx<w_th 
			I=I(1:ii+ver_intv,:);
			break;
		end
	end
	figure;imshow(I)
    imwrite(I,'1.png');
    I=I_temp;
end

aa
%% 
% %img_path = './train/';
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
for ii=18:img_num
  ii
pic = imread([img_path,img_dir(ii).name]);
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
x=size(pic,2);
y=size(pic,1);
xy=[0.3*x 0.035*y 0.30*x 0.12*y];
pic_1 = imcrop(pic,xy);%cut
%pic_1= rgb2gray(pic_1);pic_1=edge(pic_1, 'Canny');
imshow(pic_1) 
%% 提取
pic_cp= rgb2gray(pic_1);
w_th=240;
pic_cp(pic_cp>w_th)=255;
pic_cp(pic_cp<=w_th)=0;
figure;imshow(pic_cp)
% 将数字底部与圆弧分开
w_th=3;
for nn=1:100
    y=size(pic_cp,1);
    flag=0;
    flag2=0;
    for ii=1:y-2
        w_n=sum(sum(pic_cp(ii:ii+2,:)==255));
        if w_n>w_th
             flag=1;
        end
        if w_n<w_th&&flag==1
            pic_cp_temp=pic_cp(1:ii+2,:);
            flag2=1;
            break;
        end
    end
    if flag==1&&flag2==0
        w_th=w_th+1;
    end

end
pic_cp=pic_cp_temp;


figure;imshow(pic_cp);title('CP part')
imwrite(pic_cp,'cp.jpg');

I=pic_cp;
figure
imshow(I);title('gray picture')

%% separate chapter
hor_intv=2;   % horizontal interval
ver_intv=2;   % vertical interval
w_th=1;		  % white threshold
for cha=1:7
    %水平扫
	flag=0;     
	yy=zeros(1,size(I,2));
	for ii=1:size(I,2)-hor_intv
		yy(ii+1)=sum(sum(I(:,ii:ii+hor_intv)==255));
		if yy(ii+1)>=w_th&&yy(ii)==0       
			flag=1;
			pos=ii;
		end
		if (yy(ii+1)==0)&&(flag==1)
            I_temp=I(:,ii+w_th+1:end);
			I=I(:,pos:ii);           
			break;
		end
	end
	% 无符号后退出循环
	if flag==0   % no chapter
        disp(cha)
        disp('finish');
		break;
	end
	
% 	figure;imshow(I)
% 	figure;imshow(I_temp)
    %自上至下竖直扫，得到字符上界限
	flag=0;
	for ii=1:size(I,1)-ver_intv
		xx=sum(sum(I(ii:ii+ver_intv,:)==255));
		if xx>w_th
			flag=1;
			I=I(ii:end,:);
			break;
		end
	end
	
% 	figure;imshow(I)
    %自上至下竖直扫，得到字符下界
	for ii=1:size(I,1)-ver_intv
		xx=sum(sum(I(ii:ii+ver_intv,:)==255));
		if xx<w_th 
			I=I(1:ii+ver_intv,:);
			break;
		end
	end
	figure;imshow(I)
    imwrite(I,'1.png');
    I=I_temp;
end
aa
pause(100)
close all

end

