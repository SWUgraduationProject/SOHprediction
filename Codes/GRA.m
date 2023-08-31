clc;clear;

%% Step 0 (Data Preparation)
% Raw data 
load B0005.mat
load B0006.mat
load B0007.mat

% recleansed Capacity Dataset
load cap5.mat
load cap6.mat
load cap7.mat

%Cleased charge data 
load B0005Train4.mat
load B0006Train4.mat
load B0007Train4.mat

% load Capacity Data
%cap5 = extract_discharge(B0005);
%cap6 = extract_discharge(B0005);
%cap7 = extract_discharge(B0005);

cap5 = cap5;
cap6 = cap6;
cap7 = cap7;

InitC5 = 1.86;
InitC6 = 2.04;
InitC7 = 1.89;

% Extract SOH from capacity data
[SOH5] = extract_soh(InitC5, cap5);
[SOH6] = extract_soh(InitC6, cap6);
[SOH7] = extract_soh(InitC7, cap7);


% Extract Feature Data
% F0 : Cycle number (for comparison)
% F1 : CC Duration Time (aging factor 고려)
% F2 : CV Duration Time (aging factor 고려)
% F3 : 특정 volatage(3.8~4.0)에서 duration time (기울기)
% F4 : 특정 current (1.3~1.1)에서 duration time (기울기)

% Select dataset
BatteryNum = 7;
switch BatteryNum
    case 5
       %Battery = B0005Feature;
       Battery = B0005Train;
       SOH = SOH5;
    case 6
        %Battery = B0006Feature;
        Battery = B0006Train;
        SOH = SOH6;
    case 7
        %Battery = B0007Feature;
        Battery = B0007Train;
        SOH = SOH7;
end
% Assign Features 
for i = 1 : length(Battery.cycle) 
    F0(i) = Battery.cycle(i).data.Cycle_num;
    F1(i) = Battery.cycle(i).data.CCtime;
    F2(i) = Battery.cycle(i).data.CVtime;
    F3(i) = Battery.cycle(i).data.VoltageTime;
    F4(i) = Battery.cycle(i).data.CurrentTime;
end

%% Step 1 (min-max normalization)
SOH = reshape(SOH, 1,length(SOH)); % reshape 1*n to n*1

SOH = minmax_norm_GRA(SOH);
F0 = minmax_norm_GRA(F0);
F1 = minmax_norm_GRA(F1);
F2 = minmax_norm_GRA(F2);
F3 = minmax_norm_GRA(F3);
F4 = minmax_norm_GRA(F4);

%% Step 2 (Grey relational coefficient)
[GRC_F0, GRC_F1, GRC_F2, GRC_F3, GRC_F4] = grey_relational_coefficient(F0, F1, F2, F3, F4, SOH);

%% Step 3 (Grey relational Grade)
[GRG_F0, GRG_F1, GRG_F2, GRG_F3, GRG_F4] = grey_relational_grade(GRC_F0, GRC_F1, GRC_F2, GRC_F3, GRC_F4);

%% Step 4 (plot the result)
% Plot the Grey relational coefficient per cycle_num
subplot(5,1,1); plot(GRC_F0); xlabel('F0 : Cycle number');
title('Plot of Grey Relational Coefficient per cycle (B0005)','FontSize',15);
subplot(5,1,2); plot(GRC_F1); xlabel('F1 : CC Duration Time');
subplot(5,1,3); plot(GRC_F2); xlabel('F2 : CV Duration Time');
subplot(5,1,4); plot(GRC_F3); xlabel('F3 : 특정 volatage(3.8~4.0)에서 duration time');
subplot(5,1,5); plot(GRC_F4); xlabel('F4 : 특정 current (1.3~1.1)에서 duration time');

% Plot the Grey relational Grade 
%GRG = [GRG_F1, GRG_F2, GRG_F3, GRG_F4];
%bar(GRG,0.4);
%title('Plot of Grey Relational Grade of B0005','FontSize',15);

% Display the Grey relational Grade 
X = ['F0(Cycle number) : ', num2str(GRG_F0),', F1(CC Duration Time) : ', num2str(GRG_F1), ', F2(CV Duration Time) : ',num2str(GRG_F2),', F3(Certain Voltage Duration Time) : ',num2str(GRG_F3),', F4(Certain Current Duration Time) : ' , num2str(GRG_F4)];
display(X);
