*exporting of proc means;
proc means data=sashelp.cars;
var MPG_City MPG_Highway;
output out = want;
run;

proc export data=want outfile='../output/data_table_1.xlsx' dbms=xlsx replace;run;


*advanced section. ods;
ods trace on;
ODS PDF 
   FILE = '../output/CARS2.pdf'
   STYLE = EGDefault;
proc SQL;
select make, model, invoice 
from sashelp.cars
where make in ('Audi','BMW')
and type = 'Sports'
;
quit;

proc SQL;
select make,mean(horsepower)as meanhp
from sashelp.cars
where make in ('Audi','BMW')
group by make;
quit;

ODS PDF CLOSE; 
ods trace off;


ODS RTF 
FILE = '../output/CARS.rtf'
STYLE = EGDefault;
proc SQL;
select make, model, invoice 
from sashelp.cars
where make in ('Audi','BMW')
and type = 'Sports'
;
quit;

proc SQL;
select make,mean(horsepower)as meanhp
from sashelp.cars
where make in ('Audi','BMW')
group by make;
quit;

ODS rtf CLOSE; 

*using with formatting and style sheet;
options nodate nonumber obs=25;
ods html5 close;
ods pdf notoc file="../output/myReport.pdf"
                     cssstyle="syle.css";


title "Comparison of City and Highway Miles Per Gallon";
title2 "Colors Added by CSS";

proc print data=sashelp.cars;
   var make model type Origin MPG_City MPG_Highway;
run;

ods graphics on;

proc reg data=sashelp.baseball;
   id name team league;
   model logSalary = nhits nruns nrbi nbb yrmajor crhits;
run;

ods pdf close;


*exporting of proc means;
proc means data=sashelp.cars;
var MPG_City MPG_Highway;
ods output summary = want;
run;

proc export data=want outfile='../output/data_table.xlsx' dbms=xlsx replace;run;

ods excel file='../output/data_table2.xlsx' style=seaside;

proc means data=sashelp.cars;
var MPG_City MPG_Highway;
ods output summary = want;
run;

ods excel close;
