function [carNum] = multiComponent(diff_pathvar,diff_strMid,total_frames,lane,time_interval,minY, maxY, coeff,latent, p)
% multiCompoent Summary of this function goes here
% Created by Zehong Yan
% Created date: Aug 10th, 2019 
%   Utilize multiple components (k dimensions of the eigenvector) to count the car number
carNum = 0;
% calculate principal component ratio
temp_latent = 0;
proportion_latent = zeros(length(latent),3);
for i = 1:length(latent)
    proportion_latent(i,1) = latent(i,1);
    proportion_latent(i,2) = latent(i,1)/sum(latent);
    temp_latent = temp_latent+latent(i,1);
    proportion_latent(i,3) = temp_latent/sum(latent);
end
% keep k dimensions of the original data
k = find(proportion_latent(:,3) > p,1);
test_weights = [];
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
    test_nowWeight = coeff(1:lenCoeff,1:k)'*value;
    test_weights = [test_weights test_nowWeight];
    test_distance(1,tt) = sum(test_nowWeight.^2);
end
norm_distance = (test_distance-min(test_distance))/(max(test_distance)-min(test_distance));
figure;
plot(norm_distance)
title(sprintf('Temporal Component-weights Lane %d',lane))
xlabel('/frames')
ylabel('Magnitude')
grid on
ind_weights = find(test_distance > max(max(test_distance) / 19, 1000));
for k = ind_weights
    if (max(test_distance(max(1, k - time_interval/2) : min(numel(test_distance), k + time_interval/2))) == test_distance(k))
        carNum = carNum + 1;
%         outFilename = sprintf('%s/histogram_%s_data/result_lane_%d_2/frame_%d_%.4f.jpg', dir, sequence, lane, k, weights(k));
%         filename = sprintf('%s/%s/frame_%d.jpg', dir, sequence, k + 1);
%         outImg = imread(filename);
%         imwrite(outImg, outFilename);
    end
end
end

