  // Creates calibrated price change data, differentiating between path vs non-path properties
  //NOTE: the hurricane path variable includes Ivan/Jeanne, Sandy, and Irma. 
	// 1. All counties in the sample have at least on the path of Ivan/Jeanne or Irma. 
	// 2. But no county was on the path of Sandy---for Sandy, all the results are considered off-path
	// 3. Need to do county by county calculations for on path, depending on the hurricane

	// For reference
	// Assign counties dynamically per hurricane
    // Ivan path: fips, 12057 Hillsborough, 12021 Collier, 12011 Broward, 12086 Miami)
	
	// Irma path: fips, 12057 Hillsborough, 12021 Collier, 12015 Charlotte, 12071 Lee) 

// Step 1: 
cd ./Analysis

use ./Data/workfile.dta, clear

capture drop _merge
merge 1:1 transid using "./Data/flood_map_complete.dta"

capture drop _merge
merge m:1 year month using "./Data/hpi.dta"
order hpi, last
keep if _merge==3

***create flood map variables 
	*low to high risk
cap gen high_floodrisk = (fld_zone=="AE" | fld_zone=="VE")
cap gen mid_floodrisk = (fld_zone !="AE" & zone_subty!="AREA OF MINIMAL FLOOD HAZARD" & fld_zone !="VE")
cap gen low_floodrisk = (zone_subty=="AREA OF MINIMAL FLOOD HAZARD")

keep if mid_floodrisk==1


*identify unique houses
cap egen houseid = group (propertyaddresslatitude propertyaddresslongitude)
cap egen salescount=count(transid), by (houseid)
cap egen houseid_date = group (houseid salesdate)

drop if salescount >22


***hurricane dummies
	*1. Hurricane clusters: Ivan 09/16/2004; Jeanne 09/26/2004
capture g ivandate= mdy(09, 21, 2004)
format ivandate %d
cap gen ivan_days=salesdate - ivandate
cap gen ivan_months=ivan_days/30

cap g ivan0after=1 if ivan_months>=0 & ivan_months<12
replace ivan0after=0 if ivan0after==.

cap g ivan1after=1 if ivan_months>=12 & ivan_months<25
replace ivan1after=0 if ivan1after==.

cap g ivan2after=1 if ivan_months>=25 & ivan_months<38
replace ivan2after=0 if ivan2after==.

	
	* Wilma, 10/24/2005; Charley 08/13/2004; 

	*2. Hurricane Sandy, affected Florida; 10/27/2012, see https://www.weather.gov/mfl/sandy
capture gen sandydate= mdy(10, 27, 2012)
format sandydate %d
cap gen sandy_days=salesdate - sandydate
cap gen sandy_months=sandy_days/30

cap g sandy0after=1 if sandy_months>=0 & sandy_months<12
replace sandy0after=0 if sandy0after==.

cap g sandy1after=1 if sandy_months>=12 & sandy_months<25
replace sandy1after=0 if sandy1after==.

cap g sandy2after=1 if sandy_months>=25 & sandy_months<38
replace sandy2after=0 if sandy2after==.
	
	
	
	*3. Hurricane Irma, landfall in Collier county; 09/10/2017
capture gen irmadate= mdy(9, 10, 2017)
format irmadate %d
cap gen irma_days=salesdate - irmadate
cap gen irma_months=days/30

cap g irma0after=1 if irma_months>=0 & irma_months<12
replace irma0after=0 if irma0after==.

cap g irma1after=1 if irma_months>=12 & irma_months<25
replace irma1after=0 if irma1after==.

cap g irma2after=1 if irma_months>=25 & irma_months<38
replace irma2after=0 if irma2after==.



sort houseid salesdate
order houseid, first


**price per building area square feet
cap gen salesprice_sq = salespriceamount/buildingareasqft


***this next step computes price changes of house sales before and after hurricanes

