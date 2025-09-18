coefplot, xline(0) omitted base          ///
    groups(?.rep78 =                     ///
        `""{bf:Repair}" "{bf:Record}""'  ///
    ?.foreign = "{bf:Car Type}"          ///
    ?.rep78#?.foreign =                  ///
        "{bf:Interaction Effects}")      ///
    drop(_cons)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
