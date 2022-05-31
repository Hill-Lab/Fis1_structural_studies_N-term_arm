# Reanalyzing Ryan Bonate's CSP data
# and plotting the CSP plot of Fis1dN-Fis1
# so that it matches standard style of lab
# and gradient color scheme of Pymol figure
# to be incorporated into the JBC manuscript

library(tidyverse)
library(broom)
library(minpack.lm)
library(readxl)

raw <- read_csv("20211022_Fis1_Fis1dN_peaklists_edit.csv")

# Calculate total chemical shift perturbations and plot against residue

total_shift <- raw %>%
  mutate(., CSP = sqrt(((5*(H_Fis1 - H_dN))^2) + (N_Fis1 - N_dN)^2))

# Determine mean and SD of chemical shift perturbations
mean_sd <- total_shift %>%
  filter(., CSP >= 0) %>%
  summarise(., mean = mean(CSP),
            sd = sd(CSP)) %>%
  mutate(twoSD = 2*sd, sigma = mean + sd, twosigma = sigma*2)

mean_sd

total_shift <- total_shift %>%
  mutate(., STDEV = 0.402, TwoSTDEV = 0.805, sigma = 0.714693, 
         twosigma = 1.429386, mean = 0.3110453)

write_csv(total_shift, "20220310_dN_hFis1_CSPs_from_nativeN.csv")

# CSP by Fis1 Residue # for dN and WT Fis1
# in red gradient to match surface representation in Pymol
# Using W40 indole as reporter for residue W40.

total_shift %>% 
  filter(., aa!= "TRP") %>%
  ggplot(., aes(x = residue, y = CSP, fill = CSP)) +
  geom_bar(stat = "identity",  color = "gray35", size = 0.05) +
  scale_fill_gradient(low = "white", high = "#D32A2A") +
  geom_hline(yintercept = c(0.714693 , 1.429386, 0.3110453), color = c("grey50", "grey50", "black"), 
             alpha = 0.8) +
  scale_x_continuous(limits = c(10, 125),
                     breaks = c(0, 10, 20, 30, 40, 50, 60,
                                70, 80, 90, 100, 110, 120)) +
  labs(x = "Residue Number", y = "dCSP ppm") +
  theme_bw() + # green line = 1 SD and purple line = 2 SD from zero 
  theme(axis.text = element_text(color = "black", size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 1, linetype = 1),
        axis.line.y = element_line(color = "black", size = 1, linetype = 1)
  )

ggsave("20220310_Fis1_Fis1dN_CSP_plot_sigma.png",
       width = 16, height = 10, units = "cm")

ggsave("20220310_Fis1_Fis1dN_CSP_plot_sigma.pdf",
       width = 16, height = 10, units = "cm")
