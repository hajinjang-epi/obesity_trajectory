libname B "C:\Users\HajinJang\Documents\FINAL";

/*------------------------------------------------- FIGURES & TABLES -------------------------------------------------*/
/*Figure1) 연령표준화한 기수별 
A) MEAN BMI
B) MEAN WC
C) OVERALL OBESITY PREVALENCE
D) CENTRAL OBESITY PREVALENCE*/

proc surveyreg data=B.OBE_4 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain SEX*TERM;
model he_bmi=cage /noint vadjust=NONE;
estimate 'BMI_평균'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
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

proc surveyreg data=B.OBE_4 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain SEX*TERM;
model he_wc=cage /noint vadjust=NONE;
estimate 'WC_평균'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
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
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="(kg/m2)" labelpos=top MIN=22 MAX=25 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

title  font='Times New Roman' 'Age Standardized Mean WC Trends in Men and Women';
footnote justify=center font='Times New Roman' color=grey h=9pt "WC (Waist Circumference)                                                                                                                                                                      Age-standardized by 2005 population";
proc sgplot data=FIG1_WC;
  series x=TERM y=MEN/ legendlabel='Men' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="(cm)" labelpos=top MIN=76 MAX=88 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

/*p-trend 보기*/
PROC REG DATA=FIG1_BMI;
MODEL MEN=TERM ;
RUN;
PROC REG DATA=FIG1_BMI;
MODEL WOMEN=TERM;
RUN;
PROC REG DATA=FIG1_WC;
MODEL MEN=TERM ;
RUN;
PROC REG DATA=FIG1_WC;
MODEL WOMEN=TERM;
RUN;

proc surveyreg data=B.OBE_4 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain SEX*TERM;
model obe=cage /noint vadjust=NONE;
estimate '비만율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
DATA FIG1_OBE;
INPUT TERM MEN WOMEN;
CARDS;
1	24.61	25.93
2	31.07	27.41
3	34.07	27.12
4	35.14	25.2
5	35	26.15
6	37.16	24.26
7	40.7	24.8
;
RUN;

proc surveyreg data=B.OBE_4 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain SEX*TERM;
model ab_obe=cage /noint vadjust=NONE ;
estimate '복부비만율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
DATA FIG1_ABOBE;
INPUT TERM MEN WOMEN;
CARDS;
1	19.84	22.1
2	22.64	22.97
3	24.06	21.93
4	24.4	22.09
5	23.55	20.75
6	25.09	18.95
7	30.05	19.53
;
RUN;

title  font='Times New Roman' 'Age Standardized Overall Obesity Trends in Men and Women';
footnote justify=center font='Times New Roman'color=grey h=9pt "Overall obesity: BMI≥25 kg/m2                                                                                                                                                                       Age-standardized by 2005 population";
proc sgplot data=FIG1_OBE;
  series x=TERM y=MEN/ legendlabel='Men' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Percent" labelpos=top MIN=10 MAX=46.5 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

title  font='Times New Roman' 'Age Standardized Central Obesity Trends in Men and Women';
footnote justify=center font='Times New Roman'color=grey h=9pt "Central obesity: WC≥85 cm                                                                                                                                                                   Age-standardized by 2005 population";
proc sgplot data=FIG1_ABOBE;
  series x=TERM y=MEN/ legendlabel='Men' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=TERM y=WOMEN/ legendlabel='Women' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="KNHANES wave" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Percent" labelpos=top MIN=10 MAX=46.5 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

/*p-trend 보기*/
PROC REG DATA=FIG1_OBE;
MODEL MEN=TERM ;
RUN;
PROC REG DATA=FIG1_OBE;
MODEL WOMEN=TERM;
RUN;
PROC REG DATA=FIG1_OBE;
MODEL MEN=TERM ;
RUN;
PROC REG DATA=FIG1_OBE;
MODEL WOMEN=TERM;
RUN;



