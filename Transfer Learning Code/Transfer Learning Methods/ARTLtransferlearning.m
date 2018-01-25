clc
close all
clear

%% Load data
load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
Label(Label==0) = -1
fts = Features;
labels = Label;
fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
Xs = zscore(fts);    clear fts
Ys = labels;           clear labels
Ps = pca(Xs);  % source subspace


%load ('MIAS.mat')     % target domain
load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat')
Label(Label==0) = -1
fts = Features;
labels = Label;
fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
Xt = zscore(fts);     clear fts
Yt = labels;            clear labels
  % target subspace

%% Set algorithm options
options.gamma = 1;
options.lambda = .1;
options.kernel_type = 'linear';
options.T = 10;
options.dim = 100;
options.mu = 0.5;
options.n_neighbor = 2;
options.sigma = 1
%% Run algorithm
[acc,acc_ite,Alpha] = MyARTL(Xs,Ys,Xt,Yt,options);
fprintf('Acc:%.2f',Acc);

plotroc(Yt,Y_tar_pseudo)