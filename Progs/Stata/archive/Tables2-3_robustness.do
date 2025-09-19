

use ../../Data/workfile.dta, clear

*------------------------------------------------------------*
* sale tabulation table
*------------------------------------------------------------*

global HM      hurbeforemang  huryearmang huraftermang
// global HMP     huryearmangpath  huraftermangpath
// global HMOP    huryearmangoffpath  huraftermangoffpath
//
// g hurbeforecoast = hurbefore * coastline_distance_km
// g huraftercoast = hurafter * coastline_distance_km
// g huryearcoast = huryear * coastline_distance_km
//
// g hurbeforemnocoast = hurbefore * mdistance_nocoast
// g huraftermncoast = hurafter * mdistance_nocoast
// g huryearmncoast = huryear * mdistance_nocoast
//
// global HC      hurbeforecoast  huryearcoast huraftercoast
// global HMNC  hurbeforemnocoast huraftermncoast huryearmncoast



eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


gen byte esamp = e(sample)

* Define mutually exclusive hurricane period variable for summary table interpretability

cap drop hurperiod
gen hurperiod = .
replace hurperiod = 1 if hurbefore==1
replace hurperiod = 2 if huryear==1
replace hurperiod = 3 if hurafter==1
replace hurperiod = 4 if hurperiod==.

label define hurperiod_lbl ///
    1 "Years 2-3 (Pre)" ///
    2 "Year 1 (Post)" ///
    3 "Years 2-3 (Post)" ///
    4 "Non-hurricane years"

label values hurperiod hurperiod_lbl



// bysort houseid mdistancegroup hurbefore huryear hurafter: gen byte tag = (_n==1 & esamp==1)
//
// preserve
// collapse (count) N_sales = salespriceamount_log ///
//          (sum)   N_props = tag ///
//          if esamp==1, by(mdistancegroup hurbefore huryear hurafter)

bysort houseid mdistancegroup hurperiod: gen byte tag = (_n==1 & esamp==1)

preserve
collapse (count) N_sales = salespriceamount_log ///
         (sum)   N_props = tag ///
         if esamp==1, by(mdistancegroup hurperiod)
		 
// collapse (count) N_sales = salespriceamount_log ///
//          if esamp==1, by(mdistancegroup huryear hurafter)

* install estout if needed
// ssc install estout	
	
export excel using "composition_check.xlsx", firstrow(variables) replace


restore






*------------------------------------------------------------*
* Additional Robustness Checks: different clustered SEs
*------------------------------------------------------------*
use ../../Data/workfile.dta, clear
global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 

*****level effect with two way clustering*****
eststo clear
eststo: xi: reghdfe salespriceamount_log mdistancegroup $HM $CONTROLS   if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(county   month#year) vce(cluster year#month county) 

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster year#month propertyaddresscensustractandblo) 

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster year#month propertyzip)

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month fips) 
esttab using main_2wayse.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace


*****coef of var
use ../../Data/workfilecol_med.dta, clear

eststo clear

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 


eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month propertyzip) 

eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month fips) 

esttab using coefvar_2wayse.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace





