sysuse auto, clear
forv i = 3/5 {
    quietly regress price mpg ///
           headroom weight turn  ///
           if rep78==`i'
    estimate store rep78_`i'
}
coefplot rep78_3 || rep78_4 || rep78_5,  ///
    drop(_cons) xline(0)                 ///
    bycoefs byopts(xrescale) 
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

