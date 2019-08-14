function [] = imgLaneShow(pathvar, strMid, frames, rImg, minY, maxY)
% imgLaneShow Summary of this function goes here
% Created by Zehong Yan
% Created date: Jul 25th, 2019 
%   Show specific images with lane marks
for i = frames
    figure;
    testImg = imread(sprintf('%s%s%s%s',pathvar,strMid,num2str(i),'.jpg'));
    imshow(testImg)
    hold on
    plot(minY(1:rImg,1), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
    plot(minY(1:rImg,2), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
    plot(minY(1:rImg,3), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
    plot(minY(1:rImg,4), 1:rImg, 'Color', 'r', 'Linewidth',0.5)
    plot(maxY(1:rImg,1), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
    plot(maxY(1:rImg,2), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
    plot(maxY(1:rImg,3), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
    plot(maxY(1:rImg,4), 1:rImg, 'Color', 'b', 'Linewidth',0.5)
    title(sprintf('Frame No. %s',num2str(i)))
end
end

