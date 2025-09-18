sysuse auto, clear
keep if rep78>=3
regress mpg headroom i.rep##i.foreign
mata: st_matrix("e(box)",                ///
    (st_matrix("e(b)") :- 2 \            ///
     st_matrix("e(b)") :+ 2))
coefplot, xline(0) mlabel format(%9.2g)  ///
    mlabposition(0) msymbol(i)           ///
    ci(95 box) ciopts(recast(. rbar)     ///
        barwidth(. 0.35) fcolor(. white) ///
        lwidth(. medium))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
