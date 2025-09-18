sysuse auto, clear
logit foreign mpg trunk length turn
coefplot, drop(_cons) xline(0)           ///
    xtitle(Log odds)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

