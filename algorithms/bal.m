function balance = bal(idx,G,k)
% Computes (average) balance across k clusters for multi-group fairness
% balance = (1/k) * Σ_l [ min_i(|C_l∩V_i|) / max_i(|C_l∩V_i|) ]
% where C_l = cluster l, V_i = protected group i

% Input:
% idx... cluster assignments (n×1 vector, values 1..k)
% G...   group indicator matrix (n×h), G(j,i)=1 if obs j belongs to group i
% k...   number of clusters
%
% Output:
% balance... fairness metric in [0,1], 1 = perfect balance

h=size(G,2);
balvec=zeros(k,1);
for l=1:k
    vec=sum(G.*((idx==l)*ones(1,h))); %vec(i)=|V_i intersec C_l|
%     B=vec'*(1./vec); B(logical(speye(h)))=2;
%     balvec(l)=min(min(B));
    balvec(l)=min(vec)/max(vec);
end
%balance=min(balvec);   %balance
balance=sum(balvec)/k;  %average balance
end

