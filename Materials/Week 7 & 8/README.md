## BIOMECHANICS Data Playground
If you would like to access to a recording or would like a workthrough of these data, please contact Rini.

## Data Description

To assess quality assurance of lab staff marker placement when performing a clinical gait analysis, we had a single patient with gait abnormalities perform barefoot walking trials <ins> 3 different times</ins> (a.k.a. `sessions`: T1, T2, T3). The researcher would apply markers per our typical marker set, the patient would perform <ins> 4-5 walking trials</ins> (a.k.a. `trials`: Barefoot1, Barefoot2, Barefoot3 etc.), and then the markers would be removed. This process was repeated 2 more times in the same lab visit. <br><br> So ideally, there should be minimal differences between the signals produced…but if there are large differences, this could point to marker placement inconsistencies that may need to be addressed.
So now, when you see the file names, hopefully it should make more sense. As far as the signals in the .txt files, it’s pretty messy the way that Visual 3D exports it with the file names and such at the top. But essentially, the following signals were exported in all 3 planes (X, Y, Z) and normalized to %Gait Cycle of the corresponding limb (hence the 101 “items”):<br>

`Left Ankle Angular Position + Left Foot Progression + Left Hip Angular Position + Left Knee Angular Position + LeftGRF + Norm Left Ankle Joint Power + Norm Left Ankle Joint Torque + Norm Left Hip Joint Power + Norm Left Hip Joint Torque + Norm Left Knee Joint Power + Norm Left Knee Joint Torque + Norm Right Ankle Joint Power + Norm Right Ankle Joint Torque + Norm Right Hip Joint Power + Norm Right Hip Joint Torque + Norm Right Knee Joint Power + Norm Right Knee Joint Torque + Pelvis Left Angular Position + Pelvis Right Angular Position + Right Ankle Angular Position + Right Foot Progression + Right Hip Angular Position + Right Knee Angular Position + RightGRF + Trunk Left Position + Trunk Right Position`  

The signals were exported in alphabetical order unfortunately, so the organization is a bit all over the place. I could also export actual marker trajectory position data, but I just began with these signals that are calculated in Visual 3D using model-based computation.

![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) 
${\color{red} Below\space\ is \space\ our \space\ research \space OBJECTIVE:}$ <br>
**Assess statistical differences between the 3 marker placement trials** <br>


## Pod 3 Playground
The following files are codebooks that <ins>we actively worked on in weeks 7 & 8</ins>. This might help jog your memory on the decisions we took along the way and the progress we made.
1) [Week_7&8_Workbook.IPYNB format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Workbook.ipynb)

2) [Week_7&8_Workbook.PDF format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Workbook.pdf)

3) [Week_7&8_Workbook.R format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Workbook.r)

## Solution Codebooks
The following files are codebooks with <ins>the complete solutions and detailed annotations</ins>. Also contains additional data wrangling, plotting, and statistics that we did not have a chance to get to in weeks 7 & 8. Recommended if you want to go further with the analysis of these data.
1) [Week_7&8_Codebook.IPYNB format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Codebook.ipynb)

2) [Week_7&8_Codebook.PDF format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Codebook.pdf)

3) [Week_7&8_Codebook.R format](https://github.com/rinivarg/ReproRehab2024-Pod3/blob/main/Materials/Week%207%20%26%208/Week%207%20%26%208%20-%20Codebook.r)
<br>

![#006400](https://placehold.co/15x15/006400/006400.png)
${\color{green} Below \space\ is \space\ the \space\ ANSWER \space\ to \space\ our \space\ research \space\ question:}$ <br>
The [figures folder](https://github.com/rinivarg/ReproRehab2024-Pod3/tree/main/Materials/Week%207%20%26%208/figures) contains the fruit of our labors -- the plots to visually compare across the 3 sessions.
