function [xtrain,xtest] = normal(x)
% z-score
rx = std(x);
fullx = bsxfun(@rdivide, bsxfun(@minus, x, mean(x)), rx);

xtrain = fullx(1:117,:);
xtest = fullx(118:167,:);


% min-max (100% 기준으로 conversion)
%yData = (yData - min(yData))/ (max(yData) - min(yData)) *100;
%xData1 = bsxfun(@rdivide, bsxfun(@minus, xData1, min(xData1)), (max(xData1)-min(xData1)));



