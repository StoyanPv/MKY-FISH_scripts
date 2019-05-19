
//Convert image type to 32 bit
bd = bitDepth();
if (bd != 32) {
	run("32-bit");
}

// Run a Z-score transformation on the image pixels, i.e. Subtract the Mean grey value from each pixel and divide by the Standard deviation. This creates standardized image with Mean grey value zero and standard deviation 1. The grey values are expressed in number of standard deviations.
run("Measure");
mean=getResult("Mean");
sd=getResult("StdDev");
run("Macro...", "code=v=(v-"+mean+")/("+sd+")");

//Keep pixels greater or equal to 1 (greater or equal to onestandard deviation) and set all pixels <1 to 0.
setThreshold(1.0000, 3.4e38);
run("NaN Background");
resetThreshold();          
run("16-bit");

// This is the first thresholding step. The next step (Automatic thresholding with Li's Minimum Crossentropy thresholding algorithm) is executed during the counting and classification. 