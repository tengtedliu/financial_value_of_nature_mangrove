regress weight mpg trunk length turn     ///
    if foreign==0
estimates store wD
regress weight mpg trunk length turn     ///
    if foreign==1
estimates store wF
coefplot                                 ///
    (D, label(Domestic))                 ///
    (F, label(Foreign)), bylabel(Price)  ///
    || wD wF, bylabel(Weight)            ///
    ||, drop(_cons) xline(0)             ///
        byopts(xrescale)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
