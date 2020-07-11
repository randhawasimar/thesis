% Texture classification of outex database using CLBP/VAR 
clc;
clear all;
close all;
% images and labels folder
% please download Outex Database from http://www.outex.oulu.fi, then
% extract Outex_TC_00010 to the "rootpic" folder
rootpic = 'E:\MATLAB\programs\rootpic\Outex_TC_00010\';
% rootpic = 'E:\MATLAB\programs\rootpic\Outex_TC_0012\';
% picture number of the database
picNum = 4320;
% picNum = 1440;

% Radius and Neighborhood
R=1;
P=8;

% genearte CLBP features
patternMappingriu2 = getmapping(P,'riu2');
for i=1:picNum;
    filename = sprintf('%s\\images\\%06d.bmp', rootpic, i-1);
    Gray = imread(filename);
    Gray = im2double(Gray);
    Gray = imnoise(Gray,'speckle',0.03);
    Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128; % image normalization, to remove global intensity
   
    imgExt = padarray(Gray,[1 1],'symmetric','both');
    imgblks = im2col(imgExt,[3 3],'sliding');
    a = mean(imgblks);
    Gray = reshape(a,size(Gray));
    
    [CLBP_S,CLBP_M,CLBP_C,VAR] = vclbp(Gray,R,P,patternMappingriu2,'x');
    
    % Generate histogram of CLBP_S
%     CLBP_SH(i,:) = histogram(CLBP_S(:),0:patternMappingriu2.num-1);
    CLBP_SH(i,:)=imhist(CLBP_S(:));
    
    % Generate histogram of CLBP_M
    CLBP_MH(i,:) = imhist(CLBP_M(:));    
    
    % Generate histogram of VAR
    VARH(i,:) = imhist(VAR(:));  
    
    % Generate histogram of CLBP_SM
      CLBP_SM = [CLBP_S(:),CLBP_M(:)];
%     Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
      Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
      CLBP_SMH(i,:) = reshape(Hist3D,1,numel(Hist3D));
    
    % Generate histogram of CLBP_SVAR
      CLBP_SVAR = [CLBP_S(:),VAR(:)];
%     Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
      Hist3D = hist3(double(CLBP_SVAR),[patternMappingriu2.num,patternMappingriu2.num]);
      CLBP_SVH(i,:) = reshape(Hist3D,1,numel(Hist3D));
      
      % Generate histogram of CLBP_SVAR/CLBP_SM
      CLBP_SMVAR = [CLBP_SVAR(:), CLBP_SM(:)];
      %     Hist3D = hist3(double(CLBP_SM),[patternMappingriu2.num,patternMappingriu2.num]);
      Hist3D = hist3(double(CLBP_SMVAR),[patternMappingriu2.num,patternMappingriu2.num]);
      CLBP_SMVARH(i,:) = reshape(Hist3D,1,numel(Hist3D));
