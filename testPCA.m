% **********************Copyright (matlab)**********************  
% Created by Zehong Yan
% Created date: Aug 10th, 2019  
% Members: Zehong Yan
% File name: testPCA.m  
% --------------------------------------------------------------  
% Descriptions: 利用十次十折交叉验证得到temporal component-weight
%               的训练序列模型
% **************************************************************  
clear all;clc
%% load parameters
imgHeights = 576 : -1 : 418;
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/maxY.mat')
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/minY.mat')
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/ind_weights.mat')
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/all_weights.mat')
%% set parameters
% cdi images path
diff_pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/diff_img/';
diff_strMid = 'cdi_frame_';
% raw images path
pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/';
strMid = 'frame_';
% file save path
dir = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset';
sequence = 'west';
% cross-validation
frames = (1:15117)';
indices = crossvalind('Kfold',frames,10);
carNum = zeros(1,10);
carNum_true = zeros(1,10);
lane = 2;
time_interval = 30;
numbers = zeros(2,10);
for num = 1:10
    numbers(1, num) = length(find(indices ~= num));
    numbers(2, num) = length(find(indices == num));
end
%% training
for k = 1:10
    waitbar(k/10)
    test = (indices == k);
    train = ~test;
    histData = [];
    train_frames = frames(train);
    test_frames = frames(test);
    modelName = sprintf('%s/histogram_%s_data/coeff_model_%d.mat', dir, sequence, k);
    for t = 1:length(train_frames)
%         waitbar(t/length(train_frames))
        strImgName_cdi = sprintf('%s%s%s%s',diff_pathvar,diff_strMid,num2str(train_frames(t)),'.jpg');
        img = imread(strImgName_cdi);
        img = double(img);
        value = [];
        for i = imgHeights
            temp = sum(img(i,minY(i, lane):maxY(i, lane)),2);
            value = [value; temp];
        end
        histData = [histData value];
    end
    [coeff,score,latent,tsquared,explained,mu] = pca(histData', 'Centered', false);
    save(modelName,'coeff','score','latent')
    weights = [];
    for tt = 1:length(test_frames)
        strImgName_cdi = sprintf('%s%s%s%s',diff_pathvar,diff_strMid,num2str(test_frames(tt)),'.jpg');
        img = imread(strImgName_cdi);
        strImgName = sprintf('%s%s%s%s',pathvar,strMid,num2str(test_frames(tt)),'.jpg');
        img_raw = imread(strImgName);
        value = [];
        for i = imgHeights
            temp = sum(img(i, minY(i, lane) : maxY(i, lane)), 2);
            value = [value; temp];
        end
        nowWeight = dot(value, coeff(:, 1));
        weights = [weights nowWeight];
    end
    ind_weights_test = find(weights > max(max(score(:,1)) / 5, 1000));
    ind_frames = zeros(1,length(ind_weights_test));
    for ii = 1:length(ind_weights_test)
        ind_frames(1,ii) = test_frames(ind_weights_test(ii));
    end
    for kk = 1:length(ind_weights_test)
        if (max(weights(max(1, ind_weights_test(kk) - time_interval/10) : min(numel(weights), ind_weights_test(kk) + time_interval/10))) == weights(ind_weights_test(kk)))
            % display(test_frames(ind_weights_test(kk)))
            carNum(1,k) = carNum(1,k) + 1;            
        end
    end
    for jj = 1:length(ind_frames)
        if ~isempty(find(ind_weights == ind_frames(1,jj), 1))
            if jj == 1
                temp_frame = ind_frames(1,jj);
                carNum_true(1,k) = carNum_true(1,k) + 1;
            end
            if (ind_frames(1,jj)-temp_frame > 25) && (jj >= 1) 
                temp_frame = ind_frames(1,jj);
                carNum_true(1,k) = carNum_true(1,k) + 1;
            end
        end
    end
end
error_rate = carNum./carNum_true;
mean_error_rate = sum(error_rate)/10;
