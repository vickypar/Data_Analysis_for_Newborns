# Data_Analysis_for_Newborns
This project regards analysis of data about newborns using Statistical methods in order to find out useful insights. 

## Table of Contents

[0. Installation](https://github.com/vickypar/Data_Analysis_for_Newborns#0-installation)

[1. About](https://github.com/vickypar/Data_Analysis_for_Newborns#1-about)

[2. Data](https://github.com/vickypar/Data_Analysis_for_Newborns#2-data)

[3. Analysis of Available Variables](https://github.com/vickypar/Data_Analysis_for_Newborns#3-analysis-of-available-variables)

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
On the other hand, mother's age, father's age, mother's number of cigarettes, father's number of cigarettes, father's years in education, father's height and whether mother's age is larger than 35 do not have statistically significant effect on newborn's weight (p-value > 0.05). As a result, these variables are not taken into consideration.

However, we cannot omit second order dependencies, since a variable in combination with another may have effect on birthweight. Since there are 13 independent variables, there are 78 second order dependencies. However, since the dataset consists of 84 observations, more than 84/3 = 28 terms will result in a saturated model. So, we create 6 models using different combinations of the aforementioned terms. From each model, we keep only the statistically significant terms in order to create the first attempt of the model. Afterwards, we omit sequentially the non-significant terms to result in the following model, where all terms are significant.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204043990-2a463b0a-bd5c-431e-b2a8-08ad4dab4f40.png" width="600"></p>

The model explains the **76.88%** of the birthweight's variability and it is statistically significant (p-value << 0.01).

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204044317-60cc9394-b301-4fac-9953-47d242b6b912.png" width="600"></p>

## 6. Question 3
The third research question that we study is whether parents' characteristics have effect on the duration of gestation. Since gestation is a discrete variable that takes only positive values, we study whether it follows Poisson distribution or negative binomial in order to use **generalized linear models (glm)**. 

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204088656-d045e62c-3451-41f5-ae75-7f9e973f37a0.png" width="550"></p>

We observe that it is significantly different from both distributions (p-value << 0.01). Thus, we create a new binary variable that show is the baby was born prematurely (duration of gestation less than 37 weeks) or not. We create the **barplot** and the **pie chart** of the newly created variable. 

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204089504-0c8428ed-ca9b-4413-b5da-94e5a97211c6.png" width="550"></p>

As expected, about 11% of babies were born prematurely. In order to analyze the effect of independent variables, we calculate their average value (for numerical) for each one of the available categories of the dependent variable.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204094382-2c13b490-46b3-4243-95f5-1f1e2a45610d.png" width="450"></p>

It seems that variables "mppwt" and "fnocig" have effect on the duration of gestation. For the categorical variables, we plot how they are distributed across the categories.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204094826-e4085755-df85-4830-823d-8b214fb64bc5.png" width="350"></p>

Next, we create **barplots** between each categporical feature and gestation and **boxplots** between each numerical feature and gestation. The figures are stored in the **results** folder.

It seems that only father's number of cigarettes has statistically significant effect on the duration of gestation (p-value < 0.05).
On the other hand, whether mother is a smoker, mother's height, mother's pre-pregnancy weight, mother's age, father's age, mother's number of cigarettes,  father's years in education, father's height and whether mother's age is larger than 35 do not have statistically significant effect on the duration of gestation (p-value > 0.05). As a result, these variables are not taken into consideration and we create a simple model using only father's number of cigarettes.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204097443-c510eb6f-8d94-4d23-addd-670a2280724b.png" width="550"></p>

However, it is not able to describe the data sufficiently.

Consequently, we use generalized additive models to discover any complex dependencies (quadratic, logarithmic, etc.). The figures are stored in the **results** folder. After doing the appropriate transformations, we create a first draft of the model along with the second order dependencies.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204098257-858caf58-7031-42d9-b11c-a0458110d6e4.png" width="550"></p>

We observe that it predicts 50% of the premature births. After omitting non-significant terms, we end up in the following model.

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204098477-d915acfb-48e7-4d8d-9dcf-4791e7fd350a.png" width="550"></p>

<p align="center"><img src="https://user-images.githubusercontent.com/95586847/204098507-cd900de8-2310-40be-8cd7-a6aac7e1bf22.png" width="550"></p>

The final model is slightly better than the first one regarding residuals, but it still predicts 50% of the premature births. It also includes some leverage points (11, 48, 74, 84) which belong to the positive class. So if we remove them, we will create a worse model.

Consequently, the available data are not sufficient to predict the duration of the gestation.