***only use `buildingareastndcode’ that are building areas
keep if buildingareastndcode== "BAB" | buildingareastndcode== "BAE" | buildingareastndcode== "BAF" | buildingareastndcode== "BAG" | ///
		buildingareastndcode== "BAL" | buildingareastndcode== "BAT"
	



***generate sale price variables 1) within property; 2) within zip code; 3) within county
		***4 time frames
		   *1. Before 2004 (Ivan)
		   *2. 2004-2012 (Ivan and Sandy)
		   *3. 2012-2017
		   *4. After 2017
		***12 variables in total
		
		
***gen variables if house is sold before Ivan
by houseid: gen ivanbefore = (salesdate < ivandate)
***gen variables if house is sold between Ivan and Sandy
by houseid: gen ivansandy = (salesdate >= ivandate & salesdate < sandydate)

	**ivanevent dummy: houses sold right before Ivan, versus right after Ivan (but before Sandy)
	gen ivanevent = 1 if ivansandy==1
	replace ivanevent = 0 if ivanbefore ==1

***gen variables if house is sold between Sandy and Irma
by houseid: gen sandyirma = (salesdate >= sandydate & salesdate < irmadate)

	**sandyevent dummy: houses sold right before Sandy (but after Ivan), versus right after Sandy (but before Irma)
	gen sandyevent = 1 if sandyirma==1
	replace sandyevent = 0 if ivansandy==1

	**`Before' here is before both Ivan & Sandy
	gen sandyevent2 = 1 if sandyirma==1
	replace sandyevent2 = 0 if ivanbefore ==1

***gen variables if house is sold after Irma
by houseid: gen irmaafter = (salesdate >= irmadate)

	**irmaevent dummy: houses sold right before Irma (but after Sandy), versus right after Irma
	gen irmaevent = 1 if irmaafter==1
	replace irmaevent = 0 if sandyirma ==1

	**`Before'here is before both Sandy & Irma
	gen irmaevent2 = 1 if irmaafter==1
	replace irmaevent2 = 0 if ivansandy==1
	

	**`Before'here is before both Ivan & Sandy & Irma
	gen irmaevent3 = 1 if irmaafter==1
	replace irmaevent3 = 0 if ivanbefore ==1


****detrend house sale price using HPI
// reg salespriceamount hpi_level
// predict salesprice_detrend, resid

// gen hpi_prediction = 1015.389*hpi_level
// gen salesprice_detrend = salespriceamount - hpi_prediction


**gen before Ivan price column; gen after Ivan price column
**take the mean if multiple transactions before and/or after hurricane
gen ivan_period = cond(ivanevent == 1, "after ivan", "before ivan") if ivanevent !=.

gen sandy_period = cond(sandyevent == 1, "after sandy", "before sandy") if sandyevent !=.
gen sandy_period2 = cond(sandyevent2 == 1, "after sandy", "before ivan & sandy") if sandyevent2 !=.

gen irma_period = cond(irmaevent == 1, "after irma", "before irma") if irmaevent !=.
gen irma_period2 = cond(irmaevent2 == 1, "after irma", "before sandy & irma") if irmaevent2 !=.
gen irma_period3 = cond(irmaevent3 == 1, "after irma", "before ivan, sandy, & irma") if irmaevent3 !=.


**because before / after hurricanes, there may be multiple transactions (e.g., 2 transactions right before Irma, versus 1 after Irma)
	**taking means of data here, conditonal on hurrican events, so we can calculate before and after price changes
	**can also try median, or max, or min
*1 Ivan
bysort houseid: egen salesprice_ivan_b = mean(salespriceamount) if ivanevent == 0
bysort houseid: egen salesprice_ivan_a = mean(salespriceamount) if ivanevent == 1
*2 Sandy
bysort houseid: egen salesprice_sandy_b = mean(salespriceamount) if sandyevent == 0
bysort houseid: egen salesprice_sandy_a = mean(salespriceamount) if sandyevent == 1

