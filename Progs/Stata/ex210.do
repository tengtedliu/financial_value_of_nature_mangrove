set seed 73232
drop _all
matrix C = (  1, .5,  0 \ .5,  1, .3     ///
           \  0, .3,  1 )
drawnorm x1 x2 x3, n(10000) corr(C)
generate y = 1 + x1 + x2 + x3 +          ///
            5 * invnorm(uniform())
regress y x1 x2 x3
estimates store m1
generate x1err = x1 +                    ///
            2 * invnorm(uniform())
regress y x1err x2 x3
estimates store m2
coefplot (m1, label(Without error)) (m2, label(With error)),            ///
    xline(1) rename(x1err = x1)
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
