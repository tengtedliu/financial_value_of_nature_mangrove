coefplot D F, bylabel(A)                 ///
    || wD wF, bylabel(B)                 ///
    ||, drop(_cons) xline(0)             ///
      norecycle byopts(xrescale)         ///
      legend(rows(1))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
