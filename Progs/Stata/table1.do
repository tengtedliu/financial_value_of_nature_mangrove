*------------------------------------------------------------*
****Table 1: Effect of Mangroves on House Sale Prices after Hurricanes 
*------------------------------------------------------------*
use ./Analysis/Data/workfile, clear


***Level Effect of Mangrove WITHOUT property fixed effects at the property level 
eststo clear
cap g yr = year - 1992

global HM  hurbeforemang  huryearmang huraftermang
global CONTROLS coastline_distance_km elevation_meters age buildingareasqft familyresid condo 
global Hurricane hurbefore hurafter huryear

eststo: xi: reghdfe salespriceamount_log hurbeforemang  mdistancegroup $CONTROLS  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(propertyzip   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang mdistancegroup $CONTROLS if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(propertyzip   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang mdistancegroup $CONTROLS if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(propertyzip   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM  mdistancegroup $CONTROLS  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(propertyzip   month#year) vce(cluster  year#month) 

esttab using main_nopropertyfe.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)
