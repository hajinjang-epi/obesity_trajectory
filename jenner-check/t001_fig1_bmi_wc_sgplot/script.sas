/* Adapted from obesity_figures.sas (Figure 1: age-standardized mean BMI and
   waist circumference trends by KNHANES wave). The DATA steps below are the
   author's own age-standardized estimates, embedded as inline CARDS in the
   original script -- shipped here unmodified. Only the upstream
   PROC SURVEYREG step (which requires the private KNHANES extract) is
   omitted; the plotting logic, titles and axis options are exactly as
   written, with COLOR=lightred swapped for COLOR=salmon (see meta.json). */

DATA FIG1_BMI;
INPUT TERM MEN WOMEN;
CARDS;
1	23.091	23.0992
2	23.6126	23.2558
3	23.8594	23.2736
4	23.9514	23.0241
5	23.954	23.0591
6	24.1319	22.9494
7	24.3583	22.9637
;
RUN;

DATA FIG1_WC;
INPUT TERM MEN WOMEN;
CARDS;
1	82.6179	77.9428
2	83.9133	78.0294
3	83.5592	77.6799
4	83.9073	77.8499
5	83.6596	77.1557
6	84.1809	76.9751
7	85.4008	76.9539
;
RUN;

title  font='Times New Roman' 'Age Standardized Mean BMI Trends in Men and Women';
footnote justify=center font='Times New Roman' color=grey h=9pt "BMI (Body Mass Index)                                                                                                                                                                       Age-standardized by 2005 population";
proc sgplot data=FIG1_BMI;
  series x=TERM y=MEN/ legendlabel='Men' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=salmon) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="(kg/m2)" labelpos=top MIN=22 MAX=25 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

title  font='Times New Roman' 'Age Standardized Mean WC Trends in Men and Women';
footnote justify=center font='Times New Roman' color=grey h=9pt "WC (Waist Circumference)                                                                                                                                                                      Age-standardized by 2005 population";
proc sgplot data=FIG1_WC;
  series x=TERM y=MEN/ legendlabel='Men' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=salmon) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="(cm)" labelpos=top MIN=76 MAX=88 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;
