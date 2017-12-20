ArchAIDE Digit Tools
====================
ArchAIDE Digit Tools are applications for the automatic digitalization of technical drawings of archaeological vessels.

The main application is digitBatch (located in the folder ./code/apps/) that allows users to process a folder containing
technical drawings of vessels such as tableware, vases, amphorae, etc. This tool requires a few input such as
the path of the folder, the file extension of drawings, the ratio mm over pixels, etc. The output of this tool
is a new folder with digitized drawings in the SVG file format. For more information about the input parameters
of this tool check the help by calling the command "help digitBatch" in the MATLAB's Command Window.

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

DEPENDENCIES:
=============

This software uses some functions from the HDR Toolbox that can be downloaded at either:
http://www.advancedhdrbook.com/
or:
https://github.com/banterle/HDR_Toolbox



LICENSE:
========
ArchAIDE Digit Tools are distributed under the MPL 2.0 license: https://www.mozilla.org/MPL/2.0/


REFERENCE:
==========
If you use the ArchAIDE Digit Tools in your work, please cite it using this reference:

@InProceedings\{BIDWCDS17,

  author       = "Banterle, Francesco and Itkin, Barak  and Dellepiane, Matteo and Wolf, Lior and Callieri, Marco and Dershowitz, Nachum and Scopigno, Roberto",

  title        = "VASESKETCH: Automatic 3D Representation of Pottery from Paper Catalogue Drawings",

  booktitle    = "The 14th IAPR International Conference on Document Analysis and Recognition (ICDAR2017)",

  month        = "November",

  year         = "2017",

  publisher    = "IEEE",

  organization = "IEEE",

  url          = "http://vcg.isti.cnr.it/Publications/2017/BIDWCDS17"

}
