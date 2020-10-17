function [ param ] = trainRegressor(in, out)
% Number of Guassian basis function
numGaussians = 7;
baseFuncs=cell(numGaussians+1,1);
% Initialising variables
for i=1:numGaussians
    % Fill your mean (mu) and variance (sig) here
    %===========================================%
    mu = ;
    sig = ;
    %===========================================%
    baseFuncs{i}=@(x)myGaussian(x,mu,sig);
    param.mu{i}=mu;
    param.sig{i}=sig;
end
baseFuncs{end}=@(x)1;
%calculate the values of each basis function at each training datapoint
val=zeros(length(in),length(baseFuncs));
parfor i=1:length(in)
    valTemp=zeros(1,length(baseFuncs));
    for j=1:length(baseFuncs)
        valTemp(1,j)=baseFuncs{j}(in(i,:));
    end
    val(i,:)=valTemp;
end
%pseudoinverse for least squares solution
param.w=pinv(val)*out;
param.baseFuncs=baseFuncs;
end

function val=myGaussian(x,mu,sig)
%a gaussian basis function
val=exp(-(x-mu)*sig*(x-mu)');
end