// Macro create to split .ND2 images into individual channel folders

_RootFolder = getDirectory("Choose a Directory");
//_RootFolder = "/Users/mcleland/mount/home/stor2/depts/biochemistry/hill_lab/mcharwig/Images/Nikon_W1_images/20200904_HcAEC_pep213/replicate1_1hr/";

// Creating a directory where the files are saved
outputfolder1 = _RootFolder + "/channel1";
File.makeDirectory(outputfolder1);
outputfolder2 = _RootFolder + "/channel2";
File.makeDirectory(outputfolder2);
outputfolder3 = _RootFolder + "/channel3";
File.makeDirectory(outputfolder3);
outputfolder4 = _RootFolder + "/channel4";
File.makeDirectory(outputfolder4);



setBatchMode(true);

list_of_files = getFileList(_RootFolder);

for (i = 0; i < list_of_files.length; i++) {
filename = list_of_files[i];
if (endsWith(filename, ".nd2")) {
run("Bio-Formats Importer", "open=" + _RootFolder + filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Split Channels"); 
               selectWindow("C1-"+filename); 
               save(_RootFolder + "/channel1/" + replace(filename,".nd2",".tif"));
               close(); 
               selectWindow("C2-"+filename); 
               save(_RootFolder + "/channel2/" + replace(filename,".nd2",".tif"));
               close(); 
               selectWindow("C3-"+filename); 
               save(_RootFolder + "/channel3/" + replace(filename,".nd2",".tif"));
               close(); 
               selectWindow("C4-"+filename); 
               save(_RootFolder + "/channel4/" + replace(filename,".nd2",".tif"));
               close(); 
               write("Conversion Complete"); 
       
}
}