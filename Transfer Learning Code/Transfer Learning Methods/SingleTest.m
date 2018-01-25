clc
close all
% clear

addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning\libsvm-3.11\matlab');
addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning');

load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
Label(1) = [];
Label(Label==0) = -1;

numOfTrain = 1000;

%PCA first
options=[];
options.ReducedDim = 100;
[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;

% Features = zscore(Features');Features = Features';
% Features = CentralizeFea(Features,0);
% Features = NormalizeFea(Features,0);

% pick training data
posInd = find(Label==1);
negInd = find(Label==-1);

trainData = [Features(posInd(1:numOfTrain),:); Features(negInd(1:numOfTrain),:)];
trainLabel = [ones(numOfTrain,1);-ones(numOfTrain,1)];

testData = [Features(posInd(numOfTrain+1:end),:); Features(negInd(numOfTrain+1:end),:)];
testLabel = [ones(length(posInd(numOfTrain+1:end)),1); -ones(length(negInd(numOfTrain+1:end)),1)];

% Train the SVM
model = svmtrain(trainLabel, trainData, '-t 0 -c 1');
% Use the SVM model to classify the data
% [predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 0'); % run the SVM model on the test data

auc = plotroc(Label,Features, '-v 5 -t 0 -c 1');