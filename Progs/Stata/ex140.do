sysuse auto, clear
regress price mpg trunk length turn
estimates store multivariate
foreach var in mpg trunk length turn {
    quietly regress price `var'
    estimates store `var'
}
coefplot (mpg \ trunk \ length \ turn,   ///
    label(bivariate)) (multivariate)     ///
    , drop(_cons) xline(0)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

