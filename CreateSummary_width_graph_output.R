# R-script to extract information from MitoGraph .gnet files that contains numbered node to node distances
# Modified from the original MitoGraph scripts to add information on the width and frequency of connected components
# M. Viana wrote the initial script M.C.Harwig edited the script and created this current form. 

library(igraph)
library(tidyverse)
library(reshape2)
library(stringr)
library(formattable)
library(data.table)
library(dplyr)

#
# Specify the folder with the gnet files
#
# Save this script in the GNET folder you want to analyze
# 
# Set working directory to source file location (session -> set working directory -> to source file location)
# 
# Run with Command+Option+r

###
GnetsFolder <- "~/Desktop/W1/20210903_Ntermtrun_repeat4/mitoYFP_DrpIF/addmore_drp1/channel2/cells"

RawData <- NULL
Summary <- NULL

Gnets <- list.files(path = GnetsFolder, pattern = "\\.txt$", ignore.case = TRUE, full.names = TRUE)
Gnets2 <- list.files(path = GnetsFolder, pattern = "\\.gnet$", ignore.case = TRUE, full.names = TRUE)

Gnets <- list.files(path = GnetsFolder, pattern = "\\.txt$", ignore.case = TRUE, full.names = TRUE)
for (j in Gnets) {
  NameNoExtension = gsub(".txt", "", j)
  # Raw Data
  RawDataInst <- read.table(j, sep="\t", skip=1, col.names=c('line_id', 'point_id', 'x', 'y', 'z', 'width_um', 'pixel_intensity'))
  
  # Calculate mean grouped by line_id
  RawDataInst <- RawDataInst %>%
    group_by(line_id) %>%
    summarise(Width_um_avg = mean(width_um))
  
  # Select file to import for GNET portion, change to data frame and unite to the full path name
  selected_files_to_import <- paste(c(NameNoExtension,".gnet"))
  selected_files_to_import <- as.data.frame(selected_files_to_import)
  selected_files_to_import <- transpose(selected_files_to_import)
  FileName <- unite(selected_files_to_import, file, c(V1, V2), sep = "")
  
  list_of_data_frame <- lapply(FileName, 
                               function(i){read.table(i, sep="\t", skip=1, col.names=c('Source','Target','Length'))})
  
  RawDataInst2 <- bind_rows(list_of_data_frame)
  
  RawDataMerge <- cbind(RawDataInst2, RawDataInst)
  
  merged_graph <- graph.data.frame(as.data.frame(RawDataMerge, directed = F))
  
  RawDataInst3 <- NULL
  List <- decompose(merged_graph)
  for (g in List) {
    RawDataInst3 <- rbind(RawDataInst3, data.frame(FileName, vcount(g), ecount(g), mean(E(g)$Width_um_avg)))
  }
  
  RawDataInst4 <- NULL
  List <- decompose(merged_graph)
  for (g in List) {
    RawDataInst4 <- rbind(RawDataInst4, data.frame(FileName, vcount(g), ecount(g), sum(E(g)$Length)))
  }
  RawDataInst5 <- cbind(RawDataInst3,RawDataInst4)
  RawDataInst5 <- RawDataInst5[, !duplicated(colnames(RawDataInst5))]
  
  # Readable column names for RawData
  colnames(RawDataInst5) <- c('FileName', 'Nodes', 'Edges','Width', 'Length')
  
  # Sort components by size
  RawDataInst5 <- RawDataInst5[order(RawDataInst5$Length, decreasing=T),]
  
  # Summary Calculations of mito volume, nodes, edges and connected components
  TotalNodes <- vcount(merged_graph)
  TotalEdges <- ecount(merged_graph)
  TotalLength <- sum(E(merged_graph)$Length)
  MeanWidth <- mean(E(merged_graph)$Width_um_avg)
  
  ConnectedComponents = length(List)
  
  # PHI (Length of largest connected component / total length of connected components)
  PHI = max(RawDataInst5$Length) / TotalLength
  
  # Average Edge Length (Total length of connected components / total edge #)
  AvgEdgeLength = TotalLength / TotalEdges
  
  # Total Edge Normalized to Total Length
  TotalEdgeNorm = TotalEdges / TotalLength
  
  # Total Node Normalized to Total Length
  TotalNodeNorm = TotalNodes / TotalLength
  
  # Total Connected Components Normalized to Total Length
  TotalCCNorm = ConnectedComponents / TotalLength
  
  # Display the degree distirbution of the graph. I mean, the k-th element of the array
  # Pk gives the proportion of nodes with (k-1)-neighbours. Therefore, if you want the
  # proportion of free-ends in the graph, look at the 2nd element: Pk[2]. 
  
  Pk <- degree.distribution(merged_graph)
  FreeEnds = ifelse(is.na(Pk[2]), 0, Pk[2])
  ThreeWayJunct = ifelse(is.na(Pk[4]), 0, Pk[4])
  FourWayJunct = ifelse(is.na(Pk[5]), 0, Pk[5])
  
  # AVG Degree = sum_k (k * Pk) 
  AvgDegree = (FreeEnds * 1) + (ThreeWayJunct * 3) + (FourWayJunct * 4)
  
  # MitoGraph Connectivity Score
  MitoGraphCS = (PHI + AvgEdgeLength + AvgDegree) / (TotalNodeNorm + TotalEdgeNorm + TotalCCNorm)
  
  # Combine all columns
  SummaryInst = data.frame(
    "File_Name" = FileName,
    "Total_Nodes" = TotalNodes,
    "Total_Edges" = TotalEdges,
    "Total_Length_um"= TotalLength,
    "Total_Connected_Components" = ConnectedComponents,
    "PHI" = PHI,
    "Avg_Edge_Length_um" = AvgEdgeLength,
    "Total_Edge_Norm_to_Length_um" = TotalEdgeNorm,
    "Total_Node_Norm_to_Length_um" = TotalNodeNorm,
    "Total_Connected_Components_Norm_to_Length_um" = TotalCCNorm,
    "Free_Ends" = FreeEnds,
    "three_way_junction" = ThreeWayJunct,
    "four_way_junction" = FourWayJunct,
    "Avg_Degree" = AvgDegree,
    "MitoGraph_Connectivity_Score" = MitoGraphCS,
    "Average_width_um" = MeanWidth
  )
  
  RawData <- rbind(RawData, RawDataInst5)
  Summary <- rbind(Summary, SummaryInst)
  
}

