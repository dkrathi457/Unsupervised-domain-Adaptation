DDSMfeatures = csvread('D:\Inbreastfeatures.csv');
Label1 = N_Label;

p = .7      % proportion of rows to select for training
N = size(DDSMfeatures,1)  % total number of rows 
tf = false(N,1)    % create logical index vector
tf(1:round(p*N)) = true     
tf = tf(randperm(N))   % randomise order
dataTraining = DDSMfeatures(tf,:) ;
labelTraining = Label1(tf,:);
dataTesting = DDSMfeatures(~tf,:) ;
labelTesting = Label1(~tf,:);

 options=[];
 options.ReducedDim=100;
[eigvector,eigvalue] = PCA(dataTraining,options);
% pcaTime = toc;

pcaTestFea = dataTesting*eigvector;
pcaTrainFea = dataTraining*eigvector;

norm_train = NormalizeFea(pcaTrainFea,1);
norm_test = NormalizeFea(pcaTestFea, 1);


pcaTrainFea = norm_train;
pcaTestFea = norm_test;


Mdl = fitcknn(pcaTrainFea,labelTraining,'NumNeighbors',5,'Standardize',1)