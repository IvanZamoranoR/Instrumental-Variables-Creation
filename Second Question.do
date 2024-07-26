*-------------------------------------------------------------------------------
* RA Second Exercise: Distortions of the Mexican Economy
* Author: Iván Zamorano
* Date: 10/05/2024
*-------------------------------------------------------------------------------

clear all

*==============================================================================*
*                                                                              *
*                                   Code                                       *
*                                                                              *
*==============================================================================*

* Get Data (Change Directory accordingly)


cd "/Users/ivanzamorano/Downloads/RA Exam/"

* Convert csv files into .dta version
 
clear
local myfilelist : dir . files"*.csv"
foreach file of local myfilelist {
drop _all
insheet using `file', comma
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'", replace
}

* Merging Economic Census data base with other data bases 

use ce.dta
merge 1:1 id_uelm year using enafin.dta
rename _merge _merge_enafin
merge 1:1 id_uelm year using enaproce.dta
rename _merge _merge_enaproce
merge 1:1 id_uelm year using enve.dta



* Identifying variables related to the distortions 
* We can give more detail here !!! 
keep year ent workers sector2d size sales id_uelm est_type vat_sales ssc subsidies exp_sec cost_crime bribes risk_free_rate regulation_taxes bureaucracy_cost wagebill


* Value - added taxes that firms pay (vat_sales)
* Calculate sums of value added taxes and sales by year and id_uelm
egen temp_vat_sales = total(vat_sales), by(year id_uelm)
egen temp_sales = total(sales), by(year id_uelm)
* Calculate share of subsidies in total sales
gen vat_sales_share = (temp_vat_sales / temp_sales)*100


* Subsidies that firms receive from the government (subsidies)
egen temp_subsidies = total(subsidies), by(year id_uelm)
gen subsidies_share = (temp_subsidies / temp_sales)*100



* Amount of money firms spend on preventive security measures (exp_sec)
egen temp_exp_sec = total(exp_sec), by(year id_uelm)
gen exp_sec_share = (temp_exp_sec / temp_sales)*100



* Amount of money firms lose when they are victims of a crime (cost_crime)
egen temp_cost_crime = total(cost_crime), by(year id_uelm)
gen cost_crime_share = (temp_cost_crime / temp_sales)*100


* Amount of money firms pay to government officials as bribes (bribes)
egen temp_bribes = total(bribes), by(year id_uelm)
gen bribes_share = (temp_bribes / temp_sales)*100


* Amount of money firms pay to meet regulations (regulation_taxes)
egen temp_regulation_taxes = total(regulation_taxes), by(year id_uelm)
gen regulation_taxes_share = (temp_regulation_taxes / temp_sales)*100


* Amount of money firm pay their workes to ensure they comply with regulations (bureaucracy_cost)
egen temp_bureaucracy_cost = total(bureaucracy_cost), by(year id_uelm)
gen bureaucracy_cost_share = (temp_bureaucracy_cost / temp_sales)*100


* Labor taxes as share of wagebill (ssc and wagebill)
* Calculate sums of labor taxes and wagebills by year and id_uelm
egen temp_ssc = total(ssc), by(year id_uelm)
egen temp_wagebill = total(wagebill), by(year id_uelm)
* Calculate share of subsidies in total sales
gen ssc_share = (temp_ssc / temp_wagebill)*100


keep year sales year ent workers sector2d size  id_uelm est_type vat_sales_share ssc_share subsidies_share exp_sec_share cost_crime_share bribes_share risk_free_rate regulation_taxes_share bureaucracy_cost_share wagebill

* Summary statistics 1

summarize vat_sales_share ssc_share subsidies_share exp_sec_share cost_crime_share bribes_share risk_free_rate regulation_taxes_share bureaucracy_cost_share, detail
outsheet using summary_stats1.xlsx, replace


*vat_sales_share

* Calculate 5th and 95th percentiles by establishment type and year
sort est_type year
by est_type year: egen p5_vat_sales_share = pctile(vat_sales_share), p(5)
by est_type year: egen p95_vat_sales_share = pctile(vat_sales_share), p(95)


* Step 2: Winsorize 
replace vat_sales_share = p5_vat_sales_share if vat_sales_share < p5_vat_sales_share & vat_sales_share != 0
replace vat_sales_share = p95_vat_sales_share if vat_sales_share > p95_vat_sales_share


*ssc_share
sort est_type year
by est_type year: egen p5_ssc_share = pctile(ssc_share), p(5)
by est_type year: egen p95_ssc_share = pctile(ssc_share), p(95)
replace ssc_share = p5_ssc_share if ssc_share < p5_ssc_share & ssc_share != 0
replace ssc_share = p95_ssc_share if ssc_share > p95_ssc_share


*subsidies_share
sort est_type year
by est_type year: egen p5_subsidies_share = pctile(subsidies_share), p(5)
by est_type year: egen p95_subsidies_share = pctile(subsidies_share), p(95)
replace subsidies_share = p5_subsidies_share if subsidies_share < p5_subsidies_share & subsidies_share != 0
replace subsidies_share = p95_subsidies_share if subsidies_share > p95_subsidies_share


*cost_crime_share
sort est_type year
by est_type year: egen p5_cost_crime_share = pctile(cost_crime_share), p(5)
by est_type year: egen p95_cost_crime_share= pctile(cost_crime_share), p(95)
replace cost_crime_share = p5_cost_crime_share if cost_crime_share < p5_cost_crime_share & cost_crime_share != 0
replace cost_crime_share = p95_cost_crime_share if cost_crime_share > p95_cost_crime_share


*bribes_share
sort est_type year
by est_type year: egen p5_bribes_share = pctile(bribes_share), p(5)
by est_type year: egen p95_bribes_share = pctile(bribes_share), p(95)
replace bribes_share = p5_bribes_share if bribes_share < p5_bribes_share & bribes_share != 0
replace bribes_share = p95_bribes_share if bribes_share > p95_bribes_share


*risk_free_rate
sort est_type year
by est_type year: egen p5_risk_free_rate = pctile(risk_free_rate), p(5)
by est_type year: egen p95_risk_free_rate = pctile(risk_free_rate), p(95)
replace risk_free_rate = p5_risk_free_rate if risk_free_rate < p5_risk_free_rate & risk_free_rate != 0
replace risk_free_rate = p95_risk_free_rate if risk_free_rate > p95_risk_free_rate


*regulation_taxes_share
sort est_type year
by est_type year: egen p5_regulation_taxes_share = pctile(regulation_taxes_share), p(5)
by est_type year: egen p95_regulation_taxes_share = pctile(regulation_taxes_share), p(95)
replace regulation_taxes_share = p5_regulation_taxes_share if regulation_taxes_share < p5_regulation_taxes_share & regulation_taxes_share != 0
replace regulation_taxes_share = p95_regulation_taxes_share if regulation_taxes_share > p95_regulation_taxes_share

*bureaucracy_cost_share

sort est_type year
by est_type year: egen p5_bureaucracy_cost_share = pctile(bureaucracy_cost_share), p(5)
by est_type year: egen p95_bureaucracy_cost_share = pctile(bureaucracy_cost_share), p(95)
replace bureaucracy_cost_share = p5_bureaucracy_cost_share if bureaucracy_cost_share < p5_bureaucracy_cost_share & bureaucracy_cost_share != 0
replace bureaucracy_cost_share = p95_bureaucracy_cost_share if bureaucracy_cost_share > p95_bureaucracy_cost_share

*Summary Statistics 2
summarize vat_sales_share ssc_share subsidies_share exp_sec_share cost_crime_share bribes_share risk_free_rate regulation_taxes_share bureaucracy_cost_share, detail
outsheet using summary_stats2.xlsx, replace

*Obtaining log of workers

gen log_workers = log(workers)

gen log_workers_squared = log_workers^2
gen log_workers_cubed = log_workers^3
gen year_squared = year^2



*Regression for measure of distortion: vat_sales_share

* Create variable "observed_vat_sales_share"
gen observed_vat_sales_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_vat_sales_share = 1 if !missing(vat_sales_share)
replace observed_vat_sales_share = 0 if missing(vat_sales_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg vat_sales_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_vat_sales_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace vat_sales_share = predicted_vat_sales_share if observed_vat_sales_share == 0

* Estimate the same regression using predicted values 
xtreg vat_sales_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe






*Regression for measure of distortion: ssc_share
* Create variable "observedssc_share"
gen observed_ssc_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_ssc_share = 1 if !missing(ssc_share)
replace observed_ssc_share = 0 if missing(ssc_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg ssc_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_ssc_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace ssc_share = predicted_ssc_share if observed_ssc_share == 0

* Estimate the same regression using predicted values 
xtreg ssc_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe






*Regression for measure of distortion: subsidies_share
* Create variable "subsidies_share"
gen observed_subsidies_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_subsidies_share = 1 if !missing(subsidies_share)
replace observed_subsidies_share = 0 if missing(subsidies_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg subsidies_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_subsidies_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace subsidies_share = predicted_subsidies_share if observed_subsidies_share == 0

* Estimate the same regression using predicted values 
xtreg subsidies_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe








*Regression for measure of distortion: exp_sec_share
* Create variable "subsidies_share"
gen observed_exp_sec_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_exp_sec_share = 1 if !missing(exp_sec_share)
replace observed_exp_sec_share = 0 if missing(exp_sec_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg exp_sec_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_exp_sec_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace exp_sec_share = predicted_exp_sec_share if observed_exp_sec_share == 0

* Estimate the same regression using predicted values 
xtreg exp_sec_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe






*Regression for measure of distortion: cost_crime_share
* Create variable "cost_crime_share"
gen observed_cost_crime_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_cost_crime_share = 1 if !missing(cost_crime_share)
replace observed_cost_crime_share= 0 if missing(cost_crime_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg cost_crime_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_cost_crime_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace cost_crime_share = predicted_cost_crime_share if observed_cost_crime_share== 0

* Estimate the same regression using predicted values 
xtreg cost_crime_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe




*Regression for measure of distortion: bribes_share
* Create variable "bribes_share"
gen observed_bribes_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_bribes_share = 1 if !missing(bribes_share)
replace observed_bribes_share = 0 if missing(bribes_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg bribes_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_bribes_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace bribes_share = predicted_bribes_share if observed_bribes_share== 0

* Estimate the same regression using predicted values 
xtreg bribes_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe





*Regression for measure of distortion: risk_free_rate
* Create variable "risk_free_rate"
gen observed_risk_free_rate = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_risk_free_rate = 1 if !missing(risk_free_rate)
replace observed_risk_free_rate = 0 if missing(risk_free_rate)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg risk_free_rate log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_risk_free_rate, xb

* Replace observed distorsion with predicted values for firms not observed
replace risk_free_rate = predicted_risk_free_rate if observed_risk_free_rate== 0

* Estimate the same regression using predicted values 
xtreg risk_free_rate log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe




*Regression for measure of distortion: regulation_taxes_share
* Create variable "regulation_taxes_share"
gen observed_regulation_taxes_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_regulation_taxes_share = 1 if !missing(regulation_taxes_share)
replace observed_regulation_taxes_share = 0 if missing(regulation_taxes_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg regulation_taxes_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_regulation_taxes_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace regulation_taxes_share = predicted_regulation_taxes_share if observed_regulation_taxes_share== 0

* Estimate the same regression using predicted values 
xtreg regulation_taxes_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe





*Regression for measure of distortion: bureaucracy_cost_share
* Create variable "bureaucracy_cost_share"
gen observed_bureaucracy_cost_share = .

* Assign value 1 if the distorsion has a value, otherwise assign 0
replace observed_bureaucracy_cost_share = 1 if !missing(bureaucracy_cost_share)
replace observed_bureaucracy_cost_share = 0 if missing(bureaucracy_cost_share)

xtset id_uelm year

* Run the first xtreg regression and store the coefficients
xtreg bureaucracy_cost_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe
matrix reg_coefs = e(b)

* Predict for firms not observed in each survey using the stored coefficients
predict predicted_bureaucracy_cost_share, xb

* Replace observed distorsion with predicted values for firms not observed
replace bureaucracy_cost_share = predicted_bureaucracy_cost_share if observed_bureaucracy_cost_share == 0

* Estimate the same regression using predicted values 
xtreg bureaucracy_cost_share log_workers log_workers_squared log_workers_cubed year year_squared i.ent i.sector2d i.est_type i.size, fe




* Summary statistics 3

summarize predicted_vat_sales_share predicted_bribes_share predicted_bureaucracy_cost_share predicted_cost_crime_share predicted_cost_crime_share predicted_exp_sec_share predicted_exp_sec_share predicted_regulation_taxes_share predicted_risk_free_rate predicted_ssc_share predicted_subsidies_share, detail
outsheet using summary_stats3.xlsx, replace
