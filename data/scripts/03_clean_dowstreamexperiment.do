version 16
clear all
set more off
pause on
cap log close
set logtype text

* Setting Directories:
loc user : env USERPROFILE

* You will need to set your own directories here:
if "`c(os)'" == "MacOSX" {
	loc root "~/Dropbox/Research/Underway/cps-downstream/data"
}
else {
	loc root "`user'/Dropbox/Research/Underway/cps-downstream/data"
}
loc raw "`root'/raw"
loc clean "`root'/clean"
loc scripts "`root'/scripts"
loc tables "`root'/output/tables"
loc figures "`root'/output/figures"
loc qje "`root'/raw/qje"

*************************************
*Name: clean_downstreamexperiment.do
*Purpose: Cleans the main survey file for the downstream experiment and provides census village codes to match with census data
* User written packages: center, make_index
* center can be installed through ssc by typing `ssc install center'
* make_index can be found here: https://github.com/cdsamii/make_index (last accessed 2020/03/23) or from the author
*************************************

* Load raw data from CSPro converted in Stata format
use "`raw'/survey_import.dta", clear

* MERGING WITH SURVEY SAMPLE LIST TO GET TREATMENT STATUS:
tostring apfstudentcode, replace
cap duplicates drop apfstudentcode, force
merge 1:1 apfstudentcode using "`raw'/downstream_sample_third.dta", keepus(schooltype_end medium schooltype_base gender age_base caste religion offered offer status schoolcode_base schoolcode_end schooltype_2010)
keep if _merge == 3
drop _merge

* MERGING WITH ELECTION DATA:
*Correcting incorrectly entered pu_codes:
replace pu_code=12704 if apfstudentcode=="106632014" | apfstudentcode=="106571987"
replace pu_code=13525 if apfstudentcode=="108745739"

replace pu_code=23432 if apfstudentcode=="207692109"
replace pu_code=25727 if apfstudentcode=="220188276"
replace pu_name="RAJOLU" if pu_code==5727

replace pu_code=31103 if apfstudentcode=="305040379" | apfstudentcode=="305042362"
replace pu_code=31027 if pu_name=="PORUMAMILLA"
replace pu_code=31209 if apfstudentcode=="306387383"
replace pu_code=34530 if apfstudentcode=="312552612"

replace pu_code=42339 if apfstudentcode=="401766365"
replace pu_code=43907 if apfstudentcode=="411606364" | apfstudentcode=="411656934"
replace pu_code=43908 if apfstudentcode=="412178631"
replace pu_name="POTHIREDDYPALLY" if pu_code==43628

replace pu_code=52304 if apfstudentcode=="508387808"

replace pu_code=52609 if pu_code==52069

************************
* FIRST PAGE:
************************
lab define surveyor 1 Rajani 2 KSR 3 Anil 4 Veeru 5 Pasha 6 Gnanesh 7 Venu 8 Murali 9 Ramaiah 10 Lakshumaiah 11 Ramesh

replace surveyor="1" if surveyor=="Rajani" | surveyor=="M RAJANI"
replace surveyor="2" if surveyor=="KSR" | surveyor=="K SR" | surveyor=="K SRINIVASA RAO" | surveyor=="K SRINIVASARAO" | surveyor=="K SRINIVAS RAO"
replace surveyor="3" if surveyor=="Anil" | surveyor== "D A B" | surveyor=="D AB" | surveyor=="D ANNAYYA BABU" | surveyor=="D ANNAYYABABU" | surveyor=="D ANNAYYA BAB" | surveyor=="DANNAYYA BABU"
replace surveyor="4" if surveyor=="Veeru" | surveyor=="B VN"  | surveyor=="B VEERANAID" | surveyor=="B VEERA NAID" | surveyor=="VEERANAID B" | surveyor=="B VEERA NAIDU" | surveyor=="B VEEREA NAIDU" | surveyor=="VEERANAID" | surveyor=="B VEERUNAID" | surveyor=="B  VEERANAID" | surveyor=="B VEEERANAID" | surveyor=="B VEEERU NAID" | surveyor=="B VEERU NAID" | surveyor=="E VEERA NAID" | surveyor=="VEERA NAID B" | surveyor=="VEERANAIDU"
replace surveyor="4" if apfstudentcode=="206768217"
replace surveyor="5" if surveyor=="Pasha" | surveyor=="MD AP" | surveyor=="MD AHMED PASHA" | surveyor=="MD PASHA" | surveyor=="MOHAMED PASHA"
replace surveyor="6" if surveyor=="Gnanesh" | surveyor=="K GNANESHWER" | surveyor=="K GNAN"
replace surveyor="7" if surveyor=="Venu" | surveyor=="B VENUGOPAL" | surveyor=="BVN" | surveyor=="B VENU GOPAL" | surveyor=="B V G" | surveyor=="B VG" | surveyor=="K VENU GOPAL"
replace surveyor="8" if surveyor=="Murali" | surveyor=="P MURALI" | surveyor=="P RAMULU" | surveyor=="MURALI"
replace surveyor="9" if surveyor=="Ramaiah" | surveyor=="N VENKATA RAMIAH" | surveyor=="N VENKATA RAMAIAH" | surveyor=="N V RAM" | surveyor=="N VR"
replace surveyor="10" if surveyor=="Lakshumaiah" | surveyor=="N KAKSHU" | surveyor=="N LAKSH" | surveyor=="N LAKSHU" | surveyor=="N LAKSHUMAIAH" | surveyor=="N LAKSHuMAIAH" | surveyor=="N LAXM"
replace surveyor="11" if surveyor=="Ramesh" | surveyor=="H RAMESH" | surveyor=="M RAMESH" | surveyor=="HANUMANTHU RAMESH"
replace surveyor="11" if apfstudentcode=="304245942" | apfstudentcode=="303146075" | apfstudentcode=="303716476" | apfstudentcode=="303758441" | apfstudentcode=="304399167" | apfstudentcode=="304705321"
replace surveyor="." if surveyor=="NEAR SCHOOL BEHIND" | surveyor=="NEAR MAZEED BERAKHAN PALL"

*Manually entering missing surveyor codes:
replace surveyor="1" if apfstudentcode=="100688964" | apfstudentcode=="107106001"
replace surveyor="3" if apfstudentcode=="108930989" | apfstudentcode=="109297738" | apfstudentcode=="109164125" | apfstudentcode=="110323002" | apfstudentcode=="110578694"
replace surveyor="4" if apfstudentcode=="203182974" | apfstudentcode=="202911127" | apfstudentcode=="206739894"
replace surveyor="5" if apfstudentcode=="500176260"
replace surveyor="6" if apfstudentcode=="501283589" | apfstudentcode=="510053451"
replace surveyor="8" if apfstudentcode=="400031356"
replace surveyor="9" if apfstudentcode=="308882369" | apfstudentcode=="309323279"
replace surveyor="10" if apfstudentcode=="319490539" | apfstudentcode=="311421922" | apfstudentcode=="312536500"
replace surveyor="10" if pu_code==34140 & surveyor==""
replace surveyor="11" if apfstudentcode=="304348039"

destring surveyor, replace
lab val surveyor surveyor

* Generating surveyor dummies:
qui tab surveyor, g(surveyor_)

************************
* SECTION 1:
************************
recode gender (2 = 0)
ren gender male

* Replacing incorrectly entered gender:
replace male=0 if apfstudentcode=="101819572"
replace male=0 if apfstudentcode=="206768217"
replace male=1 if apfstudentcode=="208192939"
replace male=1 if apfstudentcode=="208671516"
replace male=1 if apfstudentcode=="208558896"
replace male=1 if apfstudentcode=="220235002"
replace male=1 if apfstudentcode=="404954422"
lab var male "Male"

qui tab caste, g(caste_)
ren caste_1 caste_general
ren caste_2 caste_OBC
cap ren caste_3 caste_SC
cap ren caste_4 caste_ST
drop caste
lab var caste_general "General Caste"

*Cleaning Age
replace age=. if apfstudentcode=="100576191" |apfstudentcode=="101372845" | apfstudentcode=="300386359" | apfstudentcode=="300699346" | apfstudentcode=="301348538" | apfstudentcode=="302223832" | apfstudentcode=="302891205" | apfstudentcode=="302893165" | apfstudentcode=="303033039" | apfstudentcode=="303067048" | apfstudentcode=="308637003" | apfstudentcode=="309553642" | apfstudentcode=="311978828" | apfstudentcode=="506567651" /*Age was either 0 or 99 in all these cases (or 9 in one case)*/
replace age=40 if apfstudentcode=="510068435"
replace age=41 if apfstudentcode=="103511894" | apfstudentcode=="200661446"
replace age=. if age<18 | age==99
lab var age "Age"

qui tab religion, g(religion_)
ren religion_1 rel_hindu
ren religion_2 rel_muslim
recode religion (1 2=0) (3 4 5 6 7 8=1), g(rel_other)
cap drop religion_3-religion_8
lab var rel_hindu "Hindu"
lab var rel_muslim "Muslim"

* Cleaning education
replace school=. if school==35
lab var school "Education"

lab var school_children "No. School Children in HH"

* Cleaning Income

***************************
*replace what_is_the_average_daily_wage_t=0 if daily_wage_labour==2
 
* Cleaning Ramesh's incorrectly entered income:
replace what_is_the_average_daily_wage_t=12000 if surveyor==11 & apfstudentcode=="303716476"
replace what_is_the_average_daily_wage_t=10000 if surveyor==11 & apfstudentcode=="304399167"
g ramesh_salary=what_is_the_average_daily_wage_t if surveyor==11 & daily_wage_labour==1
replace what_is_the_average_daily_wage_t=. if surveyor==11 & daily_wage_labour==1

* Cleaning small errors on income:
replace ramesh_salary=what_is_the_average_daily_wage_t if surveyor==2 & apfstudentcode=="110213186"
replace what_is_the_average_daily_wage_t=. if surveyor==2 & apfstudentcode=="110213186"

replace ramesh_salary=what_is_the_average_daily_wage_t if surveyor==2 & apfstudentcode=="110203887"
replace what_is_the_average_daily_wage_t=. if surveyor==2 & apfstudentcode=="110203887"

replace what_is_the_average_daily_wage_t=13500/90 if apfstudentcode=="203798305" & surveyor==4 /*Seasonal wage labour - how to properly code this?*/
replace what_is_the_average_daily_wage_t=7500/90 if apfstudentcode=="206775384" & surveyor==4 /*Seasonal wage labour - how to properly code this?*/
replace what_is_the_average_daily_wage_t=2000/60 if surveyor==4 & apfstudentcode=="210457756" /*Coconuts once every 2 months*/

replace what_is_their_total_salary=. if apfstudentcode=="312102561" & surveyor==10 /*DEO entered wage earnings into salary field*/
replace what_is_the_average_daily_wage_t=60 if apfstudentcode=="311421922"

replace what_is_the_average_daily_wage_t=4000/30 if surveyor==8 & apfstudentcode=="403341111"

* Cleaning salary lines that are 0:
replace what_is_the_average_daily_wage_t=. if apfstudentcode=="206768217" | apfstudentcode=="408825527" | apfstudentcode=="500757381" | apfstudentcode=="505342277" | apfstudentcode=="510521817" | apfstudentcode=="510531448" | apfstudentcode=="510471039" | apfstudentcode=="510528709" | apfstudentcode=="510533753" | apfstudentcode=="510460625" | apfstudentcode=="510607462" | apfstudentcode=="510520177" | apfstudentcode=="510462622"

recode what_is_the_average_daily_wage_t (9 8888 999 9999=.)

* Cleaning Salary:

* Replacing incorrectly entered salary data:
replace salaried=1 if apfstudentcode=="202911127"
replace salaried=2 if apfstudentcode=="206683177"
replace salaried=2 if apfstudentcode=="304767270"
replace salaried=2 if apfstudentcode=="403454915"

replace what_is_their_total_salary=3000 if apfstudentcode=="206924723"
replace no_salary=. if apfstudentcode=="206924723"

replace what_is_their_total_salary=. if apfstudentcode=="508387808"

replace what_is_their_total_salary=15000 if apfstudentcode=="312102561"

*Cleaning Salaried Employees in household:
recode salaried (2=0) (3/9=.)
recode what_is_their_total_salary (9 999 88888 99999 888888 999999=.)

replace what_is_the_average_daily_wage_t=what_is_the_average_daily_wage_t*30
egen hh_income=rowtotal(what_is_the_average_daily_wage_t what_is_their_total_salary ramesh_salary)
replace hh_income=1 if hh_income==0
replace hh_income=. if hh_income==9999

*Generating log incomes
g hh_income_log=log(hh_income)
drop daily_wage_labour no_labourers what_is_the_average_daily_wage_t no_salary what_is_their_total_salary
lab var hh_income "Household Income"
lab var hh_income_log "Household Income"
lab var salaried "Salaried Employees"

* Cleaning Land variables:
recode cents acre (99 99.99 999 =.)
replace cents=0 if cents==100 & acre==1 & (surveyor==2 | surveyor==11)
replace acre=1.5 if cents==150 & (acre==1 | acre==2) & surveyor==11
replace cents=0 if cents==150 & surveyor==11 & acre==1.5
replace cents=0 if (cents==200 & acre==2) & surveyor==11
replace cents=0 if (cents==300 & acre==3) & surveyor==11

replace acre=2 if apfstudentcode=="404743309"
replace acre=1 if apfstudentcode=="508495132"
replace acre=2 if apfstudentcode=="413325931"
replace acre=3 if apfstudentcode=="414962622"

g hh_land=(100*acre)+cents
replace hh_land=.1 if hh_land==0
g log_land=log(hh_land)
drop cents acres

************************
* SECTION 2:
************************

drop child_school_gov_6-child_school_gov_8 /*No children in school past 5th child*/

* Cleaning child age variables:
forval i = 1/5 {
	recode child_age_`i' (99 = .)
}

* Generate dummy if they have an older sibing
g older_sibling = (child_age_1 < child_age_2)
replace older_sibling = 0 if (child_age_1 > child_age_2)

g same_school_older_sibling = 1 if (child_school_type_1 == child_school_type_2) & (child_school_gov_1 == child_school_gov_2) & (child_lang_1 == child_lang_2) & older_sibling == 1
replace same_school_older_sibling = 0 if older_sibling == 1 & same_school_older_sibling == .

forval i=1/5 {
	recode child_school_gov_`i' (1 3=0) (2 4=1) (9=.), g(priv_school_`i')
	lab var priv_school_`i' "Child `i' in Private School"
}

g same_school_private = same_school * priv_school_1

egen numprivschool=rowtotal(priv_school_1 priv_school_2 priv_school_3 priv_school_4 priv_school_5)
egen non_voucher_priv=rowtotal(priv_school_2 priv_school_3 priv_school_4 priv_school_5)
egen school_age_children=rownonmiss(priv_school_1 priv_school_2 priv_school_3 priv_school_4 priv_school_5)
egen non_voucher_school_age=rownonmiss(priv_school_2 priv_school_3 priv_school_4 priv_school_5)
g per_child_priv=numprivschool/school_age_children
g per_non_voucher_priv=non_voucher_priv/non_voucher_school_age

*PRIVATE TUITION:
drop child_priv_tuition_6-child_priv_tuition_8 child_priv_amount_5 child_priv_amount_6 child_priv_amount_7 child_priv_amount_8

forval i=1/5 {
	recode child_priv_tuition_`i' (2=0) (3 4 9=.)
	lab var child_priv_tuition_`i' "Send Child `i' to Private Tuition?"
}
egen num_priv_tuition=rowtotal(child_priv_tuition_1 child_priv_tuition_2 child_priv_tuition_3 child_priv_tuition_4)
g per_child_priv_tuition=num_priv_tuition/school_age_children
forval i=1/4 {
	recode child_priv_amount_`i' (2 99 999 2222 8888 9000 9999=.)
	replace child_priv_amount_`i'=. if child_priv_tuition_`i'==2
	lab var child_priv_amount_`i' "How much do you pay for Child `i''s Private Tuition?"
}
egen tuition_total=rowtotal(child_priv_amount_1 child_priv_amount_2 child_priv_amount_3 child_priv_amount_4)

lab var priv_school_1 "Voucher Child Continued in Private School"
lab var numprivschool "Number of Children in Private Schools in Household"
lab var school_age_children "Number of School Age Children in Household"
lab var per_child_priv "Percentage of Children in Household in Private Schools"
lab var non_voucher_priv "Number of non-voucher children in private schools"
lab var non_voucher_school_age "Number of Non-Voucher Children of School Age"
lab var per_non_voucher_priv "Percentage of Non-Voucher Children in Private Schools"
lab var tuition_total "Total Amount Spent on Children's Tuition"
loc var per_child_priv_tuition "Percentage of Children in Private Tuition"

*DHAN foundation
replace health_sick_location=4 if health_sick_location==8
recode health_sick_location (1=0) (2 3 4 5 6 7 8=1) (9=.), g(healthpriv)
lab var healthpriv "Choice of Private Health Facility"

recode water_gov_connect (2 4 5 6=1) (1 3=0), g(water_priv)

recode elec_home (2=0)

* SATISFACTION WITH PUBLIC SERVICES INDEX:
recode water_satisfied elec_satisfy bpl_satisfaction (0 6 8 9=.) (1=5) (2=4) (3=3) (4=2) (5=1)
ren elec_satisfy elec_satisfied
ren bpl_satisfaction bpl_satisfied
g satisfaction_index=water_satisfied+elec_satisfied+bpl_satisfied
g satisfaction_index_no_water=elec_satisfied+bpl_satisfied

*Cleaning Schools Quality variable:
recode school_overall_qual (1=5) (2=4) (4=2) (5=1) (6=0) (7=.), g(school_qual_dk)
recode school_overall_qual (1 2=1) (3 4 5=0) (6 7=.), g(school_qual_compress)
recode school_overall_qual (1=4) (2=3) (3=2) (4=1) (5=0) (6 7=.)
lab var school_qual_compress "School Quality"

*Cleaning teacher and school level street-level bureaucrat variables:
recode school_present (1=4) (2=3) (3=2) (4=1) (5 6=.)
recode school_phone_number (2=0) (3 4 9=.) /*9s are missing*/
recode school_meet_invite (2=0) (3 4 9=.) /*9s are missing*/
recode school_meet_attend (2=0) (3 4 9=.) /*9s are missing*/
recode school_meet_same_day (1=2) (2=1) (3=0) (4 5 9=.) /* Two 9s are "Never Went"*/
recode school_problem_solve (1=2) (2=1) (3=0) (4=3) (5 6 9=.) /*9s are missing*/
recode school_days (88 99=.)
recode school_hours_per_day (0=.)
recode school_building_qual (1=4) (2=3) (3=2) (4=1) (5=0) (6 7 9=.) /*9s as missing*/
recode school_teacher_qual (1=4) (2=3) (3=2) (4=1) (5=0) (6 7=.)

*Cleaning teacher effort variables:
recode school_teach_month (2=.)
recode school_days (88/99=.)

recode school_hours_day (2/9=.)
recode school_hours_per_day (0=.)

*Cleaning transfer certificate payment variables:
recode school_informal_tc (2=0) (3/9=.)
recode school_informal_tc_amount (8888/9999=.)
replace school_informal_tc_amount=. if school_informal_tc==0

*Index of school quality:
factor school_problem_solve school_building_qual school_teacher_qual school_overall_qual, pcf
rotate
predict factor1
ren factor1 experience_index
lab var experience_index "School Experiences"

*Cleaning school preference variable:
recode school_preference (1 4 6=0) (2 3 5 7 8=1), g(pref_private)
replace pref_private=0 if (school_admit==1 | school_admit==4 | school_admit==6) & school_preference==9
replace pref_private=1 if (school_admit==2 | school_admit==3 | school_admit==5 | school_admit==7 | school_admit==8) & school_preference==9
replace pref_private=. if pref_private==9 | pref_private==99
lab var pref_private "Prefer Private Schools"

* Labelling Variables:
lab var school_problem_solve "School Solves Problems"
lab var school_building_qual "School Buildings are of Good Quality"
lab var school_teacher_qual "School Teachers are of Good Quality"
lab var school_overall_qual "School is of Good Quality"

************************
* SECTION 3
************************

recode assc_caste assc_coops assc_shg (2=0) (3 4 9=.)
recode assc_memb_smc assc_memb_amc (2=0) (3 4 5 9=.)
recode assc_attend_smc assc_attend_amc (2=0) (3 4 5 8 9=.)

g assc_memb_school=1 if assc_memb_smc==1 | assc_memb_amc==1
replace assc_memb_school=0 if (assc_memb_smc==0 | assc_memb_amc==0) & assc_memb_school==.
g assc_attend_school=1 if assc_attend_smc==1 | assc_attend_amc==1
replace assc_attend_school=0 if (assc_attend_smc==0 | assc_attend_amc==0 ) & assc_attend_school==.

ren assc_* assc*
ren asscmemb_school asscmembschool
ren asscattend_school asscattendschool

lab var assccaste "Member of a Caste Association"
lab var assccoops "Member of a Cooperative or Labor Union"
lab var asscshg "Member of a Self-Help Group"
lab var asscmembschool "Member of a School Committee"
lab var asscattendschool "Attend School Committees"

************************
* SECTION 4
************************
lab define yesno 0 No 1 Yes
lab define vote_next_election 0 No 1 Yes 3 "Don't Know/Undecided"
lab define undecided 0 Undecided 1 Decided
lab define same 0 "Different Party" 1 "Same Party"

*CLEANING VOTING QUESTIONS:
recode pol_vote_ls_2009 (3 4 9 = .) (1 = 0) (2 = 1), g(vote_ls_2009)
lab val vote_ls_2009 yesno

recode pol_vote_ls_2014 (3 4 5 6 8 9=.) (2=0), g(vote_ls_2014)
lab val vote_ls_2014 vote_next_election

replace pol_vote_ls_same = . if pol_vote_ls_2009 == 1 | pol_vote_ls_2009 == 3 | pol_vote_ls_2014 == 2
replace pol_vote_ls_same = 4 if pol_vote_ls_2014 == 3

*Cleaning individual entries that were entered incorrectly:
replace pol_vote_ls_same = . if apfstudentcode=="209646188" | apfstudentcode=="303538819" | apfstudentcode=="303668888" | apfstudentcode=="303757127" | apfstudentcode=="303817857" | apfstudentcode=="305844388" | apfstudentcode=="510053451"
recode pol_vote_ls_same (1 2 5 = 1) (3 4 = 0) (6 = .), g(ls_undecided)
recode pol_vote_ls_same (2 = 0) (3 4 5 6 8 9 = .), g(vote_ls_same)
lab val ls_undecided undecided
lab val vote_ls_same same
drop pol_vote_ls_same
drop pol_vote_ls_2014

recode pol_vote_mla_2009 (1=0) (2=1) (3 4 9=.), g(vote_mla_2009)
lab val vote_mla_2009 yesno

recode pol_vote_mla_plan_2014 (2=0) (3 4 9=.), g(vote_mla_2014)
lab val vote_mla_2014 vote_next_election

replace pol_vote_mla_same=. if pol_vote_mla_2009==. | pol_vote_mla_2009==1 | pol_vote_mla_plan_2014==2 | pol_vote_mla_plan_2014==3 | pol_vote_mla_plan_2014==9
recode pol_vote_mla_same (1 2=1) (3 4=0) (5 6=.), g(mla_undecided)
recode pol_vote_mla_same (2=0) (3 4 5 6 8 9=.), g(vote_mla_same)
lab val mla_undecided undecided
lab val vote_mla_same same
drop pol_vote_mla_same pol_vote_mla_plan_2014 pol_vote_mla_2009

recode pol_vote_pan_2009 (1=0) (2=1) (3 4 9=.), g(vote_pan_2014)
lab val vote_pan_2014 yesno

replace pol_vote_pan_same=. if pol_vote_pan_2009==1 | pol_vote_pan_2009==3
replace pol_vote_pan_same=. if pol_vote_pan_same==9
recode pol_vote_pan_same (2 3=0) (4 5 9=.), g(vote_pan_same_diff_candidate)
recode pol_vote_pan_same (2=0) (3 4 5 9=.), g(vote_pan_same_same_candidate)
lab val vote_pan_same_diff_candidate vote_pan_same_same_candidate yesno
drop pol_vote_pan_same pol_vote_pan_2009

recode pol_party pol_gram_sabha pol_meeting pol_canvas pol_leaflets (2=0) (3 9 4=.)

ren pol_party polparty
ren pol_gram_sabha gramsabha
ren pol_meeting polmeeting
ren pol_canvas polcanvas
ren pol_leaflets polleaflets
ren vote_ls_2014 votels
ren vote_mla_2014 votemla
ren vote_pan_2014 votepan

lab var polparty "Member of a Political Party"
lab var gramsabha "Attended a Gram Sabha Meeting"
lab var polmeeting "Attended a Political Meeting"
lab var polcanvas "Canvassed for a Political Party"
lab var polleaflets "Distributed Leaflets for a Political Party"
lab var votels "Intend to Vote: Lok Sabha"
lab var votemla "Intend to Vote: Vidhan Sabha"
lab var votepan "Voted: Panchayat"
lab var pol_gov_school_monitor "Government Teachers Serve as Election Monitors"
lab var pol_gov_school_census "Government Teachers Serve as Census Enumerators"

* INTENTIONS AND REASONS TO VOTE:

* Cleaning variable:
replace pol_big_3="TAP CONNECTION" if pol_big_1=="TAP CONNECTION, AGRICULTUR"
replace pol_big_1="AGRICULTURE" if pol_big_1=="TAP CONNECTION, AGRICULTUR"
replace pol_big_2="ROADS" if apfstudentcode=="106296305"
foreach var of varlist pol_big_1-pol_big_3 {
	replace `var'="DRAINAGE" if regexm(`var', "DRIANAGE") | regexm(`var', "DRIANGE") | regexm(`var', "DRIANANGE") | regexm(`var', "DRYNAGE") | regexm(`var', "DRINAGE") | `var'=="DRAIANGE" | `var'=="PROVIDE TO DEVELOP VILLAGE"

	replace `var'="JOB" if regexm(`var', "DAILY WORK") | regexm(`var', "DAILY WAGES") | `var'=="BM PLOYMENT" | `var'=="EMPLEMENT" | `var'=="SKILL IMPROVEMENT TRAININ" | `var'=="EVERY FAMILY SHOULD WANT"

	replace `var'="TOILETS" if regexm(`var', "TOILTS") | regexm(`var', "TOLITS") | `var'=="LATREAN" | `var'=="LATRINS"  | regexm(`var', "BOTH ROOMS") | `var'=="PUBLIC & PRIVATE LAVETORY" | `var'=="SANITATION" | `var'=="PRIVATE & PUBLIC SANITARY" | `var'=="LATREANS" | `var'=="SANITHAION" | `var'=="GOVT SUPPORT TO CONSTRUCT" | `var'=="GOVERNMENT SHOULD SANCTIO" | `var'=="SANCTION OF PUBLIC & PROV" | `var'=="SANCTION OF PRIVATE & PUB" | `var'=="SAFETIC TANKS" | `var'=="BOOTH ROOMS"
	
	replace `var'="WATER" if regexm(`var', "TAP CONNECTION") | regexm(`var', "MORE POWERCUTS") | `var'=="BOREWELL" | `var'=="TAPS" | `var'=="MUNCIPAL TAPS" | `var'=="MUNICIPAL TAPS" | regexm(`var', "DRINKING W") | regexm(`var', "PUBLIC TAPS") | regexm(`var', "BORES PUMP") | `var'=="WATET" | `var'=="TO PROVIDE SUFFICIENT DRI" | regexm(`var', "MUNICIPAL TAP") | `var'=="SHOULD PROVIDE MUNICIPAL" | `var'=="DRINKING FACILITY" | `var'=="PUMP SET GIVE THE GOVERNM" | `var'=="BORE WELL"
	
	replace `var'="STREET LIGHTS" if `var'=="STREET LINGHTS" | `var'=="NO STREAT LIGHTS" | regexm(`var', "STREET LIGHT") | `var'=="STREAT LIGHT" | `var'=="STREEET LIGHTS" | `var'=="SOLUTION TO STREET ISSUES"
	
	replace `var'="NO ISSUES" if `var'=="NO ANSWER ON THE ISSUESS" | `var'=="NO ISSUES UNABLE TO SAY" | `var'=="NO OPTION"
	
	replace `var'="POVERTY" if regexm(`var', "POWERTY") | `var'=="DEVELOPMENT" | `var'=="HELP FOR POOR PEOPLE" | regexm(`var', "PENSION") | `var'=="SELF FINANCE OLD AGE PENS" | `var'=="PROTECTION SHOULD BE GIVE" | `var'=="PROTECTION OF WOMEN FROM" | `var'=="MORE OPPORTUNITY SUPPORT" | `var'=="PROVISION & PROPER IMPLEM" | `var'=="PROVIDING THE SCHEMES REL" | `var'=="GOVT SERVICES SHOULD BE W" | `var'=="FAMILY WHO HAVE 2 DAUGHTE" | `var'=="PENSION" | `var'=="PATIONS" | `var'=="HELP TRADITIONAL WORKERS" | `var'=="HELP FOR POOR PEOPLES" | `var'=="PENSON" | `var'=="DEVELOP TE WORK POOR PEO" | `var'=="DEVELOP THE WORK POOR PEO"
	
	replace `var'="EDUCATION" if `var'=="EDUCQATION" | `var'=="EDUCATE" | `var'=="NOTEBOOKS TO SCHOOLCHILDR" | `var'=="TO PROVIDE E/M FREE EDUCA" | `var'=="ENUCATION" | `var'=="ENGLISH MEDIAM SCHOOL GOV" | `var'=="INFRASTRUCTURE OF SCHOOLS" | `var'=="TO PROVIDE GOOD E/M EDUCA" | `var'=="COULD PROVIDE GOOD EDUCAT" | `var'=="EVENING TUTION" | `var'=="PRIMARY EDUCATINO MORE FA" | `var'=="VILLAGE INFRASTRUCTURE LI" | `var'=="TO GIVE QUALITSTIVE EDUCA" | `var'=="TO DEVELOP INFRASTRUCTURE" | `var'=="INSTALMENT FOR SCHOLOR SH" | `var'=="GOVT ESTABLISH ENGLISH ME" | `var'=="IMPROVEMENT IN EUDCATION"
	replace `var'="EDUCATION" if `var'=="EDUCATIN" | `var'=="PROVIDE SCHOLARSHP TO CH" | `var'=="CHILDRENS STUDY" | `var'=="COLLAGE" | `var'=="TION FOR CHILDREN GOVT HO" | `var'=="PROVIDE SCHOLARSHPI TO CH" | `var'=="PROVIDE SCHOLARSHIP TO CH" | `var'=="SCHOOL BUILDING & INFRAST" | `var'=="EDUCATIN FOR POOR FAMILIE" | `var'=="EDUCAITON GOOD & EMPLOYME" | `var'=="EDU" | `var'=="CHECK TELUGU"
	
	replace `var'="HOUSING" if `var'=="PAKKA HOUSE" | `var'=="PRIVEDE HOUSE SITS" | `var'=="PROVIDE HOUSES COLONY" | `var'=="OWN HOUSES FOR POOR PEOPLE" | `var'=="BUILDING OF COLONIES" | `var'=="PROVIDE GOVT SIT (FOR HOU" | `var'=="PROVIDE FOR COLONY SITES" | `var'=="PROVIDE COLONY SITES IN" | `var'=="RESIDENCY DEVELOPMENT" | `var'=="INDIRAMMA COLONY"
	
	replace `var'="ELECTRICITY" if `var'=="ELECTRICAL" | `var'=="FREE ELECYTRICITY" | `var'=="ELECTRACITY" | `var'=="ELECTRICT" | `var'=="ELECTRICTY" | `var'=="POWER CUTS" | `var'=="SHOULD PROVID ELECTRICIT" | `var'=="ELECTRICTION" | `var'=="ELECTRICITH" | `var'=="ELECTRIC POLLS, STREET LA" | `var'=="GIVE THE ELECITY 9 HOWER"
	
	replace `var'="TELANGANA" if `var'=="STAT SHOULD NOT BE DIVID" | regexm(`var', "TELENGANA") | `var'=="TELANGAN ISSUES" | `var'=="DIVISION OF STATE TELANGA" | `var'=="DIVISION OF A P" | `var'=="DON'T DIVID STATE" | `var'=="STATE SHOULD NOT BE DIVID" | `var'=="AP CONTINEW FOR AP" | `var'=="DON'T DIVIDE STATE"
	
	replace `var'="HEALTH" if regexm(`var', "HOSPITAL") | `var'=="HEAITH" | `var'=="HEALTH FACILITIES" | `var'=="ANGANWADI" | `var'=="ASHA WORKERS SHOULD BE MA" | `var'=="IONS GOVT HEALTH CENTRES" | `var'=="PROVIDING GOOD & HEALTHY" | `var'=="IMPROVE THE SANITARY CONI" | `var'=="IMPROVE HEALTH SERVICES" | `var'=="IMPROVE GOVT HEALTH SERVI" | `var'=="HEALTH SUPPORT IN RURAL" | `var'=="HEALTH RELATED ISSUES LIK" | `var'=="GOOD SERVICE & TREATMENT" | `var'=="DHOBI KHANA SHOULD BE CON" | regexm(`var', "HEALTH") | `var'=="SANITARY RELATED" | `var'=="SANATION" | `var'=="SUPPORT FOR CHILDREN HEAL" | `var'=="RECRUITMENT FOR SWEEPER" | `var'=="CLEANNING OF CANALS & ROA" | `var'=="SHOULD ESTABLISH GOVERNME"
	
	replace `var'="TRANSPORT" if `var'=="BUSSES FACILITY" | `var'=="TRANSPORT FACILITY SHOULD" | `var'=="BUS FACILITIES" | `var'=="BUS FACILITIES MORE" | `var'=="BUSSES"
	
	replace `var'="FLOOD RELIEF" if regexm(`var', "FLOOD RELIEF") | `var'=="HELP PARMERS WHIL FLODS" | `var'=="FLODER LIEF SUPPORT TO TR" | `var'=="PROBLEM WHILE FLOODS" | `var'=="FLOD RELIEF SUPPORT" | `var'=="GOVERNMENT ASSISTANCE TO" | `var'=="FLOD RELIEF"
	
	replace `var'="INFLATION" if `var'=="TO LOWEER THE RATES" | `var'=="HIGH RATES ON THE DAILY C" | `var'=="LOWERING THE RATES OF DAI" | `var'=="CHARGES" | `var'=="REDUCED FOR MARKET PIECES" | `var'=="HIGH RENTS"
	
	replace `var'="ROADS" if `var'=="SHOULD LAY DOWN THE STREE" | `var'=="PROVID TO DEVELOP VILLAGE" | `var'=="IMPROVEMENT OF VILLAGE RO"
		
	replace `var'="CORRUPTION" if `var'=="SHOULD DISTRIBUTE AMOUNT" | `var'=="SURVEY ELECTION"
	
	replace `var'="GOVERNANCE" if `var'=="ACCESS TO FLF" | `var'=="POLITICAL LEADERS SHOULD" | `var'=="GOVT SCHEAMS NOT REACHPOO" | `var'=="GOVT OFFICERS NOT WORKING" | `var'=="GOOD ADMISTRIOM"

	replace `var'="EMPLOYMENT" if `var'=="GOVT HELP FOR TRADITIONAL" | `var'=="SOME VOCATIONAL EMPLOYMEN" | `var'=="NON AGRI LABOUR" | `var'=="LIFE LONG WORKS"

	replace `var'="AGRICULTURE" if `var'=="CANALS IN THE FIELDS" | `var'=="HELPING FARMERS" | `var'=="HELP PARMERS WHILE FLOODS" | `var'=="SUPPORT TO FARMERS" | `var'=="INDIA DEVELOPMENT IN AGRI" | `var'=="IMPROVE THE RICE AND OTHE" | `var'=="AGRI INFRASTRUCTURE" | `var'=="SUPPLY OF PEUTICIDES OF"

	replace `var'="VILLAGE DEVELOPMENT" if `var'=="VILLAGE DEVELOMENT" | `var'=="DEVELOPMENT IN VILLAGE LE" | `var'=="DEVELOP THE KHUDAVANPUR" | `var'=="VILLAGE COMMUNITI HALL" | `var'=="INFRASTRUCTURE" | `var'=="DEVELOPMENT OF VILLAGE" | `var'=="COMMUNIT HALL" | `var'=="BUSSES & VILLAGE DEVELOPM" | `var'=="CARE FOR ALL VILLAGE" | `var'=="REDUCE IN VILLAGE LEVELS"

	replace `var'="PDS" if `var'=="RATIN GOOD QUALITY"

	replace `var'="CASTE" if `var'=="AMBEDKAR STATUE SHOULD BE" | `var'=="IMPROVE OUR CAST DEVELOPM" | `var'=="SC ST SUB PLANNING" | `var'=="CAST BUILDING"

	replace `var'="GENDER" if `var'=="LADIES PROBLEM" | `var'=="PROVIDING OPPORTUNITIES F"

	replace `var'="SECURITY" if `var'=="CONTROL THE TERRARIZAM"

	replace `var'="ALCOHOL" if `var'=="BAND THE HALKAHAL WINE SH"

	replace `var'="ECONOMIC GROWTH" if `var'=="OAN INDIA DEVELOP" | `var'=="INDIA SHOULD DEVELOP" | `var'=="IMPROVE THE AP INDIA"
	
	replace `var'="" if `var'=="TO APPAINT MORE THAN ONE" | `var'=="TO INTRODUCE HINDI & ENGL" | `var'=="REDUCE FOR ALL PROBLEM IN" | `var'=="PROVIDE FOR ALL THINGS TO" | `var'=="PROVIDE ALL THINGS TO PEO" | `var'=="LOCAL ISSUE" | `var'=="COMMUNITY ISSUES" | `var'=="PROVIDE FOR ALL THINGS" | `var'=="WORKS" | `var'=="SUBSIDY" | `var'=="SE GOOD RATES" | `var'=="PLATS PATALANI" | `var'=="IES" | `var'=="FENGTION" | `var'=="CONSTRUCTION FOR MASHED" | `var'=="ND PROVIDE"
}

g issue_telangana=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_telangana=1 if regexm(`var', "TELANGANA") | regexm(`var', "ANDHRA") | regexm(`var', "SAMYKYANDRA")
	replace `var'="" if regexm(`var', "TELANGANA") | regexm(`var', "ANDHRA") | regexm(`var', "SAMYKYANDRA")
}
replace issue_telangana=0 if issue_telangana==.

g issue_public_good=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_public_good=1 if  regexm(`var', "ROAD") | regexm(`var', "WATER") | regexm(`var', "DRAINAGE") | regexm(`var', "ELECTRICITY") | regexm(`var', "VILLAGE DEVELOPMENT") | regexm(`var', "CURRENT") | regexm(`var', "TOILETS") | regexm(`var', "BATH ROOMS") | regexm(`var', "BATHROOMS") | `var'=="HEALTH" | `var'=="STREET LIGHTS" | regexm(`var', "VILLAGE INFRASTRUCTURE") | regexm(`var', "PROVIDE NETS") | regexm(`var', "POWER") | regexm(`var', "ELSTABLISHMENT OF HOSPITA") | regexm(`var', "DUMPING WARD") | regexm(`var', "DRINAGW") | regexm(`var', "COMMUNITY") | regexm(`var', "SHOULD PROVIDE ELECTRICIT") | regexm(`var', "LIGHT") | regexm(`var', "LIBRARY") | `var'=="PROVIDE NEED VILLAGE LEVE"
	replace `var'="" if regexm(`var', "ROAD") | regexm(`var', "WATER") | regexm(`var', "DRAINAGE") | regexm(`var', "ELECTRICITY") | regexm(`var', "VILLAGE DEVELOPMENT") | regexm(`var', "CURRENT") | regexm(`var', "TOILETS") | regexm(`var', "BATH ROOMS") | regexm(`var', "BATHROOMS") | `var'=="HEALTH" | `var'=="STREET LIGHTS" | regexm(`var', "VILLAGE INFRASTRUCTURE") | regexm(`var', "PROVIDE NETS") | regexm(`var', "POWER") | regexm(`var', "ELSTABLISHMENT OF HOSPITA") | regexm(`var', "DUMPING WARD") | regexm(`var', "DRINAGW") | regexm(`var', "COMMUNITY") | regexm(`var', "SHOULD PROVIDE ELECTRICIT") | regexm(`var', "LIGHT") | regexm(`var', "LIBRARY") | `var'=="PROVIDE NEED VILLAGE LEVE"
}
replace issue_public_good=0 if issue_public_good==.

g issue_education=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_education=1 if regexm(`var', "EDUCATION")
	replace `var'="" if regexm(`var', "EDUCATION")
}
replace issue_education=0 if issue_education==.

g issue_private_good=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_private_good=1 if regexm(`var', "LOAN") | regexm(`var', "HOUSE LONE") | regexm(`var', "GAS") | regexm(`var', "HOUSE") | regexm(`var', "HOUSING")
	replace `var'="" if regexm(`var', "LOAN") | regexm(`var', "HOUSE LONE") | regexm(`var', "GAS") | regexm(`var', "HOUSE") | regexm(`var', "HOUSING")
}
replace issue_private_good=0 if issue_private_good==.

g issue_agriculture=.
replace issue_agriculture=0 if issue_agriculture==.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_agriculture=1 if regexm(`var', "AGRICULTURAL") | regexm(`var', "AGRICULTURE") | regexm(`var', "IRRIGATION") | strmatch(`var', "LAND")
	replace `var'="" if regexm(`var', "AGRICULTURAL") | regexm(`var', "AGRICULTURE") | regexm(`var', "IRRIGATION") | strmatch(`var', "LAND")
}
replace issue_agriculture=0 if issue_agriculture==.

g issue_pds=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_pds=1 if regexm(`var', "RATION") | `var'=="FOOD" | regexm(`var', "PDS")
	replace `var'="" if regexm(`var', "RATION") | `var'=="FOOD" | regexm(`var', "PDS")
}
replace issue_pds=0 if issue_pds==.

g issue_employment=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_employment=1 if regexm(`var', "UNEMPLOY") | regexm(`var', "JOB") | regexm(`var', "EMPLOYEMENT") | regexm(`var', "EMPLOYMENT")
	replace `var'="" if regexm(`var', "UNEMPLOY") | regexm(`var', "JOB") | regexm(`var', "EMPLOYEMENT") | regexm(`var', "EMPLOYMENT")
}
replace issue_employment=0 if issue_employment==.

g issue_inflation=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_inflation=1 if regexm(`var', "INFLATION") | regexm(`var', "PRICE")
	replace `var'="" if regexm(`var', "INFLATION") | regexm(`var', "PRICE")
}
replace issue_inflation=0 if issue_inflation==.

g issue_corruption=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_corruption=1 if regexm(`var', "BRIBING") | regexm(`var', "BRING OF GOVT OFFICERS") | `var'=="GOVERNANCE" | `var'=="CORRUPTION"
	replace `var'="" if regexm(`var', "BRIBING") | regexm(`var', "BRING OF GOVT OFFICERS") | `var'=="GOVERNANCE" | `var'=="CORRUPTION"
}
replace issue_corruption=0 if issue_corruption==.

g issue_poverty=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_poverty=1 if `var'=="POVERTY"
	replace `var'="" if `var'=="POVERTY"
}
replace issue_poverty=0 if issue_poverty==.

g issue_emergency_support=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_emergency_support=1 if `var'=="FLOOD RELIEF"
	replace `var'="" if `var'=="FLOOD RELIEF"
}
replace issue_emergency_support=0 if issue_emergency_support==.

g issue_transportation=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_transportation=1 if regexm(`var', "BUSES") | regexm(`var', "TRANSPORT")
	replace `var'="" if regexm(`var', "BUSES") | regexm(`var', "TRANSPORT")
}
replace issue_transportation=0 if issue_transportation==.

g issue_wards=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_wards=1 if regexm(`var', "WARDS")
	replace `var'="" if regexm(`var', "WARDS")
}
replace issue_wards=0 if issue_wards==.

g issue_taxes=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_taxes=1 if regexm(`var', "TAXES")
	replace `var'="" if regexm(`var', "TAXES")
}
replace issue_taxes=0 if issue_taxes==.

g issue_caste=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_caste=1 if `var'=="CASTE"
	replace `var'="" if `var'=="CASTE"
}
replace issue_caste=0 if issue_caste==.

g issue_private_sector=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_private_sector=1 if `var'=="BUSINESS"
	replace `var'="" if `var'=="BUSINESS"
}
replace issue_private_sector=0 if issue_private_sector==.

g issue_gender=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_gender=1 if `var'=="GENDER"
	replace `var'="" if `var'=="GENDER"
}
replace issue_gender=0 if issue_gender==.

g issue_alcohol=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_alcohol=1 if `var'=="ALCOHOL"
	replace `var'="" if `var'=="ALCOHOL"
}
replace issue_alcohol=0 if issue_alcohol==.

g issue_security=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_security=1 if `var'=="SECURITY"
	replace `var'="" if `var'=="SECURITY"
}
replace issue_security=0 if issue_security==.

g issue_growth=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_growth=1 if `var'=="ECONOMIC GROWTH"
	replace `var'="" if `var'=="ECONOMIC GROWTH"
}
replace issue_growth=0 if issue_growth==.

g issue_wtf=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_wtf=1 if `var'=="TRAVEL" | `var'=="MASCETOOB" | `var'=="BUILDING"
	replace `var'="" if `var'=="TRAVEL" | `var'=="MASCETOOB" | `var'=="BUILDING"
}
replace issue_wtf=0 if issue_wtf==.

g issue_none=.
foreach var of varlist pol_big_1-pol_big_3 {
	replace issue_none=1 if regexm(`var', "NO ISSUES")
	replace `var'="" if regexm(`var', "NO ISSUES")
}
replace issue_none=0 if issue_none==.

foreach var of varlist pol_big_1-pol_big_3 {
	replace `var'="" if regexm(`var', "DON'T KNOW") | regexm(`var', "DONT KNOW") | `var'=="WHILE HAPPINING FLOODS" | `var'=="EVERY THING IS LINE IN OU"
}

*Adding employment as a private good issue:
replace issue_private_good=1 if issue_employment==1 & issue_private_good==0

************************
* SECTION 5:
************************
foreach var of varlist per_gov_teacher-per_central_gov {
	recode `var' (5=1) (1 2 3 4 6=0) (9=.), g(`var'_dk)
	recode `var' (5 6 9=.) (1=4) (2=3) (3=2) (4=1)
}

foreach var of varlist per_treat_gov_teacher-per_treat_block {
	recode `var' (3=1) (1 2 4=0) (9=.), g(`var'_dk)
	recode `var' (2=0) (3 4 9=.)
}

recode per_cash_assistance (2=0) (3/9=.)
recode per_cash_assistance_amount (9 99 999 9999 8888=.)
replace per_cash_assistance_amount=0 if per_cash_assistance==0

lab var per_gov_teacher "Government Teachers Care about the Well-Being of Their Students"
lab var per_treat_gov_teacher "Government Teachers Treat All Students Equally"

************************
* SECTION 6
************************

*Replacing specific claim answers:
replace claim_specify="" if claim_specify=="0" | claim_specify=="00" | claim_specify=="NO OTHER ACTIVITY"
g claim_sarpanch=1 if regexm(claim_specify, "P?NCH")==1 | claim_specify=="PRESIDENT" | claim_specify=="PRISEDENT" | claim_specify=="WARD MEMBER"
replace claim_sarpanch=0 if claim_sarpanch==. & claim_intermediaries==1
g claim_family=1 if claim_specify=="FAMILY NUMBERS AND CASTE" | claim_specify=="NEIGHBOUR & RELATIVES" | claim_specify=="NEIGHBOURS" | claim_specify=="THEY AUNTY" | claim_specify=="MY ONLY"
replace claim_family=0 if claim_family==. & claim_intermediaries==1
replace claim_party=1 if claim_specify=="PARTY FEELING"

replace claim_gov_teacher_specify="" if claim_gov_teacher_specify=="00" | claim_gov_teacher_specify=="9"
g claim_gov_teacher_bureaucracy=1 if regexm(claim_gov_teacher_specify, "M E O")==1 | regexm(claim_gov_teacher_specify, "M.E.O")==1 | regexm(claim_gov_teacher_specify, "MEO")==1 | regexm(claim_gov_teacher_specify, "GOVT")==1 | regexm(claim_gov_teacher_specify, "SCHOOL COMM")==1 | claim_gov_teacher_specify=="CHARIMAN" | claim_gov_teacher_specify=="PRISEDENT" | claim_gov_teacher_specify=="VILLAGE SURPANCH" | claim_gov_teacher_specify=="CHAIRMAN OF THE SCHOOL" | claim_gov_teacher_specify=="D E O" | claim_gov_teacher_specify=="D.E.O" | claim_gov_teacher_specify=="DEO"
g claim_gov_teacher_parents=1 if regexm(claim_gov_teacher_specify, "PARENT")==1 | claim_gov_teacher_specify=="BY FORMING AN UNION OF PA"
g claim_gov_teacher_civil_society=1 if regexm(claim_gov_teacher_specify, "PRESS & MEDIA")==1

replace claim_prv_teacher_specify="" if claim_prv_teacher_specify=="1"
g claim_prv_teacher_vote_feet=1 if regexm(claim_prv_teacher_specify, "CHANG")==1 | regexm(claim_prv_teacher_specify, "SHIFT")==1
g claim_prv_teacher_parents=1 if regexm(claim_prv_teacher_specify, "PARENTS")==1
g claim_prv_teacher_school=1 if regexm(claim_prv_teacher_specify, "CORR")==1 | regexm(claim_prv_teacher_specify, "CIPAL")==1 | regexm(claim_prv_teacher_specify, "MANAGEMENT")==1 | claim_prv_teacher_specify=="PRINICPAL" | claim_prv_teacher_specify=="SCHOOL CHAIRMAN"
replace claim_prv_teacher_panchayat=1 if claim_prv_teacher_specify=="VILLAGE SURPANCH"

replace claim_gov_school_specify="" if claim_gov_school_specify=="00" | claim_gov_school_specify=="9"
g claim_gov_school_gov_teacher=1 if regexm(claim_gov_school_specify, "TEACH")==1 | regexm(claim_gov_school_specify, "HM")==1 | claim_gov_school_specify=="H.M" | claim_gov_school_specify=="THE PRESENT HEAD MISTRES" | claim_gov_school_specify=="H M"
g claim_gov_school_family=1 if claim_gov_school_specify=="ANTY" | claim_gov_school_specify=="DAUGHTER"
g claim_gov_school_prv_teacher=1 if claim_gov_school_specify=="PVT SCHOOL CORRESPONDENT"
replace claim_gov_school_panchayat=1 if claim_gov_school_specify=="SURPANCH"

replace claim_bpl_specify="" if claim_bpl_specify=="00"
replace claim_bpl_gov_official=1 if claim_bpl_specify=="MLA (IN TDP GOVT)" | claim_bpl_specify=="SARPUNCH"
g claim_bpl_family=1 if claim_bpl_specify=="RELATIVES"

replace claim_hospital_specify="" if claim_hospital_specify=="00" | claim_hospital_specify=="BROTHER MET WITH A ACCIDE"
g claim_hospital_family=1 if claim_hospital_specify=="CHILDRENS" | claim_hospital_specify=="DAUGHTER" | claim_hospital_specify=="FAMILY MEMBERS" | claim_hospital_specify=="FRIENDS" | claim_hospital_specify=="MOTHER BROTHER" | claim_hospital_specify=="PARENTS AND BROTHERINLAW" | claim_hospital_specify=="RELATIONS" | claim_hospital_specify=="RELATIVE" | claim_hospital_specify=="RELATIVES" | claim_hospital_specify=="RELATIVIES"
g claim_hospital_teacher=1 if claim_hospital_specify=="AWD TEACHER (SHE IS LIVIN"
g claim_hospital_doctor=1 if claim_hospital_specify=="REFERENCE WAS GIVEN BY TH" | claim_hospital_specify=="OTHER DOCTOR (PVT)"

replace claim_nrega_specify="" if claim_nrega_specify=="00" | claim_nrega_specify=="1" | regexm(claim_nrega_specify, "WE DON'T HAVE")==1 | regexm(claim_nrega_specify, "NO NREGA")==1 | regexm(claim_nrega_specify, "NO SUCH")==1 | regexm(claim_nrega_specify, "THIS SCHEME")==1 | claim_nrega_specify=="DONT HAVE NREGA CARD" | claim_nrega_specify=="DONT WRITE NAMES IN THE R" | claim_nrega_specify=="IT IS NOT EXISTS" | claim_nrega_specify=="NEVERE GO TO FIELD" | claim_nrega_specify=="NO OTHER ACTIVITY" | claim_nrega_specify=="NO PROVISION" | claim_nrega_specify=="NO THIS SYSTEM DONT EXCIS" | claim_nrega_specify=="NOT ATTEND" | claim_nrega_specify=="NOT OTHER ACTIVITY" | claim_nrega_specify=="STILL WE DIDNT HAD THE CA" | claim_nrega_specify=="WE DONT REQUIRE"
replace claim_nrega_gov_official=1 if claim_nrega_specify=="A W TEACHER" | claim_nrega_specify=="NREGA SUPERVISOR"
g claim_nrega_family=1 if claim_nrega_specify=="RETATIVES"
replace claim_nrega_assc=1 if claim_nrega_specify=="VRP" | claim_nrega_specify=="DWACRA"

replace claim_land_specify="" if claim_land_specify=="8888888801" | claim_land_specify=="NO OTHER ACTIVITY"
replace claim_land_no_one=1 if regexm(claim_land_specify, "DIRECT")==1
replace claim_land_gov_official=1 if regexm(claim_land_specify, "PANCH")==1
g claim_land_family=1 if claim_land_specify=="RELATIVES"

*Generating particular claim categories by official and unofficial methods:
g claim_general_state=.
replace claim_general_state=1 if claim_party==1 | claim_sarpanch==1 | claim_specify=="AWS TEACHERS"
replace claim_general_state=0 if claim_intermediaries==1 & claim_general_state==.

g claim_general_nonstate=.
replace claim_general_nonstate=1 if claim_elders==1 | claim_caste==1 | claim_zamindar==1 | claim_educated==1 | claim_youth==1 | claim_family==1
replace claim_general_nonstate=0 if claim_general_nonstate==. & claim_intermediaries==1

*Removing government teachers:
g claim_gov_teacher_state=.
replace claim_gov_teacher_state=1 if claim_gov_teacher_panchayat==1 | claim_gov_teacher_gov_official==1 | claim_gov_teacher_party==1 | claim_gov_teacher_hm==1 | claim_gov_teacher_bureaucracy==1

g claim_gov_teacher_nonstate=.
replace claim_gov_teacher_nonstate=1 if claim_gov_teacher_assc==1 | claim_gov_teacher_caste==1 | claim_gov_teacher_fixer==1 | claim_gov_teacher_ngo==1 | claim_gov_teacher_parents==1

replace claim_gov_teacher_state=0 if claim_gov_teacher_nonstate==1 & claim_gov_teacher_no_one==0 & claim_gov_teacher_state==.
replace claim_gov_teacher_nonstate=0 if claim_gov_teacher_state==1 & claim_gov_teacher_no_one==0 & claim_gov_teacher_nonstate==.

*Removing Private Teachers:
g claim_prv_teacher_state=.
replace claim_prv_teacher_state=1 if claim_prv_teacher_party==1 | claim_prv_teacher_panchayat==1 | claim_prv_teacher_gov_official==1

g claim_prv_teacher_nonstate=.
replace claim_prv_teacher_nonstate=1 if claim_prv_teacher_assc==1 | claim_prv_teacher_caste==1 | claim_prv_teacher_fixer==1 | claim_prv_teacher_ngo==1 | claim_prv_teacher_hm==1 | claim_prv_teacher_vote_fee==1 | claim_prv_teacher_parents==1 | claim_prv_teacher_school==1

replace claim_prv_teacher_state=0 if claim_prv_teacher_state==. & claim_prv_teacher_nonstate==1 & claim_prv_teacher_no_one==0
replace claim_prv_teacher_nonstate=0 if claim_prv_teacher_nonstate==. & claim_prv_teacher_state==1  & claim_prv_teacher_no_one==0

*Admission to preferred government schools:
g claim_gov_school_state=.
replace claim_gov_school_state=1 if claim_gov_school_panchayat==1 | claim_gov_school_gov_official==1 | claim_gov_school_party==1 | claim_gov_school_gov_teacher==1
replace claim_gov_school_state=0 if claim_gov_school_state==0 | claim_gov_school_no_one==1

g claim_gov_school_nonstate=.
replace claim_gov_school_nonstate=1 if claim_gov_school_assc==1 | claim_gov_school_caste==1 | claim_gov_school_fixer==1 | claim_gov_school_ngo==1 | claim_gov_school_prv_teacher==1 | claim_gov_school_family==1
replace claim_gov_school_nonstate=0 if claim_gov_school_nonstate==0 | claim_gov_school_no_one==1

replace claim_gov_school_state=0 if claim_gov_school_nonstate==1 & claim_gov_school_no_one==0 & claim_gov_school_state==.
replace claim_gov_school_nonstate=0 if claim_gov_school_state==1 & claim_gov_school_no_one==0 & claim_gov_school_nonstate==.

*BPL claim making:
g claim_bpl_state=.
replace claim_bpl_state=1 if claim_bpl_panchayat==1 | claim_bpl_gov_official==1 | claim_bpl_party==1

g claim_bpl_nonstate=.
replace claim_bpl_nonstate=1 if claim_bpl_assc==1 | claim_bpl_caste==1 | claim_bpl_fixer==1 | claim_bpl_ngo==1 | claim_bpl_family==1

replace claim_bpl_state=0 if claim_bpl_nonstate==1 & claim_bpl_no_one==0 & claim_bpl_state==.
replace claim_bpl_nonstate=0 if claim_bpl_state==1 & claim_bpl_no_one==0 & claim_bpl_nonstate==.

*Admission to the hospital:
g claim_hospital_state=.
replace claim_hospital_state=1 if claim_hospital_panchayat==1 | claim_hospital_gov_official==1 | claim_hospital_party==1 | claim_hospital_teacher==1

g claim_hospital_nonstate=.
replace claim_hospital_nonstate=1 if claim_hospital_assc==1 | claim_hospital_caste==1 | claim_hospital_fixer==1 | claim_hospital_ngo==1 | claim_hospital_family==1 | claim_hospital_doctor==1

replace claim_hospital_state=0 if claim_hospital_state==. & claim_hospital_nonstate==1 & claim_hospital_no_one==0
replace claim_hospital_nonstate=0 if claim_hospital_nonstate==. & claim_hospital_state==1 & claim_hospital_no_one==0

*Work with NREGA:
g claim_nrega_state=.
replace claim_nrega_state=1 if claim_nrega_panchayat==1 | claim_nrega_gov_official==1 | claim_nrega_party==1

g claim_nrega_nonstate=.
replace claim_nrega_nonstate=1 if claim_nrega_assc==1 | claim_nrega_caste==1 | claim_nrega_fixer==1 | claim_nrega_ngo==1 | claim_nrega_family==1

replace claim_nrega_state=0 if claim_nrega_state==. & claim_nrega_nonstate==1 & claim_nrega_no_one==0
replace claim_nrega_nonstate=0 if claim_nrega_nonstate==. & claim_nrega_state==1 & claim_nrega_no_one==0

*Dealing with the land administration:
g claim_land_state=.
replace claim_land_state=1 if claim_land_panchayat==1 | claim_land_gov_official==1 | claim_land_party==1

g claim_land_nonstate=.
replace claim_land_nonstate=1 if claim_land_assc==1 | claim_land_caste==1 | claim_land_fixer==1 | claim_land_ngo==1

replace claim_land_state=0 if claim_land_state==. & claim_land_nonstate==1 & claim_land_no_one==0
replace claim_land_nonstate=0 if claim_land_nonstate==. & claim_land_state==1 & claim_land_no_one==0

lab var claim_gov_school_state "State Channel: Access to Government School"
lab var claim_bpl_state "State Channel: Access to BPL Card"
lab var claim_hospital_state "State Channel: Access to Government Hospital"
lab var claim_nrega_state "State Channel: NREGA Employment"
lab var claim_land_state "State Channel: Dealing with Police or Land Administration"
lab var claim_gov_school_nonstate "Non-State Channel: Access to Government School"
lab var claim_bpl_nonstate "Non-State Channel: Access to BPL Card"
lab var claim_hospital_nonstate "Non-State Channel: Access to Government Hospital"
lab var claim_nrega_nonstate "Non-State Channel: NREGA Employment"
lab var claim_land_nonstate "Non-State Channel: Dealing with Police or Land Administration"

************************
* SECTION 7
************************
lab define accept_gov_pds 0 "Rations to be Distributed through Government Ration Shops" 1 "Give Money to Buy Rations as you Please"
lab define accept_gov_voucher 0 "Government Should Provide Education" 1 "Choose Schools as you Please"

* CLEANING WTP PDS QUESTIONS:
g min_amount_pds=priv_pds_min
forval i=200(50)1000 {
	replace min_amount_pds=`i' if priv_pds_`i'==1
}
recode priv_pds_min (7777 77777=1), g(no_amount_pds)
replace no_amount_pds=0 if no_amount_pds!=1
recode min_amount_pds (9 6666 7777 9999 66666 77777 88888 99999=.)

* CLEANING WILLINGNESS TO ACCEPT PDS QUESTIONS:
ren priv_pds_gov_exp_amount amount_pds
recode amount_pds (9 88888 88882=.)

ren priv_pds_gov_real_exp accept_gov_pds
recode accept_gov_pds (1=0) (2=1) (9=.)
label val accept_gov_pds
label val accept_gov_pds accept_gov_pds

* CLEANING WILLINGNESS TO ACCEPT VOUCHER QUESTIONS:
ren priv_voucher_gov_exp_amount amount_school
recode amount_school (9 88888 99999=.) /*Check amount that is 70001*/
recode priv_voucher_gov_real_exp (1=0) (2=1) (9=.)
ren priv_voucher_gov_real_exp accept_gov_voucher
lab val accept_gov_voucher
lab val accept_gov_voucher accept_gov_voucher

* CLEANING WTP VOUCHER QUESTIONS:
g min_amount_voucher = priv_voucher_min
forval i = 3000(500)10000 {
	replace min_amount_voucher = `i' if priv_voucher_`i' == 1
}
recode priv_voucher_min (77777 = 1), g(no_amount_voucher)
replace no_amount_voucher = 0 if no_amount_voucher != 1
recode min_amount_voucher (2 9 66666 77777 88888 99999 = .)

drop priv_pds_200-priv_pds_1000 priv_voucher_3000-priv_voucher_10000 priv_voucher_min priv_pds_min

* Generating Standardized Valuation of Public Services Variables:
foreach var of varlist min_amount_pds min_amount_voucher {
	qui sum `var'
	g sd_`var' = (`var' - r(mean)) / r(sd)
}

lab var sd_min_amount_pds "Valuation of Public Rations"
lab var sd_min_amount_voucher "Valuation of Government Schools"

* CLEANING PRIVATIZATION QUESTIONS:
recode priv_job (1=0) (2 3=1) (9=.)
recode priv_financing (1=0) (2=0.5) (3=1) (9=.)

recode priv_services_private (1=1) (0=0), g(priv_services)
recode priv_services_government (1=0) (0=1), g(gov_services)
drop priv_services_private priv_services_government

ren priv_job privjob
ren gov_services privservices
ren priv_financing privfinancing

lab var privjob "Preference for Private Sector Job"
lab var privservices "Basic Services should be Provided Privately"
lab var privfinancing "Basic Services should be Financed Privately"

destring schooltype_2010, replace
recode schooltype_2010 (3 4 = 1) (1 2 = 0), g(private_two)
lab var private_two "Private School after Two Years"

recode schooltype_end (3 4 = 1) (1 2 = 0), g(private_end)
lab var private_end "Attended Private School"
replace private_two = 1 if private_end == 1 & private_two == .

recode medium (2 = 1) (1 = 0), g(english)
recode medium (1 = 0) (0 = 1), g(telugu)
lab var english "English Medium"
lab var telugu "Telugu Medium"

g total_priv_school = numprivschool
replace total_priv_school = numprivschool + 1 if private_end == 1 & priv_school_1 == 0
replace total_priv_school = 1 if total_priv_school == 0 & private_end == 1
g per_private_children = total_priv_school / school_age_children

ren priv_school_1 privschool1

lab var privschool1 "Voucher Child Continued in Private School"
lab var numprivschool "No. Children in HH in Private Schools"
lab var per_private_children "\% Children in HH in Private School"

*******
* Creating Indices
*******

/*
************************
* CREATING INDICES USING MAKE INDEX
* CONSTRUCTING FOUR INDICES:
* 1. Partisan Political Participation
* 2. Associational Membership
* 3. Preferences for Private Services
* 4. Valuation of Public Services
* 5. State Claim Making Networks
* 6. Non-State Claim Making Networks
************************
*/

*DEFINING COMPONENTS OF INDEX
loc pol_participation polparty polmeeting polcanvas polleaflets
loc pol_participation_voting `pol_participation' votels votemla votepan
loc associational assccaste assccoops asscshg gramsabha
loc privatisation privjob privservices privfinancing privschool1 numprivschool healthpriv
loc valuation min_amount_voucher min_amount_pds
loc claimstate claim_gov_school_state claim_bpl_state claim_hospital_state claim_nrega_state claim_land_state
loc claimnonstate claim_gov_school_nonstate claim_bpl_nonstate claim_hospital_nonstate claim_nrega_nonstate claim_land_nonstate
loc quality school_problem_solve school_building_qual school_teacher_qual school_overall_qual

* Running the index creation do-file from Cyrus Samii:
* Source here: https://github.com/cdsamii/make_index
* Last accessed on 2020/03/23:

qui do "`scripts'/make_index_gr.do"

* Creating standard weight:
g wgt = 1

* Recoding offered to be positive for control group:
recode offered (0 = 1) (1 = 0), g(control)

make_index_gr part_pol wgt control `pol_participation'
lab var index_part_pol "Summary Index: Partisan Political Participation"

make_index_gr locdemoc wgt control `associational'
lab var index_locdemoc "Summary Index: Non-Partisan Political Participation"

make_index_gr privatisation wgt control `privatisation'
lab var index_privatisation "Summary Index: Private Services"

make_index_gr valuation wgt control `valuation'
lab var index_valuation "Summary Index: Valuation of Public Services"

make_index_gr claimstate wgt control `claimstate'
lab var index_claimstate "Summary Index: State Claim Making Networks"

make_index_gr claimnonstate wgt control `claimnonstate'
lab var index_claimnonstate "Summary Index: Non-State Claim Making Networks"

make_index_gr voting wgt control `pol_participation_voting'
lab var index_voting "Summary Index: Participation Including Voting"

make_index_gr quality wgt control `quality'
lab var index_quality "Summary Index: School Quality"

* Restandardising all indices
foreach var of varlist index_* {
	qui summ `var' if control == 1
	replace `var' = (`var' - `r(mean)') / `r(sd)'
}

/*
***********************
* Creating indices with one and more items removed:
***********************
*/

* Political Participation

* Relabelling variables in political participation index:
loc number: word count `pol_participation'
forval i = 1/`number' {
	loc current_var: word `i' of `pol_participation'
	loc label_`i': var label `current_var'
	lab var `current_var' "`i'"
}

foreach x of loc pol_participation {
	loc reduced: list pol_participation - x
	make_index_gr pp_`x' wgt control `reduced'
	ren index_pp_`x' pp_`x'
	qui summ pp_`x' if control == 1
	replace pp_`x' = (pp_`x' - `r(mean)') / `r(sd)'
	loc lab: var lab `x'
	lab var pp_`x' "Partisan Political Participation - `lab'"
	
	foreach y of loc reduced {
		loc reduced_2: list reduced - y
		make_index_gr pp_`x'_`y' wgt control `reduced_2'
		ren index_pp_`x'_`y' pp_`x'_`y'
		qui summ pp_`x'_`y' if control == 1
		replace pp_`x'_`y' = (pp_`x'_`y' - `r(mean)') / `r(sd)'
		loc lab_2: var lab `y'
		lab var pp_`x'_`y' "Partisan Political Participation - `lab' -`lab_2'"
		
	}
}

forval i = 1/`number' {
	loc current_var: word `i' of `pol_participation'
	lab var `current_var' "`label_`i''"
}

* Associational Index

* Relabelling variables
loc number: word count `associational'
forval i = 1/`number' {
	loc current_var: word `i' of `associational'
	loc label_`i': var label `current_var'
	lab var `current_var' "`i'"
}

foreach x of loc associational {
	loc reduced: list associational - x
	make_index_gr assc_`x' wgt control `reduced'
	ren index_assc_`x' assc_`x'
	qui summ assc_`x' if control == 1
	replace assc_`x' = (assc_`x' - `r(mean)') / `r(sd)'
	loc lab: var lab `x'
	lab var assc_`x' "Non-Partisan Political Participation - `lab'"
	
	foreach y of loc reduced {
		loc reduced_2: list reduced - y
		make_index_gr assc_`x'_`y' wgt control `reduced_2'
		ren index_assc_`x'_`y' assc_`x'_`y'
		qui summ assc_`x'_`y' if control == 1
		replace assc_`x'_`y' = (assc_`x'_`y' - `r(mean)') / `r(sd)'
		loc lab_2: var lab `y'
		lab var assc_`x'_`y' "Non-Partisan Political Participation - `lab' -`lab_2'"
	}
}

forval i = 1/`number' {
	loc current_var: word `i' of `associational'
	lab var `current_var' "`label_`i''"
}

* RENANMING PRIVATE SERVICE INDEX VARIABLES SO THEY FIT WITH VARIABLE RENAMING:
ren privjob pj
ren privservices pr
ren privfinancing pf
ren privschool1 pc
ren numprivschool ns
ren healthpriv hp

loc privatisation pj pr pf pc ns hp

* Relabelling variables
loc number: word count `privatisation'
forval i = 1/`number' {
	loc current_var: word `i' of `privatisation'
	loc label_`i': var label `current_var'
	lab var `current_var' "`i'"
}

* Use of Private Services:
foreach x of loc privatisation {
	loc reduced: list privatisation - x
	make_index_gr priv_`x' wgt control `reduced'
	ren index_priv_`x' priv_`x'
	qui summ priv_`x' if control == 1
	replace priv_`x' = (priv_`x' - `r(mean)') / `r(sd)'
	loc lab: var lab `x'
	lab var priv_`x' "Priv Services - `lab'"
	
	foreach y of loc reduced {
		loc reduced_2: list reduced - y
		make_index_gr priv_`x'_`y' wgt control `reduced_2'		
		ren index_priv_`x'_`y' priv_`x'_`y'
		qui summ priv_`x'_`y' if control == 1
		replace priv_`x'_`y' = (priv_`x'_`y' - `r(mean)') / `r(sd)'
		loc lab_2: var lab `y'
		lab var priv_`x'_`y' "Priv Services - `lab' -`lab_2'"
		
		foreach z of loc reduced_2 {
			loc reduced_3: list reduced_2 - z
			make_index_gr priv_`x'_`y'_`z' wgt control `reduced_3'		
			ren index_priv_`x'_`y'_`z' priv_`x'_`y'_`z'
			qui summ priv_`x'_`y'_`z' if control == 1
			replace priv_`x'_`y'_`z' = (priv_`x'_`y'_`z' - `r(mean)') / `r(sd)'
			loc lab_3: var lab `z'
			lab var priv_`x'_`y'_`z' "Priv Services - `lab' -`lab_2' - `lab_3'"
			
			foreach a of loc reduced_3 {
				loc reduced_4: list reduced_3 - a
				make_index_gr priv_`x'_`y'_`z'_`a' wgt control `reduced_4'
				ren index_priv_`x'_`y'_`z'_`a' priv_`x'_`y'_`z'_`a'
				qui summ priv_`x'_`y'_`z'_`a' if control == 1
				replace priv_`x'_`y'_`z'_`a' = (priv_`x'_`y'_`z'_`a' - `r(mean)') / `r(sd)'
				loc lab_4: var lab `a'
				lab var priv_`x'_`y'_`z'_`a' "Priv Services - `lab' -`lab_2' - `lab_3' - `lab_4'"
			}
		}
	}	
}

forval i = 1/`number' {
	loc current_var: word `i' of `privatisation'
	lab var `current_var' "`label_`i''"
}

* RENANMING PRIVATE SERVICE INDEX VARIABLES BACK TO ORIGINALS:
ren pj privjob
ren pr privservices
ren pf privfinancing
ren pc privschool1
ren ns numprivschool
ren hp healthpriv

/*
**********************
* Matching with 2011 census village codes
**********************
*/

g V_CT_CODE = .
g state_district = .

*East Godavari:
replace state_district = 2814 if district_name=="EAST GODAVARI"
replace V_CT_CODE = 1876800 if pu_code == 25019
replace V_CT_CODE = 1887900 if pu_code == 25404
replace V_CT_CODE = 1875300 if pu_code == 25110
replace V_CT_CODE = 1884300 if pu_code == 25726
replace V_CT_CODE = 1888000 if pu_code == 25503
replace V_CT_CODE = 1854100 if pu_code == 23434
replace V_CT_CODE = 1885200 if pu_code == 25814
replace V_CT_CODE = 1883400 if pu_code == 25616
replace V_CT_CODE = 1851900 if pu_code == 23536
replace V_CT_CODE = 1841500 if pu_code == 25727
replace V_CT_CODE = 1884000 if pu_code == 25728
replace V_CT_CODE = 1850500 if pu_code == 22240

*Kadapa:
replace state_district = 2820 if district_name=="KADAPA"
replace V_CT_CODE = 2399700 if pu_code == 31025
replace V_CT_CODE = 2467800 if pu_code == 33937
replace V_CT_CODE = 2470300 if pu_code == 34530
replace V_CT_CODE = 2405000 if pu_code == 31103
replace V_CT_CODE = 2405200 if pu_code == 31104
replace V_CT_CODE = 2405100 if pu_code == 31105
replace V_CT_CODE = 2463200 if pu_code == 34140
replace V_CT_CODE = 2459700 if pu_code == 34044
replace V_CT_CODE = 2395100 if pu_code == 30701
replace V_CT_CODE = 2444400 if pu_code == 33323
replace V_CT_CODE = 2393100 if pu_code == 30619
replace V_CT_CODE = 2392000 if pu_code == 30620
replace V_CT_CODE = 2400700 if pu_code == 31027
replace V_CT_CODE = 2392600 if pu_code == 30621

*Medak:
replace state_district = 2804 if district_name=="MEDAK"
replace V_CT_CODE = 485200 if pu_code == 44044
replace V_CT_CODE = 494700 if pu_code == 43906
replace V_CT_CODE = 494500 if pu_code == 43907
replace V_CT_CODE = 491700 if pu_code == 43625
replace V_CT_CODE = 495000 if pu_code == 43908
replace V_CT_CODE = 492600 if pu_code == 43627
replace V_CT_CODE = 445700 if pu_code == 43029
replace V_CT_CODE = 498300 if pu_code == 43716
replace V_CT_CODE = 481000 if pu_code == 44109
replace V_CT_CODE = 439100 if pu_code == 43032
replace V_CT_CODE = 451800 if pu_code == 43321
replace V_CT_CODE = 397600 if pu_code == 41343
replace V_CT_CODE = 463600 if pu_code == 44336
replace V_CT_CODE = 419100 if pu_code == 42339

*Nizamabad:
replace state_district = 2802 if district_name=="NIZAMABAD"
replace V_CT_CODE = 203900 if pu_code == 51404
replace V_CT_CODE = 224300 if pu_code == 52034
replace V_CT_CODE = 240200 if pu_code == 52609
replace V_CT_CODE = 203000 if pu_code == 51405
replace V_CT_CODE = 225700 if pu_code == 52035
replace V_CT_CODE = 175100 if pu_code == 50227
replace V_CT_CODE = 214600 if pu_code == 51711
replace V_CT_CODE = 173100 if pu_code == 50130
replace V_CT_CODE = 215200 if pu_code == 51712
replace V_CT_CODE = 180000 if pu_code == 50320
replace V_CT_CODE = 206800 if pu_code == 51513
replace V_CT_CODE = 253400 if pu_code == 53117
replace V_CT_CODE = 179700 if pu_code == 50321
replace V_CT_CODE = 245500 if pu_code == 52844
replace V_CT_CODE = 239800 if pu_code == 52610
replace V_CT_CODE = 173400 if pu_code == 50132
replace V_CT_CODE = 225200 if pu_code == 52039

*Vizag
replace state_district = 2813 if district_name=="VISHAKAPATNAM"
replace V_CT_CODE = 1699400 if pu_code == 12210
replace V_CT_CODE = 1675500 if pu_code == 11539
replace V_CT_CODE = 1677500 if pu_code == 11540
replace V_CT_CODE = 1741800 if pu_code == 14322
replace V_CT_CODE = 1735900 if pu_code == 13525
replace V_CT_CODE = 1701500 if pu_code == 12212
replace V_CT_CODE = 1734600 if pu_code == 13526
replace V_CT_CODE = 1697000 if pu_code == 10742
replace V_CT_CODE = 1672400 if pu_code == 11629
replace V_CT_CODE = 1713300 if pu_code == 12616
replace V_CT_CODE = 1754300 if pu_code == 14232
replace V_CT_CODE = 1746400 if pu_code == 13928
replace V_CT_CODE = 1671800 if pu_code == 11630

/*
***************************
* Getting data on attrition:
***************************
*/

merge 1:1 apfstudentcode using "`raw'/downstream_sample_third.dta", keepusing(replacement_sample offered status original_sample distnames)

