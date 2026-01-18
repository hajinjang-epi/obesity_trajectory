libname a "C:\Users\HajinJang\Documents\hn";
run;

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

data hn98_05;
set a.hn98_all a.hn01_all a.hn05_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;


data hn98_17;
set hn98_05 a.hn07_all a.hn08_all a.hn09_all a.hn10_all a.hn11_all a.hn12_all a.hn13_all 
a.hn14_all a.hn15_all a.hn16_all a.hn17_all;
drop LS_type1 LS_type2 LS_type3 LS_type4;
run;

DATA hn98_17;
SET hn98_17;

/*연령구간 변수(cage) 생성*/
      IF 19<=age<=29 THEN cage=2; ELSE IF 30<=age<=39 THEN cage=3;
ELSE IF 40<=age<=49 THEN cage=4; ELSE IF 50<=age<=59 THEN cage=5;
ELSE IF 60<=age<=69 THEN cage=6; ELSE IF 70<=age THEN cage=7;

/*성인 비만 유병여부 변수(OBE) 생성*/
IF age>=19 & ((year in (1998,2001) & HS_mens^=3) or (year=2005 & HE_mens^=3)) THEN do;
   IF HE_ht^=. & HE_wt^=. THEN BMI = HE_wt / ((HE_ht/100)**2);
   IF BMI^=. THEN OBE = (BMI>=25);
END; 
IF age>=19 & 2007<=year<=2017 & HE_obe in (1,2,3) THEN OBE = (HE_obe=3);

/*1)연도별 가중치 변수명 통일(wt_pool_1), 2)통합가중치 변수(wt_pool_2) 생성*/ 
IF 1998<=year<=2001 THEN do; 
   wt_pool_1 = wt_ex;    wt_pool_2 = wt_ex_t;
end;
IF 2005<=year<=2009 THEN do; 
   wt_pool_1 = wt_ex;    wt_pool_2 = wt_ex; 
end;
IF 2010<=year<=2017 THEN do; 
   wt_pool_1 = wt_itvex;  wt_pool_2 = wt_itvex;
end;

RUN;

proc surveyreg data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage;
domain year*sex;
model obe=cage/noint vadjust=none;
estimate '연도별 성별 비만 유병율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;


/*성별과 비만 연관성분석*/
proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS sex(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=sex / VADJUST=none DF=INFINITY;
run;

/*나이와 비만 연관성분석*/
proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
domain year;
MODEL obe(EVENT='1')=age / VADJUST=none DF=INFINITY;
run;

/*소득(개인)과 비만 연관성분석*/
proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS incm(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=incm / VADJUST=none DF=INFINITY;
run;ho_incm

/*소득(가구)과 비만 연관성분석*/
proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS ho_incm(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=ho_incm / VADJUST=none DF=INFINITY;
run;

/*교육수준과 비만 연관성분석*/
data hn98_17;
set hn98_17;
IF age>=19 & year in (1998,2001) THEN do; 
   if 0<=educ<=2 then edu=1;
   else IF educ=3 then edu=2;
   else IF educ=4 then edu=3;
   else IF 5<=educ<=6 then edu=4;
end;
run;

proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS edu(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=edu / VADJUST=none DF=INFINITY;
run;


/*직업과 비만 연관성분석*/
data hn98_17;
set hn98_17;
IF age>=15 & year in (1998,2001) & job^=10 THEN do; 
   if 1<=job<=3 then occp=1;
   else IF job=4 then occp=2;
   else IF job=5 then occp=3;
   else IF job=6 then occp=4;
   else IF 7<=job<=8 then occp=5;
   else IF job=9 then occp=6;
   else IF 11<=job<=77 then occp=7;
end;
run;

proc surveylogistic data=hn98_17 nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS occp(PARAM=REF REF='1');
domain year;
MODEL obe(EVENT='1')=occp / VADJUST=none DF=INFINITY;
run;



