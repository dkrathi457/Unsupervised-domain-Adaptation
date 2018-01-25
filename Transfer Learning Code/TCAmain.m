clc
close all
clear

addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Transfer Learning Code')
%whole image feature path
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\Inbreast\Resnet Full Image Classifier')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\MIAS\MIAS whole Images')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\DDSM\Resnet Full Image classifier')
%patch feature path
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\DDSM\Patch Features')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\MIAS\MIAS Patches')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\libsvm-3.11\matlab')


% load source
load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
%load('DDSMPATCHES.mat');
Label(Label==0) = -1;

srcData = Features;
% srcData = CentralizeFea(srcData,1);
% srcData = NormalizeFea(srcData,1);
srcData = zscore(srcData); %srcData = srcData';
srcLabel = Label;
clear Features Label

% load target
%load ('MIAS.mat')
%load('MIASPATCHES.mat');

load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
Label(Label==0) = -1;

tarData = Features;
% tarData = CentralizeFea(tarData,1);
% tarData = NormalizeFea(tarData,1);
tarData = zscore(tarData); %tarData = tarData';
tarLabel = Label;
clear Features Label

%PCA first
% options=[];
% options.ReducedDim = 50;
% [eigvector,eigvalue] = PCA([srcData;tarData],options);
% srcData = srcData*eigvector;
% tarData = tarData*eigvector;

% TCA
options = [];
options.lambda = 1;              %% lambda for the regularization
options.dim = 1000;                    %% dim is the dimension after adaptation
options.kernel_type = 'rbf';    %% kernel_type is the kernel name, primal|linear|rbf
options.gamma = .1;                %% gamma is the bandwidth of rbf kernel

[srcData,tarData,A] = MyTCA(srcData,tarData,options);


%% single test
% Train the SVM
model = svmtrain(srcLabel, srcData, '-t 0 -c 1');
% Use the SVM model to classify the data
[predict_label, accuracy, prob_values] = svmpredict(tarLabel, tarData, model, '-b 0'); % run the SVM model on the test data
%%
auc = plotroc(tarLabel,tarData, ':r', 'TCA',  model);
%hold on
%auc1 = plotroc(Yt,Y_tar_pseudo, 'BDA')
%legend('show');
%plotroc(tarLabel,predict_label)

%% transfer learning

% % Features = zscore(Features');Features = Features';
% % Features = CentralizeFea(Features,0);
% % Features = NormalizeFea(Features,0);
%
% % pick training data
% posInd = find(Label==1);
% negInd = find(Label==-1);
%
% trainData = [Features(posInd(1:numOfTrain),:); Features(negInd(1:numOfTrain),:)];
% trainLabel = [ones(numOfTrain,1);-ones(numOfTrain,1)];
%
% testData = [Features(posInd(numOfTrain+1:end),:); Features(negInd(numOfTrain+1:end),:)];
% testLabel = [ones(length(posInd(numOfTrain+1:end)),1); -ones(length(negInd(numOfTrain+1:end)),1)];
%
% % Train the SVM
% model = svmtrain(trainLabel, trainData, '-t 0 -c 1');
% % Use the SVM model to classify the data
% % [predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 0'); % run the SVM model on the test data
%
% auc = plotroc(Label,Features, '-v 5 -t 0 -c 1');