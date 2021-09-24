function cost = costFunction(Train_Input,Train_Output,gam,sig2) 
    %lssvm parameter setting
    type='function estimation';
    kernel='RBF_kernel';
    preprocess='original';

    model=initlssvm(Train_Input,Train_Output,type,gam,sig2,kernel,preprocess);
    model=trainlssvm(model);
    [ptrain,zt,model]=simlssvm(model,Train_Input);
    
    %cost = sum((ptrain-valiOutput).^2)/length(valiOutput);  %mse
    %cost = 100-sum(abs(ptrain-Train_Output))/length(Train_Output);       %mae
    cost = sum(abs(ptrain-Train_Output)./abs(Train_Output))/length(Train_Output)*100;     %mape
    
    
%     trainmse = sum((ptest-testOutput).^2)/length(testOutput);   %mse
%     trainrmse = sqrt(trainmse);     %rmse
%     trainmae = sum(abs(ptest-testOutput))/length(testOutput);       %mae
%     trainmape = sum(abs(ptest-testOutput)./abs(testOutput))/length(testOutput)*100;     %mape
    


end