# # Week 3: Clean and Merge Data
# 
# In Week 2, we combined individual raw data files into one comprehensive table. Now, we will merge this table with additional data, such as demographics, to prepare for analysis.
# 
# Currently, the table is in **long** format: time points are nested within each trial, and trials are nested within each subject (see figure for wide vs long formats).
# 
# This lesson will cover:
# 1. Basic data cleaning
# 2. Converting between long and wide data formats
# 3. Merging with a separate demographic table
# 4. Aggregating the data table
# 5. Using plots for data validation<br><br>


# ## Clean the entire workspace
rm(list=ls())


# ## Load required libraries
ReqdLibs = c("here","ggplot2","ggthemes","dplyr","tidyr","corrplot","readxl","IRdisplay")
invisible(lapply(ReqdLibs, library, character.only = TRUE))

wd <- here("Materials", "Week 3")
setwd(wd)


# ## Theme defaults
thm = theme(
          strip.text.x=element_text(size=20,face="bold"),
          strip.text.y=element_text(size=20,face="bold"),
          legend.text=element_text(size=16,face="bold"),
          legend.position = "top",
          legend.title=element_text(size=16,face="bold"),
          title =element_text(size=14, face='bold'),
          text = element_text(colour = "black",size=18),
          plot.title = element_text(colour = "black",size = 22, face = "bold"),
          axis.ticks.length = unit(0.3,"cm"),
          axis.line = element_line(colour = "black",linewidth = 0.85),
          axis.ticks = element_line(colour = "black",linewidth = 0.85),
          axis.text = element_text(colour = "black",size=24),
          axis.title=element_text(size=25))


# ## Read data
# I previously saved the parent data set as a `.csv` I am now reading it in here.
data.all=read.csv("raw.data.all.csv")
head(data.all)

# ## Start by visualizing
# Plots across the time series by subject
ggplot(data.all,aes(x=t,y=VO2,color=trial))+
  geom_point()+
  geom_line()+
  facet_wrap(~Sub) + thm

# ## Some initial issues
# ### Issue 1: R naming convention
# R still thinks my subjects are listed based on the value of the first integer. We need to change this first so it displays numerically.

class(data.all$Sub)
levels(data.all$Sub)
data.all$Sub=factor(data.all$Sub, levels = c("Sub1","Sub2","Sub3","Sub4",
                                            "Sub5", "Sub6","Sub7","Sub8",
                                            "Sub9","Sub10","Sub11","Sub12",
                                            "Sub13"))



#This is more desireable anyway because a factor class is treated as a categorical variable 
# when you run regressions or other statistical analyses.
class(data.all$Sub)
levels(data.all$Sub)


# ### visualize again after fixing this issue
#Fixed
ggplot(data.all,aes(x=t,y=VO2,color=trial))+
  geom_point()+
  geom_line()+
  facet_wrap(~Sub) + thm


# ### Issue 2: Inconsistent number of points across trials
# Sub 2 took way more time than everyone else on trial 5. I am going to assume
# that doesn't warrant throwing that subjects data out, and instead I will just
# trim the excess away.
 
# To do that, let's first see how much of the extra to remove. Let's look at how long all subject's trial 5 was. The function aggregate will provide some summary stat based on how I want the dataset aggregated. Here I just want the max time for trial 5 across all subjects. To reduce the output I just index the data.all to only include trial 5. Looks like Sub 2 did 873 seconds, and everyone else did ~440

aggregate(t ~ Sub, data.all[data.all$trial=="trial 5", ], max)  #%>% mutate(a = median(.$t))


# ### trim the data
# I am going to remove all t for Sub 2 greater than 440. I am going to use a method called negation `!()`. Here I put in a bunch of boolean arguments into `()` and then preceed it with a `!`. This removes all the rows in my dataset that match these conditions.

# Note that if I removed the !() it would only return the trial 5, for Sub2 with t > 440
# using base R
data.all2 = data.all[!(data.all$trial=="trial 5" & data.all$Sub=="Sub2" & data.all$t>440),]
head(data.all2)

# using dplyr
data.all2 <- 
data.all %>%
  filter(!(trial=="trial 5" & Sub=="Sub2" & t>440))
head(data.all2)