bysort houseid: egen salesprice_sandy_b2 = mean(salespriceamount) if sandyevent2 == 0
bysort houseid: egen salesprice_sandy_a2 = mean(salespriceamount) if sandyevent2 == 1


*3 Irma
bysort houseid: egen salesprice_irma_b = mean(salespriceamount) if irmaevent == 0
bysort houseid: egen salesprice_irma_a = mean(salespriceamount) if irmaevent == 1

bysort houseid: egen salesprice_irma_b2 = mean(salespriceamount) if irmaevent2 == 0
bysort houseid: egen salesprice_irma_a2 = mean(salespriceamount) if irmaevent2 == 1

bysort houseid: egen salesprice_irma_b3 = mean(salespriceamount) if irmaevent3 == 0
bysort houseid: egen salesprice_irma_a3 = mean(salespriceamount) if irmaevent3 == 1


**same as above, but for price per square feet
*1 Ivan
bysort houseid: egen salesprice_ivan_b_sq = mean(salesprice_sq) if ivanevent == 0
bysort houseid: egen salesprice_ivan_a_sq = mean(salesprice_sq) if ivanevent == 1
*2 Sandy
bysort houseid: egen salesprice_sandy_b_sq = mean(salesprice_sq) if sandyevent == 0
bysort houseid: egen salesprice_sandy_a_sq = mean(salesprice_sq) if sandyevent == 1

bysort houseid: egen salesprice_sandy_b2_sq = mean(salesprice_sq) if sandyevent2 == 0
bysort houseid: egen salesprice_sandy_a2_sq = mean(salesprice_sq) if sandyevent2 == 1


*3 Irma
bysort houseid: egen salesprice_irma_b_sq = mean(salesprice_sq) if irmaevent == 0
bysort houseid: egen salesprice_irma_a_sq = mean(salesprice_sq) if irmaevent == 1

bysort houseid: egen salesprice_irma_b2_sq = mean(salesprice_sq) if irmaevent2 == 0
bysort houseid: egen salesprice_irma_a2_sq = mean(salesprice_sq) if irmaevent2 == 1

bysort houseid: egen salesprice_irma_b3_sq = mean(salesprice_sq) if irmaevent3 == 0
bysort houseid: egen salesprice_irma_a3_sq = mean(salesprice_sq) if irmaevent3 == 1




***create means of sale price changes in percentage terms
**in analysis, using zip code level mean
sort houseid saledate

by houseid: gen saledelta = 100*(salespriceamount - salespriceamount[_n-1])/(salespriceamount[_n-1])
by houseid: gen saledelta_sq = 100*(salesprice_sq - salesprice_sq[_n-1])/(salesprice_sq[_n-1])
bysort propertyzip: egen saledelta_mean_zip = mean(saledelta)
bysort propertyzip: egen saledelta_mean_zip_sq = mean(saledelta_sq)

// bysort fips: egen saledelta_mean_zip = mean(saledelta)
// bysort fips: egen saledelta_mean_zip_sq = mean(saledelta_sq)

bysort fips: egen saledelta_mean_fips = mean(saledelta)
bysort fips: egen saledelta_mean_fips_sq = mean(saledelta_sq)



// Step 2: 
***collapse to calculate before and after price changes + graphs
preserve

collapse (mean) salesprice_ivan_b salesprice_ivan_a salesprice_sandy_b salesprice_sandy_a salesprice_sandy_b2 salesprice_sandy_a2 ///
salesprice_irma_b salesprice_irma_a salesprice_irma_b2 salesprice_irma_a2  salesprice_irma_b3 salesprice_irma_a3 ///
salesprice_ivan_b_sq salesprice_ivan_a_sq salesprice_sandy_b_sq salesprice_sandy_a_sq salesprice_sandy_b2_sq salesprice_sandy_a2_sq ///
salesprice_irma_b_sq salesprice_irma_a_sq salesprice_irma_b2_sq salesprice_irma_a2_sq  salesprice_irma_b3_sq salesprice_irma_a3_sq ///
saledelta_mean_zip saledelta_mean_fips ///
saledelta_mean_zip_sq saledelta_mean_fips_sq hpi fips, by(houseid)