/*FIGURE2) 남녀 출생코호트 연령에 따른 BMI, WC 평균*/
PROC SURVEYMEANS DATA=B.OBE_4 NOMCAR;
STRATA kstrata;
CLUSTER psu;
WEIGHT wt_pool_2;
DOMAIN SEX*BIRTHCOHORT*AGE;
VAR HE_BMI;
RUN;
PROC SURVEYMEANS DATA=B.OBE_4 NOMCAR;
STRATA kstrata;
CLUSTER psu;
WEIGHT wt_pool_2;
DOMAIN SEX*BIRTHCOHORT*AGE;
VAR HE_WC;
RUN;
DATA FIG2;
INPUT SEX COHORT AGE BMI WC;
CARDS;
1	1	39	23.676424	83.311419
1	1	40	23.581382	83.498398
1	1	41	23.980373	84.978214
1	1	42	23.97827	85.600934
1	1	43	24.465742	85.777098
1	1	44	23.994466	85.662476
1	1	45	23.445114	84.288774
1	1	46	24.684106	86.137374
1	1	47	23.915468	84.751464
1	1	48	23.871439	84.97397
1	1	49	24.265449	85.820532
1	1	50	23.693253	84.142447
1	1	51	24.305592	85.529814
1	1	52	24.314509	85.714556
1	1	53	24.154251	85.477384
1	1	54	24.377654	85.669511
1	1	55	24.050306	85.114145
1	1	56	24.195216	85.545997
1	1	57	24.174798	85.839964
1	1	58	24.468543	86.558034
1	1	59	24.038143	85.489732
1	1	60	24.402238	86.463891
1	1	61	24.195025	86.33841
1	1	62	23.943615	85.869586
1	1	63	24.267007	86.877593
1	1	64	24.03862	86.622331
1	1	65	23.848757	85.910392
1	1	66	24.233717	86.978441
1	1	67	23.979539	86.575051
1	1	68	24.126458	87.184813
1	2	29	22.806086	80.311664
1	2	30	22.843583	80.625347
1	2	31	22.501218	79.779682
1	2	32	23.980508	83.54142
1	2	33	23.699514	83.140909
1	2	34	23.662907	84.036092
1	2	35	23.421174	83.123972
1	2	36	23.961363	84.007995
1	2	37	23.85035	83.404284
1	2	38	24.336108	84.524176
1	2	39	24.239868	84.144893
1	2	40	24.299973	84.983711
1	2	41	24.787526	85.88232
1	2	42	24.565474	84.868777
1	2	43	24.145115	84.335115
1	2	44	24.570559	85.385698
1	2	45	23.975585	83.742324
1	2	46	24.508175	84.971424
1	2	47	24.373657	84.917758
1	2	48	24.2498	84.594747
1	2	49	24.434609	85.538289
1	2	50	24.60063	85.817147
1	2	51	24.565977	86.048669
1	2	52	24.264387	85.889303
1	2	53	24.45118	86.343686
1	2	54	24.471318	86.362184
1	2	55	24.295303	86.52611
1	2	56	24.474712	86.311996
1	2	57	23.723595	84.730648
1	2	58	24.76912	87.499885
1	3	19	21.550365	76.829869
1	3	20	22.354698	76.912615
1	3	21	22.158515	76.606563
1	3	22	22.603444	78.268254
1	3	23	21.928977	76.972771
1	3	24	22.9701	79.97591
1	3	25	22.762713	78.97739
1	3	26	23.37629	80.215894
1	3	27	23.047013	80.82212
1	3	28	23.691973	81.984608
1	3	29	23.834669	82.768738
1	3	30	24.045102	83.000634
1	3	31	24.01178	82.626566
1	3	32	24.334741	83.661077
1	3	33	24.196495	83.890978
1	3	34	24.543116	84.309068
1	3	35	24.316084	84.064819
1	3	36	23.939422	83.195591
1	3	37	24.403093	84.573994
1	3	38	24.279213	83.710534
1	3	39	24.513544	84.792127
1	3	40	24.617958	84.99559
1	3	41	24.863204	85.484933
1	3	42	24.92959	85.928739
1	3	43	25.058044	86.481502
1	3	44	24.740186	85.935578
1	3	45	24.646436	85.921037
1	3	46	24.461182	86.064501
1	3	47	25.121972	87.52244
1	3	48	24.575074	86.192668
1	4	19	22.668444	78.101802
1	4	20	22.14173	77.225377
1	4	21	22.943388	79.216544
1	4	22	23.076694	78.710723
1	4	23	22.734587	78.881891
1	4	24	23.438929	80.689229
1	4	25	23.592864	81.038633
1	4	26	23.779767	81.944666
1	4	27	24.196149	82.670298
1	4	28	23.964751	82.500824
1	4	29	24.383909	83.427017
1	4	30	24.668457	84.297944
1	4	31	24.41162	84.444968
1	4	32	24.673814	85.635973
1	4	33	24.692666	85.39269
1	4	34	25.232761	87.254986
1	4	35	24.580971	85.991435
1	4	36	24.812189	86.216047
1	4	37	25.058916	87.284101
1	4	38	25.022897	86.678104
2	1	39	22.892551	76.194313
2	1	40	23.231234	77.149626
2	1	41	23.119713	75.829835
2	1	42	23.758369	79.014688
2	1	43	23.811524	78.423333
2	1	44	23.723779	78.534868
2	1	45	24.220238	79.808725
2	1	46	23.954084	78.937392
2	1	47	23.901155	78.816352
2	1	48	23.869604	79.584072
2	1	49	23.850964	79.504234
2	1	50	23.786735	80.041857
2	1	51	23.905858	80.155708
2	1	52	24.045662	80.151805
2	1	53	24.26051	81.235476
2	1	54	24.262306	81.357136
2	1	55	24.073765	80.394753
2	1	56	23.961778	80.629602
2	1	57	24.321593	81.810185
2	1	58	24.181804	81.389635
2	1	59	24.114386	80.977409
2	1	60	24.128036	81.357643
2	1	61	24.285607	82.201037
2	1	62	24.311956	81.864862
2	1	63	24.219447	82.051172
2	1	64	24.411192	82.708045
2	1	65	24.385759	83.334788
2	1	66	24.371069	83.383089
2	1	67	24.731087	83.005043
2	1	68	24.056784	82.827412
2	2	29	22.054737	72.923282
2	2	30	22.361669	75.038586
2	2	31	22.248422	74.214594
2	2	32	22.337304	74.186013
2	2	33	22.743534	76.048304
2	2	34	22.485728	74.974997
2	2	35	22.664485	75.868
2	2	36	22.87277	75.916068
2	2	37	23.035302	76.041448
2	2	38	22.823648	75.333963
2	2	39	22.852265	76.289677
2	2	40	23.267721	76.442363
2	2	41	22.880342	76.214861
2	2	42	23.368178	77.762804
2	2	43	23.533143	77.867093
2	2	44	23.474259	77.701238
2	2	45	23.603938	78.099575
2	2	46	23.548837	77.921697
2	2	47	23.502743	78.11954
2	2	48	23.552432	78.432807
2	2	49	23.779477	78.568507
2	2	50	23.786895	78.73989
2	2	51	23.709929	78.84647
2	2	52	23.58754	78.32971
2	2	53	23.75585	79.212374
2	2	54	23.795248	79.372103
2	2	55	23.667849	79.032027
2	2	56	23.632148	79.824035
2	2	57	23.794553	80.090852
2	2	58	24.122711	80.293014
2	3	19	21.254345	71.763643
2	3	20	21.35355	71.073398
2	3	21	20.753715	70.194755
2	3	22	20.99191	70.848546
2	3	23	21.404862	72.099469
2	3	24	21.3767	71.400137
2	3	25	21.106888	71.128575
2	3	26	22.00947	73.506921
2	3	27	21.629143	73.133955
2	3	28	22.223465	74.104265
2	3	29	22.379157	75.461396
2	3	30	22.147759	75.038936
2	3	31	21.674998	73.85498
2	3	32	21.960831	74.41915
2	3	33	22.482439	75.640195
2	3	34	22.513245	75.862619
2	3	35	22.537165	75.66989
2	3	36	22.626202	75.644444
2	3	37	22.568145	75.630058
2	3	38	22.560095	75.704594
2	3	39	22.90224	76.35912
2	3	40	22.699256	75.924649
2	3	41	23.087116	76.355098
2	3	42	22.803556	76.230386
2	3	43	22.825576	76.322427
2	3	44	23.125564	77.131454
2	3	45	23.232879	76.884778
2	3	46	23.502425	78.462068
2	3	47	23.311374	77.304593
2	3	48	23.029565	76.532835
2	4	19	21.677121	72.178842
2	4	20	21.462185	72.675095
2	4	21	21.431054	71.652417
2	4	22	22.032384	73.041897
2	4	23	21.104001	70.664941
2	4	24	21.46792	72.176691
2	4	25	21.372585	72.000701
2	4	26	21.233252	71.426547
2	4	27	21.856902	73.661375
2	4	28	21.908636	73.201166
2	4	29	22.239997	74.430566
2	4	30	22.073655	74.250226
2	4	31	21.931887	74.177243
2	4	32	22.359204	74.675427
2	4	33	22.125548	74.842141
2	4	34	22.76866	76.369022
2	4	35	22.358296	75.738166
2	4	36	22.492455	76.076454
2	4	37	22.55515	75.534667
2	4	38	22.366756	76.514207
;
RUN;

