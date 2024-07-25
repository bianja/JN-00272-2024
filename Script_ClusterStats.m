
clear all
close all
clc
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF.mat')

%% PCA
% visualize clustering results
figure;
gscatter(scores(:, 1), scores(:, 2), idx);
hold on;
% scatter(centroids(:, 1), centroids(:, 2), 100, 'k', 'filled');
xlabel('Feature 1');
ylabel('Feature 2');
title('Final Clustering Results');

%% visualize silhouette score
figure
bar([sort(silhouetteVals(find(idx == 1))); sort(silhouetteVals(find(idx == 2))); sort(silhouetteVals(find(idx == 3))); sort(silhouetteVals(find(idx == 4)))])
xlabel('cluster')
set(gca,'XTick',[15 35 55 80],'XTickLabel',{'1','2','3','4'})
ylabel('silhouette val')

%%
clearvars -except AllAni bgVector CI covarianceMatrix eigenValues eigenVectors idx
x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 3375]; x8 = x8 * 0.0222;
groups = 4;

  
