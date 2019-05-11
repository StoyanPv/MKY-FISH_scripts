
inputDir = getDirectory("Choose composite image directory! ");
chDir1 = getDirectory("Choose directory to save ch1! ");
chDir2 = getDirectory("Choose directory to save ch2! ");
chDir3 = getDirectory("Choose directory to save ch3! ");
chDir4 = getDirectory("Choose directory to save ch4! ");

fileList1 = getFileList(inputDir);

setBatchMode(true);
for (i = 0; i < fileList1.length; i++) {
   showProgress(i, fileList1.length);
   file1 = fileList1[i];
   open(inputDir+file1);
  id1 = getTitle();
run("16-bit");
 run("Split Channels");
 
 chnumber= getList("image.titles");
for (c = 0; c < chnumber.length; c++) {
	cn=c+1;
	selectWindow("C"+cn+"-"+id1);
 getLut(reds, greens, blues);
 if (blues[254] == 254) {
 	rename("DAPI_"+id1);
 	idch1 = getTitle();
 	saveAs("Tiff", chDir1 + "/" + idch1);} 
 	else if (reds[254] == 254) { 
 			if (greens[254] == 254) {
 				rename("AF647_"+id1);
 				idch4 = getTitle();
 				saveAs("Tiff", chDir4 + "/" + idch4);} 
 				else {rename("CY3_"+id1);
 				idch3 = getTitle();
 				saveAs("Tiff", chDir3 + "/" + idch3);}
 			} 
 			else {rename ("FITC_"+id1);
 			idch2 = getTitle();
			saveAs("Tiff", chDir2 + "/" + idch2);}
}
 			

run("Close All");
}
showMessage("Finished splitting channels!"); 