// price differences without mangrove effect
*1
gen pricediff_ivan = (100*(salesprice_ivan_a - salesprice_ivan_b)/salesprice_ivan_b)- saledelta_mean_zip-hpi

*2
gen pricediff_sandy = (100*(salesprice_sandy_a - salesprice_sandy_b )/salesprice_sandy_b)- saledelta_mean_zip-hpi
gen pricediff_sandy2 = (100*(salesprice_sandy_a2 - salesprice_sandy_b2 )/salesprice_sandy_b2)- saledelta_mean_zip-hpi

*3
gen pricediff_irma = (100*(salesprice_irma_a - salesprice_irma_b )/salesprice_irma_b)- saledelta_mean_zip-hpi
gen pricediff_irma2 = (100*(salesprice_irma_a2 - salesprice_irma_b2 )/salesprice_irma_b2)- saledelta_mean_zip-hpi
gen pricediff_irma3 = (100*(salesprice_irma_a3 - salesprice_irma_b3 )/salesprice_irma_b3)- saledelta_mean_zip-hpi

*1-sq
gen pricediff_ivan_sq = (100*(salesprice_ivan_a_sq - salesprice_ivan_b_sq )/salesprice_ivan_b_sq)- saledelta_mean_zip_sq-hpi

*2-sq
gen pricediff_sandy_sq = (100*(salesprice_sandy_a_sq - salesprice_sandy_b_sq )/salesprice_sandy_b_sq)- saledelta_mean_zip_sq-hpi
gen pricediff_sandy2_sq = (100*(salesprice_sandy_a2_sq - salesprice_sandy_b2_sq )/salesprice_sandy_b2_sq)- saledelta_mean_zip_sq-hpi

*3-sq
gen pricediff_irma_sq = (100*(salesprice_irma_a_sq - salesprice_irma_b_sq )/salesprice_irma_b_sq)- saledelta_mean_zip_sq-hpi
gen pricediff_irma2_sq = (100*(salesprice_irma_a2_sq - salesprice_irma_b2_sq )/salesprice_irma_b2_sq)- saledelta_mean_zip_sq-hpi
gen pricediff_irma3_sq = (100*(salesprice_irma_a3_sq - salesprice_irma_b3_sq )/salesprice_irma_b3_sq)- saledelta_mean_zip_sq-hpi



global countynumber 12015 12021 12071 12057 12081 12086 12103



*****raw price change
*1
gen pricediff_ivan_noajust = (100*(salesprice_ivan_a - salesprice_ivan_b)/salesprice_ivan_b)-hpi

*2
gen pricediff_sandy_noajust = (100*(salesprice_sandy_a - salesprice_sandy_b )/salesprice_sandy_b)-hpi
gen pricediff_sandy2_noajust = (100*(salesprice_sandy_a2 - salesprice_sandy_b2 )/salesprice_sandy_b2)-hpi

*3
gen pricediff_irma_noajust = (100*(salesprice_irma_a - salesprice_irma_b )/salesprice_irma_b)-hpi
gen pricediff_irma2_noajust = (100*(salesprice_irma_a2 - salesprice_irma_b2 )/salesprice_irma_b2)-hpi
gen pricediff_irma3_noajust = (100*(salesprice_irma_a3 - salesprice_irma_b3 )/salesprice_irma_b3)-hpi

*1-sq
gen pricediff_ivan_sq_noajust = (100*(salesprice_ivan_a_sq - salesprice_ivan_b_sq )/salesprice_ivan_b_sq)-hpi

*2-sq
gen pricediff_sandy_sq_noajust = (100*(salesprice_sandy_a_sq - salesprice_sandy_b_sq )/salesprice_sandy_b_sq)-hpi
gen pricediff_sandy2_sq_noajust = (100*(salesprice_sandy_a2_sq - salesprice_sandy_b2_sq )/salesprice_sandy_b2_sq)-hpi

