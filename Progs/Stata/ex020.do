// Graph A
sysuse auto, clear
regress price mpg trunk length turn if foreign==0
estimates store D
regress price mpg trunk length turn turn if for==1
estimates store F
regress weight mpg trunk length turn if foreign==0
estimates store wD
regress weight mpg trunk length turn if foreign==1
estimates store wF
coefplot                                 ///
    (D, label(Domestic))                 ///
    (F, label(Foreign)), bylabel(Price)  ///
    || wD wF, bylabel(Weight)            ///
    ||, drop(_cons) xline(0)             ///
        byopts(xrescale ti(A, pos(10))) ///
        name(a, replace) nodraw

// Graph B
sysuse auto, clear
regress price mpg headroom weight turn 
estimates store Total
regress price mpg headroom weight turn if foreign==0
estimates store Domestic
regress price mpg headroom weight turn if foreign==1
estimates store Foreign
coefplot Domestic || Foreign || Total, drop(_cons) yline(0) vertical ///
    bycoefs byopts(yrescale ti(B, pos(10))) ///
    group(1 2 = "Subgroup results", nogap) ylabel(0, add) ///
        name(b, replace) nodraw

// Graph C
sysuse auto, clear
regress price mpg trunk length turn
coefplot, drop(_cons) xline(0) cismooth grid(none) ///
    ti(C, pos(10)) name(c, replace) nodraw

// Graph D
sysuse auto, clear
keep if rep78>=3
regress mpg headroom i.rep##i.foreign
mata: st_matrix("e(box)",                ///
    (st_matrix("e(b)") :- 2 \            ///
     st_matrix("e(b)") :+ 2))
coefplot, xline(0) mlabel format(%9.2g)  ///
    mlabposition(0) msymbol(i)           ///
    ci(95 box) ciopts(recast(. rbar)     ///
        barwidth(. 0.35) fcolor(. white) ///
        lwidth(. medium)) ///
    coefl(, wrap(17)) ///
    ti(D, pos(10)) name(d, replace) nodraw

// Graph e
sysuse auto, clear
proportion rep if foreign==0
estimates store domestic
proportion rep if foreign==1
estimates store foreign
coefplot domestic foreign,        ///
    vertical recast(bar)          ///
    barwidth(0.25) fcolor(*.5)    ///
    ciopts(recast(rcap)) citop    ///
    xtitle(Repair Record 1978)    ///
    ytitle(Proportion) citype(logit) ///
    ti(E, pos(10)) name(e, replace) nodraw
    
// Graph F
sysuse auto, clear
logit foreign mpg
qui margins, at(mpg=(10(2)40)) post
estimates store bivariate
logit foreign mpg turn price
qui margins, at(mpg=(10(2)40)) post
estimates store multivariate
coefplot (bivariate) (multivariate), at  ///
    ytitle(Pr(foreign=1))                ///
    xtitle(Miles per Gallon)             ///
    recast(line) lwidth(*2)              ///
    ciopts(recast(rline)) ///
    ti(F, pos(10)) name(f, replace) nodraw

// put graph together
graph combine a b c d e f, cols(2) altshrink graphr(margin(zero)) ysize(4.5)

global grname ${TeXdoc_stprefix}overview
graph export ${grname}.pdf, replace

