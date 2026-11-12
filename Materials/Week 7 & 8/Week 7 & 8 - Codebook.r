# --------------------------------------------------
# Week 7 & 8: Putting it all together!
# --------------------------------------------------

# --------------------------------------------------
# Clear the entire workspace
# --------------------------------------------------

rm(list=ls())

# --------------------------------------------------
# Load libraries
# --------------------------------------------------

ReqdLibs = c("here","ggplot2","dplyr","tidyr","stringr","janitor","broom","emmeans","ggthemes")
invisible(lapply(ReqdLibs, library, character.only = TRUE))

# --------------------------------------------------
# Check and set data directory
#  Recap Week 1 learning  
# We want to know where we are and where we need to get the data from.
# --------------------------------------------------

# let's look at our current directory
folder_path = getwd()

# we need to navigate into one more layer to read the data files
subfolder_path = paste0(folder_path,'/data/')

# list all the files within the 'data' folder
file_list =list.files(subfolder_path)

# take a look to make sure the files you're expecting in the data folder are present
file_list

# --------------------------------------------------
# Import data
#  Recap Week 2 learning  
# Let's start by importing one file in to see what lines of code we need.
# Then, we will do this recursively using for-loops.
# --------------------------------------------------

# --------------------------------------------------
# What lines of code do we need per file?
# Run everything for the first file to get a sense for all the steps
# --------------------------------------------------

# paste strings to create a file_path for the first item in the file_list
file_path0 = paste0(subfolder_path,file_list[1])

# read in that first file using the read.delim function
temp0 = read.delim(file_path0)

# pasting strings from the first and fourth row in the
# for use as new column names next
new_names = paste(temp0[1,],temp0[4,])

# change column names to these new names
colnames(temp0) = new_names

# remove those initial 4 rows because they are no longer useful
temp1 = temp0[-c(1:4),]

# at this time, also clean up these names so there are no spaces.
# we will use the clean_names function from the janitor package
temp1 = clean_names(temp1)

# rename first column to %gait
colnames(temp1)[1] = "perc_gait"

# convert to numeric
temp1[,-1] = apply(temp1[,-1],2,as.double)

# change data table into tibble (it's currently in vectors format)
temp1 = as_tibble(temp1)

# write a temporary variable that can help you assign identifiers (trial, session etc.)
temp1$fileName = substr(file_list[1],1,nchar(file_list[1])-4)

# have a look at your data
head(temp1,5)

# NOTE!!! This is one single file that you have read in so far.
# Next, we will read in all files recursively.

# --------------------------------------------------
# NOTE!!!  This is one single file that you have read in so far.  
# But now we have all the lines of code you will need next when we will read in all files recursively.
# --------------------------------------------------

# --------------------------------------------------
# create an empty dataframe
# We will need some place to put the data.
# --------------------------------------------------

# preallocate an empty data frame which you will recursively fill in with data
data.raw = data.frame(list())

# --------------------------------------------------
# recursively read in files from the data directory
# Use a for-loopto do this. What's another way?
# --------------------------------------------------

  for(j in 1:length(file_list)){

    # paste strings to create a file_path from where we will read data
    file_path =  paste0(subfolder_path,file_list[j])

    # read each file in file_list
    temp = read.delim(file_path)

    # change column names
    colnames(temp) = paste(temp[1,],temp[4,])

    # remove first few (now) unnecessary rows
    temp = temp[-c(1:4),]

    # clean names
    temp = clean_names(temp)

    # rename first column to %gait
    colnames(temp)[1] = "perc_gait"

    # convert to numeric
    temp[,-1] = apply(temp[,-1],2,as.double)

    # change data table into tibble (it's currently in vectors format)
    temp = as_tibble(temp)

    # write a temporary variable out of the file names which will help
    # you assign identifiers (trial, session etc.)
    # without this variable, we can't discern the different trials or sessions
    temp$fileName = substr(file_list[j],1,nchar(file_list[j])-4)

    # combine data imported from different files into a single dataframe
    data.raw =rbind(data.raw,temp)

  }

# have a look at your data.raw dataframe
head(data.raw,7)

# that's it! you have your rawest form of data. Next, clean it!

# --------------------------------------------------
# Data wrangling
#  Recap Week 3 learning  
# We need some identifiers for plotting. We also don't want to plot all the variables one by one.
# --------------------------------------------------

# --------------------------------------------------
# add identifiers
# the main line of code below is the separate function that will separate the fileName "QA1T1Barefoot1" by the underscore into "QA", "T1" & "Barefoot1". 
# We will define these three parts into new variables:
# 1) the initial "QA" part will be the variable "prefix." We will remove this variable later because it's not that useful to us.
# 2) the "T1" part will be variable session. This is important because we care about comparing between sessions.
# 3) the "Barefoot1" part will be the variable "trial"
# --------------------------------------------------

# let's create some new variables using the fileName variable in data.raw
data.raw %>%
# below `separate` func will separate "QA_T1_Barefoot1" by the "_" separator
separate(fileName,into=c("prefix","session","trial"), sep = "_",fill="right",remove = TRUE) %>%
# Now, we can remove the "QA" prefix variable
select(!c("prefix")) %>%
{.->>data.clean}

head(data.clean)

# now we have a clean version of our code and we can use this to
# plot the variables one by one.

# --------------------------------------------------
# manipulate the data
# Convert it to long format so you can next plot all variables at once
# --------------------------------------------------

# let's
data.clean %>%
# I removed the "normalized torque" variables here because they didn't indicate
select(!starts_with(match = "norm_")) %>%
pivot_longer(cols = where(is.numeric), names_to = "measure", values_to = "value") %>%
{.->> data.clean.longPlot}

data.clean.longPlot$perc_gait = as.numeric(data.clean.longPlot$perc_gait)
head(data.clean.longPlot)

# --------------------------------------------------
# Visualize data
#  Recap Week 4 learning  
# We need an initial version of a plot where we can see all our data as means and standard errors. We want its appearance to be large and clear enough to be visible to the (relatively old) human eye.
# --------------------------------------------------

# --------------------------------------------------
# set theme in advance so you can use it next
# --------------------------------------------------

thm = theme(plot.title = element_text(size = 40),
          legend.title = element_text(size = 25),
          legend.position = "top",
          legend.text = element_text(size = 20),
          strip.text = element_text(size = 35),
          axis.ticks.length = unit(0.3,"cm"),
          axis.line = element_line(colour = "black",linewidth = 1),
          axis.ticks = element_line(colour = "black",linewidth = 1),
          axis.text = element_text(colour = "black",size = 40),
          axis.text.x = element_text(lineheight = 1.1, margin = margin(t = 10)),
          axis.title.x = element_text(size=40, colour = "grey35", face = "plain",
                                     lineheight = 1.1, margin = margin(r = 10)),
          axis.title.y = element_text(size=40, colour = "grey35", face = "plain",
                                     lineheight = 1.1, margin = margin(r = 10)))

custom_colors <- c("#e41a1c", "#13388e", "#03ac13")

# --------------------------------------------------
# plot all variables at once from the long format data
# What's one problem with this plot?
# --------------------------------------------------

options(repr.plot.width = 40, repr.plot.height = 40)
all_vars =
ggplot(data.clean.longPlot, aes(x = perc_gait,y = value,
                                group = session, col = session, fill = session)) +
stat_summary(geom = "line", fun = mean, na.rm = TRUE) +
stat_summary(geom = "ribbon",fun.data = mean_se, na.rm = TRUE,alpha=0.3) +
  scale_color_manual(values = custom_colors) +
  scale_fill_manual(values = custom_colors) +
xlab("% gait cycle") + ylab("") +
facet_wrap(~measure, scales = "free") +
theme_clean() + thm
all_vars

# ggsave(file='all_vars.svg', plot=all_vars, width=35, height=35)

# --------------------------------------------------
# Advanced data wrangling
#  Recap Week 4 learning  
# More data manipulation using conditional sets to define new identifiers for the variable variable
# --------------------------------------------------

