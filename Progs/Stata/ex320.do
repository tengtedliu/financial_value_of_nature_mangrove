sysuse auto, clear
regress price mpg length
estimate store m1
regress price mpg trunk turn
estimate store m2
regress price mpg trunk length turn
estimate store m3
coefplot m1 || m2 || m3, xline(0)        ///
    drop(_cons) byopts(row(1)) order(mpg trunk length)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace

