coefplot, drop(_cons) xline(0)           ///
    cismooth grid(none)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
