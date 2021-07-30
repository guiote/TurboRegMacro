# TurboRegMacros
Macros to correct chromatic shift between acquisition channels
It has been developped to corecet shift that occurs on our Pinning disk system.
The macro is designed to fit with the imaging naming protocol of the Metamorph software on our Nikon CSU-X1 and Leica CSU-W1 spinning disk system.

**SHIFT CALIBRATION MACRO**

 The macro charaterizes the chromatic shift between two imaging channels aquired sequentially (single camera mode). Ideal image for the calibration is obtained with fluorescent beads (Usually Tetraspeck beads allows to record the same object with standard laser lines ). 
 
  The macro used the TurboReg Pluging http://bigwww.epfl.ch/thevenaz/turboreg/
   Make sure that the TurboReg Pluging is well installed and updated.
  
   The macro propose the choice between Rigid Body or Affine type of distortion.
   
   It needs 2D .tif source and target images;
   The transformation matrice saved from the calibration can be batch apply to series of aquired images (single or zStacks) using the 
  shift_correction macro.
 
