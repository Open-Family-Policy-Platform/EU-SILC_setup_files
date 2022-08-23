* 2008_cross_eu_silc_p_ver_2021_04.do 
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
* Personal data file:
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
* Pforr, Klaus and Johanna Jung (2021): 2008_cross_eu_silc_p_ver_2021_04.do, 2nd update.
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

local log_file "$log/eusilc_2008_p" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2019) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2008_p_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK UK { ;
      cd "$csv_path/`CC'/2008" ;	
	  import delimited using "UDB_c`CC'08P.csv", case(upper) clear;
	  tostring PB220A, replace ;
append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort PB020 ;

log using "`log_file'", replace text ;



label define PB210_neu 
1 "LOC"
2 "EU"
3 "OTH"
;

encode PB210, gen(PB210_neu) ;

rename PB210_neu PB210_num ;

label define PB210_num_VALUE_LABELS 
1 "same country as country of residence"
2 "any european country except country of residence"
3 "any other country" ;

label define PB220A_neu 
1 "LOC"
2 "EU"
3 "OTH"
;

replace PB220A = "" if PB220A=="." ;

encode PB220A, gen(PB220A_neu) ;
recode PB220A_neu (4=.) ;

rename PB220A_neu PB220A_num ;

label define PB220A_num_VALUE_LABELS 
1 "same country as country of residence"
2 "any european country except country of residence"
3 "any other country" ;


label define PL110_neu
1 "a+b"
2 "c+d+e"
3 "f"
4 "g"
5 "h"
6 "i"
7 "j"
8 "k"
9 "l"
10 "m"
11 "n"
12 "o+p+q"
13 "undef"
;

encode PL110, gen(PL110_neu) ;

rename PL110_neu PL110_num ;


label define PL110_num_VALUE_LABELS             
1 "Agriculture, huntingforestry & fishing"
2 "Mining and quarryingmanufacturingelectricity, gas & water supply"
3 "Construction"
4 "Wholesale & retail traderepair of motor vehicles, motorcycles & personal & household goods"
5 "Hotels and restaurants"
6 "Transport, storage and communication"
7 "Financial intermediation"
8 "Real estate, renting and business activities"
9 "Public administration and defense, compulsory social security"
10 "Education"
11 "Health & social network"
12 "other community, soc. & per. service activities, pr. households with employed ps., extra-ter. organiz. & bodys"
13 "undefined"
;

label define PL111_neu
1 "a"
2 "b - e"
3 "f"
4 "g"
5 "h"
6 "i"
7 "j"
8 "k"
9 "l - n"
10 "o"
11 "p"
12 "q"
13 "r - u"
;

encode PL111, gen(PL111_neu) ;

rename PL111_neu PL111_num ;

label define PL111_num_VALUE_LABELS             
1 "Agriculture, forestry & fishing"
2 "Mining and quarrying, manufacturing, electricity, gas & water supply"
3 "Construction"
4 "Wholesale & retail"
5 "Transport, storage "
6 "Accomodation & food service activities"
7 "informtion & communication"
8 "Financial & insurance activities"
9 "Real estate, Professionnal, scientific & technical, administrative & support sercice acticities"
10 "Public administration and defense, compulsory social security "
11 "Education"
12 "Human health & social work activities"	
13 "arts, entertainment &recreation, other service activities, activities as household as employer"
;

* Drop wrongfully included variables ;
drop PS005 PS005_F ;

* Definition of variable labels ;
label variable PB010 "Year of the Survey" ;
label variable PB020 "Country alphanumeric" ;
label variable PB030 "Personal ID" ;
label variable PB040 "Personal cross-sectional weight" ;
label variable PB040_F "Flag" ;
label variable PB060 "Personal cross-sectional weight for selected respondent" ;
label variable PB060_F "Flag" ;
label variable PB100 "Quarter of the personal interview" ;
label variable PB100_F "Flag" ;
label variable PB110 "Year of the personal interview" ;
label variable PB110_F "Flag" ;
label variable PB120 "Minutes to complete the personal interview" ;
label variable PB120_F "Flag" ;
label variable PB130 "Quarter of birth" ;
label variable PB130_F "Flag" ;
label variable PB140 "Year of birth" ;
label variable PB140_F "Flag" ;
label variable PB150 "Sex" ;
label variable PB150_F "Flag" ;
label variable PB160 "Father ID" ; // some negative values for EE; use RB220
label variable PB160_F "Flag" ;
label variable PB170 "Mother ID" ; // some negative values for EE; use RB230
label variable PB170_F "Flag" ;
label variable PB180 "Spousepartner ID" ;
label variable PB180_F "Flag" ;
label variable PB190 "Marital status" ;
label variable PB190_F "Flag" ;
label variable PB200 "Consensual union" ;
label variable PB200_F "Flag" ;
label variable PB210 "Country of birth alphanumeric" ;
label variable PB210_num "Country of birth numeric" ;
label variable PB210_F "Flag" ;
label variable PB220A "Citizenship 1 alphanumeric" ;
label variable PB220A_num "Citizenship 1 numeric" ;
label variable PB220A_F "Flag" ;
label variable PE010 "Current education activity" ;
label variable PE010_F "Flag" ;
label variable PE020 "ISCED level currently attended" ;
label variable PE020_F "Flag" ;
label variable PE030 "Year when highest level of education was attained" ; //No bottom code for PT
label variable PE030_F "Flag" ; 
label variable PE040 "Highest ISCED level attained" ;
label variable PE040_F "Flag" ;
label variable PL030 "Self-defined current economic status" ;
label variable PL030_F "Flag" ;
label variable PL035 "Worked at least one hour during the previous week" ;
label variable PL035_F "Flag" ;
label variable PL015 "Person has ever worked" ;
label variable PL015_F "Flag" ;
label variable PL020 "Actively looking for a job" ;
label variable PL020_F "Flag" ;
label variable PL025 "Available for work" ;
label variable PL025_F "Flag" ;
label variable PL040 "Status in employment" ;
label variable PL040_F "Flag" ;
label variable PL050 "Occupation (ISCO-88 (Com))" ;
label variable PL050_F "Flag" ;
label variable PL060 "Number of hours usually worked per week in main job" ;
label variable PL060_F "Flag" ;
label variable PL070 "Number of months spent at full-time work" ;
label variable PL070_F "Flag" ;
label variable PL072 "Number of months spent at part-time work" ;
label variable PL072_F "Flag" ;
label variable PL080 "Number of months spent in unemployment" ;
label variable PL080_F "Flag" ;
label variable PL085 "Number of months spent in retirement" ;
label variable PL085_F "Flag" ;
label variable PL087 "Number of months spent studying" ;
label variable PL087_F "Flag" ;
label variable PL090 "Number of months spent inactively" ;
label variable PL090_F "Flag" ;
label variable PL100 "Total number of hours usually worked in second, third...jobs" ;
label variable PL100_F "Flag" ;  
label variable PL110_F "Flag" ; 
label variable PL111_F "Flag" ;
label variable PL120 "Reason for working less than 30 hours" ;
label variable PL120_F "Flag" ; 
label variable PL130 "Number of persons working at the local unit" ; 
label variable PL130_F "Flag" ;
label variable PL140 "Type of contract" ;
label variable PL140_F "Flag" ;
label variable PL150 "Managerial Position" ;
label variable PL150_F "Flag" ;
label variable PL160 "Change of job since last year" ;
label variable PL160_F "Flag" ;
label variable PL170 "Reason for change" ;
label variable PL170_F "Flag" ;
label variable PL180 "Most recent change in the individuals activity status" ;
label variable PL180_F "Flag" ;
label variable PL190 "When began regular first job" ;
label variable PL190_F "Flag" ;
label variable PL200 "Number of years spent in paid work" ;
label variable PL200_F "Flag" ;
label variable PL210A "Main activity on January" ;
label variable PL210A_F "Flag" ;
label variable PL210B "Main activity on February" ;
label variable PL210B_F "Flag" ;
label variable PL210C "Main activity on March" ;
label variable PL210C_F "Flag" ;
label variable PL210D "Main activity on april" ;
label variable PL210D_F "Flag" ;
label variable PL210E "Main activity on May" ;
label variable PL210E_F "Flag" ;
label variable PL210F "Main activity on June" ;
label variable PL210F_F "Flag" ;
label variable PL210G "Main activity on July" ;
label variable PL210G_F "Flag" ;
label variable PL210H "Main activity on August" ;
label variable PL210H_F "Flag" ;
label variable PL210I "Main activity on September" ;
label variable PL210I_F "Flag" ;
label variable PL210J "Main activity on October" ;
label variable PL210J_F "Flag" ;
label variable PL210K "Main activity on November" ;
label variable PL210K_F "Flag" ;
label variable PL210L "Main activity on December" ;
label variable PL210L_F "Flag" ;
label variable PH010 "General health" ;
label variable PH010_F "Flag" ;
label variable PH020 "Suffer from a chronic(long-standing) illness or condition" ;
label variable PH020_F "Flag" ;
label variable PH030 " Limitation in activities because of health problems" ;
label variable PH030_F "Flag" ;
label variable PH040 "Unmet need for medical examination or treatment" ;
label variable PH040_F "Flag" ;
label variable PH050 "Main reason for unmet need for medical examination or treatment" ;
label variable PH050_F "Flag" ;
label variable PH060 "Unmet need for dental examination or treatment" ;
label variable PH060_F "Flag" ;
label variable PH070 "Main reason for unmet need for dental examination or treatment" ;
label variable PH070_F "Flag" ;
label variable PY010N "Employee cash or near cash income(net)" ;
label variable PY010N_F "Flag" ;
label variable PY010N_I "Imputation factor" ;
label variable PY020N "Non-Cash employee income(net)" ;
label variable PY020N_F "Flag" ;
label variable PY020N_I "Imputation Factor" ;
label variable PY021N   "Company car (in euros)" ;
label variable PY021N_F "Flag" ;
label variable PY035N "Contributions to individual private pension plans(net)" ;
label variable PY035N_F "Flag" ;
label variable PY035N_I "Imputation Factor" ;
label variable PY050N " Cash benefits or losses from self-employment(net)" ;
label variable PY050N_F "Flag" ;
label variable PY050N_I "Imputation Factor" ;
label variable PY070N "Value of goods produced by own-consumption (net)" ;
label variable PY070N_F "Flag" ;    
label variable PY070N_I "Imputation factor" ;
label variable PY080N "Pension from individual private plans(net)" ;
label variable PY080N_F "Flag" ;
label variable PY080N_I "Imputation factor" ;
label variable PY090N "Unemployment benefits(net)" ;
label variable PY090N_F "Flag" ;
label variable PY090N_I "Imputation Factor" ;
label variable PY100N "Old-age benefits(net)" ;
label variable PY100N_F "Flag" ;  
label variable PY100N_I "Imputation Factor" ;   
label variable PY110N "Survivors Benefits (net)" ;
label variable PY110N_F "Flag" ;
label variable PY110N_I "Imputation Factor" ;
label variable PY120N "Sickness Benefits(net)" ;
label variable PY120N_F "Flag" ;
label variable PY120N_I "Imputation Factor" ;
label variable PY130N "Disability Benefits(net)" ;
label variable PY130N_F "Flag" ;
label variable PY130N_I "Imputation Factor" ;
label variable PY140N "Education-related allowances" ;
label variable PY140N_F "FlAG" ;
label variable PY140N_I "Imputation factor" ;
label variable PY010G "Employee Cash or near cash income(gross)" ;
label variable PY010G_F "Flag" ;
label variable PY010G_I "Imputation Factor" ;
label variable PY020G "Non-Cash employee income(gross)" ;  
label variable PY020G_F "Flag" ;
label variable PY020G_I "Imputation Factor" ; 
label variable PY021G "Company car (in euros)" ;
label variable PY021G_F "Flag" ;
label variable PY030G  "Employers social insurance contribution (in euros)" ;
label variable PY030G_F "Flag" ;
label variable PY035G "Contributions to individual private pension plans(gross)" ;
label variable PY035G_F "Flag" ;
label variable PY035G_I "Imputation Factor" ;
label variable PY050G "Cash benefits or losses from self-employment (gross)" ;
label variable PY050G_F "Flag" ;
label variable PY050G_I "Imputation Factor" ;
label variable PY070G  "Value of goods produced by own-consumption(gross)" ;
label variable PY070G_F "Flag" ;
label variable PY070G_I "Imputation Factor" ;
label variable PY080G  "Pension from individual private plans(gross)" ;
label variable PY080G_F "Flag" ;
label variable PY080G_I "Imputation Factor" ;
label variable PY090G  "Unemployment benefits (gross)" ;
label variable PY090G_F "Flag" ;
label variable PY090G_I "Imputation Factor" ;
label variable PY100G "Old-age benefits(gross)" ;
label variable PY100G_F "Flag" ;
label variable PY100G_I "Imputation Factor" ;
label variable PY110G "Survivor benefit" ;
label variable PY110G_F "Flag" ;
label variable PY110G_I "Imputation Factor" ;
label variable PY120G "Sickness Benefits(gross)" ;
label variable PY120G_F "Flag" ;
label variable PY120G_I "Imputation Factor" ;
label variable PY130G "Disability benefits(gross)" ;
label variable PY130G_F "Flag" ;                                
label variable PY130G_I "Imputation Factor" ;
label variable PY140G "Education-related allowances(gross)" ;
label variable PY140G_F "Flag" ;
label variable PY140G_I "Imputation factor" ;
label variable PY200G "Gross mopnthly earnings for employees(gross)" ;
label variable PY200G_F "Flag" ;
label variable PY200G_I "Imputation Factor" ;
label variable PX030 "Household ID" ;
label variable PX040 "Respondent status" ;
label variable PY021N_I "Imputation Factor" ;
label variable PY021G_I "Imputation Factor" ;
label variable PY030G_I "Imputation Factor" ;
label variable PX020 "Age at the end of the income reference period" ;
label variable PX050 "Activity status" ;
label variable PX010 "Exchange rate" ;
label variable PY031G "Optional employer social insurance contributions (in euros)" ;
label variable PY031G_F "Flag" ;
label variable PY031G_I "Imputation Factor" ;
label variable PL110 "NACE (Rev.1.1) (Missing: AT, BG, BG)" ;
label variable PL111 "NACE (Rev 2) (Missing: AT, BG, BG)" ;
label variable PL111_num "NACE (Rev 2)numeric (Missing: AT, BG, BG)" ;
label variable PL110_num "NACE (Rev.1.1) numeric (Missing: AT, BG, BG)" ;

*Imputations factor not available for RO*


* Definition of category labels ;
label define PB040_F_VALUE_LABELS             
1 "Filled"
;
label define PB060_F_VALUE_LABELS             
1 "Filled"
-2 "not defined in var. descript, unique to Luxembourg"
-3 "not selected respondent"
;
label define PB100_VALUE_LABELS               
1 "January,February,March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB100_F_VALUE_LABELS             
1 "filled"
-1 "missing"
;
label define PB110_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PB120_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (information only extracted from registers)"
;
label define PB130_VALUE_LABELS                
1 "January,February,March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB130_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PB140_VALUE_LABELS             
1927 "1927 or before"
1928 "PT: 1928 and before"
1932 "MT: 1928-1932"
1937 "MT: 1933-1937"
1942 "MT: 1938-1942"
1947 "MT: 1943-1947"
1952 "MT: 1948-1952"
1957 "MT: 1953-1957"
1962 "MT: 1958-1962"
1967 "MT: 1963-1967"
1972 "MT: 1968-1972"
1977 "MT: 1973-1977"
1982 "MT: 1978-1982"
1987 "MT: 1983-1987"
1992 "MT: 1988-1992"
;
label define PB140_F_VALUE_LABELS             
1 "filled"
-1 "missing"
;
label define PB150_VALUE_LABELS                
1 "male"
2 "female"
;
label define PB150_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PB160_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (father is not a household member)"
;
label define PB170_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-2 "na (mother is not a household member)"
;
label define PB180_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "not applicable (person has no spousepartner or spousepartner is not a household member)"
;
label define PB190_VALUE_LABELS                
1 " never married"
2 "married" 
3 "separated"
4 "widowed"
5 "divorced"
;
label define PB190_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PB200_VALUE_LABELS                
1 "yes, on a legal basis"
2 "yes, without a legal basis"
3 "no"
;
label define PB200_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PB210_F_VALUE_LABELS             
1 "filled"
-1 "missing"
;
label define PB220A_F_VALUE_LABELS            
1 "filled"
-1 "missing"
;
label define PE010_VALUE_LABELS               
1 "in education"
2 "not in education"
;
label define PE010_F_VALUE_LABELS            
1 "filled"
-1 "missing"
;
label define PE020_VALUE_LABELS               
0 "pre-primary education"
1 "primary education"
2 "lower secondary education"
3 "(upper) secondary education"
4 "post-secondary non-tertiary education"
5 "1st stage & 2nd stage of tertiary education"
;
label define PE020_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-2  "na (PE010 not=1)"
;
label define PE030_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "n.a. (the person has never been in education)"
;
label define PE040_VALUE_LABELS              
0 "pre-primary education"
1 "primary education"
2 "lower secondary education"
3 "(upper) secondary education"
4 "post-secondary non-tertiary education"
5 "1st & 2nd stage of tertiary education "
;
label define PE040_F_VALUE_LABELS           
1 "filled"
-1 "missing"
-2 "n.a. (the person has never been in education)"
;
label define PL030_VALUE_LABELS              
1 "working full-time"
2 "working part-time"
3 "Unemployed"
4 "Pupil, student, further training, unpaid work experience" 
5 "In retirement or in early retirement or has given up business"
6 "Permanently disabled orand unfit to work"
7 "In compulsory military community or service"
8 "Fulfilling domestic tasks or care responsibilities"
9 "Other inactive person"
;
label define PL030_F_VALUE_LABELS           
1 "filled"
-1 "missing"
;
label define PL035_VALUE_LABELS              
1 "yes"
2 "no"
;
label define PL035_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person is not employee or MS has other source to calculate the gender pay gap)"
-3 "not selected respondent"
;       
label define PL015_VALUE_LABELS              
1 "yes"
2 "no"
;
label define PL015_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL030=1 or 2)"
-3 "not selected respondent"
;
label define PL020_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL020_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL030=1 or 2)"
;
label define PL025_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL025_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL020=2)"
;
label define PL040_VALUE_LABELS                
1 "Self-employed with employees"
2 "self-employed without employees"
3 "employee"
4 "family worker"
;
label define PL040_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
;
label define PL050_VALUE_LABELS 
 1 "Armed Forces; MT:11–13 Legislators,senior officials & managers"
 2 "MT:21–24 Professionals"
 3 "MT:31–34 Technicians and associate professionals"
 4 "MT:41–42 Clerks"
 5 "MT:51–52 Service workers and shop and market sales workers"
 6 "MT:61 Skilled agricultural and fishery workers"
 7 "MT:71–74 Craft and related trades workers"
 8 "MT:81–83 Plant and machine operators and assemblers"
 9 "MT:91–93 Elementary occupations"
10 "MT:10 Armed forces"
11 "Legislators, senior officials and managers"
12 "corporate managers: only for PT, codes 11 & 12 grouped into 13"
13 "managers of small enterprises: only for PT, codes 11 & 12 grouped into 13"
21 "physical, mathematical and engineering professionals"
22 "life science and health professionals"
23 "teaching professionals"
24 "other professionals"
31 "physical and engineering science associate professionals"
32 "life science and helath associate professionals"
33 "Teaching associate professionals"
34 "other associate professionals"
41 "office clerks"
42 "customer services clerks"
51 "personal and protective services workers"
52 "models, salespersons and demonstrators"
61 "skilled agricultural and fishery workers"
71 "extraction and building trades workers"
72 "metal, machinery and related trades workers"
73 "precision, handicraft, craft printing and related trades workers"
74 "other craft and related trades workers"
81 "stationary-plant and related operators"
82 "machine operators and assemblers"
83 "drivers and mobile plant operators"
91 "sales and services elementary occupations"
92 "agricultural, fishery and related labourers"
93 "labourers in mining,construction,manufacturing & transport"
01 "armed forces"
;
label define PL050_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a." ;
*PL030 not=1 or 2 and PL015 not=1 and PL035 not=1 ;

label define PL060_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a."
-6 "Hours varying"
;
label define PL070_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL072_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL080_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL085_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL087_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL090_F_VALUE_LABELS              
1 "filled"
-1 "missing"
;
label define PL100_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a. (person does not have a 2nd job or PL030 not =1 or 2)"
;
label define PL110_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
-5 "missing value of PL110 because PL111 is used"
;

label define PL111_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable (PL030 not=1 or 2 & PL035 not=1)"
-3 "not selected respondent"
-5 "missing value of PL111 because PL110 is still used"
;

label define PL120_VALUE_LABELS                
1 "Undergoing education or training"
2 "Personal illness or disability"
3 "Want to work more hours but cannot find a job(s) or work(s) of more hours"
4 "Do not want to work more hours"
5 "Number of all hours in all job(s) are considered as full-time job"
6 "Housework, looking after children or other persons"  
7 "Other reasons"
;
label define PL120_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
;

* PL30 not=1 or 2 or PL060+PL100 not smaller than 30 ;
label define PL130_VALUE_LABELS                
11 "between 11 and 19 persons"
12 "between 20 and 49 persons"
13 "50 persons or more"
14 "do not know but less than 11 persons"
15 "do not know but more than 10 persons"
;
label define PL130_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
;
label define PL140_VALUE_LABELS                
1 "Permanent job work contract of unlimited duration" 
2 "temporary jobwork contract of limited duration"
;
label define PL140_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a."
-3 "not selected respondent"
-4 "n.a.:person is employee (PL040 not=3) but has not any contract"   
;
*PL040 not=3 ;

label define PL150_VALUE_LABELS                
1 "supervisory"
2 "non-supervisory"
;
label define PL150_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a." 
-3 "not selected respondent"
;
label define PL160_VALUE_LABELS                
1 "yes"
2 "no"
; 
label define PL160_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
;
* PL30 not=1 or 2 ;
label define PL170_VALUE_LABELS                
1 "To take up or seek better job"
2 "End of temporary contract"
3 "Obliged to stop by employer (business closure, redundancy, early retirement, dismissal etc."
4 "Sale or closure of ownfamily business"
5 "Child care and care for other dependant"
6 "Partners job required us to move to another area or marriage"
7 "Other reasons"
;
label define PL170_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
;
label define PL180_VALUE_LABELS                
1 "employed-unemployed"
2 "employed-retired"
3 "employed-other inactive"
4 "unemployed-employed"
5 "unemployed - retired"
6 "unemployed - other inactive"
7 "retired - employed"
8 "retired - unemployed" 
9 "retired - other inactive"
10 "other inactive - employed"
11 "other inactive - unemployed"
12  "other inactive - retired"
;
label define PL180_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (no change since last year)"
-3 "not selected respondent"
;
label define PL190_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a. (person never worked)"
-3 "not selected respondent" 
;
label define PL200_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (person never worked)"
-3 "not selected respondent"  
;
label define PL210A_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210A_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210B_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210B_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-3 "not selected respondend"
;
label define PL210C_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210C_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210D_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210D_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210E_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210E_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210F_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210F_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210G_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"