# --------------------------------------------------
# define conditional sets
# --------------------------------------------------

# side of measure
sd = c("left","right")
# segment measured
sg = c("foot", "ankle","knee","hip","pelvis","trunk","grf")
# coordinate
cd = c("x","y","z")

# --------------------------------------------------
# use conditional sets to define new variables side, segment, and coordinate
# Let's take the long format of the data and separate the "measure" variable
# into bits that are useful - e.g., the side, the segment, and the coordinate
# --------------------------------------------------

data.clean.longPlot %>%

  # an important note: i needed to know in advance how many
  separate(measure,
           into = c("part1", "part2", "part3", "part4", "part5"),
           sep = "_", extra = "merge", fill = "right",remove = FALSE) %>%

  mutate(side = case_when(part1 %in% sd ~ part1, part2 %in% sd ~ part2,
                          part3 %in% sd ~ part3, TRUE ~ NA_character_),

            # once moved, replace orig cells with NA
            part1 = if_else(part1 %in% sd, NA_character_, part1),
            part2 = if_else(part2 %in% sd, NA_character_, part2),
            part3 = if_else(part3 %in% sd, NA_character_, part3),


        segment = case_when(part1 %in% sg ~ part1, part2 %in% sg ~ part2,
                            part3 %in% sg ~ part3, TRUE ~ NA_character_),

            # once moved, replace orig cells with NA
            part1 = if_else(part1 %in% sg, NA_character_, part1),
            part2 = if_else(part2 %in% sg, NA_character_, part2),
            part3 = if_else(part3 %in% sg, NA_character_, part3),

        coord = case_when(part3 %in% cd ~ part3, part4 %in% cd ~ part4,
                           part5 %in% cd ~ part5, TRUE ~ NA_character_),

            # once moved, replace orig cells with NA
            part3 = if_else(part3 %in% cd, NA_character_, part3),
            part4 = if_else(part4 %in% cd, NA_character_, part4),
            part5 = if_else(part5 %in% cd, NA_character_, part5),

        measure = if_else(is.na(part3),'force',part3)) %>%

select(!c("part1", "part2", "part3", "part4", "part5")) %>%

{.->>data.sorted.long}
head(data.sorted.long)

# --------------------------------------------------
# visualize again
# --------------------------------------------------

# --------------------------------------------------
# right body segments
# --------------------------------------------------

right_allVars =

ggplot(data.sorted.long %>% filter(side=="right"), aes(x = perc_gait,y = value,
                                group = session, col = session, fill = session)) +
stat_summary(geom = "line", fun = mean, na.rm = TRUE) +
stat_summary(geom = "ribbon",fun.data = mean_se, na.rm = TRUE,alpha=0.3) +
  scale_color_manual(values = custom_colors) +
  scale_fill_manual(values = custom_colors) +
xlab("% gait cycle") + ylab("") + ggtitle("RIGHT BODY SEGMENTS") +
facet_wrap(segment~coord, scales = "free") +
theme_clean() + thm

right_allVars

# ggsave(file='right_allVars.svg', plot=right_allVars, width=35, height=35)

# --------------------------------------------------
# left body segments
# --------------------------------------------------

left_allVars =
ggplot(data.sorted.long %>% filter(side=="left"), aes(x = perc_gait,y = value,
                                group = session, col = session, fill = session)) +
stat_summary(geom = "line", fun = mean, na.rm = TRUE) +
stat_summary(geom = "ribbon",fun.data = mean_se, na.rm = TRUE,alpha=0.3) +
  scale_color_manual(values = custom_colors) +
  scale_fill_manual(values = custom_colors) +
xlab("% gait cycle") + ylab("") + ggtitle("LEFT BODY SEGMENTS") +
facet_wrap(segment~coord, scales = "free") +
theme_clean() + thm

left_allVars

# ggsave(file='left_allVars.svg', plot=left_allVars, width=35, height=35)

