clear

sjlog using grstyle1, replace
set scheme sj
grstyle init
grstyle graphsize x 2
grstyle graphsize y 2
sysuse auto
scatter price weight
sjlog close, replace

graph export grstyle1.pdf, replace

sjlog using grstyle2, replace
scatter price mpg
sjlog close, replace

graph export grstyle2.pdf, replace

clear all
grstyle clear

set scheme sj
grstyle init
grstyle color background white
grstyle anglestyle vertical_tick horizontal
grstyle yesno draw_major_hgrid yes
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes
grstyle color major_grid gs8
grstyle linewidth major_grid thin
grstyle linepattern major_grid dot
grstyle clockdir legend_position 4
grstyle numstyle legend_cols 1
grstyle linestyle legend none
grstyle linewidth plineplot medthick
grstyle color p1markline gs6%0
grstyle color p1markfill gs6%50
grstyle color p2markline gs10%0
grstyle color p2markfill gs10%50
grstyle color ci_area gs12%50
grstyle color ci_arealine gs12%0
grstyle color p1 black
grstyle color p2 black
grstyle linepattern p1 solid
grstyle linepattern p2 dash

sjlog using grstyle15, replace
sysuse auto
twoway (scatter price weight if foreign==0) ///
       (scatter price weight if foreign==1) ///
       (lfitci price weight if foreign==0, clstyle(p1line)) ///
       (lfitci price weight if foreign==1, clstyle(p2line)) ///
       , legend(order(1 "domestic" 2 "foreign"))
sjlog close, replace

graph export grstyle15.pdf, replace

sjlog using grstyle16, replace
twoway (scatter price mpg if foreign==0) ///
       (scatter price mpg if foreign==1) ///
       (lfitci price mpg if foreign==0, clstyle(p1line)) ///
       (lfitci price mpg if foreign==1, clstyle(p2line)) ///
       , legend(order(1 "domestic" 2 "foreign"))
sjlog close, replace

graph export grstyle16.pdf, replace

sjlog using grstyle16, replace
local xsize = 9 / 2.54               // 9cm wide
local ysize = 7 / 2.54               // 7cm high
local rsize = min(`xsize', `ysize')  // reference size
foreach pt in .5 3 6 8 10 {          // compute relative sizes
     local nm: subinstr local pt "." "_" // so that ".#" is "_#"
     local `nm'pt = `pt' /(`rsize'*72)*100
}
grstyle init
grstyle graphsize x         `xsize'
grstyle graphsize y         `ysize'
grstyle gsize heading        `10pt' // title
grstyle gsize subheading      `8pt' // subtitle
grstyle gsize axis_title      `8pt'
grstyle gsize tick_label      `6pt'
grstyle gsize key_label       `8pt' // key labels in legend
grstyle gsize plabel          `6pt' // marker labels
grstyle gsize text_option     `6pt' // added text
grstyle symbolsize p          `3pt' // marker symbols
grstyle linewidth axisline   `_5pt'
grstyle linewidth tick       `_5pt'
grstyle linewidth major_grid `_5pt'
grstyle linewidth legend     `_5pt' // legend outline
grstyle linewidth xyline     `_5pt' // added lines
sysuse auto
generate str mlab = "Marker label (6pt)" if price>15000
twoway (scatter price weight, mlabel(mlab)), title("Title (10pt)") ///
     subtitle("Subtitle (8pt)") xtitle("X-axis title (8pt)") ///
     ytitle("Y-axis title (8pt)") legend(on order(1 "Legend key (8pt)")) ///
     text(12500 2400 "Added text (6pt)") xline(4000)
sjlog close, replace

graph export grstyle17.pdf, replace

