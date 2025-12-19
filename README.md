# Spectral Clustering with Group Fairness (BSc Thesis Project)

This repository contains MATLAB code and materials for my BSc thesis on spectral clustering under group fairness constraints.

The thesis (in Italian) is included in `thesis/`.

## License
- Code: MIT Licence (see `LICENSE`).
- Thesis PDF in `thesis/`: provided for reading only, not covered by the code licence (all rights reserved).

## Overview
Spectral clustering groups data by analysing the spectrum (eigenvalues and eigenvectors) of a similarity matrix.

This project studies spectral clustering under a group fairness constraint. The goal is for cluster assignments to be independent of sensitive attributes at the group level by enforcing (as closely as possible) the same sensitive-group proportions in each cluster as in the overall dataset.

Implemented variants:
- **SC**: normalised spectral clustering (baseline)
- **FairSC**: spectral clustering with group fairness constraints [1]
- **s-FairSC**: scalable fair spectral clustering [2]
- **gep-FairSC**: FairSC variant based on a generalised eigenvalue formulation

## Repository structure
- `algorithms/` -- clustering algorithms and helper functions  
- `experiments/` -- scripts for experimental evaluation (real and synthetic data)  
- `thesis/` -- thesis PDF (Italian) and material used for figures. The PDF is provided for reading only and is not covered by the code licence  
- `startup.m` -- adds repository folders to the MATLAB path

## Requirements
- MATLAB
- Statistics and Machine Learning Toolbox

## Quickstart
1. Open MATLAB and set the Current Folder to the repository root.
2. Run:
   ```matlab
   startup
   ```

3. Run any script in `experiments/`.

## Dataset note

The FacebookNet experiment uses cleaned, derived data in `experiments/exp2_FN/`.
See `experiments/exp2_FN/DATASET_NOTICE.txt` for source and licence details.

## References

[1] M. Kleindessner, S. Samadi, P. Awasthi, J. Morgenstern (2019).
    Guarantees for Spectral Clustering with Fairness Constraints.
    In Proceedings of the 36th International Conference on Machine Learning (ICML), PMLR 97, 3458-3467.
    https://proceedings.mlr.press/v97/kleindessner19b.html

[2] J. Wang, D. Lu, I. Davidson, Z. Bai (2023).
    Scalable Spectral Clustering with Group Fairness Constraints.
    In Proceedings of the 40th International Conference on Machine Learning (ICML), PMLR 206, 6613-6629.
    https://proceedings.mlr.press/v206/wang23h.html

[3] J. Shi, J. Malik (2000).
    Normalized Cuts and Image Segmentation. IEEE TPAMI 22(8):888-905.
    https://doi.org/10.1109/34.868688

[4] U. von Luxburg (2007).
    A Tutorial on Spectral Clustering. Statistics and Computing 17(4):395-416.
    https://doi.org/10.1007/s11222-007-9033-z
