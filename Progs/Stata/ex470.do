sysuse auto, clear
keep if rep78>=3
regress mpg i.rep i.foreign
coefplot, xline(0) omitted baselevels    ///
    groups(3.rep78 = "N = 30"            ///
           4.rep78 = "N = 18"            ///
           5.rep78 = "N = 11"            ///
           0.foreign = "N = 38"          ///
           1.foreign = "N = 21"          ///
           , nogap angle(horizontal))    ///
   drop(_cons) yscale(alt axis(2))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
