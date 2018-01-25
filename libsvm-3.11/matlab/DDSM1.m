DDSMfeatures = csvread('D:\DDSMfeatures.csv');
Label1 = N_Label;

% Import Labels

p = .9      % proportion of rows to select for training
N = size(DDSMfeatures,1)  % total number of rows 
tf = false(N,1)    % create logical index vector
tf(1:round(p*N)) = true     
tf = tf(randperm(N))   % randomise order
dataTraining = DDSMfeatures(tf,:) ;
labelTraining = Label1(tf,:);
dataTesting = DDSMfeatures(~tf,:) ;
labelTesting = Label1(~tf,:);

 options=[];
 options.ReducedDim=1024;
[eigvector,eigvalue] = PCA(dataTraining,options);
% pcaTime = toc;

pcaTestFea = dataTesting*eigvector;
pcaTrainFea = dataTraining*eigvector;

norm_train = NormalizeFea(pcaTrainFea,1);
norm_test = NormalizeFea(pcaTestFea, 1);


pcaTrainFea = norm_train;
pcaTestFea = norm_test;
Mdl = fitcknn(pcaTrainFea,labelTraining,'NumNeighbors',2,'Standardize',1)

cpre = predict(Mdl,pcaTestFea)

accuracy = sum(labelTesting == cpre) / numel(labelTesting);
accuracyPercentage = 100*accuracy;

rloss = resubLoss(Mdl)
CVMdl = crossval(Mdl);
kloss = kfoldLoss(CVMdl)
