sysuse auto, clear
mlogit rep78 headroom gear_ratio foreign ///
    if rep>=3
coefplot, xline(0) keep(*:)              ///
    order(4:foreign 5:foreign            ///
          4:gear* head* 5:gear* head*    ///
          4: 5:)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
