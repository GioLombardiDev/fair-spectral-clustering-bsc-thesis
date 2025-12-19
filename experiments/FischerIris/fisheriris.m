%% FISHERIRIS EXPERIMENT
% Applies spectral clustering and fair spectral clustering (s-FairSC) 
% to the Fisher Iris dataset for comparison.

format long
load fisheriris.mat
set(0,'DefaultLineLineWidth',1.5)

X=meas-ones(150,1)*mean(meas);
n=150;
labels=[ones(50,1);2*ones(50,1);3*ones(50,1)];
k=3;
%le osservazioni 102 e 143 sono uguali
[U,L,V]=svds(X,2);
Y=U*L;

k_knn=4; sigma=1;
W=adjencymatrixknn(Y,k_knn,sigma);
D=diag(sum(W));

figure(1)
G=graph(W); LWidths = 1.2*G.Edges.Weight/max(G.Edges.Weight);
p=plot(G,'XData', Y(:,1), 'YData', Y(:,2)); hold on
axis equal
p.LineWidth=LWidths;
p.Marker='none';
p.EdgeColor=[0.3010 0.7450 0.9330];
hh=gscatter(Y(:,1),Y(:,2),labels);
hh(1).Color=[0 0.4470 0.7410];
hh(1).MarkerSize=8;
hh(2).Color=[0.8500 0.3250 0.0980];
hh(2).MarkerSize=8;
hh(3).Color=[0.4660 0.6740 0.1880]*0.9;
hh(3).MarkerSize=8;
%legend('edges','C_1','C_2','C_3')
g = zeros(3, 1);
xlim([-4 4.5])
ylim([-2.5 2.5])
yticks([-2 -1 0 1 2])
g(1) = plot(NaN,NaN,'o','Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
g(2) = plot(NaN,NaN,'o','Color',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980]);
g(3) = plot(NaN,NaN,'o','Color',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
legend(g,'setosa','versicolor','virginica','Location','northeast');
title('FisherIris: grafo di similarità',fontweight="normal")
%font: 100%; dimensioni: 16x10

%tr1=1;
[idx1,tr1]=alg1(W,D,k);
%idx1=spectralcluster(X,k);

figure(2)
hh=gscatter(Y(:,1),Y(:,2),{idx1,labels}); hold on
axis equal
[hh.Marker]=deal('o','o','o','o','o');
hh(1).MarkerSize=4;
hh(1).MarkerFaceColor=[0 0.4470 0.7410];
hh(1).MarkerEdgeColor=[0 0.4470 0.7410];
hh(2).MarkerSize=4;
hh(2).MarkerEdgeColor=[0.8500 0.3250 0.0980];
hh(2).MarkerFaceColor=[0.8500 0.3250 0.0980];
hh(3).MarkerSize=4;
hh(3).MarkerEdgeColor=[0.8500 0.3250 0.0980];
hh(3).MarkerFaceColor=[0.4660 0.6740 0.1880]*0.9;
hh(4).MarkerSize=4;
hh(4).MarkerEdgeColor=[0.4660 0.6740 0.1880]*0.9;
hh(4).MarkerFaceColor=[0.8500 0.3250 0.0980];
hh(5).MarkerSize=4;
hh(5).MarkerEdgeColor=[0.4660 0.6740 0.1880]*0.9;
hh(5).MarkerFaceColor=[0.4660 0.6740 0.1880]*0.9;
ylim([-2.8 1.8])
xlim([-3.6 4.1])
yticks([-2 -1 0 1] )
g = zeros(5, 1);
g(1) = plot(NaN,NaN,'o','MarkerEdgeColor',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
g(2) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980]);
g(3) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
g(4) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.8500 0.3250 0.0980]);
g(5) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
legend(g,'I cl., setosa','II cl., versicolor','II cl., virginica','III cl., versicolor','III cl., virginica','Location','south')
title('FisherIris: SC','fontweight','normal')
%font: 100%; dimensioni: 16x10

G=zeros(150,2);

%questa scelta dei gruppi è troppo in contrasto con i cluster -> risultati
%poco significativi
% G(1:50,1)=1; G(51:100,2)=1; G(101:150,3)=1;