DATA FIG2;
SET FIG2;
IF SEX=1 THEN DO;
IF COHORT=1 THEN M1_BMI=BMI;
ELSE IF COHORT=2 THEN M2_BMI=BMI;
ELSE IF COHORT=3 THEN M3_BMI=BMI;
ELSE IF COHORT=4 THEN M4_BMI=BMI;
END;
IF SEX=2 THEN DO;
IF COHORT=1 THEN W1_BMI=BMI;
ELSE IF COHORT=2 THEN W2_BMI=BMI;
ELSE IF COHORT=3 THEN W3_BMI=BMI;
ELSE IF COHORT=4 THEN W4_BMI=BMI;
END;
IF SEX=1 THEN DO;
IF COHORT=1 THEN M1_WC=WC;
ELSE IF COHORT=2 THEN M2_WC=WC;
ELSE IF COHORT=3 THEN M3_WC=WC;
ELSE IF COHORT=4 THEN M4_WC=WC;
END;
IF SEX=2 THEN DO;
IF COHORT=1 THEN W1_WC=WC;
ELSE IF COHORT=2 THEN W2_WC=WC;
ELSE IF COHORT=3 THEN W3_WC=WC;
ELSE IF COHORT=4 THEN W4_WC=WC;
END;
IF SEX=1 THEN DO;
MENBMI=BMI; MENWC=WC; END;
ELSE IF SEX=2 THEN DO;
WOMENBMI=BMI; WOMENWC=WC; END;
RUN;

