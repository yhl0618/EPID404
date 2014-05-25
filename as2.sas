Libname shore 'C:\Users\hailinyu\OneDrive\Courses\EPID 404\Homework 5';
Data shore.set;
run;

Proc import datafile = 'C:\Onshore.xlsx' out = shore.set
DBMS = xlsx REPLACE;SHEET = 'Data - full';
run;


proc format;
value exp
1 = ' A few days'
2 = '  Daily/Almost every day'
0 = 'Not at all';

value sym
0 = 'No symptom'
1 = '1 symptom'
2 = '  2 or more symptoms';

value symf
0 = 'No symptom'
1 = '1 symptom'
2 = '  2 symptoms'
3 = '   3  or more symptoms';

value cula
0 = 'No symptom'
1 = ' 1 and more symptoms ';

value culb
0 = 'No symtom and 1 Symptom'
1 = ' 2 and more symptoms';

value culc
0 = '2 or less syptoms'
1 = ' 3 and more symptoms';

value expx
0 = 'Neither'
1 = ' Exposed to Dust'
2 = '  Exposed to Dispersant'
3 = '   Exposed to Both';

value state
0 = "AL/FL"
1 = "MS"
2 = "LA";

value age
0 = '<40'
1 = '>=40';

value stat
0 = 'AL/FL'
1 = 'LA/MS';

value symd
0 ='No'
1= ' Yes';
run;

data shore.hw5;
set shore.set;

* missing value recode as 0;
if EDISPERSANT1 = 1 then dp= 1;
else if EDISPERSANT1 = 2 or EDISPERSANT1=3 then dp =2;
else dp=0;

* missing value recode as 0;
if EDUST = 1 then dust = 1;
else if EDUST = 2 or EDUST =3 then dust =2;
else dust =0; 

*recode outcome;
if SYMPT_ENT_SUM = 1 then sym=1;
else if SYMPT_ENT_SUM ge 2 then sym=2;
else if SYMPT_ENT_SUM = 0 then sym = 0;

if SYMPT_ENT_SUM = 1 then symf=1;
else if SYMPT_ENT_SUM = 2 then symf=2;
else if SYMPT_ENT_SUM ge 3 then symf=3;
else if SYMPT_ENT_SUM = 0 then symf = 0;

if sym=0 then cul1=0;
else if sym ge 1 then cul1=1;

if sym=1 or sym =0  then cul2=0;
else if sym ge 2 then cul2=1;

if sym ge 1 then symd=1;
else if sym = 0 then symd=0;

if dust=0 and dp = 0 then exp =0; else
if dust ge 1 and dp = 0 then exp=1; else 
if dust =0 and dp ge 1 then exp=2; else
if dust ge 1 and dp ge 1 then exp=3;

if agegrp =1 or agegrp =2 then agen=0;
else if agegrp ge 3 then agen=1;

if state ^= '.' then st1= state;
if st1 = "AL" or st1 = "FL" then st=0;
else if st1 = "MS" then st=1;
else if st1 = "LA" then st=2;

if st=0 then st2=0;
else if st=1 then st2=1;
else if st=2 then st2=1;

sm=smoker;
aller=cconditionallergy;

if st=. or aller=. or smoker=. or agen=. then mis=1;
else mis=0;

format dp exp.;
format dust exp.;
format sym sym.;
format cul1 cula.;
format cul2 culb.;
format symf symf.;
format exp expx.;
format st state.;
format age1 age.;
format st2 stat.;
format symd symd.;
run;


data shore.as2;set shore.hw5;

if sm ^= .;
if agen ^= .;
if st ^=.;
if aller ^=.;

run;

data shore.nms;set shore.hw5;

if sm ^= .;
if agen ^= .;
if st ^=.;
if aller ^=.;
run;

data shore.ms;set shore.hw5;

if sm = .;
if agen = .;
if st =.;
if aller =.;
run;

proc freq;
tables st state;
run;

proc freq;
where state in ("LA","MS");
tables state*exp/chisq;
run;


*Univariate Analysis;
Proc freq;
tables sym;
run;

*Bivariate Analysis;
Proc freq;
tables (smoker st agegrp cconditionAllergy)*sym/chisq;
run;

Proc freq;
tables (smoker state st agen cconditionAllergy)*exp/chisq;
run;

Proc freq;
where state in ("FL", "AL");
tables  state *sym/chisq;
run;

Proc freq;
tables  state *exp/chisq;
run;

*Bivarite Analysis;

proc freq order=formatted;
where sym in (0,1) and exp in (0,1);
tables exp*sym/chisq relrisk;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,1);
tables exp*sym/chisq relrisk;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,2);
tables exp*sym/chisq relrisk;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,2);
tables exp*sym/chisq relrisk;
run;

proc freq order=formatted;
where sym in (0,1) and exp in (0,3);
tables exp*sym/chisq relrisk;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,3);
tables exp*sym/chisq relrisk;
run;


* stratified analysis;
* by age;

proc freq order=formatted;
where sym in (0,1) and exp in (0,1);
tables agen*exp*sym/chisq relrisk cmh;
run;
proc freq order=formatted;
where sym in (0,2) and exp in (0,1);
tables agen*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,2);
tables agen*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,2);
tables agen*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,3);
tables agen*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,3);
tables agen*exp*sym/chisq relrisk cmh;
run;




* by state;

proc freq order=formatted;
where sym in (0,1) and exp in (0,1);
tables st*exp*sym/chisq relrisk cmh;
run;
proc freq order=formatted;
where sym in (0,2) and exp in (0,1);
tables st*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,2);
tables st*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,2);
tables st*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,3);
tables st*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,3);
tables st*exp*sym/chisq relrisk cmh;
run;



