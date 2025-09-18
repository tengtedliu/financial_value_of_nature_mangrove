/* panelEventReplication.do         KTS/DCC                yyyy-mm-dd:2020-07-06
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

This do file replicates the results provided in the working paper 
 "Implementing the Panel Event Study" written by Damian Clarke and Kathya Tapia
Schythe.  In certain cases these results will require the user-written reghdfe
and boottest command.  If these are not installed, they can be installed using:

ssc install reghdfe
ssc install boottest

This script replicates output as included in the paper, and as such requires the
sjlog command.  This can be installed using the following commands:

net from http://www.stata-journal.com/software/sj16-3/
net install pr0062_1.pkg

*/

clear all
set more off
set linesize 80

set scheme sj

*0.- Data
sjlog using eventdd1, replace
webuse set www.damianclarke.net/stata/
webuse bacon_example
generate timeToTreat = year - _nfd
sjlog close, replace


sjlog using eventdd2, replace
sort stfips year
list stfips year _nfd timeToTreat in 1/10, noobs sepby(stfips) abbreviate(11)
sjlog close, replace


*****A.- Estimation*****

*1.- eventdd: all periods
*a.- OLS
sjlog using eventdd3, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year i.stfips, timevar(timeToTreat)
method( , cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventdd1.pdf, replace

*b.- Stored results: e()
sjlog using eventdd4, replace
matrix list e(leads)
sjlog close, replace

*c.- FE
sjlog using eventdd5, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat)
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventdd2.pdf, replace

*d.-HDFE
sjlog using eventdd6, replace
#delimit ;
eventdd asmrs pcinc asmrh cases, timevar(timeToTreat) 
method(hdfe, absorb(i.stfips i.year) cluster(stfips)) 
graph_op(ytitle("Suicides per 1m women") xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventdd3.pdf, replace


*2.- eventdd: parallel trends test
sjlog using eventdd7, replace
estat leads
sjlog close, replace


*3.- eventdd: baseline() - noline
sjlog using eventdd8, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) baseline(-11)
noline method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventdd4.pdf, replace


*4.- eventdd: inrange
sjlog using eventdd9, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) inrange leads(10) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd5.pdf, replace


*5.- eventdd: balanced
sjlog using eventdd10, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) balanced 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd6.pdf, replace


*6.- eventdd: keepbal()
sjlog using eventdd11, replace
#delimit ;
eventdd asmrs pcinc asmrh cases, timevar(timeToTreat) keepbal(stfips) leads(15) 
lags(10) method(hdfe, absorb(i.stfips i.year) cluster(stfips))
graph_op(ytitle("Suicides per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd7.pdf, replace


*7.- eventdd: accum
sjlog using eventdd12, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd8.pdf, replace


*8.- eventdd: accum - noend
sjlog using eventdd13, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) noend method(fe, cluster(stfips)) graph_op( ytitle("Suicides per 
1m women"));
#delimit cr
sjlog close, replace
graph export eventdd9.pdf, replace



*****B.- Inference*****

*9.- eventdd: level()
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women"));
#delimit cr
graph export eventdd10.pdf, replace

sjlog using eventdd14, replace 
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips) level(90)) graph_op(ytitle("Suici
des per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd11.pdf, replace


*10.- eventdd: wboot - wboot_op()
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(10) 
lags(10) method(fe, cluster(stfips))graph_op(ytitle("Suicides per 1m women"));
#delimit cr
graph export eventdd12.pdf, replace

sjlog using eventdd15, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(10) 
lags(10) method(fe, cluster(stfips)) wboot wboot_op(seed(1303)) graph_op(ytitle(
"Suicides per 1m women"));
#delimit cr
sjlog close, replace
graph export eventdd13.pdf, replace


*****C.- Appearance*****

*11.- eventdd: ci()
*a.- rarea
sjlog using eventdd16, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rarea) 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventdd14.pdf, replace	

*b.- rcap
sjlog using eventdd17, replace
#delimit ;
quietly 
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rcap)
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventdd15.pdf, replace	

*c.- rline
sjlog using eventdd18, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rline) 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventdd16.pdf, replace	


*12.- eventdd: graph_op - ci_op - coef_op
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(20) method(fe, cluster(stfips)) ci(rarea) graph_op(ytitle("Suicides per 1m 
women") xlabel(-15(5)20));
#delimit cr
graph export eventdd17.pdf, replace

sjlog using eventdd19, replace
#delimit ;
quietly
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(20) method(fe, cluster(stfips)) ci(rarea, fcolor(ltblue%45)) 
graph_op(xlabel(-15 "{&le} -15" -10 "-10" -5 "-5" 0 "0" 5 "5" 10 "10" 15 "15" 
20 "{&le} 20") scheme(s1mono) ytitle("Suicides per 1m women")) coef_op(msymbol(Oh)) 
endpoints_op(msymbol(O));
#delimit cr
sjlog close, replace
graph export eventdd18.pdf, replace



