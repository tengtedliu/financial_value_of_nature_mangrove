
*EXAMPLE 1
*Event study on two varlists, with one event window around the event date (July 9, 2015)
sjlog using estudy1, replace
use data_estudy.dta
estudy boa ford boeing (apple netflix amazon facebook google), datevar(date) evdate(07092015) dateformat(MDY) indexlist(mkt) lb1(-3) ub1(3) 
sjlog close, replace

*EXAMPLE 2
*Event study on two varlists, with three event windows around the event date (July 9, 2015), a customized estimation window and the BMP test 
sjlog using estudy2, replace
estudy boa ford boeing (apple netflix amazon facebook google), datevar(date) evdate(07092015) dateformat(MDY) indexlist(mkt) lb1(-3) ub1(3) lb2(-3) ub2(-1) lb3(0) ub3(3) diagnosticsstat(BMP) eswlb(-250) eswub(-20)
sjlog close, replace

*EXAMPLE 3														
*Event study on four varlists, with three event windows around the event date (July 9, 2015), a customized estimation window and the KP test.
*ARs on single securities are not reported. Historical Mean Model is used.
sjlog using estudy3, replace
estudy boa ford boeing(ibm facebook apple) (netflix cocacola amazon) (facebook boa ford boeing google), datevar(date) evdate(07092015) dateformat(MDY) modtype(HMM) lb1(-3) ub1(3) lb2(-3) ub2(-1) lb3(0) ub3(3) diagnosticsstat(KP) eswlb(-250) eswub(-20) suppress(ind)
sjlog close, replace

*EXAMPLE 4
*Event study on four varlists, with three event windows around the event date (July 9, 2015), a customized estimation window and the KP test.
*Only ARs on single securities are reported. Fama-French 3 factors model is used.
sjlog using estudy4, replace
estudy boa ford boeing(ibm facebook apple) (netflix cocacola amazon) (facebook boa ford boeing google), datevar(date) evdate(07092015) dateformat(MDY) modtype(MFM) indexlist(mkt smb hml) lb1(-3) ub1(3) lb2(-3) ub2(-1) lb3(0) ub3(3) diagnosticsstat(KP) eswlb(-250) eswub(-20) suppress(group) showpvalues nostar
sjlog close, replace
