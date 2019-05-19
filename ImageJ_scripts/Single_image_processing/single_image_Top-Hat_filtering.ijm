initimage = getTitle();
b = getNumber("Filter radius:", 1); // Selection of the size of the closing, correspondingly opening-disk. In the analyzed set of images we used 11 px radius for the channels representing Intracellular antigen or mRNA FISH signals, and 13 px for the DAPI-channels and Nuclear antigen channels.

resetMinAndMax();
bd=bitDepth();
	if (bd == 32) {
	run("16-bit");
	}
rename("1");
selectWindow("1");
	//Closing by reconstruction to reduce dark variability which may be source of artefacts
 run("Morphological Filters", "operation=Dilation element=Disk radius="+b); //Maximum filter with a disk of size "b"
selectWindow("1-Dilation");
run("Morphological Reconstruction", "marker=1-Dilation mask=1 type=[By Erosion] connectivity=8"); //Morphological reconstruction by erosion results in an image with holes and dark spots smaller than the filter radius removed.
selectWindow("1-Dilation-rec");
run("Morphological Filters", "operation=Erosion element=Disk radius="+b); //Minimum filter with a disk of size "b" 
selectWindow("1-Dilation-rec-Erosion");
run("Morphological Reconstruction", "marker=1-Dilation-rec-Erosion mask=1-Dilation-rec type=[By Dilation] connectivity=8");//Morphological reconstruction by dilation. Creates an image in which all bright objects with radius smaller than the filter radius are removed. I.e. estimated backgraound for removal.

imageCalculator("Subtract create", "1","1-Dilation-rec-Erosion-rec"); //"Top" minus "Hat"operation: We subtract the opened image from the closed image

selectWindow("1-Dilation-rec-Erosion-rec");
close();
selectWindow("1-Dilation-rec");
close();
selectWindow("1-Dilation");
close();
selectWindow("1");
close();
selectWindow("1-Dilation-rec-Erosion");
close();

selectWindow("Result of 1");
rename("T-H_Op_by_rec_after_Cl_r"+b+"_"+initimage);