* 2009_cross_eu_silc_r_ver_2021_04.do 
* 2nd update
*
* STATA Command Syntax File
* Stata 16.1;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* 
* EU-SILC Cross 2009 - release 2021-04 / DOI: https://doi.org/10.2907/EUSILC2004-2019V.2 
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> – version of 2021-04"
*
* Personal register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*09H.csv
* 
* (c) GESIS 2021-11-17
* 
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* L-2009 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus and Johanna Jung (2021): 2009_cross_eu_silc_r_ver_2021_04.do, 2nd update.
* Stata-Syntax for transforming EU-SILC csv data into a Stata-Systemfile.
*
* https://www.gesis.org/gml/european-microdata/eu-silc/
*
* Contact: heike.wirth@gesis.org

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

local log_file "$log/eusilc_2009_r" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2019) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2009_r_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 
tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK UK { ;
      cd "$csv_path/`CC'/2009" ;
	   import delimited using "UDB_c`CC'09R.csv", case(upper) clear ;
	  append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;

sort RB020 ;

log using "`log_file'", replace text ;


* Definition of variable labels ;
label variable RB010 "Year of the survey" ;
label variable RB020 "Country alphanumeric" ;
label variable RB030 "Personal ID" ;
label variable RB050 "Personal cross-sectional weight" ;
label variable RB050_F "Flag" ;
label variable RB070 "Quarter of Birth" ;
label variable RB070_F "Flag" ;
label variable RB080 "Year of birth" ;
label variable RB080_F "Flag" ;
label variable RB090 "Sex" ;
label variable RB090_F "Flag" ;
label variable RB200 "Residential status" ;
label variable RB200_F "Flag" ;
label variable RB210 "Basic activity status" ;
label variable RB210_F "Flag" ;
label variable RB220 "Father ID" ;
label variable RB220_F "Flag" ;
label variable RB230 "Mother ID" ;
label variable RB230_F "Flag" ;
label variable RB240 "Spouse/Partner ID" ;
label variable RB240_F "Flag" ;
label variable RB245 "Respondent status" ;
label variable RB245_F "Flag" ;
label variable RB250 "Data status" ;
label variable RB250_F "Flag" ;
label variable RB260 "Type of interview" ;
label variable RB260_F "Flag" ;
label variable RB270 "Personal ID of proxy" ;
label variable RB270_F "Flag" ;
label variable RL010 "Education at pre-school: number of hours of education during an usual week" ;
label variable RL010_F "Flag" ;
label variable RL020 "Education at compulsory school: number of hours of education during an usual week" ;
label variable RL020_F "Flag" ;
label variable RL030 "Childcare at centre-based services: number of hours of child care during an usual week" ;
label variable RL030_F "Flag" ;
label variable RL040 "Childcare at day-care centre: number of hours of child care during an usual week" ;
label variable RL040_F "Flag" ;
label variable RL050 "Child care by a professional child-miner: number of hours of child care during an usual week" ;
label variable RL050_F "Flag" ;
label variable RL060 "Child care by grand-parents;other household members;relatives etc: number of hours during an usual week" ;
label variable RL060_F "Flag" ;
label variable RL070 "Children cross-sectional weight for child care" ;
label variable RL070_F "Flag" ;
label variable RX030 "Household ID" ;
label variable RX020 "Age at the end of the income reference period" ;
label variable RX010 "Age at the date of the interview" ;
label variable RX040 "Work intensity" ;
label variable RX050 "Low work intensity  status" ;
label variable RX060 "Severely materially deprived household" ;
label variable RX070 "At risk of poverty or social exclusion" ;

* Definition of category labels ;
label define RB050_F_VALUE_LABELS           
1 "filled"
;
label define RB070_VALUE_LABELS             
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define RB070_F_VALUE_LABELS           
1 "filled"
-1 "missing"
;
label define RB080_VALUE_LABELS            
1928 "1928 or before"
1929 "PT: 1929 and before"
1933 "MT: 1929-1933"
1938 "MT: 1934-1938"
1943 "MT: 1939-1943"
1948 "MT: 1944-1948"
1953 "MT: 1949-1953"
1958 "MT: 1954-1958"
1963 "MT: 1959-1963"
1968 "MT: 1964-1968"
1973 "MT: 1969-1973"
1978 "MT: 1974-1978"
1983 "MT: 1979-1983"
1988 "MT: 1984-1988"
1993 "MT: 1989-1993"
1998 "MT: 1994-1998"
2003 "MT: 1999-2003"
2009 "MT: 2004-2009"
;
label define RB080_F_VALUE_LABELS           
1 "filled"
-1 "missing" 
;
label define RB090_VALUE_LABELS             
1 "Male"
2 "Female"
;
label define RB090_F_VALUE_LABELS           
1 "filled"
-1 "missing"
;
label define RB200_VALUE_LABELS             
1 "currently living in the household"
2 "temporarily absent"
;
label define RB200_F_VALUE_LABELS           
1 "filled"      
-1 "missing"
;
label define RB210_VALUE_LABELS             
1 "at work"
2 "unemployed"
3 "in retirement or early retirement"
4 "other inactive person"
;
label define RB210_F_VALUE_LABELS           
1 "filled"      
-1 "missing"
;
label define RB220_F_VALUE_LABELS           
1 "filled"      
-1 "missing" 
-2 "na(father is not a household member)"
;
label define RB230_F_VALUE_LABELS           
1 "filled"      
-1 "missing" 
-2 "na(mother is not a household member)"
;
label define RB240_F_VALUE_LABELS            
1 "filled"      
-1 "missing" 
-2 "na(spousepartner is not a household member)"
; 
label define RB245_VALUE_LABELS              
1 "current household member aged 16 and over (all hm aged 16+ interviewed)"
2 "selected respondent (only selected hm aged 16+ interviewed)"
3 "not selected respondent(only selected hm aged 16+ interviewed)"
4 "not eligible person(Hm aged less than 16)"
;
label define RB245_F_VALUE_LABELS            
1 "filled"
;
label define RB250_VALUE_LABELS             
11 "information only completed from interview (information or interview completed)"
12 "information only completed from registers(information or interview completed) "
13 "information completed from both: interview and registers(information or interview completed) "
14 "information completed from full-record imputation (information or interview completed)"
21 "individual unable to respond and no proxy possible(Interview not completed though contact made)"
22 "failed to return self-completed questionnaire (Interview not completed though contact made)"
23 "refusal to cooperate(Interview not completed though contact made) "
31 "Individual not contacted because temporarily away and no proxy possible "
32 "Individual not contacted  for other reasons"
33 "information not completed: reason unknown"
;
label define RB250_F_VALUE_LABELS            
1 "filled"
-2 "na (RB245 not = 1,2 or 3)"
;
label define RB260_VALUE_LABELS              
1 "face to face interview-PAPI"
2 "face to face interview-CAPI"
3 "CATI, telephone interview"
4 "self-administered by respondent"
5 "proxy interview"
;
label define RB260_F_VALUE_LABELS           
1 "filled"
-1 "missing"
-2 "na (RB250 not=11 or 13)" 
;
label define RB270_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (RB260 not=5)"
;
label define RL010_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person not admitted to pre-school because of her age)"
;
label define RL020_F_VALUE_LABELS           
1 "filled"
-1 "missing"
-2 "na (person is not admitted to compulsory school)"
;
label define RL030_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person is neither at pre-school nor at school or is more than twelve years old" 
;     
label define RL040_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person is more than twelve years old)"
;
label define RL050_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person is more than twelve years old)"
;
label define RL060_F_VALUE_LABELS           
1 "filled"
-1 "missing"
-2 "na (person is more than twelve years old)"
;
label define RL070_F_VALUE_LABELS            
1 "filled"
-2 "na (children born in year N or persons aged more than 12 years old at the 3112N-1)"
;
label define RX020_VALUE_LABELS
 80 "80 and over"
