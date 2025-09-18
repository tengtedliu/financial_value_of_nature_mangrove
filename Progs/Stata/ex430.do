sysuse auto, clear
proportion rep if foreign==0
estimates store domestic
proportion rep if foreign==1
estimates store foreign
coefplot domestic foreign,        ///
    vertical recast(bar)          ///
    barwidth(0.25) fcolor(*.5)    ///
    ciopts(recast(rcap)) citop    ///
    citype(logit)                 ///
    xtitle(Repair Record 1978) ytitle(Proportion)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

