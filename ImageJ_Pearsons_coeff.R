#
# Data wrangling of coloc2 microscopy images
# Goal is to extract Pearson's coefficient from imageJ exported log file 
#

# First set working directory to source file location
# Run with command + option + R

library(tidyverse)
library(reshape2)
library(stringr)
library(formattable)

# Import data 
data_path <- "~/mount/home101/mcharwig/20210903_Ntermtrun_repeat4/mitoYFP_DrpIF/combined_drp1_days/coloc_Drp1vMitoYFP_allz"

data <- read_csv(file = "updated_job_names.csv")
  
data <- data %>%
  mutate(job = factor(job, 
                      levels = c("WT_RPE_pcDNA", "Fis1_RPE_pcDNA", "Fis1_RPE_hFis1_WT", 
                                 "Fis1_RPE_hFis1_dN8")))

# Create a Box Plot with scatter points
data %>%
  ggplot(aes(x=job, y=Pearson, fill=job)) +
  geom_boxplot(outlier.size = 0, colour = "grey10", position = position_dodge (width = 1), size = 0.25) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 1), width = 0.5, size = 0.25) +
  scale_fill_manual(values=c("#707070","#BBBBBB","#4F9ACB","#E02A26")) +
  geom_point(aes(colour = job, x=job, y=Pearson), pch=20, size=0.01, position=position_jitterdodge(jitter.width=.75, jitter.height=0.1, dodge.width=1)) +
  scale_colour_manual(values=c("#4e4e4e","#828282","#376b8e","#9c1d1a")) +
  labs(title = "Pearson Drp v MitoYFP",
       x = "job",
       y = "Pearson Drp1 v MitoYFP") +
  theme(axis.text.x = element_text(size = 10, color = "black"),
        axis.text.y = element_text(size = 10, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        plot.title = element_blank(),
        #legend.title = element_blank(),
        #legend.justification = c(0, 1), 
        #legend.position = "right",
        #legend.text = element_text(size = 6, color = "black")
        legend.position = "none"
  )

ggsave("Pearson_bar.eps", height = 8, width = 6, dpi = 300, units = "cm") 


#AOV_STATS (ANOVA and TUKEY Post Hoc analysis)

AOV_STATS <- TukeyHSD(aov(data=data, Pearson~job))

AOV_Table <- (AOV_STATS)

AOV_Table_summary <- as.data.frame(AOV_Table[1:1])

write.csv(AOV_Table_summary, paste("AOV_stats.csv",sep=""))

formattable(AOV_Table_summary, Condition.p.adj=formatter("span", style = x~style(color=ifelse(x < 0.05 , "green", "black"))))

