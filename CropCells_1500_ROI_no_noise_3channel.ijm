// Created by Matheus Viana - vianamp@gmail.com - 7.29.2013
// Modified by Megan C Harwig - mcharwig@mcw.edu 
// ==========================================================================

// This macro is used to crop cells from microscope frames that in general contains
// more than one cell.
// 1. Use the macro GenFramesMaxProjs.ijm to generate the file MaxProjs.tiff
// 2. Use the stack MaxProjs.tiff to drawn ROIs around the cells that must be
//    analysed.
// 3. Save the ROIs as RoiSet.zip
// 4. This version of the macro sequentially runs on 3 channels

// Selecting the folder that contains the TIFF frame files plus the RoiSet.zip and
// MaxProjs.tiff files.

// Defining the size of the singl cell images:
_xy = 1500; //change to crop size if trying to make montage

_RootFolder = getDirectory("Choose a Directory");

// Creating a directory where the files are saved
File.makeDirectory(_RootFolder + "/channel1/" + "cells");
File.makeDirectory(_RootFolder + "/channel1/" + "ROIs");

setBatchMode(true);
// Prevent generation of 32bit images
run("RandomJ Options", "  adopt progress");

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "/channel1/" + "RoiSet.zip");

open(_RootFolder + "/channel1/" + "MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)

for (roi = 0; roi < roiManager("count"); roi++) {		
	
	roiManager("Select",roi);
	_FileName = getInfo("slice.label");
	_FileName = replace(_FileName,".tif","@");
	_FileName = split(_FileName,"@");
	_FileName = _FileName[0];
	roiManager("Save", _RootFolder + "/channel1/" + "ROIs/" + _FileName + "_" + IJ.pad(roi,3) + ".roi");


	open(_RootFolder + "/channel1/" + _FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution around the ROI
	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Make Band...", "band=5");
		getStatistics(area, mean, min, max, std);
		run("Restore Selection");
		run("Copy");
		
		selectImage(CELL);
		setSlice(s);
		run("Select None");		
		run("Add...", "value=" + min + " slice");
		// run("Add Specified Noise...", "slice standard=" + 0.5*std);
		run("Paste");
		
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
		
	}
	
	run("Select None");
	resetMinAndMax();

	save(_RootFolder + "/channel1/" + "cells/" + _FileName + "_" + IJ.pad(roi,3) + ".tif");

	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

setBatchMode(false);

run("Close All");

// Channel 2 ----------------------------------------------
//=========================================================

// Creating a directory where the files are saved
File.makeDirectory(_RootFolder + "/channel2/" + "cells");
File.makeDirectory(_RootFolder + "/channel2/" + "ROIs");

setBatchMode(true);
// Prevent generation of 32bit images
run("RandomJ Options", "  adopt progress");

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "/channel2/" + "RoiSet.zip");

open(_RootFolder + "/channel2/" + "MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)

for (roi = 0; roi < roiManager("count"); roi++) {		
	
	roiManager("Select",roi);
	_FileName = getInfo("slice.label");
	_FileName = replace(_FileName,".tif","@");
	_FileName = split(_FileName,"@");
	_FileName = _FileName[0];
	roiManager("Save", _RootFolder + "/channel2/" + "ROIs/" + _FileName + "_" + IJ.pad(roi,3) + ".roi");


	open(_RootFolder + "/channel2/" + _FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution around the ROI
	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Make Band...", "band=5");
		getStatistics(area, mean, min, max, std);
		run("Restore Selection");
		run("Copy");
		
		selectImage(CELL);
		setSlice(s);
		run("Select None");		
		run("Add...", "value=" + min + " slice");
		// run("Add Specified Noise...", "slice standard=" + 0.5*std);
		run("Paste");
		
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
		
	}
	
	run("Select None");
	resetMinAndMax();

	save(_RootFolder + "/channel2/" + "cells/" + _FileName + "_" + IJ.pad(roi,3) + ".tif");

	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

setBatchMode(false);

run("Close All");


// Channel 3 ----------------------------------------------
//=========================================================

// Creating a directory where the files are saved
File.makeDirectory(_RootFolder + "/channel3/" + "cells");
File.makeDirectory(_RootFolder + "/channel3/" + "ROIs");

setBatchMode(true);
// Prevent generation of 32bit images
run("RandomJ Options", "  adopt progress");

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "/channel3/" + "RoiSet.zip");

open(_RootFolder + "/channel3/" + "MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)

for (roi = 0; roi < roiManager("count"); roi++) {		
	
	roiManager("Select",roi);
	_FileName = getInfo("slice.label");
	_FileName = replace(_FileName,".tif","@");
	_FileName = split(_FileName,"@");
	_FileName = _FileName[0];
	roiManager("Save", _RootFolder + "/channel3/" + "ROIs/" + _FileName + "_" + IJ.pad(roi,3) + ".roi");


	open(_RootFolder + "/channel3/" + _FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution around the ROI
	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Make Band...", "band=5");
		getStatistics(area, mean, min, max, std);
		run("Restore Selection");
		run("Copy");
		
		selectImage(CELL);
		setSlice(s);
		run("Select None");		
		run("Add...", "value=" + min + " slice");
		// run("Add Specified Noise...", "slice standard=" + 0.5*std);
		run("Paste");
		
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
		
	}
	
	run("Select None");
	resetMinAndMax();

	save(_RootFolder + "/channel3/" + "cells/" + _FileName + "_" + IJ.pad(roi,3) + ".tif");

	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

setBatchMode(false);

run("Close All");

// Channel 4 ----------------------------------------------
//=========================================================

// Creating a directory where the files are saved
File.makeDirectory(_RootFolder + "/channel4/" + "cells");
File.makeDirectory(_RootFolder + "/channel4/" + "ROIs");

setBatchMode(true);
// Prevent generation of 32bit images
run("RandomJ Options", "  adopt progress");

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "/channel4/" + "RoiSet.zip");

open(_RootFolder + "/channel4/" + "MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)

for (roi = 0; roi < roiManager("count"); roi++) {		
	
	roiManager("Select",roi);
	_FileName = getInfo("slice.label");
	_FileName = replace(_FileName,".tif","@");
	_FileName = split(_FileName,"@");
	_FileName = _FileName[0];
	roiManager("Save", _RootFolder + "/channel4/" + "ROIs/" + _FileName + "_" + IJ.pad(roi,3) + ".roi");


	open(_RootFolder + "/channel4/" + _FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution around the ROI
	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Make Band...", "band=5");
		getStatistics(area, mean, min, max, std);
		run("Restore Selection");
		run("Copy");
		
		selectImage(CELL);
		setSlice(s);
		run("Select None");		
		run("Add...", "value=" + min + " slice");
		// run("Add Specified Noise...", "slice standard=" + 0.5*std);
		run("Paste");
		
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
		
	}
	
	run("Select None");
	resetMinAndMax();

	save(_RootFolder + "/channel4/" + "cells/" + _FileName + "_" + IJ.pad(roi,3) + ".tif");

	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

setBatchMode(false);

run("Close All");
