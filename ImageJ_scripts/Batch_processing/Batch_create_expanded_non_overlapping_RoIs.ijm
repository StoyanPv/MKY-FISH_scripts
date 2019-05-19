//Expand a set of RoIs by 9 pixels and avoiding overlap and fusion pf RoIs
dir1 = getDirectory("Choose a ROI file Directory");
dir2 = getDirectory("Choose a Modified RoIs Directory");
dir3 = getDirectory("Choose an Image Directory ");
list = getFileList(dir1);
listimg= getFileList(dir3);
      print("Original RoI files directory: ",dir1, "\n");
       print("Modified RoIs directory: ", dir2,"\n");
       print("Number of files:", list.length, "\n \n");
       
 for (i=0; i<list.length; i++) {
  	path = dir1+list[i];
    pathimg= dir3+listimg[i];
    showProgress(i, list.length);
    if (!endsWith(path,"/")) open(path);
    if (!endsWith(pathimg,"/")) open(pathimg);
    
    if (nImages>=1) {
    	//Fill RoI do draw masks on image
		imgtitle=getTitle();
    	selectWindow(imgtitle);
    	rename("voronoi");
    	run("Select All");
    	setBackgroundColor(0, 0, 0);
    	run("Clear", "slice");
    	setForegroundColor(255, 255, 255);
		roiManager("Deselect");
		roiManager("Fill");
		setForegroundColor(0, 0, 0);
		roiManager("Draw");
		setForegroundColor(255, 255, 255);
		run("Duplicate...", "title=expanded");
    	//Dilate RoI masks by 9 pixels
		selectWindow("expanded");
    	run("EDM Binary Operations", "iterations=9 operation=dilate");
		// Voronoi transformation of initial RoI masks and find boundaries between masks
		selectWindow("voronoi");
    	run("Voronoi");
    	setThreshold(0, 0);
    	run("Convert to Mask");
    	//Impose detected boundaries on dilated masks
		imageCalculator("AND create", "voronoi","expanded");
       	//Create new RoI set with dilated boundaries
		roiManager("reset");
    	selectWindow("Result of voronoi");
    	run("Analyze Particles...", "clear add");
    	//Save new RoIset
		path2 = dir2+list[i]; 
        roiManager("deselect");
        roiManager("save", path2);
        selectWindow("expanded");
    	close();
    	selectWindow("voronoi");
    	close();
        roiManager("reset");                      
        close();   
    	print("processed RoI set: ", list[i], "\n");
    }
 }
        showMessage("Batch processing finished");     
				
				