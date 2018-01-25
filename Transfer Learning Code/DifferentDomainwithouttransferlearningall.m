clc
close all
clear

addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning\libsvm-3.11\matlab');
addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning');

%load('DDSMPATCHES.mat');
load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
Label(Label==0) = -1;
numOfTrain = 1000;
%PCA first
options=[];
options.ReducedDim = 200;
[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;
% Features = zscore(Features');Features = Features';
% Features = CentralizeFea(Features,0);
% Features = NormalizeFea(Features,0);
trainData = Features;
trainData = zscore(trainData);
trainLabel = Label;
% Loading the Inbreast Data
%Loading the Target Data
load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
%load ('MIAS.mat')
%load('MIASPATCHES.mat');
Label(Label==0) = -1;
testLabel = Label;
%options=[];
%options.ReducedDim = 100;
%[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;
testData = Features;
testData = zscore(testData);
% Train the SVM
model = svmtrain(trainLabel, trainData, '-t 0 -c 1');
% Use the SVM model to classify the data
 [predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 0'); % run the SVM model on the test data

 % testing on MIAS Dataset
 load ('MIAS.mat')
%load('MIASPATCHES.mat');
Label(Label==0) = -1;
testLabel1 = Label;
%options=[];
%options.ReducedDim = 100;
%[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;
testData1 = Features;
testData1 = zscore(testData1);
% Train the SVM
model1 = svmtrain(trainLabel, trainData, '-t 0 -c 1');
% Use the SVM model to classify the data
 [predict_label1, accuracy1, prob_values1] = svmpredict(testLabel1, testData1, model, '-b 0'); % run the SVM model on the test data

 
 
 % Testing on MIAS datasets
 
 
 
load('DDSMPATCHES.mat');

Label(Label==0) = -1;
numOfTrain = 1000;
%PCA first
options=[];
options.ReducedDim = 200;
[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;
% Features = zscore(Features');Features = Features';
% Features = CentralizeFea(Features,0);
% Features = NormalizeFea(Features,0);
trainData2 = Features;
trainData2 = zscore(trainData2);
trainLabel2 = Label;
% Loading the Inbreast Data
%Loading the Target Data
load('MIASPATCHES.mat');
Label(Label==0) = -1;
testLabel2 = Label;
%options=[];
%options.ReducedDim = 100;
%[eigvector,eigvalue] = PCA(Features,options);
Features = Features*eigvector;
testData2 = Features;
testData2 = zscore(testData2);
% Train the SVM
model4 = svmtrain(trainLabel2, trainData2, '-t 0 -c 1');
% Use the SVM model to classify the data
 [predict_label2, accuracy2, prob_values2] = svmpredict(testLabel2, testData2, model4, '-b 0'); % run the SVM model on the test data

 
 
 
 
 
 
 
 
   
 
 auc = plotroc(testLabel,testData,':r','InBreast',model);
%auc = plotroc(Label,Features, '-v 5 -t 0 -c 1');
hold on;
auc1 = plotroc(testLabel1,testData1,'--b','MIAS',model1);
auc2 = plotroc(testLabel2,testData2, '-.k','MIAS PATCHES',model4);

legend('Location','northwest')
lgd = legend('show');
lgd.FontSize = 13
title(lgd,'AUC')
set(gca,'fontsize',13)
set(gcf, 'PaperPosition', [0 0 8 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [8 5]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'NORMAL-ROC2', 'pdf')


hold off