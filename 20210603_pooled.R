# Plotting Prometheus nanoDSF data which measures intrinsic Trp fluorescence
# as a function of increasing temperature (20-95C)
# Data collected on 20210106 and 20210419
# 3 replicates each with n=3
# Each replicate corresponds to new protein purification sample

#Load libraries 
library(tidyverse)
library(dplyr)
library(broom)
library(readxl)
library(minpack.lm)
library(ggpmisc)
library(RColorBrewer)

theme_set(theme_bw() +
            theme(axis.text = element_text(size = 12, color = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())
)

# Import and tidy data  --------------------------------------------------------
### update excel sheet with proper heading info separated by "_"
raw106 <- read_excel("20210603_pooled_Fis1_Fis1dN.xlsx", sheet = 1) %>%
  gather(., "tmp1", "Fluorescence", 2:10) %>% # update ##:## w/ column numbers
  separate(., col = tmp1, into = c("prot", "n", "tr"), 
           sep = "_") %>%
  mutate(., Fluorescence = as.double(Fluorescence))

raw419 <- read_excel("20210603_pooled_Fis1_Fis1dN.xlsx", sheet = 2) %>%
gather(., "tmp1", "Fluorescence", 2:10) %>% # update ##:## w/ column numbers
  separate(., col = tmp1, into = c("prot", "n", "tr"), 
           sep = "_") %>%
  mutate(., Fluorescence = as.double(Fluorescence))

# merge the two data sets
merged <- union(raw106, raw419)

#calculate Tm values for each technical replicate 
Tm_all <- merged %>%
  filter(., temp < 85) %>%
  group_by(., prot, n, tr) %>%
  summarise(max = max(Fluorescence))
Tm_all

# Searched merged for max fluorescence values reported in Tm_all
# add in corresponding temperature to max fluorescence value

Tm_all$Tm <- c(81.16, 81.33, 81.46, 83.00, 82.96, 83.09, 82.88, 82.90,
                 82.83, 79.25, 79.52, 79.27, 80.15, 79.72, 80.05, 79.13, 80.08, 78.87)


# calculate the Tm value for each protein using each TR from each N (9 total data points)
 Tm_all_avg <- Tm_all %>%
  group_by(., prot) %>%
  summarise(mean = mean(Tm),
            sd = sd(Tm))
 
 # T test using all TR (9)
  t_test_Tm <- Tm_all %>%
   t.test(Tm ~ prot, data = .)

#visualize Tm values as box plot with jitter to show all data points
# n=3 with 3 tr each
Tm_all %>%
  ggplot(aes(x = prot, y = Tm, color = prot)) +
  geom_boxplot(width = 0.5, lwd = 0.75) +
   geom_jitter(size = 2, alpha = 0.8) +
 scale_color_manual(values = c("Fis1" = "#29ABE2", "Fis1dN" = "#EC1C24")) +
 scale_y_continuous(limits = c(78.75, 83.25), breaks = c(79, 80, 81, 82, 83)) +
  labs(title = "Tm values", x = "Protein",
       y = "Tm (C)") +
  theme(legend.text = element_text(size = 12), 
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))

ggsave("Fis1_Fis1dN_Tm_boxplot.pdf", 
       width = 6, height = 5, dpi = 300, useDingbats = FALSE)


# Average tr
# calculate average Fluorescence for each N (average of the 3 TR)
results_avg <- merged %>%
  group_by(., temp, prot, n) %>%
  summarise(., mean_fluor = mean(Fluorescence), 
            sd = sd(Fluorescence)) %>%
  ungroup()

# Visualize data and facet by biological replicate ----------------------
merged %>%
  ggplot(., aes(x = temp, y = Fluorescence, color = prot, shape = tr)) +
  geom_point(size = 0.75) +
  geom_line(size = 0.25) +
  scale_color_brewer(palette = "Set2") +
  facet_wrap(n ~ .) +
  labs(title = "TSA: Fis1 and Fis1dN - Facet by N and TR", 
       color = "Protein",
       x = "Temperature (C)",
       y = "dFluorescence (dF/dT))") +
  theme_bw() +
  theme(axis.text = element_text(size = 14, color = "black"),
        #axis.title.x = element_text(size = 18),
        #axis.title.y = element_text(size = 18),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        #panel.border = element_blank(),
        #panel.background = element_blank(),
        #axis.line.x = element_line(colour = 'black', size=1, linetype='solid'),
        #axis.line.y = element_line(colour = 'black', size=1, linetype='solid'),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14, color = "black")
  )

ggsave("1st_deriv_melt_curve_facet_n_tr.pdf", 
       width = 35, height = 16, units = "cm")

# Plotting averaged results (avg of Tm) - still split by n 
results_avg %>%
  filter(., temp < 85) %>%
  ggplot(., aes(x = temp, y = mean_fluor, color = prot)) +
  geom_point(size = 0.75) +
  geom_line(size = 0.25) +
  scale_color_brewer(palette = "Set2") +
  facet_wrap(n ~ .) +
  labs(title = "TSA: Fis1 and Fis1dN - Facet by N and TR", 
       color = "Protein",
       x = "Temperature (C)",
       y = "dFluorescence (dF/dT))") +
  theme_bw() +
  theme(axis.text = element_text(size = 14, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14, color = "black")
  )

ggsave("1st_deriv_melt_curve_facet_n.pdf", 
       width = 35, height = 16, units = "cm")

# Compute average of Tm values of the technical replicates
# Filter out >80 C temps due to large fluorescence increase in one of the dN samples
# likely due to aggregation post unfolding

Tm_stats <- results_avg %>%
  group_by(., prot, n) %>%
  summarise(max = max(mean_fluor))
Tm_stats

# Parsed results_avg to find temperature corresponding to max fluor
# Note: Fis1 dN n=3 had erroneous high fluor at end of run due to aggregation

Tm_stats$Tm <- c(81.33, 83.03, 82.88, 79.35, 79.95, 79.82)

# Determine avg Tm and SD from 3 biological replicates
Tm_stats_avg <- Tm_stats %>%
  summarise(mean = mean(Tm),
            sd = sd(Tm))

# T test using all TR (9)
Tm_stats_Ttest <- Tm_stats %>%
  t.test(Tm ~ prot, data = .)
