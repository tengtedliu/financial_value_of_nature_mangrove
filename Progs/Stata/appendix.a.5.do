// Note:
// 1. this file estimates price level effect by flood risk areas at the baseline


// use ./Analysis/Data/workfile.dta, clear
use workfile.dta, clear


log using Main_flood.log, replace

***create flood map variables 
	*low to high risk
cap gen high_floodrisk = (fld_zone=="AE" | fld_zone=="VE")
cap gen mid_floodrisk = (fld_zone !="AE" & zone_subty!="AREA OF MINIMAL FLOOD HAZARD" & fld_zone !="VE")
cap gen low_floodrisk = (zone_subty=="AREA OF MINIMAL FLOOD HAZARD")

**aggreate major hurricane events 
// gen hurricane0after = (sandy0after == 1 | irma0after == 1 | ivan0after == 1)
// label var hurricane0after "Hurricane (1 Year After)"

// gen hurricane1after = (sandy1after == 1 | irma1after == 1 | ivan1after == 1)
// label var hurricane1after "Hurricane (2 Years After)"

// gen hurricane2after = (sandy2after == 1 | irma2after == 1 | ivan2after == 1)
// label var hurricane2after "Hurricane (3 Years After)"

// **generate interaction variables
// gen hurricane0mang = hurricane0after * mdistancegroup
// label var hurricane0mang "Hurricane (1 Year) X Distance to Mangroves"

// gen hurricane1mang = hurricane1after * mdistancegroup
// label var hurricane1mang "Hurricane (2 Years) X Distance to Mangroves"

// gen hurricane2mang = hurricane2after * mdistancegroup
// label var hurricane2mang "Hurricane (3 Years) X Distance to Mangroves"


//flood risk and hurricane
	*high risk
// gen ivan0_high_floodrisk=ivan0after*high_floodrisk
// gen ivan1_high_floodrisk=ivan1after*high_floodrisk
// gen ivan2_high_floodrisk=ivan2after*high_floodrisk

// gen sandy0_high_floodrisk=sandy0after*high_floodrisk
// gen sandy1_high_floodrisk=sandy1after*high_floodrisk
// gen sandy2_high_floodrisk=sandy2after*high_floodrisk

// gen irma0_high_floodrisk=irma0after*high_floodrisk
// gen irma1_high_floodrisk=irma1after*high_floodrisk
// gen irma2_high_floodrisk=irma2after*high_floodrisk



	*medium risk
// gen ivan0_mid_floodrisk=ivan0after*mid_floodrisk
// gen ivan1_mid_floodrisk=ivan1after*mid_floodrisk
// gen ivan2_mid_floodrisk=ivan2after*mid_floodrisk

// gen sandy0_mid_floodrisk=sandy0after*mid_floodrisk
// gen sandy1_mid_floodrisk=sandy1after*mid_floodrisk
// gen sandy2_mid_floodrisk=sandy2after*mid_floodrisk

// gen irma0_mid_floodrisk=irma0after*mid_floodrisk
// gen irma1_mid_floodrisk=irma1after*mid_floodrisk
// gen irma2_mid_floodrisk=irma2after*mid_floodrisk

	
	*low risk
// gen ivan0_low_floodrisk=ivan0after*low_floodrisk
// gen ivan1_low_floodrisk=ivan1after*low_floodrisk
// gen ivan2_low_floodrisk=ivan2after*low_floodrisk

// gen sandy0_low_floodrisk=sandy0after*low_floodrisk
// gen sandy1_low_floodrisk=sandy1after*low_floodrisk
// gen sandy2_low_floodrisk=sandy2after*low_floodrisk

// gen irma0_low_floodrisk=irma0after*low_floodrisk
// gen irma1_low_floodrisk=irma1after*low_floodrisk
// gen irma2_low_floodrisk=irma2after*low_floodrisk


//flood risk and mangrove
// 	*high risk
// gen high_floodrisk_mang = high_floodrisk*mdistancegroup
// 	*medium risk
// gen mid_floodrisk_mang = mid_floodrisk*mdistancegroup
// 	*low risk
// gen low_floodrisk_mang = low_floodrisk*mdistancegroup


//triple interaction of hurricane, mangrove, and flood risk
	*high risk
// gen ivan0_high_floodrisk_mang=ivan0after*high_floodrisk*mdistancegroup
// gen ivan1_high_floodrisk_mang=ivan1after*high_floodrisk*mdistancegroup
// gen ivan2_high_floodrisk_mang=ivan2after*high_floodrisk*mdistancegroup

// gen sandy0_high_floodrisk_mang=sandy0after*high_floodrisk*mdistancegroup
// gen sandy1_high_floodrisk_mang=sandy1after*high_floodrisk*mdistancegroup
// gen sandy2_high_floodrisk_mang=sandy2after*high_floodrisk*mdistancegroup

// gen irma0_high_floodrisk_mang=irma0after*high_floodrisk*mdistancegroup
// gen irma1_high_floodrisk_mang=irma1after*high_floodrisk*mdistancegroup
// gen irma2_high_floodrisk_mang=irma2after*high_floodrisk*mdistancegroup


// 	*medium risk
// gen ivan0_mid_floodrisk_mang=ivan0after*mid_floodrisk*mdistancegroup
// gen ivan1_mid_floodrisk_mang=ivan1after*mid_floodrisk*mdistancegroup
// gen ivan2_mid_floodrisk_mang=ivan2after*mid_floodrisk*mdistancegroup

// gen sandy0_mid_floodrisk_mang=sandy0after*mid_floodrisk*mdistancegroup
// gen sandy1_mid_floodrisk_mang=sandy1after*mid_floodrisk*mdistancegroup
// gen sandy2_mid_floodrisk_mang=sandy2after*mid_floodrisk*mdistancegroup

// gen irma0_mid_floodrisk_mang=irma0after*mid_floodrisk*mdistancegroup
// gen irma1_mid_floodrisk_mang=irma1after*mid_floodrisk*mdistancegroup
// gen irma2_mid_floodrisk_mang=irma2after*mid_floodrisk*mdistancegroup

	
// 	*low risk
// gen ivan0_low_floodrisk_mang=ivan0after*low_floodrisk*mdistancegroup
// gen ivan1_low_floodrisk_mang=ivan1after*low_floodrisk*mdistancegroup
// gen ivan2_low_floodrisk_mang=ivan2after*low_floodrisk*mdistancegroup

// gen sandy0_low_floodrisk_mang=sandy0after*low_floodrisk*mdistancegroup
// gen sandy1_low_floodrisk_mang=sandy1after*low_floodrisk*mdistancegroup
// gen sandy2_low_floodrisk_mang=sandy2after*low_floodrisk*mdistancegroup

// gen irma0_low_floodrisk_mang=irma0after*low_floodrisk*mdistancegroup
// gen irma1_low_floodrisk_mang=irma1after*low_floodrisk*mdistancegroup
// gen irma2_low_floodrisk_mang=irma2after*low_floodrisk*mdistancegroup



cap gen saleweight = 1/salescount

// baseline specification: property FE, time FE, WITH main effect of mangrove AND main effect of hurricanes . 

// Note: mdistancegroup is included here but much of the main mangrove effect is absorbed by the property fixed effects.
***Table A.3: Effect of Mangroves on Prices by Flood Risk
global HM      hurbeforemang  huryearmang huraftermang

		**Option 1: use generalized hurricane

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

log close


***run the regressions to export to latex tables
eststo clear
eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & low_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM if salescount <= 22 & high_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


esttab using main_floodrisk.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)



log close
