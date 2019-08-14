% **********************Copyright (matlab)**********************  
% Created by Zehong Yan
% Created date: Jul 23rd, 2019  
% Members: Zehong Yan
% File name: getCDI.m  
% --------------------------------------------------------------  
% Descriptions: 读取指定文件夹下的帧数并得到CDI图像
% **************************************************************  
clear all;clc
%% read pixel data from images and get CDI from three frames
pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/';
strMid = 'frame_';
startNo = 1:15119; % startNo = 1:9227; % east
runtime = zeros(1,length(startNo)-2);
% lane = 2:3;
% Pline = 1;
temp_path = pwd; % 保存当前工作目录
cd(sprintf('%s%s',pathvar,'diff_img')) % 把当前工作目录切换到指定文件夹
tic
for frame = 2:length(startNo)-1
    runtime(frame) = toc;
    strImgName_pre = sprintf('%s%s%s%s',pathvar,strMid,...
        num2str(startNo(frame)-1),'.jpg');
    strImgName_cur = sprintf('%s%s%s%s',pathvar,strMid,...
        num2str(startNo(frame)),'.jpg');
    strImgName_nxt = sprintf('%s%s%s%s',pathvar,strMid,...
        num2str(startNo(frame)+1),'.jpg');
    if frame == 2
        % Initialize images' parameters
        % read the previous image - I(t-1)
        rgb = imread(strImgName_pre);
        hsv = rgb2hsv(rgb);
        pImg = hsv(:,:,3);
        % read the current image - I(t)
        rgb = imread(strImgName_cur);
        hsv = rgb2hsv(rgb);
        cImg = hsv(:,:,3);
        % calculate the backward-difference-image and get the threshold
        img_BDI = abs(cImg - pImg);
        thrB = max(max(img_BDI))/10;
    else
        % updata images
        pImg = cImg;
        cImg = nImg;
        img_BDI = img_FDI;
        thrB = thrF;
    end
    
    % read the next image - I(t+1)
    rgb = imread(strImgName_nxt);
    hsv = rgb2hsv(rgb);
    nImg = hsv(:,:,3);
    % calculate the foreward-difference-image and get the threshold
    img_FDI = abs(nImg - cImg);
    thrF = max(max(img_FDI))/10;
    thrC = thrB * thrF;
    
    diff_img_bright_product = img_BDI.*img_FDI;
    % foreground pixel indicator (FI) : diff_img_bp > thrC
    img_CDI = img_BDI.*(diff_img_bright_product > thrC);
    imshow(img_CDI)
    imwrite(img_CDI,strcat('cdi_frame_',num2str(frame-1),'.jpg'),'jpg')
end
disp('The loop is over!!!')
toc
cd(temp_path) % 切回原工作目录
%% another way to read img 
% pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/';
% strMid = 'frame_';
% startNo = 1:1000;
% runtime = zeros(1,length(startNo)-2);
% % D = zeros(240,320,370);  
% tic
% for frame = 2:length(startNo)-1
%     runtime(frame) = toc;
%     strImgName = sprintf('%s%s%s%s',pathvar,strMid,...
%         num2str(startNo(frame)-1),'.jpg');
%     rgb = imread(strImgName);
%     hsv = rgb2hsv(rgb);
%     D(:,:,frame) = hsv(:,:,3);
% end
% [rD, cD, nD] = size(D);
% for i = 2:nD-1
%     cImg = D(:,:,i-1);
%     pImg = D(:,:,i);
%     nImg = D(:,:,i+1);
%     BDI = abs(cImg - pImg);
%     thrB = max(max(BDI))/10;
%     FDI = abs(nImg - cImg);
%     thrF = max(max(FDI));
%     thrC = thrB * thrF;
%     diff_img_bp = BDI.*FDI;
%     diff_img_b = BDI.*(diff_img_bp > thrC);
%     CDI = diff_img_b;
%     imshow(CDI)
% end
% disp('The loop is over!!!')
% toc