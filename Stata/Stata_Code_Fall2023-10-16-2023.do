*There are a few ways to create publication ready tables in STATA. The first way we will explore is using outreg2. Later, we will look at tabout. outreg2 is useful if you are writing your papers in Word, while tabout comes in handy for LaTeX users. All a matter of preferences.

*may need to use the sysdir set PLUS command to change location of PLUS directory if you do not have write permissions. Syntax below.
*sysdir set PLUS "Path to folder you can write to"
*Link below has helpful information.
*https://kb.iu.edu/d/arur

*First, let's make sure you have outreg2 installed
 ssc install outreg2
 
 *For the ease of learning, we are going to use a STATA dataset. Let's call for it now. This will show us data from the National Longitudinal Survey of Young Women, circa 1968
  webuse nlswork, clear
  
  *Now let's create a regression for STATA to run
  reg ln_wage grade ttl_exp hours
  
  *Great! This table tells us some good information, but it's not something we'd stick into a paper manuscript is it? Let's use outreg2 to help us out.
  outreg2 using reg1.doc, replace
  *to look at the document, I as a Mac user would click "dir". Windows users, click on the word doc name!
  
  *What if we want to add more to that? Let's add a column here.
  reg ln_wage grade ttl_exp hours age race union
  
   outreg2 using reg1.doc, append
  
*Columns make little sense without their labels -- here's some code to add them.
reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2)

*We can illustrate variable labels rather than their names by using the label option
reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2)

*If you want to change things like the decimal places of the coefficients produced
reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1) label dec(2)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2) label dec(2)

*If you want decimal places for coefficients to be different than those for the standard errors, we can use different codes as well for this

reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1) label dec(2)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2) label dec(2)

*Do you need to include notes at the end of your tables? addnote() will do this
reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1) label bdec(3) sdec (4)addnote (Notes: real income is the dependent variable in both Model 1 and Model 2.)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2) label bdec(3) sdec (4) 

*What else are we missing? Oh yeah, a TITLE
reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace ctitle (Model 1) label dec(3) title (Table 1: Determinants of Income)
reg ln_wage grade ttl_exp hours age race union
outreg2 using myreg.doc, append ctitle (Model 2) label dec(3)

*Too many variables? keep() or drop() may be useful here.

reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace keep (grade)

reg ln_wage grade ttl_exp hours
outreg2 using myreg.doc, replace drop (ttl_exp hours)


*This is the basic ins and outs using outreg2. Now if you're interested in creating tables for LaTeX, tabout can be useful!

ssc install tabout
set more off
clear all

sysuse cancer, clear
la var died "Patient died"
la def ny  0 "No" 1 "Yes", modify
la val died ny
recode studytime ///
    (min/10 = 1 "10 or less months") ///
    (11/20 = 2 "11 to 20 months") ///
    (21/30 = 3 "21 to 30 months") ///
    (31/max = 4 "31 or more months") ///
    , gen(stime)
la var stime "To died or exp. end"

la var drug "Drug type"
la def drug 1 "Placebo" 2 "Trial drug 1" ///
    3 "Trial drug 2", modify
la val drug drug


* estout is yet another tool for making tables

ssc install estout
set more off
clear all

sysuse nlsw88, clear

*generate a dummy variable for each race category
tab race, gen(dum_race)


*calculate summary statistics for the specified variables
estpost summarize age wage dum_race1 dum_race2 dum_race3 collgrad

*store the calculated summary statistics in a macro 
eststo summstats

*output the summary statistics to a table
esttab summstats using table2.rtf,  replace main(mean %6.2f) aux(sd) nomtitles nonumber nostar ///
refcat(dum_race1 "Race:", nolabel) ///
coeflabel(dum_race1 "White" dum_race2 "Black" dum_race3 "Other" age "Age" wage "Hourly wage" collgrad "College graduate") ///
title(Table 2. Summary Statistics, NLSW88) ///
nonotes addn(Standard deviations in parentheses.)

*run a regression
regress wage age collgrad dum_race2 dum_race3

*store the regression results in a macro
eststo regression

*output the regression results to a table
esttab regression using table3.rtf, replace se r2 nostar ///
mtitle("Dependent variable: Wage") ///
refcat(dum_race2 "Race:", nolabel) ///
coeflabel(dum_race2 "Black" dum_race3 "Other" age "Age" wage "Hourly wage" collgrad "College graduate" _cons "Constant") ///
title(Table 3. Regression Results) ///
addn(The omitted race category is white.)

* MORE
*summary stats by subsample
eststo grad: estpost summarize age wage dum_race1 dum_race2 dum_race3 if collgrad==1
eststo nograd: estpost summarize age wage dum_race1 dum_race2 dum_race3 if collgrad==0

esttab summstats grad nograd using table4.rtf,  replace main(mean %6.2f) aux(sd) nonumber nostar ///
mtitle("Full sample" "College graduates" "Non-college graduates") ///
refcat(dum_race1 "Race:", nolabel) ///
coeflabel(dum_race1 "White" dum_race2 "Black" dum_race3 "Other" age "Age" wage "Hourly wage" collgrad "College graduate") ///
title(Table 4. Summary Statistics, NLSW88) ///
nonotes addn(Standard deviations in parentheses.)

*place std dev in its own column
esttab summstats grad nograd using table4b.rtf,  replace cell("mean(fmt(2)) sd(fmt(2))") nonumber nostar ///
mtitle("Full sample" "College graduates" "Non-college graduates") ///
refcat(dum_race1 "Race:", nolabel) ///
coeflabel(dum_race1 "White" dum_race2 "Black" dum_race3 "Other" age "Age" wage "Hourly wage" collgrad "College graduate") ///
title(Table 4. Summary Statistics, NLSW88)