# ### visualize again after fixing the issue
#Fixed
ggplot(data.all2,aes(x=t,y=VO2,color=trial))+
  geom_point()+
  geom_line()+
  facet_wrap(~Sub) + thm

#I could repeat this process again but let's move on.

# ## Pivoting: Converting data tables from long to wide format and vice versa
# 
# Now I am going to convert the data from long to wide format using the `pivot` functions in the tidyr library. This can be useful if I want to look at correlations between my behavioral variables.<br>
# There are various situations where one format is preferable to others. **Note**: when in doubt, remember the tidy data format; each row is an independent observation and each column is a variable of interest. You should <u>never stack numbers along rows of a column that do not share the same units</u>.
# 

# ### First, I am going to create an aggregate of the data
# This creates a summarized data set across our 4 outcome variables average across time for each subject for each trial

# using base R: 
data.agg = aggregate(cbind(VO2,Rf,VE,VT) ~ trial + Sub, data.all2, mean)
head(data.agg)

# using dplyr:
data.all2 %>%
    group_by(Sub, trial) %>%
    summarize(across(c(VO2, Rf, VE, VT), mean), .groups = "drop") -> data.agg
head(data.agg)
dim(data.agg)


# ### Next, let's "pivot" the data frame to a wide format
# along the trial variable

# Using the pivot_wider function from tidyr to create a new variable for each trial
data.agg.wide = pivot_wider(data.agg, names_from = trial,
                       values_from = VO2:VT, id_cols = Sub)

head(data.agg.wide)


# ### Visualizing correlations across trials using the wider format data

#create a correlation matrix with only complete observations,
#Can only include numeric variables.
cmat=cor(data.agg.wide[,-1],use="complete.obs")

#Let's visualize the correlations.
corrplot(cmat) + theme_minimal() + thm


# ### Now, let's pivot back to the long format

# Now let's convert our wide dataset back to long, just for fun.
data.agg.long <- pivot_longer(data.agg.wide,
                           cols = VO2_rest:`VT_trial 6`,
                           names_to = c(".value", "trial"),
                           names_sep = "_")
head(data.agg.long)


# ## Merge with Demographics
# Now that we have our data in a variety of formats we can now merge it with the demographic data.

demo = read_excel("SubjectInfo.xlsx")
head(demo)


# ### merging the demo data to the aggregate data in the long format
# Note that if the names of the reference variable (in this case subject ID) by which the two data frames are being merged are different then we have to call that explicitly.

demo.data = merge(data.agg, demo, by.x = "Sub",by.y = "Subject No")
head(demo.data)


# ### merging the demo data to the aggregate data in the wide format
# See how the demographic variables in the table above repeat themselves over the different trials for each subject. This is because the `merge()` function identifies that each subject has only 1 number for weight or height but it has 7 rows of trial-wise data. So it repeats them over these 7 rows. What type of table would be ideal to merge with the demographic table?...where all of the trials for one subject are in a single row? The wide format!<br><br>

# So, let's combine the demographic data with our previously created `data.agg.wide` dataframe.

demo.data_wide = merge(data.agg.wide, demo,by.x = "Sub",by.y = "Subject No")
head(demo.data_wide)


# ### now let's plot one of the demographic variables against one of the metabolic variables
# We're plotting weight against VO2 from trial 3. You see how a wide data format can be useful for correlations and scatterplots of this type where 1 row has data unique to 1 subject.

options(repr.plot.width = 6, repr.plot.height = 6)
ggplot(data = demo.data_wide, aes(x = `Weight from force plates(kg)`,y = `VO2_trial 3`)) + 
geom_point(size = 4) + geom_smooth(method = "lm", formula = y~x) + theme_minimal() + thm


# ### Let's pivot the aggregate data again to look at all variables in one column

demo.data.var.long = pivot_longer(demo.data,
                               cols = VO2:VT,
                               names_to = "Variable",
                               values_to = "Value")

head(demo.data.var.long)
dim(demo.data.var.long)

options(repr.plot.width = 16, repr.plot.height = 8)
ggplot(demo.data.var.long,aes(x=trial,Value,color=Gender))+
  geom_boxplot()+
  facet_wrap(~Variable,scales = "free") + thm


# ## The End
