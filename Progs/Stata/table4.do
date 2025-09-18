
***this do file runs estimations for hurricane dispersion effects on property values***
// Table 4: Effect of Mangroves on Price Dispersion after Hurricanes

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




****** Now do the same for standard deviations - we will need distributions by on/off path which is easy since already by county but different shifts *************
use ./Analysis/Data/workfilecol_med, clear
* to add real data file later


global HM      hurbeforemang  huryearmang huraftermang
global HMP     hurbeforemangpath huryearmangpath  huraftermangpath
global HMOP    hurbeforemangoffpath huryearmangoffpath  huraftermangoffpath


global CONTROLS coastline_distance_km elevation_meters age buildingareasqft BAB BAJ BAL familyresid condo 

* first verify aggregate effects are consistent  

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
* significant increase in variance   
esttab using agg_no_distance_delta_i.tex, b(3) se(3) ar2(2) label stats(pfe  r2 N, labels("Zipcode FE"   "$R^2$" "Observations")) replace


