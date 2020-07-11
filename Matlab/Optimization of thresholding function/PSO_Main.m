clc;
clear all;
close all;

% Load the image 
I1=imread('testimage_3.png');
I1=rgb2gray(I1);
sigma=0.15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lower=1;
upper=10;
NPSO   = 40;          
c1     = 2;           
c2     = 2;           
weight = 0.5;         
PSOCNT = 4;          

tic;

x = zeros(1,NPSO);
v = zeros(1,NPSO);

x=(upper-lower).*rand(1,NPSO)+lower;
% x=unifrnd(lower,upper, [1 NPSO]);

v=zeros(1,NPSO);

for ss=1:NPSO
%     fval(i)=obj(x(i),I1,sigma);
   % The fitness function 
        I=imnoise(I1,'speckle',sigma);
% Take logarithm of the input image
LI=log(double(I+1));
% Take DWT
[aA1,aH1,aV1,aD1]=dwt2(LI,'sym8');
[aA2,aH2,aV2,aD2]=dwt2(aA1,'sym8');
[aA3,aH3,aV3,aD3]=dwt2(aA2,'sym8');
[m,n]= size(aH1);
[p,q]=size(aV1);
[r,s]=size(aD1);
[a,b]=size(aH2);
[c,d]=size(aV2);
[e,f]=size(aD2);
[g,h]=size(aH3);
[k1,l1]=size(aV3);
[x1,y1]=size(aD3);
% Calculate noise variance of horizontal comp
noisevarH1=(median(aH1(aH1>0))/0.6745);
noisevarH2=(median(aH2(aH2>0))/0.6745);
noisevarH3=(median(aH3(aH3>0))/0.6745);
% Calculate universal threshold for horizontal comp
utH1=(noisevarH1)*sqrt(2*log(m*n));
utH2=(noisevarH2)*sqrt(2*log(a*b));
utH3=(noisevarH3)*sqrt(2*log(g*h));
% Calculate noise variance of vertical comp
noisevarV1=(median(aV1(aV1>0))/0.6745);
noisevarV2=(median(aV2(aV2>0))/0.6745);
noisevarV3=(median(aV3(aV3>0))/0.6745);
% Calculate universal threshold for vertical comp
utV1=(noisevarV1)*sqrt(2*log(p*q));
utV2=(noisevarV2)*sqrt(2*log(c*d));
utV3=(noisevarV3)*sqrt(2*log(k1*l1));
% Calculate noise variance of diagonal comp
noisevarD1=(median(aD1(aD1>0))/0.6745);
noisevarD2=(median(aD2(aD2>0))/0.6745);
noisevarD3=(median(aD3(aD3>0))/0.6745);
% Calculate universal threshold for diagonal comp
utD1=(noisevarD1)*sqrt(2*log(r*s));
utD2=(noisevarD2)*sqrt(2*log(e*f));
utD3=(noisevarD3)*sqrt(2*log(x1*y1));
% Processing sub-bands with the thresholding function
n1=3;%input('Enter the value of n1 :');
n2=2;%input('Enter the value of n2 :');
n3=0.5;%input('Enter the value of n3 :');
ktH1= (utH1)/log(2);
ktV1= (utV1)/log(2);
ktD1= (utD1)/log(2);
ktH2= (utH2)/log(3);
ktV2= (utV2)/log(3);
ktD2= (utD2)/log(3);
ktH3= (utH3)/log(4);
ktV3= (utV3)/log(4);
ktD3= (utD3)/log(4);
for i= 1:m
    for j= 1:n
        if(abs(aH1(i,j))<ktH1)
        H1(i,j)= aH1(i,j)*(x(ss))^(n1*(abs(aH1(i,j))-ktH1));
        else
            H1(i,j)= aH1(i,j);
        end
    end
end
for i= 1:p
    for j= 1:q
        if abs(aV1(i,j))<ktV1
        V1(i,j)= aV1(i,j)*(x(ss))^(n1*(abs(aV1(i,j))-ktV1));
        else
            V1(i,j)= aV1(i,j);
        end
    end
end
for i= 1:r
    for j= 1:s
        if abs(aD1(i,j))<ktD1
        D1(i,j)= aD1(i,j)*(x(ss))^(n1*(abs(aD1(i,j))-ktD1));
        else
            D1(i,j)= aD1(i,j);
        end
    end
end
for i= 1:a
    for j= 1:b
        if(abs(aH2(i,j))<ktH2)
        H2(i,j)= aH2(i,j)*(x(ss))^(n2*(abs(aH2(i,j))-ktH2));
        else
            H2(i,j)= aH2(i,j);
        end
    end
end
for i= 1:c
    for j= 1:d
        if abs(aV2(i,j))<ktV2
        V2(i,j)= aV2(i,j)*(x(ss))^(n2*(abs(aV2(i,j))-ktV2));
        else
            V2(i,j)= aV2(i,j);
        end
    end
