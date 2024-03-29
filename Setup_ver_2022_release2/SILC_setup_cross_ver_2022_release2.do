*******************************
*** 	EU-SILC: Setup 		***
*******************************

clear all

* enter your path to the folder with the downloaded EU-SILC files ("Cross")
global csv_path "[YOUR PATH]"

* destination for the .log and .dta files created via adjusted EU-SILC setup files in the "Setup_ver_2022_release2" folder
global log "[YOUR PATH]"




* create log files with var labels
* transforms .csv files to .dta 

forval x = 2004/2021 { // !!!! <- adjust years !!!
	
	foreach y in p r h d {
		
		run "$csv_path/Setup_ver_2022_release2/`x'_cross_eu_silc_`y'_ver_2022_release2.do"
	}
}



* Merge files (r,p,h,d) for each year
* format of the final data files: SILC`year'_ver_2022_release2.dta (e.g. SILC2014_ver_2022_release2.dta)

local time "04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21" // <- !!! adjust years !!!

foreach t of local time {
noisily: display "Preparing EU-SILC 20`t'" 
	
	global datapath "[YOUR PATH]" // <- folder where the .dta files are stored (should be the same as in "global log" above)
	
	global outpath "[YOUR PATH]" // <- destination of the merged .dta files
	cd "${datapath}" 

	local prefix "eusilc_20`t'_"
	local suffix "_cs"
	local year 20`t'
	global versdat 1

	*link R and P files
			
	use "${datapath}/`prefix'r`suffix'", clear 
				
	foreach var of varlist _all {
		local newname = lower("`var'")
		cap rename `var' `newname'
		}

	cap rename rb010 year
	cap rename rb020 country
	cap rename rb030 pid
	cap rename rx030 hid

	sort year country pid
	compress
	save "r-file`year'.dta", replace

	use "${datapath}/`prefix'p`suffix'", clear

	foreach var of varlist _all {
		local newname = lower("`var'")
		cap rename `var' `newname'
		}
		
	cap rename pb010 year
	cap rename pb020 country
	cap rename pb030 pid

	cap sort year country pid
	compress
	save "p-file`year'.dta", replace

	merge 1:1 year country pid using "r-file`year'.dta"

	cap rename _merge _mergeRP
	sort country hid
	save "rp-file`year'.dta", replace

	*link H file and D file

	use "${datapath}/`prefix'h`suffix'" , clear 

	foreach var of varlist _all {
		local newname = lower("`var'")
		cap rename `var' `newname'
	}

	cap rename hb010 year
	cap rename hb020 country
	cap rename hb030 hid

	sort year country hid
	compress
	save "h-file`year'.dta", replace

	use "${datapath}/`prefix'd`suffix'", clear
	compress
	foreach var of varlist _all {
		local newname = lower("`var'")
		cap rename `var' `newname'
		}
		
	cap rename db010 year
	cap rename db020 country
	cap rename db030 hid

	sort year country hid
	save "d-file`year'.dta", replace
				
	merge 1:1 year country hid using "h-file`year'.dta"
	cap rename _merge _mergeDH
	sort country hid

	save "hd-file`year'.dta", replace

	*link RP file and HD file

	merge 1:m year country hid using "rp-file`year'.dta"

	cap drop __*
	compress
	save "${outpath}/SILC`year'_ver_2022_release2.dta", replace

	erase "r-file`year'.dta"
	erase "p-file`year'.dta"
	erase "rp-file`year'.dta"
	erase "d-file`year'.dta"
	erase "h-file`year'.dta"
	erase "hd-file`year'.dta"
}
