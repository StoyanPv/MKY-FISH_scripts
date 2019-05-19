// SME projection of the z-stack 
initimage = getTitle();
run("SME Stacking", "extract=Channel-RED microscopy=Widefield");
selectWindow(initimage);
close;
selectWindow("SME PROJECTION - WIDE FIELD");
rename("SME_projection_"+initimage);

// Split image into channels, rename and save the channels into separate directories

chDir1 = getDirectory("Choose directory to save the denoised DAPI-channel! ");
chDir2 = getDirectory("Choose directory to save the denoised AF488-channel! ");
chDir3 = getDirectory("Choose directory to save the denoised Cy3-channel! ");
chDir4 = getDirectory("Choose directory to save the denoised AF647-channel! ");
run("16-bit");
run("Split Channels");
 
chnumber= getList("image.titles");
		// The loop goes over the separate channel images, performs Non-local means denoising with automatic estimation of noise sigma. Next it checks their look up tables and renames them  accordingly: Blue to "DAPI", Green to "AF488", Red to "Cy3" and Yellow to "AF647" 
for (c = 0; c < chnumber.length; c++) {
	cn=c+1;
	selectWindow("C"+cn+"-"+id1);
	run("Non-local Means Denoising", "sigma=15 smoothing_factor=1 auto");
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