# --------------------------------------------------
# **
# What did you find from visual analysis of the data?
# One observation is that across sessions T1, T2, and T3, the hip, pelvis, and trunk traces seem to be more 'apart' from one another compared to other more distal markers. Specifically:
#  On the RIGHT side segments:
#      hip x, y & z coord
#      pelvis x, y & z coord
#      trunk x coord
#      ankle y & z coord 
#  On the LEFT side segments:
#      hip x, y & z coord
#      pelvis x coord
#      trunk x coord
# --------------------------------------------------

# --------------------------------------------------
# Statistics
#  Recap Week 5 learning  
# At this point, you have to be very specific about what measures you are interested in comparing. For example, there maybe some markers and coordinates you don't care about or some others that you absolutely do care about. Decide that because it is time to compare those measures across the 3 sessions.
# --------------------------------------------------

# --------------------------------------------------
# Summarize long-form data
# For use in simple linear models next
# --------------------------------------------------

data.sorted.long %>%
group_by(perc_gait,session, side, segment, coord, measure) %>%
# summarize_if(is.double,list(mean = mean, se = parameters::standard_error),
#            .names = "{.col}_{.fn}") %>%
summarize_if(is.double, ~ mean(., na.rm = TRUE))  %>%
{.->>data.summ.long}
head(data.summ.long)

# --------------------------------------------------
# define segments that seemed most problematic during visual analysis
# --------------------------------------------------

# problem segments for both left and right side
prob_segs = c("ankle","foot","trunk","pelvis","hip")

# --------------------------------------------------
# Simple linear model
# --------------------------------------------------

# --------------------------------------------------
# for right body segments
# --------------------------------------------------

mod.right.x = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="right" & coord=="x"),
           value ~ session*segment)
mod.right.y = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="right" & coord=="y"),
           value ~ session*segment)
mod.right.z = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="right" & coord=="z"),
           value ~ session*segment)

# tidy(mod.right.x)
# glance(mod.right.x)
# glance(mod.right.y)
# glance(mod.right.z)

emm_interR.x = emmeans(mod.right.x, ~session|segment)
emm_interR.y = emmeans(mod.right.y, ~session|segment)
emm_interR.z = emmeans(mod.right.z, ~session|segment)

pairs(emm_interR.x, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)
pairs(emm_interR.y, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)
pairs(emm_interR.z, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)

# --------------------------------------------------
# for left body segments
# --------------------------------------------------

mod.left.x = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="left" & coord=="x"),
           value ~ session*segment)
mod.left.y = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="left" & coord=="y"),
           value ~ session*segment)
mod.left.z = lm(data = data.summ.long %>% filter(segment %in% prob_segs & side=="left" & coord=="z"),
           value ~ session*segment)

# tidy(mod.left.x)
# glance(mod.left.x)
# glance(mod.left.y)
# glance(mod.left.z)

emm_interL.x = emmeans(mod.left.x, ~session|segment)
emm_interL.y = emmeans(mod.left.y, ~session|segment)
emm_interL.z = emmeans(mod.left.z, ~session|segment)

pairs(emm_interL.x, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)
pairs(emm_interL.y, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)
pairs(emm_interL.z, by = "segment") %>% tidy %>% filter(adj.p.value<0.05)

# --------------------------------------------------
# Conclusion
# What did you find?
# I found that across sessions:
#  Horizontal (side-to-side,x coord) placement of:
#       PELVIS markers varied by 3.5-6.5 cms
#       TRUNK markers varied by 5-8 cms
#  Vertical placement (up-down, y coord) of:
#       HIP markers varied by 2-7 cms,
#       PELVIS markers varied by 3-4.5 cms
#       TRUNK markers varied by 1.6-2.3 cms, and
#       FOOT markers varied by 1.6-2.5 cms
#  Transverse placement (z coord) of:
#       ANKLE, HIP, and TRUNK markers varied by 2-3 cms, and
#       PELVIS marker varied by 3-5 cms
#  Recommendation* 
# Lab staff should receive training on marker placement especially for trunk, pelvis and hip. Additional measures could be taken to ensure the markers are not moving due to loose clothing, or arm/elbow knocking over markers.
# --------------------------------------------------

