/* Macro Written by Elvire GUIOT - Imaging Center if IGBMC - July 2021
 *  guiote@igbmc.fr
 * The macro  charaterizes the chromatic shift between two imaging channels on the base of fluorescent beads images (Usually
 * Tetraspeck beads allows to record the same object with standard laser lines )
 * 
 *  The macro used the TurboReg Pluging http://bigwww.epfl.ch/thevenaz/turboreg/
 *  Make sure that the TurboReg Pluging is well installed and updated.
 *  
 *  The macro propose the choice between Rigid Body  or Affine  type of distortion.
 *  
 *  It needs 2D .tif source and target images
 *  The transformation matrice saved from the calibration can be batch apply to series of aquired images (single or zStacks) using the 
 *  shift_correction macro.
 */


var dirPath;

	roiManager("reset");
	selectWindow("ROI Manager");
	run("Close");
	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      	} 
      	
	print("\\Clear");
	selectWindow("Log");
	run("Close");

	 
 	items = newArray("Rigid Body", "Affine");				//choice between RigigBody or Affine type of distortion.

	Dialog.create("Calib Image selection");
	Dialog.addMessage("Select the Target image for calibration");					/* select the target reference*/
	Dialog.addMessage("(The target  determines the reference to which the source image will be aligned)");
	Dialog.addMessage(" ");
	Dialog.addChoice("Transformation", items);
	Dialog.show();
	transformation= Dialog.getChoice();
	
	
	open();										
	dirPath = File.directory;							/*r�cup�ration du "path"*/
	getDimensions(width, height, channels, slices, frames);
	IDTarget = getImageID();
	run("Duplicate...", "title=image_target");
	imgName_target=getTitle();
	
	Dialog.create("Calib Image selection");
	Dialog.addMessage("Select the Source image for calibration");					/* select the source*/
	Dialog.addMessage("(The source determines which image will be aligned)");	
	Dialog.show();
	open();		
	IDSource = getImageID();
	run("Duplicate...", "title=image_source");
	imgName_source=getTitle();
	width = getWidth();
	height = getHeight();												// size of the image is needed for the turboReg function
	
if (transformation == "Rigid Body" ){
TurboReg_RigidBody(imgName_source, imgName_target, width, height);

// 3) The numeric results are stored inside ImageJ's results table. The first
// line (index [0]) corresponds to the coordinates of the pair of landmarks that
// determine the translation component. This translation might be non-zero
// because of geometric dicrepancies between ImageJ's coordinate system and
// TurboReg's. Together, the two remaining lines determine the rotation: we can
// compute the rotation angle by using simple trigonometric relations. Because
// we are undoing the rotation of step ii), the sign of the rotation angle is
// opposite to that we used in step ii).
sourceX0 = getResult("sourceX", 0); // First line of the table.
sourceY0 = getResult("sourceY", 0);
targetX0 = getResult("targetX", 0);
targetY0 = getResult("targetY", 0);
sourceX1 = getResult("sourceX", 1); // Second line of the table.
sourceY1 = getResult("sourceY", 1);
targetX1 = getResult("targetX", 1);
targetY1 = getResult("targetY", 1);
sourceX2 = getResult("sourceX", 2); // Third line of the table.
sourceY2 = getResult("sourceY", 2);
targetX2 = getResult("targetX", 2);
targetY2 = getResult("targetY", 2);

selectWindow("Refined Landmarks");
ResultPath= dirPath + "Transformation_RigidBody.csv";
saveAs("Results", ResultPath);
run("Close");
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      	} 
}

