coefplot (regress, asequation(model))    ///
         (tobit, keep(*:))               ///
         , xline(0)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