*3-sq
gen pricediff_irma_sq_noajust = (100*(salesprice_irma_a_sq - salesprice_irma_b_sq )/salesprice_irma_b_sq)-hpi
gen pricediff_irma2_sq_noajust = (100*(salesprice_irma_a2_sq - salesprice_irma_b2_sq )/salesprice_irma_b2_sq)-hpi
gen pricediff_irma3_sq_noajust = (100*(salesprice_irma_a3_sq - salesprice_irma_b3_sq )/salesprice_irma_b3_sq)-hpi



tostring fips, replace 
gen fips_name = fips
 
replace fips_name = "Charlotte" if fips =="12015"
replace fips_name = "Collier" if fips =="12021"
replace fips_name = "Lee" if fips =="12071"
replace fips_name = "Hillsborough" if fips =="12057"
replace fips_name = "Manatee" if fips =="12081"
replace fips_name = "Miami" if fips =="12086"
replace fips_name = "Pinellas" if fips =="12103"

save ./Data/salesprice_b_a_plot.dta, replace


restore





// Step 3: 
use ./Data/salesprice_b_a_plot.dta, clear
destring fips, replace 
***step 1: 

	**1. average increase in prices due to mangrove effect
	**2. Divide this average increase by the average price of property sales
	



// specify main effect of hurricanes in general for path and off path counties 
gen mangrove_effect_path = 0.1  /* 0.025 * 4 */
gen mangrove_effect_offpath = 0.044   /* 0.011 * 4 */

***step 2: Recalculate the house price changes to incorporate mangrove level effect
	**Multiply each original house sale return by the scaling factor
	
			// Reduced-form formlua for calculating the mangrove effect
			// price_diff_mang = (price_diff - hpi (%) - mangrove_effect_level (%)) * (1 - mangrove_effect_dispersion (%)) 



*1
// version 1: based on individual hurricane effect
// gen pricediff_ivan_mang = 100 * (salesprice_ivan_a * (1 + mangrove_effect_ivan) - salesprice_ivan_b) / salesprice_ivan_b - hpi
// version 2: based on overall hurricane effect -- on path

    // Ivan path: fips, 12057, 12021, 12011, 12086)
gen pricediff_ivan_mang = 100 * (salesprice_ivan_a * (1 + mangrove_effect_path) - salesprice_ivan_b) / salesprice_ivan_b - hpi ///
if inlist(fips, 12057, 12021, 12011, 12086)

replace pricediff_ivan_mang = 100 * (salesprice_ivan_a * (1 + mangrove_effect_offpath) - salesprice_ivan_b) / salesprice_ivan_b - hpi ///
if !inlist(fips, 12057, 12021, 12011, 12086)


*2
// version 1: based on individual hurricane effect
// gen pricediff_sandy_mang = 100 * (salesprice_sandy_a * (1 + mangrove_effect_sandy) - salesprice_sandy_b) / salesprice_sandy_b - hpi
// gen pricediff_sandy2_mang = 100 * (salesprice_sandy_a2 * (1 + mangrove_effect_sandy) - salesprice_sandy_b2) / salesprice_sandy_b2 - hpi
// version 2: based on overall hurricane effect -- off path
gen pricediff_sandy2_mang = 100 * (salesprice_sandy_a2 * (1 + mangrove_effect_offpath) - salesprice_sandy_b2) / salesprice_sandy_b2 - hpi



*3
// version 1: based on individual hurricane effect
// gen pricediff_irma_mang = 100 * (salesprice_irma_a * (1 + mangrove_effect_irma) - salesprice_irma_b) / salesprice_irma_b - hpi
// gen pricediff_irma2_mang = 100 * (salesprice_irma_a2 * (1 + mangrove_effect_irma) - salesprice_irma_b2) / salesprice_irma_b2 - hpi
// gen pricediff_irma3_mang = 100 * (salesprice_irma_a3 * (1 + mangrove_effect_irma) - salesprice_irma_b3) / salesprice_irma_b3 - hpi
// version 2: based on overall hurricane effect -- on path

	// Irma path: fips, 12057, 12021, 12015, 12071) 