g attrition = 0 if _merge == 3
replace attrition = 1 if _merge == 2 & (original_sample == 1 | original_sample == 2 | original_sample == 3)
drop if attrition == .
drop _merge
lab var attrition "Attrition"
lab define attritition 0 "Household Not Found" 1 "Household Found"
lab val attrition attrition

************************
* CREATING INSTRUMENTS
************************
recode status (1 8 = 1) (2 3 4 5 6 7 9 10 = 0) (. = 0), g(accepted)
recode status (1 = 1) (2/10 = 0) (. = 0), g(enrolled)
replace offered = 0 if offered == .
lab var offered "Voucher Winner"
lab var accepted "Accepted Voucher"
lab var enrolled "Enrolled in Private School"

* GENERATING DISTRICT DUMMIES:
forval i = 1/5 {
	replace district_code = `i' if distnames == `i' & district_code == .
}
qui tab district_code, g(dist_)
lab var dist_1 "Visakhapatnman"
lab var dist_2 "East Godavari"
lab var dist_3 "Kadapa"
lab var dist_4 "Medak"
lab var dist_5 "Nizamabad"

* GENERATING TELENGANA VARIABLE
recode district_code (1 2 = 0) (3 = 1) (4 5 = 2), g(telangana)
lab define telangana 0 "Coastal Andhra" 1 "Rayalseema" 2 "Telangana"
lab value telangana telangana

compress
save "`clean'/survey_clean.dta", replace

/*
***************************
* Cleaning replication data from qje paper and merge with survey_clean.dta
***************************
*/

use hplstudentcode y4_hindi_pr_l y4_hindi_pr_w y4_hindi_pr_li y4_hindi_pr_mcq y4_hindi_pr_pg hhold_asset_indx parents_prim y0_base_norm parents_g10 schedule_ct district using "`qje'/hindi questions y4 replication.dta", clear

ren hplstudentcode apfstudentcode
tempfile temp
save `temp', replace

use hplstudentcode y0_tel_norm y0_math_norm parents_prim hhold_asset_indx parents_g10 schedule_ct using "`qje'/main assessment y1-y2 replication.dta", clear

ren hplstudentcode apfstudentcode
merge 1:1 apfstudentcode using `temp', update
drop _merge
tempfile temp
save `temp', replace

use num_pri_sch closest_pri_sch_eng closest_pri_sch_tel nearest_applied_count num_pri_sch_1km num_pri_sch_1km_3plus num_pri_sch_1km_5plus num_pri_sch_1km_6plus y3_scholar y4_scholar attends_pri_eng_y3 attends_pri_tel_y3 attends_pri_eng_y4 attends_pri_tel_y4 total_scholarship_students year ipw_y4_combined ipw_y3_combined hplstudentcode score exam using "`qje'/main assessment y2-y4 long replication.dta", clear

ren total_scholarship_students t_scholar_student

reshape wide score num_pri_sch closest_pri_sch_eng closest_pri_sch_tel nearest_applied_count num_pri_sch_1km num_pri_sch_1km_3plus num_pri_sch_1km_5plus num_pri_sch_1km_6plus y3_scholar y4_scholar attends_pri_eng_y3 attends_pri_tel_y3 attends_pri_eng_y4 attends_pri_tel_y4 t_scholar_student year ipw_y4_combined ipw_y3_combined, i(hplstudentcode) j(exam) string

ren hplstudentcode apfstudentcode
merge 1:1 apfstudentcode using `temp'
drop _merge
tempfile temp
save `temp', replace

use y4_evs_hel_norm y4_eng_lel_norm y4_telugu_norm y4_math_norm y4_present4all_end y4_hindi_ability_norm y3_eng_hel_norm y3_telugu_norm y3_math_norm y3_present4all_end schedule_ct hplstudentcode using "`qje'/main assessment y2-y4 replication.dta", clear

ren hplstudentcode apfstudentcode
merge 1:1 apfstudentcode using `temp', update
drop _merge
tempfile temp
save `temp', replace

use hplstudentcode hh_exp_admissions hh_exp_uniforms hh_exp_textbooks hh_exp_specialevents hh_exp_transportation hh_exp_privatetuition total_hh_exp temp_mins_s4q31a temp_mins_s4q31b temp_mins_s4q31c temp_mins_s4q31d temp_mins_s4q31e temp_mins_s4q31k temp_mins_s4q31l temp_mins_s4q31m working chores freetime year using "`qje'/parent child y1-y4 replication.dta", clear

reshape wide hh_exp_admissions hh_exp_uniforms hh_exp_textbooks hh_exp_specialevents hh_exp_transportation hh_exp_privatetuition total_hh_exp temp_mins_s4q31a temp_mins_s4q31b temp_mins_s4q31c temp_mins_s4q31d temp_mins_s4q31e temp_mins_s4q31k temp_mins_s4q31l temp_mins_s4q31m working chores freetime, i(hplstudentcode) j(year)

ren hplstudentcode apfstudentcode
merge 1:1 apfstudentcode using `temp'
drop _merge
tostring apfstudentcode, replace

ren district district_baseline

lab var y4_hindi_pr_l "Hindi Score (Year 4): Letters"
lab var y4_hindi_pr_w "Hindi Score (Year 4): Words"
lab var y4_hindi_pr_li "Hindi Score (Year 4): Sentences"
lab var y4_hindi_pr_mcq "Hindi Score (Year 4): Multiple Choice"
lab var y4_hindi_pr_pg "Hindi Score (Year 4): Paragraph"
lab var parents_g10 "Parents Reached Grade 10"
lab var parents_prim "Parents Completed at Least Primary"
lab var hhold_asset_indx "Household Asset Index at Baseline"
lab var y0_tel_norm "Baseline Telugu Test Score"
lab var y0_math_norm "Baseline Math Test Score"
lab var schedule_ct "SC/ST"

tempfile temp
save `temp', replace

use apfschoolcode year s1q03 s1q05 s1q18 water_avail toi_funct sep_funct elec_funct comp_funct lib_funct rad_funct ptr fees_per_student perkid_spending_total perkid_salary_only using "`qje'/school long y1-y4 replication.dta", clear

reshape wide s1q03 s1q05 s1q18 water_avail toi_funct sep_funct elec_funct comp_funct lib_funct rad_funct ptr fees_per_student perkid_spending_total perkid_salary_only, i(apfschoolcode) j(year)

tempfile temp_school
save `temp_school', replace

use apfschoolcode flies_present stag_water garb_dump using "`qje'/school short y3-y4 replication.dta", clear

collapse (mean) flies_present stag_water garb_dump, by(apfschoolcode)

merge 1:1 apfschoolcode using `temp_school'
drop _merge
tempfile temp_school
save `temp_school', replace

use apfschoolcode year Math English Telugu SocialStudies GeneralScience Hindi MoralScience ComputerUse Break TotalHours Other TotalInstruction using "`qje'/school timeuse replication.dta", clear

merge 1:1 apfschoolcode using `temp_school'
drop _merge
tempfile temp_school
save `temp_school', replace

use apfschoolcode year absent_b4_class active_teaching not_teaching using "`qje'/teacher short y1-y4 replication.dta", clear

egen missing = rowmiss(absent_b4_class active_teaching not_teaching)
drop if missing == 3

collapse (mean) absent_b4_class active_teaching not_teaching, by(apfschoolcode year)

reshape wide absent_b4_class active_teaching not_teaching, i(apfschoolcode) j(year)

merge 1:1 apfschoolcode using `temp_school'
drop _merge

ren apfschoolcode schoolcode_end

tempfile temp_school
save `temp_school', replace

use "`clean'/survey_clean.dta", clear

merge 1:1 apfstudentcode using `temp'
drop if _merge == 2
drop _merge

merge m:1 schoolcode_end using `temp_school'
drop if _merge == 2
drop _merge

g include = 1

replace district_code = district_baseline if district_code == . | district_baseline != .

* Getting schoolcode_end
merge 1:1 apfstudentcode using "`raw'/downstream_sample_third.dta", keepus(schoolcode_end schoolcode_base pucode) update
keep if include == 1
replace pu_code = pucode
drop _merge

g x = substr(apfstudentcode, 1, 1)
destring x, replace
replace district_code = x if district_code == .
drop x

compress
save "`clean'/survey_clean.dta", replace

*******************************************************************************
* Creating individual test score data set
*******************************************************************************

use hplstudentcode district pucode y0_tel_norm y0_math_norm y0_base_norm y4_evs_hel_norm y4_eng_lel_norm y4_telugu_norm y4_math_norm y4_hindi_ability_norm y3_eng_hel_norm y3_telugu_norm y3_math_norm using "`qje'/main assessment y2-y4 replication.dta", clear

ren hplstudentcode apfstudentcode
tostring apfstudentcode, replace

merge 1:1 apfstudentcode using "`clean'/survey_clean.dta"

drop if _merge == 1
drop _merge

save "`clean'/individual_test_scores.dta", replace

*******************************************************************************
* Creating combined test score data set
*******************************************************************************

use hplstudentcode district pucode exam y0_base_norm schedule_ct parents_prim hhold_asset_indx score using "`qje'/main assessment y2-y4 long replication.dta", clear

* Generating dummy for Year 2 or Year 4 data:
g year_2 = 1 if regexm(exam, "[y][3]$")
g year_4 = 1 if regexm(exam, "[y][4]$")

ren hplstudentcode apfstudentcode
tostring apfstudentcode, replace

merge m:1 apfstudentcode using "`clean'/survey_clean.dta"
drop if _merge == 1
drop _merge

save "`clean'/combined_test_scores.dta", replace

exit
