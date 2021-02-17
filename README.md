# matlab-ripser
Interface to RIPSER via MATLAB's python

This package depends on

  - MATLAB having a working connection with a Python installation,
  - RIPSER being installed in the same Python.

For how to do that see
  - https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html
  - https://ripser.scikit-tda.org

To test that the package was installed correctly run:

```
xy = sampleFromPNG(100, 'eyes.png', [0,1],[0,1]);
computeBarcodes(xy);
```
