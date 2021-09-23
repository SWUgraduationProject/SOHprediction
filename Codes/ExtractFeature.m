clear;
% load data
load B0005.mat
load B0006.mat
load B0007.mat

load B0005Charge.mat 
load B0006Charge.mat 
load B0007Charge.mat 

%Select dataset
BatteryNum = 5;
switch BatteryNum
    case 5
       Data = B0005;
       ChargeData = B0005Cleansed;
    
       %Make Data Structure of Discharge Data
       B0005Discharge = struct('cycle',{struct('data',{0})});
       B0005Discharge.cycle.data = struct('Voltage_measured',{0},'Current_measured',{0}','Temperature',{0},'Time',{0});
       
       %Make Data Structure of Features
       B0005Feature = struct('cycle',{struct('data',{0})});
       B0005Feature.cycle.data = struct('Cycle_num',{0},'CCtime',{0},'CVtime',{0},'VoltageTime',{0}','CurrentTime',{0},'Temperature',{0});
      
    case 6
       Data = B0006;
       ChargeData = B0006Cleansed;
       
       %Make Data Structure of Discharge Data
       B0006Discharge = struct('cycle',{struct('data',{0})});
       B0006Discharge.cycle.data = struct('Voltage_measured',{0},'Current_measured',{0}','Temperature',{0},'Time',{0});
       
       %Make Data Structure of Features
       B0006Feature = struct('cycle',{struct('data',{0})});
       B0006Feature.cycle.data = struct('Cycle_num',{0},'CCtime',{0},'CVtime',{0},'VoltageTime',{0}','CurrentTime',{0},'Temperature',{0});
       
    case 7
       Data = B0007; 
       ChargeData = B0007Cleansed;
       
       %Make Data Structure of Discharge Data
       B0007Discharge = struct('cycle',{struct('data',{0})});
       B0007Discharge.cycle.data = struct('Voltage_measured',{0},'Current_measured',{0}','Temperature',{0},'Time',{0});
       
       %Make Data Structure of Features
       B0007Feature = struct('cycle',{struct('data',{0})});
       B0007Feature.cycle.data = struct('Cycle_num',{0},'CCtime',{0},'CVtime',{0},'VoltageTime',{0}','CurrentTime',{0},'Temperature',{0});
end

%% Extract Discharge Data
j = 1
for i = 1: length(Data.cycle)
    if (strcmp(Data.cycle(i).type,'discharge'))
        DischargeData.cycle(j).data.Voltage_measured = Data.cycle(i).data.Voltage_measured;
        DischargeData.cycle(j).data.Current_measured = Data.cycle(i).data.Current_measured;
        DischargeData.cycle(j).data.Temperature = Data.cycle(i).data.Temperature_measured;
        DischargeData.cycle(j).data.Time = Data.cycle(i).data.Time;
        DischargeData.cycle(j).data.Capacity = Data.cycle(i).data.Capacity;
        j = j + 1;
    end
end

%% Plot1 - Discharge Voltage
% y1 = DischargeData.cycle(2).data.Voltage_measured;
% plot(y1)
% title('Discharge Voltage - B0005')
% 
% hold on
% 
% y2 = DischargeData.cycle(50).data.Voltage_measured;
% plot(y2)
% 
% y3 = DischargeData.cycle(100).data.Voltage_measured;
% plot(y3) 
% 
% y4 = DischargeData.cycle(130).data.Voltage_measured;
% plot(y4) 
% 
% y5 = DischargeData.cycle(168).data.Voltage_measured;
% plot(y5) 
% legend({'Cycle 2','Cycle 50','Cycle 100','Cycle 130','Cycle 168'},'Location','northeast')
% hold off

%% Plot2 - Charge Voltage
% y1 = ChargeData.cycle(2).data.Voltage_measured;
% plot(y1)
% title('Charge Voltage - B0005')
% 
% hold on
% 
% y2 = ChargeData.cycle(50).data.Voltage_measured;
% plot(y2)
% 
% y3 = ChargeData.cycle(100).data.Voltage_measured;
% plot(y3) 
% 
% y4 = ChargeData.cycle(130).data.Voltage_measured;
% plot(y4) 
% 
% y5 = ChargeData.cycle(168).data.Voltage_measured;
% plot(y5) 
% legend({'Cycle 2','Cycle 50','Cycle 100','Cycle 130','Cycle 168'},'Location','southeast')
% hold off

%% Plot3 - Discharge Temperature
% y2 = DischargeData.cycle(50).data.Temperature;
% plot(y2)
% title('Discharge Temperature - B0005')
% 
% hold on
% 
% y3 = DischargeData.cycle(100).data.Temperature;
% plot(y3) 
% 
% y4 = DischargeData.cycle(130).data.Temperature;
% plot(y4) 
% 
% y5 = DischargeData.cycle(168).data.Temperature;
% plot(y5) 
% legend({'Cycle 50','Cycle 100','Cycle 130','Cycle 168'},'Location','southeast')
% hold off


%% Plot4 - Charge Temperature
% y2 = ChargeData.cycle(50).data.Temperature;
% plot(y2)
% 
% title('ChargeData Temperature - B0005')
% 
% hold on
% 
% y3 = ChargeData.cycle(100).data.Temperature;
% plot(y3) 
% 
% y4 = ChargeData.cycle(130).data.Temperature;
% plot(y4) 
% 
% y5 = ChargeData.cycle(168).data.Temperature;
% plot(y5) 
% legend({'Cycle 50','Cycle 100','Cycle 130','Cycle 168'},'Location','northeast')
% hold off


%% Extract Feature - Charge (충전 소요 시간, 각 cycle 별 temperature Max)
for i = 1 : length(ChargeData.cycle) 
    ChargeFeature.cycle(i).data.Num = i;
    ChargeFeature.cycle(i).data.Temperature = max(ChargeData.cycle(i).data.Temperature);
    ChargeFeature.cycle(i).data.Time = ChargeData.cycle(i).data.Time(end);
end

%% Extract Feature - Discharge (충전 소요 시간, 각 cycle 별 temperature Max)
for i = 1 : length(DischargeData.cycle) 
    DischargeFeature.cycle(i).data.Num = i;
    DischargeFeature.cycle(i).data.Temperature = max(DischargeData.cycle(i).data.Temperature);
    DischargeFeature.cycle(i).data.Time = DischargeData.cycle(i).data.Time(end);
end

%% Restruct Feature
for i = 1 : length(DischargeData.cycle)
    Feature.cycle(i).data.Num = i;
    Feature.cycle(i).data.TimeSum = ChargeFeature.cycle(i).data.Time + DischargeFeature.cycle(i).data.Time;
    Feature.cycle(i).data.TimeRatio = ChargeFeature.cycle(i).data.Time / DischargeFeature.cycle(i).data.Time;
    Feature.cycle(i).data.ChargeTemp = ChargeFeature.cycle(i).data.Temperature;
    Feature.cycle(i).data.DischargeTemp = DischargeFeature.cycle(i).data.Temperature;
end

%Plot the Feature Data
% plot(x)
% title('Max Temperature per Each DIscharging Cycle')
% legend('Battery #7')
% xlabel Cycle, ylabel Time(sec)

% Delete Outlier Row
Feature.cycle(1) = [];

%% Define dataset
switch BatteryNum
    case 5
       B0005Discharge = DischargeData;
       B0005Feature = Feature;
    case 6
       B0006Discharge = DischargeData;
       B0006Feature = Feature;
    case 7
       B0007Discharge = DischargeData;
       B0007Feature = Feature;
end