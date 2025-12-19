function [clusterLabels, tr] = alg3(W, D, F, k)
%s-FairSC

%INPUT:
%   W ... (weighted) adjacency matrix of size n x n
%   D ... degree matrix of W
%   F ... group membership matrix G of size n x (h-1)
%   k ... number of clusters

%OUTPUT:
% clusterLabels ... vector of length n comprising the cluster label for each
%                  data point

% 1: compute the Laplacian matrix L = D - W
n = size(W, 1);
L = D - W;

% 2: set Ln = D^(-1/2)*L*D^(-1/2) and C = D^(-1/2)*F
sqrtD = sqrtm(D);
C = sqrtD\F;
Ln = (sqrtD\L)/sqrtD;

% 3: compute the k smallest eigenvalues of Lns and the corresponding eigenvectors
% as columns of X n x k
Ln = (Ln+Ln')/2;
sigma = norm(Ln,1);
% eigvals = eigs(Ln, k, 'sr','MaxIterations',1000,'SubspaceDimension', 4*k)

% s = warning('error', 'MATLAB:EigenvaluesNotConverged');
% warning('error', 'MATLAB:MaxIterationReached');
% try
%     [X, vals] = eigs(@(b) Afun(Ln, C, b, sigma), n, k, 'sr', 'SubspaceDimension',2*k);
% catch
%     fprintf('warning catched\n');
    [X,~] = eigs(@(b) Afun(Ln, C, b, sigma), n, k, 'sr','MaxIterations',1000,'SubspaceDimension', 4*k,'Tolerance',1e-6, ...
        'IsFunctionSymmetric',1);
% end
% warning(s);

% 4: apply k-means clustering to the rows of H = D^(-1/2)*X
H = sqrtD\X;
% scatter(H(:,1),H(:,2))
% plot(H(:,1),H(:,2),'k*','MarkerSize',5);

% try
%     clusterLabels = kmeans(H,k,'Replicates',10);
% catch
%     fprintf('warning catched\n');
    clusterLabels = kmeans(H,k,'Replicates',10,'MaxIter',500);
% end
% Restore the warnings back to their previous (non-error) state
% warning(s);

% tr = trace(H'*L*H);
% resH3 = norm(H'*D*H-eye(k),1)/k
% resF3 = norm(F'*H, 1)/max(size(F,2),k)

%Costruzione della matrice indicatrice del clustering e calcolo NCut
tr = mioNCut(clusterLabels,L,D,n,k); %da scommentare per esperimenti che
%richiedono NCut
end