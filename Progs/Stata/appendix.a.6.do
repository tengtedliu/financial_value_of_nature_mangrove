// ****This file estimates results for Appendix A.7 Robustness test tables and analysis disaggregated, by hurricanes and years


************ Main **************.
use ./Analysis/Data/workfile, clear


***flood zone dummy
// cap gen floodzone = 1 if coastline_distance_km <2 & elevation_meters <0.9
// cap replace floodzone = 0 if floodzone==.


***create interactions beteween hurricane1bmang hurricane2bmang and with hurricane_path
// g hurricane2amang = hurricane1after * mdistancegroup
// g hurricane3amang = hurricane2after * mdistancegroup

// gen hurricane1bmang = hurricane1before * mdistancegroup
// gen hurricane2bmang = hurricane2before * mdistancegroup
// gen hurricane3bmang = hurricane3before * mdistancegroup

// g hurricane1bmangpath = hurricane1bmang * hurricane_path 
// g hurricane2bmangpath = hurricane2bmang * hurricane_path
// g hurricane1afterpath = huryearmang * hurricane_path
// g hurricane2afterpath = hurricane2amang * hurricane_path
// g hurricane3afterpath = hurricane3amang * hurricane_path
//
// g hurricane1bmangoffpath = hurricane1bmang -  hurricane1bmangpath
// g hurricane2bmangoffpath = hurricane2bmang -  hurricane2bmangpath
// g hurricane1afteroffpath = huryearmang -  hurricane1afterpath
// g hurricane2afteroffpath = hurricane2amang -  hurricane2afterpath
// g hurricane3afteroffpath = hurricane3amang -  hurricane3afterpath
//
//
// global HMeach hurricane2bmang hurricane1bmang  huryearmang hurricane2amang hurricane3amang
// global HMPeach hurricane2bmangpath hurricane1bmangpath  hurricane1afterpath hurricane2afterpath hurricane3afterpath
// global HMOPeach hurricane2bmangoffpath hurricane1bmangoffpath hurricane1afteroffpath hurricane2afteroffpath hurricane3afteroffpath


****Table A.4: Effect of Mangroves on Prices after Hurricanes by Year
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
// eststo: xi: reghdfe salespriceamount_log hurricane2bmang hurricane1bmang  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)
// eststo: xi: reghdfe salespriceamount_log huryearmang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)
// eststo: xi: reghdfe salespriceamount_log  hurricane2amang hurricane3amang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)
// eststo: xi: reghdfe salespriceamount_log $HMeach  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)
// esttab using main_seperateyears.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  
eststo: xi: reghdfe salespriceamount_log ivanbeforemang sandybeforemang irmabeforemang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log ivan1yearmang sandy1yearmang irma1yearmang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log ivanaftermang sandyaftermang irmaaftermang if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HMIVAN $HMSANDY $HMIRMA if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main_seperatehurricane.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)


****Table A.5: Effect of Mangroves on Prices after Hurricanes: hurricane path effects by year
// replace hurricane_path = 1 if inlist(fips, 12057, 12021, 12011, 12086) & (ivan1before == 1 | ivan2before == 1)	
// replace hurricane_path = 1 if inlist(fips, 12057, 12021, 12015, 12071) & (irma1before == 1 | irma2before == 1) 
// g hurricane1bmangpath = hurricane1bmang * hurricane_path 
// g hurricane2bmangpath = hurricane2bmang * hurricane_path
// g hurricane1afterpath = huryearmang * hurricane_path
// g hurricane2afterpath = hurricane2amang * hurricane_path
// g hurricane3afterpath = hurricane3amang * hurricane_path

// g hurricane1bmangoffpath = hurricane1bmang -  hurricane1bmangpath
// g hurricane2bmangoffpath = hurricane2bmang -  hurricane2bmangpath
// g hurricane1afteroffpath = huryearmang -  hurricane1afterpath
// g hurricane2afteroffpath = hurricane2amang -  hurricane2afterpath
// g hurricane3afteroffpath = hurricane3amang -  hurricane3afterpath

g hurricane_path_ivan = 0
g hurricane_path_irma = 0
replace hurricane_path_ivan = 1 if inlist(fips, 12057, 12021, 12011, 12086) & (ivan1before == 1 | ivan2before == 1)	
replace hurricane_path_irma = 1 if inlist(fips, 12057, 12021, 12015, 12071) & (irma1before == 1 | irma2before == 1) 

**generate interaction variables with path
g ivan1yearmangpath = ivan1yearmang * hurricane_path_ivan
g ivanaftermangpath = ivanaftermang * hurricane_path_ivan

g irma1yearmangpath = irma1yearmang * hurricane_path_irma
g irmaaftermangpath = irmaaftermang * hurricane_path_irma

g ivan1yearmangoffpath = ivan1yearmang - ivan1yearmangpath
g ivanaftermangoffpath = ivanaftermang - ivanaftermangpath

g irma1yearmangoffpath = irma1yearmang - irma1yearmangpath
g irmaaftermangoffpath = irmaaftermang - irmaaftermangpath

global hurricanepaths ivan1yearmangpath  ivan1yearmangoffpath sandy1yearmang irma1yearmangpath /// 
irma1yearmangoffpath ivanaftermangpath ///
ivanaftermangoffpath sandyaftermang irmaaftermangpath irmaaftermangoffpath

eststo clear
// eststo: reghdfe salespriceamount_log hurricane2bmangpath hurricane2bmangoffpath hurricane1bmangpath hurricane1bmangoffpath if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log ivan1yearmangpath  ivan1yearmangoffpath sandy1yearmang irma1yearmangpath irma1yearmangoffpath if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)
eststo: reghdfe salespriceamount_log ivanaftermangpath ivanaftermangoffpath sandyaftermang irmaaftermangpath irmaaftermangoffpath if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)
eststo: reghdfe salespriceamount_log $hurricanepaths   if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster year#month)

esttab using path_seperatehurricane.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)




// eststo: reghdfe salespriceamount_log hurricane1afterpath hurricane1afteroffpath if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)

// eststo: reghdfe salespriceamount_log hurricane2afterpath hurricane2afteroffpath if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)

// eststo: reghdfe salespriceamount_log hurricane3afterpath  hurricane3afteroffpath if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)

// eststo: reghdfe salespriceamount_log hurricane2bmangpath hurricane2bmangoffpath hurricane1bmangpath hurricane1bmangoffpath ///
// hurricane1afterpath hurricane1afteroffpath hurricane2afterpath hurricane2afteroffpath hurricane3afterpath  hurricane3afteroffpath ///
//  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month)

// esttab using path_seperateyears.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  





***Table A.6: Level Effect of Mangroves on Price per Square Foot, by hurricane and year
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




***Table A.8: Effect of Mangroves on Prices after Hurricanes at ZIP code level
***Table A.9: Effect of Mangroves on Prices after Hurricanes: hurricane path effects at ZIP code level

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


eststo clear
eststo: reghdfe salespriceamount_log_mean   mdistancegroup  hurbeforemangpath hurbeforemangoffpath huryearmangpath huryearmangoffpath huraftermangpath huraftermangoffpath $CONTROLS ,  absorb(year#month propertyzip) vce(cluster  year#month) 
eststo: reghdfe salespriceamount_log   mdistancegroup  hurbeforemangpath hurbeforemangoffpath huryearmangpath huryearmangoffpath huraftermangpath huraftermangoffpath $CONTROLS ,  absorb(year#month propertyzip) vce(cluster  year#month) 

esttab using agg_level_nodistance_delta_i_part2.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  


***Table A.10: Effect of Mangroves on Prices after Hurricanes: Weighted Regression
***Table A.11: Effect of Mangroves on Prices after Hurricanes by Hurricane Path: Weighted Regression
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


eststo clear
eststo: reghdfe salespriceamount_log hurbeforemangpath ///
    hurbeforemangoffpath [aweight=saleweight]  if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log huryearmangpath huryearmangoffpath ///
    [aweight=saleweight] if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log huraftermangpath huraftermangoffpath ///
    [aweight=saleweight] if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)

eststo: reghdfe salespriceamount_log $HMP  $HMOP   ///
    [aweight=saleweight] if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster year#month)

esttab using path_weights.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  



***Table A.12: Effect of Mangroves on Prices after Hurricanes: hurricane main and path effects, excluding Lehmann Crisis
use ./Analysis/Data/workfile, clear


cap g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath

** Drop Lehmann years or Sandy years from on/off path (all off path)

g lehmann = 0
replace lehmann = 1 if year==2007
replace lehmann = 1 if year==2008
replace lehmann = 1 if year==2009


eststo clear
eststo: reghdfe salespriceamount_log $HM    if salescount <= 22  & lehmann==0 & mid_floodrisk ==1, absorb(houseid month#year) vce(cluster  year#month) 
eststo: reghdfe salespriceamount_log $HMP  $HMOP   if salescount <= 22  & lehmann==0 & mid_floodrisk ==1, absorb(houseid month#year) vce(cluster  year#month)

replace hurbeforemangoffpath=0  if sandy_month>=-36 & sandy_month<=36
replace huryearmangoffpath =0  if sandy_month>=-36 & sandy_month<=36
replace huraftermangoffpath=0  if sandy_month>=-36 & sandy_month<=36

eststo: reghdfe salespriceamount_log $HMP  $HMOP   if salescount <= 22   & mid_floodrisk ==1, absorb(houseid month#year) vce(cluster  year#month)
esttab using nolehmannsandy.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  