title  font='Times New Roman' 'Trends of BMI in Men Stratified by Birth Cohorts and Ages';
footnote font='Times New Roman'  h=8pt 'BMI: Body Mass Index';
proc sgplot data=FIG2;
  series x=AGE y=M1_BMI/ legendlabel='Birth in 1950-1959' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=AGE y=M2_BMI/ legendlabel='Birth in 1960-1969' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  series x=AGE y=M3_BMI/ legendlabel='Birth in 1970-1979' lineattrs=(PATTERN=SOLID COLOR=lightgreen) ;
  series x=AGE y=M4_BMI/ legendlabel='Birth in 1980-1989' lineattrs=(PATTERN=SOLID COLOR=purple) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Mean BMI (kg/m2)" labelpos=top MIN=20 MAX=27 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;
title  font='Times New Roman' 'Trends of BMI in Women Stratified by Birth Cohorts and Ages';
footnote font='Times New Roman'  h=8pt 'BMI: Body Mass Index';
proc sgplot data=FIG2;
  series x=AGE y=W1_BMI/ legendlabel='Birth in 1950-1959' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=AGE y=W2_BMI/ legendlabel='Birth in 1960-1969' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  series x=AGE y=W3_BMI/ legendlabel='Birth in 1970-1979' lineattrs=(PATTERN=SOLID COLOR=lightgreen) ;
  series x=AGE y=W4_BMI/ legendlabel='Birth in 1980-1989' lineattrs=(PATTERN=SOLID COLOR=purple) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Mean BMI (kg/m2)" labelpos=top MIN=20 MAX=27 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

title  font='Times New Roman' 'Trends of WC in Men Stratified by Birth Cohorts and Ages';
footnote font='Times New Roman'  h=8pt 'WC: Waist Circumference';
proc sgplot data=FIG2;
  series x=AGE y=M1_WC/ legendlabel='Birth in 1950-1959' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=AGE y=M2_WC/ legendlabel='Birth in 1960-1969' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  series x=AGE y=M3_WC/ legendlabel='Birth in 1970-1979' lineattrs=(PATTERN=SOLID COLOR=lightgreen) ;
  series x=AGE y=M4_WC/ legendlabel='Birth in 1980-1989' lineattrs=(PATTERN=SOLID COLOR=purple) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Mean WC (cm)" labelpos=top MIN=74 MAX=94 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;
