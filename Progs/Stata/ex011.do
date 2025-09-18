margins, dydx(*)
marginsplot, horizontal xline(0)         ///
    yscale(reverse) recast(scatter)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace


