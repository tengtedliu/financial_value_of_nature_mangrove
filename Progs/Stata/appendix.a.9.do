***Robustness check: include belief data in the benchmark regressions

use workfile, clear

******merge with county belief data
cap drop _merge
merge m:1 fips year using ycm_beliefs_merged_wide_FL.dta

**use the variable `personal' (Personal Damage from Climate Change)


g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath



eststo clear
eststo: xi: reghdfe salespriceamount_log hurbeforemang personal  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang personal if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang personal if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_log $HM  personal  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


eststo: xi: reghdfe salespriceamount_log $HM personal c.yr#c.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_belief.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  