gen pricediff_irma2_mang = 100 * (salesprice_irma_a2 * (1 + mangrove_effect_path) - salesprice_irma_b2) / salesprice_irma_b2 - hpi ///
if inlist(fips, 12057, 12021, 12015, 12071)

replace pricediff_irma2_mang = 100 * (salesprice_irma_a2 * (1 + mangrove_effect_offpath) - salesprice_irma_b2) / salesprice_irma_b2 - hpi ///
if !inlist(fips, 12057, 12021, 12015, 12071)


***step 3: Recalculate the house price changes to incorporate mangrove var effect

// specify main effect of hurricanes in general for path and off path counties 
	gen mangrove_var_path = 0.032   /* this is coef 0.008 * 4 */  /* do we need to multiply by mean here? */
	gen mangrove_var_offpath = 0.028 /* 0.007 * 4 */


gen pricediff_ivan_mang_scale = (pricediff_ivan_mang)*(1-mangrove_var_path) if inlist(fips, 12057, 12021, 12011, 12086)
replace pricediff_ivan_mang_scale = (pricediff_ivan_mang)*(1-mangrove_var_offpath) if !inlist(fips, 12057, 12021, 12011, 12086)

gen pricediff_sandy2_mang_scale = (pricediff_sandy2_mang)*(1-mangrove_var_offpath)

gen pricediff_irma2_mang_scale = (pricediff_irma2_mang)*(1-mangrove_var_path) if inlist(fips, 12057, 12021, 12015, 12071)
replace pricediff_irma2_mang_scale = (pricediff_irma2_mang)*(1-mangrove_var_offpath) if !inlist(fips, 12057, 12021, 12015, 12071)





************export to csv for graphing in R
// NOTE: re-run the previous code to output each of the following csv



preserve
keep houseid fips fips_name pricediff_sandy2_noajust pricediff_sandy2_mang_scale 
drop if pricediff_sandy2_noajust ==.
ren pricediff_sandy2_noajust pricediff_calib

export delimited using ./Data/pricediff_sandy2_b_update_newbenchmark.csv, replace
restore


preserve
keep houseid fips fips_name pricediff_ivan_noajust pricediff_ivan_mang_scale 
drop if pricediff_ivan_noajust ==.
ren pricediff_ivan_noajust pricediff_calib
drop if fips_name =="12037.25"

export delimited using ./Data/pricediff_ivan_update_newbenchmark.csv, replace
restore




preserve
keep houseid fips fips_name pricediff_irma2_noajust pricediff_irma2_mang_scale 
drop if pricediff_irma2_noajust ==.
ren pricediff_irma2_noajust pricediff_calib
drop if fips_name =="12037.25"

export delimited using ./Data/pricediff_irma2_update_newbenchmark.csv, replace
restore




************FINAL STEPS: 

************FINAL STEPS to reshape the data: (automated approach) 
// Sandy
// STEP 1: Load the original dataset
import delimited "./Data/pricediff_sandy2_b_update_newbenchmark.csv", clear

// STEP 2: Save original version as "No mangrove"
gen mangrove = "No"
gen pricediff_calib_reshaped = pricediff_calib
keep houseid fips pricediff_calib_reshaped fips_name mangrove
tempfile original
save `original'

// STEP 3: Reload and prepare "Yes mangrove" rows using mangrove-adjusted values
import delimited "./Data/pricediff_sandy2_b_update_newbenchmark.csv", clear
keep houseid fips pricediff_sandy2_mang_scale fips_name
rename pricediff_sandy2_mang_scale pricediff_calib_reshaped
drop if missing(pricediff_calib_reshaped)
gen mangrove = "Yes"
tempfile recalibrated
save `recalibrated'

