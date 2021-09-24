clc;
clear;

%% Data load
load B0005trainX.mat
load B0005testX.mat

load B0006trainX.mat
load B0006testX.mat

load B0007trainX.mat
load B0007testX.mat

%Y is the capacity
load B0005trainY.mat
load B0005testY.mat

load B0006trainY.mat
load B0006testY.mat

load B0007trainY.mat
load B0007testY.mat

%% Train set
B0005train = extract_feature(B0005trainX);
B0005test = extract_feature(B0005testX);

B0006train = extract_feature(B0005trainX);
B0006test = extract_feature(B0005testX);

B0007train = extract_feature(B0005trainX);
B0007test = extract_feature(B0005testX);

%Initailization
InitC5 = 1.86;
InitC6 = 2.04;
InitC7 = 1.89;

%Make SOH data
[yB5train] = extract_soh(InitC5, B0005trainY);
[yB5test] = extract_soh(InitC5, B0005testY);

[yB6train] = extract_soh(InitC6, B0006trainY);
[yB6test] = extract_soh(InitC6, B0006testY);

[yB7train] = extract_soh(InitC5, B0007trainY);
[yB7test] = extract_soh(InitC5, B0007testY);

fullX5 = vertcat(B0005train, B0005test); 
fullX6 = vertcat(B0006train, B0006test); 
fullX7 = vertcat(B0007train, B0007test); 

%Nomalization
[xB5train, xB5test] = normal(fullX5);
[xB6train, xB6test] = normal(fullX6);
[xB7train, xB7test] = normal(fullX7);

%Select train dataset
%Select test dataset
BatteryNum = 5;

switch BatteryNum
    case 5
       Train_Input = xB5train;
       Train_Output = yB5train;
       TestSet = xB5test;
       testOutput = yB5test;
    case 6
       Train_Input = xB6train;
       Train_Output = yB6train;
       TestSet = xB6test;
       testOutput = yB6test;
    case 7
       Train_Input = xB7train;
       Train_Output = yB7train-1.2617;
       TestSet = xB7test;
       testOutput = yB7test-1.2617;
end

%% Problem Definition + Parameters of PSO + Parameters of LSSVM
c1=1.5;             %Personal Acceleration Coefficient
c2=1.7;             %Social Acceleration Coefficient
maxgen=100;         %Maximum Number of Iteration
sizepop=30;         %Population Size(Swarm Size)
popcmax=10^(3);     %Upper Bound of Decision Variables(gam)
popcmin=10^(-1);    %Lower Bound of Decision Variables(gam)
popgmax=10^(3);     %Upper Bound of Decision Variables(sig2)
popgmin=10^(-2);    %Lower Bound of Decision Variables(sig2)
k =0.5;
Vcmax =k*popcmax;   
Vcmin=-Vcmax;       
Vgmax=k*popgmax;    
Vgmin=-Vgmax ;      

%Initialize Population Members
for i=1:sizepop
    %generate random solution
	pop(i,1)=(popcmax-popcmin)*rand(1,1)*rand(1,1)+popcmin;     
	pop(i,2)=(popgmax-popgmin)*rand(1,1)*rand(1,1)+popgmin;
    
	%Initailize velocity
	V(i,1)=Vcmax*rands(1,1);
	V(i,2)=Vgmax*rands(1,1);
	gam=pop(i,1);
	sig2=pop(i,2);
    trainmse = costFunction(Train_Input,Train_Output,gam,sig2); %lssvm
    fitness(i) = trainmse;
end
[global_fitness,bestindex]=min(fitness);            
local_fitness=fitness;
global_x=pop(bestindex,:);
local_x=pop;
avgfitness_gen=zeros(1,maxgen);

