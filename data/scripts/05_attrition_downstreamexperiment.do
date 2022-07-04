version 16
clear all
set more off
pause on
cap log close
set logtype text
*set trace on

* SETTING DIRECTORIES:
loc user : env USERPROFILE
if "`c(os)'" == "MacOSX" {
	loc root "~/Dropbox/Research/Underway/cps-downstream/data"
}
else {
	loc root "`user'/Dropbox/Research/Underway/cps-downstream/data"

}
loc clean "`root'/clean"
loc tables "`root'/output/tables"
loc figures "`root'/output/figures/"
loc text "`root'/output/text"
loc pca "`user'/Dropbox/UPenn/Dissertation/Data/Census of India/2011/PCA"

/*
*************************************
*Name: attrition_downstreamexperiment.do
*Purpose: Conducts analysis of attrition for the Downstream Experiment
* Author: Emmerich Davies
* Date Created: 2018/12/17
* Last Run: 2018/12/17
*************************************
*/

use "`clean'/survey_clean.dta", clear

* Defining macros:
loc pol_participation index_part_pol polparty polmeeting polcanvas polleaflets
loc locdemocindex index_locdemoc assccaste assccoops asscshg gramsabha
loc privatisation index_privatisation privjob privservices privfinancing privschool1 numprivschool healthpriv
loc valuation index_valuation sd_min_amount_voucher sd_min_amount_pds
loc fixed_effects dist_1-dist_4

* Relabelling variables:
g attrition_offered = attrition * offered
lab var attrition "Attrition"
lab var attrition_offered "Attrition x Voucher Winner"
lab var y4_hindi_pr_l "Hindi Score: Letters"
lab var y4_hindi_pr_w "Hindi Score: Words"
lab var y4_hindi_pr_li "Hindi Score: Sentences"
lab var y4_hindi_pr_mcq "Hindi Score: Multiple Choice"
lab var y4_hindi_pr_pg "Hindi Score: Paragraph"
lab var parents_g10 "Parents Reached Grade 10"
lab var parents_prim "Parents Completed Primary"
lab var hhold_asset_indx "Household Asset Index at Baseline"
lab var y0_tel_norm "Baseline Telugu Test Score"
lab var y0_math_norm "Baseline Math Test Score"
lab var schedule_ct "SC/ST"
lab var y4_evs_hel_norm "EVS Score"
lab var y4_eng_lel_norm "English Score"
lab var y4_telugu_norm "Telugu Score"
lab var y4_math_norm "Math Score"
lab var y4_present4all_end "Present for all Endline Tests"
lab var attends_pri_eng_y3eng_y3 "Private English"
lab var attends_pri_tel_y3eng_y3 "Private Telugu"

foreach var of varlist y0_tel_norm y0_math_norm parents_prim hhold_asset_indx parents_g10 schedule_ct y4_hindi_pr_l y4_hindi_pr_w y4_hindi_pr_li y4_hindi_pr_mcq y4_hindi_pr_pg y4_evs_hel_norm y4_eng_lel_norm y4_telugu_norm y4_math_norm y4_present4all_end attends_pri_eng_y3eng_y3 attends_pri_tel_y3eng_y3 attends_pri_eng_y4eng_y3 attends_pri_tel_y4eng_y3 {
	reg `var' attrition_offered attrition offered i.district_code, cl(pu_code)
	eststo `var'
}

* Exporting household characteristics:
esttab parents_prim hhold_asset_indx parents_g10 schedule_ct using "`tables'/attritionhousehold.tex", replace label wrap booktabs se(3) b(3) nonote nofloat compress star(* .1 ** .05 *** .01) keep(attrition_offered attrition offered)

* Exporting academic achievement characteristics at baseline:
esttab y0_tel_norm y0_math_norm using "`tables'/attritionacademicbaseline.tex", replace label wrap booktabs se(3) b(3) nonote nofloat compress star(* .1 ** .05 *** .01) keep(attrition_offered attrition offered)

* Exporting academic achievement characteristics at endline:
esttab y4_hindi_pr_l y4_hindi_pr_w y4_hindi_pr_li y4_hindi_pr_pg using "`tables'/attritionacademichindiendline.tex", replace label wrap booktabs se(3) b(3) nonote nofloat compress star(* .1 ** .05 *** .01) keep(attrition_offered attrition offered)

* Exporting academic achievement characteristics at endline for all other subjects:
esttab y4_evs_hel_norm y4_eng_lel_norm y4_telugu_norm y4_math_norm y4_present4all_end using "`tables'/attritionacademicotherendline.tex", replace label wrap booktabs se(3) b(3) nonote nofloat compress star(* .1 ** .05 *** .01) keep(attrition_offered attrition offered)

* Exporting School Choice characteristics:
esttab attends_pri_eng_y3eng_y3 attends_pri_tel_y3eng_y3 using "`tables'/attritionschoolchoice.tex", replace label wrap booktabs se(3) b(3) nonote nofloat compress star(* .1 ** .05 *** .01) keep(attrition_offered attrition offered)
estimates clear

exit, clear
