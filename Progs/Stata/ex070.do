sysuse auto, clear
regress price mpg trunk length turn      ///
    if foreign==0
estimates store D
regress price mpg trunk length turn      ///
    if foreign==1
estimates store F
coefplot D F, drop(_cons) xline(0)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

