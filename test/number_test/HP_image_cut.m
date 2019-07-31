%%
clc
clear
close all

%%  get HP part
pic = imread('007_CP132_HP28_SD600_8071_9.png');
imshow(pic);
% get pic size
x=size(pic,2);%����
y=size(pic,1);%����



xy=[0.3*x 0.45*y  0.4*x 0.2*y ];
pic_1 = imcrop(pic,xy);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.jpg');
pic_1 = rgb2gray(pic_1);% to gray
figure
imshow(pic_1)
%% ��ֵ��
w_th=230;
pic_1(pic_1>=w_th)=255;
pic_1(pic_1<w_th)=0;
figure;imshow(pic_1)
pic_1=imresize(pic_1,[500,1000]);
figure;imshow(pic_1)

%% ����ɨ ���ҵ��������ַ�֮��Ŀհ�
x=size(pic_1,2);
y=size(pic_1,1);
v_len=3;
b_n=2;
flag=0;
for ii=1:y-v_len-1
    b_n=sum(sum(pic_1(ii:ii+v_len,:)==0));
    if b_n>=0.95*(v_len+1)*(x-1)  %��⵽����
        flag=1;
    end
    if b_n<0.1*(v_len+1)*x&&flag==1 % �������·��Ŀհ�
        pic_1=pic_1(ii+v_len:end,:);
        break;
    end
end
figure;
imshow(pic_1)

%% ����ɨ���ҵ��ַ��·��Ŀհ�
x=size(pic_1,2);
y=size(pic_1,1);
h_len=2;
v_len=3;
w_th=2;
b_th=2;
flag=0;
for ii=1:y-v_len-1
    b_n=sum(sum(pic_1(ii:ii+v_len,:)==0));
    if b_n>=0.1*(v_len+1)*(x-1)  %��⵽�ַ�
        flag=1;
    end
    if b_n< 0.01*(v_len+1)*(x-1)&&flag==1
        pic_1=pic_1(1:ii+v_len,:);
        break;
    end
end
figure;imshow(pic_1);

%% ����ɨ���õ�ÿ���ַ�
for ch=1:8
    x=size(pic_1,2);
    y=size(pic_1,1);
    h_len=1;
    v_len=3;
    w_th=2;
    b_th=2;
    flag=0;
    for ii=1:x-h_len-1
        b_n=sum(sum(pic_1(:,ii:ii+h_len)==0));
        if b_n>b_th  %���ַ�
            flag=1;
        end
        if b_n<=b_th&&flag==1 %����ֱ�İ��ߣ��ָ���
            pic_temp=pic_1(:,ii+h_len+1:end);
            pic_ch=pic_1(:,1:ii+h_len);
            break;
        end
        
    end
    % ���µ��ַ����˳�
    if flag==0
        disp('ch finish');
        break;
    end
    pic_1=pic_temp;
%     figure;imshow(pic_ch)
    % �����ַ�
    % ȥ����߿հ�
    x=size(pic_ch,2);
    h_len=1;
    b_th=2;
    flag=0;
    for ii=1:x-h_len
       b_n=sum(sum(pic_ch(:,ii:ii+h_len)==0));%����ڵ���
       if b_n<=b_th
            flag=1;
       end
       if b_n>b_th && flag==1
            pic_ch=pic_ch(:,ii:end);
            break;
       end
    end
    %figure;imshow(pic_ch)
    % ȥ���ϱ߿հ�
    x=size(pic_ch,2);
    y=size(pic_ch,1);
    h_len=1;
    v_len=3;
    w_th=2;
    b_th=2;
    flag=0;
    for ii=1:y-v_len-1
        b_n=sum(sum(pic_ch(ii:ii+v_len,:)==0));
        if b_n<b_th
            flag=1;
        end
        if b_n>b_th && flag==1
            pic_ch=pic_ch(ii:end,:);
            break;
        end
            
    end
    figure;imshow(pic_ch);
     imwrite(pic_ch,'3.png');
end

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
x=size(pic,2);%����
y=size(pic,1);%����
xy=[0.3*x 0.45*y  0.4*x 0.2*y ];
pic_1 = imcrop(pic,xy);%cut
%pic_1= rgb2gray(pic_1);pic_1=edge(pic_1, 'Canny');
imshow(pic_1)

pause(1)
close all
end