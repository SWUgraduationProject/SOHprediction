function [SOH] = extract_soh(InitC, cap)
SOH = cap';
%SOH = [InitC*ones(1, 1); cap'];
SOH = SOH / InitC *100;