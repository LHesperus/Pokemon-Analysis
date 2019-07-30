function   [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
%% 预处理
id_model=model.id_model;
cp_model=model.cp_model;
hp_model=model.hp_model;
sd_model=model.sd_model;

%% 识别ID
try
	k=100;%需要调整
	n_train=910;
	ID=ID_recongnition(img,k,id_model,n_train);
catch
	ID=0;
end

%% 识别 CP
try
	pic = img;
	% get CP  picture
	x=size(pic,2);
	y=size(pic,1);
	xy=[0.3*x 0.035*y 0.30*x 0.12*y];
	pic_cp = imcrop(pic,xy);%cut
	pic_cp=rgb2gray(pic_cp);% to gray
	pic_cp=imresize(pic_cp,[500,1000]);
	
	%  二值化
	w_th=240;
	pic_cp(pic_cp>w_th)=255;
	pic_cp(pic_cp<=w_th)=0;
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
	% figure;imshow(pic_cp);title('CP part')
	I=pic_cp_temp;
	% figure;imshow(I);title('CP part')
	% imwrite(I,'cp.jpg');
	
	% separate chapter
	hor_intv=2;   % horizontal interval
	ver_intv=2;   % vertical interval
	w_th=1;		  % white threshold
	for cha=1:10
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
			break;
		end
		
	% 	figure;imshow(I)
	% 	figure;imshow(I_temp)
	    %自上至下竖直扫，得到字符上界限
		for ii=1:size(I,1)-ver_intv
			xx=sum(sum(I(ii:ii+ver_intv,:)==255));
			if xx>w_th
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
	% 	figure;imshow(I)
	%   imwrite(I,'1.png');
	    ch_set(cha,:,:)=imresize(I,[1000 1000]);
	    I=I_temp;
	end
	CP=CP_recog(ch_set,cp_model);	
catch
	CP=0;
end

%% 识别 HP
try
	pic = img;
	imshow(pic);
	% get pic size
	x=size(pic,2);%横向
	y=size(pic,1);%纵向
	xy=[0.3*x 0.45*y  0.4*x 0.2*y ];
	pic_1 = imcrop(pic,xy);%cut
	pic_1 = rgb2gray(pic_1);% to gray
	% 二值化
	w_th=230;
	pic_1(pic_1>=w_th)=255;
	pic_1(pic_1<w_th)=0;
	pic_1=imresize(pic_1,[500,1000]);
	
	% 纵向扫 ，找到横线与字符之间的空白
	x=size(pic_1,2);
	y=size(pic_1,1);
	v_len=3;
	flag=0;
	for ii=1:y-v_len-1
		b_n=sum(sum(pic_1(ii:ii+v_len,:)==0));
		if b_n>=0.95*(v_len+1)*(x-1)  %检测到横线
			flag=1;
		end
		if b_n<0.1*(v_len+1)*x&&flag==1 % 到横线下方的空白
			pic_1=pic_1(ii+v_len:end,:);
			break;
		end
	end
	
	
	% 纵向扫，找到字符下方的空白
	x=size(pic_1,2);
	y=size(pic_1,1);
	v_len=3;
	flag=0;
	for ii=1:y-v_len-1
		b_n=sum(sum(pic_1(ii:ii+v_len,:)==0));
		if b_n>=0.1*(v_len+1)*(x-1)  %检测到字符
			flag=1;
		end
		if b_n< 0.01*(v_len+1)*(x-1)&&flag==1
			pic_1=pic_1(1:ii+v_len,:);
			break;
		end
	end
	
	
	% 横向扫，得到每个字符
	for ch=1:10
		x=size(pic_1,2);
		h_len=1;
		b_th=2;
		flag=0;
		for ii=1:x-h_len-1
			b_n=sum(sum(pic_1(:,ii:ii+h_len)==0));
			if b_n>b_th  %有字符
				flag=1;
			end
			if b_n<=b_th&&flag==1 %有竖直的白线，分隔线
				pic_temp=pic_1(:,ii+h_len+1:end);
				pic_ch=pic_1(:,1:ii+h_len);
				break;
			end
			
		end
		% 无新的字符后退出
		if flag==0
			break;
		end
		pic_1=pic_temp;
		% 修正字符
		% 去掉左边空白
		x=size(pic_ch,2);
		h_len=1;
		b_th=2;
		flag=0;
		for ii=1:x-h_len
		b_n=sum(sum(pic_ch(:,ii:ii+h_len)==0));%纵向黑点数
		if b_n<=b_th
				flag=1;
		end
		if b_n>b_th && flag==1
				pic_ch=pic_ch(:,ii:end);
				break;
		end
		end
		% 去掉上边空白
		y=size(pic_ch,1);
		v_len=3;
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
		% 统一字符大小
		ch_set(ch,:,:)=imresize(pic_ch,[1000 1000]);
	end
	% 识别
	HP=HP_recog(ch_set,hp_model);
catch
	HP=0;
end
    
%% 识别 stardust
try 
	pic = img;
	% get pic size
	x=size(pic,2);%横向
	y=size(pic,1);%纵向
	xy=[0.15*x 0.7*y  0.55*x 0.2*y ];
	pic_1 = imcrop(pic,xy);%cut
	pic_1 = rgb2gray(pic_1);% to gray
	pic_1=imresize(pic_1,[1000,1000]);
	% 二值化
	w_th=220;
	pic_1(pic_1>w_th)=255;
	pic_1(pic_1<=w_th)=0;
	% 缩小区间
	y=size(pic_1,1);%纵向
	for ii=1:y%找到中间
		b_n=sum(sum(pic_1(ii:ii+2,1:10)==0));
		if b_n>10
			pic_1=pic_1(ii:ii+333,:);
			break;
		end
	end
	x=size(pic_1,2);%横向
	%找到数字
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
	% figure;imshow(pic_1)
	% 进一步缩小范围
	x=size(pic_1,2);%横向
	flag=0;
	for ii=1:x%找到左边数字
		b_n=sum(sum(pic_1(:,ii:ii+3)==0));
		if b_n==0
			flag=1;
		end
		if b_n>10 &&flag==1
			pic_1=pic_1(:,ii:end);
			break;
		end
	end
	% figure;imshow(pic_1)
	x=size(pic_1,2);%横向
	if x>200
		x=200;
	end
	for ii=x:-1:1%找到右边数字
		b_n=sum(sum(pic_1(:,ii-2:ii)==0));
		if b_n>10 
			pic_1=pic_1(:,1:ii);
			break;
		end
	end
	% figure;imshow(pic_1)
	% 去掉上下空白
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
	% figure;imshow(pic_1)
	% 判断字符数并分割
	x=size(pic_1,2);%字符长度
	if x>=100&&x<140 %3个字符
			ch_len=round(x/3);
			pic_sd(1,:,:)=imresize(pic_1(:,1:ch_len),[1000 1000]);
			pic_sd(2,:,:)=imresize(pic_1(:,ch_len+1:2*ch_len),[1000 1000]);
			pic_sd(3,:,:)=imresize(pic_1(:,2*ch_len:end),[1000 1000]);
	end
	if x>=140&&x<200%4个字符
			ch_len=round(x/4);
			pic_sd(1,:,:)=imresize(pic_1(:,1:ch_len),[1000 1000]);
			pic_sd(2,:,:)=imresize(pic_1(:,ch_len+1:2*ch_len),[1000 1000]);
			pic_sd(3,:,:)=imresize(pic_1(:,2*ch_len+1:3*ch_len),[1000 1000]);
			pic_sd(4,:,:)=imresize(pic_1(:,3*ch_len:end),[1000 1000]);
	end
	if x<100||x>=200
		stardust=0;
	else
		stardust=SD_recog(pic_sd,sd_model); 
	% disp(stardust)
	end
catch
	stardust=0;
end

%% 识别 level 和 cir_center
try
	pic =img;
	% get pic size
	x=size(pic,2);%横向
	y=size(pic,1);%纵向
	xy=[0 0  x 0.5*y ];
	pic_1 = imcrop(pic,xy);%cut
	pic_1 = rgb2gray(pic_1);% to gray
	% 二值化
	w_th=230;
	pic_1(pic_1>=w_th)=255;
	pic_1(pic_1<w_th)=0;
	% 找到圆弧
	x1=size(pic_1,2);%横向
	y1=size(pic_1,1);%纵向
	flag=0;
	flag2=0;
	for ii=y1:-1:2
		w_n=sum(sum(pic_1(ii-1:ii,1:round(0.3*x1))==255));
		if  w_n<=round(0.5*0.3*x1)
			flag=1;
		end
		if w_n>=2&&w_n<round(0.1*0.3*x1)&&flag==1
	%         figure
	%         imshow(pic_1(1:ii-1,1:round(0.3*x1)));
			y_left=ii-1;
			for  jj=1:round(0.3*x1)
				w_nn=sum(pic_1(ii-1,jj:jj+1)==255);
				if w_nn>0
					x_left=jj+1;
					flag2=1;
					break;
				end
			end      
			break;
		end
	end
	% 圆心->cen 
	if flag2==1%找到了圆弧
		x_cen=round(x/2);
		y_cen=y_left;
		x_right=x-x_left;
		y_right=y_left;
		radius=round((x_right-x_left)/2);
		cir_center=[x_cen,y_cen];
    else
        level=[0,0];
		cir_center=[0,0];
    end
% 非圆弧区域涂白
	if flag2==1
        l_th=25;
        for ii=1:x1
            for jj=1:y1
                pos_value= sqrt((ii-x_cen)^2+(jj-y_cen)^2);
                if pos_value> (radius+l_th)||pos_value <(radius-l_th)
                    pic_1(jj,ii)=255;
                end                           
            end        
        end
% 截取圆弧部分
		pic_2=pic_1(y_left-radius-l_th:y_left+l_th,:);
		x2=size(pic_2,2);%横向
		y2=size(pic_2,1);%纵向
		pic_2=imresize(pic_2,[500,1000]);    
		pic_2=edge(pic_2, 'Canny');% 边沿检测,方便找圆
		[centers, radii, metric] = imfindcircles(pic_2,[1 round(0.03*x)]);%找到小圆点
		if size(centers,1)==0 %没找到
			
			level=[x_left ,y_left];
		else
			[~,cen_pos]=max(radii);%最大半径
			%坐标变换
			level=centers(cen_pos,:);
			level(1)=level(1)*x2/1000;       
			level(2)=level(2)*y2/500+y_left-radius-l_th;
		end    
	end
catch
	level=[0,0];
	cir_center=[0,0];
end

end
%% ID识别函数
function ID=ID_recongnition(imag,k,model,img_num)
j=sqrt(-1);
[xx,yy]=ID_ExtractFeature(imag,k);
B=zeros(k,2);
B(1:length(xx),1)=xx;
B(1:length(yy),2)=yy;

for ii=1:img_num
    A=[model.IDx_feature(ii,:)' model.IDy_feature(ii,:)'];
    Idx= knnsearch(A,B);
    A1=A(Idx,1)+j*A(Idx,2);
    B1=B(:,1)+j*B(:,2);
    F1=(A1-B1).^2;
    F(ii)=sum(F1);
end
[~,n]=min(F);
ID=model.ID_gt(n);
end
function [xx,yy]=ID_ExtractFeature(imag,k)
%% resize imag
%pic = imread(imag);
pic=imag;
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
x=size(pic,2);
y=size(pic,1);
xy=[0.30*x 0.16*y 0.4*x 0.24*y];
pic_1 = imcrop(pic,xy);%cut
%%   SURF
RGB = pic_1;
if length(size(RGB))>=3  % avoid RGB gray imag
    I = rgb2gray(RGB);% to gray
else
    I=RGB;
end

%edge
%I=edge(I, 'Canny');
points = detectSURFFeatures(I);
%points = detectHarrisFeatures(I);
%points=detectMSERFeatures(I);
%points=detectKAZEFeatures(I);
%% Harris
% corners = detectHarrisFeatures(I);
% figure
% imshow(I); hold on;
% plot(corners.selectStrongest(n));

%% k means
if points.Count<=k
    k=points.Count;
end
X=points.Location;
[idx,C] = kmeans(X,k);
%k_freq=sum(idx==(1:k));
xx=C(:,1);
yy=C(:,2);
end
%% CP识别函数
function cp=CP_recog(ch_set,cp_model)
    % c->11
    % p->12
    len=size(ch_set,1);
	w_th=250;
    if len<3
        cp=0;
        return;
    end
	ch_err=zeros(1,len);
	ch_cp=zeros(1,len);
    if len>=3
        for ii=1:len
            ch_temp=ch_set(ii,:,:);
			ch_temp=reshape(ch_temp,1000,1000);
            ch_temp(ch_temp>w_th)=255;
            ch_temp(ch_temp<=w_th)=0;
            ch_err(1)=sum(sum(ch_temp~=cp_model.cp_c));
            ch_err(2)=sum(sum(ch_temp~=cp_model.cp_p));
            ch_err(3)=sum(sum(ch_temp~=cp_model.cp_0));
            ch_err(4)=sum(sum(ch_temp~=cp_model.cp_1));
            ch_err(5)=sum(sum(ch_temp~=cp_model.cp_2));
            ch_err(6)=sum(sum(ch_temp~=cp_model.cp_3));
            ch_err(7)=sum(sum(ch_temp~=cp_model.cp_4));
            ch_err(8)=sum(sum(ch_temp~=cp_model.cp_5));
            ch_err(9)=sum(sum(ch_temp~=cp_model.cp_6));
            ch_err(10)=sum(sum(ch_temp~=cp_model.cp_7));
            ch_err(11)=sum(sum(ch_temp~=cp_model.cp_8));
            ch_err(12)=sum(sum(ch_temp~=cp_model.cp_9));
            [~,pos]=min(ch_err);
            switch pos
                case 1
                    ch_cp(ii)=11;
                case 2
                    ch_cp(ii)=12;	
				case 3	
				    ch_cp(ii)=0;
                case 4
                    ch_cp(ii)=1;
                case 5
                    ch_cp(ii)=2;
				case 6	
				    ch_cp(ii)=3;	
				case 7	
				    ch_cp(ii)=4;
                case 8
                    ch_cp(ii)=5;
 				case 9
					ch_cp(ii)=6;
                case 10
                    ch_cp(ii)=7;
				case 11	
				    ch_cp(ii)=8;	
				case 12	
				    ch_cp(ii)=9;
            end            
        end
		%找到P
		p_pos=find(ch_cp==12);
		if length(p_pos)==0
			cp=sum(ch_cp(3:end).*10.^(len-3:-1:0));
			return;
		else
			cp=sum(ch_cp(p_pos+1:end).*10.^(len-p_pos-1:-1:0));
        end				
    end
end
%% HP识别函数
function hp=HP_recog(ch_set,hp_model)
    % h->11
    % p->12
    % /->13
    len=size(ch_set,1);
	w_th=250;
    if len<5
        hp=0;
        return;
    end
    ch_err=zeros(1,13);
    ch_hp=zeros(1,len);
    if len>=5
        for ii=1:len
            ch_temp=ch_set(ii,:,:);
            ch_temp=reshape(ch_temp,1000,1000);
            ch_temp(ch_temp>w_th)=255;
            ch_temp(ch_temp<=w_th)=0;
            ch_err(1)=sum(sum(ch_temp~=hp_model.hp_h));
            ch_err(2)=sum(sum(ch_temp~=hp_model.hp_p));
            ch_err(3)=sum(sum(ch_temp~=hp_model.hp_div));
            ch_err(4)=sum(sum(ch_temp~=hp_model.hp_0));
            ch_err(5)=sum(sum(ch_temp~=hp_model.hp_1));
            ch_err(6)=sum(sum(ch_temp~=hp_model.hp_2));
            ch_err(7)=sum(sum(ch_temp~=hp_model.hp_3));
            ch_err(8)=sum(sum(ch_temp~=hp_model.hp_4));
            ch_err(9)=sum(sum(ch_temp~=hp_model.hp_5));
            ch_err(10)=sum(sum(ch_temp~=hp_model.hp_6));
            ch_err(11)=sum(sum(ch_temp~=hp_model.hp_7));
            ch_err(12)=sum(sum(ch_temp~=hp_model.hp_8));
            ch_err(13)=sum(sum(ch_temp~=hp_model.hp_9));
            [~,pos]=min(ch_err);
            switch pos
                case 1
                    ch_hp(ii)=11;
                case 2
                    ch_hp(ii)=12;
				case 3	
				    ch_hp(ii)=13;	
				case 4	
				    ch_hp(ii)=0;
                case 5
                    ch_hp(ii)=1;
                case 6
                    ch_hp(ii)=2;
				case 7	
				    ch_hp(ii)=3;	
				case 8	
				    ch_hp(ii)=4;
                case 9
                    ch_hp(ii)=5;
 				case 10
					ch_hp(ii)=6;
                case 11
                    ch_hp(ii)=7;
				case 12	
				    ch_hp(ii)=8;	
				case 13	
				    ch_hp(ii)=9;
            end
        end
        % 找到HP的值
        h_pos=find(ch_hp==11);%找到P
        div_pos=find(ch_hp==13);%找到/
        if length(h_pos)&&length(div_pos)==0
            hp=0;
            return;
        end
        % 判断在前还是在后面
        if h_pos< div_pos
            hp_temp=ch_hp(div_pos+1:end);
        else
            hp_temp=ch_hp(div_pos+1:h_pos-1);
        end
        %计算 hp
        hp_len=length(hp_temp);
        hp=sum(hp_temp.*(10.^(hp_len-1:-1:0)));
    end
end

%% stardust 识别函数
function stardust=SD_recog(pic,sd_model)
    len=size(pic,1);
	ch_err=zeros(1,10);
    ch_sd=zeros(1,len);
    w_th=250;
    for ii=1:len
            ch_temp=pic(ii,:,:);
            ch_temp=reshape(ch_temp,1000,1000);
            ch_temp(ch_temp>w_th)=255;
            ch_temp(ch_temp<=w_th)=0;
            ch_err(1)=sum(sum((ch_temp~=sd_model.sd_0).^2));
            ch_err(2)=sum(sum((ch_temp~=sd_model.sd_1).^2));
            ch_err(3)=sum(sum((ch_temp~=sd_model.sd_2).^2));
            ch_err(4)=sum(sum((ch_temp~=sd_model.sd_3).^2));
            ch_err(5)=sum(sum((ch_temp~=sd_model.sd_4).^2));
            ch_err(6)=sum(sum((ch_temp~=sd_model.sd_5).^2));
            ch_err(7)=sum(sum((ch_temp~=sd_model.sd_6).^2));
            ch_err(8)=sum(sum((ch_temp~=sd_model.sd_7).^2));
            ch_err(9)=sum(sum((ch_temp~=sd_model.sd_8).^2));
            ch_err(10)=sum(sum((ch_temp~=sd_model.sd_9).^2));
            [~,pos]=min(ch_err);
            switch pos
                case 1
                    ch_sd(ii)=0;
                case 2
                    ch_sd(ii)=1;
				case 3	
				    ch_sd(ii)=2;	
				case 4	
				    ch_sd(ii)=3;
                case 5
                    ch_sd(ii)=4;
                case 6
                    ch_sd(ii)=5;
				case 7	
				    ch_sd(ii)=6;	
				case 8	
				    ch_sd(ii)=7;
                case 9
                    ch_sd(ii)=8;
 				case 10
					ch_sd(ii)=9;
            end
     end
     %计算 sd
     stardust=sum(ch_sd.*(10.^(len-1:-1:0)));
end