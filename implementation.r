# Import necessary libraries
library(haven)
library(data.table)
library(summarytools)
library(ggplot2)
library(stringr)
library(hrbrthemes)
library(psych)
library(DescTools)
library(olsrr)
library(mgcv)
library(fitdistrplus)

dataset = read_sav("Birthweight_data_SPSS.sav")
raw_data = dataset #keep for later


############ SUMMARY ##################

# change values of binary variables
dataset$smoker <- str_replace_all(dataset$smoker, "0", "non-smoker")
dataset$smoker <- str_replace_all(dataset$smoker, "1", "smoker")
dataset$lowbwt <- str_replace_all(dataset$lowbwt, "0", "NO")
dataset$lowbwt <- str_replace_all(dataset$lowbwt, "1", "YES")
dataset$mage35 <- str_replace_all(dataset$mage35, "0", "NO")
dataset$mage35 <- str_replace_all(dataset$mage35, "1", "YES")

# descriptive statistics
summary(dataset[, - c(5, 14, 15)])


# alternatively
freq(dataset$smoker)
freq(dataset$lowbwt)
freq(dataset$mage35)

# Analyze each feature (create histograms, box plots and qq-plots to check if they follow normal distribution)

############ Birthweigth ####################
hist_birthw <- ggplot(dataset, aes(x=Birthweight)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Birthweight") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_birthw <- hist_birthw + stat_function(fun = dnorm,
                                           args = list(
                                            mean = mean(dataset$Birthweight),
                                            sd = sd(dataset$Birthweight)
                                           ))
hist_birthw

hist(dataset$Birthweight, xlab = "Birthweight", main = "Histogram of Birthweight")

# check normal distribution 
qqnorm(dataset$Birthweight, main="Normal Q-Q Plot for Birthweight")
qqline(dataset$Birthweight)

