mean mpg trunk turn
estimates store mean
coefplot (matrix(res[,1]), label(median) ///
        ci((res[,2] res[,3])))           ///
    (mean)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
