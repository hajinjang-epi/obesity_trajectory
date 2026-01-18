libname b 'C:\Users\HajinJang\Documents\hn_coded';
libname a 'C:\Users\HajinJang\Documents\hn';

/*전체 음주량과 비만율 변수생성(drinking=3개로 분류)*/
data b.drinking;
set a.hn98_17_03;
if year=1998 & BD1_2^=. then do;
if BD1_2=0 then drinking=1;
else if 1<=BD1_2<=9 then drinking=2;
else if 1<=BD1_2<88 then drinking=3;
end;
if year=2001 & BD1_15^=. then do;
if BD1_15=1 then drinking=1;
else if 2<=BD1_15<=3 then drinking=2;
else if 4<=BD1_15<=5 then drinking=3;
end;
if year=2005 & BD1_12^=. then do;
if BD1_12=0 then drinking=1;
else if 1<=BD1_12<=9 then drinking=2;
else if 1<=BD1_12<88 then drinking=3;
end;
if 2007<=year<=2017 then do;
if 1<=BD1_11<=2 then drinking=1;
else if 3<=BD1_11<=4 then drinking=2;
else if 5<=BD1_11<=6 then drinking=3;
end;
run;


/*전체 음주량과 비만율 변수생성 (drink=5개로 분류)*/
data b.drinking;
set a.hn98_17_03;
if year=1998 & BD1_2^=. then do;
if BD1_2=0 then drink=1;
else if BD1_2=1 then drink=2;
else if 2<=BD1_2<=4 then drink=3;
else if 5<=BD1_2<=15 then drink=4;
else if 16<=BD1_2<88 then drink=5;
end;
if year=2001 & BD1_15^=. then do;
if BD1_15=1 then drink=1;
else if BD1_15=2 then drink=2;
else if BD1_15=3 then drink=3;
else if BD1_15=4 then drink=4;
else if BD1_15=5 then drink=5;
end;
if year=2005 & BD1_12^=. then do;
if BD1_12=0 then drink=1;
else if BD1_12=1 then drink=2;
else if 2<=BD1_12<=4 then drink=3;
else if 5<=BD1_12<=15 then drink=4;
else if 16<=BD1_12<88 then drink=5;
end;
if 2007<=year<=2017 then do;
if 1<=BD1_11<=2 then drink=1;
else if BD1_11=3 then drink=2;
else if BD1_11=4 then drink=3;
else if BD1_11=5 then drink=4;
else if BD1_11=6 then drink=5;
end;
run;

/*전체 음주량과 비만율 연관성분석*/
proc surveyreg data=b.drinking nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
class cage sex occp region;
domain year*sex;
model obe=drink edu cage incm occp region /SOLUTION CLPARM noint vadjust=none;
estimate '음주량별 비만율'
cage 8262905 8627773 8206397 5147501 3635784 2631178/divisor=36511538;
run;

/*사무종사자에서 음주량과 비만율 변수생성(drink_5: 5개로분류)*/
data b.drinking;
set a.hn98_17_03;
if year=1998 & BD1_2^=. & occp=2 then do;
if BD1_2=0 then drink_5=1;
else if BD1_2=1 then drink_5=2;
else if 2<=BD1_2<=4 then drink_5=3;
else if 5<=BD1_2<=15 then drink_5=4;
else if 16<=BD1_2<88 then drink_5=5;
end;
if year=2001 & BD1_15^=. & occp=2 then do;
if BD1_15=1 then drink_5=1;
else if BD1_15=2 then drink_5=2;
else if BD1_15=3 then drink_5=3;
else if BD1_15=4 then drink_5=4;
else if BD1_15=5 then drink_5=5;
end;
if year=2005 & BD1_12^=. & occp=2 then do;
if BD1_12=0 then drink_5=1;
else if BD1_12=1 then drink_5=2;
else if 2<=BD1_12<=4 then drink_5=3;
else if 5<=BD1_12<=15 then drink_5=4;
else if 16<=BD1_12<88 then drink_5=5;
end;
if 2007<=year<=2017 & occp=2 then do;
if 1<=BD1_11<=2 then drink_5=1;
else if BD1_11=3 then drink_5=2;
else if BD1_11=4 then drink_5=3;
else if BD1_11=5 then drink_5=4;
else if BD1_11=6 then drink_5=5;
end;
run;


/*사무종사자에서 음주량과 비만율 변수생성(drink_3: 3개로분류)*/
data b.drinking;
set a.hn98_17_03;
if year=1998 & BD1_2^=. & occp=2 then do;
if BD1_2=0 then drink_3=1;
else if 1<=BD1_2<=9 then drink_3=2;
else if 1<=BD1_2<88 then drink_3=3;
end;
if year=2001 & BD1_15^=. & occp=2 then do;
if BD1_15=1 then drink_3=1;
else if 2<=BD1_15<=3 then drink_3=2;
else if 4<=BD1_15<=5 then drink_3=3;
end;
if year=2005 & BD1_12^=. & occp=2 then do;
if BD1_12=0 then drink_3=1;
else if 1<=BD1_12<=9 then drink_3=2;
else if 10<=BD1_12<88 then drink_3=3;
end;
if 2007<=year<=2017 & occp=2 then do;
if 1<=BD1_11<=2 then drink_3=1;
else if 3<=BD1_11<=4 then drink_3=2;
else if 5<=BD1_11<=6 then drink_3=3;
end;
run;

/*남녀 사무종사자에서의 음주량과 비만율 연관성분석*/
proc surveylogistic data=b.drinking nomcar;
STRATA kstrata;
CLUSTER psu;
weight wt_pool_2;
CLASS sex region drink_3;
domain year*sex;
MODEL obe(EVENT='1')=drink_3 age region incm edu/ VADJUST=none DF=INFINITY;
run;
