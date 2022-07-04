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
loc figures "`root'/output/figures"
loc text "`root'/output/text"
loc census "`root'/raw/census"

*************************************
*Name: analysis_downstreamexperiment.do
*Purpose: Downstream Experiment Analysis
*Notes: Replaces neweps_analysis.do, job_market_tables.do, and survey_analysis.do as final version of analysis of downstream experiment.  Once this runs properly and provides analysis I need, will commit to git and delete other versions.
*************************************

use "`clean'/survey_clean.dta", clear /* Future iterations will clean the cleaning file to just call this survey clean and use Guy's new code*/

keep if attrition == 0 /*Dropping households we were unable to follow-up with*/

* Defining macros:
loc controls parents_g10 hhold_asset_indx schedule_ct male age rel_muslim
loc fixed_effects dist_1-dist_4
loc pol_participation index_part_pol polparty polmeeting polcanvas polleaflets
loc pol_participation_voting index_voting `pol_participation' votels votemla votepan
loc locdemocindex index_locdemoc assccaste assccoops asscshg gramsabha
loc privatisation index_privatisation privjob privservices privfinancing privschool1 numprivschool healthpriv
loc valuation index_valuation sd_min_amount_voucher sd_min_amount_pds
loc monitoring pol_gov_school_monitor pol_gov_school_census
loc treatment per_gov_teacher per_treat_gov_teacher
loc summary private_two private_end `pol_participation' `locdemocindex' `privatisation' `valuation' `monitoring' `treatment'

*******
* Balance Test Table
*******
qui replace hh_income = 0 if hh_income == 1

foreach var of varlist y0_tel_norm y0_math_norm `controls' vote_ls_2009 vote_mla_2009 {
	display "`var'"
	ttest `var', by(offered)
	mat balance = nullmat(balance) \ r(mu_1) - r(mu_2), r(se), r(N_1), r(N_2)
}

* Seemingly Unrelated Regression of Joint Independence:
sureg (y0_tel_norm offered) (y0_math_norm offered) (parents_g10 offered) (hhold_asset_indx offered) (schedule_ct offered) (male offered) (age offered) (rel_muslim) (vote_ls_2009 offered) (vote_mla_2009 offered)
test offered
loc full_chi = r(p)

sureg (y0_tel_norm offered) (parents_g10 offered) (hhold_asset_indx offered) (schedule_ct offered) (male offered) (age offered) (rel_muslim) (vote_ls_2009 offered) (vote_mla_2009 offered)
test offered
loc reduced_chi = r(p)

* Exporting test statistic:
loc clean_full_chi: display %9.2f `full_chi'

* Writing output:
file open myfile using "`text'/fullchi.tex", write text replace
file write myfile "`clean_full_chi',"
file close myfile

loc clean_reduced_chi: display %9.2f `reduced_chi'

* Writing output:
file open myfile using "`text'/reducedchi.tex", write text replace
file write myfile "`clean_reduced_chi'."
file close myfile

*******
* Summary Statistics
*******

* Labelling variables for summary statistics
lab var private_two "Private School after Two Years (%)"
lab var private_end "Private School after Four Year (%)"
lab var hh_income "Household Income (Rs.)"
lab var hh_land "Household Land (Cents)"
lab var male "Male (%)"
lab var caste_general "General Caste (%)"
lab var caste_OBC "OBC (%)"
lab var caste_SC "SC (%)"
lab var caste_ST "ST (%)"
lab var rel_muslim "Muslim (%)"
lab var age "Age"
lab var salaried "Salaried Employees in Household? (%)"
lab var school "Years of Education"
lab var school_children "School Age Children in Household"
lab var dist_1 "Visakhapatnam (%)"
lab var dist_2 "East Godavari (%)"
lab var dist_3 "Kadapa (%)"
lab var dist_4 "Medak (%)"
lab var dist_5 "Nizamabad (%)"
lab var index_part_pol "Partisan Political Participation Index"
lab var polparty "Member of a Political Party (%)"
lab var polmeeting "Attended Political Meetings (%)"
lab var polcanvas "Canvassed for a Political Party (%)"
lab var polleaflets "Distributed Political Leaflets (%)"
lab var index_locdemoc "Non-Partisan Political Participation Index"
lab var assccaste "Member Caste Association (%)"
lab var assccoops "Member Cooperative (%)"
lab var asscshg "Member SHG (%)"
lab var gramsabha "Attended Village Meeting (%)"
lab var index_privatisation "Private Services Index"
lab var privjob "Private Job (%)"
lab var privservices "Private Services (%)"
lab var privfinancing "Private Financing (%)"
lab var privschool1 "Voucher Child in Private School (%)"
lab var numprivschool "Number of Children in Private School"
lab var healthpriv "Choose Private Health Facility (%)"
lab var index_valuation "Valuation of Public Services Index"
lab var min_amount_voucher "Valuation of Government Schools (Rs.)"
lab var min_amount_pds "Valuation of Government Rations (Rs.)"
lab var pol_gov_school_monitor "Teacher Works as Poll Monitor"
lab var pol_gov_school_census "Teacher Works as Census Enumerator"
lab var per_gov_teacher "Teachers Care About Students"
lab var per_treat_gov_teacher "Teachers Care About All Equally"
lab var index_claimstate "State Claim Making Index"
lab var claim_gov_school_state "State Claim: Government School Entrance (%)"
lab var claim_bpl_state "State Claim: BPL Card (%)"
lab var claim_hospital_state "State Claim: Government Hospital Entrance (%)"
lab var claim_nrega_state "State Claim: NREGA Job (%)" 
lab var claim_land_state "State Claim: Land or Police (%)"
lab var index_claimnonstate "Non-State Claim Making Index"
lab var claim_gov_school_nonstate "Non-State Claim: Government School Entrance (%)"
lab var claim_bpl_nonstate "Non-State Claim: BPL Card (%)"
lab var claim_hospital_nonstate "Non-State Claim: Government Hospital Entrance (%)"
lab var claim_nrega_nonstate "Non-State Claim: NREGA Job (%)"
lab var claim_land_nonstate "Non-State Claim: Land or Police (%)"
lab var parents_g10 "Parents Reached at least Grade 10 (%)"
lab var schedule_ct "Scheduled Caste or Tribe (%)"

loc num_vars_summary: word count `summary'

forval i = 1/`num_vars_summary' {
	loc current_var: word `i' of `summary'

	qui summ `current_var' if offered == 1
	loc treatment_mean =  r(mean)
	loc treatment_sd = r(sd)
	loc treatment_N = r(N)

	qui summ `current_var' if offered == 0
	loc control_mean =  r(mean)
	loc control_sd = r(sd)
	loc control_N = r(N)

	mat summary = nullmat(summary) \ `treatment_mean', `treatment_sd', `treatment_N', `control_mean', `control_sd', `control_N'

	loc var_`i': var label `current_var'
}

* Appendix Summary Statistics
loc num_vars_summary_appendix: word count `controls'

forval i = 1/`num_vars_summary_appendix' {
	loc current_var: word `i' of `controls'

	qui summ `current_var' if offered == 1
	loc treatment_mean =  r(mean)
	loc treatment_sd = r(sd)
	loc treatment_N = r(N)

	qui summ `current_var' if offered == 0
	loc control_mean =  r(mean)
	loc control_sd = r(sd)
	loc control_N = r(N)

	mat summaryappendix = nullmat(summaryappendix) \ `treatment_mean', `treatment_sd', `treatment_N', `control_mean', `control_sd', `control_N'

	loc var_`i'_appendix: var label `current_var'
}

* Relabelling variables for outsheeting to tables:
lab var offered "Voucher Winner"
lab var private_two "Private School after Two Years"
lab var private_end "Private School after Four Years"
lab var male "Male"
lab var caste_general "General Caste"
lab var rel_muslim "Muslim"
lab var salaried "Salaried Employees in Household"

