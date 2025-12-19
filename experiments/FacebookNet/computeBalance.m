function balance = computeBalance(labels, gmale, k)
% Computes minimum balance ratio across all clusters
% balance = min_i min(m_i/f_i, f_i/m_i) where m_i,f_i = males,females in cluster i

% Input:
% labels... cluster assignments (1..k)
% gmale...  binary vector: 1 = male, 0 = female
% k...      number of clusters
%
% Output:
% balance... fairness metric in [0,1], higher = more balanced

    b = zeros(k, 1);
    c = zeros(k, 1);
    for i = 1:k
        idx = find(labels == i);
        c(i) = length(idx); %n°persone nel cluster i-esimo
        count=sum(gmale(idx)==1); %n°maschi nel cluster i-esimo
        b(i) = min(count/(c(i)-count),(c(i)-count)/count);
    end
    %balance = mean(b);
    balance=min(b);
end

