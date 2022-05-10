// Matheus Viana - vianamp@gmail.com - 7.29.2013
// ==========================================================================

// This macro must be used to generate a stack of max projection from a set
// of microscope frames. In general, the max projection stack is then used
// to drawn ROIs around the cells that are going to be further analyzed.
// Macro repeats 3 times for 3 channel images (edit by Megan Harwig) 

// Selecting the folder that contains the TIFF frame files

_RootFolder = getDirectory("Choose a Directory");

item = 0;
ntiff = 0;
_List = getFileList(_RootFolder + "/channel1/");
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		if (ntiff==0) {
			open(_RootFolder + "/channel1/" + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + "/channel1/" + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/channel1/" + "MaxProjs.tif");



// CHANNEL 2 MAXPROJS ==========================================================================


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder + "/channel2/");
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		if (ntiff==0) {
			open(_RootFolder + "/channel2/" + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + "/channel2/" + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/channel2/" + "MaxProjs.tif");

// CHANNEL 3 MAXPROJS ==========================================================================


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder + "/channel3/");
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		if (ntiff==0) {
			open(_RootFolder + "/channel3/" + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + "/channel3/" + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/channel3/" + "MaxProjs.tif");

// CHANNEL 4 MAXPROJS ==========================================================================


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder + "/channel4/");
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		if (ntiff==0) {
			open(_RootFolder + "/channel4/" + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + "/channel4/" + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/channel4/" + "MaxProjs.tif");

