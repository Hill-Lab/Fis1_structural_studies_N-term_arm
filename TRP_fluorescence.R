#
# TRP fluorescence of nativeN- and dN- hFis1
# [nativeN- or dN-hFis1] = 10 µM
# Low Salt Buffer: 50 mM HEPES pH 7.4, 0.2 M NaCl
# High Salt Buffer: 50 mM HEPES pH 7.4, 2 M NaCl
# TRP excitation = 295 nm
# emission = 300 - 400nm
# excitation slit width (nm) = 4, 4
# emission slit width (nm) = 6, 6
# 

library(tidyverse)
library(broom)
library(readxl)
library(minpack.lm)

# Import, tidy, and correct for buffer emission background signal  ----

raw <- read_excel("20181127_TRP_nativeN_dN_hFis1_iodide_quenching.xlsx") %>%
  select(., -starts_with("X")) %>%
  gather(., "tmp", "Fluorescence", 2:37) %>%
  separate(., "tmp", into = c("hFis1", "NaI", "salt", "TRP"), sep = "_") %>%
  mutate(., NaI = parse_number(NaI)/1000) %>%
  filter(., wavelength >= 310 & wavelength <= 370) %>%
  group_by(., hFis1, salt) %>%
  mutate(., corrected_Fluor = 
           Fluorescence - Fluorescence[which(NaI == 0 & TRP == "buffer")]) %>%
  filter(., TRP == "prot") %>%
  select(., -TRP)


# Caclulate Fo/F for Stern-Volmer equation fitting ----

results <- raw %>%
  group_by(., hFis1, wavelength) %>%
  mutate(., FoF = corrected_Fluor[which(NaI == 0)] / corrected_Fluor)
  
write_csv(results, "nativeN_dN_hFis1_FoF_values.csv")

# Visualize Emission spectra for nativeN and dN in high and low salt -----

results %>%
  filter(., NaI == 0, salt == "low") %>%
  ggplot(., aes(x = wavelength, y = corrected_Fluor/1000, 
                color = hFis1)) +
  geom_line(stat = "smooth", method = "loess", span = 0.3, alpha = 0.7, 
            size = 1) +
  geom_vline(aes(xintercept = 339), color = "red", linetype = 2) + 
  geom_vline(aes(xintercept = 343), color = "blue", linetype = 2) + 
  scale_x_continuous(limits = c(310, 370),
                     breaks = c(310, 330, 350, 370)) +
  scale_color_manual(values = c("blue", "red")) +
  labs(color = "hFis1",
       title = "Removal of N-terminal arm increases solvent accessibility", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU*1000)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
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
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14, color = "black")
  )

ggsave("nativeN_dN_hFis1_TRP_em_spectra_arm_buries.pdf", 
       width = 16, height = 12, dpi = 300, units = "cm")

# Visualize Emission spectra for nativeN and dN in high and low salt -----

results %>%
  ggplot(., aes(x = wavelength, y = corrected_Fluor, 
                color = factor(NaI), shape = salt)) +
  geom_line(stat = "smooth", method = "loess", span = 0.2, alpha = 0.7, 
            size = 1) +
  facet_wrap(salt ~ hFis1, scales = "free") +
  scale_x_continuous(limits = c(310, 370),
                     breaks = c(310, 330, 350, 370)) +
  labs(color = "[NaI] (M)",
       shape = "[Salt]",
       title = "Iodide Quenching of TRP Emission Spectra", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
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
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14, color = "black")
  )

 ggsave("nativeN_dN_hFis1_TRP_em_spectra_all.pdf", 
       width = 20, height = 12, dpi = 300, units = "cm")
 
# Determine lamda max at each concentration of NaI ----
max_wavelength <- results %>% 
  group_by(., hFis1, NaI, salt) %>%
  summarise(., lamda_max = wavelength[which.max(corrected_Fluor)])
write_csv(max_wavelength, "nativeN_dN_hFis1_iodide_quenching_lamda_max.csv") 

max_wavelength 

avg_lamda_max <- max_wavelength %>%
   group_by(., hFis1) %>%
   summarise(., median_lamda_MAX = median(lamda_max),
             avg_lamda_MAX = mean(lamda_max),
             stdev = sd(lamda_max))
avg_lamda_max

write_csv(avg_lamda_max, "nativeN_dN_hFis1_iodide_quenching_avg_lamda_max.csv")