5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210G_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210H_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210H_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210I_VALUE_LABELS              
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210I_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210J_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210J_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
; 
label define PL210K_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210K_F_VALUE_LABELS             
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PL210L_VALUE_LABELS               
1 "Employee (full-time)"
2 "Employee (part-time)"
3 "Self-employed (full-time)"
4 "Self-employed (part-time)"
5 "unemployed"
6 "Retired"
7 "Student"
8 "Other inactive"
9 "Compulsory military service"
;
label define PL210L_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH010_VALUE_LABELS                
1 "very good"
2 "good"
3 "fair"
4 "bad"
5 "very bad"
;
label define PH010_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH020_VALUE_LABELS                
1 "yes"
2 "no"
8 "do not know (Germany only)"
;
label define PH020_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH030_VALUE_LABELS               
1 "yes, strongly limited"
2 "yes, limited"
3 "no, not limited"
;
label define PH030_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH040_VALUE_LABELS                
1 "yes there was at least one occasion when the person really needed examination or treatment but did not"               
2 "no, there was no occasion when the person really needed examination or treatment but did not"
8 "do not know (Germany only)"
;
label define PH040_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH050_VALUE_LABELS                
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travelno means of transportation"
5 "Fear of doctorhospitalexaminationtreatment"
6 "Wanted to wait and see if problrm got better on its own"
7 "did not know any good doctor or specialist"
8 "other reasons"
;
label define PH050_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-2 "na (Ph040 not=1)"
-3 "not selected respondent"
;
label define PH060_VALUE_LABELS                
1 "yes there was at least one occasion when the person really needed dental examination or treatment but did not"               
2 "no, there was no occasion when the person really needed dental examination or treatment but did not"
8 "do not know (German only)"
;
label define PH060_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH070_VALUE_LABELS               
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travelno means of transportation"
5 "Fear of doctor(dentist)hospitalexaminationtreatment"
6 "Wanted to wait and see if problrm got better on its own"
7 "did not know any dentist"
8 "other reasons"
;
label define PH070_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-2 "na (PH060 not =1)"
-3 "not selected respondent"
;
label define PY010N_F_VALUE_LABELS             
0  "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
43 "collected grossrecorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define PY020N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY021N_VALUE_LABELS               
0 "no income"
;
label define PY021N_F_VALUE_LABELS            
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
53  "collected unknownrecorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY035N_F_VALUE_LABELS             
0  "no contribution"
1 "variable is filled"
-1  "missing"
-5 "not filled: variable of the gross series is filled"
;
label define PY050N_VALUE_LABELS              
0 "no income"
;
label define PY050N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY070N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY080N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY090N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
43 "collected grossrecorded net of tax on social contrib."
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY100N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY110N_F_VALUE_LABELS             
0  "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY120N_F_VALUE_LABELS            
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY130N_F_VALUE_LABELS            
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY140N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib.recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected grossrecorded net of tax on income & social contrib."
42 "collected grossrecorded net of tax on income at source"
51 "collected unknownrecorded net of tax on income & social contrib."
52 "collected unknownrecorded net of tax on income"
53 "collected unknownrecorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY010G_F_VALUE_LABELS             
0  "no income"
1 "net of tax on income at source and social contribution"
2 "net of tax on income at source and social contribution"
3 "net of tax on social contribution"
4 "gross"
5 "unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY020G_F_VALUE_LABELS             
0  "no income"
1 "net of tax on income at source and social contribution"
2 "net of tax on income at source and social contribution"
3 "net of tax on social contribution"
4 "gross"
5 "unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY021G_VALUE_LABELS               
0 "no income"
;
label define PY021G_F_VALUE_LABELS            
-5 "not filled: variable of net series is filled"
-4 "amount included in another component"
-1 "missing"
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
;
label define PY030G_VALUE_LABELS               
0 "no contribution"
;
label define PY030G_F_VALUE_LABELS            
-5 "not filled: variable of net series is filled"
-1 "missing"
0 "no income"
1 "income (variable is filled)"
;
label define PY031G_VALUE_LABELS               
0 "no contribution"
;
label define PY031G_F_VALUE_LABELS 
0 "no income"
1 "income (variable is filled)"
-1 "missing"
-5 "not filled: variable of net (..G)   gross (..N) series is filled"
;