%% Main Loop
for i=1:maxgen
	for j=1:sizepop
		
        %update velocity
		wV=0.729;
		V(j,:)= wV*V(j,:) +c1*rand*(local_x(j,:)-pop(j,:)) +c2*rand*(global_x- pop(j,:));
		
        %Apply Velocity Limits
		if V(j,2)>Vgmax
			V(j,2)=Vgmax;
        end
		if V(j,2)<Vgmin
            V(j,2)=Vgmin;
        end
            
        if V(j,1)>Vcmax
            V(j,1)=Vcmax;
        end
		if V(j,1) <Vcmin
            V(j,1)=Vcmin;
        end
            
		% Update Position
		wP =0.729;
		pop(j,:)=pop(j,:)+wP*V(j,:);
        
		% Apply Lower and Upper Bound Limits		
		if pop(j,2)>popgmax
			pop(j,2)=popgmax;
		end
		if pop(j,2)<popgmin
			pop(j,2)=popgmin;
        end
            
        if pop(j,1)>popcmax
            pop(j,1)=popcmax;
        end
		if pop(j,1)<popcmin
			pop(j,1)=popcmin;
        end
            
		%Evaluation
		gam=pop(j,1);
        sig2=pop(j,2);
        trainmse = costFunction(Train_Input,Train_Output,gam,sig2); %lssvm
        fitness(i) = trainmse;
          
		%Update Personal Best
		if fitness(j) <local_fitness(j)
			local_x(j,:)=pop(j,:);
			local_fitness(j)=fitness(j);
        end
       
		%Update Global Best
		if fitness(j) <global_fitness
			global_x=pop(j,:);
			global_fitness=fitness(j);
        end
        
    end
    
	%Store the Best Cost Value
	fit_gen(i)=global_fitness;
	avgfitness_gen(i)=sum(fitness)/sizepop;
    %Display iteration result
    disp(['Iteration ' num2str(i) ': Best Cost = ' num2str(global_fitness)  ' Best gam = ' num2str(global_x(1)) ' Best sig2 = ' num2str(global_x(2))]);
end

%% Result & Generate Plot

type='function estimation';
kernel='RBF_kernel';
preprocess='original';

model_final=initlssvm(Train_Input,Train_Output,type,global_x(1),global_x(2),kernel,preprocess);
model_final=trainlssvm(model_final);
plottest = model_final;
[ptest,zt,model_final]=simlssvm(model_final, TestSet);
% plotlssvm(model);

%평가지표
trainmse = sum((ptest-testOutput).^2)/length(testOutput);
trainrmse = sqrt(trainmse);
trainmae = sum(abs(ptest-testOutput))/length(testOutput);
trainmape = sum(abs(ptest-testOutput)./abs(testOutput))/length(testOutput)*100;
rsquare = 1 - (sum((ptest-testOutput).^2)/ sum((testOutput-mean(testOutput)).^2));

% Display result
disp(['RESULT==>     G x: ',num2str(global_x)])
disp(['/MSE:',num2str(trainmse),' /RMSE:',num2str(trainrmse),' /MAE:',num2str(trainmae),' /MAPE:',num2str(trainmape),' /R^2:',num2str(rsquare)])



% generate plot

fullY = vertcat(Train_Output,testOutput);
predictY = vertcat(zeros(length(Train_Output),1),ptest);

figure(1)
subplot(2,1,1)
plot(predictY,'r-'),
hold on,
plot(fullY,'b.'),
plot([length(Train_Output)+1 length(Train_Output)+1],[50 100],'LineWidth',2,'color',[0.5 0.5 0.5]),
hold off,
title({['PSO-LSSVM>> BatteryNum: ' num2str(BatteryNum)];
    ['gamma: ' num2str(global_x(1)), '  sigma^2: ' num2str(global_x(2))];
    ['RMSE:',num2str(trainrmse),', MAE:',num2str(trainmae),', MAPE:',num2str(trainmape),', R^2:',num2str(rsquare)]})
legend('estimation', 'datapoints' );
ylabel('SOH(%)');
ylim([50, 100]);
xlim([0, 180]);
grid minor;

subplot(2,1,2)
error = (abs(predictY - fullY)).';
plot(error, 'm-'),
hold on,
plot([length(Train_Output)+1 length(Train_Output)+1],[0 5],'LineWidth',2,'color',[0.5 0.5 0.5]),
hold off,
ylim([0, 5]);
ylabel('ERROR(%)');
xlim([0, 180]);
xlabel('Cycle num');
grid minor;
