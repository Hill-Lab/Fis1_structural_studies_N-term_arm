//Coloc 2 macro that runs on two single channel/single cell TIFF images

_RootFolder = getDirectory("Choose a Directory");

// Creating a directory where the files are saved
//MAKE SURE TO ADJUST IMAGE SIZE TO THE CANVAS SIZE YOU CROPPED YOUR IMAGES TOO!!!

outputfolder = _RootFolder + "/coloc2_output";
File.makeDirectory(outputfolder);

outputfolderROIs = _RootFolder + "/coloc2_output/ROIs";
File.makeDirectory(outputfolderROIs);


setBatchMode(true);

list = getFileList( _RootFolder + "/channel2/cells/" ); 
for ( i=0; i<list.length; i++ ) { 

    //create image ID
    fileName = list[i]; 
    imageName = replace(fileName,"\\.tif$", "");

	//open channel 2
	open(_RootFolder + "/channel2/cells/" + imageName + ".tif");
	run("Z Project...", "projection=[Max Intensity]");
	saveAs("Tiff", _RootFolder + "/channel2/" + "channel2.tif");

	//open channel 3
	open(_RootFolder + "/channel3/cells/" + imageName + ".tif"); 
	run("Z Project...", "projection=[Max Intensity]");
	saveAs("Tiff", _RootFolder + "/channel3/" + "channel3.tif");

	//open ROI
	run("ROI Manager...");
	roiManager("Reset");
	roiManager("Associate", "false");
	roiManager("Centered", "false");
	roiManager("UseNames", "true");
	roiManager("Open",_RootFolder + "/channel2/ROIs/" + imageName + ".roi");
	roiManager("Select", 0);
	roiManager("List")

	//Adjust location of ROI to center of image
	Roi.getBounds(x, y, width, height);	
	// saveAs("Text", outputfolder + "/" + imageName + "ROIcoord.txt");
	Roi.move((1500 - width) / 2, (1500 - height) / 2); //ADJUST first number to total size of cropped image

	//Add new ROI and delete old ROI
	roiManager("Add");
	roiManager("List")
	roiManager("Select", 1);
	roiManager("Save selected", _RootFolder + "/coloc2_output/ROIs/" + imageName + ".roi");
	roiManager("Select", 0);
	roiManager("Delete");
	roiManager("List")

	//Run Coloc 2 and reset 
	run("Coloc 2", "channel_1=channel2.tif channel_2=channel3.tif roi_or_mask=[ROI Manager] threshold_regression=Bisection psf=3 costes_randomisations=10");
	selectWindow("Log");
	saveAs("Text", outputfolder + "/" + imageName + ".txt");
	selectWindow("Log");
	print("\\Clear");
	run("AutoClickerJ GUI 1.0.7", "order=LeftClick x_point=8 y_point=155 delay=100 clickandkeywrite=[]");
	run("AutoClickerJ GUI 1.0.7", "order=LeftClick x_point=13 y_point=34 delay=100 clickandkeywrite=[]");
	
	run("Close All");	
}
