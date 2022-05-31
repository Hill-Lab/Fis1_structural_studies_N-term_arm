# 
# Replotting atom-atom distances for JE's 1000-ns 1PC2_125SKY and h1IYG
# pooledtr1, tr2, and tr3
# force field = AMBER99SB
# GROMACS
# Included average atom-distances for 20-ensemble solved hFis1 1PC2 and
# mFis1 1IYG

library(tidyverse)
library(Peptides)
library(readxl)
theme_set(theme_bw() +
            theme(axis.text = element_text(size = 12, color = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()))

# read in pooled distances - previously calculated by JE

distances <- read_csv("atom_distances_1pc2_pool.csv") %>%
  union(read_csv("atom_distances_h1IYG_pool.csv"))

ensemble_distances <- read_excel("1PC2_1IYG_ensemble_atom_distances_tidy.xlsx", sheet=1)

mean_distances <- distances %>%
  group_by(., atom_pair, start) %>%
  summarise(avg = mean(distance), stdev = sd(distance))

mean_ensemble_distances <- ensemble_distances %>%
  group_by(., atom_pair, start) %>%
  summarise(avg = mean(distance), stdev = sd(distance))

# Plot atom-atom distances

mean_distances %>%
  filter(., atom_pair == "R83NH2_N6O" | atom_pair == "W40HE1_E2OE1" | atom_pair == "Y76CE1_V4CG2") %>%
  ggplot(aes(x = atom_pair, y = avg, fill = start)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_errorbar(aes(ymin = avg - stdev,
                      ymax = avg + stdev),
                  color = "grey70", width = 0.4, position=position_dodge(.9)) +
  labs(title = "Distances during 1000ns MD of 1PC2 and h1IYG",
      color = "Starting structure",
      x = "Time (ns)",
      y = "Atom-Atom Distance (Ã)") +
  scale_y_continuous(limits = c(0, 30), breaks = c(0, 5, 10, 15, 20, 25, 30)) +
  theme(legend.position = "none")


ggsave("atom_atom_distances_1pc2_pool.pdf", 
       width = 16, height = 12, units = "cm")

# Filter subset of atom-atom and ensemble distances for residue pairs of choice

mean_distances_filt <-mean_distances %>%
  filter(., atom_pair == "R83NH2_N6O" | atom_pair == "W40HE1_E2OE1" | atom_pair == "Y76CE1_V4CG2")

mean_ensemble_distances_filt <-mean_ensemble_distances %>%
  filter(., atom_pair == "R83NH2_N6O" | atom_pair == "W40HE1_E2OE1" | atom_pair == "Y76CE1_V4CG2")

# Plot atom-atom distances with mean ensemble distances overlaid on top

  ggplot(data = mean_distances_filt, aes(x = atom_pair, y = avg, fill = start)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_pointrange(data = mean_ensemble_distances_filt, aes(ymin = avg - stdev, ymax = avg + stdev), 
                  position = position_dodge(width=0.7), color = "red", fatten = 6) +
  geom_errorbar(aes(ymin = avg - stdev,
                    ymax = avg + stdev),
                color = "grey30", width = 0.3, position=position_dodge(.9)) +
    scale_fill_manual(values = c("1PC2" = "#989898", "h1IYG" = "#70cddd")) +
  labs(title = "Distances during 1000ns MD of 1PC2 and h1IYG",
       color = "Starting structure",
       x = "TEST Time (ns)",
       y = "Atom-Atom Distance (Ã)") +
  scale_y_continuous(limits = c(0, 30), breaks = c(0, 5, 10, 15, 20, 25, 30)) +
  theme(legend.position = "none")

  ggsave("20220314_updated_MD_distances_smallerdot.pdf", 
         width = 35, height = 16, units = "cm")
  
