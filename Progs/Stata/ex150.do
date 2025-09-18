sysuse auto, clear
foreach v of var price mpg trunk length  ///
    turn {
    quietly summarize `v'
    quietly replace `v' =             ///
           (`v' - r(mean)) / r(sd)
}
regress price mpg trunk length turn
estimate store regress
tobit price mpg trunk length turn,       ///
    ll(-.5)
estimate store tobit
coefplot regress tobit, xline(0)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
