rm(list=ls()); ##clean environment
# load packages
library(WRS2)
library(ggpubr) # creating easily publication ready plots
library(tidyverse) #data manipulation and visualization
library(rstatix) #provides pipe-friendly R functions for easy statistical analyses
library(cowplot)  #these ones for the raincloud plots
library(dplyr)
library(readr)
library(rcompanion)  #mean and CI
#change working directory
setwd("C:/Users/sapls6/Documents/MATLAB/TransitiveInferenceExp/Sleep_CL_TMR/Behaviour_Analysis_Oct_2020/csvFiles") 
## load plotting functions
source("RainCloudPlots-master/tutorial_R/R_rainclouds.R")
source("RainCloudPlots-master/tutorial_R/summarySE.R")
source("RainCloudPlots-master/tutorial_R/simulateData.R")
################################################################
## TRIALS TO LEARN
################################################################
NoTrials<-read.csv("CL_TMR_No_Trials_Learning.csv")
#re-organise
Trials <- NoTrials%>%
  gather(key = "Stimuli", value = "Number",Objects,Faces,Scenes) %>%
  convert_as_factor(Stimuli)
#stats
t1way(Number~Stimuli,data=Trials)
# descriptive metrcs
Summary=Trials%>%group_by(Stimuli) %>% 
  get_summary_stats(Number, type ="full")

################################################################
## Premises pairs S1 
################################################################
Premises<-read.csv("CL_TMR_Session1.csv")
PremisesLitte<-Premises[,c(1,3,4,5,6)]
PremisesLitte%>%group_by(Cued) %>% 
  get_summary_stats(Acc, type ="full")
PremisesLitte<-Premises[,c(1,3,4,5,6)]
t1way(Acc~Cued,data=PremisesLitte) #one way anova
lincon(Acc~Cued,data=PremisesLitte) #post-hoc

################################################################
## Premies pairs S1-S2
################################################################
Premises<-read.csv("Premises_S1_S2.csv")
PremisesLitte<-Premises[,c(1,5,6,9)]
names(PremisesLitte)[3]<-'Session1'
names(PremisesLitte)[4]<-'Session2'
# convert into factors
Premises2 <- PremisesLitte%>%
  gather(key = "Session", value = "Accuracy",Session1,Session2) %>%
  convert_as_factor(ID, Session)
names(Premises2)[2]<-'Condition'
# robust two-way misex Anova using trimmed means
bwtrim(Accuracy~Session*Condition, id=ID,data=Premises2)
# manual post-hocs
newD<-subset(Premises2, Session=='Session1')
t1way(Accuracy~Condition, data=newD)
lincon(Accuracy~Condition, data=newD)

newD<-subset(Premises2, Session=='Session2')
t1way(Accuracy~Condition, data=newD)
lincon(Accuracy~Condition, data=newD)


newD1<-subset(Premises2, Condition=='Down')
t1way(Accuracy~Session, data=newD1)


newD1<-subset(Premises2, Condition=='Up')
t1way(Accuracy~Session, data=newD1)

newD1<-subset(Premises2, Condition=='None')
t1way(Accuracy~Session, data=newD1)

################################################################
## Premises pairs S1-S2-S3
################################################################
Premises1_2<-read.csv("Premises_S1_S2.csv") #session 1 and 2
PremisesLitte<-Premises1_2[,c(1,5,6,9)];rm(Premises1_2)
names(PremisesLitte)[3]<-'Session1'
names(PremisesLitte)[4]<-'Session2'
Premises2 <- PremisesLitte%>%
  gather(key = "Session", value = "Accuracy",Session1,Session2) %>%
  convert_as_factor(ID, Session,Cued)
rm(PremisesLitte)
Premises3<-read.csv("Premises_S3.csv") #session 3
PremisesLitte2<-Premises3[,c(1,5,6)];remove(Premises3)
PremisesLitte2$Session='Session3'
names(PremisesLitte2)[3]<-'Accuracy'
PremisesLitte2<-PremisesLitte2[,c(1,2,4,3)]
PremisesLitte2 <- PremisesLitte2%>%  convert_as_factor(ID, Session,Cued)
Pre<-rbind(Premises2,PremisesLitte2)  # join them together
rm(PremisesLitte2,Premises2)
names(Pre)[2]<-'Condition'


# robust mised Anova using trimmed means
bwtrim(Accuracy~Session*Condition, id=ID,data=Pre)
# manual post-hocs
newD<-subset(Pre, Session=='Session1')
t1way(Accuracy~Condition, data=newD)
lincon(Accuracy~Condition, data=newD)

newD<-subset(Pre, Session=='Session2')
t1way(Accuracy~Condition, data=newD)
lincon(Accuracy~Condition, data=newD)

newD<-subset(Pre, Session=='Session3')
t1way(Accuracy~Condition, data=newD)
lincon(Accuracy~Condition, data=newD)



newD<-subset(Pre, Condition=='Down')
t1way(Accuracy~Session, data=newD)
lincon(Accuracy~Session, data=newD)

newD<-subset(Pre, Condition=='Up')
t1way(Accuracy~Session, data=newD)
lincon(Accuracy~Session, data=newD)

newD<-subset(Pre, Condition=='None')
t1way(Accuracy~Session, data=newD)
lincon(Accuracy~Session, data=newD)

################################################################
## Premises pairs S1+ Pair Type
################################################################
Premises<-read.csv("Premises_S1_S2.csv")
PremisesLitte<-Premises[,c(1,4,5,6)]
names(PremisesLitte)[3]<-'Condition'
# convert into factors
Premises2 <- PremisesLitte%>%
  convert_as_factor(ID, Condition,Pair)

#2ways anova
t2way(Acc~Pair*Condition, data=Premises2)

newD1<-subset(PremisesLitte, Condition=='Down')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte, Condition=='Up')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte, Condition=='None')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

################################################################
## Premises pairs S2+ Pair Type
################################################################

PremisesLitte<-Premises[,c(1,4,5,9)]
names(PremisesLitte)[3]<-'Condition'
names(PremisesLitte)[4]<-'Acc'
# convert into factors
Premises2 <- PremisesLitte%>%
  convert_as_factor(ID, Condition,Pair)

#2ways anova
t2way(Acc~Pair*Condition, data=Premises2)

newD1<-subset(PremisesLitte, Condition=='Down')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte, Condition=='Up')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte, Condition=='None')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)


################################################################
## Premises pairs S3+ Pair Type
################################################################
Premises3<-read.csv("Premises_S3.csv") #session 3
PremisesLitte2<-Premises3[,c(1,4,5,6)];remove(Premises3)
PremisesLitte2 <- PremisesLitte2%>%  convert_as_factor(ID,Cued,Pair)
names(PremisesLitte2)[3]<-'Condition'
names(PremisesLitte2)[4]<-'Acc'


#2ways anova
t2way(Acc~Pair*Condition, data=PremisesLitte2)

newD1<-subset(PremisesLitte2, Condition=='Down')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte2, Condition=='Up')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

newD1<-subset(PremisesLitte2, Condition=='None')
t1way(Acc~Pair, data=newD1,tr = 0.1)
lincon(Acc~Pair, data=newD1,tr = 0.1)

###############################################################
## INFERENCES S2
###############################################################
Inferences<-read.csv("Inferences_S2.csv")
InferencesLitte<-Inferences[,c(1,5,7)]
InferencesLitte<-InferencesLitte %>% convert_as_factor(ID, Cued)
names(InferencesLitte)[2]<-'Condition'

t1way(Acc~Condition,data=InferencesLitte) #one way anova
lincon(Acc~Condition,data=InferencesLitte) #post-hoc

###############################################################
## INFERENCES S2 BY DEGREE OF SEPARATION
###############################################################
InferencesLitte<-Inferences[,c(1,5,6,7)]
InferencesLitte<-InferencesLitte %>% convert_as_factor(ID, Cued,Distance)
names(InferencesLitte)[2]<-'Condition'

t2way(Acc~Condition*Distance,data=InferencesLitte) #2-way2 anova
mcp2atm(Acc~Condition*Distance,data=InferencesLitte) #post=hocs 

newD1<-subset(InferencesLitte, Condition=='Down')
t1way(Acc~Distance, data=newD1,tr = 0.1)


newD1<-subset(InferencesLitte, Condition=='Up')
t1way(Acc~Distance, data=newD1,tr = 0.1)

