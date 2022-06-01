# Acrylamide quenching of Trp fluorescence of nativeN and dN-hFis1
# [nativeN] and [dN] = 10 uM
# [acrylamide] = 0-500 mM
# data collected on 20200219
# Buffer: 20 mM Hepes, 175 mM NaCl, 1 mM DTT, 0.02% NaAz
# Trp excitation: 295 nm
# Trp emission collected over: 300-400 nm
# slit widths set at 2.5 per Dash lab protocol

library(ggpmisc)
library(tidyverse)
library(broom)
library(readxl)
library(minpack.lm)

theme_set(theme_bw() +
            theme(axis.text = element_text(size = 12, color = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())
)

# Import data, tidy, and correct for buffer emission background signal

raw <- read_excel("20200219_TRP_dN_nativeN_acrylamide_d1.xlsx") %>%
  gather(., key = "tmp1", value = "fluor", 2:44 ) %>%
  separate(., "tmp1", into = c("prot", "conc", "tr"), sep = "_")

# Visualize data before buffer correction

raw %>%
  ggplot(., aes(x = Wavelength, y = fluor, color = conc, shape = tr)) +
  geom_line(stat = "smooth", method = "loess", span = 0.2,
            alpha = 0.7, size = 1) +
  facet_wrap(~ prot) +
  scale_x_continuous(limits = c(315, 375),
                     breaks = c(315, 345, 375)) +
  labs(color = "[Acrylamide] (M)",
       title = "Acrylamide Quenching of TRP Emission Spectra", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12, color = "black")
  )

# Subtract buffer signal

corrected <- raw %>%
  filter(., Wavelength >= 315 & Wavelength <= 375) %>%
  mutate(., corrected_fluor = fluor - fluor[which(conc ==0 & prot == "Buffer")]) %>%
  filter(., prot != "Buffer")

# Visualize data

corrected %>%
  ggplot(., aes(x = Wavelength, y = corrected_fluor, color = conc, shape = tr)) +
         geom_line(stat = "smooth", method = "loess", span = 0.2,
                   alpha = 0.7, size = 1) +
  facet_wrap(~ prot) +
  scale_x_continuous(limits = c(315, 375),
                     breaks = c(315, 345, 375)) +
  labs(color = "[Acrylamide] (M)",
       title = "Acrylamide Quenching of TRP Emission Spectra", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12, color = "black")
  )

ggsave("nativeN_dN_hFis1_TRP_em_spectra_all.pdf", 
       width = 20, height = 12, dpi = 300, units = "cm")

#Subset data to remove outliers

corrected_noFis1_50 <- corrected[-c(1465:1525),]
corrected_no_outlier <- corrected_noFis1_50[-c(1953:2013),]

# Visualize data without outliers

corrected_no_outlier %>%
  ggplot(., aes(x = Wavelength, y = corrected_fluor, color = conc, shape = tr)) +
  geom_line(stat = "smooth", method = "loess", span = 0.2,
            alpha = 0.7, size = 1) +
  facet_wrap(~ prot) +
  scale_x_continuous(limits = c(315, 375),
                     breaks = c(315, 345, 375)) +
  labs(color = "[Acrylamide] (mM)",
       title = "Acrylamide Quenching of TRP Emission Spectra", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12, color = "black"),
  )

# Average corrected fluorescence intensities of corrected data

corrected_no_outlier_avg <- corrected_no_outlier %>%
  group_by(., prot, conc, Wavelength) %>%
  summarise(., avg_fluor = mean(corrected_fluor))

# Visualize average fluorescence intensities of corrected data
corrected_no_outlier_avg %>%
  ggplot(., aes(x = Wavelength, y = avg_fluor, color = conc)) +
  geom_line(stat = "smooth", method = "loess", span = 0.35,
            alpha = 0.7, size = 1) +
  facet_wrap(~ prot) +
  scale_x_continuous(limits = c(315, 375),
                     breaks = c(315, 345, 375)) +
  labs(color = "[Acrylamide] (mM)",
       title = "Acrylamide Quenching of TRP Emission Spectra", 
       x = "Wavelength (nm)",
       y = "Fluorescence (AU)") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12, color = "black")
  )

# Caclulate Fo/F for Stern-Volmer equation fitting

results <- corrected_no_outlier_avg %>%
  group_by(., prot, Wavelength) %>%
  mutate(., FoF = avg_fluor[which(conc == 0)] / avg_fluor)

write_csv(results, "nativeN_dN_hFis1_FoF_values.csv")

#Calculate average Fo/F for each protein/[acrylamide]

results_avg <- results %>%
  group_by(., prot, conc, Wavelength) %>%
  summarise(., avg_FoF = mean(FoF))

# Determine lamda max at each concentration of NaI ----
max_wavelength <- results %>% 
  group_by(., prot, conc) %>%
  summarise(., lamda_max = Wavelength[which.max(avg_fluor)])

write_csv(max_wavelength, "nativeN_dN_hFis1_iodide_quenching_lamda_max.csv") 

avg_lamda_max <- max_wavelength %>%
  group_by(., prot) %>%
  summarise(., median_lamda_MAX = median(lamda_max),
            avg_lamda_MAX = mean(lamda_max),
            stdev = sd(lamda_max))

write_csv(avg_lamda_max, "nativeN_dN_hFis1_iodide_quenching_avg_lamda_max.csv") 

# Visualize Stern-Volmer plots for nativeN and dN  -----
results_avg %>%
  filter(., Wavelength == 341) %>%
  ggplot(., aes(x = as.numeric(conc), y = avg_FoF, color = prot)) +
  geom_point(size = 2) +
  geom_line(stat = "smooth", method = "nlsLM",
            formula = y ~ (1 + (Ksv * x)),
            method.args = list(start = c(Ksv = 0.5),
                               control = nls.control(maxiter = 100, tol = 1e-6)),
            se = FALSE,        
            fullrange = TRUE, 
            size = 1.25,
            alpha = 0.9) + 
   scale_colour_manual(name = "Protein",
                      labels = c("dN", "Fis1"),
                      values = c("#EC1C24", "#29ABE2", "#EC1C24", "#29ABE2")) +   
  scale_shape_manual(name = "Protein", labels = c("dN", "Fis1"),
                     values = c(17, 19)) +
    labs(color = "Protein",
       title = "Stern-Volmer Plots (lamda = 341 nm)", 
       x = "[Acrylamide] (mM)",
       y = "Fo/F") +
  guides(shape = guide_legend(override.aes = list(size = 2))) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12, color = "black")
  )

ggsave("stern_volmer_correctcolors_thinnerlines.pdf", 
       width = 4, height = 3, dpi = 300, useDingbats = FALSE)

# Determine Ksv by fitting Fo/F vs. [NaI] to stern-volmer equation ----
# calculate Ksv from model fitting

Ksv_model <-  results_avg %>%
  group_by(., Wavelength, prot) %>%
  do(tidy(nlsLM(avg_FoF ~ (1 + (Ksv * as.numeric(conc))),
                start = list(Ksv = 0.5), 
                trace = TRUE,
                control = nls.control(maxiter = 100, tol = 1e-6), .))) %>%
  spread(., key = term, value = estimate)

write_csv(Ksv_model, "nativeN_dN_Ksv_model_values.csv")

Ksv_model

