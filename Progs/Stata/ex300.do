sysuse auto, clear
gen mpp = mpg/8
mlogit rep78 mpp i.foreign if rep>=3
coefplot, omitted keep(*:)               ///
    coeflabels(mpp = "Mileage")           ///
    eqlabels("Equation 1" "Equation 2"   ///
        "Equation 3")
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