title  font='Times New Roman' 'Trends of WC in Women Stratified by Birth Cohorts and Ages';
footnote font='Times New Roman'  h=8pt 'WC: Waist Circumference';
proc sgplot data=FIG2;
  series x=AGE y=W1_WC/ legendlabel='Birth in 1950-1959' lineattrs=(PATTERN=SOLID COLOR=lightblue) ;
  series x=AGE y=W2_WC/ legendlabel='Birth in 1960-1969' lineattrs=(PATTERN=SOLID COLOR=lightred) ;
  series x=AGE y=W3_WC/ legendlabel='Birth in 1970-1979' lineattrs=(PATTERN=SOLID COLOR=lightgreen) ;
  series x=AGE y=W4_WC/ legendlabel='Birth in 1980-1989' lineattrs=(PATTERN=SOLID COLOR=purple) ;
  keylegend / location=inside position=topright across=1 titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
XAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
yaxis label="Mean WC (cm)" labelpos=top MIN=68 MAX=89 LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman");
run;

/*p-trend 보기*/
PROC REG DATA=FIG2;
MODEL M1_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M2_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M3_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M4_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M1_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M2_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M3_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL M4_WC=AGE ;
RUN;

PROC REG DATA=FIG2;
MODEL W1_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W2_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W3_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W4_BMI=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W1_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W2_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W3_WC=AGE ;
RUN;
PROC REG DATA=FIG2;
MODEL W4_WC=AGE ;
RUN;

PROC REG DATA=FIG2;
MODEL MENBMI=COHORT;
RUN;
PROC REG DATA=FIG2;
MODEL WOMENBMI=COHORT;
RUN;
PROC REG DATA=FIG2;
MODEL MENWC=COHORT;
RUN;
PROC REG DATA=FIG2;
MODEL WOMENWC=COHORT;
RUN;



