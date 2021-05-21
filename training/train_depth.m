%train depth network
clear all;
%load('trccc_data_sync_depth_dsin_4x50','Xtr1','tar1');
load('trc3_data_sync_dsin_4x50','Xtr1','tar1');
load('v_data_sync_dsin_4x50','Xtrc','tarc');


numFeat = size(Xtr1,2);
numoutputs = size(tar1,2);

layers = [...
    sequenceInputLayer(numFeat);
    fullyConnectedLayer(500, 'Name','hidden1');
    reluLayer('Name','relu1');
    fullyConnectedLayer(500, 'Name','hidden2');
    reluLayer('Name','relu2');
    fullyConnectedLayer(numoutputs, 'Name','outputlayer');
    regressionLayer('Name','regr')];

%lgraph = layerGraph(layers);

% options = trainingOptions('adam', ...
%     'MaxEpochs',100, ...
%     'GradientThreshold',1, ...
%     'InitialLearnRate',0.01, ...
%     'MiniBatchSize',1000, ...
%     'ValidationData',{Xtr',tar'},...
%     'ValidationFrequency',10,...
%     'Verbose',1, ...
%     'Plots','training-progress');
%     

options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'MiniBatchSize',500, ...
    'Verbose',1, ...
    'ValidationData',{Xtrc',tarc'},...
    'ValidationFrequency',25,...
     'LearnRateSchedule','piecewise',...
     'LearnRateDropFactor',0.75, ...
     'LearnRateDropPeriod',50, ...
     'Plots','training-progress');

%view(net);
net = trainNetwork(Xtr1',tar1',layers,options);


% batchsize = 1000;
% passes = size(Xtr2,1)/batchsize;
% t=1;
% teststate = [30 30 1 0 0 0 0];
% for i=0:batchsize:size(Xtr2,1)-1
%     X = Xtr2(i+1:i+batchsize,:);
%     target = tar2(i+1:i+batchsize,:);
%     
%     [net,tr] = train(net,X',target');
%     plotperf(tr);
%     herror(t) = horizontest_fn(teststate , 4,net);
%     t = t+1;
% end;
% 
% figure(2),plot([1:t-1],herror(1:t-1),'-k');

deepnet_c1= net;
%save ('deepnet_c2','deepnet_c2');