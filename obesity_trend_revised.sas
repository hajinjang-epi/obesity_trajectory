libname a "C:\Users\HajinJang\Documents\hn";

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


data a.hn_obesity;
set hn98_05 a.hn07_all a.hn08_all a.hn09_all a.hn10_all a.hn11_all a.hn12_all a.hn13_all 
a.hn14_all a.hn15_all a.hn16_all a.hn17_all a.hn18_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;

DATA a.hn_obesity;
SET a.hn_obesity;

/*연령구간 변수(cage) 생성*/
      IF 19<=age<=29 THEN cage=2; ELSE IF 30<=age<=39 THEN cage=3;
ELSE IF 40<=age<=49 THEN cage=4; ELSE IF 50<=age<=59 THEN cage=5;
ELSE IF 60<=age<=69 THEN cage=6; ELSE IF 70<=age THEN cage=7;

/*성인 비만 유병여부 변수(OBE) 생성*/
IF age>=19 & ((year in (1998,2001) & HS_mens^=3) or (year=2005 & HE_mens^=3)) THEN do;
   IF HE_ht^=. & HE_wt^=. THEN BMI = HE_wt / ((HE_ht/100)**2);
   IF BMI^=. THEN OBE = (BMI>=25);
END; 
IF age>=19 & 2007<=year<=2018 & HE_obe in (1,2,3) THEN OBE = (HE_obe=3);

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
RUN;

/*교육수준*/
data a.hn_obesity;
set a.hn_obesity;
IF age>=19 & year in (1998,2001) THEN do; 
   if 0<=educ<=2 then edu=1;
   else IF educ=3 then edu=2;
   else IF educ=4 then edu=3;
   else IF 5<=educ<=6 then edu=4;
end;
/*교육수준 3cat (edu_2)*/
if year in (1998,2001) & educ in (0,1,2,3,4,5,6) then do;
if educ in (0,1,2,3) then edu_2=1;
else if educ=4 then edu_2=2;
else if educ in (5,6) then edu_2=3;
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
run;

/*직업 job_t에서 occp_re로 코딩*/
data a.hn_obesity;
set a.hn_obesity;
IF age>=15 & year in (1998,2001,2005) & job^=6 THEN do; 
   if job_t in (1,2) then occp_re=1;
   else IF job_t=3 then occp_re=2;
   else IF job_t=4 then occp_re=3;
   else IF job_t=5 then occp_re=4;
   else IF job_t in (7,8,77) then occp_re=5;
  end;
IF age>=15 & year in (2007:2018) THEN do; 
if occp in (1,2) then occp_re=1;
if occp=3  then occp_re=2;
if occp=4 then occp_re=3;
if occp in (5,6) then occp_re=4;
if occp=7  then occp_re=5;
end;
IF occp_re in (1,2,3,4) then occp_2=occp_re;
run; 

/*지역(region_re)*/
data a.hn_obesity;
set a.hn_obesity;
if year in (1998:2015) then do;
if region in (1,4,8,9) then region_re=1;
if region in (2,3,7,14,15) then region_re=2;
if region in (5,12,13) then region_re=3;
if region in (6,10,11) then region_re=4;
if region=16 then region_re=5;
end;
if year in (2016:2018) then do;
if region in (1,4,9,10) then region_re=1;
if region in (2,3,7,15,16) then region_re=2;
if region in (5,13,14) then region_re=3;
if region in (6,8,11,12) then region_re=4;
if region=17 then region_re=5;
end;
/* 지역 재분류(region_2)*/
if year=1998 then do;
if region=1 then region_2=1;
else if region in (2:6) then region_2=2;
else if region in (8:16) & town_t=1 then region_2=3; /*동 지역*/
else if region in (8:16) & town_t=2 then region_2=4; /*읍면 지역*/
end;
if year in (2001:2015) then do;
if region=1 then region_2=1;
else if region in (2:7) then region_2=2;
else if region in (8:16) & town_t=1 then region_2=3; /*동 지역*/
else if region in (8:16) & town_t=2 then region_2=4; /*읍면 지역*/
end;
if year in (2016:2018) then do;
if region=1 then region_2=1;
else if region in (2:7) then region_2=2;
else if region in (8:17) & town_t=1 then region_2=3; /* 동 지역*/
else if region in (8:17) & town_t=2 then region_2=4; /*읍면 지역*/
end;
run;

/*출생코호트*/
data a.hn_obesity;
set a.hn_obesity;
birthyear=year-age;
if birthyear<=1940 then birthcohort_10=1;
else if 1940<birthyear<=1950 then birthcohort_10=2;
else if 1950<birthyear<=1960 then birthcohort_10=3;
else if 1960<birthyear<=1970 then birthcohort_10=4;
else if 1970<birthyear<=1980 then birthcohort_10=5;
else if 1980<birthyear<=1990 then birthcohort_10=6;
else if 1990<birthyear<=2000 then birthcohort_10=7;
run;

/*복부비만 변수(ab_obe)*/
data a.hn_obesity;
set a.hn_obesity;
if age>=19 & sex=1 & HE_WC in (40:120) then ab_obe=(he_wc>=90);
else if age>=19 & sex=2 & HE_WC in (40:120) then ab_obe=(he_wc>=85);
run;

/*복부비만, 비만 동시유병 변수(both_obe)*/
data a.hn_obesity;
set a.hn_obesity;
if obe^=. and ab_obe^=. then do;
if obe=1 & ab_obe=1 then both_obe=1;             /*둘다 해당*/
if obe=1 & ab_obe=0 then both_obe=2;     /*bmi비만만 해당*/
if obe=0 & ab_obe=1 then both_obe=3;     /*복부비만만 해당*/
if obe=0 & ab_obe=0 then both_obe=4;     /*둘다 비해당*/
end;
run;


/* bmi 극단치 제거-density plot 그릴때 사용*/
data a.hn_obesity;
set a.hn_obesity;
if year in (1998,2001,2005) then do;
if BMI<=10 or BMI>=50 then delete;
end;
if year in (2007:2018) then do;
if HE_BMI<=10 or HE_BMI>=50 then delete;
end;
run;


/*논문그래프넣을분석-BMI*/
proc surveylogistic data=a.hn_obesity nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
class incm(ref="1") cage(ref="2") occp_2(ref="1") region_2(ref="1") edu_2(ref="1");
model obe(EVENT='1')=incm cage edu_2 occp_2 region_2/VADJUST=NONE;
domain year*sex;
estimate '비만유병률'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;


/*논문그래프넣을분석-BMI*/
proc surveyfreq data=a.hn_obesity nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
tables year*sex*cage*both_obe /row chisq;
run;

proc surveyfreq data=a.hn_obesity nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
tables year*sex*occp_2*obe /row chisq;
run;

/*2017, 2018 obe, ab_obe, both_obe 확인*/
proc freq data=a.hn_obesity;
tables year*sex*occp_2*obe;
run;


