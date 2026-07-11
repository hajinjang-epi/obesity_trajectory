/* Adapted from obesity_figures.sas (the underlying PROC SURVEYREG call
   that produces Figure 1's age-standardized mean BMI trend by wave --
   the t001/t002 bundles in this PR use the pre-computed CARDS output of
   this exact call; this bundle exercises the survey-regression call
   itself). The private KNHANES extract this script normally reads via
   LIBNAME B is not in the repository; MOCK is a small hand-built
   stand-in with the columns the MODEL/CLASS/STRATA/CLUSTER/WEIGHT/
   DOMAIN statements actually reference (cage, sex, TERM, he_bmi,
   kstrata, psu, wt_pool_2). The PROC SURVEYREG call itself -- STRATA/
   CLUSTER/WEIGHT/CLASS/DOMAIN/MODEL, including NOINT and
   VADJUST=NONE -- is the author's own code, copied verbatim from
   obesity_figures.sas. */

DATA MOCK;
INPUT TERM cage sex he_bmi kstrata psu wt_pool_2;
DATALINES;
1 3 1 23.4 1 101 1520.4
1 4 2 22.9 1 102 1310.7
2 3 1 23.9 2 103 1420.1
2 4 2 23.1 2 104 1105.9
3 3 1 24.2 1 105  980.5
3 4 2 23.0 1 106 1210.3
4 3 1 24.5 2 107 1440.8
4 4 2 22.8 2 108 1330.0
;
RUN;

proc surveyreg data=MOCK nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain SEX*TERM;
model he_bmi=cage /noint vadjust=NONE;
estimate 'BMI_평균'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
