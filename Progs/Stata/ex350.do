sysuse auto, clear
regress price mpg trunk length turn
coefplot, drop(_cons) xline(0)           ///
    msymbol(s) mfcolor(white)            ///
    levels(99.9 99 95)                   ///
    legend(order(1 "99.9" 2 "99" 3 "95") ///
        row(1))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
