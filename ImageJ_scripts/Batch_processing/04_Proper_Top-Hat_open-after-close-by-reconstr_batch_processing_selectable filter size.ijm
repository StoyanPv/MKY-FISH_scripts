//Batch Processor

// ***Select macro(s) used here ***
// Just replace "bmp" by "jpeg" or any other standard image file format here
//to select output type of your filtered image

macro "Batch Convert to TIFF" {convert("tif");}

//Function Batch processing
 function convert(format) {
     requires("1.34m");

// *** General Settings ***


// Close log window if open
       if (isOpen("Log")) {
        selectWindow("Log");
        run("Close");
       }

//Variables
       var abort,dir1,dir2,dir3,rad,list;

// Instruction
       showMessage("Instruction", "Choose source diretory containing source-files \nand destination directories for Filtered IMAGE. \n \nBrougt to you 2007 by porifera.net\n \n");

// ### Input your values for specific functions here ###

// ### End Input specific functions ###


// Choose directories
     dir1 = getDirectory("Choose source image directory ");
     dir2 = getDirectory("Choose FILTERED IMAGE destination directory ");
     list = getFileList(dir1);
	b = getNumber("Filter radius:", 1);	
	sc=getNumber("Scaling factor (Micrometer/px):",0.3225);
	
// Protocol start
       print("ImageJ macro 'Batch_Processor' by porifera.net \n \n");
       print("initial file source directory: ",dir1, "\n");
       print("filtered file destination directory: ", dir2,"\n");
       print("Number of files:", list.length, "\n \n");

// Batch processing
     setBatchMode(true);
     count = 0;
               countFiles(dir1);
               n = 0;
               processFiles(dir1);

     function countFiles(dir1) {
       list = getFileList(dir1);
       for (i=0; i<list.length; i++) {
         if (endsWith(list[i], "/"))
             countFiles(""+dir1+list[i]);
         else
             count++;
       }
               }



  function processFiles(dir1) {
     list = getFileList(dir1);
     for (i=0; i<list.length; i++) {
         if (endsWith(list[i], "/"))
             processFiles(""+dir1+list[i]);
         else {
            showProgress(n++, count);
            path = dir1+list[i];
            processFile(path);
               }
               }
       }

 function processFile(path) {
      if (endsWith(path, "")) {
          open(path);
          initimage = getTitle();

	//b = getNumber("Filter radius:", 1);	


// *** Insertion specific operations ***
run("Set Scale...", "distance=1 known=&sc unit=um");
resetMinAndMax();
	bd=bitDepth();
		if (bd == 32) {
		run("16-bit");
	}
	rename("1");
	selectWindow("1");
	//run("Median...", "radius=2");
	//run("8-bit");
	run("Morphological Filters", "operation=Dilation element=Disk radius="+b);
	selectWindow("1-Dilation");
	run("Morphological Reconstruction", "marker=1-Dilation mask=1 type=[By Erosion] connectivity=8");
	selectWindow("1-Dilation-rec");
	run("Morphological Filters", "operation=Erosion element=Disk radius="+b);
	selectWindow("1-Dilation-rec-Erosion");
	run("Morphological Reconstruction", "marker=1-Dilation-rec-Erosion mask=1-Dilation-rec type=[By Dilation] connectivity=8");
	imageCalculator("Subtract create", "1","1-Dilation-rec-Erosion-rec");

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
	rename(initimage);
  	//run("Set Measurements...", "  mean min redirect=None decimal=9");
	//run("Measure");
	//ma=getResult("Max");
	//getRawStatistics(max);
//	setThreshold(1, max);
	//run("NaN Background");
	//run("16-bit");
	//run("Median...", "radius=2");
      



// *** End Insertion specific operations ***



// Save and close images

       // Safe and close FILTERED IMAGE
         selectWindow(initimage);
         saveAs(format, dir2+"T-H_Op_by_rec_after_Cl_r"+b+"_"+list[i]);
         close();


//Print progress report
print("processed file ", list[i]);

     }
 }

//Final message progress report
print("successfully processed ", list.length, " files");
showMessage("Batch processing finished");

 }


macro "Abort" {
      abort = true;
}


