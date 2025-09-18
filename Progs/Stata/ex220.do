sysuse auto, clear
matrix res = J(3,3,.)
matrix coln res = median ll95 ul95
matrix rown res = mpg trunk turn 
local i 0
foreach v of var mpg trunk turn {
    local ++ i
    quietly centile `v'
    matrix res[`i',1] = r(c_1),       ///
        r(lb_1), r(ub_1)
}
matrix list res
coefplot matrix(res[.,1]), ci((res[.,2] res[.,3]))
global grname ${TeXdoc_stprefix}`=${TeXdoc_stcounter}-1'
graph export ${grname}.pdf, replace
