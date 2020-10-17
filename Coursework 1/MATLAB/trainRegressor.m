%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepared By: Jenna Luchak
% CID: 01429938
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ param ] = trainRegressor(in, out)
% Number of Guassian basis function
numGaussians = 10;
baseFuncs=cell(numGaussians+1,1);
% Initialising variables
for i=1:numGaussians
    % Fill your mean (mu) and variance (sig) here
    %===========================================%
%% Define the useable data for this assignment
% i.e. Load and then filter the data set such that it only represents the
% Greater London Area.

% Load the dataset
    load('london.mat');

% Rename subsets of the structure array Prices
% i.e. Define variables to represent the three columns:latitude, longitude 
% and rent prices
    lat = Prices.location(:,1); % Latitude data points in Degrees 
    long = Prices.location(:,2); % Longitude data points in Degrees 
    rent = Prices.rent; % Rent prices data points in GBP

% Filter the Prices subsets with respect to latitudes
% i.e. Only keep data points with latitudes less than 51.72 degrees and greater
% than 51.30 degrees.
    lat_2 = lat(lat < 51.72 & lat > 51.30); % In Degrees
    long_2 = long(lat < 51.72 & lat > 51.30); % In Degrees
    rent_2 = rent(lat < 51.72 & lat > 51.30); % In GBP

% Filter the Prices subsets AGAIN, this time with respect to longitudes
% i.e. Only keep data points with longitudes less than 0.303 degrees and greater
% than -0.510 degrees.
    lat_3 = lat_2(long_2 < 0.303 & long_2 > -0.510); % In Degrees
    long_3 = long_2(long_2 < 0.303 & long_2 > -0.510); % In Degrees
    rent_3 = rent_2(long_2 < 0.303 & long_2 > -0.510); % In GBP

%%  Calculate the Mean and Variance for each Gaussian function
% Divide the data into rings around a central point
% i.e. First, determine a central point with respect to the data in the
% latitude-longitude plane. Second, calculate the distance of the farthest 
% data point from the center. Lastly, divide the filtered data set into 
% clusters bounded by rings around the central point, where the number of 
% rings selected is dependant on the number of Gaussian equations used in 
% the script. 
% A new mean and variance will be calculated for every Gaussian 
% function.

% Redefine the filtered data subset into one matrix and then sort the data 
% with respect to ascending rental prices.
    data = [lat_3,long_3,rent_3]; % Redefine the filtered Prices subset
    data_sorted = sort(data,3); % Sorted data matrix

% Calculate the average latitude and longitude location for the top 1000
% rental prices to determine the data sets central point.
    n = 1000; % Number of specified points to select
    max_points = data_sorted(end-n:end,:); % Collect the last n rows of the sorted data 
    center = [mean(max_points(:,1)) mean(max_points(:,2))]; % Calculate center(x,y)=[lat,long]

% Determine the maximum radii needed to reach all data points from center
% point
    radii = hypot((data(:,1)-center(1)),(data(:,2)-center(2))); % Distance of all points to center
    max_radius = max(radii); % Distance of the fathest point away from center 

% Create a vector defining the radii boundaries of each data cluster 
% starting at zero,increasing uniformly, and ending at the farthest data 
% point from center.
    ring = 0:(max_radius/numGaussians):max_radius; 

% Use a "for" loop to collect all data points that lie within each
% clusters set boundaries and then calculate it's mean and variance. 
    for j=2:(numGaussians+1)    
        cluster = data((radii>=ring(j-1) & radii<=ring(j)),1:2); % Define the data allowed in each cluster
        Mean(j-1,:) = mean(cluster); % Calculate the clusters mean vector
        Variance(j-1).a = cov(cluster); % Calculate the clusters co-variance matrix
    end
       
% Redefine the mean vector for every Guassian basis function
    mu = Mean(i,:);
    
% Calculate the pseudo inverse of each co-variance matrix and redefine it
% for every Gaussian basis function
    sig = pinv(Variance(i).a);
    
    %% =========================================== %%
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