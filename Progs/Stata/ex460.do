coefplot, xline(0) omitted base          ///
    groups(?.rep78 =                     ///
        `""{bf:Repair}" "{bf:Record}""'  ///
    ?.foreign = "{bf:Car Type}"          ///
    ?.rep78#?.foreign =                  ///
        "{bf:Interaction Effects}",      ///
        angle(rvertical))                ///
    drop(_cons) yscale(alt axis(2))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
