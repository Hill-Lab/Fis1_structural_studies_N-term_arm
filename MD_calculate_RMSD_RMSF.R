# 
# Plotting RMSD and RMSF values
# experiment = 100-ns 1PC2_121SKY, tr1
# force field = AMBER99SB
# GROMACS
# 

library(tidyverse)
library(Peptides)
theme_set(theme_bw() +
            theme(axis.text = element_text(size = 12, color = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()))


# Import and tidy data ----------------------------------------------------

backbone_rmsd <- read_table2("rmsd_1pc2.txt") %>%
  mutate(rmsd = rmsd*10)
backbone_rmsd

calpha_rmsd <- read_table2("rmsd_Caplha_Calpha.txt") %>%
  mutate(rmsd = rmsd*10)
calpha_rmsd

rmsf <- read_table2("rmsf_1pc2.txt") %>%
  mutate(rmsf = rmsf*10)
rmsf

# Plot backbone RMSD values -----------------------------------------------
a <- ggplot(backbone_rmsd, aes(x = time_ns, y = rmsd)) +
  geom_line(color = "grey10", size = 0.2) +
  #geom_line(stat = "smooth", method = "loess", color = "red", span = 0.6, size = 0.4) +
  labs(x = "Time (ns)",
       y = "RMSD (Å)") +
  scale_y_continuous(limits = c(0, 6),
                     breaks = c(0, 2, 4, 6))
a
ggsave("rmsd_backbone_1pc2.pdf", width = 6, height = 5, units = "cm")

# Plot C-alpha RMSD values -----------------------------------------------
b <- ggplot(calpha_rmsd, aes(x = time_ns, y = rmsd)) +
  geom_line(color = "grey10", size = 0.2) +
  #geom_line(stat = "smooth", method = "loess", color = "red", span = 0.6, size = 0.4) +
  labs(x = "Time (ns)",
       y = "RMSD (Å)") +
  scale_y_continuous(limits = c(0, 6),
                     breaks = c(0, 2, 4, 6))
b
ggsave("rmsd_calpha_1pc2.pdf", width = 6, height = 4, units = "cm")

# Plot RMSF values -----------------------------------------------
c <- ggplot(rmsf, aes(x = residue, y = rmsf)) +
  geom_line(color = "grey10", size = 0.5) +
  #geom_line(stat = "smooth", method = "loess", color = "red", span = 0.6, size = 0.4) +
  labs(x = "Time (ns)",
       y = "RMSF (Å)")
c
ggsave("rmsf_1pc2.pdf", width = 6, height = 4, units = "cm")

