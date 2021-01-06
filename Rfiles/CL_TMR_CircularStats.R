rm(list=ls()); ##clean environment
##Libraries
library("circular")
library(ggplot2)
# load behaviour table
dataBeh<-read.csv("C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_Phases_v2.csv")
# take the F3 only
#F3 <- dataBeh$Phase2F3
#F3 <- dataBeh$Phase2F4
Fz <- dataBeh$Phase2F4
#find the mean per participant
ID<-dataBeh$Participant
NoID<-unique(ID)
PhaseAvg<-data.frame(Up_Control=numeric(0),Up_Exp=numeric(0),Down_Control=numeric(0),Down_Exp=numeric(0));

for (pt in 1:length(NoID)){
  #get values per condition per participant and transform data to circular class
  Up_Control<- circular(F3[which(dataBeh$Participant==NoID[pt] & dataBeh$Cond=="Up_Con")],units="degrees")
  Up_Exp<- circular(F3[which(dataBeh$Participant==NoID[pt] & dataBeh$Cond=="Up_Exp")],units="degrees")
  Down_Control<- circular(F3[which(dataBeh$Participant==NoID[pt] & dataBeh$Cond=="Down_Con")],units="degrees")
  Down_Exp<- circular(F3[which(dataBeh$Participant==NoID[pt] & dataBeh$Cond=="Down_Exp")],units="degrees")
  #  means
  PhaseAvg[pt,]<-c(mean.circular(Up_Control),mean.circular(Up_Exp),
                      mean.circular(Down_Control),mean.circular(Down_Exp))
}
# save the AvgPhase
#write.csv(PhaseAvg,"C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_F3.csv")
#write.csv(PhaseAvg,"C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_F4.csv")
write.csv(PhaseAvg,"C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_Fz.csv")
# Do stats (whatson's two-sample test)
watson.two.test(circular(PhaseAvg$Up_Control,units="degrees"),circular(PhaseAvg$Up_Exp,units="degrees"))
watson.two.test(circular(PhaseAvg$Down_Control,units="degrees"),circular(PhaseAvg$Down_Exp,units="degrees"))
watson.two.test(circular(PhaseAvg$Up_Control,units="degrees"),circular(PhaseAvg$Down_Control,units="degrees"))
watson.two.test(circular(PhaseAvg$Up_Exp,units="degrees"),circular(PhaseAvg$Down_Exp,units="degrees"))
# plot
rose.diag(circular(PhaseAvg$Up_Exp,units="degrees"),pch=16,cex=1,axes=T,shrink=1,bins=20,col=2)