end
for i= 1:e
    for j= 1:f
        if abs(aD2(i,j))<ktD2
        D2(i,j)= aD2(i,j)*(x(ss))^(n2*(abs(aD2(i,j))-ktD2));
        else
            D2(i,j)= aD2(i,j);
        end
    end
end
for i= 1:g
    for j= 1:h
        if(abs(aH3(i,j))<ktH3)
        H3(i,j)= aH3(i,j)*(x(ss))^(n3*(abs(aH3(i,j))-ktH3));
        else
            H3(i,j)= aH3(i,j);
        end
    end
end
for i= 1:k1
    for j= 1:l1
        if abs(aV3(i,j))<ktV3
        V3(i,j)= aV3(i,j)*(x(ss))^(n3*(abs(aV3(i,j))-ktV3));
        else
            V3(i,j)= aV3(i,j);
        end
    end
end
for i= 1:x1
    for j= 1:y1
        if abs(aD3(i,j))<ktD3
        D3(i,j)= aD3(i,j)*(x(ss))^(n3*(abs(aD3(i,j))-ktD3));
        else
            D3(i,j)= aD3(i,j);
        end
    end
end
% Take inverse DWT
ILI1=idwt2(aA3,H3,V3,D3,'sym8');
ILI1=ILI1(1:c,1:d);
ILI2=idwt2(ILI1,H2,V2,D2,'sym8');
ILI2=ILI2(1:m,1:n);
ILI=idwt2(ILI2,H1,V1,D1,'sym8');
% Take exponent
II=exp(ILI);
II=uint8(II);
%figure, imshow(II)
[u1,v1]=size(I1);
% squaredErrorImage = (double(II(1:u1,1:v1)) - double(I1)) .^ 2;
% MSE = sum(sum(squaredErrorImage)) / (u1*v1);
% squaredOutputImage= (double(II(1:u1,1:v1))).^2;
% snr=sum(sum(squaredOutputImage))/ (u1*v1);
% SNR=10*log10(snr);
% PSNR= 10*log10( 255^2 / MSE);
%SSval_1(z)=ssim(I,I1);
%SSval_2=ssim(II(1:u,1:v),I1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% BETA METRIC %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offset=0;
% ImL = I1;
ImL = im2double(I1);

  % Second Derivative (Laplacian)
ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
[height weight] = size(ImL);

Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
HPg = Ixx+Iyy+Ixy;

clear ImL; 
clear ImAux;

ImL = im2double(II(1:u1,1:v1));

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



for h=1:height
    for w=1:weight
        
        if(dg(h,w)>-offset && dg(h,w)<offset)
            dg(h,w)=0;
        end
        
        if(df(h,w)>-offset && df(h,w)<offset)
            df(h,w)=0;
        end
        
    end
end


Db1 = sum(sum(dg.*df));
Db2 = sum(sum(dg.*dg));
Db3 = sum(sum(df.*df));

Bmetric(ss) = abs (Db1./(sqrt(Db2*Db3)+eps));

fval(ss)=Bmetric(ss);
end
[mag loc]=max(fval);

gBest      = x(loc);
Fval_gBest = mag;
fprintf('\n    Initialize gBest, gBestFitVal = %e; ',Fval_gBest);

pBest      = x;
Fval_pBest = zeros(NPSO,1);
for k=1:NPSO
    Fval_pBest(k)  = obj(pBest(k),I1,sigma);
    
    if Fval_pBest(k)>Fval_gBest
        Fval_gBest = Fval_pBest(k);
        gBest      = pBest(k);
        fprintf('\n    Update gBest, gBestFitVal = %e; ',Fval_gBest);
    end
end


tic;
pBestUpdateCNT = zeros(1,PSOCNT);
gBestUpdateCNT = zeros(1,PSOCNT);
Fval_gBestCNT  = zeros(1,PSOCNT);
for t = 1:PSOCNT
    fprintf('\nt = %d; ',t);
    for k = 1:NPSO
        
        R1 = rand;
        R2 = rand;
        v(k) = weight*v(k)+c1*R1.*(pBest(k)-x(k))+c2*R2.*(gBest-x(k));
        x(k) = x(k)+v(k);
        if(x(k)<lower)
            x(k)=unifrnd(lower,upper);
%         elseif(x(k)>upper)
%             x(k)=upper;
%         else
%             x(k)=x(k);
        end
        F = obj(x(k),I1,sigma);
        
        if F<Fval_pBest(k)
            Fval_pBest(k)     = F;
            pBest(k)        = x(k);
            pBestUpdateCNT(t) = pBestUpdateCNT(t)+1;
        end
        % 更新全局最优值
        if Fval_pBest(k)>Fval_gBest
            Fval_gBest = Fval_pBest(k);
            gBest      = pBest(k);
            fprintf('\n    Update gBest, gBestFitVal = %e; ',Fval_gBest);
            gBestUpdateCNT(t)=gBestUpdateCNT(t)+1;
        end
    end
    Fval_gBestCNT(t) = Fval_gBest;
end
fprintf('\nLastgBestFitVal = %e; \n',Fval_gBest);
toc;



