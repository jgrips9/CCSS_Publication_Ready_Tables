*open sample dataset. 
sysuse auto, clear

scatter mpg weight
graph export scatter.png, replace
graph export scatter.pdf, replace

*Create summary table. Then export dataset as excel
collapse (mean) mean_mpg = mpg mean_price = price (sd) sd_mpg = mpg sd_price = price, by(foreign)
export excel using "Descriptives_Stata.xlsx", first(var) replace


*Through the use of a package. Specific packages created to export results nicely. 
ssc install estout, replace



*create regression table
sysuse auto, clear
reg mpg weight foreign

esttab, se

*export word file. rtf is file that can be opened in word. 
esttab using "regression.rtf", replace eform z


reg mpg foreign
est sto m1
reg mpg foreign weight
est sto m2
reg mpg foreign weight displacement gear_ratio
est sto m3

esttab m1 m2 m3

esttab m1 m2 m3 using "multiple reg.rtf", label nonumber title("Models of MPG") mtitle("Model 1" "Model 2" "Model 3") p star(+ 0.1 * 0.05 ** 0.01) replace

*Summary tables
estpost sum price foreign mpg

esttab using "table.rtf", modelwidth(10 20) cell((mean(label(Mean)) sd(par label(Standard Deviation)))) label nomtitle nonumber replace





*Advavnced Section
sysuse auto, clear

putpdf begin

// Create a paragraph
putpdf paragraph
putpdf text ("putpdf "), bold
putpdf text ("can add formatted text to a paragraph.  You can ")
putpdf text ("italicize, "), italic
putpdf text ("striketout, "), strikeout
putpdf text ("underline"), underline
putpdf text (", sub/super script")
putpdf text ("2 "), script(sub)
putpdf text (", and   ")
putpdf text ("bgcolor"), bgcolor("blue")
qui sum mpg
local sum : display %4.2f `r(sum)'
putpdf text (".  Also, you can easily add Stata results to your paragraph (mpg total = `sum')")

// Embed a graph
histogram rep
graph export hist.png, replace
putpdf paragraph, halign(center)
putpdf image hist.png

// Embed Stata output
putpdf paragraph
putpdf text ("Embed the output from a regression command into your pdf file.")
regress mpg price
putpdf table mytable = etable

// Embed Stata dataset
putpdf paragraph
putpdf text ("Embed the data in Stata's memory into a table in your pdf file.")
statsby Total=r(N) Average=r(mean) Max=r(max) Min=r(min), by(foreign): summarize mpg
rename foreign Origin
putpdf table tbl1 = data("Origin Total Average Max Min"), varnames  ///
        border(start, nil) border(insideV, nil) border(end, nil)

putpdf save "myreport.pdf", replace
timer off 1
timer list

*putexcel command
*load system dataset
sysuse auto, clear

*perfrom command on 1 variable
ci means price

*create excel worksheet to export to
putexcel set "results_exp", sheet(res)

putexcel (A1) = ("OBS") (B1) = ("Mean") (C1) = ("standard Error") (D1) = ("Lower Bound") (E1) = ("Upper Bound") (F1) = ("Confidence Level")
putexcel (A2) = rscalars, colwise
*Below method to export each individual element to excel. 
putexcel set "results_exp1", sheet(res)
*names used below gotten from following command
return list
*Headings to excel columns
putexcel (A1) = ("OBS")
putexcel (B1) = ("Mean")
putexcel (C1) = ("Lower Bound")
putexcel (D1) = ("Upper Bound")
*excel data
putexcel (A2) = (r(N))
putexcel (B2) = (r(mean))
putexcel (C2) = (r(lb))
putexcel (D2) = (r(ub))

putexcel (A5) = ("OBS") (B5) = ("Mean") (C5) = ("Standard Error") (D5) = ("Lower Bound") (E5) = ("Upper Bound") (F5) = ("Confidence Level")
*nkow export ci_means for mpg variable.
ci means mpg
putexcel (A6) = rscalars, colwise

*next for length variable, you get it
putexcel (A8) = ("OBS") (B8) = ("Mean") (C8) = ("Standard Error")(D8) = ("Lower Bound") (E8) = ("Upper Bound") (F8) = ("Confidence Level")
ci means length
putexcel (A9) = rscalars, colwise


*Putexcel command. Performed in loop. 
*load system dataset
sysuse auto, clear

*variable list macro
local vlist price mpg trunk weight length turn displacement headroom
*Excel cells organization macro.
local exnum = 2

*Setup excel sheet and file names along with headings. Same headings all variables.
*Could alter the format a bit.
putexcel set "results_exp2", sheet(res)
putexcel (A1) = ("OBS") (B1) = ("Mean") (C1) = ("standard Error") (D1) = ("Lower Bound") (E1) = ("Upper Bound") (F1) = ("Confidence Level")

foreach var of varlist `vlist' {
*perform cimean of variables in order of macro: price mpg trunk weight length turn displacement headroom
ci means `var'
*Place variable name in own row, bolded text.
putexcel (A`exnum') = "`var'", bold
*Increase organize macro to go to next row in excel.
local exnum = `exnum' + 1
*Place measures of ci mean into excel
putexcel (A`exnum') = rscalars, colwise
*2 new rows when switching to new variable.
local exnum = `exnum' + 2
}


*using tabout command
ssc install tabout, replace
*Other. Using tabout feature
sysuse cancer, clear
la var died "Patient died"
la def ny 0 "No" 1 "Yes", modify
la val died ny
recode studytime (min/10 = 1 "10 or less months") ///
(11/20 = 2 "11 to 20 months") ///
(21/30 = 3 "21 to 30 months") ///
(31/max = 4 "31 or more months") ///
, gen(stime)
la var stime "To died or exp. end"
tabout stime died using "table1.txt", ///
cells(freq col cum) format(0 1) clab(No. Col_% Cum_%) ///
replace

*outreg2 package. 
ssc install outreg2
sysuse auto,clear
regress mpg foreign weight headroom trunk length turn displacement

est store Full
regress mpg foreign weight headroom

est store Restricted1
regress mpg foreign weight

    est store Restricted2
    outreg2 [Full Restricted1 Restricted2] using myfile, replace see

    outreg2 will take the stored estimates as wildcards (*). Try this:

    outreg2 [*] using myfile, see replace
    outreg2 [R*] using myfile, see replace

    outreg2 foreign weight [*] using myfile, see replace
