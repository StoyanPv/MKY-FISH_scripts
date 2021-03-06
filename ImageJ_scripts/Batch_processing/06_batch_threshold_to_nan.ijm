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
//	b = getNumber("Filter radius in lateral direction (x and y-axis):", 3.75);	
//	zr = getNumber("Filter radius in axial direction (z-axis):", 1.82);
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



// *** Insertion specific operations ***
	
	setThreshold(1.0000, 3.4e38);
	run("NaN Background");
    resetThreshold();          
	run("16-bit");


// *** End Insertion specific operations ***



// Save and close images

       // Safe and close FILTERED IMAGE
         selectWindow(initimage);
         saveAs(format, dir2+"Thr_above_Z1_"+list[i]);
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