* by smoker;

proc freq order=formatted;
where sym in (0,1) and exp in (0,1);
tables smoker*exp*sym/chisq relrisk cmh;
run;
proc freq order=formatted;
where sym in (0,2) and exp in (0,1);
tables smoker*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,2);
tables smoker*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,2);
tables smoker*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,3);
tables smoker*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,3);
tables smoker*exp*sym/chisq relrisk cmh;
run;



* by allergy;

proc freq order=formatted;
where sym in (0,1) and exp in (0,1);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;
proc freq order=formatted;
where sym in (0,2) and exp in (0,1);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,2);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,2);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;


proc freq order=formatted;
where sym in (0,1) and exp in (0,3);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;

proc freq order=formatted;
where sym in (0,2) and exp in (0,3);
tables cconditionallergy*exp*sym/chisq relrisk cmh;
run;



proc logistic order=formatted;
class st(ref="AL/FL") exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp st smoker agen cconditionallergy exp*st exp*smoker exp*cconditionallergy/link=glogit;
run;

proc logistic order=formatted data=shore.hw5;
class st(ref="AL/FL") exp(ref="Neither")/param=ref;
model sym(ref="No symptom") =  st  exp  exp*st/link=glogit;
run;

proc logistic order=formatted data=shore.hw5;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") =  st2  exp  exp*st2/link=glogit;
run;

proc logistic order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp cconditionallergy/link=glogit;
run;

proc sort data=shore.hw5;
by st;
run;

proc logistic order=formatted data=shore.hw5;
by st;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp sm agen aller;
run;


proc freq order=formatted data= shore.hw5;
where st = 1;
tables exp*sym;
run;

proc freq order=formatted data= shore.hw5;
where st = 2;
tables exp*sym;
run;
proc freq order=formatted data=shore.as2;
tables st aller agen sm sym exp /list missing;
run;

proc freq order=formatted data=shore.hw5;
tables st1 /list missing;
run;


proc sort;
by st2;
run;

proc logistic order=formatted data=shore.hw5;
by st2;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp sm agen aller ;
run;

proc freq order=formatted data= shore.hw5;
where st = 2 and sym in (0,2) and exp in (0,2);
tables exp*sym /chisq relrisk;
run;

proc sort data=shore.hw5;
by st;
run;

proc logistic order=formatted data=shore.hw5;
by st;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp sm agen aller ;
run;

proc logistic order=formatted data=shore.nms;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp ;
run;


*sensitivity analysis;
proc logistic order=formatted data=shore.hw5;
where st=. or aller=. or smoker=. or agen=.;
class exp(ref="Neither")/param=ref;
model sym(ref="No symptom") = exp ;
run;


proc freq order=formatted data=shore.hw5;
where st=. or aller=. or smoker=. or agen=.;
tables exp;
run;

proc freq order=formatted data=shore.hw5;
where st=. or aller=. or smoker=. or agen=.;
tables ;
run;



*dicho logit;
proc sort;
by st;
run;
proc logistic data=shore.hw5 order=formatted;
class exp(ref="Neither") st(ref="AL/FL")/param=ref;
model sym = exp st ;
run;

proc logistic data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model symd = exp sm agen aller ;
run;

proc logistic data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model sym = exp sm agen aller ;
run;

proc logistic data=shore.hw5 order=formatted;
class exp(ref="Neither")/param=ref;
model symd = exp sm agen aller ;
run;

*log binormal;
proc genmod data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model symd = exp sm agen aller /link=log dist=bin ;
estimate "Both vs Neither" exp 1 0 0/exp;
estimate "Dispersant vs Neither" exp 0 1 0/exp;
estimate "Dust vs Neither" exp 0 0 1/exp;
run;

*sensitivity;
proc freq data=shore.hw5;
tables mis*sym mis*exp/chisq;
run;


proc freq data=shore.hw5;
tables smoker/chisq;
run;


proc sort;
by st;
run;

proc logistic data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model sym= exp sm agen aller ;
run;

proc sort;
by state;
run;

proc logistic data=shore.hw5 order=formatted;
by state;
class exp(ref="Neither")/param=ref;
model sym= exp sm agen aller ;
run;

proc freq data=shore.hw5 order=formatted;
where state="FL";
tables exp*sym;
run;

proc freq data=shore.hw5 order=formatted;
by state;
tables exp*SYMPT_ENT_SUM;
run;


proc freq data=shore.hw5 order=formatted;
tables sym * state/ list missing;
run;

proc sort data=shore.hw5;
by aller;
run;
proc freq data=shore.hw5;
tables (st sm aller agen)*sym/chisq;
run;

proc freq data=shore.hw5;
tables (st sm aller agegrp)*exp/chisq;
run;


proc freq data=shore.hw5;
tables st*sym/chisq;
run;

proc sort;
by mis;
run;
proc freq order=formatted;
tables agen*exp agen*sym/chisq;
run;

proc logistic data=shore.hw5 order=formatted;
by mis;
class exp(ref="Neither")/param=ref;
model sym= exp;
run;




proc freq;
tables sym exp;
run;

proc sort;
by mis;
run;

proc logistic data= shore.hw5;


proc sort;
by st;
run;

proc logistic data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model symd= exp sm agen aller ;
run;

proc sort;
by st;
run;

proc genmod data=shore.hw5 order=formatted;
by st;
class exp(ref="Neither")/param=ref;
model symd= exp sm agen aller/link=log dist=bin;
estimate "Both vs Neither" exp 1 0 0/exp;
estimate "Dispersant vs Neither" exp 0 1 0/exp;
estimate "Dust vs Neither" exp 0 0 1/exp;
run;
