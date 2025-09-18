sysuse auto, clear
gen mpp = mpg/8
label variable mpp "Miles per pint"
mlogit rep78 mpp foreign if rep>=3
estimates store mlogit
forvalues i = 3/5 {
    quietly margins, dydx(*)          ///
           predict(outcome(`i')) post
    estimates store ame`i'
    quietly estimates restore mlogit
}
coefplot mlogit, keep(*:) drop(_cons) omitted bylabel(Log Odds)         ///
      || (ame3, aseq(3) \ ame4, aseq(4) \ ame5, aseq(5)), bylabel(AME)  ///
      ||, xline(0) byopts(xrescale)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
