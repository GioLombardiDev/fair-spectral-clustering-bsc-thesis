function tr = mioNCut(clusterLabels,L,D,n,k)
% Computes Normalized Cut (NCut) value for given clustering
% NCut = Sum_l cut(C_l, V\C_l) / vol(C_l) = trace(H'*L*H)

% Input:
% clusterLabels... assignment vector (1..k)
% L... Laplacian matrix (n×n)
% D... degree matrix (n×n)
% n... number of vertices
% k... number of clusters
%
% Output:
% tr... NCut value (lower -> better clustering)

H=zeros(n,k);
for l=1:k 
    index=(clusterLabels==l);
    H(index,l)=1/sqrt(sum(diag(D(index,index))));
end
tr = trace(H'*L*H); %NCut

% alternative:
% acc=0;
% for l=1:k
%     index=(clusterLabels==l);
%     vol=sum(diag(D(index,index)));
%     cut=sum(sum(W(clusterLabels==l,clusterLabels~=l),2));
%     acc=acc+cut/vol;
% end

