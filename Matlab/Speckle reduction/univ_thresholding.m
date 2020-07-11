clc;
clear all;
close all;
% DEFINE WAVELET
wname='db4';
% LOAD THE IMAGE 
I1=imread('testimage_3.png');
I1=rgb2gray(I1);
% z=0;
% for w=0.01:0.01:0.2
sigma= 0.05;
% z=z+1;
I=imnoise(I1,'speckle',sigma);
% imshow(I1)
% figure, imshow(I)
% TAKE LOGARITHM OF THE INPUT IMAGE
LI=log(double(I)+1);
% MULTILEVEL DECOMPOSITION
[aA1,aH1,aV1,aD1]=dwt2(LI,wname);
[aA2,aH2,aV2,aD2]=dwt2(aA1,wname);
[aA3,aH3,aV3,aD3]=dwt2(aA2,wname);
[m,n]= size(aH1);
[p,q]=size(aV1);
[r,s]=size(aD1);
[a,b]=size(aH2);
[c,d]=size(aV2);
[e,f]=size(aD2);
[g,h]=size(aH3);
[k,l]=size(aV3);
[x,y]=size(aD3);
% COMPUTE SCALE PARAMETER 'K' FOR EACH LEVEL
K1=sqrt(log(m*n));
K2=sqrt(log(a*b));
K3=sqrt(log(g*h));
% CALCULATE NOISE VARIANCE OF HORIZONTAL COMP
noisevarH1=(median(aH1(aH1>0))/0.6745)^2;
noisevarH2=(median(aH2(aH2>0))/0.6745)^2;
noisevarH3=(median(aH3(aH3>0))/0.6745)^2;
% CALCULATE NOISE VARIANCE OF VERTICAL COMP
noisevarV1=(median(aV1(aV1>0))/0.6745)^2;
noisevarV2=(median(aV2(aV2>0))/0.6745)^2;
noisevarV3=(median(aV3(aV3>0))/0.6745)^2;
% CALCULATE NOISE VARIANCE OF DIAGONAL COMP
noisevarD1=(median(aD1(aD1>0))/0.6745)^2;
noisevarD2=(median(aD2(aD2>0))/0.6745)^2;
noisevarD3=(median(aD3(aD3>0))/0.6745)^2;
% COMPUTE THRESHOLD FOR IST LEVEL
% Calculate threshold for horizontal levels
aH1sq=aH1*aH1;
SH1=0;
for i=1:m
    SH1=aH1sq(i,i)+SH1;
end
yH1=sqrt(SH1/(m*m));
xH1=sqrt(max(yH1^2-noisevarH1));
% Compute threshold
if (xH1^2>noisevarH1)
    TH1=K1*(noisevarH1/xH1);
else
    TH1=max(max(aH1));
end
% Calculate threshold for vertical levels
aV1sq=aV1*aV1;
SV1=0;
for i=1:p
    SV1=aV1sq(i,i)+SV1;
end
yV1=sqrt(SV1/(p*p));
xV1=sqrt(max(yV1^2-noisevarV1));
% Compute threshold
if (xV1^2>noisevarV1)
    TV1=K1*(noisevarV1/xV1);
else
    TV1=max(max(aV1));
end
% Calculate threshold for diagonal levels
aD1sq=aD1*aD1;
SD1=0;
for i=1:r
    SD1=aD1sq(i,i)+SD1;
end
yD1=sqrt(SD1/(r*r));
xD1=sqrt(max(yD1^2-noisevarD1));
% Compute threshold
if (xD1^2>noisevarD1)
    TD1=K1*(noisevarD1/xD1);
else
    TD1=max(max(aD1));
end
% COMPUTE THRESHOLD FOR 2ND LEVEL
% Calculate threshold for horizontal levels
aH2sq=aH2*aH2;
SH2=0;
for i=1:a
    SH2=aH2sq(i,i)+SH2;
end
yH2=sqrt(SH2/(a*a));
xH2=sqrt(max(yH2^2-noisevarH2));
% Compute threshold
if (xH2^2>noisevarH2)
    TH2=K2*(noisevarH2/xH2);
else
    TH2=max(max(aH2));
end
% Calculate threshold for vertical levels
aV2sq=aV2*aV2;
SV2=0;
for i=1:c
    SV2=aV2sq(i,i)+SV2;
end
yV2=sqrt(SV2/(c*c));
xV2=sqrt(max(yV2^2-noisevarV2));
% Compute threshold
if (xV2^2>noisevarV2)
    TV2=K2*(noisevarV2/xV2);
