/* Adapted from obesity_data.sas (the author's core variable-derivation
   pipeline: age category, BMI-based obesity flag, pooled survey weight,
   education level, occupation group, region, birth cohort, waist-based
   central obesity, and combined obesity flags). The raw KNHANES extracts
   this script reads via LIBNAME A/B ("C:\Users\HajinJang\Documents\hn" and
   "...\FINAL") are the authors' private survey files and are not in the
   repository; MOCK is a small hand-built stand-in with the same columns
   the DATA step actually reads (age, HS_mens/HE_mens/HE_obe, HE_ht/HE_wt,
   HE_WC, educ/graduat, JOB_T/OCCP, REGION/town_t, wt_ex/wt_ex_t/wt_itvex,
   year) across a couple of KNHANES waves. The derivation logic below
   (cage/OBE/wt_pool_1/wt_pool_2/edu_2/edu_bi/occp_2/region_2/birthcohort/
   ab_obe/both_obe/TERM/COAGE) is the author's own code, copied verbatim
   from obesity_data.sas. */

DATA MOCK;
INPUT year age sex HS_mens HE_mens HE_obe HE_ht HE_wt HE_WC educ graduat
      JOB_T OCCP REGION town_t wt_ex wt_ex_t wt_itvex;
DATALINES;
1998 34 1 1 . . 172.3 78.4 91.2 4 . 2 . 1 1 1520.4 1518.9 .
1998 52 2 1 . . 158.1 61.0 79.5 3 . 3 . 1 1 1310.7 1305.2 .
2005 41 1 . 1 . 175.0 84.1 95.0 5 3 . . 3 2 1420.1 1420.1 .
2005 29 2 . 1 . 162.4 55.2 71.3 4 1 . . 8 1 1105.9 1105.9 .
2009 63 1 . . 3 . . 88.0 6 . . 2 5 1 . . 980.5
2009 24 2 . . 1 . . 68.0 7 . . 1 1 1 . . 1210.3
2014 45 1 . . 6 . . 102.4 5 . . 5 6 1 . . 1440.8
2014 38 2 . . 3 . . 82.1 8 . . 3 8 2 . . 1330.0
2018 70 1 . . 5 . . 96.5 6 . . 6 9 1 . . 1601.2
2018 22 2 . . 1 . . 70.2 88 . . 1 1 1 . . 1080.4
;
RUN;

DATA MOCK;
SET MOCK;

/*연령구간 변수(cage) 생성*/
      IF 19<=age<=29 THEN cage=2; ELSE IF 30<=age<=39 THEN cage=3;
ELSE IF 40<=age<=49 THEN cage=4; ELSE IF 50<=age<=59 THEN cage=5;
ELSE IF 60<=age<=69 THEN cage=6; ELSE IF 70<=age THEN cage=7;

/*성인 비만 유병여부 변수(OBE) 생성*/
IF age>=19 & ((year in (1998,2001) & HS_mens^=3) or (year=2005 & HE_mens^=3)) THEN do;
   IF HE_ht^=. & HE_wt^=. THEN HE_BMI = HE_wt / ((HE_ht/100)**2);
   IF HE_BMI^=. THEN OBE = (HE_BMI>=25);
END;
IF age>=19 & 2007<=year<=2016 & HE_obe in (1,2,3) THEN OBE = (HE_obe=3);
IF age>=19 & 2017<=year<=2018 & HE_obe in (1,2,3,4,5,6) THEN OBE=(HE_obe in (4,5,6));

/*1)연도별 가중치 변수명 통일(wt_pool_1), 2)통합가중치 변수(wt_pool_2) 생성*/
IF 1998<=year<=2001 THEN do;
   wt_pool_1 = wt_ex;    wt_pool_2 = wt_ex_t;
end;
IF 2005<=year<=2009 THEN do;
   wt_pool_1 = wt_ex;    wt_pool_2 = wt_ex;
end;
IF 2010<=year<=2018 THEN do;
   wt_pool_1 = wt_itvex;  wt_pool_2 = wt_itvex;
end;

/*교육수준 3cat (edu_2)*/
if year in (1998,2001) & educ in (0,1,2,3,4,5,6) then do;
if educ in (0,1,2,3) then edu_2=1;   /*고졸미만*/
else if educ=4 then edu_2=2;    /*고졸*/
else if educ in (5,6) then edu_2=3;    /*대졸이상*/
end;
if year in (2007:2009) & educ in (1,2,3,4,5,6,7,8,9) & graduat in (1,2,3,4,8) then do;
if educ in (1,2,3,4,5) & graduat in (1,2,3,4,8) then edu_2=1;
else if educ=6 & graduat in (2,3,4) then edu_2=1;
else if educ=6 & graduat=1 then edu_2=2;
else if educ in (7,8,9) & graduat in (1,2,3,4) then edu_2=3;
end;
if year in (2010:2018) & educ in (1,2,3,4,5,6,7,8,88) & graduat in (1,2,3,4,8) then do;
if educ in (1,2,3,4) & graduat in (1,2,3,4,8) then edu_2=1;
else if educ=5 & graduat in (2,3,4) then edu_2=1;
else if educ=5 & graduat=1 then edu_2=2;
else if educ in (6,7,8) & graduat in (1,2,3,4) then edu_2=3;
end;

