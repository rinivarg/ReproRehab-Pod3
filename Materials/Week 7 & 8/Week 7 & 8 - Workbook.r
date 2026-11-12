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

ReqdLibs = c("here","ggplot2","dplyr","tidyr","stringr","janitor","broom","emmeans")
invisible(lapply(ReqdLibs, library, character.only = TRUE))

# --------------------------------------------------
# Check and set data directory
#  Recap Week 1 learning  
# We want to know where we are and where we need to get the data from.
# --------------------------------------------------


# --------------------------------------------------
# Import data
#  Recap Week 2 learning  
# We need some place to put the data and we don't want to read each file one by one.
# --------------------------------------------------


# --------------------------------------------------
# Data wrangling
#  Recap Week 3 learning  
# We need some identifiers for plotting. We also don't want to plot all the variables one by one.
# --------------------------------------------------


# --------------------------------------------------
# Visualize data
#  Recap Week 4 learning  
# We need an initial version of a plot where we can see all our data as means and standard errors. We want its appearance to be large and clear enough to be visible to the (relatively old) human eye.
# --------------------------------------------------


# --------------------------------------------------
# Advanced data wrangling
#  Recap Week 4 learning  
# What's the problem with the plot above?
# --------------------------------------------------


# --------------------------------------------------
# ***
# What did you find from visual analysis of the data?
# --------------------------------------------------


# --------------------------------------------------
# Statistics
#  Recap Week 5 learning  
# We want to compare if some of these measures are significantly different between the 3 sessions.
# --------------------------------------------------


# --------------------------------------------------
# Conclusion
# What did you find?
# --------------------------------------------------


