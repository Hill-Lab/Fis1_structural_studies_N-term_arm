# 20211122 plotting of spin relaxation data collected on 500 MHz and 600 MHz
# spectrometers. Plots of R1, R2, NOE, and calculated order parameters by residue.

library(tidyverse)
library(readxl)

#load file - edited in excel
#raw data included in folder

order_param <- read_excel("20211122_spinrelaxation_plotting.xlsx", sheet = 1)

R1 <- read_excel("20211122_spinrelaxation_plotting.xlsx", sheet = 2)
  
R2 <- read_excel("20211122_spinrelaxation_plotting.xlsx", sheet = 3)
  
NOE <- read_excel("20211122_spinrelaxation_plotting.xlsx", sheet = 4) 

  
#Combined data - R1, R2, and HetNOE

#R1
R1 %>% 
  ggplot(., aes(x = residue, y = R1, color = as.factor(field), shape=as.factor(field))) +
  geom_pointrange(aes(ymin=R1-R1err, ymax=R1+R1err), position=position_dodge(0.9),
                  size=0.3) +
  scale_color_manual(values=c("gray15", "orchid4")) +
  labs(x = "Residue Number", y = "R1") +
  theme_bw() + 
  scale_y_continuous(limits = c(0, 2.3), breaks = c(0, 0.5, 1.0, 1.5, 2.0)) +
  theme(axis.text = element_text(color = "black", size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 1, linetype = 1),
        axis.line.y = element_line(color = "black", size = 1, linetype = 1)
  )

ggsave("20211122_Fis1_R1.png",
       width = 16, height = 10, units = "cm")

ggsave("20211122_Fis1_R1.pdf",
       width = 16, height = 10, units = "cm")

#R2
R2 %>% 
  ggplot(., aes(x = residue, y = R2, color = as.factor(field), shape=as.factor(field))) +
  geom_pointrange(aes(ymin=R2-R2err, ymax=R2+R2err), position=position_dodge(0.9),
                  size=0.3) +
  scale_color_manual(values=c("gray15", "orchid4")) +
  labs(x = "Residue Number", y = "R2") +
  theme_bw() +
  scale_y_continuous(limits = c(0, 15.3), breaks = c(0, 3, 6, 9, 12, 15)) +
  theme(axis.text = element_text(color = "black", size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 1, linetype = 1),
        axis.line.y = element_line(color = "black", size = 1, linetype = 1)
  )

ggsave("20211122_Fis1_R2.png",
       width = 16, height = 10, units = "cm")

ggsave("20211122_Fis1_R2.pdf",
       width = 16, height = 10, units = "cm")

#NOE
NOE %>% 
  ggplot(., aes(x = residue, y = NOE, color = as.factor(field), shape=as.factor(field))) +
  geom_pointrange(aes(ymin=NOE-NOEerr, ymax=NOE+NOEerr), position=position_dodge(0.9),
                  size=0.3) +
  scale_color_manual(values=c("gray15", "orchid4")) +
  labs(x = "Residue Number", y = "NOE") +
  theme_bw() + 
  theme(axis.text = element_text(color = "black", size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 1, linetype = 1),
        axis.line.y = element_line(color = "black", size = 1, linetype = 1)
  )

ggsave("20211122_Fis1_NOE.png",
       width = 16, height = 10, units = "cm")

ggsave("20211122_Fis1_NOE.pdf",
       width = 16, height = 10, units = "cm")


#Plot order parameter figure
order_param %>% 
  filter(., residue!= 5) %>%
  ggplot(., aes(x = residue, y = S2, color = secondary)) +
#  geom_point(stat = "identity",  color = "gray40", size = 1.0) +
  geom_pointrange(aes(ymin=S2-S2err, ymax=S2+S2err), size = 0.3) +
  scale_y_continuous(limits = c(0, 1.1), breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1.0)) +
  scale_color_manual(breaks = c("arm", "helix", "loop"),
                    labels = c("N-arm", "Helix", "Loop"),
                    values = c("#1b9e77", "#7570b3", "#d95f02")) +
  labs(x = "Residue Number", y = "S2") +
  theme_bw() + 
  theme(axis.text = element_text(color = "black", size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 1, linetype = 1),
        axis.line.y = element_line(color = "black", size = 1, linetype = 1)
  )

ggsave("20211122_Fis1_order_parameters_color.png",
       width = 16, height = 10, units = "cm")

ggsave("20211122_Fis1_order_parameters_color.pdf",
       width = 16, height = 10, units = "cm")
