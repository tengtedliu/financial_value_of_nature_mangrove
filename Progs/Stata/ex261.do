coefplot, xline(0) coeflabel(, wrap(20))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
