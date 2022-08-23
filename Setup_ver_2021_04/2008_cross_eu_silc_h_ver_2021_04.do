* 2008_cross_eu_silc_h_ver_2021_04.do
* 2nd update 
*
* STATA Command Syntax File
* Stata 16.1;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* 
* EU-SILC Cross 2008 - release 2021-04 / DOI: https://doi.org/10.2907/EUSILC2004-2019V.2
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> – version of 2021-04"
*
* Household data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*08D.csv
* 
* (c) GESIS 2021-11-17
*
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* C-2008 DIFFERENCES BETWEEN DATA COLLECTED.doc	
* 
* This Stata-File is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
* 
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
* Pforr, Klaus and Johanna Jung (2021): 2008_cross_eu_silc_h_ver_2021_04.do, 2nd update.
* Stata-Syntax for transforming EU-SILC csv data into a Stata-Systemfile.
*
* https://www.gesis.org/gml/european-microdata/eu-silc/
*
* Contact: klaus.pforr@gesis.org


/* Initialization commands */

clear 
capture log close
set more off
set linesize 250
set varabbrev off
#delimit ;


* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
* CONFIGURATION SECTION - Start ;

* The following command should contain the complete path and
* name of the Stata log file.
* Change LOG_FILENAME to your filename ; 

local log_file "$log/eusilc_2008_h" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2019) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2008_h_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK UK { ;
      cd "$csv_path/`CC'/2008" ;
	  import delimited using "UDB_c`CC'08H.csv", case(upper) clear;
append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort HB020 ;

log using "`log_file'", replace text ;



* Definition of variable labels ;

label variable HB010 "Year of the survey" ;
label variable HB020 "country alphanumeric" ;
label variable HB030 "Household ID" ;
label variable HB050 "Quarter of household interview" ;
label variable HB050_F "Flags" ;
label variable HB060 "Year of household interview" ;
label variable HB060_F "Flag" ;
label variable HB070 "Person responding to household questionnaire" ;
label variable HB070_F "Flag" ;
label variable HB080 "Person 1 responsible for the accommodation" ;
label variable HB080_F "Flag" ;
label variable HB090 "Person 2 responsible for the accommodation" ;
label variable HB090_F  "Flag" ;
label variable HB100 "Number of Minutes to complete the household questionnaire" ;
label variable HB100_F "flag" ;
label variable HY010 "Total Household Gross Income" ;
label variable HY010_F "Flag" ;
label variable HY010_I "Imputation factor" ;
label variable HY020 "total disposable household income" ;
label variable HY020_F "Flag" ;
label variable HY020_I "Imputation Factor" ;
label variable HY022 "Total disposable Household Income before social transfers other than old-age and survivors benefits" ;
label variable HY022_F "Flag" ;
label variable HY022_I "Imputation Factor" ;
label variable HY023 "Total disposable Household income before social transfers including old-age and survivors benefits" ;
label variable HY023_F "Flag" ;
label variable HY023_I "Imputation Factor" ;
label variable HY025 "Within Household non-response inflation factor" ;
label variable HY025_F "Flag" ;
label variable HY030N "Imputed rent (net)" ; 
label variable HY030N_F "Flag" ;
label variable HY040N "Income from rental of a property or land(net)" ; 
label variable HY040N_F "Flag" ;
label variable HY040N_I "Imputation factor" ;
label variable HY050N "FamilyChildren related allowances (net)" ;
label variable HY050N_F "Flag" ;
label variable HY050N_I "Imputation factor" ;
label variable HY060N "Social Exclusion not elsewhere classified(net)" ;
label variable HY060N_F "Flag" ; 
label variable HY060N_I "Imputation Factor" ;
label variable HY070N "Housing Allowances(net)" ;
label variable HY070N_F "Flag" ;
label variable HY070N_I "Imputation factor" ;
label variable HY080N "Regular inter-household cash received (net)" ;
label variable HY080N_F "Flag" ;
label variable HY080N_I "Imputation Factor" ;
label variable HY090N "Interests,dividends,profit from capital investment in uncorporated business (net)" ;
label variable HY090N_F "Flag" ;
label variable HY090N_I "Imputation Factor" ;
label variable HY100N "Interest Repayment on mortgage(net)" ;
label variable HY100N_F "Flag" ;
label variable HY100N_I "Imputation factor" ;
label variable HY110N "Income received by people aged under 16(net)" ;
label variable HY110N_F "Flag" ;
label variable HY110N_I "Imputation Factor" ;
label variable HY120N "Regular taxes on wealth(net)" ;
label variable HY120N_F "Flag" ;
label variable HY120N_I "Imputation Factor" ;
label variable HY130N "Regular inter-household cash transfer paid" ;
label variable HY130N_F "Flag" ;
label variable HY130N_I "Imputation factor" ;
label variable HY140N "Tax on income and social contribution" ;
label variable HY140N_F "Flag" ;
label variable HY140N_I "Imputation Factor" ;
label variable HY145N "repaymentsreceipts for tax adjustment(net)" ;
label variable HY145N_F "Flag" ;
label variable HY145N_I "Imputation Factor" ;
label variable HY030G "Imputed rent (gross)" ;
label variable HY030G_F "Flag" ;
label variable HY040G "Income from rental of a property or land (gross)" ;
label variable HY040G_F "Flag" ;
label variable HY040G_I "Imputation Factor" ;
label variable HY050G  "FamilyChildren related allowances (gross)" ;
label variable HY050G_F "Flag" ;
label variable HY050G_I "Imputation Factor" ;
label variable HY060G  "Social Exclusion not elsewhere classified(gross)" ;
label variable HY060G_F "Flag" ;
label variable HY060G_I "Imputation Factor" ;
label variable HY070G "Housing allowances(gross)" ;
label variable HY070G_F "Flag" ;
label variable HY070G_I "Imputation Factor" ;
label variable HY080G "Regular Interhousehold cash transfer received(gross)" ;
label variable HY080G_F "Flag" ;
label variable HY080G_I "Imputation Factor" ;
label variable HY090G "Interests,dividends,profit from capital investment in uncorporated business (gross)" ;
label variable HY090G_F "Flag" ;
label variable HY090G_I "Imputation Factor" ;
label variable HY100G "Interest Repayments on Mortgage(Gross)" ;
label variable HY100G_F "Flag" ;
label variable HY100G_I "Imputation Factor" ;
label variable HY110G "Income received by people aged under 16 (Gross)" ;
label variable HY110G_F "Flag" ;
label variable HY110G_I "Imputation Factor" ;
label variable HY120G "Regular Taxes on Wealth(Gross)" ;
label variable HY120G_F "Flag" ;
label variable HY120G_I "Imputation factor" ;
label variable HY130G "Regular interhousehold cash transfer paid(gross)" ;
label variable HY130G_F "Flag" ;
label variable HY130G_I "Imputation Factor" ;
label variable HY140G "Tax on income and social contributions(gross)" ;
label variable HY140G_F "Flag" ;
label variable HY140G_I "Imputation Factor" ;
label variable HS010 " Arrears on Mortgage or Rent Payments" ;
label variable HS010_F "Flag" ;
label variable HS011 "Arrears on Mortgage or Rent Payments" ;
label variable HS011_F "Flag" ;
label variable HS020 "Arrears on utility bills" ;
label variable HS020_F "Flag" ;
label variable HS021 "Arrears on utility bills" ;
label variable HS021_F "Flag" ;
label variable HS030 "Arrears on Hire purchase instalments or other loan payments" ;
label variable HS030_F "Flag" ;
label variable HS031 "Arrears on Hire purchase instalments or other loan payments" ;
label variable HS031_F "Flag" ;
label variable HS040 "Capacity to afford paying for one week annual holiday away from home" ;
label variable HS040_F "Flag" ;
label variable HS050 "Capacity to afford a meal with meat, chicken, fish (or vegetarian equivalent) every second day" ;
label variable HS050_F "Flag" ;
label variable HS060 "Capacity to face unexpected financial expenses" ;
label variable HS060_F "Flag" ;
label variable HS070 "Do you have a telephone (including mobile phone)?" ;
label variable HS070_F "Flag" ;
label variable HS080 "Do you have a colour TV?" ;
label variable HS080_F "Flag" ;
label variable HS090 "Do you have a computer?" ;
label variable HS090_F "Flag" ;
label variable HS100 "Do you have a washing maschine?" ;
label variable HS100_F "Flag" ;
label variable HS110 "Do you have a car?" ;
label variable HS110_F "Flag" ;
label variable HS120 "Ability to make ends meet" ;
label variable HS120_F "Flag" ;
label variable HS130 "Lowest monthly income to make end meet" ;
label variable HS130_F "Flag" ;
label variable HS140 "Financial burden of the total housing cost" ;
label variable HS140_F "Flag" ;
label variable HS150 "Financial Burden of the repayment of debts from hire purchases or loans" ;
label variable HS150_F "Flag" ;
label variable HS160 "Problems with the dwelling:too dark, not enough light" ;
label variable HS160_F "Flag" ;
label variable HS170 "Noise from neighbours or from the street" ;
label variable HS170_F "Flag" ;
label variable HS180 "Pollution, grime or other environmental problems" ;
label variable HS180_F "Flag" ;
label variable HS190 "Crime violence or vandalism in the area" ;
label variable HS190_F "Flag" ;
label variable HH010 "Dwelling Type" ;
label variable HH010_F "Flag" ;
label variable HH020 "Tenure Status" ;
label variable HH020_F "Flag" ;
label variable HH030 "Number of rooms available to the household" ;
label variable HH030_F "Flag" ;
label variable HH031 "Year of contract or purchasing or installation" ;
label variable HH031_F "Flag" ;
label variable HH040 "Leaking roof, damp wallsfloorsfoundation, or rot in window frame or floor" ;
label variable HH040_F "Flag" ;
label variable HH050 "Ability to keep home adequately warm" ;
label variable HH050_F "Flag" ;
label variable HH060 "Current rent related to occupied dwelling" ;
label variable HH060_F "Flag" ;
label variable HH061 "Subjective rent" ;
label variable HH061_F  "Flag" ;
label variable HH070 "Total Housing cost" ;
label variable HH070_F "Flag" ;
label variable HH080 "Bath or shower in Dwelling" ;
label variable HH080_F "Flag" ;
label variable HH081 "Bath or shower in Dwelling" ;
label variable HH081_F "Flag" ;
label variable HH090 "Indoor flushing toilet for sole use of household" ;
label variable HH090_F "Flag" ;
label variable HH091 "Indoor flushing toilet for sole use of household" ;
label variable HH091_F "Flag" ;
label variable MI010 " Household has a bank current account" ;
label variable MI010_F "Flag" ;
label variable MI020 " Household is overdrawn on one of its bank accounts" ;
label variable MI020_F "Flag" ;
label variable MI025 " Estimated total amount unbalanced on hhld banks accounts in classes" ;
label variable MI025_F "Flag" ;
label variable MI026 " Total amount unbalanced on hhld banks accounts (exact amount) Optional Variable" ;
label variable MI026_F "Flag" ;
label variable MI030 "Household has credit card(s) andor store card(s)" ;
label variable MI030_F "Flag" ;
label variable MI040 "Household has credit card(s) andor store card(s) with un-cleared balances" ;
label variable MI040_F "Flag" ;
label variable MI045 "Estimated total amount unbalanced at the last monthly statement on household creditstore cards in classes" ;
label variable MI045_F "Flag" ;
label variable MI046 "Total amount unbalanced at the last monthly statement on hhld creditstore cards (exact amounts) Optional Var" ;
label variable MI046_F "Flag" ;
label variable MI050 "Household has credits or loans (other than mortgage for the main dwelling)" ;
label variable MI050_F "Flag" ;
label variable MI051 "Household has mortgage for other than the main dwelling" ;
label variable MI051_F "Flag" ;
label variable MI052 "Household has hire purchase instalments (e g  leasing, car, technical equipment)" ;
label variable MI052_F "Flag" ;
label variable MI053 "Household has home-related creditloans (inventory, domestic appliances, repairs)" ;
label variable MI053_F "Flag" ;
label variable MI054 "Household has credit (loans) to pay for holidaysleisure" ;
label variable MI054_F "Flag" ;
label variable MI055 "Household has credit (loans) to pay for education or child care" ;
label variable MI055_F "Flag" ;
label variable MI056 "Household has credit (loans) to pay for health issues" ;
label variable MI056_F "Flag" ;
label variable MI057 "Household has credit (loans) for investment or business start-up" ;
label variable MI057_F "Flag" ;
label variable MI058 "Household has other cash loans (debt conversion, to cover overdraft, credit card and other bills, etc )" ;
label variable MI058_F "Flag" ;
label variable MI060 "Arrears on other non-housing household bills" ;
label variable MI060_F "Flag" ;
label variable MI065 "Estimated total amount currently in arrears for other non-housing household bills in classes" ;
label variable MI065_F "Flag" ;
label variable MI066 "Total amount currently in arrears for other non-housing household bills (exact amounts) Optional Variable" ;
label variable MI066_F "Flag" ;
label variable MI075 "Estimated total amount currently in arrears for household housing bill,srepayments in classes" ;
label variable MI075_F "Flag" ;
label variable MI076 "Total amount currently in arrears for other non-housing household bills (exact amounts) Optional Variable" ;
label variable MI076_F "Flag" ;
label variable MI085 "Estimated total amount currently in arrears for household other loans and credit repayment in classes" ;
label variable MI085_F "Flag" ;
label variable MI086 "Total amount currently in arrears for household other loans and credit repayment (exact amounts) Optional Var " ;
label variable MI086_F "Flag" ;
label variable MI090 "Major drop in household income during the last 12 montHS" ;
label variable MI090_F "Flag" ;
label variable MI095 "Main reason for drop in income" ;
label variable MI095_F "Flag" ;
label variable MI100 "Expectation of financial situation in the next 12 montHS; do you expect your financial situation" ;
label variable MI100_F "Flag" ;
label variable MI110 "Household does not need an account and prefers to deal in cash" ;
label variable MI110_F "Flag" ;
label variable MI111 "The charges are too high" ;
label variable MI111_F "Flag" ;
label variable MI112 "There is no bank branch near where household lives or works" ;
label variable MI112_F "Flag" ;
label variable MI113 "Household has applied for an account and been turned down" ;
label variable MI113_F "Flag" ;
label variable MI114 "Banks would refuse household" ;
label variable MI114_F "Flag" ;
label variable MI120 "Household does not need to borrow at all" ;
label variable MI120_F "Flag" ;
label variable MI121 "Household can borrow from family or friends" ;
label variable MI121_F "Flag" ;
label variable MI122  "Household will not be able to repay debt" ;
label variable MI122_F "Flag" ;
label variable MI123 "Household has applied for credit and been turned down" ;
label variable MI123_F "Flag" ;
label variable MI124 "Household used to have credit but the facility was withdrawn" ;
label variable MI124_F "Flag" ;
label variable MI125 "Banks would refuse to give credit to household" ;
label variable MI125_F "Flag" ;
label variable HX040 "Household size" ;
label variable HX050 "Equivalised Household Size" ;
label variable HX090 "Equivalised disposable income" ;
label variable HX080 "Poverty indicator" ;
label variable HX060 "Household type" ;
label variable HX070 "Tenure state" ;
label variable HX010 "Change rate" ;
label variable HX120 "Overcrowded household" ;
label variable HY081G "Alimonies received (gross)" ;
label variable HY081G_F "Flag" ;
label variable HY081G_I "Imputation Factor" ;
label variable HY081N "Alimonies received (net)" ;
label variable HY081N_F "Flag" ;
label variable HY081N_I "Imputation Factor" ;
label variable HY131G "Alimonies paid (gross)" ;
label variable HY131G_F "Flag" ;
label variable HY131G_I "Imputation Factor" ;
label variable HY131N "Alimonies paid (net)" ;
label variable HY131N_F "Flag" ;
label variable HY131N_I "Imputation Factor" ;

*Imputations factor not available for RO*

* Definition of category labels ;

label define HB050_VALUE_LABELS       
1 "January,February,March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define HB050_F_VALUE_LABELS      
1 "filled"
-1 "missing"
;
label define HB060_F_VALUE_LABELS      
1 "filled"
;
label define HB070_F_VALUE_LABELS      
1 "filled"
-1 "missing"
;
label define HB080_F_VALUE_LABELS      
1 "filled"
-1 "missing"
;
label define HB090_F_VALUE_LABELS     
1 "filled"               
-1 "missing"
-2 "not applicable (no 2nd responsible)"
;
label define HB100_F_VALUE_LABELS      
1 "filled"
-1 "missing"
;
label define HY010_F_VALUE_LABELS      
0 "no income"
1 "data collection:net" 
2 "data collection:gross" 
3 "data collection:net and gross"
4 "data collection:unknown"
-1 "missing"
-5 "not filled: no conversion to gross is done"
; 
label define HY020_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"   
-1 "missing" 
;
label define HY022_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"
-1 "missing"
;
label define HY023_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"
-1 "missing"
;
label define HY025_F_VALUE_LABELS      
1 "filled"
-1 "missing"
;
label define HY030N_F_VALUE_LABELS      
0 "no income"
1 "income(variable is filled)"
-1 "Missing"
-5 "not filled: variable of gross series is filled"
;
label define HY040N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
43 "collected grossrecorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY050N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
43 "collected grossrecorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY060N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
43 "collected grossrecorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY070N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY080N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY081N_F_VALUE_LABELS        
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY090N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross recorded net of tax on income & social contrib."
42 "collected gross recorded net of tax on income at source"
43 "collected gross recorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
1 "net of tax on income at source and social contribution"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY100N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "not filled:variable of the gross series is filled"
;
label define HY110N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
12 "collec. net of tax on income at source & social contrib. recorded net of tax on income at source"
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib. recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross recorded net of tax on income & social contrib."
42 "collected gross recorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY120N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-4 "Amount included in another income component"
-5 "Not filled: variable of the gross series is filled"
;
label define HY130N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY131N_F_VALUE_LABELS        
0 "none"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
55 "unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY140N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "Not filled: variable of the gross series is filled"
;
label define HY145N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "Not filled: variable of gross series is filled"
;
label define HY030G_F_VALUE_LABELS      
0 "no income"
1 "income (variable is filled)"
-1 "missing"
-5 "not filled:variable of net (...g)gross (...n) series is filled"
;
label define HY040G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY050G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY060G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY070G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY080G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY081G_F_VALUE_LABELS        
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY090G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY100G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "not filled: variable of netgross series is filled"
;
label define HY110G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY120G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-4 "amount included in another income component"
-5 "not filled: variable of the net series is filled"
;
label define HY130G_F_VALUE_LABELS      
0 "no income"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY131G_F_VALUE_LABELS        
0 "none"
1 "collected:net of tax on income at source and social contributions"
2 "collected:net of tax on income at source"
3 "collected:net of tax on social contributions"
4 "collected:gross"
5 "collected:unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"     
;
label define HY140G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "not filled: variable of the netgross series is filled"
;
label define HS010_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS010_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS010 because HS011 is used"
;
label define HS011_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS011_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS011 because HS010 is still used"
;
label define HS020_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS020_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS020 because HS021 is still used"
;
label define HS021_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS021_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS021 because HS020 is used"
;
label define HS030_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS030_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS030 because HS031 is used"
;
label define HS031_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS031_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS031 because HS030 is used"
;
label define HS040_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS040_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS050_VALUE_LABELS         
1 "yes" 
2 "no"
;
label define HS050_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS060_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS060_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS070_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS070_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS080_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS080_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS090_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS090_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
;
label define HS100_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS100_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
;
label define HS110_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS110_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
;
label define HS120_VALUE_LABELS         
1 "with great difficulty"
2 "with difficulty"
3 "with some difficulty"
4 "fairly easily"
5 "easily"
6 "very easily"
;
label define HS120_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
;
label define HS130_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS140_VALUE_LABELS         
1 "A heavy burden"
2 "somewhat a burden"
3 "not a burden at all"
;
label define HS140_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
;
label define HS150_VALUE_LABELS         
1 "repayment is a heavy burden"
2 "repayment is somewhat a burden"
3 "repayment is not a burden at all"
;
label define HS150_F_VALUE_LABELS      
1 "filled" 
-1 "missing"
-2 "not applicable (no repayment of debts)"
;
label define HS160_VALUE_LABELS        
1 "yes"
2 "no"
;
label define HS160_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS170_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS170_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS180_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS180_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS190_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS190_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH010_VALUE_LABELS         
1 "detached house"
2 "semi-detached house"
3 "apartment or flat in a building with < 10 dwellings"
4 "apartment or flat in a building with >=10 dwellings"
;
label define HH010_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH020_VALUE_LABELS         
1 "owner"
2 "tenant or subtenant paying rent at prevailing or market rate"
3 "accommodation is rented at a reduced rate(lower price than market price)"
4 "accommodation is provided free"
;
label define HH020_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH030_VALUE_LABELS         
6 "six or more rooms"
;
label define HH030_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH031_F_VALUE_LABELS      
1 "filled"
-1 "missing"
-2 "n.a."
;
label define HH040_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH040_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH050_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH050_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH060_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-2 "n.a. (HH020 ne 2 or 3)"
;
label define HH061_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-2 "na"
;
label define HH070_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH080_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH080_F_VALUE_LABELS       
1 "filled"
-1 "missing"
-5 "missing value of HH080 because HH081 is used"
;
label define HH081_VALUE_LABELS
1 "yes, for sole use of the household"
2 "yes, shared"
3 "no"
;
label define HH081_F_VALUE_LABELS
1 "filled"
-1 "missing"
-5 "missing value of HH081 because HH080 is still used"
;
label define HH090_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH090_F_VALUE_LABELS       
1 "filled "
-1 "missing"
-5 "missing value of HH090 because HH091 is used"
;
label define HH091_VALUE_LABELS
1 "yes, for sole use of the household"
2 "yes, shared"
3 "no"
;
label define HH091_F_VALUE_LABELS
1 "filled"
-1 "missing"
-5 "missing value of HH091 because HH090 is still used"
;
label define MI010_VALUE_LABELS          
1 "yes"
2 "no"
;
label define MI010_F_VALUE_LABELS       
-1 "missing"
1 "filled"
;
label define MI020_VALUE_LABELS          
1 "yes"
2 "no"
;
label define MI020_F_VALUE_LABELS       
-2 "not applicable (no bank account)"
-1 "missing"
1 "filled"
;
label define MI025_VALUE_LABELS            
1 "amount owed: < 10% of the monthly hhld disposable income"
2 "amount owed: > 10% and < 33% of the monthly hhld disposable income"
3 "amount owed: > 33% and < 100% of the monthly hhld disposable income"
4 "amount owed: > 100% of the monthly hhld disposable income"
;
label define MI025_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no overdraft: MI020 = 2)"
;
label define MI026_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no overdraft: MI020 = 2)"
;
label define MI030_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI030_F_VALUE_LABELS          
1 "filled"
-1 "missing"
;
label define MI040_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI040_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no creditstore card: MI030=2)"
;
label define MI045_VALUE_LABELS            
1 "the amount owed represents < 10% of the monthly hhld disposable income"
2 "the amount owed represents > 10% and < 33% of the monthly hhld disposable income"
3 "the amount owed represents > 33% and < 100% of the monthly hhld disposable income"
4 "the amount owed represents > 100% of the monthly hhld disposable income"
;
label define MI045_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no unbalanced creditstore card: MI040=2 or MI030=2)"
;
label define MI046_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no unbalanced creditstore card: MI040=2 or MI030=2)"
;
label define MI050_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI050_F_VALUE_LABELS          
1 "filled"
-1 "missing"
;
label define MI051_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI051_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI052_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI052_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI053_VALUE_LABELS           
1 "yes"
2 "no"
;
label define MI053_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI054_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI054_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI055_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI055_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI056_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI056_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI057_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI057_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI058_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI058_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no credit or loan except mortgage for main dwelling: MI050=2)"
;
label define MI060_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI060_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (no other non-housing household bills)"
;
label define MI065_VALUE_LABELS            
1 "the amount owed represents < 10% of the monthly hhld disposable income"
2 "the amount owed represents > 10% and < 33% of the monthly hhld disposable income"
3 "the amount owed represents > 33% and < 100% of the monthly hhld disposable income"
4 "the amount owed represents > 100% of the monthly hhld disposable income"
;
label define MI065_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define MI066_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define MI075_VALUE_LABELS            
1 "the amount owed represents < 10% of the monthly hhld disposable income"
2 "the amount owed represents > 10% and < 33% of the monthly hhld disposable income"
3 "the amount owed represents > 33% and < 100% of the monthly hhld disposable income"
4 "the amount owed represents > 100% of the monthly hhld disposable income"
;
label define MI075_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define MI076_VALUE_LABELS            
0 "999999.99   amount"
;
label define MI076_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define MI085_VALUE_LABELS            
1 "the amount owed represents < 10% of the monthly hhld disposable income"
2 "the amount owed represents > 10% and < 33% of the monthly hhld disposable income"
3 "the amount owed represents > 33% and < 100% of the monthly hhld disposable income"
4 "the amount owed represents > 100% of the monthly hhld disposable income"
;
label define MI085_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define  MI086_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable"
;
label define MI090_VALUE_LABELS            
1 "yes"
2 "no"
;
label define MI090_F_VALUE_LABELS          
1 "filled"
-1 "missing"
;
label define MI095_VALUE_LABELS            
1 "Job loss/redundancy"
2 "Change in hours worked andor in wages"
3 "Inability to work through sickness or disability"
4 "Maternity - parental leave - child care"
5 "Retirement"
6 "Marriagerelationship breakdown"
7 "Other change in household composition"
8 "Other reason"
;
label define MI095_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "no applicable (no drop in income: MI090=2)"
;
label define MI100_VALUE_LABELS            
1 "To improve"
2 "To stay about the same"
3 "To get worse"
4 "Do not know"
;
label define MI100_F_VALUE_LABELS          
1 "filled"
-1 "missing"
;
label define  MI110_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define  MI110_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has bank current account: MI010=1)"
;
label define  MI111_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define  MI111_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has bank current account (MI010=1) or does not need one (MI110=1))"
;
label define MI112_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI112_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has bank current account (MI010=1) or does not need one (MI110=1))"
;
label define MI113_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define  MI113_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has bank current account (MI010=1) or does not need one (MI110=1))"
;
label define MI114_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI114_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has bank current account (MI010=1) or does not need one (MI110=1))"
;
label define MI120_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI120_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit)"
;
label define MI121_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI121_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit)"
;
label define MI122_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI122_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit or does not need it (MI120=1))"
;
label define MI123_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI123_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit or does not need it (MI120=1))"
;
label define MI124_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI124_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit or does not need it (MI120=1))"
;
label define MI125_VALUE_LABELS            
1 "Yes"
2 "No"
;
label define MI125_F_VALUE_LABELS          
1 "filled"
-1 "missing"
-2 "not applicable (household has commercial credit or does not need it (MI120=1)"          
;
label define HX060_VALUE_LABELS          
5 "One person household"
6 "2 adults, no dependent children, both adults under 65 years"
7 "2 adults, no dependent children, at least one adult >=65 years"
8 "Other households without dependent children"
9 "Single parent household, one or more dependent children"
10 "2 adults, one dependent child"
11 "2 adults, two dependent children"
12 "2 adults, three or more dependent children"
13 "Other households with dependent children"
16 "Other (these household are excluded from Laeken indicators calculation)"
;
label define HX070_VALUE_LABELS          	
1 "when HH020= 1 or 4"
2 "when HH020= 2 or 3"
;
label define HX080_VALUE_LABELS          
0 "when HX090>= at risk of poverty threshold (60% of Median HX090)"
1 "when HX090 < at risk of poverty threshold (60% of Median HX090)"
;

