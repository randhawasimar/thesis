clc;
clear all;
close all;
% DEFINE POLYNOMIAL ORDER AND FRAME SIZE
% if ord=flen-1 filter does not produce any smoothing %
ord=4; % Polynomial order (must be less than frame size)
flen=21; % Frame size (must be odd)
% LOAD THE IMAGE 
I1=imread('testimage_3.png');
I1=rgb2gray(I1);
[u,v]=size(I1);
% z=0;
% for w=0.01:0.01:0.2
sigma= 0.01;
% z=z+1;
x=0;
I=imnoise(I1,'speckle',sigma);
imshow(I1)
figure, imshow(I)
for i= 1:1:5
    x=2+x;
    flen=35+x
% APPLY SAVITZKY GOLAY FILTER
II=sgolayfilt(double(I),ord,flen);
II=uint8(II);
figure, imshow(II)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% PERFORMANCE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

squaredErrorImage = (double(II(1:u,1:v)) - double(I1)) .^ 2;
MSE(i)= sum(sum(squaredErrorImage)) / (u*v);
squaredOutputImage= (double(II(1:u,1:v))).^2;
snr=sum(sum(squaredOutputImage))/ (u*v);
SNR =10*log10(snr);
PSNR(i)= 10*log10( 256^2 / MSE(i));
SSval(i)=ssim(II(1:u,1:v),I1);
% correl=xcorr2(II(1:u,1:v),I1);
% BETA (edge preservation index)
Imf=im2double(II(1:u,1:v));
Iref=im2double(I1);
ImL = Iref;
  % Second Derivative (Laplacian)
ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
[height weight] = size(ImL);

Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
HPg = Ixx+Iyy+Ixy;

clear ImL; 
clear ImAux;

ImL = Imf;

  % Second Derivative (Laplacian)
ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
[height weight] = size(ImL);
Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
HPf = Ixx+Iyy+Ixy;

clear ImL; clear Ixx; clear Iyy; clear Ixy;
clear ImAux;

aHPg = mean(HPg(:));
aHPf = mean(HPf(:));

dg = HPg - aHPg;
df = HPf - aHPf;

clear HPg; clear HPf;
clear aHPg; clear aHPf;

Db1 = sum(sum(dg.*df));
Db2 = sum(sum(dg.*dg));
Db3 = sum(sum(df.*df));

Bmetric(i) = abs(Db1./(sqrt(Db2*Db3)+eps));
end
filename='E:\phd\SGfilterpaper\results.xlsx';
B=MSE';
D=PSNR';
E=SSval';
F=Bmetric';
% G=correl;
A=[B,D,E,F];
xlswrite(filename,A,1,'D69')