// STEP 4: Append recalibrated observations to original
use `original', clear
append using `recalibrated'

// STEP 5: Reorder columns to match manual formatting
order houseid fips pricediff_calib_reshaped fips_name mangrove
rename pricediff_calib_reshaped pricediff_calib


// STEP 7: Export
export delimited "./Data/pricediff_sandy2_b_update_newbenchmark.csv", replace



// Ivan
// STEP 1: Load the original dataset
import delimited "./Data/pricediff_ivan_update_newbenchmark.csv", clear

// STEP 2: Save original version as "No mangrove"
gen mangrove = "No"
gen pricediff_calib_reshaped = pricediff_calib
keep houseid fips pricediff_calib_reshaped fips_name mangrove
tempfile original
save `original'

// STEP 3: Reload and prepare "Yes mangrove" rows using mangrove-adjusted values
import delimited "./Data/pricediff_ivan_update_newbenchmark.csv", clear
keep houseid fips pricediff_ivan_mang_scale fips_name
rename pricediff_ivan_mang_scale pricediff_calib_reshaped
drop if missing(pricediff_calib_reshaped)
gen mangrove = "Yes"
tempfile recalibrated
save `recalibrated'						

// STEP 4: Append recalibrated observations to original
use `original', clear
append using `recalibrated'
// STEP 5: Reorder columns to match manual formatting
order houseid fips pricediff_calib_reshaped fips_name mangrove
rename pricediff_calib_reshaped pricediff_calib

// STEP 7: Export
export delimited "./Data/pricediff_ivan_update_newbenchmark.csv", replace


// Irma
// STEP 1: Load the original dataset
import delimited "./Data/pricediff_irma2_update_newbenchmark.csv", clear


// STEP 2: Save original version as "No mangrove"
gen mangrove = "No"
gen pricediff_calib_reshaped = pricediff_calib
keep houseid fips pricediff_calib_reshaped fips_name mangrove
tempfile original
save `original'

// STEP 3: Reload and prepare "Yes mangrove" rows using mangrove-adjusted values
import delimited "./Data/pricediff_irma2_update_newbenchmark.csv", clear
keep houseid fips pricediff_irma2_mang_scale fips_name
rename pricediff_irma2_mang_scale pricediff_calib_reshaped
drop if missing(pricediff_calib_reshaped)
gen mangrove = "Yes"
tempfile recalibrated
save `recalibrated'

// STEP 4: Append recalibrated observations to original
use `original', clear
append using `recalibrated'

// STEP 5: Reorder columns to match manual formatting
order houseid fips pricediff_calib_reshaped fips_name mangrove
rename pricediff_calib_reshaped pricediff_calib


// STEP 7: Export
export delimited "./Data/pricediff_irma2_update_newbenchmark.csv", replace



    //  I. alternatively, MANUALLY modify the csv files 
			// (the process is a bit convoluted; might be better way to automate it in the future)
			// key steps, using the example of pricediff_irma_update.csv
			// 1. Column "pricediff_irma2_mang_scale" here represents the recalibrated price change after taking into account the mangrove effect
			// 	- append (copy and paste) vertically the values in "pricediff_irma2_mang_scale" right after the last observation in "pricediff_calib"
			// 	- remove the original column "pricediff_irma2_mang_scale"

			// 2. Move column "fips_name" right next to column "pricediff_calib"

			// 3. New column named "mangrove" and add 
			// 	- "No" for observations originally in "pricediff_calib"
			// 	- "Yes" for observations newly added to "pricediff_calib"--this should be easy to tell, as these observations right now still miss county names
			// 4. Copy and paste the observations in "houseid", "fips", and "fips_name" to the blank cells in the same columns
			// 	- this works because everything is at unique property level (houseid), and the data is sorted by houseid

			// 5. Save the file as something like "pricediff_irma_update_reshape.csv"

