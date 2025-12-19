%% RANDOMLAPLACIAN EXPERIMENT
% This script benchmarks the runtime of multiple spectral clustering variants
% (baseline and fairness-constrained) on random sparse graph Laplacians.
% For each graph size n and edge density Wden, it generates a random symmetric
% weight matrix, builds the corresponding degree matrix, runs the algorithms
% for several repetitions, and plots the average execution time versus n.

clearvars
set(0,'DefaultLineLineWidth',2)
%exp setup: width: 14; height: 12; fontsize: 145
%ritaglio: 2 1 4 8

runs = 15;
n_range =1000:1000:8000; %era 5000:1000:10000;
n_range_alg4 =1000:1000:8000; 
n_range_alg2 = 1000:1000:4000;
Wden_range=[0.001,0.01,0.1];

time1 = zeros(runs, length(n_range), length(Wden_range));
% time_Kalg = zeros(runs, length(n_range_alg2));
time3 = zeros(runs,length(n_range),length(Wden_range));
time4 = zeros(runs,length(n_range_alg4),length(Wden_range));
time2 = zeros(runs,length(n_range_alg2),length(Wden_range));

cont=1;

for Wden=Wden_range

for k=10

for h=10

for i = 1:length(n_range)
    n = n_range(i);

    fprintf('----------n = %d, k = %d, h = %d, Wden = %g ----------\n', n,k,h,Wden);

    for j = 1:runs
        fprintf('--------run = %d---------\n',j);

        % Testing on random Graph Laplacian
        W = sprand(n,n,Wden); 
        W = tril(W,-1);
        W = W+W';
        d = W*ones(n,1);

        idxIso = find(d == 0);
        if ~isempty(idxIso)
            for t = 1:numel(idxIso)
                ii = idxIso(t);
                jj = randi(n);
                while jj == ii
                    jj = randi(n);
                end
                W(ii, jj) = 1e-5;
                W(jj, ii) = 1e-5;
            end
        end

        W = (W+W')/2;
    %     W = W.*~eye(size(W));
        D = spdiags(W*ones(n,1),0,n,n);
        F = rand(n,h-1);
        
        fprintf('-----alg1-----\n');
        fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
        tstart = tic;
        clusters1 = alg1(W,D,k);
        time1(j,i,cont) = toc(tstart);
        
         if i <= length(n_range_alg2)
             fprintf('-----alg2-----\n');
             fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
             tstart = tic;
             clusters2 = alg2(W,D,F,k); 
             time2(j,i,cont) = toc(tstart);
         end
        
        fprintf('-----alg3-----\n');
        fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
        tstart = tic;
        clusters3 = alg3(W,D,F,k);
        time3(j,i,cont) = toc(tstart);
        
        if i <= length(n_range_alg4)
             fprintf('-----alg4-----\n');
             fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
             tstart = tic;
             clusters4 = alg4(W,D,F,k); 
             time4(j,i,cont) = toc(tstart);
        end
    end
end

figure(cont);clf;
n_range_alcubo = n_range_alg2.^3; n_range_alcubo = n_range_alcubo*(33.4/n_range_alcubo(end));
n_range_alquad = n_range.^2; n_range_alquad = n_range_alquad*(5/n_range_alquad(end));

% Uso squeeze e poi rendo riga.
y2 = squeeze(mean(time2(:,:,cont),1)); y2 = y2(:).';
y4 = squeeze(mean(time4(:,:,cont),1)); y4 = y4(:).';
y3 = squeeze(mean(time3(:,:,cont),1)); y3 = y3(:).';
y1 = squeeze(mean(time1(:,:,cont),1)); y1 = y1(:).';

p=plot(n_range_alg2,y2,'gx-', ...
    n_range_alg4,y4,'rx-', ...
    n_range,y3,'bx-', ...
    n_range,y1,'mx--', ...
    n_range,n_range_alquad,'yx-.', ...
    n_range_alg2,n_range_alcubo,'cx-.'); 

p(1).Color=[0.4940 0.1840 0.5560];
p(2).Color=[0.4660 0.6740 0.1880];
p(3).Color=[0 0.4470 0.7410];
p(4).Color=[0.8500 0.3250 0.0980];
p(5).Color=[0.3010 0.7450 0.9330];
p(6).Color=[0.9290 0.6940 0.1250];

ylim([0 35])
legend('FairSC','gep-FairSC','s-FairSC','SC','~n^2','~n^3', 'location', 'northwest')
xlabel('n')
ylabel('Tempo di esecuzione [s]')
title(strcat('RandomLaplacian: k=',num2str(k),', h=',num2str(h), ', d=',num2str(Wden)), 'FontWeight','normal')
%font: 100%; dimensioni: 16x10

cont=cont+1;
end

end

end
