clear all;
load('trccc_data_sync_depth_dsin_4x50','Xtr1','tar1');
X = [];
for i=1:9
    X(:,i) = Xtr1(:,i);
end
X(:,10) = Xtr1(:,15);
X(:,11) = Xtr1(:,16);

Xtr1 = X;
save('trc3_data_sync_dsin_4x50','Xtr1','tar1');