newD1<-subset(InferencesLitte, Condition=='None')
t1way(Acc~Distance, data=newD1,tr = 0.1)


newD1<-subset(InferencesLitte, Distance=='Distance1')
t1way(Acc~Condition, data=newD1,tr = 0.1)
lincon(Acc~Condition,data=newD1) #post-hoc

newD1<-subset(InferencesLitte, Distance=='Distance2')
t1way(Acc~Condition, data=newD1,tr = 0.1)
lincon(Acc~Condition,data=newD1) #post-hoc
###############################################################
## INFERENCES S2 AND S3
##########################################################
Inferences<-read.csv("Inferences_S2.csv")
InferencesLitte<-Inferences[,c(1,5,7)]
InferencesLitte$Session='Session2'

Inferences2<-read.csv("Inferences_S3.csv")
InferencesLitte2<-Inferences2[,c(1,5,7)]
InferencesLitte2$Session='Session3'
Pre<-rbind(InferencesLitte,InferencesLitte2)
names(Pre)[2]<-'Condition'
Pre <- Pre %>%convert_as_factor(ID, Session,Condition)

# mixed anova
bwtrim(Acc~Session*Condition,id=ID,data=Pre)
# manual post-hocs
newD<-subset(Pre, Session=='Session2')
t1way(Acc~Condition, data=newD, tr=0.1)
lincon(Acc~Condition, data=newD,tr=0.1)

newD<-subset(Pre, Session=='Session3')
t1way(Acc~Condition, data=newD, tr=0.1)
lincon(Acc~Condition, data=newD,tr=0.1)

newD<-subset(Pre, Condition=='Down')
t1way(Acc~Session, data=newD)


newD<-subset(Pre, Condition=='Up')
t1way(Acc~Session, data=newD)

newD<-subset(Pre, Condition=='None')
t1way(Acc~Session, data=newD)

###############################################################
## INFERENCES S3 BY DEGREE OF SEPARATION
###############################################################
Inferences2<-read.csv("Inferences_S3.csv")
InferencesLitte<-Inferences2[,c(1,5,6,7)]
InferencesLitte<-InferencesLitte %>% convert_as_factor(ID, Cued,Distance)
names(InferencesLitte)[2]<-'Condition'

t2way(Acc~Condition*Distance,data=InferencesLitte) #one way anova
mcp2atm(Acc~Condition*Distance,data=InferencesLitte) #post=hocs way anova

newD1<-subset(InferencesLitte, Condition=='Down')
t1way(Acc~Distance, data=newD1,tr = 0.1)


newD1<-subset(InferencesLitte, Condition=='Up')
t1way(Acc~Distance, data=newD1,tr = 0.1)

newD1<-subset(InferencesLitte, Condition=='None')
t1way(Acc~Distance, data=newD1,tr = 0.1)


newD1<-subset(InferencesLitte, Distance=='Distance1')
t1way(Acc~Condition, data=newD1,tr = 0.1)
lincon(Acc~Condition,data=newD1) #post-hoc

newD1<-subset(InferencesLitte, Distance=='Distance2')
t1way(Acc~Condition, data=newD1,tr = 0.1)
lincon(Acc~Condition,data=newD1) #post-hoc

###############################################################
## INFERENCES S2 AND S3 BY DEGREE OF SEPARATION
##########################################################
Inferences<-read.csv("Inferences_S2.csv")
InferencesLitte<-Inferences[,c(1,5,6,7)]
InferencesLitte$Session='Session2'

Inferences2<-read.csv("Inferences_S3.csv")
InferencesLitte2<-Inferences2[,c(1,5,6,7)]
InferencesLitte2$Session='Session3'
Pre<-rbind(InferencesLitte,InferencesLitte2)
names(Pre)[2]<-'Condition'
Pre <- Pre %>%convert_as_factor(ID, Session,Condition)

######################### DOWN ONLY #############
Down<-subset(Pre, Condition=='Down')
# mixed anova
bwtrim(Acc~Session*Distance,id=ID,data=Down)
# manual post-hocs
newD<-subset(Down, Session=='Session2')
t1way(Acc~Distance, data=newD, tr=0.1)


newD<-subset(Down, Session=='Session3')
t1way(Acc~Distance, data=newD, tr=0.1)

newD<-subset(Down, Distance=='Distance1')
t1way(Acc~Session, data=newD)

