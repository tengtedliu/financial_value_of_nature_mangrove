coefplot, omitted keep(*:)               ///
    coeflabels(mpp = "Mileage")           ///
    eqlabels("{bf:Equation 1}"           ///
        "{bf:Equation 2}"                ///
        "{bf:Equation 3}", asheadings)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
