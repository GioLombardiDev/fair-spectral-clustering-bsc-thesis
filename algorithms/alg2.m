function [clusterLabels, tr] = alg2(W, D, F, k)
%FairSC 

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

% 2: compute an orthonormal basis Z of the null space of F' n x (n-h+1)
Z = null(F');

% 3: compute the matrix square root Q = (Z'*D*Z)^1/2
Q=sqrtm(Z'*D*Z);

% 4: compute M = Q^-1ZTLZQ^-1 (n-h+1) x (n-h+1)
M=(Q\Z')*L*(Z/Q); 
M=(M+M')/2;


% 5: compute the k smallest eigenvalues of M and the corresponding eigenvectors Y (n-h+1) x k
% s = warning('error', 'MATLAB:EigenvaluesNotConverged');
% warning('error', 'MATLAB:MaxIterationReached');
% try
%     [Y, vals] = eigs(@(b) Afun2(M, b), n - size(F,2), k,'sr','SubspaceDimension',2*k);
% catch
%     fprintf('warning catched\n');
    [Y, ~] = eigs(@(b) Afun2(M, b), n - size(F,2), k,'sr','MaxIterations',1000,'SubspaceDimension',4*k,'Tolerance',1e-6, ...
        'IsFunctionSymmetric',1);
% end
% warning(s);

%6: apply k-means clustering to the rows of H = Z*Q^-1*Y
H = Z*(Q\Y);

% try
%     clusterLabels = kmeans(H,k,'Replicates',10);
% catch
%     fprintf('warning catched\n');
    clusterLabels = kmeans(H,k,'Replicates',10, 'MaxIter',500);
% end
% warning(s);

% tr = trace(H'*L*H);
% resH2 = norm(H'*D*H-eye(k),1)/k
% resF2 = norm(F'*H, 1)/max(size(F,2),k)

%Costruzione della matrice indicatrice del clustering e calcolo NCut
tr = mioNCut(clusterLabels,L,D,n,k); %da scommentare per esperimenti che
%richiedono NCut
end

