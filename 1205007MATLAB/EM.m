% Author:  <ashik@KAI10>
% Created: 2017-05-14

clear
clc

data = dlmread('loc.txt');
Mean = mean(data);
Cov = cov(data);
%Cov = eye(2,2);

[N, ~] = size(data);
D = size(Mean);

numberOfShips = input('Enter Number of Ships: ');
% numberOfShips = 3;

Means = zeros(numberOfShips, D(1,2));
for i = 1:numberOfShips
    index = randi(N);
    Means(i,:) = data(index, :);
    %Means(i, :) = Mean;
end

Covs = zeros(D(1,2), D(1,2), numberOfShips);
for i = 1:numberOfShips
    Covs(:,:,i) = Cov;
end     

Means
Covs

Theta = rand(1,numberOfShips);
Theta = normalize(Theta);

old_loglikelihood = loglikelihood(data, Means, Covs, Theta)

PI = zeros(N, numberOfShips);

iteration = 1;
while(1)
    iteration
    % E STEP
    for i=1:N
        for j=1:numberOfShips
           number = mvnpdf(data(i,:), Means(j,:), Covs(:,:,j));
           PI(i,j) = Theta(1,j) * number;
        end
        div = sum(PI(i,:));
        PI(i,:) = PI(i,:) ./ div;
    end
    
    % M step 
    for k=1:numberOfShips
        % update mean
        sumPI = sum(PI(:,k));
        up = zeros(size(Mean));
        for i=1:N
            up = up + PI(i,k) * data(i,:);
        end
        Means(k, :) = up / sumPI;
        
        % update SIGMA
        up = zeros(size(Cov));
        for i=1:N
            up = up + PI(i,k) * (data(i,:)' - Means(k,:)') * (data(i,:)' - Means(k,:)')';
        end
        Covs(:,:,k) = up / sumPI;
        
        % update theta
        Theta(1, k) = sumPI/N;
    end
    
    new_loglikelihood = loglikelihood(data, Means, Covs, Theta);
    change = new_loglikelihood - old_loglikelihood
    old_loglikelihood = new_loglikelihood;
    
    if(change <= 1e-3)
        break;
    end
    
    iteration = iteration + 1;
end

% plot graph

x1 = min(data(:,1)):.1:max(data(:,1)); x2 = min(data(:,2)):.1:max(data(:,2));
[X1,X2] = meshgrid(x1,x2);
xlabel('x'); ylabel('y');

colors = ['r-', 'g-', 'b-', 'y-'];

for i=1:numberOfShips
    
    F = mvnpdf([X1(:) X2(:)],Means(i,:),Covs(:,:,i));
    F = reshape(F,length(x2),length(x1));
    
    contour(x1,x2,F, colors(1,i));
    hold on;

end

scatter(data(:,1),data(:,2));
