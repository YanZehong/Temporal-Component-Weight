% **********************Copyright (matlab)**********************  
% Created by Zehong Yan
% Created date: Jul 28th, 2019  
% Members: Zehong Yan
% File name: rewriteFrames.m  
% --------------------------------------------------------------  
% Descriptions: 将图片转化为视频
% **************************************************************
clear all;
clc;
pathvar = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west/';
strMid = 'frame_';
startNo = 1:15117;
aviobj = VideoWriter('original.avi');
aviobj.FrameRate = 30;
% load('/Users/yanzehong/Workspace_matlab/vehiclePerception/maxY.mat')
% load('/Users/yanzehong/Workspace_matlab/vehiclePerception/minY.mat')
rImg = 576; cImg = 720;
open(aviobj)
for i = 1:length(startNo)
    waitbar(i/length(startNo))
    strImgName = sprintf('%s%s%s%s',pathvar,strMid,...
        num2str(startNo(i)),'.jpg');
    img =  imread(strImgName);
    imshow(img);
%     hold on
%     plot(minY(1:rImg,1), 1:rImg, 'Color', 'r', 'Linewidth',0.5);
%     plot(minY(1:rImg,2), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
%     plot(minY(1:rImg,3), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
%     plot(minY(1:rImg,4), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
%     plot(maxY(1:rImg,1), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
%     plot(maxY(1:rImg,2), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
%     plot(maxY(1:rImg,3), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
%     plot(maxY(1:rImg,4), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
    frame = getframe(gcf);
    writeVideo(aviobj,frame);
end
close(aviobj)