dataset$dummy = "Birthweight"
box_birth <- ggplot(dataset, aes(x=dummy, y=Birthweight, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    axis.title.y = element_text(size = 15)
    
  ) +
  ggtitle("Boxplot of Birthweight") +
  xlab("") + ylab("lbs")

box_birth


############ Length #################
hist_len <- ggplot(dataset, aes(x=length)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Length") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_len <- hist_len + stat_function(fun = dnorm,
                                           args = list(
                                           mean = mean(dataset$length),
                                           sd = sd(dataset$length)
                                           ))
hist_len

dataset$dummy = "length"
box_length <- ggplot(dataset, aes(x=dummy, y=length, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Length") +
  xlab("") + ylab("inches")

box_length

# check normal distribution 
qqnorm(dataset$length, main="Normal Q-Q Plot for Length")
qqline(dataset$length)

############ Head cirumference ################
hist_head <- ggplot(dataset, aes(x=headcirumference)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Head Cirumference") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_head <- hist_head + stat_function(fun = dnorm,
                                       args = list(
                                       mean = mean(dataset$headcirumference),
                                       sd = sd(dataset$headcirumference)
                                     ))
hist_head

dataset$dummy = "headcirumference"
box_head <- ggplot(dataset, aes(x=dummy, y=headcirumference, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    axis.title.y = element_text(size = 15) 
    
  ) +
  ggtitle("Boxplot of Head Circumference") +
  xlab("") + ylab("inches")

box_head

counts <- plyr::count(factor(dataset$headcirumference))
pie_head <- pie(counts$freq , labels = counts$x)

# check normal distribution 
qqnorm(dataset$headcirumference, main="Normal Q-Q Plot for Head Circumference")
qqline(dataset$headcirumference)

########### Gestation ######################
hist_gest <- ggplot(dataset, aes(x=Gestation)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Gestation") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_gest <- hist_gest + stat_function(fun = dnorm,
                                       args = list(
                                       mean = mean(dataset$Gestation),
                                       sd = sd(dataset$Gestation)
                                       ))

hist_gest

dataset$dummy = "Gestation"
box_gest <- ggplot(dataset, aes(x=dummy, y=Gestation, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Gestation") +
  xlab("") + ylab("weeks")

box_gest

# check normal distribution 
qqnorm(dataset$Gestation, main="Normal Q-Q Plot for Gestation")
qqline(dataset$Gestation)

# create barplot and pie for categorical variables
############ Smoker ###########
bar_smoker <- ggplot(dataset, aes(x=smoker, color = smoker, fill = smoker)) +
  geom_bar( aes(y = (..count..)/sum(..count..)), alpha=0.9) +
  ggtitle("Barplot Smoker") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    legend.position = "none"
  )+
  ylab("Frequency")

bar_smoker


counts <- plyr::count(dataset$smoker)
pie_smoker <- pie(counts$freq , labels = counts$x)

########### Mother's Age #############
hist_mage <- ggplot(dataset, aes(x=motherage)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Mother's Age") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_mage <- hist_mage + stat_function(fun = dnorm,
                                       args = list(
                                       mean = mean(dataset$motherage),
                                       sd = sd(dataset$motherage)
                                       ))

hist_mage



dataset$dummy = "motherage"
box_mage <- ggplot(dataset, aes(x=dummy, y=motherage, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    axis.title.y = element_text(size = 15)
    
  ) +
  ggtitle("Boxplot of Mother's Age") +
  xlab("") + ylab("years")

box_mage

# check normal distribution 
qqnorm(dataset$motherage, main="Normal Q-Q Plot for Mother's Age")
qqline(dataset$motherage)

######### Number of cigarettes smoked by mother ###########
hist_mnocig <- ggplot(dataset, aes(x=mnocig)) +
  geom_histogram( aes(y = ..density..), binwidth = 3, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Mother's Daily Cigarettes") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_mnocig <- hist_mnocig + stat_function(fun = dnorm,
                                           args = list(
                                           mean = mean(dataset$mnocig),
                                           sd = sd(dataset$mnocig)
                                           ))

hist_mnocig 


dataset$dummy = "mother's daily cigaretts"
box_mnocig <- ggplot(dataset, aes(x=dummy, y=mnocig, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Mother's Daily Cigarettes") +
  xlab("") + ylab("cigarettes")

box_mnocig

# check normal distribution 
qqnorm(dataset$mnocig, main="Normal Q-Q Plot for Mother's Daily Cigarettes")
qqline(dataset$mnocig)

######### Mother's Height ###########
hist_mheight <- ggplot(dataset, aes(x=mheight)) +
  geom_histogram( aes(y = ..density..), binwidth = 2, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Mother's Height") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_mheight <- hist_mheight + stat_function(fun = dnorm,
                                             args = list(
                                             mean = mean(dataset$mheight),
                                             sd = sd(dataset$mheight)
                                             ))

hist_mheight

dataset$dummy = "mother's height"
box_mheight <- ggplot(dataset, aes(x=dummy, y=mheight, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Mother's Height") +
  xlab("") + ylab("inches")

box_mheight

# check normal distribution 
qqnorm(dataset$mheight, main="Normal Q-Q Plot for Mother's Height")
qqline(dataset$mheight)

######### Mother's Pre Pregnancy Weight ###########
hist_mppwt <- ggplot(dataset, aes(x=mppwt)) +
  geom_histogram( aes(y = ..density..), binwidth = 4, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Mother's Pre Pregnancy Weight") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_mppwt


hist_mppwt <- hist_mppwt + stat_function(fun = dnorm,
                                             args = list(
                                             mean = mean(dataset$mppwt),
                                             sd = sd(dataset$mppwt)
                                             ))

hist_mppwt

dataset$dummy = "mother's pre pregnancy weight"
box_mppwt <- ggplot(dataset, aes(x=dummy, y=mppwt, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Mother's Pre Pregnacy Weight") +
  xlab("") + ylab("lbs")

box_mppwt

# check normal distribution 
qqnorm(dataset$mppwt, main="Normal Q-Q Plot for Mother's Pre Pregnancy Weight")
qqline(dataset$mppwt)


######### Father's age ###########
hist_fage <- ggplot(dataset, aes(x=fage)) +
  geom_histogram( aes(y = ..density..), binwidth = 2, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Father's Age") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_fage

hist_fage <- hist_fage + stat_function(fun = dnorm,
                                         args = list(
                                           mean = mean(dataset$fage),
                                           sd = sd(dataset$fage)
                                         ))

hist_fage

dataset$dummy = "father's age"
box_fage <- ggplot(dataset, aes(x=dummy, y=fage, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Father's Age") +
  xlab("") + ylab("years")

box_fage

# check normal distribution 
qqnorm(dataset$fage, main="Normal Q-Q Plot for Father's Age")
qqline(dataset$fage)


######### Father's years in education ###########
hist_fedyrs <- ggplot(dataset, aes(x=fedyrs)) +
  geom_histogram( aes(y = ..density..), binwidth = 1, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Father's Years in Education") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency") + scale_x_continuous(breaks = c(9, 10, 11, 12, 13, 14,15,  16))

hist_fedyrs
hist_fedyrs <- hist_fedyrs + stat_function(fun = dnorm,
                                       args = list(
                                         mean = mean(dataset$fedyrs),
                                         sd = sd(dataset$fedyrs)
                                       ))

hist_fedyrs

dataset$dummy = "father's years in education"
box_fedyrs <- ggplot(dataset, aes(x=dummy, y=fedyrs, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Father's Years in Education") +
  xlab("") + ylab("years")

box_fedyrs

# check normal distribution 
qqnorm(dataset$fedyrs, main="Normal Q-Q Plot for Father's Years in Education")
qqline(dataset$fedyrs)


counts <- plyr::count(factor(dataset$fedyrs))
pie_head <- pie(counts$freq , labels = counts$x)


######### Father's Number of cigarettes ###########
hist_fnocig <- ggplot(dataset, aes(x=fnocig)) +
  geom_histogram( aes(y = ..density..), binwidth = 5, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Cigarettes Smoked by Father") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency")

hist_fnocig

hist_fnocig <- hist_fnocig + stat_function(fun = dnorm,
                                           args = list(
                                             mean = mean(dataset$fnocig),
                                             sd = sd(dataset$fnocig)
                                           ))

hist_fnocig

dataset$dummy = "number of cigarettes smoked by father"
box_fnocig <- ggplot(dataset, aes(x=dummy, y=fnocig, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Cigarettes Smoked by Father") +
  xlab("") + ylab("number of cigarettes")

box_fnocig

# check normal distribution 
qqnorm(dataset$fnocig, main="Normal Q-Q Plot for Cigarettes Smoked by Father")
qqline(dataset$fnocig)


######### Father's Height ###########
hist_fheight <- ggplot(dataset, aes(x=fheight)) +
  geom_histogram( aes(y = ..density..), binwidth = 2, fill="#69b3a2", color="#e9ecef", alpha=1) +
  ggtitle("Histogram of Father's Height") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
  ) +
  ylab("Frequency") + xlim(c(66, 78)) + scale_x_continuous(breaks = seq(66, 78,2))

hist_fheight

hist_fheight <- hist_fheight + stat_function(fun = dnorm,
                                             args = list(
                                               mean = mean(dataset$fheight),
                                               sd = sd(dataset$fheight)
                                             ))

hist_fheight

dataset$dummy = "father's height"
box_fheight <- ggplot(dataset, aes(x=dummy, y=fheight, fill=dummy)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot of Father's Height") +
  xlab("") + ylab("inches")

box_fheight

# check normal distribution 
qqnorm(dataset$fheight, main="Normal Q-Q Plot for Father's Height")
qqline(dataset$fheight)


############ Low Birthweight ###########
bar_lowbwt <- ggplot(dataset, aes(x=lowbwt, color = lowbwt, fill = lowbwt)) +
  geom_bar( aes(y = (..count..)/sum(..count..)), alpha=0.9) +
  ggtitle("Barplot Low Birthweight") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    legend.position = "none"
  )+
  ylab("Frequency")

bar_lowbwt


counts <- plyr::count(dataset$lowbwt)
pie_lowbwt <- pie(counts$freq , labels = counts$x)


############ Mother's Age ###########
bar_mage35 <- ggplot(dataset, aes(x=mage35, color = mage35, fill = mage35)) +
  geom_bar( aes(y = (..count..)/sum(..count..)), alpha=0.9) +
  ggtitle("Barplot Mothe's Age > 35") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    legend.position = "none"
  )+
  ylab("Frequency")

bar_mage35


counts <- plyr::count(dataset$mage35)
pie_mage35 <- pie(counts$freq , labels = counts$x)

####### Question 1 #####
# Analyzing the effect of newborns' length and head circumference as well as the duration of gestation in newborns' weight.

pairs(dataset[, c(1,2,3,4)], panel = panel.smooth)

# Create scatterplots between each feature and birthweight.
### Length ####
sc_len <- ggplot(dataset, aes(x=length, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Length")

sc_len
cor.test(dataset$Birthweight, dataset$length, method = "pearson")

### Head Circuference ####
sc_head <- ggplot(dataset, aes(x=headcirumference, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Head Circumference")

sc_head

boxplot(datset$Birthweight~factor(dataset$headcirumference))
cor.test(dataset$Birthweight, dataset$headcirumference, method = "pearson")

### Gestation #####
sc_gestation <- ggplot(dataset, aes(x=Gestation, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Gestation")

sc_gestation

cor.test(dataset$Birthweight, dataset$Gestation, method = "pearson") # there are ties

library(tree)
modeltree <- tree(Birthweight~.,data=raw_data[,c(1:4)])
plot(modeltree)
text(modeltree)


### Models ####
model1 <- lm(Birthweight~length*Gestation*headcirumference+I(length^2)+I(Gestation^2)+I(headcirumference^2),
             data = dataset)
summary(model1)

model2<-update(model1,~.-length:Gestation:headcirumference)
summary(model2)

model3<-update(model2,~.-Gestation:headcirumference)
summary(model3)

model4<-update(model3,~.-I(Gestation^2))
summary(model4)

model5<-update(model4,~.-I(length^2))
summary(model5)

model6<-update(model5,~.-length:headcirumference)
summary(model6)

par(mfrow=c(2,2))
plot(model6, sub.caption=" ")


model.dim<-ols_step_both_p(model1)
model.dim

summary(model.dim$model)

anova(model6, model.dim$model)

#plot(Gestation,Birthweight)
#abline(model1)

############ Question 2 ############
# We analyze all features' effect (features that regard parents and other newborn's characteristics) on newborn's birthwight

pairs(raw_data[, -c(14)], panel = panel.smooth)

##### Smoker #######
box_smoker <- ggplot(dataset, aes(x=smoker, y=Birthweight, fill=smoker)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Birthweight and Smoker") +
  xlab("") + ylab("Birthweight (lbs)")

box_smoker
summary(aov(Birthweight ~ smoker, data = dataset))

##### Mother's Age ######

sc_mage <- ggplot(dataset, aes(x=motherage, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=17),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Mother's Age")

sc_mage
cor.test(dataset$Birthweight, dataset$motherage, method = "spearman")


##### Mnocig ######

sc_mnocig <- ggplot(dataset, aes(x=mnocig, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Mother's Daily Cigarettes")

sc_mnocig
cor.test(dataset$Birthweight, dataset$mnocig, alternative="two.sided", method = "kendall")


##### Mheight ####

sc_mheight <- ggplot(dataset, aes(x=mheight, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Mother's Height")

sc_mheight
cor.test(dataset$Birthweight, dataset$mheight, method = "spearman")


##### Mppwt #####

sc_mpptw <- ggplot(dataset, aes(x=mppwt, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Mother's Pre-Pregnancy Weight")

sc_mpptw
cor.test(dataset$Birthweight, dataset$mppwt, method = "spearman")


##### Fage #####

sc_fage <- ggplot(dataset, aes(x=fage, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Father's Age")

sc_fage
cor.test(dataset$Birthweight, dataset$fage, method = "spearman")


##### Fedyrs #####

sc_fedyrs <- ggplot(dataset, aes(x=fedyrs, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Father's Years in Education")

sc_fedyrs
cor.test(dataset$Birthweight, dataset$fedyrs, method = "spearman")


##### Fnocig #####

sc_fnocig <- ggplot(dataset, aes(x=fnocig, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Father's Daily Cigarettes")

sc_fnocig
cor.test(dataset$Birthweight, dataset$fnocig, alternative="two.sided", method = "kendall")
summary(aov(Birthweight~factor(fnocig),data=dataset))


##### Fheight ######

sc_fheight <- ggplot(dataset, aes(x=fheight, y=Birthweight)) + 
  #geom_boxplot(size=2, color = "blue", alpha = 0.7) +
  geom_jitter(size=2, color = "blue", fill = "grey", alpha = 0.7, stroke = 0.5)+
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Scatterplot Between Birthweight and Father's Height")

sc_fheight

cor.test(dataset$Birthweight, dataset$fheight, method = "spearman")


##### Lowbwt ######

box_lowbwt <- ggplot(dataset, aes(x=lowbwt, y=Birthweight, fill=lowbwt)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=12),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Birthweight and Binary Variable Low Birth Weight") +
  xlab("") + ylab("Birthweight (lbs)")

box_lowbwt

summary(aov(Birthweight~factor(lowbwt),data=dataset))


##### Mage35 ######

box_mage35 <- ggplot(dataset, aes(x=dataset$mage35, y=Birthweight, fill=mage35)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=16),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Birthweight and Mother's Age") +
  xlab("") + ylab("Birthweight (lbs)")

box_mage35
summary(aov(Birthweight ~ mage35, data = dataset))

modeltree <- tree(Birthweight~.,data=raw_data[, -c(14)])
plot(modeltree)
text(modeltree)

######## Models #########
# 13 independent variables + n(n-1)/2 = 78 second order dependencies >>> 84/3 = 28
# we could not possibly calculate all the parameters

model1 <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt + 
             I(length^2)+I(Gestation^2)+I(headcirumference^2) + I(mheight^2) +
               I(mppwt^2) + I(motherage^2) + I(mnocig^2) + I(fage^2) + I(fedyrs^2) +
               I(fnocig^2) + I(fheight^2),
             data = dataset)

summary(model1)

# we keep first order + I(length^2) + I(headcirumference^2) + I(fheight^2) 

# all the second order dependencies are:
t(combn(colnames(dataset[-c(2, 14, 16)]), 2))

model2a <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt + 
              length:headcirumference + length:Gestation + length:smoker + length:motherage+
              length:mnocig + length:mheight + length:mppwt + length:fage + length:fedyrs +         
              length:fnocig + length:fheight + length:mage35 + headcirumference:Gestation +       
              headcirumference:smoker + headcirumference:motherage + headcirumference:mnocig +          
              headcirumference:mheight + headcirumference:mppwt + headcirumference:fage +
              headcirumference:fedyrs,
              data = dataset)

summary(model2a)

# we keep length:fheight

model2b <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt + 
              headcirumference:fnocig + headcirumference:fheight + headcirumference:mage35 +   
              Gestation:smoker + Gestation:motherage + Gestation:mnocig + Gestation:mheight +  
              Gestation:mppwt + Gestation:fage + Gestation:fedyrs + Gestation:fnocig +   
              Gestation:fheight + Gestation:mage35 + smoker:motherage + smoker:mnocig +   
              smoker:mheight + smoker:mppwt + smoker:fage + smoker:fedyrs +smoker:fnocig,
              data = dataset)

summary(model2b)

# we keep Gestation:smokersmoker , smokersmoker:fage, Gestation:fheight, 
# Gestation:fage, Gestation:motherage


model2c <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt + 
              smoker:fheight + smoker:mage35 + motherage:mnocig + motherage:mheight +motherage:mppwt +  
              motherage:fage +  motherage:fedyrs + motherage:fnocig + motherage:fheight +
              motherage:mage35 + mnocig:mheight + mnocig:mppwt + mnocig:fage + mnocig:fedyrs + 
              mnocig:fnocig + mnocig:fheight + mnocig:mage35 + mheight:mppwt + mheight:fage +   
              mheight:fedyrs,
              data = dataset)

summary(model2c)

# we keep motherage:fage, mheight:mppwt , mheight:fage


model2d <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt + 
              mheight:fnocig + mheight:fheight + mheight:mage35 + mppwt:fage + mppwt:fedyrs + 
              mppwt:fnocig + mppwt:fheight + mppwt:mage35 + fage:fedyrs + fage:fnocig +
              fage:fheight + fage:mage35 + fedyrs:fnocig + fedyrs:fheight + fedyrs:mage35 + 
              fnocig:fheight + fnocig:mage35 + fheight:mage35,
              data = dataset)

summary(model2d)

# we keep mheight:fnocig , mheight:fheight , mheight:mage35, mppwt:fheight, mage35YES:fedyrs ,
# fnocig:fheight , fnocig:mage35 , fnocig:fedyrs, fnocig:fage

model3 <- lm(Birthweight~length + Gestation + headcirumference + smoker + mheight + mppwt +
               mheight:fnocig + mheight:fheight + mheight:mage35 + mppwt:fheight + mage35:fedyrs +
              fnocig:fheight + fnocig:mage35 + fnocig:fedyrs + fnocig:fage +
               motherage:fage + mheight:mppwt + mheight:fage + Gestation:smoker +
               smoker:fage + Gestation:fheight + Gestation:fage + Gestation:motherage +
               length:fheight + I(length^2) + I(headcirumference^2) + I(fheight^2),
             data = dataset)

summary(model3)

model4 <- update(model3, ~.-mheight:fnocig  -mheight:fheight -mheight:mppwt
                 -smoker:fage  -fnocig:fheight 
                 -Gestation:motherage -length:fheight)
summary(model4)

anova(model3, model4)

model5 <- update(model4, ~.-mheight:fage  -Gestation:smokersmoker -mage35:fnocig
                 -I(headcirumference^2)   -I(fheight^2))

summary(model5)
anova(model4, model5)

model6 <- update(model5, ~. -headcirumference)
summary(model6)
anova(model5, model6)

par(mfrow=c(2,2))
plot(model6, sub.caption=" ")

model7 <- update(model6, ~.-mage35:fedyrs)
summary(model7)
anova(model6, model7)

model8 <- update(model7,~.-Gestation:fage -fage:motherage -mheight:mage35)
summary(model8)
anova(model8, model6)

model9 <- update(model8, ~.-fedyrs:fnocig)
summary(model9)
anova(model8, model9)

model10 <- update(model9, ~.-length)
summary(model10)
anova(model10, model9)

model11 <- update(model10, ~.-I(length^2))
summary(model11)
anova(model10, model11)

par(mfrow=c(2,2))
plot(model11, sub.caption=" ")

model.dim<-ols_step_both_p(model3)
model.dim

summary(model.dim$model)

anova(model11, model.dim$model)

######## Question 3 ###########
# The third research question that we study is whether parents' characteristics have effect on the duration of gestation.
### check glm ####

f.P<-fitdist(as.numeric(dataset$Gestation),"pois")
f.nb<-fitdist(as.numeric(dataset$Gestation),"nbinom")
cdfcomp(list(f.P, f.nb),legendtext = c("Poisson", "negative binomial"),fitlty=1)
gofstat(list(f.P, f.nb),fitnames = c("Poisson", "negative binomial"))

### make binary ####
raw_data$Gestation_binary <- 0
who <- which(raw_data$Gestation < 37)
raw_data$Gestation_binary[who] <- 1 ##premature

freq(raw_data$Gestation_binary)


dataset$Gestation_binary <- as.factor(raw_data$Gestation_binary)

bar_gb <- ggplot(dataset, aes(x=Gestation_binary, color = Gestation_binary, 
                              fill = Gestation_binary)) +
  geom_bar( aes(y = (..count..)/sum(..count..)), alpha=0.9) +
  ggtitle("Barplot Gestation_binary") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15),
    axis.line = element_line(colour = "black"),
    legend.position = "none"
  )+
  ylab("Frequency")

bar_gb


counts <- plyr::count(dataset$Gestation_binary)
pie_gb <- pie(counts$freq , labels = counts$x)

# "smoker", "motherage", "mnocig", "mheight", "mppwt", "fage", "fedyrs", "fnocig"          
# "fheight", "mage35", "Gestation_binary"

#tapply(raw_data$smoker,raw_data$Gestation_binary,mean)
tapply(raw_data$motherage,raw_data$Gestation_binary,mean)
tapply(raw_data$mnocig,raw_data$Gestation_binary,mean)
tapply(raw_data$mheight,raw_data$Gestation_binary,mean)
tapply(raw_data$mppwt,raw_data$Gestation_binary,mean)
tapply(raw_data$fage,raw_data$Gestation_binary,mean)
tapply(raw_data$fedyrs,raw_data$Gestation_binary,mean)
tapply(raw_data$fnocig,raw_data$Gestation_binary,mean)
tapply(raw_data$fheight,raw_data$Gestation_binary,mean)
#tapply(raw_data$mage35,raw_data$Gestation_binary,mean)

table(dataset$Gestation_binary,dataset$smoker)

table(dataset$Gestation_binary,dataset$mage35)



### smoker ####
bar_smoker <- ggplot(dataset, aes(Gestation_binary, ..count..)) +
  geom_bar(aes(fill = smoker), position = "dodge")+
    theme_ipsum() +
    theme(
      plot.title = element_text(size=10),
      axis.line = element_line(colour = "black")

    ) +
    ggtitle("Barplot Between Gestation_binary and Smoker")

bar_smoker

chisq.test(dataset$smoker, dataset$Gestation_binary)


### motherage ####

box_motherage <- ggplot(dataset, aes(x=Gestation_binary, y=motherage, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=12),
    axis.line = element_line(colour = "black")

  ) +
  ggtitle("Boxplot Between Gestation_binary and Mother's Age")


box_motherage

cor.test(raw_data$Gestation_binary,raw_data$motherage,method="kendall")
wilcox.test(dataset$motherage~ dataset$Gestation_binary)


### mnocig ####

box_mnocig <- ggplot(dataset, aes(x=Gestation_binary, y=mnocig, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=9.5),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Mother's Daily Cigarettes")


box_mnocig

cor.test(raw_data$Gestation_binary,raw_data$mnocig,method="kendall")
wilcox.test(dataset$mnocig~ dataset$Gestation_binary)

### mheight ####

box_mheight <- ggplot(dataset, aes(x=Gestation_binary, y=mheight, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=10),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Mother's Height")


box_mheight

cor.test(raw_data$Gestation_binary,raw_data$mheight,method="kendall")
wilcox.test(dataset$mheight~ dataset$Gestation_binary)

### mppwt ####

box_mppwt <- ggplot(dataset, aes(x=Gestation_binary, y=mppwt, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=8),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Mother's Pre Pregnancy Weight")


box_mppwt

cor.test(raw_data$Gestation_binary,raw_data$mppwt,method="kendall")
wilcox.test(dataset$mppwt~ dataset$Gestation_binary)

### fage ####

box_fage <- ggplot(dataset, aes(x=Gestation_binary, y=fage, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=10),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Father's Age")


box_fage

cor.test(raw_data$Gestation_binary,raw_data$fage,method="kendall")
wilcox.test(dataset$fage~ dataset$Gestation_binary)

### fedyrs ####

box_fedyrs <- ggplot(dataset, aes(x=Gestation_binary, y=fedyrs, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=9),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Father's Years of Education")


box_fedyrs

cor.test(raw_data$Gestation_binary,raw_data$fedyrs,method="kendall")
wilcox.test(dataset$fedyrs~ dataset$Gestation_binary)

### fnocig ####

box_fnocig <- ggplot(dataset, aes(x=Gestation_binary, y=fnocig, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=9.5),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Father's Daily Cigarettes")


box_fnocig

cor.test(raw_data$Gestation_binary,raw_data$fnocig,method="kendall")
wilcox.test(dataset$fnocig~ dataset$Gestation_binary)

### fheight ####

box_fheight <- ggplot(dataset, aes(x=Gestation_binary, y=fheight, fill=Gestation_binary)) +
  geom_boxplot() +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=10),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Boxplot Between Gestation_binary and Father's Height")


box_fheight

cor.test(raw_data$Gestation_binary,raw_data$fheight,method="kendall")
wilcox.test(dataset$fheight~ dataset$Gestation_binary)

### mage35 ####
bar_mage35 <- ggplot(dataset, aes(Gestation_binary, ..count..)) +
  geom_bar(aes(fill = mage35), position = "dodge")+
  theme_ipsum() +
  theme(
    plot.title = element_text(size=10),
    axis.line = element_line(colour = "black")
    
  ) +
  ggtitle("Barplot Between Gestation_binary and Mother's Age > 35")

bar_mage35

chisq.test(dataset$mage35, dataset$Gestation_binary)

### check simple ####
model0<-glm(Gestation_binary~fnocig ,
            family = binomial, data = dataset)
summary(model0)

p1<-predict(model0,type="response")
p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
prop.table(table(raw_data$Gestation_binary,p.c.1),1)

### check gam for variable transformations ####
model1.smooth<-gam(Gestation_binary ~ smoker + s(motherage) ,binomial, data = dataset)
plot.gam(model1.smooth)


model2.smooth<-gam(Gestation_binary ~ s(mnocig) , binomial, data = dataset)
plot.gam(model2.smooth)


model3.smooth<-gam(Gestation_binary ~ s(mheight) ,binomial, data = dataset)
plot.gam(model3.smooth)


model4.smooth<-gam(Gestation_binary ~ s(mppwt) ,binomial, data = dataset)
plot.gam(model4.smooth)


model5.smooth<-gam(Gestation_binary ~  s(fage) ,binomial, data = dataset)
plot.gam(model5.smooth)


model6.smooth<-gam(Gestation_binary ~  s(fheight)+ mage35 ,binomial, data = dataset)
plot.gam(model6.smooth)


model7.smooth<-gam(Gestation_binary ~ s(fnocig,k = 2) ,binomial, data = dataset)
plot.gam(model7.smooth)


model8.smooth<-gam(Gestation_binary ~ s(fedyrs, k = 2) ,binomial, data = dataset)
plot.gam(model8.smooth)


### Models ####
model1<-glm(Gestation_binary~fnocig + I((motherage-35)*(motherage>35)) + 
              I((motherage-25)^2 *(motherage-25))+
              I((mheight-61)*(mheight<61)) + I((mheight-66)*(mheight>66)) +
              I((mppwt-140)*(mppwt>140)) + I((fage-40)*(fage>40)),
            family = binomial, data = dataset)
summary(model1)

p1<-predict(model1,type="response")
p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
prop.table(table(raw_data$Gestation_binary,p.c.1),1)

# all the second order dependencies are:

model2a <- glm(Gestation_binary~ smoker:motherage +
              smoker:mnocig + smoker:mheight + smoker:mppwt + smoker:fage +
              smoker:fedyrs + smoker:fnocig + smoker:fheight + smoker:mage35 +
              motherage:mnocig + motherage:mheight + motherage:mppwt +
              motherage:fage + motherage:fedyrs + motherage:fnocig +
              motherage:fheight +motherage:mage35 + mnocig:mheight + mnocig:mppwt +mnocig:fage +
              mnocig:fedyrs + mnocig:fnocig + mnocig:fheight + mnocig:mage35 +
              mheight:mppwt ,
              family = binomial, data = dataset)

summary(model2a)


# we keep nothing

model2b <- glm(Gestation_binary~+ mheight:fage + mheight:fedyrs + mheight:fnocig +
              mheight:fheight + mheight:mage35 + mppwt:fage + mppwt:fedyrs + mppwt:fnocig +
                mppwt:fheight + mppwt:mage35 + fage:fedyrs + fage:fnocig +fage:fheight +
                fage:mage35 + fedyrs:fnocig + fedyrs:fheight + fedyrs:mage35 +
                fnocig:fheight + fnocig:mage35 + fheight:mage35,
              family = binomial, data = dataset)

summary(model2b)

# we keep nothing
modeltree <- tree(Gestation_binary~.,data=raw_data[,c(5:13, 15:16)])
plot(modeltree)
text(modeltree)


model3<-glm(Gestation_binary~fnocig + I((motherage-34)*(motherage>34)) +
              I((motherage-25)^2 *(motherage-25))+
              I((mheight-61)*(mheight<61)) + I((mheight-61)*(mheight>61)) +
              I((mppwt-127)*(mppwt>127)) + I((fage-27)*(fage>27)),
            family = binomial, data = dataset)
summary(model3)

p1<-predict(model3,type="response")
p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
prop.table(table(raw_data$Gestation_binary,p.c.1),1)


model4 <- update(model3, ~. -I((mppwt-127)*(mppwt>127)) -I((motherage-25)^2 *(motherage-25)))
summary(model4)

p1<-predict(model4,type="response")
p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
prop.table(table(raw_data$Gestation_binary,p.c.1),1)

model5 <- update(model4, ~. -I((mheight - 61) * (mheight > 61))  )
summary(model5)

p1<-predict(model5,type="response")
p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
prop.table(table(raw_data$Gestation_binary,p.c.1),1)

par(mfrow=c(2,2))
plot(model5, sub.caption=" ")

which(dataset$Gestation_binary == 1)

# 
# model6 <- update(model5, ~. ,subset=(c(1:8, 12:47, 49:73, 75:84)) )
# summary(model6)
# 
# p1<-predict(model6,type="response")
# p.c.1 <- ifelse(p1 > 0.5, "pos", "neg")
# prop.table(table(raw_data$Gestation_binary[-c(9, 10, 11, 48, 74)],p.c.1),1)
# 
# par(mfrow=c(2,2))
# plot(model6, sub.caption=" ")

