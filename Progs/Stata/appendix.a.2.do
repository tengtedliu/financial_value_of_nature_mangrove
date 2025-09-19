

// Appendix A.2 Descriptive Results


*------------------------------------------------------------*
****Figure A.3: Figure A.3: Bin scatterplot of Housing Price per Square Foot and Mangroves Distance
*------------------------------------------------------------*
use ./Analysis/Data/workfile.dta, clear
// use ../../Data/workfile.dta, clear

**create bin scatterplot of price per square foot and mangrove distance, controling for hpi
// ssc install binscatter
gen salespriceamount_sqt_dollar = salespriceamount/buildingareasqft

capture drop _merge
merge m:1 year month using "../../Data/hpi.dta"

global CONTROLS hpi_level 



binscatter salespriceamount_sqt_dollar mangrove, controls($CONTROLS) ///
    title("") ///
    xtitle("Mangrove Distance (km)") ///
    ytitle("Price per Square Foot (USD)") ///
    lcolor(black) ///
    mcolor(dkgreen) ///
    saving("../../Results/Figures/binscatter_price_mangrove.gph", replace)

* Export to PNG

graph export "../../Results/Figures/binscatter_price_mangrove.png", replace width(2000)




*------------------------------------------------------------*
****Table A.1: Transactions and Unique Properties by Distance-to-Mangroves Bin and Hurricane Window
*------------------------------------------------------------*

global HM      hurbeforemang  huryearmang huraftermang


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


bysort houseid mdistancegroup hurperiod: gen byte tag = (_n==1 & esamp==1)

preserve
collapse (count) N_sales = salespriceamount_log ///
         (sum)   N_props = tag ///
         if esamp==1, by(mdistancegroup hurperiod)
	
export excel using "composition_check.xlsx", firstrow(variables) replace


restore