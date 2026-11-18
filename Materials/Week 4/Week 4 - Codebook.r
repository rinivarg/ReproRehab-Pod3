rm(list = ls())

#setwd("Materials/Week 4/")

ReqdLibs = c("readxl","ggplot2","ggthemes","dplyr","tidyr","forcats","janitor","IRdisplay","patchwork","png")

# note if you have not installed any of the packages above, 
# in the line below change 'library' to 'install.packages' then switch it back to 'library'
invisible(lapply(ReqdLibs, library, character.only = TRUE))

ggplot(data = mpg)

ggplot(mpg, mapping = aes(x = cty, y = hwy))

ggplot(mpg, aes(cty, hwy)) +
  # to create a scatterplot
  geom_point() +
  # to fit and overlay a loess trendline
  geom_smooth(formula = y ~ x, method = "lm")

ggplot(mpg, aes(cty, hwy, color = class)) +
  geom_point() +
  scale_colour_viridis_d()

ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  facet_grid(year ~ drv)

ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  coord_fixed()

ggplot(mpg, aes(cty, hwy, colour = class)) +
  geom_point(size = 4) +
  theme_minimal() + 
  theme(
    legend.position = "top",
    legend.text=element_text(size=16,face="bold"),
    axis.line = element_line(linewidth = 0.75),
    axis.text = element_text(colour = "black",size=35),
    text = element_text(colour = "black",size=35)
  ) 


ggplot(mpg, aes(cty, hwy)) +
  geom_point(mapping = aes(colour = displ)) +
  geom_smooth(formula = y ~ x, method = "lm") +
  scale_colour_viridis_c() +
  facet_grid(year ~ drv) +
  #coord_fixed() +
  theme_tufte() +
  theme(
    legend.position = "top",
    legend.text=element_text(size=16,face="bold"),
    axis.line = element_line(linewidth = 0.75),
    axis.text = element_text(colour = "black",size=20),
    text = element_text(colour = "black",size=20)    
  )

dat.raw = read.csv(file = "rawdata.csv", header = TRUE)
head(dat.raw)
dim(dat.raw)

# reorder the Sub factor so that it is sorted numerically rather than alphabetically

# fct_reorder is in the forcats package which does not rely on 'exact' names for reordering
# gsub or global substitution funcn that looks for a specific text pattern (regex) and replaces it 
# (kind of like ctrl F & replace)
dat.raw$Sub <- fct_reorder(dat.raw$Sub, as.numeric(gsub("Sub", "", dat.raw$Sub)))
levels(dat.raw$Sub)

# based on above, we define trial number (conditions) that match the incline and speeds
# these are 'condition sets' which we will call when we apply conditional logics next.

# inclines
lev = c("1","2")
uph = c("3","4")
dwh = c("5","6")

# speeds
fs = c("1","3","5")
sl = c("2","4","6")


data.def <- dat.raw %>% 
# so we can refer to those trial conditions more succinctly 
# let's separate these characters into workable parts
separate(trial,into=c("prefix","num"), sep = " ",fill="right",remove = FALSE) %>%  

# "rest" level is different from other trials (format: prefix + num), 
# so we fill out the new variable num with "rest"
mutate(num = if_else(prefix == "rest", prefix, num)) %>% 

# now we are ready to define some new informative variables from our non-informative variable "num"
mutate(cond = if_else(num == "rest", num, "walk"),
       
       incline = case_when(num %in% lev ~ "level",
                           num %in% uph ~ "uphill",
                           num %in% dwh ~ "downhill",
                           num == "rest" ~ "rest",
                           TRUE ~ NA_character_),
       
       speed = case_when(num %in% fs ~ 1.3,
                         num %in% sl ~ 0.8,
                         cond == "rest" ~ 0,
                           TRUE ~ NA_real_)) %>% 
# remove unwanted variables
select(!c("X","prefix","num"))# %>% 

# assign to a new 'defined' data frame
#{.->> dat.def}

tail(dat.def)


rmv.rest = 30
rmv.walk = 3*60

dat.def %>% 
filter(case_when(cond == "rest" ~ t > rmv.rest,
                 cond == "walk" ~ t > rmv.walk,
                 TRUE ~ FALSE)) %>% 
group_by(Sub,cond,incline,speed) %>% 
summarize_if(is.double, ~ mean(., na.rm = TRUE)) %>% 

{.->>dat.summ}

head(dat.summ,7)

# VO2 in our data table is absolute VO2, to normalize it by the weight of each subject, 
# we need weight data from the demographic excel file!
# read excel file

demo=read_xlsx("SubjectInfo.xlsx")

tail(demo)

# TIP! you could use clean_names function from the janitor package
# to clean var names so that they don't contain spaces and parentheses.. 
# also makes it easyt to use dplyr to mutate later #uncomment below

demo.clean = demo %>% janitor::clean_names()
dat.summdemo = merge(dat.summ,demo.clean,by.x = 'Sub', by.y = 'subject_no')

head(demo.clean)

dat.summdemo %>% 
mutate(adjVO2 = VO2/reported_weight_kg) %>% 
mutate(W = 4.184/60 * (3.972 + 1.078 * R) * adjVO2) %>% 
{.->>dat.calc1}

head(dat.calc1)

# extracting the rest trials only so we can merge it as a column next
dat.calc1 %>% 
filter(cond=="rest") %>% 
select(Sub,W) %>% 
{.->>dat.rest}

# now merging it with the original 
merge(dat.calc1,dat.rest,by='Sub',suffixes = c('','_rest')) %>% 
filter(cond!="rest") %>% 
mutate(W_adj = W - W_rest) %>% 
mutate(C_meas = W_adj/speed) %>% 
{.->>dat.calc2}

head(dat.calc2)

thm = theme(
          plot.title = element_text(colour = "black",size = 35, face = "bold", hjust = 0.5),
          axis.ticks.length = unit(-0.3,"cm"),
          axis.line = element_line(colour = "black",size = 1),
          axis.ticks = element_line(colour = "black",size = 1),
          axis.text = element_text(colour = "black",size = 35),
          axis.text.x = element_text(lineheight = 1.1, margin = margin(t = 20)),
          axis.title.y = element_text(size=35, colour = "grey35", face = "plain", 
                                     lineheight = 1.1, margin = margin(r = 10)))

repro.fig = 
# FUNCTION CALL
ggplot(dat.calc2, aes(x = incline, y = C_meas, group = speed, label = speed)) + 

# LAYERS THAT SUMMARIZE WHILE PLOTTING! - this is one of the most powerful features of ggplot
stat_summary(geom = "bar", fun = mean, col = NA, fill = "black", width = 0.7, na.rm = TRUE,
             position=position_dodge(width = 0.82, preserve = 'single')) + 
stat_summary(geom = "errorbar",fun.data = mean_cl_boot, width = 0.15, lwd=2.5, col="darkgray", na.rm = TRUE,
            position=position_dodge(0.82, preserve = 'single')) + 
stat_summary(geom = "text", fun.y = mean, position = position_dodge(0.8, preserve = 'total'), na.rm = TRUE,
             vjust = -1.25, size = 10) +

# AXIS LIMITS
coord_cartesian(ylim = c(0.31,6.75)) + 

# LABELS
scale_x_discrete(labels = c("Downhill", "Level", "Uphill")) +  # capitalize label initials :/
labs(title = "Pulmonary Gas Exchange", x = "", y = "Measured Metabolic\nCost [J/kg/m]") + 
theme_classic() + thm

repro.fig


# saving your figures as image files
ggsave(file='reproduced_figure.tiff', plot=repro.fig, width=12, height=8)
