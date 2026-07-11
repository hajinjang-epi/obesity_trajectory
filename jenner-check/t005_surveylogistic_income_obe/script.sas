/* Adapted from obesity_trends_final.sas (the association analysis between
   income and obesity, one of the paper's core PROC SURVEYLOGISTIC calls).
   The private KNHANES extract this script normally reads via LIBNAME A is
   not in the repository; MOCK is a small hand-built stand-in with the
   columns the MODEL/CLASS/STRATA/CLUSTER/WEIGHT/DOMAIN statements actually
   reference (obe, incm, kstrata, psu, wt_pool_2, year). The PROC
   SURVEYLOGISTIC call itself -- STRATA/CLUSTER/WEIGHT/CLASS/MODEL/DOMAIN,
   VADJUST=none -- is the author's own code, copied verbatim from
   obesity_trends_final.sas, with the PROC statement's NOMCAR option and
   the MODEL statement's DF=INFINITY option dropped (see meta.json). */

DATA MOCK;
INPUT year kstrata psu incm obe wt_pool_2;
DATALINES;
1998 1 101 1 1 1520.4
1998 1 102 2 0 1310.7
1998 2 103 3 1 1420.1
1998 2 104 4 0 1105.9
2005 1 105 1 0  980.5
2005 1 106 2 1 1210.3
2005 2 107 3 0 1440.8
2005 2 108 4 1 1330.0
2017 1 109 1 1 1601.2
2017 1 110 2 0 1080.4
2017 2 111 3 1 1350.6
2017 2 112 4 0  990.1
;
RUN;

/*소득(개인)과 비만 연관성분석*/
proc surveylogistic data=MOCK;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS incm(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=incm / VADJUST=none;
run;
