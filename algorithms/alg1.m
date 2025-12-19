function [clusterLabels,tr] = alg1(W, D, k)
%SC

%INPUT:
%   W ... (weighted) adjacency matrix of size n x n
%   D ... degree matrix of W
%   k ... number of clusters

%OUTPUT:
%   clusterLabels ... vector of length n comprising the cluster label for 
%                  each data point
%   (aggiunto) tr... trace(H'*L*H), approssimazione dell'NCut ottenuto

% 1: compute the Laplacian matrix L = D - W
n = size(W, 1);
L = D - W;

% 2: compute the normalized Laplacian Ln=D^(-1/2)*L*D^(-1/2)
% componet-wise: 
% observed slower than sqrtm (is sqrtm smart enough to detect diagonal matrix?)
sqrtD = sqrtm(D);
Ln = (sqrtD\L)/sqrtD;
Ln = (Ln+Ln')/2;

% 3: compute the k smallest eigenvalues of Ln and the corresponding eigenvectors Y n x k
% s = warning('error', 'MATLAB:EigenvaluesNotConverged');
% warning('error', 'MATLAB:MaxIterationReached');
% try
%     [Y, vals] = eigs(@(b) Afun2(Ln, b), n, k, 'sr','SubspaceDimension',2*k);
% catch
%     fprintf('warning catched\n');
    [Y,~] = eigs(@(b) Afun2(Ln, b), n, k, 'sr', 'MaxIterations', 1000, 'SubspaceDimension', 4*k,'Tolerance',1e-6, ...
        'IsFunctionSymmetric',1);
% end
% warning(s);

% 4: apply k-means clustering to the rows of H = D^(-1/2)*Y
H = sqrtD\Y;
%H = H*sparse(diag(1./vecnorm(H)));

% try
%     clusterLabels = kmeans(H,k,'Replicates',10);
% catch
%     fprintf('warning catched\n');
    [clusterLabels, ~] = kmeans(H,k,'Replicates',10, 'MaxIter',500);
% end
% warning(s);

% resH1 = norm(H'*D*H-eye(k),1)/k;

% figure(30)
% g=gscatter(H(:,1),H(:,2),[ones(150,1);2*ones(150,1)]); hold on%per scriptfigura1
% axis equal, %per scriptfigura1
% axis([-0.05 0.02 -0.04 0.03]), 
% g(1).Color=[0 0.4470 0.7410];
% g(1).MarkerSize=10;
% g(2).Color=[0.8500 0.3250 0.0980];
% g(2).MarkerSize=10;

% scatter3(H(:,1),H(:,2),H(:,3),20,clusterLabels); hold on %per fisheriris 
% colormap(gca,cool) %per fisheriris
% scatter3(ctrs(:,1),ctrs(:,2),ctrs(:,3),'kx'); hold off
% xlabel('var1'),ylabel('var2'),zlabel('var3')

%facoltativo: sistemo le labels nel modo che preferisco
% uniquecl=unique(clusterLabels,'stable');
% temp=zeros(150,1);
% for l=1:k, temp(clusterLabels==uniquecl(l))=l; end
% clusterLabels=temp;

% figure(31)
% p=plot(H,'s','LineWidth',0.5,'MarkerSize',3); hold on
% p(3).Color=[0.4660 0.6740 0.1880]*0.9;
% [p.MarkerFaceColor] = deal([0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.4660 0.6740 0.1880]*0.9);
% g = zeros(3, 1);
% g(1) = plot(NaN,NaN,'s','Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
% g(2) = plot(NaN,NaN,'s','Color',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980]);
% g(3) = plot(NaN,NaN,'s','Color',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
% legend(g,'h_1','h_2','h_3','Location','southwest');
% title("FisherIris: autovettori di L_{rw}",fontweight="normal")
% hold off

% figure(32)
% s=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.4660 0.6740 0.1880]*0.9];
% for l=1:k
%     p=plot(find(clusterLabels==l),H(clusterLabels==l,:),'s','Color',s(l,:),'LineWidth',0.5,'MarkerSize',3); hold on
%     [p.MarkerFaceColor] = deal(s(l,:),s(l,:),s(l,:));
% end
% g = zeros(3, 1);
% g(1) = plot(NaN,NaN,'s','Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
% g(2) = plot(NaN,NaN,'s','Color',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980]);
% g(3) = plot(NaN,NaN,'s','Color',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
% legend(g,'I cl.','II cl.','III cl.','Location','southwest');
% title("FisherIris: autovettori di L_{rw} e clusters",fontweight="normal")
% hold off


%Costruzione della matrice indicatrice del clustering e calcolo NCut
tr = mioNCut(clusterLabels,L,D,n,k); %da scommentare per esperimenti che
%richiedono NCut
end