%       
%       % Generate histogram of CLBP_S/M/C
    CLBP_MCSum = CLBP_M;
    idx = find(CLBP_C);
    CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMappingriu2.num;
    CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%     Hist3D = hist3(CLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
    Hist3D = hist3(double(CLBP_SMC),[patternMappingriu2.num,patternMappingriu2.num]);
    CLBP_SMCH(i,:) = reshape(Hist3D,1,numel(Hist3D));
   
    % Generate histogram of M_C
    CLBP_MCSumH(i,:)=imhist(CLBP_MCSum);
    
    % Generate histogram of SMC and SVAR
    VCLBP = [CLBP_SMC(:),CLBP_SVAR(:)];
    Hist3D = hist3(double(VCLBP),[patternMappingriu2.num,patternMappingriu2.num]);
    VCLBPH(i,:) = reshape(Hist3D,1,numel(Hist3D));
end
CLBP_SH=CLBP_SH(:,1:10);
CLBP_MH=CLBP_MH(:,1:10);
CLBP_VH=VARH(:,1:10);
CLBP_MCSumH=CLBP_MCSumH(:,1:10);
% CLBP_S_M_V=[CLBP_SH, CLBP_MH, CLBP_VH];
% CLBP_S_M_C_V=[CLBP_SH, CLBP_MCSumH, CLBP_VH];
CLBP_S_M=[CLBP_SH, CLBP_MH];
% read picture ID of training and test samples, and read class ID of
% training and test samples
trainTxt = sprintf('%s000\\train.txt', rootpic);
testTxt = sprintf('%s000\\test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);

% % classification test using CLBP_S (LBP)
% trains = CLBP_SH(trainIDs,:);
% tests = CLBP_SH(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_SH=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% 
% % classification test using CLBP_S, VAR
% trains = CLBP_SVH(trainIDs,:);
% tests = CLBP_SVH(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_SV=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% 
% % % classification test using CLBP_S, VAR
% % CLBP_S_V = [CLBP_SH , CLBP_VH];
% % trains = CLBP_SVH(trainIDs,:);
% % tests = CLBP_SVH(testIDs,:);
% % trainNum = size(trains,1); 
% % testNum = size(tests,1);
% % DistMat = zeros(P,trainNum);
% % DM = zeros(testNum,trainNum);
% % for i=1:testNum;
% %     test = tests(i,:);        
% %     DM(i,:) = distMATChiSquare(trains,test)';
% % end
% % CP_S_V=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% 
% % classification test using CLBP_M
% trains = CLBP_MH(trainIDs,:);
% tests = CLBP_MH(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_M=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% 
% % % classification test using CLBP_M/C
% % trains = CLBP_MCH(trainIDs,:);
% % tests = CLBP_MCH(testIDs,:);
% % trainNum = size(trains,1);
% % testNum = size(tests,1);
% % DistMat = zeros(P,trainNum);
% % DM = zeros(testNum,trainNum);
% % for i=1:testNum;
% %     test = tests(i,:);        
% %     DM(i,:) = distMATChiSquare(trains,test)';
% % end
% % CP_M_C=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% 
% % classification test using CLBP_S_M/C
% trains = CLBP_SMCH(trainIDs,:);
% tests = CLBP_SMCH(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_SMCH=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_S/M
% trains = CLBP_SMH(trainIDs,:);
% tests = CLBP_SMH(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_SM=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% % classification test using CLBP_S/M/VAR
% trains = CLBP_S_M_V(trainIDs,:);
% tests = CLBP_S_M_V(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_S_M_V=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% xlswrite(filename,CP_SV,1,'A2');
% xlswrite(filename,CP_SMCH,1,'B2');
% xlswrite(filename,CP_SM,1,'C2');
% xlswrite(filename,CP_SMVAR,1,'D2');

% % classification test using CLBP_S/M/C/VAR
% 
% trains = CLBP_S_M_C_V(trainIDs,:);
% tests = CLBP_S_M_C_V(testIDs,:);
% trainNum = size(trains,1);
% testNum = size(tests,1);
% DistMat = zeros(P,trainNum);
% DM = zeros(testNum,trainNum);
% for i=1:testNum;
%     test = tests(i,:);        
%     DM(i,:) = distMATChiSquare(trains,test)';
% end
% CP_S_M_C_V=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_S/M/C/VAR

trains = VCLBPH(trainIDs,:);
tests = VCLBPH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP_VCLBPH=ClassifyOnNN(DM,trainClassIDs,testClassIDs)
% A=CP_SV;
% B=CP_M;
% C=CP_SMCH;
% D=CP_SM;
% E=CP_SH;
filename='E:\phd\paper3 (Texture classification)\results';
sheet=1;
% xlswrite(filename,A,sheet,'O11')
% xlswrite(filename,B,sheet,'P11')
% xlswrite(filename,C,sheet,'Q11')
% xlswrite(filename,D,sheet,'R11')
% xlswrite(filename,E,sheet,'S11')
% xlswrite(filename,CP_VCLBPH,sheet,'Q21')