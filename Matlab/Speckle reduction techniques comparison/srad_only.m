%%%%%%%%US Image Enhancement using SRAD%%%%%%%%

clc
close all
clear all
g0=imread('ANI_0001.jpg');
g0=rgb2gray(g0);
[m n]=size(g0);
% z=0;
% for w=0.01:0.01:0.2
%     sigma=0.05;
%     z=z+1;
% g0 = imnoise(g,'speckle',sigma);
I=im2double(g0);
% make image a double and normalize
I = double(g0);
mx = max(I(:));
mn = min(I(:));
I = (I-mn)/(mx-mn);

% indices (using boudary conditions)
[M,N] = size(I);
iN = [1, 1:M-1];
iS = [2:M, M];
jW = [1, 1:N-1];
jE = [2:N, N];

%log uncompress and eliminate zero value pixels.
I = exp(I);

% main algorithm
niter=15;
for iter = 1:niter
    % speckle scale function
    Iuniform = I;
    q0_squared = (std(Iuniform(:))/mean(Iuniform(:)))^2;
    % differences
    dN = I(iN,:) - I;
    dS = I(iS,:) - I;
    dW = I(:,jW) - I;
    dE = I(:,jE) - I;
    % normalized discrete gradient magnitude squared (equ 52,53)
    G2 = (dN.^2 + dS.^2 + dW.^2 + dE.^2) ./ (I.^2 + eps);
    %normalized discrete laplacian (equ 54)
    L = (dN + dS + dW + dE) ./ (I + eps);
    % ICOV (equ 31/35)
    num = (.5*G2) - ((1/16)*(L.^2));
    den = (1 + ((1/4)*L)).^2;
    q_squared = num ./ (den + eps);
    % diffusion coefficent (equ 33)
    den = (q_squared - q0_squared) ./ (q0_squared *(1 + q0_squared) + eps);
    c = 1 ./ (1 + den);
    cS = c(iS, :);
    cE = c(:,jE);
    % divergence equ 58
    D = (cS.*dS) + (c.*dN) + (cE.*dE) + (c.*dW);
    % update (equ 61)
    lambda=0.05;
    I = I + (lambda/4)*D;
        
%     err = immse(I,im2double(g));
%     if err<0.1
%         break;
%     end
    
end
I = log(I);
I = uint8(round(I.*255));
% figure, imshow(g0);
figure, imshow(I);

% %%%%%%%%Performance Parameters%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%---2. MSE---%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% squaredErrorImage = (double(I) - double(g)) .^ 2;
% MSE(z) = sum(sum(squaredErrorImage)) / (m*n);
% squaredOutputImage= (double(I)).^2;
% snr=sum(sum(squaredOutputImage))/ (m*n);
% SNR(z)=10*log10(snr);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%---3. PSNR---%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSNR(z) = 10*log10( 255^2 / MSE(z));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%---4. Beta Metric---%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imf=im2double(I);
% Iref=im2double(g);
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
% Bmetric(z) = abs( Db1./(sqrt(Db2*Db3)+eps));
% end
% filename='E:\phd\solan conference paper\results.xlsx';
% B=MSE';
% C=SNR';
% D=PSNR';
% % E=SSval_1';
% % F=SSval_2';
% E=Bmetric';
% %xlswrite(filename,A,'C2')
% xlswrite(filename,B,3,'D2')
% xlswrite(filename,C,3,'E2')
% xlswrite(filename,D,3,'F2')
% xlswrite(filename,E,3,'G2')