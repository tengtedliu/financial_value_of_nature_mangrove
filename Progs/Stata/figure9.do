// this do file estimates the width effect of mangroves; used for graphing Figure 9 Effect of Mangroves Distance and Width on Sale Price, Medium Risk Areas


use workfile, clear


**merge with width data
capture drop _merge

merge m:1 propertyaddresslatitude propertyaddresslongitude ///
using mangrovewidth_080823.dta
keep if _merge==3

** create interaction variables between hurricanes and width
* using inverse mangrove width so that it moves in the same direction as distance group (bigger inverse width means smaller width)
capture gen inv_mang_thickness= 1/(1+mangrove_width_meters)
gen mang_wid_inv= inv_mang_thickness

cap gen hurbeforewid_inv= hurbefore*mang_wid_inv
cap gen huryearwid_inv= huryear*mang_wid_inv
cap gen hurafterwid_inv= hurafter*mang_wid_inv


cap gen hurbeforemangwid_inv = hurbefore*mang_wid_inv*mdistancegroup
cap gen huryearmangwid_inv = huryear*mang_wid_inv*mdistancegroup
cap gen huraftermangwid_inv = hurafter*mang_wid_inv*mdistancegroup


***************estimation

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath

eststo clear
				
eststo: xi: reghdfe salespriceamount_log hurbeforemang  huryearmang huraftermang ///
	hurbeforewid_inv huryearwid_inv hurafterwid_inv ///
	hurbeforemangwid_inv huryearmangwid_inv huraftermangwid_inv ///
	if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


**linear combinations: holding distance constant, what is the effect of width
estadd local fe Yes
estadd local tfe Yes
xlincom (10m = huraftermangwid_inv*(1/(1+10))) ///
		(20m = huraftermangwid_inv*(1/(1+20))) ///
		(30m = huraftermangwid_inv*(1/(1+30))) ///
		(70m = huraftermangwid_inv*(1/(1+70))) ///
		(150m = huraftermangwid_inv*(1/(1+150))), post
est store hurricaneswidth

esttab hurricaneswidth using table_width_inv_newbenchmark.tex, b(2) se(2) ar2(2) label stats(r2 N fe tfe, fmt(%9.2f %9.0g) labels("R-squared" "N" "Property FE" "Year-Month FE")) replace
