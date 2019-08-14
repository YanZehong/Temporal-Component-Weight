% **********************Copyright (matlab)**********************  
% Created by Zehong Yan
% Created date: Jul 25th, 2019  
% Updated date: Aug 13th, 2019
% Members: Zehong Yan
% File name: main.m  
% --------------------------------------------------------------  
% Descriptions: Temporal Component-weight
% **************************************************************
clear all;clc
%% read pixel data from images and get CDI from three frames
pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/';
strMid = 'frame_';
frameNo = 1:15119;
runtime = getCDI(pathvar, strMid, frameNo);
%%
for k = 1:100 
    for frame = 1:20
        strImgName = sprintf('%s%s%s%s',pathvar,strMid,...
        num2str(startNo(frame)),'.jpg');
        img_empty = imread(strImgName);
        imwrite(img_empty)
    end
end
%% set parameters
dir = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset';
sequence = 'west';
if strcmp(sequence, 'west')
    train_frames = 2000:4000;
    imgHeights = 576 : -1 : 418;
end
%% import the configuration of lane(minY, maxY)
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/maxY.mat')
load('/Users/yanzehong/Workspace_matlab/vehiclePerception/minY.mat')
% show specific images
% rImg = 576; cImg = 720;
% pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/diff_img/';
% strMid = 'cdi_frame_';
% imgLaneShow(pathvar, strMid, 2005:-1:2000, rImg, minY, maxY);

%% pca
diff_pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/diff_img/';
diff_strMid = 'cdi_frame_';
histData = [];
% histData4 = [];histData3 = [];histData2 = [];histData1 = [];histData0 = [];
for t = train_frames
    strImgName_cdi = sprintf('%s%s%s%s',diff_pathvar,diff_strMid,num2str(t),'.jpg');
    img = imread(strImgName_cdi);
    img = double(img);
    value = [];
%     value4 = [];value3 = [];value2 = [];value1 = [];value0 = [];
    for i = imgHeights
        temp = sum(img(i,minY(i,2):maxY(i,2)),2);
%         projection_lane4 = sum(img(i,minY(i,4):maxY(i,4)),2);
%         projection_lane3 = sum(img(i,minY(i,3):maxY(i,4)),2);
%         projection_lane2 = sum(img(i,minY(i,2):maxY(i,3)),2);
%         projection_lane1 = sum(img(i,minY(i,1):maxY(i,1)),2);
%         projection_lane0 = sum(img(i,minY(i,1):maxY(i,4)),2);
%         value4 = [value4; projection_lane4];
%         value3 = [value3; projection_lane3];
%         value2 = [value2; projection_lane2];
%         value1 = [value1; projection_lane1];
%         value0 = [value0; projection_lane0];
        value = [value; temp];
    end
    histData = [histData value];
%     histData4 = [histData4 value4];
%     histData3 = [histData3 value3];
%     histData2 = [histData2 value2];
%     histData1 = [histData1 value1];
%     histData0 = [histData0 value0];
end
% for ii = 1:5
%     matName = sprintf('%s/histogram_%s_data/lane_%d_%05d-%05d.mat', dir, sequence, ii-1, frames(1), frames(end));
%     save(matName, sprintf('histData%d',ii-1));
% end

[coeff,score,latent,tsquared,explained,mu] = pca(histData', 'Centered', false);
% reconstruction = score*coeff';
% get proportion of eigen value
temp_latent = 0;
proportion_latent = zeros(length(latent),3);
for i = 1:length(latent)
    proportion_latent(i,1) = latent(i,1);
    proportion_latent(i,2) = latent(i,1)/sum(latent);
    temp_latent = temp_latent+latent(i,1);
    proportion_latent(i,3) = temp_latent/sum(latent);
end
%% load histdata and get coeff
% frames = 1:15117;
% imgHeights = 522 : -1 : 430;
% for ii = 1:5
%     matName = sprintf('%s/histogram_%s_data/lane_%d_%05d-%05d.mat', dir, sequence, ii-1, frames(1), frames(end));
%     load(matName);
% end
% [coeff1,score1,latent1,tsquared1,explained1,mu1] = pca(histData1', 'Centered', false);
% [coeff2,score2,latent2,tsquared2,explained2,mu2] = pca(histData2', 'Centered', false);
% [coeff3,score3,latent3,tsquared3,explained3,mu3] = pca(histData3', 'Centered', false);
% [coeff4,score4,latent4,tsquared4,explained4,mu4] = pca(histData4', 'Centered', false);
% [coeff0,score0,latent0,tsquared0,explained0,mu0] = pca(histData0', 'Centered', false);
% plot(coeff1(:, 1));

%% pca test
carNum = 0;
time_interval = 30;
total_frames = 1:15117;
diff_pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/diff_img/';
diff_strMid = 'cdi_frame_';
wetName_all = sprintf('%s/histogram_%s_data/all_weight.mat', dir, sequence);
for lane = 2
    wetName = sprintf('%s/histogram_%s_data/weight_lane_%d_%05d-%05d.mat', dir, sequence, lane, total_frames(1), total_frames(end));
    weights = [];
    if lane ==1
        rangeH = 576 : -1 : 498;
        lenCoeff = length(rangeH);
    elseif (lane > 1) && (lane < 5) 
        rangeH = 576 : -1 : 418;
        lenCoeff = length(rangeH);
    else
        warning('Wrong lane number!')
    end
    for tt = total_frames
        waitbar(tt/length(total_frames))
        strImgName_cdi = sprintf('%s%s%s%s',diff_pathvar,diff_strMid,num2str(tt),'.jpg');
        img = imread(strImgName_cdi);
        value = [];
        for i = rangeH
            temp = sum(img(i, minY(i, lane) : maxY(i, lane)), 2);
            value = [value; temp];
        end
        nowWeight = coeff(1:lenCoeff,1)'*value; % nowWeight = dot(value, coeff(:, 1));
        weights = [weights abs(nowWeight)];
    end
%     save(wetName,'weights')
    figure;plot(weights);
    allWeights{lane} = weights;
%     allWeights{lane} = weights;
    norm_weights = (weights-min(weights))/(max(weights)-min(weights));
    plot(norm_weights,'k')
    title(sprintf('Temporal Component-weights Lane %d',lane))
    xlabel('/frames')
    ylabel('Magnitude')
    grid on
%     axis([2000 4000 0 1])
    ind_weights = find(weights > max(max(weights) / 5, 1000));
    for k = ind_weights
        if (max(weights(max(1, k - time_interval) : min(numel(weights), k + time_interval))) == weights(k))
            carNum = carNum + 1;
%             display(k)
%             outFilename = sprintf('%s/histogram_%s_data/test_lane_%d/frame_%d_%.4f.jpg', dir, sequence, lane, k, weights(k));
%             filename = sprintf('%s/%s/frame_%d.jpg', dir, sequence, k + 1);
%             outImg = imread(filename);
%             imwrite(outImg, outFilename);
        end
    end
end
% save(wetName_all, 'allWeights');
%% Specify principal components proportion to count the car number
frameRate = 30;
lane = 2;
total_frames = 1:15117;
% set image path and name
diff_pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/diff_img/';
diff_strMid = 'cdi_frame_';
p = 0.8; % Specify the proportion of the eigenvector of the principal component
cntNum = multiComponent(diff_pathvar,diff_strMid,total_frames,lane,...
    frameRate,minY,maxY,coeff,latent,p);
