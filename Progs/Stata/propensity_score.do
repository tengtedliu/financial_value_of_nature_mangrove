
* import data
use ../../Data/workfile.dta, clear

global CONTROLS coastline_distance_km elevation_meters age buildingareasqft familyresid condo 

**2km, 1km
cap gen treat_2km = (mangrove <= 2)

* Estimate the propensity score
// qui logit treat_2km $CONTROLS i.propertyzip 
qui logit treat_2km $CONTROLS i.fips 
predict pscore


* Checking mean propensity scores for treatment and control groups
su pscore if treat_2km==1, detail
su pscore if treat_2km==0, detail

* Now look at the propensity score distribution for treatment and control groups
histogram pscore, by(treat_2km) binrescale

**match
g att=.
levelsof year, local(years)
qui foreach yr of local years {
	psmatch2 treat_2km if year==`yr', pscore(pscore) neighbor(2) caliper(0.05)
	replace att = r(att) if year==`yr'
}
sum att
// pstest $CONTROLS i.propertyzip, both graph



*****estimation
keep if _weight != .

cap drop _merge
merge m:1 year month using "./Analysis/Data/hpi.dta"


gen hurbeforemang_psp = hurbefore * treat_2km
gen huryearmang_psp = huryear * treat_2km
gen huraftermang_psp = hurafter * treat_2km

eststo: xi: reghdfe salespriceamount_log hurbeforemang_psp hpi if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid month) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huryearmang_psp hpi if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid month) vce(cluster  year#month) 
eststo: xi: reghdfe salespriceamount_log huraftermang_psp hpi if salescount <= 22 & floodzone==0    & mid_floodrisk ==1, absorb(houseid month) vce(cluster  year#month) 






