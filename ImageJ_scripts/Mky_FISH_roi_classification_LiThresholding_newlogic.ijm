   //Returns an array of indexes of ROIs that match  
 //the given regular expression 
 //
 function findRoisWithName(roiName) {
 nR = roiManager("Count");
 roiIdx = newArray(nR); 
k=0;
 clippedIdx = newArray(0);
 for (r=0; r<nR; r++) {
 roiManager("Select", r);
 rName = Roi.getName();
 if (endsWith(rName, roiName) ) {
 roiIdx[k] = r; k++;
 } } 
if (k>0) {
 clippedIdx = Array.trim(roiIdx,k); 
} 
return clippedIdx;
 };

 function countRoisWithName(roiName) {
 nR = roiManager("Count");
 roiIdx = newArray(nR); 
k=0;
 clippedIdx = newArray(0);
 for (r=0; r<nR; r++) {
 roiManager("Select", r);
 rName = Roi.getName();
 if (endsWith(rName, roiName) ) {
 roiIdx[k] = r; k++;
 } } 

return k;
 };
 if (isOpen("Cell counts"))
;
  else {run("Table...", "name=[Cell counts] width=800 height=600");
     print("[Cell counts]", "\\Headings:Group\	Image\	Genes\	Classes\	Counts\	Total\	ClassColor");}

    
run("Set Measurements...", "area integrated area_fraction limit display redirect=None decimal=2");

showMessage("In the next dialog select the file with the RoI set!");
open();
Dialog.create("Experimental group");
       		 Dialog.addMessage("Choose experimental group?");
       		 Dialog.addChoice("Group:", newArray("Control", "Ischemia", "BrdU"));
       		 Dialog.show();
       		 trgroup=Dialog.getChoice();

           Dialog.create("Number of channels");
       		 Dialog.addMessage("Choose number of channels to measure?");
       		 Dialog.addChoice("Number channels:", newArray(2, 3));
       		 Dialog.show();
       		 ChannelNumStr=Dialog.getChoice(); 
			ChannelNum = parseInt(ChannelNumStr);
			
         Dialog.create("Criterion type");
       		 Dialog.addMessage("Choose criterion to identify positive cell?");
       		 Dialog.addChoice("Criteria:", newArray("%Area", "Area"));
       		 Dialog.show();
       		 criterion=Dialog.getChoice(); 
              
              
            geneonename = getString ("What gene/antigen is recorded in the first (green) channel?", "");
       		showMessage("In the next dialog select the "+geneonename+"-image!");
       		open();
       		imagetype= bitDepth();
       		
       		run("Set Scale...", "distance=3.1008 known=1 pixel=1 unit=um global");
       		filename=getTitle();
       		rename(geneonename); 
       		w=getWidth();
            h=getHeight();
			setAutoThreshold("Li dark");
       	
            critsizech1=getNumber("What is the minimum size of the selected measurement that identifies a positive cell in the"+geneonename+"-channel?",2);
            mboundarych1=getNumber("Select the number of scaled units (e.g. mkm) to enlarge nucleus boundary for measurement in the"+geneonename+"-channel?",0);

			newImage("Classified_nuclei_"+filename, "8-bit white",w,h,1);
			
       		genetwoname = getString ("What gene/antigen is recorded in the second (cy3) channel?", "");
       		showMessage("In the next dialog select the "+genetwoname+"-image!");
       		open();
       		
       		setAutoThreshold("Li dark");
       		rename(genetwoname); 
       		        critsizech2=getNumber("What is the minimum size of the selected measurement that identifies a positive cell in the"+genetwoname+"-channel?",2);
            mboundarych2=getNumber("Select the number of scaled units (e.g. mkm) to enlarge nucleus boundary for measurement in the"+genetwoname+"-channel?",0);

       if (ChannelNum == 3) {
       		
       		genethreename = getString ("What gene/antigen is recorded in the third (af647) channel?", "");
       		showMessage("In the next dialog select the "+genethreename+"-image!");
       		open();
       		
       		setAutoThreshold("Li dark");

       		rename(genethreename); 		
       		critsizech3=getNumber("What is the minimum size of the selected measurement that identifies a positive cell in the"+genethreename+"-channel?",2);
            mboundarych3=getNumber("Select the number of scaled units (e.g. mkm) to enlarge nucleus boundary for measurement in the"+genethreename+"-channel?",0);
       		n = roiManager("count");
			total=n;					
								for (j=0; j<n; j++) {
								selectImage(geneonename);
							
								roiManager("select", j);
							run("Enlarge...", "enlarge=&mboundarych1");
								run("Measure");
								a= getResult(criterion);
								if (a<critsizech1) {alabel = "No_"+geneonename;}
									else {alabel = geneonename;};
								
								selectImage(genetwoname);
								roiManager("select", j);
								run("Enlarge...", "enlarge=&mboundarych2");
								run("Measure");
								b= getResult(criterion);
								if (b<critsizech2) {blabel = "No_"+genetwoname;}
									else {blabel = genetwoname;};
								
								selectImage(genethreename);
								roiManager("select", j);
								run("Enlarge...", "enlarge=&mboundarych3");
								run("Measure");
								c= getResult(criterion);
								if (c<critsizech3) {clabel = "No_"+genethreename;}
									else {clabel = genethreename;};
				roiManager("rename", j+":"+alabel+":"+blabel+":"+clabel);
				};
	

 									
 neg = findRoisWithName(":No_"+geneonename+":No_"+genetwoname+":No_"+genethreename);
 g1=findRoisWithName(":"+geneonename+":No_"+genetwoname+":No_"+genethreename);	
 g2=findRoisWithName(":No_"+geneonename+":"+genetwoname+":No_"+genethreename);
 g3=findRoisWithName(":No_"+geneonename+":No_"+genetwoname+":"+genethreename);
 g12=findRoisWithName(":"+geneonename+":"+genetwoname+":No_"+genethreename);
 g13=findRoisWithName(":"+geneonename+":No_"+genetwoname+":"+genethreename);
 g23=findRoisWithName(":No_"+geneonename+":"+genetwoname+":"+genethreename);
 g123=findRoisWithName(":"+geneonename+":"+genetwoname+":"+genethreename);

if (lengthOf(neg)>0 ) { 								
roiManager("select", neg);//draw negative
setForegroundColor(0, 0, 0);
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}


if (lengthOf(g1)>0 ) {
roiManager("select", g1);//draw gene1
setForegroundColor(20, 20, 20); 
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}


if (lengthOf(g2)>0 ) {
roiManager("select", g2);//draw gene2
setForegroundColor(53, 53, 53); 
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}


if (lengthOf(g3)>0 ) {
roiManager("select",g3 );//draw gene3
setForegroundColor(119, 119, 119); //gene3
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}


if (lengthOf(g12)>0 ) {
roiManager("select", g12);//draw gene1&gene2
setForegroundColor(73, 73, 73); //gene1&gene2
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}

if (lengthOf(g13)>0 ) {
roiManager("select",g13 );//draw gene1&gene3
setForegroundColor(139, 139, 139); //gene1&gene3
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}

if (lengthOf(g23)>0 ) {
roiManager("select", g23);//draw gene2&gene3
setForegroundColor(169, 169, 169); //gene2&gene3
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}


if (lengthOf(g123)>0 ) {
roiManager("select", g123);//draw gene1&gene2&gene3
 setForegroundColor(192, 192, 192); //gene1&gene2&gene3
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}




//print ("Group","	","Image","	","negative", "	",geneonename+"-only","	",genetwoname+"-only","	",genethreename+"-only","	",geneonename +" and "+genetwoname,"	",geneonename+" and "+genethreename,"	",genetwoname+" and "+genethreename,"	",geneonename+" and "+genetwoname+" and "+genethreename);
negativecount = countRoisWithName(":No_"+geneonename+":No_"+genetwoname+":No_"+genethreename);
gene1count = countRoisWithName(":"+geneonename+":No_"+genetwoname+":No_"+genethreename);
gene2count = countRoisWithName(":No_"+geneonename+":"+genetwoname+":No_"+genethreename);
gene3count = countRoisWithName(":No_"+geneonename+":No_"+genetwoname+":"+genethreename);
gene1and2count = countRoisWithName(":"+geneonename+":"+genetwoname+":No_"+genethreename);
gene1and3count = countRoisWithName(":"+geneonename+":No_"+genetwoname+":"+genethreename);
gene2and3count = countRoisWithName(":No_"+geneonename+":"+genetwoname+":"+genethreename);
gene1and2and3count = countRoisWithName(":"+geneonename+":"+genetwoname+":"+genethreename);
//print (trgroup,"	",filename,"	",negativecount,"	",gene1count,"	",gene2count,"	",gene3count,"	",gene1and2count,"	",gene1and3count,"	",gene2and3count,"	",gene1and2and3count);
print("[Cell counts]", trgroup+ "	"+filename+"	"+"negative	"+"No_"+geneonename+":No_"+genetwoname+":No_"+genethreename+"	"+negativecount+"	"+total+"	"+ 0);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"	"+geneonename+":No_"+genetwoname+":No_"+genethreename+"	"+gene1count+"	"+total+"	"+ 20);
print("[Cell counts]", trgroup+ "	"+filename+"	"+genetwoname+"	"+"No_"+geneonename+":"+genetwoname+":No_"+genethreename+"	"+gene2count+"	"+total+"	"+ 53);
print("[Cell counts]", trgroup+ "	"+filename+"	"+genethreename+"	"+"No_"+geneonename+":No_"+genetwoname+":"+genethreename+"	"+gene3count+"	"+total+"	"+ 119);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"+"+genetwoname+"	"+geneonename+":"+genetwoname+":No_"+genethreename+"	"+gene1and2count+"	"+total+"	"+ 73);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"+"+genethreename+"	"+geneonename+":No_"+genetwoname+":"+genethreename+"	"+gene1and3count+"	"+total+"	"+ 139);
print("[Cell counts]", trgroup+ "	"+filename+"	"+genetwoname+"+"+genethreename+"	"+"No_"+geneonename+":"+genetwoname+":"+genethreename+"	"+gene2and3count+"	"+total+"	"+ 169);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"+"+genetwoname+"+"+genethreename+"	"+geneonename+":"+genetwoname+":"+genethreename+"	"+gene1and2and3count+"	"+total+"	"+ 192);
    exit ("Classification&Counting finished!");
    };
       			
				n = roiManager("count");
				total=n;
								for (j=0; j<n; j++) {
								selectWindow(geneonename);

								roiManager("select", j);
								run("Enlarge...", "enlarge=&mboundarych1");
								run("Measure");
								a= getResult(criterion);
								if (a<critsizech1) {alabel = "No_"+geneonename;}
									else {alabel = geneonename;};
									
								selectWindow(genetwoname);

								roiManager("select", j);
								run("Enlarge...", "enlarge=&mboundarych2");
								run("Measure");
								b= getResult(criterion);
								if (b<critsizech2) {blabel = "No_"+genetwoname;}
									else {blabel = genetwoname;};

roiManager("rename", j+":"+alabel+":"+blabel);
								};
