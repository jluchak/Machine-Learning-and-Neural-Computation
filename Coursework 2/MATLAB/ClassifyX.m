%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepared By: Jenna Luchak
% CID: 01429938
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function class = ClassifyX(input, parameters)
% The function "ClassifyX" implements the classifiers method of K
% nearest neighbours (KNN) to predict the classification labels of test
% data.

% The function uses two arguments, "input", a 3-column matrix, where each 
% column corresponds to x,y and z axis and "parameters", a 1x1 structure 
% array containing the following 2 fields.
% k: a scalar value indicating the number of training data points to use 
% in the classification calculation of each test point
% NearestNeighbours: a 4 column matrix that stores the training data and 
% training labels

% The functions return is "class", a column vector of predicted labels.

%% Re-define each field from structure "parameters"
% The number of nearest numbers to use for classification
k = parameters.k;
% The training data points and labels represented in the matrix as [x,y,z,label]
NearestNeighbours = parameters.NearestNeighbours;

%% Implement K Nearest Neighbours Method
% For every test point, the distance between it and every training point
% is calculated and sorted from smallest to largest. Next, the mode of the 
% corresponding labels for the "k" nearest data points (smallest distances 
% calculated) is calculated to find the class the test point belongs to.

% For loop to cycle through every test point
    for j=1:size(input,1)
    % Define the test point
        points(1,:) = input(j,:);
        
    % For loop to cycle through every training point        
        for m=1:size(NearestNeighbours,1)
        % Define the train point
            points(2,:) = NearestNeighbours(m,1:3);
            
         % Calculate the distance between the test point and train point
         % and store each value in the first column of the matrix "d"
            d(m,1) = pdist(points,'euclidean');
        end
     % Define the training labels as the second column of the matrix 
     % "d" so that the distance from the test point to each training
     % point corresponds to the correct label of each train point
        d(:,2) = NearestNeighbours(:,4);
        
     % Sort the rows of the matrix neighbours with respect to the first 
     % column, so that the distances between each point are in ascending
     % order and still correspond to their correct label
        KNN = sortrows(d);
        
     % Identify the desired label of the test point by calculating the 
     % mode of the labels corresponding to the smallest "k" distances
     % i.e. the most occuring label with respect to it's k nearest neighbours
        class(j) = mode(KNN(1:k,2));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of function ClassifyX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

