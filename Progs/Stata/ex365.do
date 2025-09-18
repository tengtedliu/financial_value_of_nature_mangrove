regress price mpg trunk length turn,     ///
    vce(bootstrap)
coefplot                                 ///
    (, ci(ci_normal) label(normal))      ///
    (, ci(ci_percentile) label(percent)) ///
    (, ci(ci_bc) label(bc))              ///
    , drop(_cons) xline(0) legend(row(1))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
