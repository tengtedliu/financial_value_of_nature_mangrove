// ****This file estimates results for Appendix A.6 
***note: the code file for Figure A.5 ensitivity of willingness to pay calculations to the loss threshold and CRRA parameter
        ***is in a seperate python file figure10.ipynb



*------------------------------------------------------------*
****Table A.5: Effect of Mangroves on Prices after Hurricanes by Individual Hurricane
*------------------------------------------------------------*
************ Load data file **************
use ./Analysis/Data/workfile, clear

**aggreate major hurricane events 
* 2 years before individual hurricanes
g sandybefore = (sandy1before ==1 |  sandy2before ==1  ) 
g irmabefore = (irma1before ==1 |  irma2before ==1  ) 
g ivanbefore = (ivan1before ==1 |  ivan2before ==1  )

* 1 year after individual hurricanes
g sandy1year = sandy0after 
g irma1year = irma0after 
g ivan1year = ivan0after 

* 2 years after individual hurricanes
g sandyafter = (sandy1after ==1 | sandy2after ==1)
g irmaafter = (irma1after ==1 | irma2after ==1)
g ivanafter = (ivan1after ==1 | ivan2after ==1)

**generate interaction variables
g ivanbeforemang = ivanbefore * mdistancegroup
g sandybeforemang = sandybefore * mdistancegroup
g irmabeforemang = irmabefore * mdistancegroup
g ivan1yearmang = ivan1year * mdistancegroup
g sandy1yearmang = sandy1year * mdistancegroup
g irma1yearmang = irma1year * mdistancegroup
g ivanaftermang = ivanafter * mdistancegroup
g sandyaftermang = sandyafter * mdistancegroup
g irmaaftermang = irmaafter * mdistancegroup

global HMIVAN ivanbeforemang ivan1yearmang ivanaftermang
global HMSANDY sandybeforemang sandy1yearmang sandyaftermang
global HMIRMA irmabeforemang irma1yearmang irmaaftermang

eststo clear

eststo: xi: reghdfe salespriceamount_log ivanbeforemang sandybeforemang irmabeforemang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log ivan1yearmang sandy1yearmang irma1yearmang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log ivanaftermang sandyaftermang irmaaftermang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HMIVAN $HMSANDY $HMIRMA if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_seperatehurricane.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)






*------------------------------------------------------------*
***Table A.6: Effect of Mangroves on House Sale Prices (per Square Foot) after Hurricanes
*------------------------------------------------------------*
************ Load data file **************
use ./Analysis/Data/workfile, clear

eststo clear
cap g yr = year - 1992

cap drop salespriceamount_sqt
cap gen salespriceamount_sqt = ((salespriceamount_log)/buildingareasqft)*100
global HM hurbeforemang  huryearmang huraftermang


eststo: xi: reghdfe salespriceamount_sqt hurbeforemang    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_sqt huryearmang  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_sqt huraftermang   if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_sqt $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_sqt $HM  c.yr#c.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_sqt.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)



*------------------------------------------------------------*
***Table A.7: Effect of Mangroves on Prices after Hurricanes at ZIP code level
*------------------------------------------------------------*
use ./Analysis/Data/workfilecol_med, clear
eststo clear

cap g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath

global CONTROLS coastline_distance_km elevation_meters age buildingareasqft familyresid condo 

eststo clear
eststo: reghdfe salespriceamount_log_mean  mdistancegroup  $HM  $CONTROLS ,  absorb(year#month propertyzip) vce(cluster  year#month) 
eststo: reghdfe salespriceamount_log   mdistancegroup  $HM  $CONTROLS ,  absorb(year#month propertyzip) vce(cluster  year#month) 
esttab using agg_level_nodistance_delta_i_part1.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  
 

*------------------------------------------------------------*
***Table A.8: Effect of Mangroves on Prices after Hurricanes: Weighted Regression
*------------------------------------------------------------*
use ./Analysis/Data/workfile, clear
eststo clear


cap g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


eststo clear
eststo: xi: reghdfe salespriceamount_log hurbeforemang [aweight=saleweight]  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang [aweight=saleweight] if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang [aweight=saleweight] if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_log $HM  [aweight=saleweight]  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


eststo: xi: reghdfe salespriceamount_log $HM c.yr#c.mdistancegroup  [aweight=saleweight] if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_weights.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  


*------------------------------------------------------------*
***Table A.9: Effect of Mangroves on Prices after Hurricanes: hurricane main and path effects, excluding Lehmann Crisis
*------------------------------------------------------------*

use ./Analysis/Data/workfile, clear


cap g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath

** Drop Lehmann years

g lehmann = 0
replace lehmann = 1 if year==2007
replace lehmann = 1 if year==2008
replace lehmann = 1 if year==2009


eststo clear
eststo: reghdfe salespriceamount_log $HM    if salescount <= 22  & lehmann==0 & mid_floodrisk ==1, absorb(houseid month#year) vce(cluster  year#month) 
eststo: reghdfe salespriceamount_log $HMP  $HMOP   if salescount <= 22  & lehmann==0 & mid_floodrisk ==1, absorb(houseid month#year) vce(cluster  year#month)

esttab using nolehmannsandy.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  











*------------------------------------------------------------*
***Table A.10: Effect of Mangroves on Prices after Hurricanes, Controlling for Insurance Coverage
*------------------------------------------------------------*
use ./Analysis/Data/workfile, clear


******merge with insurance data can merge with property dataset by hurricane and zipcode
cap drop _merge

merge m:1 propertyzip year using ./Analysis/Data/aggregated_claims_by_zip.dta

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


eststo clear
eststo: xi: reghdfe salespriceamount_log hurbeforemang lag_buildinginsurancecoverage  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang lag_buildinginsurancecoverage if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang lag_buildinginsurancecoverage if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_log $HM  lag_buildinginsurancecoverage  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


eststo: xi: reghdfe salespriceamount_log $HM lag_buildinginsurancecoverage c.yr#c.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_insurance_coverage.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  



*------------------------------------------------------------*
***Table A.11: Effect of Mangroves on Prices after Hurricanes, Controlling for Climate Belief
*------------------------------------------------------------*

use ./Analysis/Data/workfile, clear


******merge with county belief data
cap drop _merge
merge m:1 fips year using ./Analysis/Data/ycm_beliefs_merged_wide_FL.dta

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




*------------------------------------------------------------*
***Table A.12: Effect of Mangroves on Prices after Hurricanes, Two Way Clustered Standard Errors
*------------------------------------------------------------*


// use ../../Data/workfile.dta, clear
use ./Analysis/Data/workfile, clear

global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 

*****level effect with two way clustering*****
eststo clear
eststo: xi: reghdfe salespriceamount_log mdistancegroup $HM $CONTROLS   if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(county   month#year) vce(cluster year#month county) 

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster year#month propertyaddresscensustractandblo) 

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster year#month propertyzip)

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month fips) 
esttab using main_2wayse.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace


*------------------------------------------------------------*
***Table A.13: Effect of Mangroves on Price Dispersion after Hurricanes, Two Way Clustered Standard Errors
*------------------------------------------------------------*
*****coef of var
// use ../../Data/workfilecol_med.dta, clear
use ./Analysis/Data/workfilecol_med.dta, clear

eststo clear

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 


eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month propertyzip) 

eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month fips) 

esttab using coefvar_2wayse.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace
