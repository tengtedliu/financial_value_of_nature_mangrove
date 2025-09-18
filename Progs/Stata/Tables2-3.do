***this do file runs estimations for hurricane level effects on property values***
// Table 2: Effect of Mangroves on House Sale Prices after Hurricanes
// Table 3: Effect of Mangroves on Prices after Hurricanes: Accounting for Hurricane Path


// the commented out section is to generate variables used in the estimation
/*
g irma1before = 0
g irma2before = 0
g ivan1before = 0
g ivan2before = 0
g sandy1before = 0
g sandy2before = 0
g irma3before = 0
g ivan3before = 0
g sandy3before = 0

replace irma1before = 1  if irma_months<0  & irma_months>=-12
replace irma2before = 1  if irma_months<-12 & irma_months>=-24
replace ivan1before = 1  if ivan_months<0  & ivan_months>=-12
replace ivan2before = 1  if ivan_months<-12 & ivan_months>=-24
replace sandy1before = 1 if  sandy_months<0  & sandy_months>=-12
replace sandy2before = 1 if  sandy_months<-12 & sandy_months>=-24
replace irma3before = 1  if irma_months<-25  & irma_months>=-36
replace ivan3before = 1  if ivan_months<-25  & ivan_months>=-36
replace sandy3before = 1 if  sandy_months<-25 & sandy_months>=-36
 
 
cap drop hurricane1b* hurricane2b*
gen hurricane1before = (sandy1before == 1 | irma1before == 1 | ivan1before == 1)
gen hurricane2before = (sandy2before == 1 | irma2before == 1 | ivan2before == 1)

replace hurricane_path = 1 if inlist(fips, 12057, 12021, 12011, 12086) & (ivan1before == 1 | ivan2before == 1)	
replace hurricane_path = 1 if inlist(fips, 12057, 12021, 12015, 12071) & (irma1before == 1 | irma2before == 1) 


cap drop hurricane1b* hurricane2b*
gen hurricane1before = (sandy1before == 1 | irma1before == 1 | ivan1before == 1)
gen hurricane2before = (sandy2before == 1 | irma2before == 1 | ivan2before == 1)
gen hurricane3before = (sandy3before == 1 | irma3before == 1 | ivan3before == 1)

gen hurricane1bmang = hurricane1before * mdistancegroup
gen hurricane2bmang = hurricane2before * mdistancegroup
gen hurricane3bmang = hurricane3before * mdistancegroup


capture drop hurbefore* hurafter* huryear* mangpath  

g hurbefore = (hurricane1before ==1 |  hurricane2before ==1  )  /* making it 3 years does not make much difference */ 
g hurafter = (hurricane1after==1 | hurricane2after==1 )
g huryear = hurricane0after

g hurbeforepath = hurbefore * hurricane_path 
g hurafterpath  = hurafter * hurricane_path
g huryearpath  = huryear * hurricane_path

g mangpath = mdistancegroup * hurricane_path 
 
g hurbeforemang = hurbefore * mdistancegroup
g huraftermang = hurafter * mdistancegroup
g huryearmang = hurricane0mang

g hurbeforemangpath = hurbeforemang * hurricane_path 
g huraftermangpath  = huraftermang * hurricane_path
g huryearmangpath  = huryearmang * hurricane_path
 
g hurbeforemangoffpath = hurbeforemang -  hurbeforemangpath
g huryearmangoffpath = huryearmang - huryearmangpath 
g huraftermangoffpath = huraftermang - huraftermangpath

compress
save workfile, replace  
*/

**** July 2025 ******
use ../../Data/workfile.dta, clear 
* to add real data file later

global HM      hurbeforemang  huryearmang huraftermang
global HMP     huryearmangpath  huraftermangpath
global HMOP    huryearmangoffpath  huraftermangoffpath

g hurbeforecoast = hurbefore * coastline_distance_km
g huraftercoast = hurafter * coastline_distance_km
g huryearcoast = huryear * coastline_distance_km

