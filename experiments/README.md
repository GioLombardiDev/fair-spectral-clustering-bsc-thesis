# Experiments

Scripts used to reproduce the experimental results and figures in the thesis.

## Facebook network experiment
Applies and compares four spectral clustering variants on cleaned Facebook friendship data.
The script builds an unweighted adjacency matrix, extracts the largest connected component,
and evaluates the following methods for k = 2,...,6:
- SC (alg1)
- FairSC (alg2)
- s-FairSC (alg3)
- gep-FairSC (alg4)

Metrics: balance (gender fairness) and NCut.
Outputs: Figure 1 (balance vs k) and Figure 2 (NCut vs k).
For k = 2, the script optionally prints per-cluster gender fractions.

## Fisher Iris experiment
Builds a kNN similarity graph for the Fisher Iris dataset (2D SVD projection, kNN with k = 4, sigma = 1),
then compares:
- SC (alg1)
- fairness-constrained variant (alg2)

The fairness constraint uses an artificial binary protected grouping.
Outputs: figures for the similarity graph, SC clustering, protected groups, and fair clustering,
plus a small table reporting balance and NCut.

## Random Laplacian experiment
Benchmarks runtime of SC (alg1), FairSC (alg2), s-FairSC (alg3), and gep-FairSC (alg4)
on random sparse symmetric graphs for n = 1000, ..., 8000 and edge densities Wden in {0.001, 0.01, 0.1}.
Each setting is repeated 15 times, isolated nodes are avoided, and mean runtime is plotted versus n
(with scaled ~n^2 and ~n^3 reference curves). alg2 is run up to n = 4000.
