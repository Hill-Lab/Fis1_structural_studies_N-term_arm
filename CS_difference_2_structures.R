# 
# Computing chemical shift differences between experimental HEPES & 1PC2
#


# Load libraries and set theme --------------------------------------------

library(tidyverse)
library(readxl)
library(bio3d)
theme_set(theme_bw() + 
            theme(panel.grid.minor = element_blank(),
                  panel.grid.major = element_blank(),
                  axis.text = element_text(size = 10, color = "black")))

# Import prot file and aa sequence ----------------------------------------
onepc2 <- read_table("hfis1_Youle_construct.txt", col_names = FALSE)
onepc2

hepes <- read_excel("apo_hFis1_aa1-125_chemical_shifts.xlsx", sheet = 1) %>%
  rename(H_hepes = H_ppm, N_hepes = N_ppm) %>%
  mutate(residue = parse_number(label)) %>%
  select(-label)
hepes

# Tidy 1PC2 chemical shift references (Youle) -----------------------------

tmp1 <- onepc2 %>%
  filter(X1 == "RES_ID") %>%
  rename(residue = X2) %>%
  slice(1:125) %>%
  filter(residue != 1 & residue != 2 & residue != 63 & residue != 102) %>%
  select(residue)
tmp1

tmp2 <- onepc2 %>%
  filter(X1 == "RES_TYPE") %>%
  rename(aa = X2) %>%
  select(aa) %>%
  slice(c(3:62, 64:101, 103:125)) # select row positions w/ removing missing aa
tmp2

tmp3 <- onepc2 %>%
  filter(X1 == "HN" | X1 == "RES_ID") %>%
  rename(HN = X2) %>%
  filter(HN != 1 & HN != 2 & HN != 63 & HN != 102 & X1 == "HN") %>%
  slice(1:121) %>%
  select(HN)
tmp3

tmp4 <- onepc2 %>%
  filter(X1 == "N" | X1 == "RES_ID") %>%
  rename(N = X2) %>%
  slice(1:246) %>%
  filter(X1 == "N") %>%
  select(N)
tmp4

tmp5 <- onepc2 %>%
  filter(X1 == "CA" | X1 == "RES_ID") %>%
  rename(CA = X2) %>%
  slice(1:250) %>%
  filter(X1 == "CA") %>%
  select(CA) %>%
  slice(c(3:62, 64:101, 103:125))
tmp5

youle_talos <- tmp1 %>%
  bind_cols(tmp2, tmp3, tmp4, tmp5) %>%
  gather(HN, N, CA, key = "atom", value = "shift") %>%
  mutate(residue = parse_number(residue),
         shift = parse_number(shift)) %>%
  arrange(residue)
youle_talos
write_csv(youle_talos, "youle_talos_table.csv")


# Recreate 1PC2’s HSQC ----------------------------------------------------

youle_talos %>%
  spread(key = atom, value = shift) %>%
  ggplot(aes(x = HN, y = N)) +
  geom_point(shape = 4, size = 2, color = "blue") +
  scale_x_reverse(limits = c(10.5, 6.5)) +
  scale_y_reverse(limits = c(130, 105))

ggsave("youle_1PC2_HSQC.pdf",
       width = 16, height = 16, units = "cm", dpi = 300)


# Pool my experimental shifts in HEPES with Youle’s 1PC2 -----------------------

youle_1pc2 <- tmp1 %>%
  bind_cols(tmp2, tmp3, tmp4) %>%
  rename(H_1pc2 = HN, N_1pc2 = N) %>%
  mutate(residue = parse_number(residue),
         H_1pc2 = parse_number(H_1pc2),
         N_1pc2 = parse_number(N_1pc2))
youle_1pc2

pool <- hepes %>%
  left_join(youle_1pc2, by = "residue") %>%
  select(residue, aa, secondary, everything())
pool

# Compute exp-HEPES and 1PC2 chemical shift difference -------------

pool2 <- pool %>%
  mutate(H_diff = H_hepes - H_1pc2,
         N_diff = N_hepes - N_1pc2)
pool2

### H Difference plot ----------------------------------------------
pool2 %>%
  ggplot(aes(x = residue, y = H_diff, fill = secondary)) +
  geom_col() +
  scale_fill_manual(values = c("darkgreen", "purple", "orange")) +
  scale_x_continuous(limits = c(0, 126),
                     breaks = c(0, 25, 50, 75, 100, 125)) +
  scale_y_continuous(limits = c(-0.4, 0.4),
                     breaks = c(-0.4, -0.2, 0, 0.2, 0.4)) +
  labs(fill = "",
       x = "Residue",
       y = "H ∆∂ (∂Exp - ∂1PC2)") +
  theme(legend.position = "top")

suppressWarnings(ggsave("exp_HEPES_1PC2_CS_H_difference_plot.pdf",
       width = 12, height = 8, units = "cm", dpi = 300))
ggsave("exp_HEPES_1PC2_CS_H_difference_plot.png",
       width = 12, height = 8, units = "cm", dpi = 300)

### N Difference plot ---------------------------------------------
pool2 %>%
  ggplot(aes(x = residue, y = N_diff, fill = secondary)) +
  geom_col() +
  scale_fill_manual(values = c("darkgreen", "purple", "orange")) +
  scale_x_continuous(limits = c(0, 126),
                     breaks = c(0, 25, 50, 75, 100, 125)) +
  scale_y_continuous(limits = c(-3.7, 7),
                     breaks = c(-2, 0, 2, 4, 6)) +
  labs(fill = "",
       x = "Residue",
       y = "N ∆∂ (∂Exp - ∂1PC2)") +
  theme(legend.position = "top")

suppressWarnings(ggsave("exp_HEPES_1PC2_CS_N_difference_plot.pdf",
       width = 12, height = 8, units = "cm", dpi = 300))
ggsave("exp_HEPES_1PC2_CS_N_difference_plot.png",
       width = 12, height = 8, units = "cm", dpi = 300)


# H distribution plots  ----------------------------------------------------

pool2 %>%
  ggplot(aes(x = H_diff, color = secondary)) +
  geom_density(size = 1) +
  scale_color_manual(values = c("darkgreen", "purple", "orange")) +
  labs(x = "H ∆∂",
       y = "Density")

ggsave("H_delta_density_plot.svg",
       width = 8, height = 6, units = "cm", dpi = 300)

# N distribution plots -----------------------------------------------------

pool2 %>%
  ggplot(aes(x = N_diff, color = secondary)) +
  geom_density() +
  scale_color_manual(values = c("darkgreen", "purple", "orange")) +
  labs(x = "N ∆∂",
       y = "Density")

ggsave("N_delta_density_plot.svg",
       width = 8, height = 6, units = "cm", dpi = 300)
