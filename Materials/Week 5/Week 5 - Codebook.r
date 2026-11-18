rm(list=ls())

ReqdLibs = c("readxl","dplyr","tidyr","gt","sjPlot",
             "ggplot2","ggthemes","ggpubr","ggExtra",
             "lme4","emmeans","janitor","broom","car","IRdisplay")
invisible(lapply(ReqdLibs, library, character.only = TRUE))


thm = theme(strip.text.x=element_text(size=20,face="bold"),
          strip.text.y=element_text(size=20,face="bold"),
          legend.text=element_text(size=16,face="bold"),
          legend.position = "top",
          legend.title=element_text(size=16,face="bold"),
          title =element_text(size=14, face='bold'),
          text = element_text(colour = "black",size=18), 
          plot.title = element_text(colour = "black",size = 22, face = "bold"),
          axis.ticks.length = unit(0.3,"cm"),
          axis.line = element_line(colour = "black",linewidth=0.85),
          axis.ticks = element_line(colour = "black",linewidth=0.85),
          axis.text = element_text(colour = "black",size=24),
          axis.title=element_text(size=25))

# Read in demographics data
demo <- read_excel("SubjectInfo.xlsx")

# Display structure of demo data
head(demo)

demo_clean = clean_names(demo) %>% filter(subject_no!="Sub4")
head(demo_clean)

# Create summary statistics
demo_summary <- demo_clean %>%
  summarise(
    sex = paste0(sum(gender == "M", na.rm = TRUE), "M, ", 
                 sum(gender == "F", na.rm = TRUE), "F"),
    age =    paste0(round(mean(age, na.rm = TRUE),0), " ± ",
                    round(sd(age, na.rm = TRUE),0)),

    weight = paste0(round(mean(reported_weight_kg, na.rm = TRUE),0), " ± ",
                    round(sd(reported_weight_kg, na.rm = TRUE),0)),

    # weight = paste0(round(mean(weight_from_force_plates_kg, na.rm = TRUE),0), " ± ",
    #                 round(sd(weight_from_force_plates_kg, na.rm = TRUE),0)),
                    
    height = paste0(round(mean(reported_length_cm, na.rm = TRUE),0), " ± ",
                    round(sd(reported_length_cm, na.rm = TRUE),0)),
  )

# Create gt table
tb <- demo_summary %>%
  gt()

# Display inline
tb %>%
  as_raw_html() %>%
  display_html()

# display_markdown("#### We were able to reproduce means and SD! We also found out that the weight summary was actually from force plate data.")


options(repr.plot.width = 9, repr.plot.height = 4.5)

# just for plotting, let's pivot the level_slow and level_walk to look at their distributions together
demo_hist = demo_clean %>% pivot_longer(cols = c(level_slow, level_walk), names_to = "MetCost_cond",values_to = "MetCost_val")

# visualize distributions using geom_histogram
ggplot(data = demo_hist, aes(x = MetCost_val, y = after_stat(count), fill = MetCost_cond)) + 
geom_histogram(bins = 8,alpha = 0.4, show.legend = FALSE) + 
labs(title = "metabolic cost distribution", x = "met cost (units)") +
facet_grid(~MetCost_cond) + 
theme_cleveland() + thm


# Read in calculated dataset
data_calc <- read.csv("calcData.csv")
# data_calc = data_calc %>% filter(Sub!="Sub4")
head(data_calc)

# first make sure there in fact are complete paired observations
table(data_calc$speed)

# See the data structure
data_calc %>% count(Sub, speed)

# remove non-complete cases
data_calc2 = data_calc %>% filter(Sub!="Sub12")

# Compare C_meas between speeds 0.8 and 1.3
slow_speed <- data_calc2 %>% filter(speed == 0.8) %>% pull(C_meas)
fast_speed <- data_calc2 %>% filter(speed == 1.3) %>% pull(C_meas)

# Paired t-test
result <- t.test(slow_speed, fast_speed, paired = TRUE)
print(result)

simple_anova_model <- aov(C_meas ~ incline, data = data_calc2)
summary(simple_anova_model)

rm_anova_model <- aov(C_meas ~ incline + Error(Sub/incline), 
                   data = data_calc2)

summary(rm_anova_model)

data_calc2 %>% 
 with(cor.test(C_meas, adjVO2, method = "pearson"))

options(repr.plot.width = 7, repr.plot.height = 7)

cor_plot <-

ggplot(data = data_calc2, aes(x = adjVO2,y = C_meas)) + 
 geom_point(size = 2) + geom_smooth(formula = 'y~x',method = "lm") + 
 # the stat_cor function from ggpubr is a neat way to add correlation values on the plot itself
 stat_cor(method = "pearson", size = 7, col = "blue") + 
 labs(title = "VO2 and metabolic cost are correlated", y = "Metabolic Cost", x = "adj. VO2") + 
 theme_classic2() + thm

# cor_plot
ggMarginal(cor_plot, type = "histogram")


lm_fit <- lm(C_meas ~ incline * speed, data = data_calc)
summary(lm_fit)

#ooh, btw, check this out:
display_markdown("#### BTW, if you ran an ANOVA of this linear model, it would give you the exact same estimates as your original ANOVA!")
anova(lm_fit)

par(mfrow = c(2,2))
plot(lm_fit)

# WE can also print out the exact values and indices of the influential observations
cooksd <- cooks.distance(lm_fit)
influential <- which(cooksd > 4/nrow(data_calc))
print(paste("Influential observation #", influential, "C Meas is", cooksd[influential]))

regression_table = tab_model(lm_fit, show.stat = TRUE,
                            dv.labels = "Measured Metabolic Cost")

display_html(head(regression_table$page.complete))

# Estimated marginal means for speed - the same as were compared by the t-test
speed_means <- emmeans(lm_fit, specs =  ~ speed)
speed_means

pairs(speed_means)

display_markdown("------------")
# Estimated marginal means for incline - the same as were compared by the ANOVA
incline_means <- emmeans(lm_fit, ~ incline)
incline_means

pairs(incline_means)

display_markdown("------------")
# Estimated marginal means for both factors - "splits" them by these two factors
speed_by_incline_means <- emmeans(lm_fit, ~ speed | incline)
speed_by_incline_means

display_markdown("------------")
# Plot estimated marginal means
plot_model(lm_fit, type = "pred", terms = c("incline", "speed")) + thm

# With adjustment for multiple comparisons
pairs(incline_means, adjust = "fdr")

display_markdown("------------")
pairs(incline_means, adjust = "bonferroni")

# check levels (what comes first, second and third)
factor(data_calc$incline) %>% levels()
# incline_means
contrast(incline_means, 
         list("Uphill - Downhill" = c(1, 0, -1),    # Compare uphill to downhill
              "Uphill - Level" = c(0, -1, 1)))      # Compare uphill to level