/*교육수준 2단계로 다시나눔 (edu_bi)*/
IF edu_2 in (1,2) then edu_bi=1;    /*고졸이하*/
ELSE IF edu_2=3 then edu_bi=2;    /*대졸이상*/

/*직업(occp_2)*/
IF age>=15 & year in (1998,2001,2005) AND JOB_T IN (1:5) THEN do;
   if job_t in (1,2) then occp_2=1;    /*관리자, 사무종사자*/
   else IF job_t=3 then occp_2=2;    /*서비스판매종사자*/
   else IF job_t=4 then occp_2=3;    /*농림어업종사자*/
   else IF job_t=5 then occp_2=4;    /*기계조립, 단순노무종사자*/
  end;
IF age>=15 & year in (2007:2018) AND OCCP IN (1:6) THEN do;
if occp in (1,2) then occp_2=1;
ELSE if occp=3  then occp_2=2;
ELSE if occp=4 then occp_2=3;
ELSE if occp in (5,6) then occp_2=4;
end;

/*지역(region_2)*/
if year=1998 AND REGION^=. then do;
if region=1 then region_2=1; /*서울*/
else if region in (2:6) then region_2=2; /*광역시*/
else if region in (8:16) & town_t=1 then region_2=3; /*동 지역*/
else if region in (8:16) & town_t=2 then region_2=4; /*읍면 지역*/
end;
if year in (2016:2018) AND REGION^=. then do;
if region=1 then region_2=1; /*서울*/
else if region in (2:7) then region_2=2; /*광역시*/
else if region in (8:17) & town_t=1 then region_2=3; /* 동 지역*/
else if region in (8:17) & town_t=2 then region_2=4; /*읍면 지역*/
end;

/*출생코호트(birthcohort)*/
birthyear=year-age;
if 1950<=birthyear<1960 then birthcohort=1;    /*50년대생*/
else if 1960<=birthyear<1970 then birthcohort=2;    /*60년대생*/
else if 1970<=birthyear<1980 then birthcohort=3;    /*70년대생*/
else if 1980<=birthyear<1990 then birthcohort=4;    /*80년대생*/

/*복부비만 변수(ab_obe)& 극단치제거*/
IF age>=19 & ((year in (1998,2001) & HS_mens^=3) or (year=2005 & HE_mens^=3)) THEN do;
IF sex=1 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=90);
ELSE IF sex=2 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=85);
END;
IF age>=19 & year in (2007,2008,2009,2010,2011,2012,2016,2017,2018) then do;
IF sex=1 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=90);
ELSE IF sex=2 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=85);
END;

/*복부비만, 비만 동시유병 변수(both_obe)*/
if obe^=. and ab_obe^=. then both_obe=(obe=1 & ab_obe=1);

/*기수(TERM)*/
IF YEAR=1998 THEN TERM=1;
ELSE IF YEAR=2005 THEN TERM=3;
ELSE IF YEAR IN (2007:2009) THEN TERM=4;
ELSE IF YEAR IN (2013:2015) THEN TERM=6;
ELSE IF YEAR IN (2016:2018) THEN TERM=7;

/*코호트 나이 5세씩 묶기*/
 IF AGE IN (19:24) THEN COAGE=1;
ELSE IF AGE IN (25:29) THEN COAGE=2;
ELSE IF AGE IN (30:34) THEN COAGE=3;
ELSE IF AGE IN (35:39) THEN COAGE=4;
ELSE IF AGE IN (40:44) THEN COAGE=5;
ELSE IF AGE IN (45:49) THEN COAGE=6;
ELSE IF AGE IN (50:54) THEN COAGE=7;
ELSE IF AGE IN (55:59) THEN COAGE=8;
ELSE IF AGE IN (60:64) THEN COAGE=9;
ELSE IF AGE IN (65:69) THEN COAGE=10;

RUN;

PROC PRINT DATA=MOCK;
VAR year age cage OBE wt_pool_2 edu_2 edu_bi occp_2 region_2 birthcohort ab_obe both_obe TERM COAGE;
RUN;
