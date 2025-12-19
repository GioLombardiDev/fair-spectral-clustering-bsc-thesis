function [clusterLabels, tr] = alg4(W, D, F, k)
%gep-FairSC 

%INPUT:
%   W ... (weighted) adjacency matrix of size n x n
%   D ... degree matrix of W
%   F ... group membership matrix G of size n x (h-1)
%   k ... number of clusters

%OUTPUT:
% clusterLabels ... vector of length n comprising the cluster label for each
%                  data point

% 1: compute the Laplacian matrix L = D - W
[n, m] = size(F);
L = D - W;

% 2: compute eigenvectors of Ax=lambda Bx
A = [L,F;F',zeros(m,m)];
B = D; B(n+m,n+m)=0;
[X, ~] = eigs(A,B, k,-1e-6,'MaxIterations',1000,'SubspaceDimension',4*k,'Tolerance',1e-6);

% 3: compute H
H = X(1:n,:);

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

