%% CHAPTER 1 FIGURES - CLUSTERING COMPARISON
% Generates two-circle synthetic data and compares spectral clustering 
% (custom algorithm) with K-means for visualization.

clear all
rng('default') 

thisFile = mfilename('fullpath');
repoRoot = fileparts(fileparts(fileparts(thisFile))); % mioProva -> experiments -> repo root
addpath(fullfile(repoRoot,'algorithms'))
addpath(genpath(fullfile(repoRoot,'experiments')))

% Parameters for data generation
N = 150;  
n=2*N;
r1 = 3;   % Radius of first circle
r2 = 5;   % Radius of second circle
theta = linspace(0,2*pi,N)';

X1 = r1*[cos(theta),sin(theta)]+[rand(N,1),rand(N,1)]; 
X2 = r2*[cos(theta),sin(theta)]+[rand(N,1),rand(N,1)]; 
X = [X1;X2]; 

W = adjencymatrixknn(X,10,1);

d=sum(W);
D=sparse(diag(d));

k=2;
idx=alg1(W,D,k);

%figure(2)
%idx2=spectralcluster(W,k,'Distance','precomputed','LaplacianNormalization','symmetric');
%gscatter(X(:,1),X(:,2),idx2);

labels=[ones(N,1);2*ones(N,1)];

figure(3)
g=gscatter(X(:,1),X(:,2),idx); hold on
axis equal
axis([-6 7 -6 7])
g(1).Color=[0.9290 0.6940 0.1250];
g(1).MarkerSize=10;
g(2).Color=[0.4660 0.6740 0.1880]*0.9;
g(2).MarkerSize=10;
hold off

figure(4)
idx2=kmeans(X,k);
g=gscatter(X(:,1),X(:,2),idx2); hold on
axis equal
axis([-6 7 -6 7])
g(1).Color=[0.9290 0.6940 0.1250];
g(1).MarkerSize=10;
g(2).Color=[0.4660 0.6740 0.1880]*0.9;
g(2).MarkerSize=10;
hold off

figure(5)
G=graph(W); LWidths = 1.2*G.Edges.Weight/max(G.Edges.Weight);
p=plot(G,'XData', X(:,1), 'YData', X(:,2)); hold on
axis equal
axis([-6 7 -6 7])
p.LineWidth=LWidths;
p.Marker='none';
p.EdgeColor=[0.3010 0.7450 0.9330];
hh=gscatter(X(:,1),X(:,2),labels);
hh(1).Color=[0 0.4470 0.7410];
hh(1).MarkerSize=10;
hh(2).Color=[0.8500 0.3250 0.0980];
hh(2).MarkerSize=10;
%font: 100%; dimensioni: 16x10


