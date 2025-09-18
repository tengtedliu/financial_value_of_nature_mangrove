// Note: Create scatterplot between price per square foot and mangrove distance

use ../../Data/workfile.dta, clear
// Patht to data: ztrax_FL/FL_data


**creste bin scatterplot of price per square foot and mangrove distance, controling for hpi
// ssc install binscatter
gen salespriceamount_sqt_dollar = salespriceamount/buildingareasqft

capture drop _merge
merge m:1 year month using "../../Data/hpi.dta"

// global CONTROLS hpi coastline_distance_km elevation_meters age buildingareasqft distance_delta_i familyresid condo 
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
