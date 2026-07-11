/* Adapted from obesity_sex_stratified.sas (the paper's regional obesity
   trend cross-tab, one of the core PROC SURVEYFREQ calls). The private
   KNHANES extract this script normally reads via LIBNAME A is not in the
   repository; MOCK is a small hand-built stand-in with the columns the
   TABLE/STRATA/CLUSTER/WEIGHT statements actually reference (year, sex,
   region_re, obe, kstrata, psu, wt_pool_2). The PROC SURVEYFREQ call
   itself -- STRATA/CLUSTER/WEIGHT/TABLE, including NOMCAR (Jenner
   supports it here, unlike on PROC SURVEYLOGISTIC -- see the
   t005 bundle) and the ROW CHISQ options -- is the author's own code,
   copied verbatim from obesity_sex_stratified.sas. */

DATA MOCK;
INPUT year sex region_re obe kstrata psu wt_pool_2;
DATALINES;
1998 1 1 1 1 101 1520.4
1998 1 2 0 1 102 1310.7
1998 2 1 1 2 103 1420.1
1998 2 2 0 2 104 1105.9
2015 1 1 0 1 105  980.5
2015 1 2 1 1 106 1210.3
2015 2 1 0 2 107 1440.8
2015 2 2 1 2 108 1330.0
2018 1 1 1 1 109 1601.2
2018 1 2 0 1 110 1080.4
2018 2 1 1 2 111 1350.6
2018 2 2 0 2 112  990.1
;
RUN;

/*--------------성별별 비만 추이 분석-----------*/
proc surveyfreq data=MOCK nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
tables year*sex*region_re*obe/row chisq;
run;