/*FIGURE 3) 남자 출생코호트, 교육수준별 연령에 따른 비만과 복부비만(%)*/
/*FIGURE 4) 여자 출생코호트, 교육수준별 연령에 따른 비만과 복부비만(%)*/
PROC SURVEYFREQ DATA=B.OBE_4 NOMCAR;
STRATA kstrata;
CLUSTER psu;
WEIGHT wt_pool_2;
TABLE SEX*BIRTHCOHORT*EDU_BI*COAGE*OBE/ ROW;
RUN;
PROC SURVEYFREQ DATA=B.OBE_4 NOMCAR;
STRATA kstrata;
CLUSTER psu;
WEIGHT wt_pool_2;
TABLE SEX*BIRTHCOHORT*EDU_BI*COAGE*AB_OBE/ ROW;
RUN;
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
1	1	3	1	1	16.473
1	1	3	1	2	31.6891
1	1	3	1	3	35.9275
1	1	3	1	4	38.6847
1	1	3	1	5	44.8378
1	1	3	1	6	39.3904
1	1	3	2	1	17.5094
1	1	3	2	2	26.7426
1	1	3	2	3	41.2265
1	1	3	2	4	40.8069
1	1	3	2	5	47.0789
1	1	3	2	6	48.9131
1	1	4	1	1	27.7998
1	1	4	1	2	39.6613
1	1	4	1	3	46.5707
1	1	4	1	4	41.5656
1	1	4	2	1	22.1345
1	1	4	2	2	32.7867
1	1	4	2	3	43.002
1	1	4	2	4	45.8254
2	1	1	1	4	17.7809
2	1	1	1	5	30.2935
2	1	1	1	6	35.8228
2	1	1	1	7	36.4053
2	1	1	1	8	38.0328
2	1	1	1	9	38.1396
2	1	1	1	10	40.1694
2	1	1	2	4	9.3698
2	1	1	2	5	9.912
2	1	1	2	6	18.8228
2	1	1	2	7	27.4127
2	1	1	2	8	21.4999
2	1	1	2	9	23.089
2	1	1	2	10	17.1852
2	1	2	1	2	14.3968
2	1	2	1	3	21.2648
2	1	2	1	4	24.4804
2	1	2	1	5	29.9649
2	1	2	1	6	31.4191
2	1	2	1	7	31.3904
2	1	2	1	8	35.372
2	1	2	2	2	16.9205
2	1	2	2	3	12.1835
2	1	2	2	4	11.7332
2	1	2	2	5	17.618
2	1	2	2	6	20.1493
2	1	2	2	7	21.4806
2	1	2	2	8	23.1534
2	1	3	1	1	11.1419
2	1	3	1	2	19.5311
2	1	3	1	3	22.9689
2	1	3	1	4	24.7881
2	1	3	1	5	27.7519
2	1	3	1	6	31.2787
2	1	3	2	1	8.4777
2	1	3	2	2	11.3424
2	1	3	2	3	10.9646
2	1	3	2	4	15.4651
2	1	3	2	5	16.9174
2	1	3	2	6	22.2356
2	1	4	1	1	18.6426
2	1	4	1	2	23.1768
2	1	4	1	3	25.5514
2	1	4	1	4	29.1662
2	1	4	2	1	10.0588
2	1	4	2	2	12.4752
2	1	4	2	3	14.677
2	1	4	2	4	17.8471
1	2	1	1	4	12.9827
1	2	1	1	5	24.3703
1	2	1	1	6	24.9917
1	2	1	1	7	26.7993
1	2	1	1	8	28.2834
1	2	1	1	9	30.2955
1	2	1	1	10	33.6227
1	2	1	2	4	8.4434
1	2	1	2	5	30.8979
1	2	1	2	6	32.2531
1	2	1	2	7	29.5589
1	2	1	2	8	31.9263
1	2	1	2	9	35.5032
1	2	1	2	10	34.7304
1	2	2	1	2	9.5159
1	2	2	1	3	17.6044
1	2	2	1	4	17.3207
1	2	2	1	5	27.3404
1	2	2	1	6	25.2445
1	2	2	1	7	30.3163
1	2	2	1	8	29.7748
1	2	2	2	2	12.3149
1	2	2	2	3	20.2244
1	2	2	2	4	25.9671
1	2	2	2	5	27.2726
1	2	2	2	6	29.7048
1	2	2	2	7	32.7498
1	2	2	2	8	31.1673
1	2	3	1	1	8.881
1	2	3	1	2	15.6738
1	2	3	1	3	20.2933
1	2	3	1	4	23.3695
1	2	3	1	5	28.3575
1	2	3	1	6	32.0499
1	2	3	2	1	9.218
1	2	3	2	2	15.3991
1	2	3	2	3	26.5126
1	2	3	2	4	25.0647
1	2	3	2	5	32.0873
1	2	3	2	6	34.6804
1	2	4	1	1	17.4094
1	2	4	1	2	21.4618
1	2	4	1	3	33.8207
1	2	4	1	4	32.9577
1	2	4	2	1	9.6488
1	2	4	2	2	17.0238
1	2	4	2	3	28.0791
1	2	4	2	4	32.3846
2	2	1	1	4	9.9913
2	2	1	1	5	20.9529
2	2	1	1	6	26.1479
2	2	1	1	7	30.0125
2	2	1	1	8	33.3447
2	2	1	1	9	36.5456
2	2	1	1	10	40.9223
2	2	1	2	4	7.6667
2	2	1	2	5	6.482
2	2	1	2	6	6.9435
2	2	1	2	7	21.8938
2	2	1	2	8	15.4655
2	2	1	2	9	18.5371
2	2	1	2	10	23.9797
2	2	2	1	2	6.658
2	2	2	1	3	12.0031
2	2	2	1	4	16.7801
2	2	2	1	5	19.7988
2	2	2	1	6	22.4598
2	2	2	1	7	23.0752
2	2	2	1	8	28.0814
2	2	2	2	2	8.1322
2	2	2	2	3	10.6178
2	2	2	2	4	6.8469
2	2	2	2	5	9.605
2	2	2	2	6	13.1217
2	2	2	2	7	16.4191
2	2	2	2	8	15.5135
2	2	3	1	1	7.7886
2	2	3	1	2	11.3785
2	2	3	1	3	19.0263
2	2	3	1	4	16.768
2	2	3	1	5	19.8955
2	2	3	1	6	21.2602
2	2	3	2	1	5.1965
2	2	3	2	2	7.5603
2	2	3	2	3	8.7357
2	2	3	2	4	10.69
2	2	3	2	5	11.8561
2	2	3	2	6	12.6597
2	2	4	1	1	11.2281
2	2	4	1	2	16.5905
2	2	4	1	3	22.1146
2	2	4	1	4	25.5048
2	2	4	2	1	5.4081
2	2	4	2	2	7.5531
2	2	4	2	3	9.4628
2	2	4	2	4	13.1676
;
RUN;

