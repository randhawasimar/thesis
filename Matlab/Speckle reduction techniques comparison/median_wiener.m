clear all;
close all;
n=imread('ANI_0001.jpg');
n=rgb2gray(n);
[x,y]=size(n);
%subplot(3,2,1);
% imshow(i)
% title('org image');
% z=0;
% for w=0.01:0.01:0.2
%     sigma=0.05;
%     z=z+1;
%     n=imnoise(i,'speckle',sigma);%adding speckle noise
%subplot(3,2,2);
% figure,imshow(n);
% title('with noise')
k=medfilt2(n);%applying median filter
%subplot(3,2,3);
figure,imshow(k);
% title('median filter')
% h = fspecial('average',5);%averager of 5x5 pixel dimension
% h1= uint8(filter2(h,n));%applying 2D filter over the noise image 'n' with the averager 'h' and then converting double to uint8
% %subplot(3,2,4);
% figure,imshow(h1);
% title('avg');
m=wiener2(n);%applying wiener filter
%subplot(3,2,5);
figure,imshow(m);
% title('wiener');

% %%%%%%%%%%%%%%%%%%%%%% MEDIAN FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%
% 
% msquaredErrorImage = (double(i) - double(k)) .^ 2;
% mMSE(z) = sum(sum(msquaredErrorImage)) / (x*y);
% msquaredOutputImage= (double(i)).^2;
% msnr=sum(sum(msquaredOutputImage))/ (x*y);
% mSNR(z)=10*log10(msnr);
% mPSNR(z) = 10*log10( 255^2 / mMSE(z));
% % BETA (edge preservation index)
% Imf=im2double(k);
% Iref=im2double(i);
% 
% ImL = Iref;
% 
%   % Second Derivative (Laplacian)
% ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
% [height weight] = size(ImL);
% 
% Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
% Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
% Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
% HPg = Ixx+Iyy+Ixy;
% 
% clear ImL; 
% clear ImAux;
% 
% ImL = Imf;
% 
%   % Second Derivative (Laplacian)
% ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
% [height weight] = size(ImL);
% Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
% Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
% Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
% HPf = Ixx+Iyy+Ixy;
% 
% clear ImL; clear Ixx; clear Iyy; clear Ixy;
% clear ImAux;
% 
% aHPg = mean(HPg(:));
% aHPf = mean(HPf(:));
% 
% dg = HPg - aHPg;
% df = HPf - aHPf;
% 
% clear HPg; clear HPf;
% clear aHPg; clear aHPf;
% 
% Db1 = sum(sum(dg.*df));
% Db2 = sum(sum(dg.*dg));
% Db3 = sum(sum(df.*df));
% 
% mBmetric(z) = abs(Db1./(sqrt(Db2*Db3)+eps));
% 
% %%%%%%%%%%%%%%%%%%%%%% WIENER FILTER PARAMETERS %%%%%%%%%%%%%%%%%%%%%
% 
% wsquaredErrorImage = (double(i) - double(m)) .^ 2;
% wMSE(z) = sum(sum(wsquaredErrorImage)) / (x*y);
% wsquaredOutputImage= (double(i)).^2;
% wsnr=sum(sum(wsquaredOutputImage))/ (x*y);
% wSNR(z)=10*log10(wsnr);
% wPSNR(z) = 10*log10( 255^2 / wMSE(z));
% % BETA (edge preservation index)
% Imf=im2double(m);
% Iref=im2double(i);
% 
% ImL = Iref;
% 
%   % Second Derivative (Laplacian)
% ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
% [height weight] = size(ImL);
% 
% Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
% Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
% Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
% HPg = Ixx+Iyy+Ixy;
% 
% clear ImL; 
% clear ImAux;
% 
% ImL = Imf;
% 
%   % Second Derivative (Laplacian)
% ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
% [height weight] = size(ImL);
% Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
% Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
% Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
% HPf = Ixx+Iyy+Ixy;
% 
% clear ImL; clear Ixx; clear Iyy; clear Ixy;
% clear ImAux;
% 
% aHPg = mean(HPg(:));
% aHPf = mean(HPf(:));
% 
% dg = HPg - aHPg;
% df = HPf - aHPf;
% 
% clear HPg; clear HPf;
% clear aHPg; clear aHPf;
% 
% Db1 = sum(sum(dg.*df));
% Db2 = sum(sum(dg.*dg));
% Db3 = sum(sum(df.*df));
% 
% wBmetric(z) = abs(Db1./(sqrt(Db2*Db3)+eps));
% end
% filename='E:\phd\solan conference paper\results.xlsx';
% B=mMSE';
% C=mSNR';
% D=mPSNR';
% E=mBmetric';
% xlswrite(filename,B,5,'D2')
% xlswrite(filename,C,5,'E2')
% xlswrite(filename,D,5,'F2')
% xlswrite(filename,E,5,'G2')
% 
% U=wMSE';
% V=wSNR';
% W=wPSNR';
% X=wBmetric';
% 
% xlswrite(filename,U,6,'D2')
% xlswrite(filename,V,6,'E2')
% xlswrite(filename,W,6,'F2')
% xlswrite(filename,X,6,'G2')