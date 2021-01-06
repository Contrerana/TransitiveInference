dataF<-read.csv("Plotting_Inferences_Distances.csv")
data1<-subset(dataF, Distance==1)
ggplot(data1,aes(x=Condition,y=acc,group=Session,colour=Session))+
  geom_line()+
  geom_point(shape = 15,size  = 4, position = position_dodge(.2))+
  geom_errorbar(aes(ymin=ci_l, ymax=ci_up),width=0.2,position = position_dodge(.2))+
  ylim(0.3,0.9)+
  labs(title="Distance 1", x="Condition", y = "Accuracy")+
  theme_classic() +
  scale_color_manual(values=c('#999999','#E69F00'))

data1<-subset(dataF, Distance==2)
ggplot(data1,aes(x=Condition,y=acc,group=Session,colour=Session))+
  geom_line()+
  geom_point(shape = 15,size  = 4, position = position_dodge(.2))+
  geom_errorbar(aes(ymin=ci_l, ymax=ci_up),width=0.2,position = position_dodge(.2))+
  ylim(0.3,0.9)+
  labs(title="Distance 2", x="Condition", y = "Accuracy")+
  theme_classic() +
  scale_color_manual(values=c('#999999','#E69F00'))


library(gmodels)

A<-subset(Pre, Condition=='Down')
A<-subset(A,Distance=='Distance2')
######ci(A$Acc,confidence = 0.095)

library(rcompanion)
Sum = groupwiseMean(Acc~ Session,
                    data   = A,
                    conf   = 0.95,
                    digits = 3)
Sum

##########################
dataF<-read.csv("Plotting_ConfidenceIntervals_PremisesVSinferences.csv")
data1<-subset(dataF, Session=='S2')
data1<- data1%>%convert_as_factor(Condition, PairType)
ggplot(data1,aes(x=Condition,y=score,group=PairType,colour=PairType))+
  geom_line()+
  geom_point(shape = 15,size  = 4, position = position_dodge(.2))+
  geom_errorbar(aes(ymin=ci_l, ymax=ci_up),width=0.2,position = position_dodge(.2))+
  labs(title="Session 2", x="Condition", y = "Score")+
  theme_classic() +
  scale_color_manual(values=c('#999999','#E69F00'))

data1<-subset(dataF, Session=='S3')
data1<- data1%>%convert_as_factor(Condition, PairType)
ggplot(data1,aes(x=Condition,y=score,group=PairType,colour=PairType))+
  geom_line()+
  geom_point(shape = 15,size  = 4, position = position_dodge(.2))+
  geom_errorbar(aes(ymin=ci_l, ymax=ci_up),width=0.2,position = position_dodge(.2))+
  labs(title="Session 3", x="Condition", y = "Score")+
  theme_classic() +
  scale_color_manual(values=c('#999999','#E69F00'))