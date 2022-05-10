# Fis1 structural studies N-term arm scripts
R-scripts &amp; ImageJ macros used in the manuscript "Structural studies of human Fis1 reveals a dynamic region important for Drp1 recruitment and mitochondrial fission"

>*R-scripts for structural studies*:
1. *CS_difference_2_structures.R*
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

