<img src="ReproRehab-05.png" align = "right" width = "300"><br>
# ReproRehab POD-3 (2026-27)
*TAs: Chad Aldridge and Rini Varghese*<br>
Learn more about ReproRehab here: https://www.reprorehab.usc.edu

# Getting Started  
Welcome Pod 3! We have created a GitHub repository as a centralized location to store and share all the materials/code/resources discussed during the bootcamp. To get started with using this repository, follow 3 steps:<br><br>
**Step 1**: Fork this repository by clicking [here](https://github.com/rinivarg/ReproRehab-Pod3/fork)<br>
**Step 2**: Download and install `git` on your computer [here](https://git-scm.com/downloads)<br>
**Step 3**: Clone this repository locally to your computer by following instructions [here](https://github.com/rinivarg/ReproRehab-Pod3/blob/main/Git%20and%20GitHub/Github%20integration%20in%20Rstudio%20-%20How%20to%20download%20the%20repo%20into%20Rstudio%20and%20keep%20it%20updated%20on%20your%20local%20machine..pdf) <br>

You will now be able to access all the code and materials and follow along each week.<br>
Live session recordings can be found here: [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat&logo=youtube&logoColor=white)](https://youtube.com/playlist?list=PLX8sMF8_Ee24&si=gzmmFhblVSvyOmHL)

# Overview of the Course
Each week, we will share a **“codebook”** that contains the code and explanations for what we covered in class. To make it accessible, the codebook will be available in three formats:  

1. **`.R` format**: A script that can be run in RStudio. Contains the same code with comments, but without the step-by-step explanations and outputs.  

2. **`.ipynb` format (Jupyter Notebook)**: An interactive notebook with code and explanations. Run it step-by-step, view outputs, and read notes. Open locally in Jupyter (install <a href="https://youtu.be/BQ-aM3ULKYs?si=5DmHN1956TxVTE-s&t=160" target="_blank">tutorial</a>) or in **Google Colab**.[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com)  

3. **`.pdf` format**: A static version of the notebook with code and explanations, but not interactive.


# Curriculum
Below is the curriculum which shows the week-wise breakdown of the topics we will cover. Everything on here is subject to change as the needs of the pod evolve. Looking forward to 8 weeks of learning and teamwork!

<details>
  <summary>Click to expand</summary>
  
## [Week 1](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%201): Tutorial on R/Rstudio and “Cheatsheets”
This lesson introduces learners to [R](https://cran.r-project.org) and [RStudio](https://posit.co/downloads/), including how to use built-in functions, how to start with a clean workspace, install packages, and avoid namespace collision when dealing with R packages. A handy way to orient yourself to popular packages is through [“Cheatsheets”](https://posit.co/resources/cheatsheets/). 
<br><br>
![Note](https://img.shields.io/badge/-NOTE-blue) **In WEEKS 2-5, we will use the [`data`](https://zenodo.org/records/1973799) that the authors of this [`paper`](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0222037#pone-0222037-g005) generously shared with us!** Doing so gets us right into real messy data, understand its structure, import it, clean and manipulate it, and finally visualize and analyze it.
<br>
## [Week 2](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%202): Importing Data into R
The first step to using R for research is to import one’s data in R’s memory. There are good base functions to import basic file types such as .csv files, but many times the format and file type of the data we wish to import can vary in a way base functions in R do not support. This week we’ll cover importing data from common formats, use non-base R packages to do so when appropriate, and cover 3 methods to programmatically listing and reading files from subfolders.

## [Week 3](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%203): Data Cleaning and Manipulation
Once data is loaded into R it rarely is in the structure or format that is ready for analysis. In this lesson we will provide the best practices for handling missing data, converting data into different variable types, and converting data from wide to long and from long to wide formats.

## [Week 4](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%204): Summarizing and Visualizing Data
A good sanity check before plugging in your now clean and formatted data into a statistical model is to visualize it. This is good for a priori check of outliers, normality, and overall trends you may or may not expect. We will also present methods for compiling data into modifiable demographic tables that are publication ready.

## [Week 5](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%205): Statistical Analysis
Now that you have imported, cleaned, manipulated, and visually checked your data you are ready to confidently analyze it. In this lesson we will learn how to run general and generalize linear models for statistical analysis. Additionally, we will go over how to use a library specific for mixed effects models for repeated measures designs and the incorporation of random effects.

## [Week 6]: Text Analysis with R
NEW THIS YEAR! In this lesson, we will introduce the basics of working with text data in R. Learners will explore methods for mining, cleaning, preprocessing, and visualizing textual data using tools such as `stringr`. We will also provide an introductory overview of natural language processing (NLP) concepts and tools in R.

## [Week 7 & 8](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%207%20%26%208): Personalized Lessons!!
We have now covered the basics on all things R that are necessary for reproducible research in rehabilitation science. Now it is your turn to tell us what you would like to learn next! Don’t be afraid to think big or aim for a deep dive into one specific area! Even if it is something that we are unfamiliar with, will make sure to connect you with someone in the ReproRehab cohort that can help!

## Bonus Content: 
### [Intro to Git & GitHub](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Git%20and%20GitHub):
You've probably heard by now about GitHub for sharing your code and data, but it's much more than that! In fact, Git (the software that the GitHub platform uses) is first and foremost a version-control tool. Through that very function, it allows you to travel in time on some version of your own code *and* collaborate with others on the same code without needing to have a million versions (e.g., code_FINAL_RV, code_FINAL_RV_AH, code_FINALFINAL_AH_RV_RV2024... lol, you get the gist). <br> 

### [Codebooks and Cloud Computing](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Codebooks%20and%Cloud%20Computing):
You now have the makings of a working analytical pipeline that fits your data and your research question. One day you will want to share it with the world! In this lesson we will present different methods for sharing your code either a vignette or notebook that makes your work accessible to a variety of audiences.

****
</details> 
