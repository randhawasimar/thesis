% Texture classification of Cirrhosis and normal ultrasound database using CLBP/VAR 
clc;
clear all;
close all;
% images and labels folder
CLASSES = 2
TRAINSAMPLES=135;
TESTSAMPLES=138;
classnames = {'CIR';'N'};
% Radius and Neighborhood
R=3;
P=24;
% genearte CLBP features
patternMappingriu2 = getmapping(P,'riu2');

for n=1:60
    c=1;
    indx = n;
    test_set(indx).name = [char(classnames(c)) '_test_' num2str(n,'%03d')];
    test_set(indx).class = c;
end
for n=1:78
    c=2;
    indx =n+60;
    test_set(indx).name = [char(classnames(c)) '_test_' num2str(n,'%03d')];
    test_set(indx).class = c;
end
for indx=1:138
         Gray = load([test_set(indx).name '.mat']);
%          Gray = im2double(Gray);
%          Gray = imnoise(Gray,'speckle',0.1);
%          imgExt = padarray(Gray,[1 1],'symmetric','both');
%          imgblks = im2col(imgExt,[3 3],'sliding');
%          x = mean(imgblks);
%          Gray = reshape(x,size(Gray));
         image_cell=struct2cell(Gray);
         Gray=image_cell{1,1};
         test_set(indx).image = Gray;
         [CLBP_S,CLBP_M,CLBP_C,VAR] = vclbp(Gray,R,P,patternMappingriu2,'x');
         % Generate histogram of CLBP_S
         CLBP_SH = histogram(CLBP_S(:),0:patternMappingriu2.num-1);
%          CLBP_SH=imhist(CLBP_S(:));
    
         % Generate histogram of CLBP_M
%          CLBP_MH = imhist(CLBP_M(:));    
    
         % Generate histogram of VAR
         VARH = imhist(VAR(:));  
    
         % Generate histogram of CLBP_SM
         CLBP_SM = [CLBP_S(:),CLBP_M(:)];
%         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         CLBP_SMH = reshape(Hist3D,1,numel(Hist3D));
    
         % Generate histogram of CLBP_SVAR
         CLBP_SVAR = [CLBP_S(:),VAR(:)];
%          Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         Hist3D = hist3(double(CLBP_SVAR),[patternMappingriu2.num,patternMappingriu2.num]);
         CLBP_SVH = reshape(Hist3D,1,numel(Hist3D));
      
        % Generate histogram of CLBP_SVAR/CLBP_SM
        CLBP_SMVAR = [CLBP_SVAR(:), CLBP_SM(:)];
%         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
        Hist3D = hist3(double(CLBP_SMVAR),[patternMappingriu2.num,patternMappingriu2.num]);
        CLBP_SMVARH = reshape(Hist3D,1,numel(Hist3D));
