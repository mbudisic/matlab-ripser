# matlab-ripser
Interface to RIPSER (computation of persistent homology) via MATLAB's python interface.

This package depends on

  - MATLAB having a working connection with a Python installation,
  - Ripser pip package being installed under the same Python environment.

For how to do that see
  - https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html
  - https://ripser.scikit-tda.org

To test that the MATLAB-Python-ripser toolchain was installed correctly run:
```
xy = sampleFromPNG(100, 'eyes.png', [0,1],[0,1]);
computeBarcodes(xy);
```
If you see no errors - things are well!

The package additionally has functions to compute CROCKER plots (https://doi.org/10.1371/journal.pone.0126383) from either point cloud trajectories, or distance matrix trajectories.