reg mdistancegroup coastline_distance_km  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1
predict mdistance_nocoast , resid

g hurbeforemnocoast = hurbefore * mdistance_nocoast
g huraftermncoast = hurafter * mdistance_nocoast
g huryearmncoast = huryear * mdistance_nocoast

g huraftercoastpath  = huraftercoast * hurricane_path
g huryearcoastpath  = huryearcoast * hurricane_path
g huryearcoastoffpath = huryearcoast - huryearmangpath 
g huraftercoastoffpath = huraftercoast - huraftermangpath

g huraftermncoastpath  = huraftermncoast * hurricane_path
g huryearmncoastpath  = huryearmncoast * hurricane_path
g huryearmncoastoffpath = huryearmncoast - huryearmangpath 
g huraftermncoastoffpath = huraftermncoast - huraftermangpath

global HC      hurbeforecoast  huryearcoast huraftercoast
global HMNC  hurbeforemnocoast huraftermncoast huryearmncoast
global HCP      huryearcoastpath huraftercoastpath
global HMNCP    huryearmncoastpath huraftermncoastpath
global HCOP    huryearcoastoffpath huraftercoastoffpath
global HMNCOP     huryearmncoastoffpath huraftermncoastoffpath

eststo clear

eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HC $HMNC    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  star(* 0.10 ** 0.05 *** 0.01)


eststo clear
eststo: xi: reghdfe salespriceamount_log $HMP  $HMOP  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HCP $HCOP $HMNCP $HMNCOP  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 


esttab, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  star(* 0.10 ** 0.05 *** 0.01)

************ Main **************. Note mdist is never zero so don't need main effects with path and no mangrove
*  
use ./Analysis/Data/workfile.dta, clear 

g yr = year - 1992

global HM      hurbeforemang  huryearmang huraftermang
global HMP     huryearmangpath  huraftermangpath
global HMOP    huryearmangoffpath  huraftermangoffpath

g hurbeforecoast = hurbefore * coastline_distance_km
g huraftercoast = hurafter * coastline_distance_km
g huryearcoast = huryear * coastline_distance_km

g hurbeforemnocoast = hurbefore * mdistance_nocoast
g huraftermncoast = hurafter * mdistance_nocoast
g huryearmncoast = huryear * mdistance_nocoast

global HC      hurbeforecoast  huryearcoast huraftercoast
global HMNC  hurbeforemnocoast huraftermncoast huryearmncoast

*******Table 1: Effect of Mangroves on House Sale Prices after Hurricanes
eststo clear

eststo: xi: reghdfe salespriceamount_log c.yr#i.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log hurbeforemang    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang   if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

*eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0   & low_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
*eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22  & floodzone==0   & high_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
*eststo: xi: reghdfe salespriceamount_log $HM    if salescount <= 22  & floodzone==0   , absorb(houseid   month#year) vce(cluster  year#month) 

eststo: xi: reghdfe salespriceamount_log $HM  c.yr#c.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log $HM  c.yr#i.mdistancegroup  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid   month#year) vce(cluster  year#month) 

esttab using main.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$")) replace  star(* 0.10 ** 0.05 *** 0.01)


*******Table 2: Effect of Mangroves on Prices after Hurricanes: Accounting for Hurricane Path
eststo clear
*eststo: reghdfe salespriceamount_log hurbeforemangpath hurbeforemangoffpath  if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)
eststo: reghdfe salespriceamount_log huryearmangpath  huryearmangoffpath   if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)
eststo: reghdfe salespriceamount_log huraftermangpath  huraftermangoffpath  if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster  year#month)
eststo: reghdfe salespriceamount_log $HMP  $HMOP   if salescount <= 22 &  mid_floodrisk ==1 , absorb(houseid  month#year) vce(cluster year#month)
esttab using path.tex, b(3) se(3) ar2(2) label stats(r2 N, labels("$R^2$" "Observations")) replace  star(* 0.10 ** 0.05 *** 0.01)