%       
        % Generate histogram of CLBP_S/M/C
        CLBP_MCSum = CLBP_M;
        idx = find(CLBP_C);
        CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMappingriu2.num;
        CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%       Hist3D = hist3(CLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
        Hist3D = hist3(double(CLBP_SMC),[patternMappingriu2.num,patternMappingriu2.num]);
        CLBP_SMCH = reshape(Hist3D,1,numel(Hist3D));
   
        % Generate histogram of M_C
        CLBP_MCSumH=imhist(CLBP_MCSum);
    
        % Generate histogram of SMC and SVAR
        VCLBP = [CLBP_SMC(:),CLBP_SVAR(:)];
        Hist3D = hist3(double(VCLBP),[patternMappingriu2.num,patternMappingriu2.num]);
        VCLBPH = reshape(Hist3D,1,numel(Hist3D));
        test_set(indx).histogram = VCLBPH;
%         test_set(indx).histogram = CLBP_SMCH;
%         test_set(indx).histogram = CLBP_SMH;
end
% CLBP_SH=CLBP_SH(:,1:10);
% CLBP_MH=CLBP_MH(:,1:10);
% CLBP_VH=VARH(:,1:10);
% CLBP_MCSumH=CLBP_MCSumH(:,1:10);
% CLBP_S_M_V=[CLBP_SH, CLBP_MH, CLBP_VH];
% CLBP_S_M_C_V=[CLBP_SH, CLBP_MCSumH, CLBP_VH];
% CLBP_S_M=[CLBP_SH, CLBP_MH];
for n=1:60
    c=1;
    indx=n;
    train_set(indx).name = [char(classnames(c)) '_train_' num2str(n,'%03d')];
    train_set(indx).class = c;
end
for n=1:75
    c=2;
    indx=60+n;
    train_set(indx).name = [char(classnames(c)) '_train_' num2str(n,'%03d')];
    train_set(indx).class = c;
end
for indx=1:135
    Gray = load([train_set(indx).name '.mat']); 
         image_cell=struct2cell(Gray);
         Gray=image_cell{1,1};
%          Gray = im2double(Gray);
%          Gray = imnoise(Gray,'speckle',0.01);
%          imgExt = padarray(Gray,[1 1],'symmetric','both');
%          imgblks = im2col(imgExt,[3 3],'sliding');
%          x = mean(imgblks);
%          Gray = reshape(x,size(Gray));
         train_set(indx).image = Gray;
         [CLBP_S,CLBP_M,CLBP_C,VAR] = vclbp(Gray,R,P,patternMappingriu2,'x');
         % Generate histogram of CLBP_S
         CLBP_SH = histogram(CLBP_S(:),0:patternMappingriu2.num-1);
%          CLBP_SH(:,indx)=imhist(CLBP_S(:));
    
         % Generate histogram of CLBP_M
%          CLBP_MH = imhist(CLBP_M(:));    
    
         % Generate histogram of VAR
%          VARH = imhist(VAR(:));  
    
         % Generate histogram of CLBP_SM
         CLBP_SM = [CLBP_S(:),CLBP_M(:)];
%         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         CLBP_SMH = reshape(Hist3D,1,numel(Hist3D));
    
         % Generate histogram of CLBP_SVAR
         CLBP_SVAR = [CLBP_S(:),VAR(:)];
%          Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
         Hist3D = hist3(double(CLBP_SVAR),[patternMappingriu2.num,patternMappingriu2.num]);
         CLBP_SVH = reshape(Hist3D,1,numel(Hist3D));
      
        % Generate histogram of CLBP_SVAR/CLBP_SM
        CLBP_SMVAR = [CLBP_SVAR(:), CLBP_SM(:)];
%         Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
        Hist3D = hist3(double(CLBP_SMVAR),[patternMappingriu2.num,patternMappingriu2.num]);
        CLBP_SMVARH = reshape(Hist3D,1,numel(Hist3D));
%       
        % Generate histogram of CLBP_S/M/C
        CLBP_MCSum = CLBP_M;
        idx = find(CLBP_C);
        CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMappingriu2.num;
        CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%       Hist3D = hist3(CLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
        Hist3D = hist3(double(CLBP_SMC),[patternMappingriu2.num,patternMappingriu2.num]);
        CLBP_SMCH = reshape(Hist3D,1,numel(Hist3D));
   
        % Generate histogram of M_C
%         CLBP_MCSumH=imhist(CLBP_MCSum);
    
        % Generate histogram of SMC and SVAR
        VCLBP = [CLBP_SMC(:),CLBP_SVAR(:)];
        Hist3D = hist3(double(VCLBP),[patternMappingriu2.num,patternMappingriu2.num]);
        VCLBPH = reshape(Hist3D,1,numel(Hist3D));
        train_set(indx).histogram = VCLBPH;
%         train_set(indx).histogram = CLBP_SMCH;
%         train_set(indx).histogram = CLBP_SMH;
      
end
models = zeros(CLASSES,676); %% no of bins %% R=1,100 bins; R=2,324 bins; R=3,676 bins  update accordingly

for i=1:TRAINSAMPLES
   models(train_set(i).class,:) = models(train_set(i).class,:) + train_set(i).histogram;
end;

distances=zeros(TESTSAMPLES,CLASSES); 

for i = 1:TESTSAMPLES
   for j = 1:CLASSES
      distances(i,j) = CUM_LOG(test_set(i).histogram, models(j,:));
   end;
end;

[dist, ind] = min(distances,[],2);

cm = zeros(16,16);
correct=0;
wrong=0;
for i = 1:TESTSAMPLES
   cm(test_set(i).class, ind(i)) = cm(test_set(i).class, ind(i))+1;
   if test_set(i).class == ind(i)
      correct=correct+1;
   else
      wrong=wrong+1;
      mis(wrong).name = test_set(i).name;
      mis(wrong).classification = ind(i);
   end;
end;
error_rate = wrong/TESTSAMPLES;

disp('Error rate');
disp(error_rate);
disp('Confusion Matrix');
disp(cm);

disp('Misclassified samples');
for z=1:wrong
   disp([mis(z).name ' -> ' char(classnames(mis(z).classification))]);
end;