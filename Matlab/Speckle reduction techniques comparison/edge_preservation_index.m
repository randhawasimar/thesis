clc;
clear all;
% if ~exist('offset')
   offset=0;
%    fprintf(1,'PLEASE SET OFFSET. e.g. offset=0.01;');
% end
I1=imread('testimage_3.png');
I1=rgb2gray(I1);

ImL = im2double(I1);
I=imnoise(I1,'speckle',0.01);

  % Second Derivative (Laplacian)
ImAux = single(padarray(ImL,[1 1],'symmetric','both'));
[height weight] = size(ImL);

Ixx = single(ImAux(2:height+1,3:weight+2) - 2*ImL + ImAux(2:height+1,1:weight));   % East-West
Iyy = single(ImAux(3:height+2,2:weight+1) - 2*ImL + ImAux(1:height,2:weight+1));   % South-North
Ixy = single(1/4*(ImAux(1:height,3:weight+2)+ImAux(3:height+2,1:weight)-ImAux(1:height,1:weight)-ImAux(3:height+2,3:weight+2)));
HPg = Ixx+Iyy+Ixy;

clear ImL; 
clear ImAux;

ImL = im2double(I);

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

Bmetric = Db1./(sqrt(Db2*Db3)+eps);     % As defined by [1]