newD<-subset(Down, Distance=='Distance2')
t1way(Acc~Session, data=newD)

######################### UP ONLY #############
Up<-subset(Pre, Condition=='Up')
# mixed anova
bwtrim(Acc~Session*Distance,id=ID,data=Up)
# manual post-hocs
newD<-subset(Up, Session=='Session2')
t1way(Acc~Distance, data=newD, tr=0.1)


newD<-subset(Up, Session=='Session3')
t1way(Acc~Distance, data=newD, tr=0.1)

newD<-subset(Up, Distance=='Distance1')
t1way(Acc~Session, data=newD)

newD<-subset(Up, Distance=='Distance2')
t1way(Acc~Session, data=newD)
######################## CONTROL ONLY #############
Non<-subset(Pre, Condition=='None')
# mixed anova
bwtrim(Acc~Session*Distance,id=ID,data=Non)
# manual post-hocs
newD<-subset(Non, Session=='Session2')
t1way(Acc~Distance, data=newD, tr=0.1)


newD<-subset(Non, Session=='Session3')
t1way(Acc~Distance, data=newD, tr=0.1)

newD<-subset(Non, Distance=='Distance1')
t1way(Acc~Session, data=newD)

newD<-subset(Non, Distance=='Distance2')
t1way(Acc~Session, data=newD)
##########################################################
## CONFIDENT INTERVALS 
#########################################################

#Session 2: premises vs inference pairs
dataF<-read.csv("Session2_with_ConfidentIntervals.csv")
dataL<-dataF[,c(10,4,5,7,9)]
dataLittle<-subset(dataL,PairType!=c('Anchor'))
dataLittle<- dataLittle%>%convert_as_factor(ID, PairType,Condition)

t2way(Confidence~PairType*Condition, data=dataLittle)
mcp2atm(Confidence~PairType*Condition, data=dataLittle)

newD1<-subset(dataLittle, Condition=='Down')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Control')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Up')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, PairType=='Premise')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

newD1<-subset(dataLittle, PairType=='Inference')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

#Session 2: 1st degree vs 2nd degree
dataLittle<-subset(dataL,PairType=='Inference')
dataLittle<- dataLittle%>%convert_as_factor(ID, PairType,Condition,Distance)

t2way(Confidence~Distance*Condition, data=dataLittle)
mcp2atm(Confidence~Distance*Condition, data=dataLittle)

newD1<-subset(dataLittle, Condition=='Down')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Control')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Up')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)


newD1<-subset(dataLittle, Distance=='Distance1')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

newD1<-subset(dataLittle, Distance=='Distance2')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

#Session 3: premises vs inference pairs
dataF<-read.csv("Session3_with_ConfidentIntervals.csv")
dataL<-dataF[,c(10,4,5,7,9)]
dataLittle<-subset(dataL,PairType!=c('Anchor'))
dataLittle<- dataLittle%>%convert_as_factor(ID, PairType,Condition)


t2way(Confidence~PairType*Condition, data=dataLittle)
mcp2atm(Confidence~PairType*Condition, data=dataLittle)

newD1<-subset(dataLittle, Condition=='Down')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Control')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Up')
t1way(Confidence~PairType, data=newD1,tr = 0.1)
groupwiseMean(Confidence~PairType, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, PairType=='Premise')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

newD1<-subset(dataLittle, PairType=='Inference')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

#Session 3: 1st degree vs 2nd degree
dataLittle<-subset(dataL,PairType=='Inference')
dataLittle<- dataLittle%>%convert_as_factor(ID, PairType,Condition,Distance)


t2way(Confidence~Distance*Condition, data=dataLittle)
mcp2atm(Confidence~Distance*Condition, data=dataLittle)

newD1<-subset(dataLittle, Condition=='Down')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Control')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Condition=='Up')
t1way(Confidence~Distance, data=newD1,tr = 0.1)
groupwiseMean(Confidence~Distance, data= newD1,conf= 0.95,digits =4)

newD1<-subset(dataLittle, Distance=='Distance1')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs

newD1<-subset(dataLittle, Distance=='Distance2')
t1way(Confidence~Condition, data=newD1,tr = 0.1)
lincon(Confidence~Condition,data=newD1) #post-hocs
