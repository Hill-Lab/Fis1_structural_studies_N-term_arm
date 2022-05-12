# Fis1 structural studies N-term arm scripts
R-scripts &amp; ImageJ macros used in the manuscript "Structural studies of human Fis1 reveals a dynamic region important for Drp1 recruitment and mitochondrial fission"

**R-scripts for structural studies**:
1. CS_difference_2_structures.R
* Computing chemical shift differences between experimental HEPES & 1PC2

2. hetNOE_analysis.R 
* Data analysis of hetNOE of hFis1 aa1-125 in 1IYG sample conditions

3. MD_calculate_RMSD_RMSF.R
* Plotting RMSD and RMSF values
* experiment = 100-ns 1PC2_121SKY, tr1
* force field = AMBER99SB
* GROMACS

4. MD_equilibration_checkpoint.R
* Plotting equilibration checkpoints of calculated energy potential, 
* temperature, pressure, and density of system for
* experiment = 100-ns 1PC2_121SKY, tr1
* force field = AMBER99SB
* GROMACS

5. MD_sparta_prediction_analysis
* Chemical shift predictions (Sparta+) of MD simulations
* experiment = 100-ns 1IYG_121SKY, tr1
* force field = AMBER99SB
* MD simulation time = 100 ns
* GROMACS

6. Talos_predication_analysis.R
* Comparing ramachandran angles of hFis1 from experimental HEPES condition against NMR solution structures of N-arm in (1IYG) and out (1PC2)
* mouse_ref = 1IYG = N-arm in
* human_ref = 1PC2 = N-arm out

7. TRP_fluorescence.R
* TRP fluorescence of nativeN- and dN- hFis1
* [nativeN- or dN-hFis1] = 10 µM
* Low Salt Buffer: 50 mM HEPES pH 7.4, 0.2 M NaCl
* High Salt Buffer: 50 mM HEPES pH 7.4, 2 M NaCl
* TRP excitation = 295 nm
* emission = 300 - 400nm
* excitation slit width (nm) = 4, 4
* emission slit width (nm) = 6, 6

**ImageJ Macro scripts for cell studies (mitochondrial morphology & colocalization analysis):**

**see <a href="https://github.com/Hill-Lab/MitoGraph-Contrib-RScripts">MitoGraph R-scripts</a>, <a href="https://github.com/vianamp/MitoGraph">MitoGraph v3.0</a> and our previously published paper <a href="https://www.sciencedirect.com/science/article/pii/S0003269718301921?via%3Dihub">"Methods for imaging mammalian mitochondrial morphology: A prospective on MitoGraph"</a> for more information on MitoGraph Analysis** 
1. splitchannel_4.ijm
* ImageJ macro that takes a .ND2 file, opens it and splits it into 4 individual channel folers
2. GenFramesMaxProjs_3channel.ijm
* ImageJ macro that creates maximum intensity z projection images from all images in a specific folder and creates a single stack of those images
3. CropCells_1500_ROI_no_noise_3channel.ijm
* ImageJ macro that uses ROIs traced on the MaxProjs.tif stack and single cell cropped TIFF files
4. Coloc2_batch_ch2vsch3.ijm
* Imagee macro that uses single cell cropped TIFF files for colocalization analysis using the Coloc2 module on ImageJ. 
5. megan-directory-split-join
* command envoked on terminal to split a large data set into identically sized folders to make downstream analysis quicker

