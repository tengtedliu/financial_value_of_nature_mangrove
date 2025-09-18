coefplot, drop(_cons) xline(1) eform     ///
    xtitle(Odds ratio)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

