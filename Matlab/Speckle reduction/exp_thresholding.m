clc;
clear all;
close all;
% Set wavelet name
wname='sym7';
% Load the image 
I1=imread('testimage_3.png');
I1=rgb2gray(I1);
% z=0;
% for w=0.01:0.01:0.2
sigma= 0.05;
% z=z+1;
I=imnoise(I1,'speckle',sigma);
% imshow(I1)
% figure, imshow(I)
% Take logarithm of the input image
U=double(I);
LI=log(U+1);
% Take DWT
[aA1,aH1,aV1,aD1]=dwt2(LI,wname);
[aA2,aH2,aV2,aD2]=dwt2(aA1,wname);
[aA3,aH3,aV3,aD3]=dwt2(aA2,wname);
[m,n]=size(aH1);
[p,q]=size(aV1);
[r,s]=size(aD1);
[a,b]=size(aH2);
[c,d]=size(aV2);
[e,f]=size(aD2);
[g,h]=size(aH3);
[k,l]=size(aV3);
[x,y]=size(aD3);
% Calculate noise variance of horizontal comp
noisevarH1=(median(aH1(aH1>0))/0.6745)^2;
noisevarH2=(median(aH2(aH2>0))/0.6745)^2;
noisevarH3=(median(aH3(aH3>0))/0.6745)^2;
% Calculate universal threshold for horizontal comp
utH1=(noisevarH1)*sqrt(2*log(m*n));
utH2=(noisevarH2)*sqrt(2*log(a*b));
utH3=(noisevarH3)*sqrt(2*log(g*h));
% Calculate noise variance of vertical comp
noisevarV1=(median(aV1(aV1>0))/0.6745)^2;
noisevarV2=(median(aV2(aV2>0))/0.6745)^2;
noisevarV3=(median(aV3(aV3>0))/0.6745)^2;
% Calculate universal threshold for vertical comp
utV1=(noisevarV1)*sqrt(2*log(p*q));
utV2=(noisevarV2)*sqrt(2*log(c*d));
utV3=(noisevarV3)*sqrt(2*log(k*l));
% Calculate noise variance of diagonal comp
noisevarD1=(median(aD1(aD1>0))/0.6745)^2;
noisevarD2=(median(aD2(aD2>0))/0.6745)^2;
noisevarD3=(median(aD3(aD3>0))/0.6745)^2;
% Calculate universal threshold for diagonal comp
utD1=(noisevarD1)*sqrt(2*log(r*s));
utD2=(noisevarD2)*sqrt(2*log(e*f));
utD3=(noisevarD3)*sqrt(2*log(x*y));
% Processing sub-bands with the thresholding function
n1=3;%input('Enter the value of n1 :');
k1=3.2;%input('Enter the value of k1 :');
n2=2;%input('Enter the value of n2 :');
k2=2;%input('Enter the value of k2 :');
n3=0.5;%input('Enter the value of n3 :');
k3=1.5;%input('Enter the value of k3 :');
ktH1= k1*utH1;
ktV1= k1*utV1;
ktD1= k1*utD1;
ktH2= k2*utH2;
ktV2= k2*utV2;
ktD2= k2*utD2;
ktH3= k3*utH3;
ktV3= k3*utV3;
ktD3= k3*utD3;
for i= 1:m
    for j= 1:n
        if(abs(aH1(i,j))<ktH1)
        H1(i,j)= aH1(i,j)*exp(n1*(abs(aH1(i,j))-ktH1));
        else
            H1(i,j)= aH1(i,j);
        end
    end
end
for i= 1:p
    for j= 1:q
        if abs(aV1(i,j))<ktV1
        V1(i,j)= aV1(i,j)*exp(n1*(abs(aV1(i,j))-ktV1));
        else
            V1(i,j)= aV1(i,j);
        end
    end
end
for i= 1:r
    for j= 1:s
        if abs(aD1(i,j))<ktD1
        D1(i,j)= aD1(i,j)*exp(n1*(abs(aD1(i,j))-ktD1));
        else
            D1(i,j)= aD1(i,j);
        end
    end
end
for i= 1:a
    for j= 1:b
        if(abs(aH2(i,j))<ktH2)
        H2(i,j)= aH2(i,j)*exp(n2*(abs(aH2(i,j))-ktH2));
        else
            H2(i,j)= aH2(i,j);
        end
    end
end
for i= 1:c
    for j= 1:d
        if abs(aV2(i,j))<ktV2
        V2(i,j)= aV2(i,j)*exp(n2*(abs(aV2(i,j))-ktV2));
        else
            V2(i,j)= aV2(i,j);
        end
    end
end
for i= 1:e
    for j= 1:f
        if abs(aD2(i,j))<ktD2
        D2(i,j)= aD2(i,j)*exp(n2*(abs(aD2(i,j))-ktD2));
        else
            D2(i,j)= aD2(i,j);
        end
    end
end
for i= 1:g
    for j= 1:h
        if(abs(aH3(i,j))<ktH3)
        H3(i,j)= aH3(i,j)*exp(n3*(abs(aH3(i,j))-ktH3));
        else
            H3(i,j)= aH3(i,j);
        end
    end
end
for i= 1:k
    for j= 1:l
        if abs(aV3(i,j))<ktV3
        V3(i,j)= aV3(i,j)*exp(n3*(abs(aV3(i,j))-ktV3));
        else
            V3(i,j)= aV3(i,j);
        end
    end
end
for i= 1:x
    for j= 1:y
        if abs(aD3(i,j))<ktD3
        D3(i,j)= aD3(i,j)*exp(n3*(abs(aD3(i,j))-ktD3));
        else
            D3(i,j)= aD3(i,j);
        end
    end
end
% Take inverse DWT
ILI1=idwt2(aA3,H3,V3,D3,wname);
ILI1=ILI1(1:c,1:d);
ILI2=idwt2(ILI1,H2,V2,D2,wname);
ILI2=ILI2(1:m,1:n);
ILI=idwt2(ILI2,H1,V1,D1,wname);
% Take exponent
II=exp(ILI);
II=uint8(II);
figure, imshow(II);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% PERFORMANCE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [u,v]=size(I1);
% squaredErrorImage = (double(II(1:u,1:v)) - double(I1)) .^ 2;
% MSE(z)= sum(sum(squaredErrorImage)) / (u*v);
% squaredOutputImage= (double(II(1:u,1:v))).^2;
% snr=sum(sum(squaredOutputImage))/ (u*v);
% SNR(z) =10*log10(snr);
% PSNR(z)= 10*log10( 256^2 / MSE(z));
% % SSval_1=ssim(I,I1);
% % SSval_2=ssim(II(1:u,1:v),I1);
% % BETA (edge preservation index)
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
% xlswrite(filename,B,2,'D2')
% xlswrite(filename,C,2,'E2')
% xlswrite(filename,D,2,'F2')
% xlswrite(filename,E,2,'G2')
% % xlswrite(filename,E,2,'G2')
% % xlswrite(filename,F,2,'H2')