else
    TV2=max(max(aV2));
end
% Calculate threshold for diagonal levels
aD2sq=aD2*aD2;
SD2=0;
for i=1:e
    SD2=aD2sq(i,i)+SD2;
end
yD2=sqrt(SD2/(e*e));
xD2=sqrt(max(yD2^2-noisevarD2));
% Compute threshold
if (xD2^2>noisevarD2)
    TD2=K2*(noisevarD2/xD2);
else
    TD2=max(max(aD2));
end
% COMPUTE THRESHOLD FOR 3RD LEVEL
% Calculate threshold for horizontal levels
aH3sq=aH3*aH3;
SH3=0;
for i=1:g
    SH3=aH3sq(i,i)+SH3;
end
yH3=sqrt(SH3/(g*g));
xH3=sqrt(max(yH3^2-noisevarH3));
% Compute threshold
if (xH3^2>noisevarH3)
    TH3=K3*(noisevarH3/xH3);
else
    TH3=max(max(aH3));
end
% Calculate threshold for vertical levels
aV3sq=aV3*aV3;
SV3=0;
for i=1:k
    SV3=aV3sq(i,i)+SV1;
end
yV3=sqrt(SV3/(k*k));
xV3=sqrt(max(yV3^2-noisevarV3));
% Compute threshold
if (xV3^2>noisevarV3)
    TV3=K3*(noisevarV3/xV3);
else
    TV3=max(max(aV3));
end
% Calculate threshold for diagonal levels
aD3sq=aD3*aD3;
SD3=0;
for i=1:x
    SD1=aD1sq(i,i)+SD1;
end
yD3=sqrt(SD3/(x*x));
xD3=sqrt(max(yD3^2-noisevarD3));
% Compute threshold
if (xD3^2>noisevarD3)
    TD3=K3*(noisevarD3/xD3);
else
    TD3=max(max(aD3));
end
% PROCESSING SUB-BANDS WITH THE THRESHOLDING FUNCTION
H1 = wthresh(aH1,'s',TH1);
V1 = wthresh(aV1,'s',TV1);
D1 = wthresh(aD1,'s',TD1);
H2 = wthresh(aH2,'s',TH2);
V2 = wthresh(aV2,'s',TV2);
D2 = wthresh(aD2,'s',TD2);
H3 = wthresh(aH3,'s',TH3);
V3 = wthresh(aV3,'s',TV3);
D3 = wthresh(aD3,'s',TD3);
% TAKE INVERSE DWT
ILI1=idwt2(aA3,H3,V3,D3,wname);
ILI1=ILI1(1:c,1:d);
ILI2=idwt2(ILI1,H2,V2,D2,wname);
ILI2=ILI2(1:m,1:n);
ILI=idwt2(ILI2,H1,V1,D1,wname);
% TAKE EXPONENT
II=exp(ILI);
II=uint8(II);
figure, imshow(II)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%% PERFORMANCE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%
% [u,v]=size(I);
% squaredErrorImage = (double(II(1:u,1:v)) - double(I)) .^ 2;
% MSE(z) = sum(sum(squaredErrorImage)) / (u*v);
% squaredOutputImage= (double(II(1:u,1:v))).^2;
% snr=sum(sum(squaredOutputImage))/ (u*v);
% SNR(z)=10*log10(snr);
% PSNR(z) = 10*log10( 255^2 / MSE(z));
% SSval_1(z)=ssim(I,I1);
% SSval_2(z)=ssim(II(1:u,1:v),I1);
% % BETA (Edge preservation index)
% Imf=im2double(II(1:u,1:v));
% Iref=im2double(I1);
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
% Bmetric(z) = abs(Db1./(sqrt(Db2*Db3)+eps));
% end
% % fprintf('MSE= %f \n', MSE);
% % fprintf('SNR= %f dB \n', SNR);
% % fprintf('PSNR= %f dB \n', PSNR);
% % fprintf('SSIM_N= %f \n', SSval_1);
% % fprintf('SSIM_D= %f \n', SSval_2);
% filename='E:\phd\solan conference paper\results.xlsx';
% B=MSE';
% C=SNR';
% D=PSNR';
% % E=SSval_1';
% % F=SSval_2';
% E=Bmetric';
% %xlswrite(filename,A,'C2')
% xlswrite(filename,B,1,'D2')
% xlswrite(filename,C,1,'E2')
% xlswrite(filename,D,1,'F2')
% xlswrite(filename,E,1,'G2')
% % xlswrite(filename,E,1,'G2')
% % xlswrite(filename,F,1,'H2')