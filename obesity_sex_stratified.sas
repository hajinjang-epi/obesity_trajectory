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


data a.hn98_18;
set hn98_05 a.hn07_all a.hn08_all a.hn09_all a.hn10_all a.hn11_all a.hn12_all a.hn13_all 
a.hn14_all a.hn15_all a.hn16_all a.hn17_all a.hn18_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;

DATA a.hn98_18;
SET a.hn98_18;

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

/*교육수준 재코팅*/
data a.hn98_18;
set a.hn98_18;
IF age>=19 & year in (1998,2001) THEN do; 
   if 0<=educ<=2 then edu=1;
   else IF educ=3 then edu=2;
   else IF educ=4 then edu=3;
   else IF 5<=educ<=6 then edu=4;
end;
run;


/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*직업 job_t에서 occp_re로 코딩*/
data a.hn98_18;
set a.hn98_18;
IF age>=15 & year in (1998,2001,2005) & job^=6 THEN do; 
   if job_t in (1,2) then occp_re=1;
   else IF job_t=3 then occp_re=2;
   else IF job_t=4 then occp_re=3;
   else IF job_t=5 then occp_re=4;
   else IF job_t in (7,8,77) then occp_re=5;
  end;
run;

/*직업 job_t에서 occp_re로 코딩*/
data a.hn98_18;
set a.hn98_18;
IF age>=15 & year in (2007:2018) THEN do; 
if occp in (1,2) then occp_re=1;
if occp=3  then occp_re=2;
if occp=4 then occp_re=3;
if occp in (5,6) then occp_re=4;
if occp=7  then occp_re=5;
end;
run;

/*지역 region_re로 재코딩(개수줄이기)*/
data a.hn98_18;
set a.hn98_18;
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
run;

/* bmi 극단치 제거*//*극단치 제거 a.hn98_18_bmi 에 넣음---------------------------------------------------*/
data a.hn98_18_bmi;
set a.hn98_18;
if year in (1998,2001,2005) then do;
if BMI<=10 or BMI>=50 then delete;
end;
if year in (2007:2018) then do;
if HE_BMI<=10 or HE_BMI>=50 then delete;
end;
run;

proc univariate data=a.hn98_18_bmi;
var BMI he_bmi;
histogram;
run;

/*-------------logistic 성별 소득--------------*/
proc surveylogistic data=a.hn98_18_bmi nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
class incm(ref="4") cage(ref="7") occp_re(ref="5") region_re(ref="1") edu(ref="4");
model obe(EVENT='1')=incm cage edu occp_re region_re/VADJUST=NONE;
domain year*sex;
estimate '소득과 비만율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;

/*--------------성별별 비만 추이 분석-----------*/
proc surveyfreq data=a.hn98_18_bmi nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
tables year*sex*region_re*obe/row chisq;
run;


/*--------------성별별 복부비만(허리둘레) 추이 분석--------*/
proc univariate data=a.hn98_18_bmi;
class year;
var he_wc;
histogram;
run;

data a.hn98_18_wc;
set a.hn98_18_bmi;
if age>=19 & sex=1 & HE_WC in (40:120) then ab_obe=(he_wc>=90);
else if age>=19 & sex=2 & HE_WC in (40:120) then ab_obe=(he_wc>=85);
run;

proc freq data=a.hn98_18_wc;
table ab_obe; run;

proc surveyfreq data=a.hn98_18_wc nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
tables year*sex*region_re*ab_obe/row chisq;
run;

data a.hn98_18_wc;
set a.hn98_18_wc;
if age>=19 & sex=1 then both_obe=(HE_WC>=90 & obe=1);
else if age>=19 & sex=2 then both_obe=(HE_WC>=85 & obe=1);
run;

proc surveyfreq data=a.hn98_18_wc;
strata kstrata;
cluster psu;
weight wt_pool_2;
tables both_obe obe*both_obe ab_obe*both_obe/row chisq;
run;

/*-------------logistic 복부비만--------------*/
proc surveylogistic data=a.hn98_18_wc nomcar;
strata kstrata;
cluster psu;
weight wt_pool_2;
class incm(ref="4") cage(ref="7") occp_re(ref="5") region_re(ref="1") edu(ref="4");
model ab_obe(EVENT='1')=incm cage edu occp_re region_re/VADJUST=NONE;
domain year*sex;
estimate '소득과 비만율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;
