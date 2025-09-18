sysuse auto, clear
regress price mpg headroom weight turn 
estimates store Total
regress price mpg headroom weight turn   ///
    if foreign==0
estimates store Domestic
regress price mpg headroom weight turn   ///
    if foreign==1
estimates store Foreign
coefplot Domestic || Foreign || Total, drop(_cons) yline(0) vertical ///
    bycoefs byopts(yrescale) ///
    group(1 2 = "Subgroup results", nogap) ylabel(0, add)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