if (transformation == "Affine" ){
TurboReg_Affine(imgName_source, imgName_target, width, height);

// 3) The numeric results are stored inside ImageJ's results table. The first
// line (index [0]) corresponds to the coordinates of the pair of landmarks that
// determine the translation component. This translation might be non-zero
// because of geometric dicrepancies between ImageJ's coordinate system and
// TurboReg's. Together, the two remaining lines determine the rotation: we can
// compute the rotation angle by using simple trigonometric relations. Because
// we are undoing the rotation of step ii), the sign of the rotation angle is
// opposite to that we used in step ii).
sourceX0 = getResult("sourceX", 0); // First line of the table.
sourceY0 = getResult("sourceY", 0);
targetX0 = getResult("targetX", 0);
targetY0 = getResult("targetY", 0);
sourceX1 = getResult("sourceX", 1); // Second line of the table.
sourceY1 = getResult("sourceY", 1);
targetX1 = getResult("targetX", 1);
targetY1 = getResult("targetY", 1);
sourceX2 = getResult("sourceX", 2); // Third line of the table.
sourceY2 = getResult("sourceY", 2);
targetX2 = getResult("targetX", 2);
targetY2 = getResult("targetY", 2);

selectWindow("Refined Landmarks");
ResultPath= dirPath + "Transformation_Affine.csv";
saveAs("Results", ResultPath);
run("Close");
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      	} 
}

/*-----------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                  Fonctions                                                                                    */
/*-----------------------------------------------------------------------------------------------------------------------------------------------*/


function TurboReg_RigidBody(imgName_source, imgName_target, width, height){    
setBatchMode(true);

// Init the landmarks
sourceX0 = round (width/2);
sourceY0 = round (height*0.2);
targetX0 = sourceX0;
targetY0 = sourceY0;
sourceX1 = round (width/2);
sourceY1 = round (height / 2);
targetX1 = sourceX1;
targetY1 = sourceY1;
sourceX2 = round (width/2);
sourceY2 = round(height*0.8);
targetX2 = sourceX2;
targetY2 = sourceY2;

run("TurboReg ", "-align " 												// Register the two images that we have just prepared.
	+ "-window " + imgName_source + " "					// Source (window reference).
	+ "0 0 " + (width - 1) + " " + (height - 1) + " "		// No cropping.
	+ "-window " + imgName_target + " "						// Target (window reference).
	+ "0 0 " + (width - 1) + " " + (height - 1) + " " 		// No cropping.
	+ "-rigidBody " 										// This corresponds to rotation and translation.	
	+ sourceX0 + " " + sourceY0 + " "					// Source translation landmark.
	+ targetX0 + " " + targetY0 + " "				 // Target translation landmark.
	+ sourceX1 + " " + sourceY1 + " "						// Source first rotation landmark.
	+ targetX1 + " " + targetY1 + " "							// Target first rotation landmark.
	+ sourceX2 + " " + sourceY2 + " "				// Source second rotation landmark.
	+ targetX2 + " " + targetY2 + " " 
	+ "-showOutput"); 	   				// Target second rotation landmark.
									// show the result table.

setBatchMode(false);
}

function TurboReg_Affine(imgName_source, imgName_target, width, height){    
setBatchMode(true);

// Init the landmarks
sourceX0 = round (width/2);
sourceY0 = round(height*0.1);
targetX0 = sourceX0;
targetY0 = sourceY0;
sourceX1 = round(width/4);
sourceY1 = round(height*0.9);
targetX1 = sourceX1;
targetY1 = sourceY1;
sourceX2 = round(width*0.8);
sourceY2 = round(height*0.9);
targetX2 = sourceX2;
targetY2 = sourceY2;



run("TurboReg ", "-align " 												// Register the two images that we have just prepared.
	+ "-window " + imgName_source + " "					// Source (window reference).
	+ "0 0 " + (width - 1) + " " + (height - 1) + " "		// No cropping.
	+ "-window " + imgName_target + " "						// Target (window reference).
	+ "0 0 " + (width - 1) + " " + (height - 1) + " " 		// No cropping.
	+ "-affine " 										// This corresponds to rotation and translation.	
	+ sourceX0 + " " + sourceY0 + " "					// Source translation landmark.
	+ targetX0 + " " + targetY0 + " "				 // Target translation landmark.
	+ sourceX1 + " " + sourceY1 + " "						// Source first rotation landmark.
	+ targetX1 + " " + targetY1 + " "							// Target first rotation landmark.
	+ sourceX2 + " " + sourceY2 + " "				// Source second rotation landmark.
	+ targetX2 + " " + targetY2 + " " 
	+ "-showOutput"); 	   				// Target second rotation landmark.
									// show the result table.

setBatchMode(false);
}
