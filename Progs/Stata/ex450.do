sysuse auto, clear
keep if rep78>=3
regress mpg headroom i.rep##i.foreign
coefplot, xline(0) omitted baselevels    ///
    headings(                            ///
    3.rep78 = "{bf:Repair Record}"       ///
    0.foreign = "{bf:Car Type}"          ///
    3.rep78#0.foreign =                  ///
        "{bf:Interaction Effects}")      ///
    drop(_cons) yscale(alt)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
