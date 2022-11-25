# Data_Analysis_for_Newborns
This project regards analysis of data about newborns using Statistical methods in order to find out useful insights. 

## Table of Contents

[0. Installation](https://github.com/vickypar/Data_Analysis_for_Newborns#0-installation)

[1. About](https://github.com/vickypar/Data_Analysis_for_Newborns#1-about)

[2. Data](https://github.com/vickypar/Data_Analysis_for_Newborns#2-data)

[3. Analysis of Available Variables](https://github.com/vickypar/#3-Data_Analysis_for_Newborns#3-analysis-of-available-variables)

[4. Question 1](https://github.com/vickypar/Data_Analysis_for_Newborns#4-question-1)

[5. Question 2](https://github.com/vickypar/Data_Analysis_for_Newborns#5-question-2)

[6. Question 3](https://github.com/vickypar/Data_Analysis_for_Newborns#6-question-3)


## 0. Installation 

The code requires R.

## 1. About

**Data Analysis for Newborns** is a project that was created as a semester Project in the context of “Statistics” class. MSc Data and Web Science, School of Informatics, Aristotle University of Thessaloniki.

## 2. Data
The dataset contains information on new born babies and their parents.

The main dependent variable is considered to be the **Birthweight**. The available variables include other features about newborns and their parents and are presented below:

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/203937973-0d9aff7c-6501-4d09-bb54-024766df994b.png" width="550"></p>

## 3. Analysis of Available Variables
First, we analyze all of the available variables (both numerical and categorical):

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/203941990-cbbc9c17-fbea-45c2-a2ab-d595069f4d80.png" width="700"></p>

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/203942426-35d69cb0-7955-47c4-8959-c5db196553bc.png" width="400"></p>

After that, for **numerical** variables we plot **histograms**, **boxplots**, and **qq-plots** to observe if they follow normal distribution. For **categorical** variables we plot **bar charts** and **pie charts**. The figures are stored in the **results** folder.

## 4. Question 1
The first research question that we study is whether the newborns' length, the newborn's head circumference and the duration of gestation have effect on newborn's weight. Thus, we create **scatterplots** between each feature and birthweight.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204034161-d1143a20-3e45-4cb1-9ad0-3134f5ab7a4e.png" width="650"></p>

We can conclude that length and gestation are linearly correlated with birthweight, while headcirumference is logarithmically correlated with birthweight.
Next we create a model using all of the independent variables, their interactions, and their squares.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204035053-0a5c8f2a-52fa-421d-8b4a-b49aa32555c6.png" width="600"></p>

It is evident that some variables are not statistically significant (p-value > 0.01), so we omit them sequentially in order to create a model that includes only significant variables. Our final model is as follows:

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204035696-d808f8e5-f1ec-4191-a65d-5cbf533da884.png" width="600"></p>

The model explains the **68.78%** of the birthweight's variability.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204035833-c6abb257-7aab-4584-bedc-17100c57c8e2.png" width="600"></p>

## 5. Question 2
The second research question that we study is whether features that regard both parents and newborns have effect on newborn's birthwight. Thus, we create **scatterplots** between each numerical feature and birthweight and **boxplots** between each categporical feature and birthweight. The figures are stored in the **results** folder.
It seems that whether mother is a smoker, mother's height and mother's pre-pregnancy weight have statistically significant effect of newborn's weight (p-value < 0.05).
On the other hand mother's age, father's age, mother's number of cigarettes, father's number of cigarettes, father's years in education, father's height and whether mother's age is larger than 35 do not have statistically significant effect of newborn's weight (p-value > 0.05). As a result, these variables are not taken into consideration.





