function W = adjencymatrixfull(X)
% Fully-connected weighted adjacency matrix using Gaussian similarity
% W(i,j) = exp(-dist(i,j)^2/(2sigma^2)), with sigma chosen heuristically

% Input:
% X... Data matrix (n×d), each row = observation
%
% Output:
% W... Fully-connected weighted adjacency matrix

%parametri
distance='euclidean';
n=size(X,1);

%metodo euristico per la scelta di sigma
k=3;
Mdl=createns(X);
IdxNN=knnsearch(Mdl,X,'K',k+1);
IdxNN(:,1)=[];
sigma=mean(vecnorm((X-X(IdxNN(:,k),:))'));

%costruzione della matrice di adiacenza
dist=pdist(X,distance);
A=squareform(dist);
W=exp(-(A.^2)./(2*sigma^2));
W(logical(eye(n,n)))=0;


%per il plot elimino i lati poco signiifcativi
Wplot=W; Wplot(Wplot<0.1)=0;
G=graph(Wplot); 
LWidths = 1*G.Edges.Weight/max(G.Edges.Weight);
LWidths(LWidths<=0.1)=0;
plot(G,'XData', X(:,1), 'YData', X(:,2), 'LineWidth',LWidths)
end


