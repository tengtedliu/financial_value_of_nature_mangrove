coefplot (bivariate) (multivariate), at  ///
    ytitle(Pr(foreign=1))                ///
    xtitle(Miles per Gallon)             ///
    recast(line) lwidth(*2)              ///
    ciopts(recast(rline))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
