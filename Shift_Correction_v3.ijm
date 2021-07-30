/* Macro Written by Elvire GUIOT - Imaging Center if IGBMC - July 2021
 *  guiote@igbmc.fr
 * The macro  has to be used following the Shift_Calibration macro; it is suitable for images aquired with the spinning disk systems
 * it applyes the transformation matrice on a specific channel chosen  by the user 
 * all the images contained in a folder are batch processed
 * 
 * 
  */
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


itemsystems = newArray("Spinning Nikon CSU_X1", "Spinning Leica CSU_W1");		
Dialog.create("Selection of the transformation file");
Dialog.addChoice("Data from", itemsystems);		
Dialog.addMessage("Select the transformation file to Apply");			
Dialog.show();
system = Dialog.getChoice();										// system Nikon or Leica
open();														
dirTrans = File.name();
transname = File.getNameWithoutExtension(dirTrans);
TransType = substring (transname, 15);									// transformation affine or rigidBody

if (TransType == "RigidBody") TransToApply = "-rigidBody ";
if (TransType == "Affine") TransToApply = "-affine ";

Table.rename("Transformation.csv");

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

run("Close");

Dialog.create("Selection a folder to process");
Dialog.addMessage("Selection a folder to process");					
Dialog.show();
dir = getDirectory("Choose a Directory ");	

if (system == "Spinning Leica CSU_W1" ) {
		
		Dialog.create("Which Channel need to be corrected?");				// dialog box to select a channel for SPinning Disk Leica CSU_W1
		label ="Channel to correct";
		itemsLeica =newArray("CSU405","CSU488" , "CSU561", "CSU642");
		Dialog.addChoice(label, itemsLeica);
		Dialog.show();
		Channel = Dialog.getChoice();
}

if (system == "Spinning Nikon CSU_X1" ) {
		
		Dialog.create("Which Channel need to be corrected?");				// dialog box to select a channel for SPinning Disk Nikon CSU_X1
		label ="Channel to correct";
		itemsNik =newArray("SPI 405 DAPI","SPI 491 GFP" , "SPI 561 mCherry", "SPI 635 CY5");
		Dialog.addChoice(label, itemsNik);
		Dialog.show();
		Channel = Dialog.getChoice();
}

list=getFileList(dir);													// list the files in the folder to be processed
listImages = newArray(list.length);
ImagesToCorrect=newArray(list.length);

setBatchMode(true);
for (i=0; i<list.length; i++) {
		print (list[i]);
}

j=0;

for (i=0; i<list.length; i++) {
	test = list[i].contains(Channel);		
		if (test == "true"){
				ImagesToCorrect[j]=list[i];     						// select only the channel choosen by the user 
				j=j+1;
			}
	}

print("\\Clear");
nbImagesToCorrect= j;
for (i=0; i<nbImagesToCorrect; i++) {

		open (dir+ImagesToCorrect[i]);
		imgName=getTitle();
		width = getWidth();
		height = getHeight();
		numSlices = nSlices;
		print("Correcting " + ImagesToCorrect[i] );
		
if (numSlices == 1){		

	run("TurboReg ", "-transform " 					//run turboReg transform							
		+ "-window " + imgName + " " 
		+ width + " " + height + " "
		+ TransToApply 										
		+ sourceX0 + " " + sourceY0 + " "					
		+ targetX0 + " " + targetY0 + " "				 
		+ sourceX1 + " " + sourceY1 + " "						
		+ targetX1 + " " + targetY1 + " "							
		+ sourceX2 + " " + sourceY2 + " "				
		+ targetX2 + " " + targetY2 + " " 
		+ "-showOutput"); 
									
		run("Conversions...", " "); //don't re-scale when converting to 16bit
		run("16-bit");
		 run("Duplicate...", "title=registered"); //get the result
		 corrImage=dir + "registered_" + imgName  ;
		 save(corrImage);
		 close();
		 selectWindow("Output");
		 close();
		 selectWindow(imgName);
		 close();
}else {
		
	for(j=1; j <=numSlices; j++) { //for each slice				//if the image is a zstack
		    selectImage(imgName);
		    setSlice(j);
		    run("Duplicate...", "title=currentFrame"); //get the current slice
		   	tempName=getTitle();
		    run("TurboReg ", "-transform " 					//run turboReg transform							
					+ "-window " + tempName + " "    
					+ width + " " + height + " "
					+ TransToApply 										
					+ sourceX0 + " " + sourceY0 + " "					
					+ targetX0 + " " + targetY0 + " "				 
					+ sourceX1 + " " + sourceY1 + " "						
					+ targetX1 + " " + targetY1 + " "							
					+ sourceX2 + " " + sourceY2 + " "				
					+ targetX2 + " " + targetY2 + " " 
					+ "-showOutput"); 
		    run("Duplicate...", "title=registered"); //get the result
		    run("Conversions...", " "); //don't re-scale when converting to 16bit
		    run("16-bit");
		    if(j == 1) { //if this is the first slice, start the "registeredStack"
		        run("Duplicate...", "title=registeredStack");
		        selectWindow("registered");
		        close();
		    } else { //otherwise, concatenate the result with the growing "registeredStack"
		        run("Concatenate...", "  title=registeredStack open image1=registeredStack image2=registered");
		       		    }
		
		    selectWindow("currentFrame"); //close unneeded windows
		    close();
		    selectWindow("Output");
		    close();
	}
				selectWindow("registeredStack");
		     corrImage=dir + "registered_"  + imgName  ;
			 save(corrImage);
			 close();
		}
 }	
setBatchMode(false);
print ("Done!");
while (nImages>0) { 
          selectImage(nImages); 
          close(); 

/*
 *  run("TurboReg ",
            "-align "
         + "-window " + frame1 + " "// Source (window reference).
         + " 0 0 " + (width - 1) + " " + (height - 1)
         + " -window " + frame2 + " "// Target (window reference).
         + " 0 0 " + (width - 1) + " " + (height - 1)
         + " -translation"
         + " " + (width / 2) + " " + (height / 2)
         + " " + (width / 2) + " " + (height / 2)
         + " -hideOutput"
          );

       sourceX0 = getResult("sourceX", 0); // First line of the table.
       sourceY0 = getResult("sourceY", 0);
       targetX0 = getResult("targetX", 0);
       targetY0 = getResult("targetY", 0);

 */



	
