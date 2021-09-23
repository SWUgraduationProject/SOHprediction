clear; 

% Load The Dataset
load B0005Feature.mat
load B0006Feature.mat
load B0007Feature.mat

load cap5.mat
load cap6.mat
load cap7.mat

load B0005Charge.mat

% Select dataset
BatteryNum = 7;
switch BatteryNum
    case 5
       cap = cap5;
       Feature = B0005Feature;
      
    case 6
       cap = cap6;
       Feature = B0006Feature;

    case 7
       cap = cap7;
       Feature = B0007Feature;
       
end

%% Data Preprocessing  - 117: TrainSet / 50: TestSet (7:3)
for i = 1 : length(Feature.cycle)
    if(i<118) 
        trainX.cycle(i).data = Feature.cycle(i).data;
        trainY(i) = cap(i);
    end
    if(i>=118)
        testX.cycle(i-117).data = Feature.cycle(i).data;
        testY(i-117) = cap(i);
    end
end


%% Define dataset
switch BatteryNum
    case 5
       B0005trainX = trainX;
       B0005trainY = trainY;
       B0005testX = testX;
       B0005testY = testY;
    case 6
       B0006trainX = trainX;
       B0006trainY = trainY;
       B0006testX = testX;
       B0006testY = testY;
    case 7
       B0007trainX = trainX;
       B0007trainY = trainY;
       B0007testX = testX;
       B0007testY = testY;
end