* Attachement of category labels to variable ;

label values HB050 HB050_VALUE_LABELS ;
label values HB050_F HB050_F_VALUE_LABELS ;
label values HB060_F HB060_F_VALUE_LABELS ;
label values HB070_F HB070_F_VALUE_LABELS ;
label values HB080_F HB080_F_VALUE_LABELS ;
label values HB090_F HB090_F_VALUE_LABELS ;
label values HB100_F HB100_F_VALUE_LABELS ;
label values HY010_F HY010_F_VALUE_LABELS ;
label values HY020_F HY020_F_VALUE_LABELS ;
label values HY022_F HY022_F_VALUE_LABELS ;
label values HY023_F HY023_F_VALUE_LABELS ;
label values HY025_F HY025_F_VALUE_LABELS ;
label values HY030N_F HY030N_F_VALUE_LABELS ;
label values HY040N_F HY040N_F_VALUE_LABELS ;
label values HY050N_F HY050N_F_VALUE_LABELS ;
label values HY060N_F HY060N_F_VALUE_LABELS ;
label values HY070N_F HY070N_F_VALUE_LABELS ;
label values HY080N_F HY080N_F_VALUE_LABELS ;
label values HY081N_F HY081N_F_VALUE_LABELS ;
label values HY090N_F HY090N_F_VALUE_LABELS ;
label values HY100N_F HY100N_F_VALUE_LABELS ;
label values HY110N_F HY110N_F_VALUE_LABELS ;
label values HY120N_F HY120N_F_VALUE_LABELS ;
label values HY130N_F HY130N_F_VALUE_LABELS ;
label values HY131N_F HY131N_F_VALUE_LABELS ;
label values HY140N_F HY140N_F_VALUE_LABELS ;
label values HY145N_F HY145N_F_VALUE_LABELS ;
label values HY030G_F HY030G_F_VALUE_LABELS ;
label values HY040G_F HY040G_F_VALUE_LABELS ;
label values HY050G_F HY050G_F_VALUE_LABELS ;
label values HY060G_F HY060G_F_VALUE_LABELS ;
label values HY070G_F HY070G_F_VALUE_LABELS ;
label values HY080G_F HY080G_F_VALUE_LABELS ;
label values HY081G_F HY081G_F_VALUE_LABELS ; 
label values HY090G_F HY090G_F_VALUE_LABELS ;
label values HY100G_F HY100G_F_VALUE_LABELS ;
label values HY110G_F HY110G_F_VALUE_LABELS ;
label values HY120G_F HY120G_F_VALUE_LABELS ;
label values HY130G_F HY130G_F_VALUE_LABELS ;
label values HY131G_F HY131G_F_VALUE_LABELS ;
label values HY140G_F HY140G_F_VALUE_LABELS ;
label values HS010 HS010_VALUE_LABELS ;
label values HS010_F HS010_F_VALUE_LABELS ;
label values HS011 HS011_VALUE_LABELS ;
label values HS011_F HS011_F_VALUE_LABELS ;
label values HS020 HS020_VALUE_LABELS ;
label values HS020_F HS020_F_VALUE_LABELS ;
label values HS021 HS021_VALUE_LABELS ;
label values HS021_F HS021_F_VALUE_LABELS ;
label values HS030 HS030_VALUE_LABELS ;
label values HS030_F HS030_F_VALUE_LABELS ;
label values HS031 HS031_VALUE_LABELS ;
label values HS031_F HS031_F_VALUE_LABELS ;
label values HS040 HS040_VALUE_LABELS ;
label values HS040_F HS040_F_VALUE_LABELS ;
label values HS050 HS050_VALUE_LABELS ;
label values HS050_F HS050_F_VALUE_LABELS ;
label values HS060 HS060_VALUE_LABELS ;
label values HS060_F HS060_F_VALUE_LABELS ;
label values HS070 HS070_VALUE_LABELS ;
label values HS070_F HS070_F_VALUE_LABELS ;
label values HS080 HS080_VALUE_LABELS ;
label values HS080_F HS080_F_VALUE_LABELS ;
label values HS090 HS090_VALUE_LABELS ;
label values HS090_F HS090_F_VALUE_LABELS ;
label values HS100 HS100_VALUE_LABELS ;
label values HS100_F HS100_F_VALUE_LABELS ;
label values HS110 HS110_VALUE_LABELS ;
label values HS110_F HS110_F_VALUE_LABELS ;
label values HS120 HS120_VALUE_LABELS ;
label values HS120_F HS120_F_VALUE_LABELS ;
label values HS130_F HS130_F_VALUE_LABELS ;
label values HS140 HS140_VALUE_LABELS ;
label values HS140_F HS140_F_VALUE_LABELS ;
label values HS150 HS150_VALUE_LABELS ;
label values HS150_F HS150_F_VALUE_LABELS ;
label values HS160 HS160_VALUE_LABELS ;
label values HS160_F HS160_F_VALUE_LABELS ;
label values HS170 HS170_VALUE_LABELS ;
label values HS170_F HS170_F_VALUE_LABELS ;
label values HS180 HS180_VALUE_LABELS ;
label values HS180_F HS180_F_VALUE_LABELS ;
label values HS190 HS190_VALUE_LABELS ;
label values HS190_F HS190_F_VALUE_LABELS ;
label values HH010 HH010_VALUE_LABELS ;
label values HH010_F HH010_F_VALUE_LABELS ;
label values HH020 HH020_VALUE_LABELS ;
label values HH020_F HH020_F_VALUE_LABELS ;
label values HH030 HH030_VALUE_LABELS ;
label values HH030_F HH030_F_VALUE_LABELS ;
label values HH031_F HH031_F_VALUE_LABELS ;
label values HH040  HH040_VALUE_LABELS ;
label values HH040_F HH040_F_VALUE_LABELS ;
label values HH050 HH050_VALUE_LABELS ;
label values HH050_F HH050_F_VALUE_LABELS ;
label values HH060_F HH060_F_VALUE_LABELS ;
label values HH061_F HH061_F_VALUE_LABELS ;
label values HH070_F HH070_F_VALUE_LABELS ;
label values HH080 HH080_VALUE_LABELS ;
label values HH080_F HH080_F_VALUE_LABELS ;
label values HH081 HH081_VALUE_LABELS ;
label values HH081_F HH081_F_VALUE_LABELS ;
label values HH090 HH090_VALUE_LABELS ;
label values HH090_F HH090_F_VALUE_LABELS ;
label values HH091 HH091_VALUE_LABELS ;
label values HH091_F HH091_F_VALUE_LABELS ;
label values MI010 MI010_VALUE_LABELS ;
label values MI010_F MI010_F_VALUE_LABELS ;
label values MI020 MI020_VALUE_LABELS ;
label values MI020_F MI020_F_VALUE_LABELS ;
label values MI025 MI025_VALUE_LABELS ;
label values MI025_F MI025_F_VALUE_LABELS ;
label values MI026_F MI026_F_VALUE_LABELS ;
label values MI030 MI030_VALUE_LABELS ;
label values MI030_F MI030_F_VALUE_LABELS ;
label values MI040 MI040_VALUE_LABELS ;
label values MI040_F MI040_F_VALUE_LABELS ;
label values MI045 MI045_VALUE_LABELS ;
label values MI045_F MI045_F_VALUE_LABELS ;
label values MI046_F MI046_F_VALUE_LABELS ;
label values MI050 MI050_VALUE_LABELS ;
label values MI050_F MI050_F_VALUE_LABELS ;
label values MI051 MI051_VALUE_LABELS ;
label values MI051_F MI051_F_VALUE_LABELS ;
label values MI052 MI052_VALUE_LABELS ;
label values MI052_F MI052_F_VALUE_LABELS ;
label values MI053 MI053_VALUE_LABELS ;
label values MI053_F MI053_F_VALUE_LABELS ;
label values MI054 MI054_VALUE_LABELS ;
label values MI054_F MI054_F_VALUE_LABELS ;
label values MI055 MI055_VALUE_LABELS ;
label values MI055_F MI055_F_VALUE_LABELS ;
label values MI056 MI056_VALUE_LABELS ;
label values MI056_F MI056_F_VALUE_LABELS ;
label values MI057 MI057_VALUE_LABELS ;
label values MI057_F MI057_F_VALUE_LABELS ;
label values MI058 MI058_VALUE_LABELS ;
label values MI058_F MI058_F_VALUE_LABELS ;
label values MI060 MI060_VALUE_LABELS ;
label values MI060_F MI060_F_VALUE_LABELS ;
label values MI065 MI065_VALUE_LABELS ;
label values MI065_F MI065_F_VALUE_LABELS ;
label values MI066_F MI066_F_VALUE_LABELS ;
label values MI075 MI075_VALUE_LABELS ;
label values MI075_F MI075_F_VALUE_LABELS ;
label values MI076 MI076_VALUE_LABELS ;
label values MI076_F MI076_F_VALUE_LABELS ;
label values MI085 MI085_VALUE_LABELS ;
label values MI085_F MI085_F_VALUE_LABELS ;
label values MI086_F MI086_F_VALUE_LABELS ;
label values MI090 MI090_VALUE_LABELS ;
label values MI090_F MI090_F_VALUE_LABELS ;
label values MI095 MI095_VALUE_LABELS ;
label values MI095_F MI095_F_VALUE_LABELS ;
label values MI100 MI100_VALUE_LABELS ;
label values MI100_F MI100_F_VALUE_LABELS ;
label values MI110 MI110_VALUE_LABELS ;
label values MI110_F MI110_F_VALUE_LABELS ;
label values MI111 MI111_VALUE_LABELS ;
label values MI111_F MI111_F_VALUE_LABELS ;
label values MI112 MI112_VALUE_LABELS ;
label values MI112_F MI112_F_VALUE_LABELS ;
label values MI113 MI113_VALUE_LABELS ;
label values MI113_F MI113_F_VALUE_LABELS ;
label values MI114 MI114_VALUE_LABELS ;
label values MI114_F MI114_F_VALUE_LABELS ;
label values MI120 MI120_VALUE_LABELS ;
label values MI120_F MI120_F_VALUE_LABELS ;
label values MI121 MI121_VALUE_LABELS ;
label values MI121_F MI121_F_VALUE_LABELS ;
label values MI122 MI122_VALUE_LABELS ;
label values MI122_F MI122_F_VALUE_LABELS ;
label values MI123 MI123_VALUE_LABELS ;
label values MI123_F MI123_F_VALUE_LABELS ;
label values MI124 MI124_VALUE_LABELS ;
label values MI124_F MI124_F_VALUE_LABELS ;
label values MI125 MI125_VALUE_LABELS ;
label values MI125_F MI125_F_VALUE_LABELS ;
label values HX060 HX060_VALUE_LABELS ;
label values HX070 HX070_VALUE_LABELS ;
label values HX080 HX080_VALUE_LABELS ;

label data "Household data file 2008" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



