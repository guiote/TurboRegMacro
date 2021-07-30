# TurboRegMacros
Macros to correct chromatic shift between acquisition channels
It has been developped to corrcec shifts that occurs on our Spinning disk systems.
The macro is designed to fit with the imaging naming protocol of the Metamorph software on our Nikon CSU-X1 and Leica CSU-W1 spinning disk system.


## **Shift_calibration macro**

 The macro charaterizes the chromatic shift between two imaging channels aquired sequentially (single camera mode). Ideal image for the calibration is obtained with fluorescent beads (Usually Tetraspeck beads allows to record the same object with standard laser lines ). 
 
  The macro used the TurboReg Pluging http://bigwww.epfl.ch/thevenaz/turboreg/
   Make sure that the TurboReg Pluging is well installed and updated.
  
   The macro propose the choice between Rigid Body or Affine type of distortion.
   
   It needs 2D .tif source and target images;
   The transformation matrice saved from the calibration can be batch apply to series of aquired images (single or zStacks) using the 
  shift_correction macro.
 
## **Shift_correction macro**
 The macro  has to be used following the Shift_Calibration macro; it is suitable for images aquired with the spinning disk systems in single camera mode (two channel aquired sequentially)
 * it applyes the transformation matrice on a specific channel chosen  by the user 
 * all the images contained in a folder are batch processed
