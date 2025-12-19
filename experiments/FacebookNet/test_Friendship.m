%% FACEBOOK NETWORK EXPERIMENT
% Applies and compares four spectral clustering variants on Facebook friendship data.
% Algorithms: SC (alg1), FairSC (alg2), gep-FairSC (alg4), s-FairSC (alg3).
% Metrics: Minimum balance (gender fairness) and NCut (clustering quality).
% Results: Figures 1 (balance vs k) and 2 (NCut vs k) for k = 2,...,6.

clearvars; clear;
set(0,'DefaultLineLineWidth',2.5)
%EXPORT SETUP: 14cm 10cm 140% font size, Arial, ritaglio 1 1 3 11

% Load cleaned facebook friendship data
group = readmatrix('group_clean.csv');
% each row: [studentID gender], gender = 1 male, 0 female
friendship = readmatrix('friendship_clean.csv');
% each row: [studentID_i studentID_j w], w = 1 if friends, 0 otherwise

% Build adjacency matrix on the filtered set (students with known gender)
nall = size(group, 1);
A = zeros(nall, nall);
for m = 1:size(friendship,1)
    ii = find(group(:,1) == friendship(m,1));
    jj = find(group(:,1) == friendship(m,2));
    if friendship(m,3) == 1
        A(ii,jj) = 1;
        A(jj,ii) = 1;
    end
end
% Note: unknown friendship relations are treated as 0 (no edge)

G = graph(A);

% Largest connected component
[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
SG = subgraph(G, idx);

% W and D
W = adjacency(SG);
n = size(W, 1);
D = diag(W*ones(n,1));

% Sensitive attribute
g = group(idx,:);
gmale = g(:,2);
gfemale = double(~gmale);

% Fairness constraint matrix
F = gfemale - sum(gfemale)/n;

krange = 2:6;
Ncut1 = zeros(length(krange),1);
Ncut2 = zeros(length(krange),1);
Ncut3 = zeros(length(krange),1);
Ncut4 = zeros(length(krange),1);

balance1 = zeros(length(krange),1);
balance2 = zeros(length(krange),1);
balance3 = zeros(length(krange),1);
balance4 = zeros(length(krange),1);

f = sum(gmale)/size(g,1);

for i = 1:length(krange)
    k = krange(i);

    [labels1, tr1] = alg1(W, D, k);
    [labels2, tr2] = alg2(W, D, F, k);
    [labels3, tr3] = alg3(W, D, F, k);
    [labels4, tr4] = alg4(W, D, F, k);

    % Print cluster gender fractions for k = 2 (optional inspection)
    if k == 2
        fprintf('---------- k = %d ----------\n', k);

        f1 = computeFraction(labels1, gmale);
        f2 = computeFraction(labels2, gmale);
        f3 = computeFraction(labels3, gmale);
        f4 = computeFraction(labels4, gmale);

        fprintf('Overall female fraction: %.3f\n', 1 - f);
        disp(table((1:k)', 1-f1, 1-f2, 1-f3, 1-f4, ...
            'VariableNames', {'cluster','alg1','alg2','alg3','alg4'}))

        fprintf('Overall male fraction: %.3f\n', f);
        disp(table((1:k)', f1, f2, f3, f4, ...
            'VariableNames', {'cluster','alg1','alg2','alg3','alg4'}))
    end

    balance1(i) = computeBalance(labels1, gmale, k);
    balance2(i) = computeBalance(labels2, gmale, k);
    balance3(i) = computeBalance(labels3, gmale, k);
    balance4(i) = computeBalance(labels4, gmale, k); % FIX: was labels3

    Ncut1(i) = tr1;
    Ncut2(i) = tr2;
    Ncut3(i) = tr3;
    Ncut4(i) = tr4;
end

% Plot balance 
figure(1); clf;
plot(krange, balance1,'|-','Color',[0.4660 0.6740 0.1880]), hold on
plot(krange, balance2,'o-.','Color',[0.8500 0.3250 0.0980])
plot(krange, balance4,'x--','Color',[0.4940 0.1840 0.5560])
plot(krange, balance3,'s:','Color',[0 0.4470 0.7410])
hold off
ylim([0 1]);
xlabel('k');
ylabel('Minimum balance');
title('FacebookNet: Minimum balance','FontWeight','normal')
legend({'SC', 'FairSC', 'gep-FairSC', 's-FairSC'}, 'Location','south');

% Plot NCut
figure(2); clf;
plot(krange, Ncut1,'|-','Color',[0.4660 0.6740 0.1880]), hold on
plot(krange, Ncut2,'o-.','Color',[0.8500 0.3250 0.0980])
plot(krange, Ncut4,'x--','Color',[0.4940 0.1840 0.5560])
plot(krange, Ncut3,'s:','Color',[0 0.4470 0.7410])
hold off
legend({'SC', 'FairSC', 'gep-FairSC', 's-FairSC'}, 'Location','northwest');
xlabel('k');
ylabel('NCut');
title('FacebookNet: NCut','FontWeight','normal')


