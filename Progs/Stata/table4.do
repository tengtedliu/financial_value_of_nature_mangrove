
*------------------------------------------------------------*
****Table 4: Effect of Mangroves on Price Dispersion after Hurricanes
*------------------------------------------------------------*

use ./Analysis/Data/workfilecol_med, clear


global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 


eststo clear
eststo: reghdfe salesprice2  mdistancegroup  $HM    , absorb(year#month  ) vce(cluster  year#month) 
estadd local pfe No
eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month  ) vce(cluster  year#month) 
estadd local pfe No
eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month) 
estadd local pfe YES
eststo: reghdfe salesprice2  mdistancegroup  $HM  $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month) 
estadd local pfe YES
eststo: reghdfe salesprice2  mdistancegroup  $HMP  $HMOP   $CONTROLS , absorb(year#month propertyzip) vce(cluster  year#month) 
estadd local pfe YES

esttab using agg_no_distance_delta_i.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace


