version 16
clear all
set more off
pause on
cap log close
set logtype text

* Setting Directories
loc user : env USERPROFILE

if "`c(os)'" == "MacOSX" {
	loc root "~/Dropbox/Research/Underway/cps-downstream/data"
}
else {
	loc root "`user'/Dropbox/Research/Underway/cps-downstream/Data"
}
loc clean "`root'/clean"
loc tables "`root'/output/tables"

*******************************************************************************
*Name: 010_analysis_academics.do
*Purpose: Conducts analysis on how students in the downstream sample did on
* academics
*******************************************************************************

use "`clean'/individual_test_scores.dta", clear

* Keeping only households I was able to follow-up with
keep if attrition == 0

* Defining locals
loc dependentvariables y3_telugu_norm y3_math_norm y3_eng_hel_norm y4_telugu_norm y4_math_norm y4_eng_lel_norm y4_evs_hel_norm y4_hindi_ability_norm
loc fulldvs y3_telugu_norm y3_math_norm y3_eng_hel_norm score_y2 y4_telugu_norm y4_math_norm y4_eng_lel_norm y4_evs_hel_norm score_y4 y4_hindi_ability_norm
loc controls y0_base_norm schedule_ct parents_prim hhold_asset_indx
loc fixed_effects dist_1-dist_4

* ITT of test scores on downstream sample
foreach var of varlist `dependentvariables' {
	reg `var' offered `controls' `fixed_effects', cl(pu_code)
	eststo `var'
}

* Results for pooled DVs
use "`clean'/combined_test_scores.dta", clear

* Keeping only households I was able to follow-up with:
keep if attrition == 0

reg score offered `controls' `fixed_effects' if year_2 == 1, cl(pu_code)
eststo score_y2

reg score offered `controls' `fixed_effects' if year_4 == 1, cl(pu_code)
eststo score_y4

* Exporting tables:
esttab `fulldvs' using "`tables'/academics.tex", replace mgroup("Year 2 Scores" "Year 4 Scores", pattern(1 0 0 0 1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) mtitles("Telugu" "Math" "English" "Combined" "Telugu" "Math" "English" "EVS" "Combined" "Hindi") label wrap booktabs se(3) b(3) nonumbers nonote nofloat compress star(* .1 ** .05 *** .01) drop(y0_base_norm dist_? schedule_ct parents_prim hhold_asset_indx _cons)
estimates clear

use "`clean'/individual_test_scores.dta", clear

* Keeping only households I was able to follow-up with
keep if attrition == 0

* TOT of test scores on downstream sample:
foreach var of varlist `dependentvariables' {
	ivregress 2sls `var' (enrolled = offered) `controls' `fixed_effects', cl(pu_code)
	eststo `var'
}

* Results for pooled DVs
use "`clean'/combined_test_scores.dta", clear

* Keeping only households I was able to follow-up with:
keep if attrition == 0

ivregress 2sls score (enrolled = offered) `controls' `fixed_effects' if year_2 == 1, cl(pu_code)
eststo score_y2

ivregress 2sls score (enrolled = offered) `controls' `fixed_effects' if year_4 == 1, cl(pu_code)
eststo score_y4

* Exporting tables
esttab `fulldvs' using "`tables'/academicsinstrumented.tex", replace mgroup("Year 2 Scores" "Year 4 Scores", pattern(1 0 0 0 1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) mtitles("Telugu" "Math" "English" "Combined" "Telugu" "Math" "English" "EVS" "Combined" "Hindi") label wrap booktabs se(3) b(3) nonumbers nonote nofloat compress star(* .1 ** .05 *** .01) drop(y0_base_norm dist_? schedule_ct parents_prim hhold_asset_indx _cons)
estimates clear

exit, clear