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