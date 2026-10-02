# clear workspace
rm(list=ls())

# specify libraries you want to load 
# (use install.packages if you want to install)
ReqdLibs = c("here","ggplot2","dplyr")

# apply the "library" function to get dynamically load all the required libraries
lapply(ReqdLibs, library, character.only = TRUE)

# find working directory root using 'here' function
folder_path = here()
# print that path to the console
folder_path

# check the type of variable folder_path is
class(folder_path)

# append the path to a specific data folder and a 
file_path = here("data", "data.csv")
file_path

# list all the packages that were being used, even the ones you don't explicitly call
search()

### I am just making a