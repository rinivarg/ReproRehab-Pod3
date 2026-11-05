suppressMessages(install.packages("emmeans"))

rm(list = ls())

ReqdLibs = c("ggplot2","dplyr","emmeans")
invisible(suppressMessages(lapply(ReqdLibs, library, character.only = TRUE)))


thm = theme(
          plot.title = element_text(colour = "black",size = 35, face = "bold", hjust = 0.5),
          legend.text = element_text(size = 18),
          legend.title = element_text(size = 20),
          axis.ticks.length = unit(0.3,"cm"),
          axis.line = element_line(colour = "black",linewidth = 1),
          axis.ticks = element_line(colour = "black",linewidth = 1),
          axis.text = element_text(colour = "black",size = 35),
          axis.text.x = element_text(lineheight = 1.1, margin = margin(t = 20)),
          axis.title.x = element_text(size=35, colour = "grey35", face = "plain",
                                     lineheight = 1.1, margin = margin(r = 10)),
          axis.title.y = element_text(size=35, colour = "grey35", face = "plain",
                                     lineheight = 1.1, margin = margin(r = 10)))



head(diamonds)

diamonds %>%
  filter(cut!="Fair") %>%
  select(clarity,cut, depth) %>%
  {.->>diamonds.ideal}

head(diamonds.ideal)

options(repr.plot.width = 10, repr.plot.height = 7)

ggplot(diamonds.ideal, mapping = aes(x = depth, y = after_stat(density),
                                     group = cut, col = cut, fill = cut)) +
  # geom_histogram(bins = 50, fill = NA) +
  geom_density(alpha = 0.5) +
  # facet_wrap(~clarity) +
  coord_cartesian(xlim = c(40,80), ylim = c(0, 1.3)) +
    theme_minimal() + thm


dat.calc2 = read.csv("calcData.csv", header = TRUE)
head(dat.calc2)

options(repr.plot.width = 12, repr.plot.height = 8)

repro.fig =
# FUNCTION CALL
ggplot(dat.calc2, aes(x = incline,y = C_meas, group = speed, label = speed)) +

# LAYERS THAT SUMMARIZE WHILE PLOTTING! - this is one of the most powerful features of ggplot
stat_summary(geom = "bar", fun = mean, col = NA, fill = "black", width = 0.7, na.rm = TRUE,
             position=position_dodge(width = 0.82, preserve = 'single')) +
stat_summary(geom = "errorbar",fun.data = mean_se, width = 0.15, lwd=2.5, col="darkgray", na.rm = TRUE,
            position=position_dodge(0.82, preserve = 'single')) +
stat_summary(geom = "text", fun = mean, position = position_dodge(0.82, preserve = 'total'), na.rm = TRUE,
             vjust = -1.25, size = 10) +

# AXIS LIMITS
coord_cartesian(ylim = c(0.31,6.75)) +

# LABELS
scale_x_discrete(labels = c("Downhill", "Level", "Uphill")) +  # capitalize label initials :/
labs(title = "Pulmonary Gas Exchange", x = "", y = "Measured Metabolic\nCost [J/kg/m]") +
theme_classic() + thm

repro.fig

mod.inter = lm(data = dat.calc2, W_adj ~ incline*speed)
summary(mod.inter)

emm_inter = emmeans(mod.inter, ~incline|speed)
pairs(emm_inter, by = "incline")


