sysuse auto, clear
logit foreign mpg trunk length turn
margins, dydx(*) post
coefplot, xline(0)                       ///
    xtitle(Average marginal effects)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
