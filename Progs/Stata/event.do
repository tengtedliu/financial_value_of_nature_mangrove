*------------------------------------------------------------*
****Figure 4: Housing Prices Following Hurricane Season: event study
*------------------------------------------------------------*


use ../../Data/workfile.dta, clear 

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


**********

g irmonths = int(irma_months) /* 2017-10 */
g ivmonths = int(ivan_months) /* 2004-10 */
g smonths = int(sandy_months) /* 2012-11 */

g hmonths = ivmonths  
replace hmonths = smonths if smonths>-6
replace hmonths = irmonths if irmonths>-6

sort year month
egen ym = group(year month)

g timetoevent = year-huryear

capture drop _merge
merge m:1 month year using ../../Data/hpi.dta, keep(1 3)

save ../../Data/event.dta, replace

 

keep  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1 

// eventdd salespriceamount_log hpi_level  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1 & mdistancegroup==1 , timevar(hmonths)  method(hdfe, absorb(houseid  ))  leads(12) lags(36)  graph_op(saving(close1, replace) graphregion(fcolor(white)) title("Closer than 2km")) accum ci(rline) level(67) noend coef_op(msize(small) connect(l))
// estat eventdd
//
// eventdd salespriceamount_log   hpi_level   if salescount <= 22 & floodzone==0    & mid_floodrisk ==1 & mdistancegroup==2 , timevar(hmonths)  method(hdfe, absorb(houseid   ))  leads(12) lags(36)  graph_op(saving(close2, replace) legend(off) graphregion(fcolor(white)) title("2-4 km"))
// accum ci(rline) level(67) noend  coef_op(msize(small) connect(l))
// estat eventdd
//
// eventdd salespriceamount_log    hpi_level  if salescount <= 22 & floodzone==0    & mid_floodrisk ==1 & mdistancegroup==3 , timevar(hmonths)  method(hdfe, absorb(houseid   ))  leads(12) lags(36)  graph_op(saving(close3, replace) legend(off) graphregion(fcolor(white)) title("4-8 km")) accum ci(rline) level(67) noend  coef_op(msize(small) connect(l)) 
// estat eventdd

*****add y and x axis labels
eventdd salespriceamount_log hpi_level ///
  if salescount <= 22 & floodzone==0 & mid_floodrisk==1 & mdistancegroup==1, ///
  timevar(hmonths) method(hdfe, absorb(houseid)) leads(12) lags(36) ///
  graph_op(saving(close1, replace) graphregion(fcolor(white)) ///
  title("Closer than 2km to mangroves") ytitle("Log of sale price") ///
  xtitle("Months after hurricane")) ///
  accum ci(rline) level(67) noend ///
  coef_op(lcolor("128 0 0") mcolor("128 0 0") msymbol(circle) msize(small) connect(l)) ///
  ci_op(lcolor("0 0 139") lwidth(thin))


eventdd salespriceamount_log hpi_level ///
  if salescount <= 22 & floodzone==0 & mid_floodrisk==1 & mdistancegroup==2, ///
  timevar(hmonths) method(hdfe, absorb(houseid)) leads(12) lags(36) ///
  graph_op(saving(close2, replace) graphregion(fcolor(white)) ///
  title("2-4 km to mangroves") ytitle("Log of sale price") ///
  xtitle("Months after hurricane")) ///
  accum ci(rline) level(67) noend ///
  coef_op(lcolor("128 0 0") mcolor("128 0 0") msymbol(circle) msize(small) connect(l)) ///
  ci_op(lcolor("0 0 139") lwidth(thin))

eventdd salespriceamount_log hpi_level ///
  if salescount <= 22 & floodzone==0 & mid_floodrisk==1 & mdistancegroup==3, ///
  timevar(hmonths) method(hdfe, absorb(houseid)) leads(12) lags(36) ///
  graph_op(saving(close3, replace) graphregion(fcolor(white)) ///
  title("4-8 km to mangroves") ytitle("Log of sale price") ///
  xtitle("Months after hurricane")) ///
  accum ci(rline) level(67) noend ///
  coef_op(lcolor("128 0 0") mcolor("128 0 0") msymbol(circle) msize(small) connect(l)) ///
  ci_op(lcolor("0 0 139") lwidth(thin))
  


set scheme s1color
grc1leg  close1.gph close2.gph close3.gph  , xcommon ycommon cols(3) scale(0.8) 
graph export ../../Results/Figures/event3_label.png, replace

 
