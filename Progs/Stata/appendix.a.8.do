// This file runs robustness check of baseline results by incorporating insurance coverage data from NFIP


************ Main **************. Note mdist is never zero so don't need main effects with path and no mangrove
use workfile, clear


******merge with insurance data can merge with property dataset by hurricane and zipcode
cap drop _merge
// merge m:1 propertyzip year using "/Users/ted/Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/aggregated_claims_by_zip.dta"
merge m:1 propertyzip year using aggregated_claims_by_zip.dta

// Note: we are controling for zipcode level insurance; calulate average using num_claims using a loop of the variables above
foreach var in amountpaidonbuildingclaim amountpaidoncontentsclaim ///
	totalbuildinginsurancecoverage totalcontentsinsurancecoverage ///
	buildingdamageamount netbuildingpaymentamount buildingpropertyvalue {
	replace `var' = `var' / num_claims if num_claims > 0
}

// calulate average using num_claims using a loop of the variables for lagged variables
foreach var in lag_amountpaidonbuildingclaim lag_amountpaidoncontentsclaim ///
	lag_buildinginsurancecoverage lag_contentsinsurancecoverage ///
	lag_buildingdamageamount lag_buildingpaymentamount lag_buildingpropertyvalue {
	replace `var' = `var' / lag_num_claims if lag_num_claims > 0
}

// replace those with missing insurance data with zero, do this also for lagged variables
foreach var in amountpaidonbuildingclaim amountpaidoncontentsclaim ///
	totalbuildinginsurancecoverage totalcontentsinsurancecoverage ///
	buildingdamageamount netbuildingpaymentamount buildingpropertyvalue ///
	lag_amountpaidonbuildingclaim lag_amountpaidoncontentsclaim ///
	lag_buildinginsurancecoverage lag_contentsinsurancecoverage ///
	lag_buildingdamageamount lag_buildingpaymentamount lag_buildingpropertyvalue {
	replace `var' = 0 if `var' == .
}


g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


****add insurance coverage to Table 1
eststo clear
eststo: xi: reghdfe salespriceamount_log hurbeforemang lag_buildinginsurancecoverage  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang lag_buildinginsurancecoverage if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang lag_buildinginsurancecoverage if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_log $HM  lag_buildinginsurancecoverage  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


eststo: xi: reghdfe salespriceamount_log $HM lag_buildinginsurancecoverage c.yr#c.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_insurance_coverage.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  


****add insurance coverage to Table 2 (on and off path)
eststo clear
eststo: reghdfe salespriceamount_log hurbeforemangpath c.hurbeforemangpath#c.lag_buildinginsurancecoverage ///
    hurbeforemangoffpath lag_buildinginsurancecoverage  if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log huryearmangpath  c.huryearmangpath#c.lag_buildinginsurancecoverage huryearmangoffpath ///
    lag_buildinginsurancecoverage if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log huraftermangpath  c.huraftermangpath#c.lag_buildinginsurancecoverage huraftermangoffpath ///
    lag_buildinginsurancecoverage if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log $HMP  $HMOP   ///
    c.hurbeforemangpath#c.lag_buildinginsurancecoverage c.huryearmangpath#c.lag_buildinginsurancecoverage c.huraftermangpath#c.lag_buildinginsurancecoverage ///
    lag_buildinginsurancecoverage if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster year#month)


esttab using path_insurance_coverage.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace