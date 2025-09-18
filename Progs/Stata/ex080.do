coefplot (D, label(Domestic Cars)        ///
             pstyle(p3))                 ///
         (F, label(Foreign Cars)         ///
             pstyle(p4))                 ///
    , msymbol(S) drop(_cons) xline(0)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

