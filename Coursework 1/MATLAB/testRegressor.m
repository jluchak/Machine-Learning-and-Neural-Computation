%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepared By: Jenna Luchak
% CID: 01429938
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ val ] = testRegressor(in, param)
% default length(in),1)
val=zeros(length(in(:,1)),1);
baseFuncs=param.baseFuncs;
w=param.w;
%calculate values of all testing datapoints
parfor i=1:length(in(:,1))
    for j=1:length(baseFuncs)
        val(i)=val(i)+w(j)*baseFuncs{j}(in(i,:));
    end
end
end


