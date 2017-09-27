ArchAIDE Digit Tools
====================
ArchAIDE Digit Tools are tools for the automatic digitalizations of technical drawings of archaeological vessels.

The main application is digitBatch (located in the folder ./code/apps/) that allows users to process a folder containing
technical drawings of vessels such as tableware, vases, amphorae, etc. This tool requires a few input such as
the path of the folder, the file extension of drawings, the ratio mm over pixels, etc. The output of this tool
is a new folder with digitized drawings in the SVG file format.

The second application is digit (located in the folder ./code/apps/) that allows users to check and fix the results
of digitBatch. This tool has a GUI with different tools for fixing an SVG. For example, digit provides a tool for
setting the revolution axis of a vessel, labelling a fracture, setting different parameters of the algorithm, etc.
digit can be employed to digitize drawings from scratch as well.

HOW TO INSTALL:
===============
1) Unzip the file .zip in a FOLDER on your PC/MAC

2) Run Matlab

3) Set the FOLDER as current directory

4) Write the command install in the Command Window, and wait for the installation process to end.