DATA FIG34;
SET FIG34;
IF SEX=1 THEN DO;
IF TYPE=1 AND EDU=1 THEN MENOBE_EDU1=FREQ;
ELSE IF TYPE=1 AND EDU=2 THEN MENOBE_EDU2=FREQ;
ELSE IF TYPE=2 AND EDU=1 THEN MENAB_EDU1=FREQ;
ELSE IF TYPE=2 AND EDU=2 THEN MENAB_EDU2=FREQ;
END;
IF SEX=2 THEN DO;
IF TYPE=1 AND EDU=1 THEN WOMENOBE_EDU1=FREQ;
ELSE IF TYPE=1 AND EDU=2 THEN WOMENOBE_EDU2=FREQ;
ELSE IF TYPE=2 AND EDU=1 THEN WOMENAB_EDU1=FREQ;
ELSE IF TYPE=2 AND EDU=2 THEN WOMENAB_EDU2=FREQ;
END;
RUN;

title  font='Times New Roman' "Overall Obesity in Men's Birth Cohorts Stratified by Education Levels & Ages";
footnote font='Times New Roman'  h=8pt 'Overall Obesity: BMI ≥ 25 kg/m2';
PROC SGPANEL DATA=FIG34;
PANELBY COHORT/novarname headerattrs=(family="Times New Roman");
LOESS X=COAGE Y=MENOBE_EDU1/legendlabel="High School Graduate or Below"  lineattrs=(pattern=solid color=indianred) nomarkers SMOOTH=0.7;
LOESS X=COAGE Y=MENOBE_EDU2/legendlabel="College Graduate or Higher" lineattrs=(pattern=solid color=mediumseagreen) nomarkers SMOOTH=0.7;
  keylegend / titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
colAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") values=(1 to 10 by 1);
rowaxis label="Percent" labelpos=top LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") max=50;
run;
title  font='Times New Roman' "Central Obesity in Men's Birth Cohorts Stratified by Education Levels & Ages";
footnote font='Times New Roman'  h=8pt 'Central Obesity: WC ≥ 90cm in Men';
PROC SGPANEL DATA=FIG34;
PANELBY COHORT/novarname headerattrs=(family="Times New Roman");
LOESS X=COAGE Y=MENAB_EDU1/legendlabel="High School Graduate or Below"  lineattrs=(pattern=solid color=indianred) nomarkers SMOOTH=0.7;
LOESS X=COAGE Y=MENAB_EDU2/legendlabel="College Graduate or Higher" lineattrs=(pattern=solid color=mediumseagreen) nomarkers SMOOTH=0.7;
  keylegend / titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
colAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") values=(1 to 10 by 1);
rowaxis label="Percent" labelpos=top LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") max=50;
run;

title  font='Times New Roman' "Overall Obesity in Women's Birth Cohorts Stratified by Education Levels & Ages";
footnote font='Times New Roman'  h=8pt 'Overall Obesity: BMI ≥ 25 kg/m2';
PROC SGPANEL DATA=FIG34;
PANELBY COHORT/novarname headerattrs=(family="Times New Roman");
LOESS X=COAGE Y=WOMENOBE_EDU1/legendlabel="High School Graduate or Below"  lineattrs=(pattern=solid color=indianred) nomarkers SMOOTH=0.7;
LOESS X=COAGE Y=WOMENOBE_EDU2/legendlabel="College Graduate or Higher" lineattrs=(pattern=solid color=mediumseagreen) nomarkers SMOOTH=0.7;
  keylegend / titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
colAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") values=(1 to 10 by 1);
rowaxis label="Percent" labelpos=top LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") max=50;
run;
title  font='Times New Roman' "Central Obesity in Women's Birth Cohorts Stratified by Education Levels & Ages";
footnote font='Times New Roman'  h=8pt 'Central Obesity: WC ≥ 85cm in Women';
PROC SGPANEL DATA=FIG34;
PANELBY COHORT/novarname headerattrs=(family="Times New Roman");
LOESS X=COAGE Y=WOMENAB_EDU1/legendlabel="High School Graduate or Below"  lineattrs=(pattern=solid color=indianred) nomarkers SMOOTH=0.7;
LOESS X=COAGE Y=WOMENAB_EDU2/legendlabel="College Graduate or Higher" lineattrs=(pattern=solid color=mediumseagreen) nomarkers SMOOTH=0.7;
  keylegend / titleattrs=(family="Times New Roman") valueattrs=(family="Times New Roman");
colAXIS LABEL="Age" LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") values=(1 to 10 by 1);
rowaxis label="Percent" labelpos=top LABELATTRS=(FAMILY="Times New Roman") valueattrs=(FAMILY="Times New Roman") max=50;
run;