lab var parents_g10 "Parents Reached Grade 10"
lab var schedule_ct "SC/ST"

********
* Main Results
********

* Partisan Political Participation:
loc counter: word count `pol_participation' 
foreach var of varlist `pol_participation' {
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures
	mat plot_part = nullmat(plot_part) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

* Non-Partisan Political Participation:
loc counter: word count `locdemocindex' 
foreach var of varlist `locdemocindex' {
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures
	mat plot_nonpart = nullmat(plot_nonpart) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

* Private Services Index:
loc counter: word count `privatisation'
foreach var of varlist `privatisation' {
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures
	mat plot_privatisation = nullmat(plot_privatisation) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

* Valuation of Public Services Index:
loc counter: word count `valuation'
foreach var of varlist `valuation'{
	ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures
	mat plot_valuation = nullmat(plot_valuation) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

************
* Mechanisms & Alternative Explanations
************

* Monitoring:
loc counter: word count `monitoring'
foreach var of varlist `monitoring' {
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures
	mat plot_monitoring = nullmat(plot_monitoring) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

* Evaluation of Government School Teachers:
loc counter: word count `treatment'
foreach var of varlist `treatment' {
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	* Storing point estimates and standard errors for figures:
	mat plot_evaluation = nullmat(plot_evaluation) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

* English Language Education:
loc counter: word count index_part_pol index_locdemoc index_privatisation index_valuation
foreach var of varlist index_part_pol index_locdemoc index_privatisation index_valuation {
	qui ivregress 2sls `var' (english = offered) `fixed_effects', cl(schoolcode_base)
	eststo `var'
	loc b_`var' = _b[english]
	loc se_`var' = _se[english] * 1.96

	* Storing point estimates and standard errors for figures:
	mat plot_english = nullmat(plot_english) \ `b_`var'', `se_`var'', `counter'
	loc counter = `counter' - 1
}

**************
* Full Results Online Appendix
**************

* First Stage
foreach var of varlist accepted enrolled private_two private_end {
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	eststo `var'

	qui reg `var' offered `controls' `fixed_effects', cl(schoolcode_base)
	eststo `var'controls
}
esttab accepted acceptedcontrols enrolled enrolledcontrols private_two private_twocontrols private_end private_endcontrols using "`tables'/firststage.tex", replace mgroup("Accepted Voucher" "Enrolled in Private School" "Private School after Two Years" "Private School after Four Years", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ml(none) label wrap booktabs se(3) b(3) nonote nofloat compress mtitle("") star(* .1 ** .05 *** .01) drop(dist_? _cons) scalar("F F-Stat")

* School Quality Results:
loc quality index_quality school_problem_solve school_building_qual school_teacher_qual school_overall_qual 
foreach var of varlist `quality' {
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	eststo offered
	estadd loc controls "No"

	qui reg `var' offered `controls' `fixed_effects', cl(schoolcode_base)
	eststo offeredcontrols
	estadd loc controls "Yes"

	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	eststo accepted
	estadd loc controls "No"

	qui ivregress 2sls `var' (accepted = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo acceptedcontrols
	estadd loc controls "Yes"

	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo enrolled
	estadd loc controls "No"

	qui ivregress 2sls `var' (enrolled = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo enrolledcontrols
	estadd loc controls "Yes"

	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	eststo private_two
	estadd loc controls "No"

	qui ivregress 2sls `var' (private_two = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_twocontrols
	estadd loc controls "Yes"

	qui ivregress 2sls `var' (private_end = offered) `fixed_effects', cl(schoolcode_base)
	eststo private_end
	estadd loc controls "No"

	qui ivregress 2sls `var' (private_end = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_endcontrols
	estadd loc controls "Yes"

	* Exporting for Submission
	esttab offered offeredcontrols accepted acceptedcontrols enrolled enrolledcontrols private_two private_twocontrols private_end private_endcontrols using "`tables'/`var'.tex", replace mgroup("Voucher Winner" "Accepted Voucher" "Enrolled in Private School" "Private School after Two Years" "Private School after Four Years", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ml(none) label wrap booktabs se(3) b(3) nonote nofloat compress mtitle("") star(* .1 ** .05 *** .01) drop(dist_? _cons) order(offered accepted enrolled private_two private_end) substitute(% \%)

	esttab offered offeredcontrols accepted acceptedcontrols enrolled enrolledcontrols private_two private_twocontrols private_end private_endcontrols using "`tables'/wp`var'.tex", replace mgroup("Voucher Winner" "Accepted Voucher" "Enrolled in Private School" "Private School after Two Years" "Private School after Four Years", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ml(none) label wrap booktabs se(3) b(3) nonote nofloat compress mtitle("") star(* .1 ** .05 *** .01) drop(dist_? _cons parents_g10 hhold_asset_indx schedule_ct male age rel_muslim) order(offered accepted enrolled private_two private_end) substitute(% \%) scalar("controls Controls")
	estimates clear
}


* Full Regression Tables:
foreach var of varlist `pol_participation' `locdemocindex' `privatisation' `valuation' `monitoring' `treatment' {
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	eststo offered

	qui reg `var' offered `controls' `fixed_effects', cl(schoolcode_base)
	eststo offeredcontrols

	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	eststo accepted

	qui ivregress 2sls `var' (accepted = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo acceptedcontrols

	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo enrolled

	qui ivregress 2sls `var' (enrolled = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo enrolledcontrols

	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	eststo private_two

	qui ivregress 2sls `var' (private_two = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_twocontrols

	qui ivregress 2sls `var' (private_end = offered) `fixed_effects', cl(schoolcode_base)
	eststo private_end

	qui ivregress 2sls `var' (private_end = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_endcontrols

	esttab offered offeredcontrols accepted acceptedcontrols enrolled enrolledcontrols private_two private_twocontrols private_end private_endcontrols using "`tables'/`var'.tex", replace mgroup("Voucher Winner" "Accepted Voucher" "Enrolled in Private School" "Private School after Two Years" "Private School after Four Years", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ml(none) label wrap booktabs se(3) b(3) nonote nofloat compress mtitle("") star(* .1 ** .05 *** .01) drop(dist_? _cons) order(offered accepted enrolled private_two private_end) substitute(% \%)
	estimates clear
}

**************
* Exporting results to produce full set of results with each potential variant of regression results
*************

* Political Participation
loc political_participation index_part_pol pp_polparty pp_polmeeting pp_polcanvas pp_polleaflets pp_polmeeting_polparty pp_polcanvas_polparty pp_polleaflets_polparty pp_polcanvas_polmeeting pp_polleaflets_polmeeting pp_polleaflets_polcanvas polparty polmeeting polcanvas polleaflets

loc counter: word count `political_participation'
foreach var of varlist `political_participation' {
	* Storing point estimates and standard errors for figures on ITT
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[offered]
	loc se_`var' = _se[offered] * 1.96

	mat plot_political_participation = nullmat(plot_political_participation) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and standard errors for IV on accepted voucher:
	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[accepted]
	loc se_`var' = _se[accepted] * 1.96

	mat a_political_participation = nullmat(a_political_participation) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on enrolled:
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	mat e_political_participation = nullmat(e_political_participation) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after two years:
	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_two]
	loc se_`var' = _se[private_two] * 1.96

	mat priv2_political_participation = nullmat(priv2_political_participation) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after four years:
	qui ivregress 2sls `var' (private_end = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_end]
	loc se_`var' = _se[private_end] * 1.96

	mat priv4_political_participation = nullmat(priv4_political_participation) \ `b_`var'', `se_`var'', `counter'

	loc l_political_participation_`counter': var label `var'

	loc counter = `counter' - 1
}

* Associational Activity:
loc associational_activity index_locdemoc assc_assccaste assc_assccoops assc_asscshg assc_gramsabha assc_gramsabha_asscshg assc_gramsabha_assccoops assc_gramsabha_assccaste assc_asscshg_assccoops assc_asscshg_assccaste assc_assccoops_assccaste assccaste assccoops asscshg gramsabha

loc counter: word count `associational_activity'
foreach var of varlist `associational_activity' {
	* Storing point estimates and standard errors for IV on accepted voucher:
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[offered]
	loc se_`var' = _se[offered] * 1.96

	mat plot_associational_activity = nullmat(plot_associational_activity) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and standard errors for IV on accepted voucher:
	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[accepted]
	loc se_`var' = _se[accepted] * 1.96

	mat a_associational_activity = nullmat(a_associational_activity) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on enrolled:
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	mat e_associational_activity = nullmat(e_associational_activity) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after two years:
	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_two]
	loc se_`var' = _se[private_two] * 1.96

	mat priv2_associational_activity = nullmat(priv2_associational_activity) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after four years:
	qui ivregress 2sls `var' (private_end = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_end]
	loc se_`var' = _se[private_end] * 1.96

	mat priv4_associational_activity = nullmat(priv4_associational_activity) \ `b_`var'', `se_`var'', `counter'

	loc l_associational_activity_`counter': var label `var'

	loc counter = `counter' - 1
}

* Private Services:
loc private_services index_privatisation priv_pj priv_pr priv_pf priv_pc priv_ns priv_hp priv_pj_pr priv_pj_pf priv_pj_pc priv_pj_ns priv_pj_hp priv_pr_pf priv_pr_pc priv_pr_ns priv_pr_hp priv_pf_pc priv_pf_ns priv_pf_hp priv_pc_ns priv_pc_hp priv_ns_hp priv_pj_pr_pf priv_pj_pr_pc priv_pj_pr_ns priv_pj_pr_hp priv_pj_pf_pc priv_pj_pf_ns priv_pj_pf_hp priv_pj_pf_ns priv_pj_pf_hp priv_pj_pc_ns priv_pj_pc_hp priv_pj_ns_hp priv_pr_pf_pc priv_pr_pf_ns priv_pr_pf_hp priv_pr_pf_ns priv_pr_pf_hp priv_pr_pc_ns priv_pr_pc_hp priv_pr_ns_hp priv_pf_pc_ns priv_pf_pc_hp priv_pf_ns_hp priv_pc_ns_hp priv_pj_pr_pf_pc priv_pj_pr_pf_ns priv_pj_pr_pf_hp priv_pj_pf_pc_ns priv_pj_pf_pc_hp priv_pr_pf_pc_ns priv_pr_pf_pc_hp priv_pr_pc_ns_hp privjob privservices privfinancing privschool1 numprivschool healthpriv

loc counter: word count `private_services'
foreach var of varlist `private_services' {
	* Storing point estimates and standard errors for IV on accepted voucher:
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[offered]
	loc se_`var' = _se[offered] * 1.96

	mat plot_private_services = nullmat(plot_private_services) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and standard errors for IV on accepted voucher:
	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[accepted]
	loc se_`var' = _se[accepted] * 1.96

	mat a_private_services = nullmat(a_private_services) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on enrolled:
	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[enrolled]
	loc se_`var' = _se[enrolled] * 1.96

	mat e_private_services = nullmat(e_private_services) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after two years:
	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_two]
	loc se_`var' = _se[private_two] * 1.96

	mat priv2_private_services = nullmat(priv2_private_services) \ `b_`var'', `se_`var'', `counter'

	* Storing point estimates and ses for IV on Private after four years:
	qui ivregress 2sls `var' (private_end = offered) `fixed_effects', cl(schoolcode_base)
	loc b_`var' = _b[private_end]
	loc se_`var' = _se[private_end] * 1.96

	mat priv4_private_services = nullmat(priv4_private_services) \ `b_`var'', `se_`var'', `counter'

	loc l_private_services_`counter': var label `var'

	loc counter = `counter' - 1
}

**************
* Generating Comparison Table between sample and census data
**************

*KEEPING VARIABLES OF INTEREST:
keep school agriculture caste_ST caste_SC unemployed agriculture_other state_district V_CT_CODE

*CLEANING VARIABLES THAT ARE NOT PROPERLY CLEANED
g lit = 1 if school > 6
replace lit = 0 if school <= 6
replace lit = . if school == .

g agri = 1 if agriculture == 1 | agriculture_other == 1
replace agri = 0 if agri == .

*GENERATING SAMPLE SUMMARY STATS:
qui summ lit if lit == 1
loc per_lit = round((`r(N)' / 1202) * 100, .01)
qui summ agri if agri == 1
loc per_agri = round((`r(N)' / 1202) * 100, .01)
qui summ unemployed if unemployed == 1
loc per_unemployed = round((`r(N)' / 1202) * 100, .01)
qui summ caste_SC if caste_SC == 1
loc per_sc = round((`r(N)' / 1202) * 100, .01)
qui summ caste_ST if caste_ST == 1
loc per_st = round((`r(N)' / 1202) * 100, .01)

cap mat drop temp_1
mat temp_1 = `per_lit' \ `per_agri' \ `per_unemployed' \ `per_sc' \ `per_st'

*GETTING PUS FROM SURVEY DATA:
keep state_district V_CT_CODE
duplicates drop state_district V_CT_CODE, force
drop if V_CT_CODE == .
tempfile pus
save `pus'

*CREATING VILLAGE LEVEL AVERAGES FOR SAMPLE VILLAGES:

*CLEANING RURAL DIRECTORY CODES TO MATCH 2001 CENSUS CODES WITH 2011 CENSUS CODES:
use "`census'/rdir.dta", clear
destring plcn2001, replace
drop if plcn2001 == 0 | plcn2001 == .

*RENAMING VARIABLES TO MATCH FULL CENSUS NAMING CONVENTIONS
ren mdds_stc State
ren mdds_dtc District
ren mdds_subdt Subdistt
ren mdds_plcn TownVillage
keep if State == "28" & (District == "533" | District == "535" |  District == "544" | District == "545" | District == "551")
destring TownVillage, replace

tempfile temp
save `temp', replace

*CLEANING 2011 PCA AND KEEPING VILLAGE LEVEL VARIABLES OF INTEREST:
use "`census'/pca_census11_india.dta", clear
keep if Level == "VILLAGE"
keep if State == "28" & (District == "533" | District == "535" |  District == "544" | District == "545" | District == "551")

keep No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P P_06 State District Subdistt TownVillage
destring TownVillage, replace

merge 1:1 State District TownVillage using `temp'
drop _merge
destring _all, replace
compress

*Generating state district codes to merge with pus from survey data
ren plcn2001 V_CT_CODE
drop if V_CT_CODE == .
tostring stc2001 dtc2001, replace
g x = "0" if length(dtc2001) == 1
egen state_district = concat(stc2001 x dtc2001)
destring state_district, replace
drop x stc2001 dtc2001

g non_working_adults = NON_WORK_P - P_06

*Collapsing villages that split between 2001 and 2011:
collapse (sum) No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P non_working_adults, by(state_district V_CT_CODE)

merge 1:1 state_district V_CT_CODE using `pus'
keep if _merge == 3
drop _merge

*Creating tables:
loc per_sc = round((P_SC / TOT_P) * 100, .01)
loc per_st = round((P_ST / TOT_P) * 100, .01)
loc per_lit=round((P_LIT / TOT_P) * 100, .01)
loc per_unemployed = round((non_working_adults / TOT_P) * 100, .01)
loc per_agri = round((MAIN_AL_P / MAINWORK_P) * 100, .01)

cap matrix drop village_level
mat village_level = `per_lit' \ `per_agri' \ `per_unemployed' \ `per_sc' \ `per_st'

*District level averages:
use "`census'/cens2011_subdist_Rural.dta", clear

compress
destring _all, replace
preserve

*Survey districts:
keep if state_name == "ANDHRA PRADESH"
keep if district_name == "East Godavari" | district_name == "Medak" | district_name == "Nizamabad" | district_name == "Visakhapatnam" | district_name == "Y.S.R."

keep district_name No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P P_06

g non_working_adults = NON_WORK_P - P_06

collapse (sum) No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P non_working_adults, by(district_name)

*Creating tables:
loc per_sc = round((P_SC / TOT_P) * 100, .01)
loc per_st = round((P_ST / TOT_P) * 100, .01)
loc per_lit = round((P_LIT / TOT_P) * 100, .01)
loc per_unemployed = round((non_working_adults / TOT_P) * 100, .01)
loc per_agri = round((MAIN_AL_P / MAINWORK_P) * 100, .01)

cap matrix drop temp_2
mat temp_2 = `per_lit' \ `per_agri' \ `per_unemployed' \ `per_sc' \ `per_st'

restore

keep No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P TOT_WORK_P TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P P_06

g non_working_adults = NON_WORK_P - P_06
* pause

*Getting nationwide averages:
g India = 1
collapse (sum) No_HH TOT_P TOT_M TOT_F P_SC P_ST P_LIT P_ILL TOT_WORK_P MAIN_AL_P NON_WORK_P MAINWORK_P non_working_adults, by(India)

loc per_sc = round((P_SC / TOT_P) * 100, .01)
loc per_st = round((P_ST / TOT_P) * 100, .01)
loc per_lit = round((P_LIT / TOT_P) * 100, .01)
loc per_unemployed = round((non_working_adults / TOT_P) * 100, .01)
loc per_agri = round((MAIN_AL_P / MAINWORK_P) * 100, .01)

cap matrix drop temp_3
mat temp_3 = `per_lit' \ `per_agri' \ `per_unemployed' \ `per_sc' \ `per_st'

mat define comparison = temp_1, village_level, temp_2, temp_3

clear
svmat comparison
g var_name = ""
replace var_name = "Literate (%)" in 1
replace var_name = "Agricultural Labor (%)" in 2
replace var_name = "Unemployed (%)" in 3
replace var_name = "Scheduled Caste (%)" in 4
replace var_name = "Scheduled Tribe (%)" in 5
order var_name
outsheet using "`tables'/sample_comparison.csv", comma replace

**************
* Calculating Attrition Rates:
**************

use "`clean'/survey_clean.dta", clear

qui summ attrition if offered == 1 & attrition == 1
loc treat = r(N)
qui summ attrition if offered == 0 & attrition == 1
loc control = r(N)
qui ttest attrition, by(offered)
mat attrition = nullmat(attrition) \ r(mu_2) * 100, r(mu_1) * 100, (r(mu_2) - r(mu_1)) * 100 \ `treat', `control', r(se)

**************
* Exporting tables and figures in main body of paper for creation in R
**************

* Balance test tables:
clear
svmat balance
outsheet using "`tables'/balance.csv", comma replace

*Outsheeting summary stats
clear
svmat summary
g var_name = ""
forval i = 1/`num_vars_summary' {
	replace var_name = "`var_`i''" in `i'
}
order var_name
format summary1 summary2 summary4 summary5 %12.2f
format summary3 summary6 %12.0f
tostring _all, replace
outsheet using "`tables'/summary.csv", comma replace

*Outsheeting appendix summary stats:
clear
svmat summaryappendix
g var_name = ""
forval i = 1/`num_vars_summary_appendix' {
	replace var_name = "`var_`i'_appendix'" in `i'
}
order var_name
format summaryappendix1 summaryappendix2 summaryappendix4 summaryappendix5 %12.2f
format summaryappendix3 summaryappendix6 %12.0f
tostring _all, replace
outsheet using "`tables'/summaryappendix.csv", comma replace

* Figures for analysis:
foreach x in plot_part plot_nonpart plot_privatisation plot_valuation plot_english plot_monitoring plot_evaluation {
	clear
	svmat `x'

	ren `x'1 beta
	ren `x'2 se
	ren `x'3 yaxis
	outsheet using "`figures'/`x'.csv", comma replace
}

* Attrition Table:
clear
svmat attrition
g var_name = ""
replace var_name = "Households Reached (%)" in 1
replace var_name = "Total Households Reached" in 2
order var_name
outsheet using "`tables'/attrition_raw.csv", comma replace

*******************
* Non-Submission Tables and Figures
*******************

use "`clean'/survey_clean.dta", clear

* Full Regression Tables:
foreach var of varlist `pol_participation_voting' {
	qui reg `var' offered `fixed_effects', cl(schoolcode_base)
	eststo offered

	qui reg `var' offered `controls' `fixed_effects', cl(schoolcode_base)
	eststo offeredcontrols

	qui ivregress 2sls `var' (accepted = offered) `fixed_effects', cl(schoolcode_base)
	eststo accepted

	qui ivregress 2sls `var' (accepted = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo acceptedcontrols

	qui ivregress 2sls `var' (enrolled = offered) `fixed_effects', cl(schoolcode_base)
	eststo enrolled

	qui ivregress 2sls `var' (enrolled = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo enrolledcontrols

	qui ivregress 2sls `var' (private_two = offered) `fixed_effects', cl(schoolcode_base)
	eststo private_two

	qui ivregress 2sls `var' (private_two = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_twocontrols

	qui ivregress 2sls `var' (private_end = offered `fixed_effects') `fixed_effects', cl(schoolcode_base)
	eststo private_end

	qui ivregress 2sls `var' (private_end = offered) `controls' `fixed_effects', cl(schoolcode_base)
	eststo private_endcontrols

	* Exporting for Submission
	esttab offered offeredcontrols accepted acceptedcontrols enrolled enrolledcontrols private_two private_twocontrols private_end private_endcontrols using "`tables'/`var'.tex", replace mgroup("Voucher Winner" "Accepted Voucher" "Enrolled in Private School" "Private School after Two Years" "Private School after Four Years", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ml(none) label wrap booktabs se(3) b(3) nonote nofloat compress mtitle("") star(* .1 ** .05 *** .01) drop(dist_? _cons) order(offered accepted enrolled private_two private_end) substitute(% \%)
	estimates clear
}

* Outsheeting variations on index for political participation:
foreach var in political_participation associational_activity private_services {
	clear
	svmat plot_`var'
	count
	loc counter = r(N)

	g var_name = ""
	forval i = 1/`counter' {
		replace var_name = "`l_`var'_`i''" in `i'
	}
	order var_name
	tostring _all, replace
	outsheet using "`figures'/plot_`var'.csv", comma replace

	clear
	svmat a_`var'
	g var_name = ""

	forval i = 1/`counter' {
		replace var_name = "`l_`var'_`i''" in `i'
	}
	order var_name
	tostring _all, replace
	outsheet using "`figures'/a_`var'.csv", comma replace

	clear
	svmat e_`var'
	g var_name = ""
	forval i = 1/`counter' {
		replace var_name = "`l_`var'_`i''" in `i'
	}
	order var_name
	tostring _all, replace
	outsheet using "`figures'/e_`var'.csv", comma replace

	clear
	svmat priv2_`var'
	g var_name = ""
	forval i = 1/`counter' {
		replace var_name = "`l_`var'_`i''" in `i'
	}
	order var_name
	tostring _all, replace
	outsheet using "`figures'/priv2_`var'.csv", comma replace

	clear
	svmat priv4_`var'
	g var_name = ""
	forval i = 1/`counter' {
		replace var_name = "`l_`var'_`i''" in `i'
	}
	order var_name
	tostring _all, replace
	outsheet using "`figures'/priv4_`var'.csv", comma replace
}

exit
