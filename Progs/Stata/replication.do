clear all
set more off

set scheme sj

*0.- Data
sjlog using time, replace
webuse set www.damianclarke.net/stata/
webuse bacon_example.dta, clear
gen timeToTreat = year - _nfd
sjlog close, replace


sjlog using description, replace
sort stfips year
list stfips year _nfd timeToTreat in 1/10, noobs sepby(stfips) abbreviate(11)
sjlog close, replace


*****A.- Estimation*****

*1.- eventdd: all periods
*a.- OLS
sjlog using eventDD_ols, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year i.stfips, timevar(timeToTreat)
method( , cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventDD_ols.eps, replace

*b.- Stored results: e()
sjlog using eventDD_stored, replace
mat list e(leads)
sjlog close, replace

*c.- FE
sjlog using eventDD_fe, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat)
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventDD_fe.eps, replace

*d.-HDFE
sjlog using eventDD_hdfe, replace
#delimit ;
eventdd asmrs pcinc asmrh cases, timevar(timeToTreat) 
method(hdfe, absorb(i.stfips i.year) cluster(stfips)) 
graph_op(ytitle("Suicides per 1m Women") xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventDD_hdfe.eps, replace


*2.- eventdd: parallel trends test
sjlog using eventDD_test, replace
estat leads
sjlog close, replace


*3.- eventdd: baseline() - noline
sjlog using eventDD_fe_baseline, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) baseline(-11)
noline method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace
graph export eventDD_fe_baseline.eps, replace


*4.- eventdd: inrange
sjlog using eventDD_fe_inrange, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) inrange leads(10) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_inrange.eps, replace


*5.- eventdd: balanced
sjlog using eventDD_fe_balanced, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) balanced 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_balanced.eps, replace


*6.- eventdd: keepbal()
sjlog using eventDD_fe_keepbal, replace
#delimit ;
eventdd asmrs pcinc asmrh cases, timevar(timeToTreat) keepbal(stfips) leads(15) 
lags(10) method(hdfe, absorb(i.stfips i.year) cluster(stfips))
graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_keepbal.eps, replace


*7.- eventdd: accum
sjlog using eventDD_fe_accum, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_accum.eps, replace


*8.- eventdd: accum - noend
sjlog using eventDD_fe_noend, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) noend method(fe, cluster(stfips)) graph_op( ytitle("Suicides per 
1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_noend.eps, replace



*****B.- Inference*****

*9.- eventdd: level()
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
graph export eventDD_fe_level1.eps, replace

sjlog using eventDD_fe_level, replace 
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(10) method(fe, cluster(stfips) level(90)) graph_op(ytitle("Suici
des per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_level2.eps, replace


*10.- eventdd: wboot - wboot_op()
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(10) 
lags(10) method(fe, cluster(stfips))graph_op(ytitle("Suicides per 1m Women"));
#delimit cr
graph export eventDD_fe_wboot1.eps, replace

sjlog using eventDD_fe_wboot, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(10) 
lags(10) method(fe, cluster(stfips)) wboot wboot_op(seed(1303)) graph_op(ytitle(
"Suicides per 1m Women"));
#delimit cr
sjlog close, replace
graph export eventDD_fe_wboot2.eps, replace


*****C.- Appearance*****

*11.- eventdd: ci()
*a.- rarea
sjlog using eventDD_fe_rarea, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rarea) 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventDD_fe_rarea.eps, replace	

*b.- rcap
sjlog using eventDD_fe_rcap, replace
#delimit ;
qui 
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rcap)
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventDD_fe_rcap.eps, replace	

*c.- rline
sjlog using eventDD_fe_rline, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) ci(rline) 
method(fe, cluster(stfips)) graph_op(ytitle("Suicides per 1m Women") 
xlabel(-20(5)25));
#delimit cr
sjlog close, replace	
graph export eventDD_fe_rline.eps, replace	


*12.- eventdd: graph_op - ci_op - coef_op
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(20) method(fe, cluster(stfips)) ci(rarea) graph_op(ytitle("Suicides per 1m 
Women") xlabel(-15(5)20));
#delimit cr
graph export eventDD_fe_nice1.eps, replace

sjlog using eventDD_fe_nice, replace
#delimit ;
qui
eventdd asmrs pcinc asmrh cases i.year, timevar(timeToTreat) accum leads(15) 
lags(20) method(fe, cluster(stfips)) ci(rarea, fcolor(ltblue%45)) 
graph_op(xlabel(-15 "{&le} -15" -10 "-10" -5 "-5" 0 "0" 5 "5" 10 "10" 15 "15" 
20 "{&le} 20") scheme(s1mono) ytitle("Suicides per 1m Women")) coef_op(msymbol(Oh)) 
endpoints_op(msymbol(O));
#delimit cr
sjlog close, replace
graph export eventDD_fe_nice2.eps, replace



