% **********************Copyright (matlab)**********************  
% Created by Zehong Yan
% Created date: Jul 23rd, 2019  
% Members: Zehong Yan
% File name: rewriteFrames.m  
% --------------------------------------------------------------  
% Descriptions: 读取指定文件夹下的帧数并重新命名存储 
% **************************************************************  
clear all;clc
%% rewrite image name
file_path =  '/Users/yanzehong/Downloads/Loop_west/'; 
new_file_path = '/Users/yanzehong/Workspace_matlab/vehiclePerception/dataset/west';
img_path_list = dir(strcat(file_path,'*.jpg')); % 获取所有jpg格式的图像
img_num = length(img_path_list); % 获取图像总数量
temp_path = pwd; % 保存当前工作目录
cd(new_file_path) % 把当前工作目录切换到指定文件夹
if img_num > 0
    %逐一读取图像
    for j = 1:img_num
        waitbar(j/img_num)
        image_name = img_path_list(j).name;
        image =  imread(strcat(file_path,image_name));
        % 显示正在处理的图像名
        % fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));
        img_gray = rgb2gray(image);
        % imshow(img_gray);
        imwrite(image,strcat('frame_',num2str(j),'.jpg'),'jpg') 
        imwrite(img_gray,strcat('frame_gray_',num2str(j),'.jpg'),'jpg')            
    end
end
cd(temp_path) % 切回原工作目录