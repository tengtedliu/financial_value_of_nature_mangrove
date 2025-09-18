// Appendix A.4: Temporal Variation of Mangroves

use "./Analysis/Data/workfile.dta"

// the followings are the time-variant variables of mangrove distance
        // sp_join_gmw_v3_2020_vec 
        // sp_join_gmw_v3_2019_vec 
        // sp_join_gmw_v3_2018_vec 
        // sp_join_gmw_v3_2017_vec 
        // sp_join_gmw_v3_2016_vec 
        // sp_join_gmw_v3_2015_vec 
        // sp_join_gmw_v3_2010_vec 
        // sp_join_gmw_v3_2009_vec 
        // sp_join_gmw_v3_2008_vec 
        // sp_join_gmw_v3_2007_vec 
        // sp_join_gmw_v3_1996_vec


// do summary statistics of the time-variant mangrove distance data

// analyze the max chanage rate of mangrove distance for each property 
gen rate_2020_2019 = (sp_join_gmw_v3_2020_vec - sp_join_gmw_v3_2019_vec) / sp_join_gmw_v3_2019_vec
gen rate_2019_2018 = (sp_join_gmw_v3_2019_vec - sp_join_gmw_v3_2018_vec) / sp_join_gmw_v3_2018_vec
gen rate_2018_2017 = (sp_join_gmw_v3_2018_vec - sp_join_gmw_v3_2017_vec) / sp_join_gmw_v3_2017_vec
gen rate_2017_2016 = (sp_join_gmw_v3_2017_vec - sp_join_gmw_v3_2016_vec) / sp_join_gmw_v3_2016_vec
gen rate_2016_2015 = (sp_join_gmw_v3_2016_vec - sp_join_gmw_v3_2015_vec) / sp_join_gmw_v3_2015_vec
gen rate_2015_2010 = (sp_join_gmw_v3_2015_vec - sp_join_gmw_v3_2010_vec) / sp_join_gmw_v3_2010_vec
gen rate_2010_2009 = (sp_join_gmw_v3_2010_vec - sp_join_gmw_v3_2009_vec) / sp_join_gmw_v3_2009_vec
gen rate_2009_2008 = (sp_join_gmw_v3_2009_vec - sp_join_gmw_v3_2008_vec) / sp_join_gmw_v3_2008_vec
gen rate_2008_2007 = (sp_join_gmw_v3_2008_vec - sp_join_gmw_v3_2007_vec) / sp_join_gmw_v3_2007_vec
gen rate_2007_1996 = (sp_join_gmw_v3_2007_vec - sp_join_gmw_v3_1996_vec) / sp_join_gmw_v3_1996_vec

//difference between the first year of observation and most recent year of observation
gen rate_2020_1996 = (sp_join_gmw_v3_2020_vec - sp_join_gmw_v3_1996_vec) / sp_join_gmw_v3_1996_vec

// analyze the max chanage rate of mangrove distance for each property
egen rate_max = rowmax(rate_2020_2019 rate_2019_2018 rate_2018_2017 rate_2017_2016 rate_2016_2015 rate_2015_2010 rate_2010_2009 rate_2009_2008 rate_2008_2007 rate_2007_1996)

***results for "Max year to year change rate of mangrove distance"***
summarize rate_max, detail

***results for "Longitudinal change rate of mangrove distance from 1996 to 2020"***
summarize rate_2020_1996, detail