neg = findRoisWithName(":No_"+geneonename+":No_"+genetwoname);
 g1=findRoisWithName(":"+geneonename+":No_"+genetwoname);	
 g2=findRoisWithName(":No_"+geneonename+":"+genetwoname);
 g12=findRoisWithName(":"+geneonename+":"+genetwoname);
 
if (lengthOf(neg)>0 ) { 						
roiManager("select", neg);//draw negative
setForegroundColor(0, 0, 0); 
selectWindow("Classified_nuclei_"+filename);
roiManager("fill");}

if (lengthOf(g1)>0 ) {
roiManager("select", g1);//draw gene1
setForegroundColor(20, 20, 20); 
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}

if (lengthOf(g2)>0 ) {
roiManager("select", g2);//draw gene2
setForegroundColor(53, 53, 53); 
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}

if (lengthOf(g12)>0 ) {
roiManager("select",g12 );//draw gene1&gene2
setForegroundColor(73, 73, 73); //gene1&gene2
selectWindow("Classified_nuclei_"+filename);
roiManager("Fill");}

//print ("Group","	","Image","	","negative", "	",geneonename+"-only","	",genetwoname+"-only","	",genethreename+"-only","	",geneonename +" and "+genetwoname,"	",geneonename+" and "+genethreename,"	",genetwoname+" and "+genethreename,"	",geneonename+" and "+genetwoname+" and "+genethreename);
negativecount = countRoisWithName(":No_"+geneonename+":No_"+genetwoname);
gene1count = countRoisWithName(":"+geneonename+":No_"+genetwoname);
gene2count = countRoisWithName(":No_"+geneonename+":"+genetwoname);
gene1and2count = countRoisWithName(":"+geneonename+":"+genetwoname);
		
//print (trgroup,"	",filename,"	",negativecount,"	",gene1count,"	",gene2count,"	","NA","	",gene1and2count,"	","NA","	","NA","	","NA");
 print("[Cell counts]", trgroup+ "	"+filename+"	"+"negative	"+"No_"+geneonename+":No_"+genetwoname+"	"+negativecount+"	"+total+"	"+ 0);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"	"+geneonename+":No_"+genetwoname+"	"+gene1count+"	"+total+"	"+ 20);
print("[Cell counts]", trgroup+ "	"+filename+"	"+genetwoname+"	"+"No_"+geneonename+":"+genetwoname+"	"+gene2count+"	"+total+"	"+ 53);
print("[Cell counts]", trgroup+ "	"+filename+"	"+geneonename+"+"+genetwoname+"	"+geneonename+":"+genetwoname+"	"+gene1and2count+"	"+total+"	"+ 73);

 
 exit ("Classification&Counting finished!");
 ///       setBatchMode(true);

  
        
