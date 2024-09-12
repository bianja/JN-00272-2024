
%% load data
clear; close all; clc
cd('\\132.187.28.171\home\Data\Analysis\matlab\scripts')
load('Results_groups_manuscript.mat')
AllAni = [excbi excinh1];
AllAni = [AllAni(1:56) AllAni(61:end)];

%% matrix containing data
% predefine vars
dataMatrix = zeros(size(AllAni,2),10);
bgVector = zeros(size(AllAni,2),1);
normData = zeros(size(AllAni,2),10);

for i = 1 : size(AllAni,2) % save data in one matrix (and bg in vector)
    dataMatrix(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8; % for ftb, w8    
    bgVector(i) = mean([AllAni(i).R01.background.rawmean.translation.fw.w2 AllAni(i).R01.background.rawmean.translation.fw.w4 AllAni(i).R01.background.rawmean.translation.fw.w8...
        AllAni(i).R01.background.rawmean.translation.bw.w2 AllAni(i).R01.background.rawmean.translation.bw.w4 AllAni(i).R01.background.rawmean.translation.bw.w8]); % bg vector for bg subtraction
%     h = hist(AllAni(i).R01.times.translation.fw.w8{1,5},26); % to use temporal dynamics for clustering
%     dataMatrix(i,:) = h;
%     normData(i,:) = (dataMatrix(i,:) - bgVector(i))/(max(dataMatrix(i,:) - bgVector(i))); % subtract bg and norm data
    normData(i,:) = dataMatrix(i,:)/max(dataMatrix(i,:)); % subtract bg and norm data
    
    dataMatrixBW(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w8; % for ftb, w8       
    normDataBW(i,:) = dataMatrixBW(i,:)/max(dataMatrixBW(i,:)); % subtract bg and norm data
end

%% find optimal number of clusters
wcss = zeros(1, 10);
for k = 1:10 % WCSS for different num of clusters
    [idx, centroid] = kmeans(normData, k);
    distances = sum((normData - centroid(idx, :)).^2, 2);
    wcss(k) = sum(distances);
end
figure;
plot(1:10, wcss, 'o-');
xlabel('Number of Clusters');
ylabel('WCSS');

%%
groups = 3;

 %% k means
% [idx, centroids] = kmeans(normData, groups);
% % [idx, model, energy] = knKmeans(dataMatrix',groups);
% % Plotting the data points with different colors for each cluster
% figure
% scatter(normData(:,1), normData(:,2), 10, idx, 'filled');
% hold on;
% 
% % Plotting the cluster centroids
% scatter(centroids(:,1), centroids(:,2), 50, 'k', 'filled');
% hold off;
% 
% % Adding labels and titles
% xlabel('Feature 1');
% ylabel('Feature 2');
% title('K-means Clustering');
% 
% % Evaluate clustering using silhouette score
% silhouette_vals = silhouette(normData, idx);
% mean_silhouette = mean(silhouette_vals);
% 
% % Evaluate clustering using within-cluster sum of squares (WCSS)
% D = pdist(normData, 'euclidean'); % Compute pairwise distances between data points
% D = squareform(D);
% wcss = 0;
% for k = 1:max(idx)
%     cluster_k = normData(idx == k, :);
%     centroid_k = mean(cluster_k);
%     dist_k = sum(sum((cluster_k - centroid_k).^2));
%     wcss = wcss + dist_k;
% end
% 
% % Display the evaluation results
% disp(['Mean Silhouette Score: ', num2str(mean_silhouette)]);
% disp(['Within-Cluster Sum of Squares (WCSS): ', num2str(wcss)]);
% 
% % Silhouette Analysis
% silhouette_vals = silhouette(normData, idx);
% mean_silhouette = mean(silhouette_vals);
% 
% % Plotting the data points with their assigned cluster labels
% % Convert cluster_labels to categorical variable
% figure; gscatter(normData(:, 1), normData(:, 2), idx);
% xlabel('Feature 1');
% ylabel('Feature 2');
% title('Clustering Results');
% legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5');  % Update with the appropriate legend labels

%% pca
% Compute PCA
% Compute the covariance matrix
covarianceMatrix = cov(normData);

% Calculate the eigenvectors and eigenvalues
[eigenVectors, eigenValues] = eig(covarianceMatrix);

% Sort the eigenvalues and corresponding eigenvectors in descending order
[eigenValues, indices] = sort(diag(eigenValues), 'descend');
eigenVectors = eigenVectors(:, indices);

% Compute the principal component scores
scores = normData * eigenVectors;

% Scatter plot of the principal component scores
figure;
gscatter(scores(:, 1), scores(:, 2));
title('PCA of Cluster Data');
xlabel('PC1');
ylabel('PC2');

tempNormData = normData;
clear normData
normData = scores(:,1:2);
%% bootstrap
numBootstraps = 1000; % num of bootstraps
bootstrapIndices = bootstrp(numBootstraps, @kmeans, normData, groups); % bootstrapping
bootstrapCentroids = zeros(groups, size(normData, 2));
for i = 1:numBootstraps
    sampleIndices = bootstrapIndices(i, :); % indices for curr bootstrap sample
    [sampleClusterIndices, sampleCentroids] = kmeans(normData(sampleIndices, :), groups); % k means on current bootstrap
    bootstrapCentroids = bootstrapCentroids + sampleCentroids; % cluster centroids
end
averageCentroids = bootstrapCentroids / numBootstraps; % avg cluster centroids
[idx, centroids] = kmeans(normData, groups, 'Start', averageCentroids); % k means on dataset using average centroids

% visualize clustering results
figure;
gscatter(normData(:, 1), normData(:, 2), idx);
hold on;
% scatter(centroids(:, 1), centroids(:, 2), 100, 'k', 'filled');
xlabel('Feature 1');
ylabel('Feature 2');
title('Final Clustering Results');

% WCSS (Within-Cluster Sum of Squares)
distances = pdist2(normData, centroids); % distances between data points and centroids
WCSS = sum(min(distances.^2, [], 2)); % sum of squared distances to the nearest centroid

% Silhouette Coefficient
silhouetteVals = silhouette(normData, idx); 
silhouetteCoeff = mean(silhouetteVals); 

% Davies-Bouldin Index
% dbIndex = evalclusters(normData,idx,'DaviesBouldin');

% display stats
display(WCSS)
display(silhouetteCoeff)
% display(dbIndex)

 %% bootstrap knk means
% numBootstraps = 1000; % num of bootstraps
% 
% % Define the Gaussian kernel function
% gaussianKernel = @(X, Y, sigma) exp(-(pdist2(X,Y).^2) / (2 * sigma^2));
% 
% % Set parameters
% kernel = @(X,Y) gaussianKernel(X,Y, (15-1)/6); % Gaussian kernel function
% 
% % Perform bootstrapping
% bootstrappedAssignments = cell(numBootstraps, 1);
% for i = 1:numBootstraps
%     % Generate bootstrap sample
%     bootstrapIndices = datasample(1:size(normData, 1), size(normData, 1), 'Replace', true);
%     bootstrapData = normData(bootstrapIndices, :);
%     
%     % Compute kernel matrix
%     kernelMatrix = kernel(bootstrapData, bootstrapData);
%     
%     % Apply kernel k-means
%     [assignments] = knKmeans(kernelMatrix, groups);
%     centroids = grpstats(normData, assignments, 'mean');
%     
%     % Store the cluster assignments
%     bootstrappedAssignments{i} = assignments;
% end
% 
% % Create the consensus matrix
% n = size(normData, 1); % number of data points
% consensusMatrix = zeros(n, n);
% 
% for i = 1:n
%     for j = i+1:n
%         count = sum(cellfun(@(x) x(i) == x(j), bootstrappedAssignments));
%         consensusValue = count / numBootstraps;
%         consensusMatrix(i, j) = consensusValue;
%         consensusMatrix(j, i) = consensusValue;
%     end
% end
% 
% % Apply hierarchical clustering to the consensus matrix
% Z = linkage(1 - consensusMatrix, 'average'); % Compute the hierarchical clustering linkage
% 
% % Extract the cluster assignments using the 'cut' method
% assignments = cluster(Z, 'maxclust', groups);
% 
% % visualize clustering results
% figure;
% gscatter(normData(:, 1), normData(:, 2), assignments);
% hold on;
% % scatter(centroids(:, 1), centroids(:, 2), 100, 'k', 'filled');
% xlabel('Feature 1');
% ylabel('Feature 2');
% 
% % WCSS (Within-Cluster Sum of Squares)
% distances = pdist2(normData, centroids); % distances between data points and centroids
% WCSS = sum(min(distances.^2, [], 2)); % sum of squared distances to the nearest centroid
% 
% % Silhouette Coefficient
% silhouetteVals = silhouette(normData, assignments); 
% silhouetteCoeff = mean(silhouetteVals); 
% 
% % Davies-Bouldin Index
% % dbIndex = evalclusters(normData,idx,'DaviesBouldin');
% 
% % display stats
% display(WCSS)
% display(silhouetteCoeff)
% % display(dbIndex)
% 
%%  plot cluster
clear normData
normData = tempNormData;
col = repmat([0.7 0.7 0.7],groups,1);
figure
for i = 1 : groups
    subplot(1,groups,i)
    hold on
    plot(normDataBW(find(idx == i),:)','Color',[col(i,:) .2])%[0 0 0 .2])
    plot(median(normDataBW(find(idx == i),:))','Color',[0 0 0],'LineWidth',1.5)
    set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
%     ylim([0 1])
end
set(gcf,'Position',[680 520 515 180])
subplot(1,groups,2)
xlabel('temporal frequency (Hz)')
subplot(1,groups,1)
ylabel('norm spike rate')

%% visualize silhouette score
figure
bar(silhouetteVals)
xlabel('unit')
ylabel('silhouette val')



