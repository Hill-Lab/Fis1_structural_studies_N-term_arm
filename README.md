# Fis1 structural studies N-term arm scripts
R-scripts &amp; ImageJ macros used in the submitted manuscript "Structural studies of human Fis1 reveals a dynamic region important for Drp1 recruitment and mitochondrial fission"

# **R-scripts for structural studies**:
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

# ImageJ Macro scripts for cell studies 
> Mitochondrial Morphology & Colocalization Analysis:

> For more information on MitoGraph Analysis see:
* <a href="https://github.com/Hill-Lab/MitoGraph-Contrib-RScripts">MitoGraph R-scripts</a>
* <a href="https://github.com/vianamp/MitoGraph">MitoGraph v3.0</a> & 
* our previously published paper <a href="https://www.sciencedirect.com/science/article/pii/S0003269718301921?via%3Dihub">"Methods for imaging mammalian mitochondrial morphology: A prospective on MitoGraph"</a> 
>We prepared single cell, single channel TIFF images to be used for MitoGraph or Colocalization analysis using the following ImageJ macros: 
1. ImageJ macro that takes a Nikon .ND2 file, opens it, splits it into individual channels and saves as all z-slice TIFF images in individual channel folders (<a href="https://github.com/Hill-Lab/Fis1_structural_studies_N-term_arm/blob/main/splitchannel_4.ijm">**splitchannel_4.ijm**</a>) 

2. ImageJ macro that takes the single channel TIFF images created above and creates a single stack of maximum intensity z-projection images of the entire dataset (<a href="https://github.com/Hill-Lab/Fis1_structural_studies_N-term_arm/blob/main/GenFramesMaxProjs_3channel.ijm">**GenFramesMaxProjs_3channel.ijm**</a>)

3. Cellular ROIs are hand traced in ImageJ and then the crop macro uses these ROIs, the MaxProj file from **#2** and the single channel TIFF images created in **#1** to create single cell, single channel all z slices TIFF image that can be uploaded for MitoGraph analysis or processed with ImageJ for Coloc2 analysis (<a href="https://github.com/Hill-Lab/Fis1_structural_studies_N-term_arm/blob/main/CropCells_1500_ROI_no_noise_3channel.ijm">**CropCells_1500_ROI_no_noise_3channel.ijm**</a>)

4. Single cell/single channel TIFF images were processed for colocalization using the ROIs generated in step 3. Both all z-slices and maxIP projections were used for the analysis (**Coloc2_batch_ch2vsch3.ijm**)

5. Short command program envoked on terminal to split a large data set into identically sized folders to make downstream upload to our cluster for analysis and to allow for parallel MitoGraph processing. The file is placed into the same folder as the images and run using the following terminal command: ./megan-directory-split-join dN_mitoYFP 25 where the base folder name is first specified followed by how many images in each folder  (**megan-directory-split-join**)

6. Upload and submit all folders with the single cell/single channel all-z slices mitochondrial images to our cluster for analysis using the commands found in this text file (**mitographrundNmitoYFP1_1.txt**).

7. Download resulting MitoGraph files and process with the following R-script that takes .GNET files containing numbered node-node distances and computes a variety of metrics. Note this script differs slights from that originally published in the sources above in that is also calculate, reports and plots the small/repeating noisy pixels/voxels and reports a freqeuency table to help extract those from the dataset (**CreateSummary_width_graph_output.R**). That frequency table is then used to select an ideal cut off point to remove the repeating pixels and then a very similar R script was run to remove the small/highly repetative connected components from the dataset (**CreateSummary_width_graph_output_filtered.R**). 

8. Using the output summary file generated from the **CreateSummary_width_graph_output_filtered.R** boxplots were created by running an additional R-script (**MitoGraph_simplified_width_filtered.R**). See **MitoGraph_simplified_width_filtered.html** for the compiled output for mitoYFP dataset and **MitoGraph_simplified_width_filtered_YFP-TBC_dataset.html** for the compiled output for the YFP-TBC1D15 dataset. 

9. Create graph of Coloc2 results generated using **Coloc2_batch_ch2vsch3.ijm** by running **ImageJ_Pearsons_coeff.R**. See **ImageJ_Pearsons_coeff_Drp1vMito_allz.html** for the compiled output of the mitoYFP/Drp1 coloc2 dataset. 
