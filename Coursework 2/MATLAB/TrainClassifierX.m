%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepared By: Jenna Luchak
% CID: 01429938
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function parameters = TrainClassifierX(input,output)
% The function "TrainClassifierX" implements the classifiers method of K
% nearest neighbours (KNN) to test several values of K and produce the
% optimal parameter.

% The function uses two arguments, "input", a 3-column matrix, where each 
% column corresponds to x,y and z axis and "output", a column vector 
% containing data labels. 

% The functions return is "parameters", a 1x1 structure array containing 
% the following 2 fields.
% k: a scalar value indicating the number of training data points to use 
% in the classification calculation of each test point
% NearestNeighbours: a 4 column matrix that stores the training data and 
% training labels

%% Split input and output arguments into Training and Testing Data sets
% i.e. Randomly shuffle the data and then divide the shuffled data
% into 4 sections, such that one of those sections is defined
% as testing data and the other remaining sections as training data.

% Create one matrix to hold the input and output arguments together
    data = [input,output]; % The columns are [x,y,z,labels]
    rows = length(data); % The number of rows in the data matrix
    
% Randomly shuffle each row of the data matrix
    shuffled_data = data(randperm(size(data,1)),:);

% Calculate the integer of data points in a quarter section
    num = round(rows/4,0);

% Define the testing and training data sets respectively
    testing = shuffled_data(1:num,:); % The columns are [x,y,z,labels]
    training = shuffled_data(num+1:end,:); % The columns are [x,y,z,labels] 

%% Implement K Nearest Neighbours Method 

% Define a vector of k values to test. Note that for a binary classification, 
% the values of k should be odd.
    k_values = 3:2:19;

% Initialize an external for loop to test each value of k for the KNN
% method.
    for k=1:length(k_values)
    % Reset the count    
        count = 0;
        
    % Initialize two internal for loops such that for every test point 
    % the distance between it and all of the training points are
    % calculated
        for j=1:size(testing,1)
        % Define the test point    
            points(1,:) = testing(j,1:3); 
            
            for m=1:size(training,1)
            % Define the train point
                points(2,:) = training(m,1:3);                    
            % Calculate the distance between the test point and train point
            % and store each value in the first column of the matrix neighbours 
                neighbours(m,1) = pdist(points,'euclidean');
            end
            
        % Define the training labels as the second column of the matrix 
        % neighbours so that the distance from the test point to each training
        % point corresponds to the correct label of each train point
            neighbours(:,2) = training(:,4);
            
        % Sort the rows of the matrix neighbours with respect to the first 
        % column, so that the distances between each point are in ascending
        % order and still correspond to their correct label
            nearest_neighbours = sortrows(neighbours,1);
            
        % Identify the desired label of the test point by calculating the 
        % mode of the labels corresponding to the smallest "k" distances
        % i.e. the most common label of it's k nearest neighbours
            label(j) = mode(nearest_neighbours(1:k,2));
        end
        
    % Initialize one internal for loop to compare the predicted labels with
    % their actual labels
        for n=1:size(testing,1)
            if label(n)==testing(n,4)
            % If the predicted label matches the actual label add 1 to count    
                count = count +1; 
            end
        end
        
    % Calculate the accuracy of the method for each k value tested    
        KNN_accuracy(k) = (count/size(testing,1))*100;
    end
    
% Determine the index value corresponding to the maximum accuracy obtained
    [~,index] = max(KNN_accuracy);
    
%% Define the parameters of the system
% The k value that resulted in the most accurate KNN method
    parameters.k = k_values(index);
% The input and output arguments of the function
    parameters.NearestNeighbours = [input,output];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of function TrainClassifierX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%