libname a "C:\Users\HajinJang\Documents\hn";
libname b "C:\Users\HajinJang\Documents\FINAL";

proc contents data=a.hn98_all;
run;
proc contents data=a.hn01_all;
run;
proc contents data=a.hn05_all;
run;
proc contents data=a.hn07_all;
run;
proc contents data=a.hn08_all;
run;
proc contents data=a.hn09_all;
run;
proc contents data=a.hn10_all;
run;
proc contents data=a.hn11_all;
run;
proc contents data=a.hn12_all;
run;
proc contents data=a.hn13_all;
run;
proc contents data=a.hn14_all;
run;
proc contents data=a.hn15_all;
run;
proc contents data=a.hn16_all;
run;
proc contents data=a.hn17_all;
run;
proc contents data=a.hn18_all;
run;

data hn98_05;
set a.hn98_all a.hn01_all a.hn05_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;


data B.FINAL2;
set hn98_05 a.hn07_all a.hn08_all a.hn09_all a.hn10_all a.hn11_all a.hn12_all a.hn13_all 
a.hn14_all a.hn15_all a.hn16_all a.hn17_all a.hn18_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;

DATA B.FINAL2;
SET B.FINAL2;

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

/* bmi 극단치 제거*/
if HE_BMI<16.9995 or HE_BMI>33.1511 then delete;

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
if year=2005 & educ in (0,1,2,3,4,5,6) & graduat in (1,2,3,4,5,8) then do;
if educ in (0,1,2,3) & graduat in (1,2,3,4,5,8) then edu_2=1;
else if educ=4 & graduat in (2,3,4,5) then edu_2=1;
else if educ=4 & graduat=1 then edu_2=2;
else if educ in (5,6) & graduat in (1,2,3,4,5) then edu_2=3;
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
if year in (2001:2015) AND REGION^=. then do;
if region=1 then region_2=1; /*서울*/
else if region in (2:7) then region_2=2; /*광역시*/
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
IF age>=19 & year in (2007,2008,2009,2010,2011,2012,2016,2017,2018) & HE_prg^=1 then do;
IF sex=1 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=90);
ELSE IF sex=2 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=85);
END;
IF age>=19 & year in (2013:2015) & LW_ms^=3 then do;
IF sex=1 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=90);
ELSE IF sex=2 & HE_WC in (61.2:105.9) then ab_obe=(he_wc>=85);
END;

/*복부비만, 비만 동시유병 변수(both_obe)*/
if obe^=. and ab_obe^=. then both_obe=(obe=1 & ab_obe=1);

/*기수(TERM)*/
IF YEAR=1998 THEN TERM=1;
ELSE IF YEAR=2001 THEN TERM=2;
ELSE IF YEAR=2005 THEN TERM=3;
ELSE IF YEAR IN (2007:2009) THEN TERM=4;
ELSE IF YEAR IN (2010:2012) THEN TERM=5;
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
