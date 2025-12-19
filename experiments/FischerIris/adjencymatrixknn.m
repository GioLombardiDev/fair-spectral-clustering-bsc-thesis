function W = adjencymatrixknn(X,k_nn,sigma)
% Symmetric adjacency matrix for mutual k-NN graph
% W(i,j) = exp(-dist^2/(2sigma^2)) if mutual k-nearest neighbors, else 0

% Input:
% X...     Data matrix (n×d), each row = observation
% k_nn...  Number of nearest neighbors
% sigma... Gaussian bandwidth
%
% Output:
% W...     Weighted adjacency matrix

k=k_nn;
distance='euclidean';

n=size(X,1);
IdxNN=knnsearch(X,X,'K',k+1,Distance=distance);
IdxNN(:,1)=[];
IM=zeros(n,n);
for i=1:n
    IM(i,IdxNN(i,:))=1;
end
IM=IM+IM'; IM(IM>0)=1;
%spy(IM)
dist=pdist(X,distance);
A=squareform(dist); 
W=A;
W(~IM)=0;
W(W>0)=exp(-W(W>0).^2./(2*sigma^2));
end

