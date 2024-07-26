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

use INEGI_employment.dta