;
label define RX050_VALUE_LABELS
0 "no low work intensity"
1 "low work intensity"
2 "na"
;
label define RX060_VALUE_LABELS
0 "not severely materially deprived"
1 "severely materially deprived"
;
label define RX070_VALUE_LABELS 
000 "not ARP/not severely materially deprived/no low work intensity"
001 "not ARP/not severely materially deprived/low work intensity"
010 "not ARP/severely materially deprived/no low work intensity"
011 "not ARP/severely materially deprived/low work intensity"
100 "ARP/not severely materially deprived/no low work intensity"
101 "ARP/not severely materially deprived/low work intensity"
110 "ARP/severely materially deprived/no low work intensity"
111 "ARP/severely materially deprived/low work intensity"
;

* Attachement of category labels to variable ;

label values RB050_F RB050_F_VALUE_LABELS ;
label values RB070 RB070_VALUE_LABELS ;
label values RB070_F RB070_F_VALUE_LABELS ;
label values RB080 RB080_VALUE_LABELS ;
label values RB080_F RB080_F_VALUE_LABELS ;
label values RB090 RB090_VALUE_LABELS ;
label values RB090_F RB090_F_VALUE_LABELS ;
label values RB200 RB200_VALUE_LABELS ;
label values RB200_F RB200_F_VALUE_LABELS ;
label values RB210 RB210_VALUE_LABELS ;
label values RB210_F RB210_F_VALUE_LABELS ;
label values RB220_F RB220_F_VALUE_LABELS ;
label values RB230_F RB230_F_VALUE_LABELS ;
label values RB240_F RB240_F_VALUE_LABELS ;
label values RB245 RB245_VALUE_LABELS ;
label values RB245_F RB245_F_VALUE_LABELS ;
label values RB250 RB250_VALUE_LABELS ;
label values RB250_F RB250_F_VALUE_LABELS ;
label values RB260 RB260_VALUE_LABELS ;
label values RB260_F RB260_F_VALUE_LABELS ;
label values RB270_F RB270_F_VALUE_LABELS ;
label values RL010_F RL010_F_VALUE_LABELS ;
label values RL020_F RL020_F_VALUE_LABELS ;
label values RL030_F RL030_F_VALUE_LABELS ;
label values RL040_F RL040_F_VALUE_LABELS ;
label values RL050_F RL050_F_VALUE_LABELS ;
label values RL060_F RL060_F_VALUE_LABELS ;
label values RL070_F RL070_F_VALUE_LABELS ;
label values RX010 RX020 RX020_VALUE_LABELS ;
label values RX050 RX050_VALUE_LABELS ;
label values RX060 RX060_VALUE_LABELS ;
label values RX070 RX070_VALUE_LABELS ;

label data "Personal register file 2009" ;

save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



