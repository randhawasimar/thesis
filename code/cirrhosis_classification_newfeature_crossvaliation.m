% % % Classification of Cirrhosis and normal ultrasound database using CLBP/VAR % % %
clc;
clear all;
close all;

% % % samples % % %
CLASSES = 2
TRAINSAMPLES=131;
TESTSAMPLES=131;
classnames = {'CIR';'N'};

% % % Radius and Neighborhood % % %
r=100;%(r1=100;r2=324;r3=676)
rn=101;%(r1=101;r2=325;r3=677)
% R=3;
% P=24;

% % % Read CLBP/VAR features from excel sheet % % %
filename='E:\phd\paper4\feature histograms\imagehistogramsR1.xlsx';
% filename='E:\phd\paper4\feature histograms\imagehistogramsR2.xlsx';
% filename='E:\phd\paper4\feature histograms\imagehistogramsR3.xlsx';
N=xlsread(filename,1); % Radius 1
C=xlsread(filename,2); % Radius 1
% N=xlsread(filename,1); % Radius 2
% C=xlsread(filename,2); % Radius 2
% N=xlsread(filename,1); % Radius 3
% C=xlsread(filename,2); % Radius 3

% % % CROSS VALIDATION % % %
Nor=N(randperm(end),:);
Cir=C(randperm(end),:);

% % % TEST SAMPLES % % %
for i=1:56
    c=1;
    indx=i;
    test_set(indx).histogram=Cir(i,1:r);%(100;324;676)
    test_set(indx).name=Cir(i,rn);%(101;325;677)
    test_set(indx).class = c;
end
for i=1:75
    c=2;
    indx=56+i;
    test_set(indx).histogram=Nor(i,1:r);%(100;324;676)
    test_set(indx).name=Nor(i,rn);%(101;325;677)
    test_set(indx).class = c;
end

% % % TRAIN SAMPLES % % %
for n=57:112
    c=1;
    indx=n-56;
    train_set(indx).histogram=Cir(n,1:r);%(100;324;676)
    train_set(indx).name=Cir(n,rn);%(101;325;677)
    train_set(indx).class = c;
end
for n=76:150
    c=2;
    indx=(n-75)+56;
    train_set(indx).histogram=Nor(n,1:r);%(100;324;676)
    train_set(indx).name=Nor(n,rn);%(101;325;677)
    train_set(indx).class = c;
end

models = zeros(CLASSES,r); %% no of bins %% R=1,100 bins; R=2,324 bins; R=3,676 bins  update accordingly

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
   disp([mis(z).name ' -> ' (classnames(mis(z).classification))]);
end;

