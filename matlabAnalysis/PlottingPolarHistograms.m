% Read csv file
T=readtable('C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_F3.csv');
Up_Exp=[T.Up_Exp];
Up_Cont=[T.Up_Control];
Down_Exp=[T.Down_Exp];
Down_Cont=[T.Down_Control];
% Up Control vs Exp (up is yellow)
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.8500 0.3250 0.0980],'FaceAlpha',0.6);
a=gca;set(a,'FontWeight','bold','FontSize',20);set(a,'RTick',[2,4,6,8,10],'RTicKLabel',{'2','4','6','8','10'});
title('Up: cont vs exp');saveas(gcf,'Phase_Up_EpxCont_F3.tiff');close(gcf);
% Down Control vs Exp (down is purple)
figure;polarhistogram((Down_Exp.*pi/180),15,'FaceColor',[0.6940 0.1840 0.5560]);
hold on;polarhistogram((Down_Cont.*pi/180),15,'FaceColor',[0.4940 0.1840 0.5560],'FaceAlpha',0.6);
title('Down: cont vs exp');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});saveas(gcf,'Phase_Down_ExpCont_F3.tiff');close(gcf);
% Exp Up vs Down
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Exp.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Experimental sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Exp_UpDown_F3.tiff');close(gcf);
% Control Up vs Down
figure;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Cont.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Control sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Cont_UpDown_F3.tiff');close(gcf);

%%
% Read csv file
T=readtable('C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_F4.csv');
Up_Exp=[T.Up_Exp];
Up_Cont=[T.Up_Control];
Down_Exp=[T.Down_Exp];
Down_Cont=[T.Down_Control];
% Up Control vs Exp (up is yellow)
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.8500 0.3250 0.0980],'FaceAlpha',0.6);
a=gca;set(a,'FontWeight','bold','FontSize',20);set(a,'RTick',[2,4,6,8,10],'RTicKLabel',{'2','4','6','8','10'});
title('Up: cont vs exp');saveas(gcf,'Phase_Up_EpxCont_F4.tiff');close(gcf);
% Down Control vs Exp (down is purple)
figure;polarhistogram((Down_Exp.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
hold on;polarhistogram((Down_Cont.*pi/180),18,'FaceColor',[0.4940 0.1840 0.5560],'FaceAlpha',0.6);
title('Down: cont vs exp');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});saveas(gcf,'Phase_Down_ExpCont_F4.tiff');close(gcf);
% Exp Up vs Down
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Exp.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Experimental sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Exp_UpDown_F4.tiff');close(gcf);
% Control Up vs Down
figure;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Cont.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Control sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Cont_UpDown_F4.tiff');close(gcf);
%%
T=readtable('C:/Users/sapls6/Documents/MATLAB/TransitiveInference_Dec2020/CL_TMR_AvgPhases_Fz.csv');
Up_Exp=[T.Up_Exp];
Up_Cont=[T.Up_Control];
Down_Exp=[T.Down_Exp];
Down_Cont=[T.Down_Control];
% Up Control vs Exp (up is yellow)
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.8500 0.3250 0.0980],'FaceAlpha',0.6);
a=gca;set(a,'FontWeight','bold','FontSize',20);set(a,'RTick',[2,4,6,8,10],'RTicKLabel',{'2','4','6','8','10'});
title('Up: cont vs exp');saveas(gcf,'Phase_Up_EpxCont_Fz.tiff');close(gcf);
% Down Control vs Exp (down is purple)
figure;polarhistogram((Down_Exp.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
hold on;polarhistogram((Down_Cont.*pi/180),18,'FaceColor',[0.4940 0.1840 0.5560],'FaceAlpha',0.6);
title('Down: cont vs exp');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Down_ExpCont_Fz.tiff');close(gcf);
% Exp Up vs Down
figure;polarhistogram((Up_Exp.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Exp.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Experimental sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Exp_UpDown_Fz.tiff');close(gcf);
% Control Up vs Down
figure;polarhistogram((Up_Cont.*pi/180),10,'FaceColor',[0.9290 0.6940 0.1250]);
hold on;polarhistogram((Down_Cont.*pi/180),18,'FaceColor',[0.6940 0.1840 0.5560]);
title('Control sounds: Up vs Down');a=gca;set(a,'FontWeight','bold','FontSize',20);
set(a,'RTick',[2,5,10],'RTicKLabel',{'2','5','10'});
saveas(gcf,'Phase_Cont_UpDown_Fz.tiff');close(gcf);
