/* Adapted from obesity_figures.sas (Figure 3/4: obesity and central-obesity
   prevalence by age, paneled by birth cohort and stratified by education
   level, using a LOESS smoother). The DATA...CARDS block below is a
   representative subset of the author's own age-standardized prevalence
   values by SEX*TYPE*COHORT*EDU*COAGE (the full figure spans 4 cohorts;
   this bundle keeps cohorts 1-2 for men's overall-obesity series to stay
   within the runner's captured-row cap while exercising the same
   reshape-then-panel logic). The reshape DATA step and the
   PROC SGPANEL/LOESS call are the author's own code, copied verbatim,
   except ROWAXIS's LABELPOS=top is dropped (LABELPOS is a valid XAXIS/
   YAXIS option in PROC SGPLOT but is not a documented ROWAXIS/COLAXIS
   option in PROC SGPANEL). The upstream PROC SURVEYFREQ step that
   produces these estimates from the private KNHANES extract is omitted. */

DATA FIG34;
INPUT SEX TYPE COHORT EDU COAGE FREQ;
CARDS;
1	1	1	1	4	28.1901
1	1	1	1	5	34.21
1	1	1	1	6	34.5553
1	1	1	1	7	39.1739
1	1	1	1	8	37.0315
1	1	1	1	9	34.9497
1	1	1	1	10	36.3858
1	1	1	2	4	32.8164
1	1	1	2	5	38.8726
1	1	1	2	6	42.2112
1	1	1	2	7	40.6416
1	1	1	2	8	40.2389
1	1	1	2	9	42.1153
1	1	1	2	10	41.5991
1	1	2	1	2	21.9644
1	1	2	1	3	26.8761
1	1	2	1	4	32.9154
1	1	2	1	5	41.4319
1	1	2	1	6	37.9479
1	1	2	1	7	39.2536
1	1	2	1	8	37.9902
1	1	2	2	2	17.4072
1	1	2	2	3	32.5907
1	1	2	2	4	41.9544
1	1	2	2	5	43.2818
1	1	2	2	6	42.3739
1	1	2	2	7	43.1475
1	1	2	2	8	44.1686
;
RUN;

DATA FIG34;
SET FIG34;
IF SEX=1 THEN DO;
IF TYPE=1 AND EDU=1 THEN MENOBE_EDU1=FREQ;
ELSE IF TYPE=1 AND EDU=2 THEN MENOBE_EDU2=FREQ;
END;
RUN;

title  font='Times New Roman' "Overall Obesity in Men's Birth Cohorts Stratified by Education Levels & Ages";
footnote font='Times New Roman'  h=8pt 'Overall Obesity: BMI >= 25 kg/m2';
PROC SGPANEL DATA=FIG34;
PANELBY COHORT/novarname headerattrs=(family="Times New Roman");
LOESS X=COAGE Y=MENOBE_EDU1/legendlabel="High School Graduate or Below"  lineattrs=(pattern=solid color=indianred) nomarkers SMOOTH=0.7;
LOESS X=COAGE Y=MENOBE_EDU2/legendlabel="College Graduate or Higher" lineattrs=(pattern=solid color=mediumseagreen) nomarkers SMOOTH=0.7;
  keylegend / titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
colAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") values=(1 to 10 by 1);
rowaxis label="Percent" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") max=50;
run;
