sysuse auto, clear
regress price mpg trunk length turn
coefplot, drop(_cons) xline(0)           ///
    ciopts(recast(rcap))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
