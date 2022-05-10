# 
# Plotting equilibration checkpoints of calculated energy potential, 
# temperature, pressure, and density of system for
# experiment = 100-ns 1PC2_121SKY, tr1
# force field = AMBER99SB
# GROMACS
# 

library(tidyverse)
library(Peptides)
library(broom)

potential <- readXVG("potential.xvg") %>%
  as_tibble() %>%
  rename(., time_ps = Time) %>%
  mutate(time_ps = parse_number(time_ps),
         Potential = parse_number(Potential))
potential

temperature <- readXVG("temperature.xvg") %>%
  as_tibble() %>%
  rename(., time_ps = Time) %>%
  mutate(time_ps = parse_number(time_ps),
         Temperature = parse_number(Temperature))
temperature

pressure <- readXVG("pressure.xvg") %>%
  as_tibble() %>%
  rename(., time_ps = Time) %>%
  mutate(time_ps = parse_number(time_ps),
         Pressure = parse_number(Pressure))
pressure

density <- readXVG("density.xvg") %>%
  as_tibble() %>%
  rename(., time_ps = Time) %>%
  mutate(time_ps = parse_number(time_ps),
         Density = parse_number(Density))
density

# Energy potential minimization
a <- ggplot(potential, aes(x = time_ps, y = Potential)) +
  geom_line(color = "black") +
  labs(title = "Energy Minimization",
       x = "Time (ps)",
       y = "Energy Potential (kJ/mol)") +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = 'black'),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid')
  )
a
ggsave("potential.pdf", width = 18, height = 10, units = "cm")
ggsave("potential.png", width = 18, height = 10, units = "cm")

# Temperature equilibration 
b <- ggplot(temperature, aes(x = time_ps, y = Temperature)) +
  geom_line(color = "black") +
  geom_line(stat = "smooth", method = "loess", color = "red", size = 0.5) +
  labs(title = "Temperature Equilibration (NVT Ensemble)", x = "Time (ps)", 
            y = "Temperature (K)") +
  coord_cartesian(ylim = c(250, 310), xlim = c(0, 100)) +
  scale_y_discrete(limits = c(250, 260, 270, 280, 290, 300, 310)) +
  scale_x_discrete(limits = c(0, 25, 50, 75, 100)) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = 'black'),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid')
  )
b
ggsave("temperature.pdf", width = 18, height = 10, units = "cm")
ggsave("temperature.png", width = 18, height = 10, units = "cm")

# Pressure equilibration 
c <- ggplot(pressure, aes(x = time_ps, y = Pressure)) +
  geom_line(color = "black") +
  geom_line(stat = "smooth", method = "loess", color = "red", size = 0.5) +
  labs(title = "Pressure Equilibration (NPT Ensemble)",
       x = "Time (ps)",
       y = "Pressure (bar)") +
  coord_cartesian(ylim = c(-1000, 1000), xlim = c(0, 100)) +
  scale_y_discrete(limits = c(-1000, -750, -500, -250, 0, 250, 
                              500, 750, 1000)) +
  scale_x_discrete(limits = c(0, 25, 50, 75, 100)) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = 'black'),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid')
  )
c
ggsave("pressure.pdf", width = 18, height = 10, units = "cm")
ggsave("pressure.png", width = 18, height = 10, units = "cm")

# Density progression
d <- ggplot(density, aes(x = time_ps, y = Density)) +
  geom_line(color = "black") +
  geom_line(stat = "smooth", method = "loess", color = "red", size = 0.5) +
  labs(title = "Density Progression (NPT Ensemble)",
       x = "Time (ps)",
       y = "Density (kg/m^3)") +
  coord_cartesian(ylim = c(980, 1040), xlim = c(0, 100)) +
  scale_y_discrete(limits = c(980, 990, 1000, 1010, 1020, 1030, 1040)) +
  scale_x_discrete(limits = c(0, 25, 50, 75, 100)) +
  theme_bw() +
  theme(axis.text = element_text(size = 12, color = 'black'), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid')
  )
d
ggsave("density.pdf", width = 18, height = 10, units = "cm")
ggsave("density.png", width = 18, height = 10, units = "cm")