label define PY035G_F_VALUE_LABELS            
0 "no contribution"
1 "variable is filled"
-1 "missing"
-5 "not filled: variable of net series is filled" 
;  
label define PY050G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY070G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-2 "not defined in variable description unique to Norway"
-5 "not filled:variable of net series is filled"
;
label define PY080G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY090G_F_VALUE_LABELS             
0  "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY100G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY110G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY120G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY130G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY140G_F_VALUE_LABELS            
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY200G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
-1 "missing"
-2 "na" 
;
label define PX020_VALUE_LABELS               
80 "80 and over"
;
label define PX040_VALUE_LABELS                
1 "current household member aged >=16 (All hhld members aged >=16 are interviewed)"
2 "selected respondent(Only selected hhld member aged >= 16 is interviewed)"
3 "not selected respondent (Only selected hhld member aged >= 16 is interviewed)"
4 "not eligible person (Hhld members aged < 16 at the time of interview)"
;
label define PX050_VALUE_LABELS                
1 "EMPTOT > 0.5"
2 "UNPTOT > 0.5"
3 "RETTOT > 0.5"
4 "OINTOT > 0.5"
;

* Attachement of category labels to variables ;

label values PB040_F PB040_F_VALUE_LABELS ;
label values PB060_F PB060_F_VALUE_LABELS ;
label values PB100 PB100_VALUE_LABELS ;
label values PB100_F PB100_F_VALUE_LABELS ;
label values PB110_F PB110_F_VALUE_LABELS ;
label values PB120_F PB120_F_VALUE_LABELS ;
label values PB130 PB130_VALUE_LABELS ;
label values PB130_F PB130_F_VALUE_LABELS ; 
label values PB140 PB140_VALUE_LABELS ;
label values PB140_F PB140_F_VALUE_LABELS ;
label values PB150 PB150_VALUE_LABELS ;
label values PB150_F PB150_F_VALUE_LABELS ;
label values PB160_F PB160_F_VALUE_LABELS ;
label values PB170_F PB170_F_VALUE_LABELS ;
label values PB180_F PB180_F_VALUE_LABELS ;
label values PB190 PB190_VALUE_LABELS ;
label values PB190_F PB190_F_VALUE_LABELS ;
label values PB200 PB200_VALUE_LABELS ;
label values PB200_F PB200_F_VALUE_LABELS ;
label values PB210_num PB210_num_VALUE_LABELS ;
label values PB210_F PB210_F_VALUE_LABELS ;
label values PB220A_num PB220A_num_VALUE_LABELS ;
label values PB220A_F PB220A_F_VALUE_LABELS ;
label values PE010 PE010_VALUE_LABELS ;
label values PE010_F PE010_F_VALUE_LABELS ;
label values PE020 PE020_VALUE_LABELS ;
label values PE020_F PE020_F_VALUE_LABELS ;
label values PE030_F PE030_F_VALUE_LABELS ;
label values PE040 PE040_VALUE_LABELS ;
label values PE040_F PE040_F_VALUE_LABELS ;
label values PL030 PL030_VALUE_LABELS ;
label values PL030_F PL030_F_VALUE_LABELS ;
label values PL035 PL035_VALUE_LABELS ;
label values PL035_F PL035_F_VALUE_LABELS ;
label values PL015 PL015_VALUE_LABELS ;
label values PL015_F PL015_F_VALUE_LABELS ;
label values PL020 PL020_VALUE_LABELS ;
label values PL020_F PL020_F_VALUE_LABELS ;
label values PL025 PL025_VALUE_LABELS ;
label values PL025_F PL025_F_VALUE_LABELS ;
label values PL040 PL040_VALUE_LABELS ;
label values PL040_F PL040_F_VALUE_LABELS ;
label values PL050 PL050_VALUE_LABELS ;
label values PL050_F PL050_F_VALUE_LABELS ;
label values PL060_F PL060_F_VALUE_LABELS ;
label values PL070_F PL070_F_VALUE_LABELS ;
label values PL072_F PL072_F_VALUE_LABELS ;
label values PL080_F PL080_F_VALUE_LABELS ;
label values PL085_F PL085_F_VALUE_LABELS ;
label values PL087_F PL087_F_VALUE_LABELS ;
label values PL090_F PL090_F_VALUE_LABELS ;
label values PL100_F PL100_F_VALUE_LABELS ;
label values PL110_F PL110_F_VALUE_LABELS ;
label values PL111_F PL111_F_VALUE_LABELS ;
label values PL120 PL120_VALUE_LABELS ;
label values PL120_F PL120_F_VALUE_LABELS ;
label values PL130 PL130_VALUE_LABELS ;
label values PL130_F PL130_F_VALUE_LABELS ;
label values PL140 PL140_VALUE_LABELS ;
label values PL140_F PL140_F_VALUE_LABELS ;
label values PL150 PL150_VALUE_LABELS ;
label values PL150_F PL150_F_VALUE_LABELS ;
label values PL160 PL160_VALUE_LABELS ;
label values PL160_F PL160_F_VALUE_LABELS ;
label values PL170 PL170_VALUE_LABELS ;
label values PL170_F PL170_F_VALUE_LABELS ;
label values PL180 PL180_VALUE_LABELS ;
label values PL180_F PL180_F_VALUE_LABELS ;
label values PL190_F PL190_F_VALUE_LABELS ;
label values PL200_F PL200_F_VALUE_LABELS ;
label values PL210A PL210A_VALUE_LABELS ; 
label values PL210A_F PL210A_F_VALUE_LABELS ;
label values PL210B PL210B_VALUE_LABELS ;
label values PL210B_F PL210B_F_VALUE_LABELS ;
label values PL210C PL210C_VALUE_LABELS ;
label values PL210C_F PL210C_F_VALUE_LABELS ;
label values PL210D  PL210D_VALUE_LABELS ;
label values PL210D_F PL210D_F_VALUE_LABELS ;
label values PL210E PL210E_VALUE_LABELS ;
label values PL210E_F PL210E_F_VALUE_LABELS ;
label values PL210F PL210F_VALUE_LABELS ;
label values PL210F_F PL210F_F_VALUE_LABELS ;
label values PL210G PL210G_VALUE_LABELS ;
label values PL210G_F PL210G_F_VALUE_LABELS ;
label values PL210H PL210H_VALUE_LABELS ;
label values PL210H_F PL210H_F_VALUE_LABELS ;
label values PL210I PL210I_VALUE_LABELS ;
label values PL210I_F PL210I_F_VALUE_LABELS ; 
label values PL210J PL210J_VALUE_LABELS ;
label values PL210J_F PL210J_F_VALUE_LABELS ; 
label values PL210K PL210K_VALUE_LABELS ;
label values PL210K_F PL210K_F_VALUE_LABELS ;
label values PL210L PL210L_VALUE_LABELS ;
label values PL210L_F PL210L_F_VALUE_LABELS ;
label values PH010 PH010_VALUE_LABELS ;
label values PH010_F PH010_F_VALUE_LABELS ;
label values PH020 PH020_VALUE_LABELS ;
label values PH020_F  PH020_F_VALUE_LABELS ;
label values PH030 PH030_VALUE_LABELS ;
label values PH030_F PH030_F_VALUE_LABELS ;
label values PH040 PH040_VALUE_LABELS ;
label values PH040_F PH040_F_VALUE_LABELS ;
label values PH050 PH050_VALUE_LABELS ;
label values PH050_F PH050_F_VALUE_LABELS ;
label values PH060 PH060_VALUE_LABELS ;
label values PH060_F PH060_F_VALUE_LABELS ;
label values PH070 PH070_VALUE_LABELS ;
label values PH070_F PH070_F_VALUE_LABELS ;
label values PY010N_F PY010N_F_VALUE_LABELS ;
label values PY020N_F PY020N_F_VALUE_LABELS ;
label values PY021N PY021N_VALUE_LABELS ;
label values PY021N_F PY021N_F_VALUE_LABELS ;
label values PY035N_F PY035N_F_VALUE_LABELS ;
label values PY050N PY050N_VALUE_LABELS ;
label values PY050N_F PY050N_F_VALUE_LABELS ;
label values PY070N_F PY070N_F_VALUE_LABELS ; 
label values PY080N_F PY080N_F_VALUE_LABELS ;
label values PY090N_F PY090N_F_VALUE_LABELS ;
label values PY100N_F PY100N_F_VALUE_LABELS ; 
label values PY110N_F PY110N_F_VALUE_LABELS ;
label values PY120N_F PY120N_F_VALUE_LABELS ;
label values PY130N_F  PY130N_F_VALUE_LABELS ;
label values PY140N_F PY140N_F_VALUE_LABELS ;
label values PY010G_F PY010G_F_VALUE_LABELS ;
label values PY020G_F PY020G_F_VALUE_LABELS ;
label values PY021G PY021G_VALUE_LABELS ;
label values PY021G_F PY021G_F_VALUE_LABELS ;
label values PY030G PY030G_VALUE_LABELS ;
label values PY030G_F PY030G_F_VALUE_LABELS ;
label values PY031G PY031G_VALUE_LABELS ;
label values PY031G_F PY031G_F_VALUE_LABELS ;
label values PY035G_F PY035G_F_VALUE_LABELS ;
label values PY050G_F PY050G_F_VALUE_LABELS ;
label values PY070G_F PY070G_F_VALUE_LABELS ;
label values PY080G_F PY080G_F_VALUE_LABELS ;
label values PY090G_F PY090G_F_VALUE_LABELS ;
label values PY100G_F PY100G_F_VALUE_LABELS ;
label values PY110G_F PY110G_F_VALUE_LABELS ;
label values PY120G_F PY120G_F_VALUE_LABELS ;
label values PY130G_F PY130G_F_VALUE_LABELS ;                                
label values PY140G_F PY140G_F_VALUE_LABELS ;
label values PY200G_F PY200G_F_VALUE_LABELS ;
label values PX020 PX020_VALUE_LABELS ;
label values PX040 PX040_VALUE_LABELS ;
label values PX050 PX050_VALUE_LABELS ;
label values PL110_num PL110_num_VALUE_LABELS ;
label values PL111_num PL111_num_VALUE_LABELS ;


label data "Personal data file 2008" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr







