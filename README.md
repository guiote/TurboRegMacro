# TurboRegMacros
Macros to correct chromatic shift between acquisition channels

#SHIFT cALIBRATION MACRO
 The macro  charaterizes the chromatic shift between two imaging channels on the base of fluorescent beads images (Usually
 Tetraspeck beads allows to record the same object with standard laser lines )
 
  The macro used the TurboReg Pluging http://bigwww.epfl.ch/thevenaz/turboreg/
   Make sure that the TurboReg Pluging is well installed and updated.
  
   The macro propose the choice between Rigid Body  or Affine  type of distortion.
   
   It needs 2D .tif source and target images;
   The transformation matrice saved from the calibration can be batch apply to series of aquired images (single or zStacks) using the 
  shift_correction macro.
 
