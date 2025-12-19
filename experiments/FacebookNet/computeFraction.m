function fractions = computeFraction(labels,gmale)
% Computes male percentage in each cluster
% fractions(i) = (#males in cluster i) / (size of cluster i)

% Input:
% labels... cluster assignments (1..k)
% gmale...  binary vector: 1 = male, 0 = female
%
% Output:
% fractions... k×1 vector with male proportions per cluster

    unilb = unique(labels);
    k = length(unilb);
    fractions = zeros(k,1);
    for i = 1:k
        idx = labels == unilb(i);
        ci = sum(idx);                  %n°persone nel cluster i-esimo
        vfandci = sum(gmale(idx));      %n°maschi nel cluster i-esimo
        fractions(i) = vfandci/ci;
    end
end

