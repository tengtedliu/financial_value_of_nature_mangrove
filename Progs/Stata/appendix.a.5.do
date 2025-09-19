// Estimate Table A.4: Effect of Mangroves on Prices by Flood Risk
	***the linear combination results are used for Figure A.4 Mangroves and Price, by Flood Risk Zone

use ./Analysis/Data/workfile.dta, clear



***create flood map variables 
	*low to high risk
cap gen high_floodrisk = (fld_zone=="AE" | fld_zone=="VE")
cap gen mid_floodrisk = (fld_zone !="AE" & zone_subty!="AREA OF MINIMAL FLOOD HAZARD" & fld_zone !="VE")
cap gen low_floodrisk = (zone_subty=="AREA OF MINIMAL FLOOD HAZARD")



global HM      hurbeforemang  huryearmang huraftermang


eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & low_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
// *============================*
// * Linear combination LOW FLOOD RISK
// *============================*
	lincom huryearmang 
	lincom huryearmang*2
	lincom huryearmang*4 

	lincom huraftermang
	lincom huraftermang*2
	lincom huraftermang*4

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
// *============================*
// * Linear combination MID FLOOD RISK
// *============================*
	lincom huryearmang 
	lincom huryearmang*2
	lincom huryearmang*4 

	lincom huraftermang
	lincom huraftermang*2
	lincom huraftermang*4

eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & high_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
// *============================*
// * Linear combination HIGH FLOOD RISK
// *============================*
	lincom huryearmang 
	lincom huryearmang*2
	lincom huryearmang*4 

	lincom huraftermang
	lincom huraftermang*2
	lincom huraftermang*4


***run the regressions to export to latex tables
eststo clear
eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & low_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & high_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


esttab using main_floodrisk.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)



log close