Output <- paste(GnetsFolder,"/output.csv",sep='')
OutputSummary <- paste(GnetsFolder,"/output-summary.csv",sep='')

write.csv(RawData,file=Output, row.names = FALSE)  
write.csv(Summary,file=OutputSummary, row.names= FALSE)  

##
## graph output 
##

Summary_output <- read_csv("output.csv") 

Summary_output %>%
  ggplot(aes(x = Width, color = Length)) +
  geom_histogram(binwidth = 0.001) +
  #stat_bin (binwidth=.001, geom='text', aes(label=..count..), position=position_stack(vjust = 0.5)) +
  #geom_density(alpha=0.6) +
  #geom_vline(aes(xintercept=mean(Nodes), color=strain), linetype="dashed", size=1) +
  #xlim(0, 1.5) +
  #ylim(0, .001) +
  #scale_x_log10() +
  #scale_y_log10() +
  #facet_grid(strain ~ .) +
  labs(title = "Histogram Analysis of GNETs",
       x = "Width Connected Component",
       y = "Count") +
  theme(axis.text.x = element_text(size = 12, color = "black"),
        axis.text.y = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        legend.position = "right",
        legend.text = element_text(size = 12, color = "black")
  )

ggsave(paste("Histogram_W.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)


Summary_output %>%
  ggplot(aes(x = Length, color = Width)) +
  geom_histogram(binwidth = .001) +
  #stat_bin (binwidth=.001, geom='text', aes(label=..count..), position=position_stack(vjust = 0.5)) +
  #geom_density(alpha=0.6) +
  #geom_vline(aes(xintercept=mean(Nodes), color=strain), linetype="dashed", size=1) +
  xlim(0, 1.5) +
  #ylim(0, .001) +
  #scale_x_log10() +
  #scale_y_log10() +
  #facet_grid(strain ~ .) +
  labs(title = "Histogram Analysis of GNETs",
       x = "Length Connected Component",
       y = "Count") +
  theme(axis.text.x = element_text(size = 12, color = "black"),
        axis.text.y = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        legend.position = "right",
        legend.text = element_text(size = 12, color = "black")
  )

ggsave(paste("Histogram_L.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)


Summary_output%>%
  ggplot(aes(x = Length, y = Width, color = Nodes)) +
  geom_point(size=1) +
  xlim(0,1.1) +
  #ylim(0, .001) +
  #scale_x_log10() +
  #scale_y_log10() +
  labs(title = "Analysis of GNETs",
       x = "Length Connected Component",
       y = "Width") +
  theme(axis.text.x = element_text(size = 12, color = "black"),
        axis.text.y = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        legend.position = "right",
        legend.text = element_text(size = 12, color = "black")
  )
ggsave(paste("WidthVlength.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

library(janitor)
table_L <- tabyl(Summary_output$Length, sort = TRUE)
table_W <- tabyl(Summary_output$Width, sort = TRUE)

write_csv(table_L, "output_frequency_L.csv")
write_csv(table_W, "output_frequency_W.csv")