%con i gruppi dati a seguire giustamente viene un risultato quasi identico
%a SC
%G(1:16,1)=1; G(51:66,1)=1; G(101:116,1)=1;
%G(17:32,2)=1; G(67:79,2)=1; G(117:133,2)=1;
%G(33:50,3)=1; G(80:100,3)=1; G(134:150,3)=1;

%scelta gruppi definitiva
G(1:25,1)=1; G(26:50,2)=1; G(51:100,1)=1; G(101:150,2)=1; 

figure(3)
gg=gscatter(Y(:,1),Y(:,2),{G(:,1),G(:,2)}); hold on
axis equal
%gg=gscatter(Y(:,1),Y(:,2),{G(:,1),G(:,2)}); hold on
[gg.Marker]=deal('o','o');
gg(1).MarkerSize=4;
gg(1).MarkerFaceColor=[0.4940*1.5 0.1840*1.5 1.30*0.5560];
gg(1).MarkerEdgeColor=[0.4940*1.5 0.1840*1.5 1.30*0.5560];
gg(2).MarkerSize=4;
gg(2).MarkerFaceColor=[0.9290 0.6940 0.1250];
gg(2).MarkerEdgeColor=[0.9290 0.6940 0.1250];
g = zeros(2, 1);
g(1) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.9290 0.6940 0.1250],'MarkerFaceColor',[0.9290 0.6940 0.1250]);
g(2) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.4940*1.5 0.1840*1.5 1.30*0.5560],'MarkerFaceColor',[0.4940*1.5 0.1840*1.5 1.30*0.5560]);
ylim([-2.8 1.8])
xlim([-3.6 4.1])
yticks([-2 -1 0 1] )
legend(g,'I gr.','II gr.','Location','south')
hold off
title('FisherIris: gruppi protetti','fontweight','normal')
%font: 100%; dimensioni: 16x10

z=sum(G,1)'/n;
F0=G-ones(n,1)*z';
F=F0(:,1:end-1);

[idx2,tr2]=alg2(W,D,F,k);

figure(4)
hh=gscatter(Y(:,1),Y(:,2),{idx2,labels}); hold on
axis equal
[hh.Marker]=deal('o','o','o','o','o');
hh(1).MarkerSize=4;
hh(1).MarkerFaceColor=[0 0.4470 0.7410];
hh(1).MarkerEdgeColor=[0 0.4470 0.7410];
hh(2).MarkerSize=4;
hh(2).MarkerEdgeColor=[0.8500 0.3250 0.0980];
hh(2).MarkerFaceColor=[0.8500 0.3250 0.0980];
hh(3).MarkerSize=4;
hh(3).MarkerEdgeColor=[0.8500 0.3250 0.0980];
hh(3).MarkerFaceColor=[0.4660 0.6740 0.1880]*0.9;
hh(4).MarkerSize=4;
hh(4).MarkerEdgeColor=[0.4660 0.6740 0.1880]*0.9;
hh(4).MarkerFaceColor=[0.8500 0.3250 0.0980];
hh(5).MarkerSize=4;
hh(5).MarkerEdgeColor=[0.4660 0.6740 0.1880]*0.9;
hh(5).MarkerFaceColor=[0.4660 0.6740 0.1880]*0.9;
ylim([-2.8 1.8])
xlim([-3.6 4.1])
yticks([-2 -1 0 1] )
g = zeros(5, 1);
g(1) = plot(NaN,NaN,'o','MarkerEdgeColor',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
g(2) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980]);
g(3) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
g(4) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.8500 0.3250 0.0980]);
g(5) = plot(NaN,NaN,'o','MarkerEdgeColor',[0.4660 0.6740 0.1880]*0.9,'MarkerFaceColor',[0.4660 0.6740 0.1880]*0.9);
legend(g,'I cl., setosa','II cl., versicolor','II cl., virginica','III cl., versicolor','III cl., virginica','Location','south')
title('FisherIris: s-FairSC','fontweight','normal')
%font: 100%; dimensioni: 16x10

b1=bal(idx1,G,k); b2=bal(idx2,G,k);
table(['SC      ';'s-FairSC'],[b1 b2]', [tr1 tr2]','VariableNames',{'alg','balance','NCut'})


