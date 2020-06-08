********************************************************************************
****   Project: COVID-19 cases/deaths/recovered by States (Latest Update: 05/10/2020)
****   Producer: Wooserk Park
****   Steps: 1. Cleaning Data Using Master Data from Johns Hopkins University Data
****         	 1.1. Worldwide Data Collecting (daily_reports)
****         	 1.2. Cleaning the data
****          2. Producing Weekly Data 
****   
****   Note1: Data from: https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/  
****   Note2: Data will be updated every Sunday (Each weekly data contain Monday to Sunday observations)
********************************************************************************

ssc install fs
global master = "C:\Users\User\project_based Dropbox\Wooserk Park\wooserk&rahul\COVID-19_Analysis"
global datainput = "C:\Users\User\project_based Dropbox\Wooserk Park\wooserk&rahul\COVID-19_Analysis\03_data_collection"
global dataoutput = "C:\Users\User\project_based Dropbox\Wooserk Park\wooserk&rahul\COVID-19_Analysis\02_data_cleaning"

********************************************************************************
** 1. Cleaning Data **
********************************************************************************
********************************************************************************
** 1.1. Worldwide Data Collecting (daily_reports) ****************************

cd "$master\03_data_collection\COVID Scrap"

local URL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
forvalues month = 1/12 {
   forvalues day = 1/31 {
      local month = string(`month', "%02.0f")
      local day = string(`day', "%02.0f")
      local year = "2020"
      local today = "`month'-`day'-`year'"
      local FileName = "`URL'`today'.csv"
      clear
      capture import delimited "`FileName'"
      capture confirm variable ïprovincestate
	  gen date = "`month'`day'`year'"
	  gen month = "`month'"
	  gen day = "`day'"
	  gen year = "`year'"
      if _rc == 0 {
         rename ïprovincestate provincestate
         label variable provincestate "Province/State"
      }
      capture save "`today'", replace
   }
}
** This code came from JHU Repository. I added some date variables to make it easy to separate the timeline for the future step **
clear
forvalues month = 1/12 {
   forvalues day = 1/31 {
      local month = string(`month', "%02.0f")
      local day = string(`day', "%02.0f")
      local year = "2020"
      local today = "`month'-`day'-`year'"
		capture append using "`today'"
   }
}
save "$dataoutput\rawdata\append_COVID.dta", replace
********************************************************************************

********************************************************************************
** 1.2. Cleaning the data ******************************************************
use "$dataoutput\rawdata\append_COVID.dta", clear
gen date1 = date(date, "MDY")
format date1 %td
destring month day year, replace
gen myday = mdy(month, day, year)
gen mysunday = myday - mod(dow(myday) -1 , 7)
gen week = week(mysunday) + 1
drop myday mysunday
gen dow = dow(mdy(month, day, year))
drop if dow ~= 0
drop dow
** Create week variable & kept Sunday due to duplicates **

drop last_update lastupdate
order date* week admin2 province_state country_region lat long_ active combined_key fips /// ** this is the latest variable shape (post-Mar 21) 
provincestate countryregion confirmed deaths recovered latitude longitude ïfips  // ** Pre-Mar 21 
** reordered variables to show the latest categories first **

replace country_region = countryregion if country_region == "" 
keep if country_region == "US"
replace lat = latitude if lat == . 
replace long_ = longitude if long_ == . 
replace fips = ïfips if fips == . 
drop countryregion latitude longitude ïfips

** provincestate format has been changed after Mar 09. Needed to clean those **
replace province_state = provincestate if province_state == ""  
**51 States Abbr -> State Name **
replace province_state = "Alaska" if regexm(provincestate, ", AK")
replace province_state = "Alabama" if regexm(provincestate, ", AL")
replace province_state = "Arkansas" if regexm(provincestate, ", AR")
replace province_state = "Arizona" if regexm(provincestate, ", AZ")
replace province_state = "California" if regexm(provincestate, ", CA")
replace province_state = "Colorado" if regexm(provincestate, ", CO")
replace province_state = "Connecticut" if regexm(provincestate, ", CT")
replace province_state = "District of Columbia" if regexm(provincestate, ", DC")
replace province_state = "Delaware" if regexm(provincestate, ", DE")
replace province_state = "Florida" if regexm(provincestate, ", FL")
replace province_state = "Georgia" if regexm(provincestate, ", GA")
replace province_state = "Hawaii" if regexm(provincestate, ", HI")
replace province_state = "Iowa" if regexm(provincestate, ", IA")
replace province_state = "Idaho" if regexm(provincestate, ", ID")
replace province_state = "Illinois" if regexm(provincestate, ", IL")
replace province_state = "Indiana" if regexm(provincestate, ", IN")
replace province_state = "Kansas" if regexm(provincestate, ", KS")
replace province_state = "Kentucky" if regexm(provincestate, ", KY")
replace province_state = "Louisiana" if regexm(provincestate, ", LA")
replace province_state = "Massachusetts" if regexm(provincestate, ", MA")
replace province_state = "Maryland" if regexm(provincestate, ", MD")
replace province_state = "Maine" if regexm(provincestate, ", ME")
replace province_state = "Michigan" if regexm(provincestate, ", MI")
replace province_state = "Minnesota" if regexm(provincestate, ", MN")
replace province_state = "Missouri" if regexm(provincestate, ", MO")
replace province_state = "Mississippi" if regexm(provincestate, ", MS")
replace province_state = "Montana" if regexm(provincestate, ", MT")
replace province_state = "North Carolina" if regexm(provincestate, ", NC")
replace province_state = "North Dakota" if regexm(provincestate, ", ND")
replace province_state = "Nebraska" if regexm(provincestate, ", NE")
replace province_state = "New Hampshire" if regexm(provincestate, ", NH")
replace province_state = "New Jersey" if regexm(provincestate, ", NJ")
replace province_state = "New Mexico" if regexm(provincestate, ", NM")
replace province_state = "Nevada" if regexm(provincestate, ", NV")
replace province_state = "New York" if regexm(provincestate, ", NY")
replace province_state = "Ohio" if regexm(provincestate, ", OH")
replace province_state = "Oklahoma" if regexm(provincestate, ", OK")
replace province_state = "Oregon" if regexm(provincestate, ", OR")
replace province_state = "Pennsylvania" if regexm(provincestate, ", PA")
replace province_state = "Rhode Island" if regexm(provincestate, ", RI")
replace province_state = "South Carolina" if regexm(provincestate, ", SC")
replace province_state = "South Dakota" if regexm(provincestate, ", SD")
replace province_state = "Tennessee" if regexm(provincestate, ", TN")
replace province_state = "Texas" if regexm(provincestate, ", TX")
replace province_state = "Utah" if regexm(provincestate, ", UT")
replace province_state = "Virginia" if regexm(provincestate, ", VA")
replace province_state = "Vermont" if regexm(provincestate, ", VT")
replace province_state = "Washington" if regexm(provincestate, ", WA")
replace province_state = "Wisconsin" if regexm(provincestate, ", WI")
replace province_state = "West Virginia" if regexm(provincestate, ", WV")
replace province_state = "Wyoming" if regexm(provincestate, ", WY")
**Etc.**
replace province_state = "Armed Forces" if regexm(provincestate, ", AE")
replace province_state = "Armed Forces" if regexm(provincestate, ", AA")
replace province_state = "Armed Forces" if regexm(provincestate, ", AE")
replace province_state = "Armed Forces" if regexm(provincestate, ", AP")
**Unassigned Location: Diamond Princess**
replace provincestate = "Grand Princess" if province_state == "Grand Princess Cruise Ship"
replace province_state = "Grand Princess" if regexm(province_state, "Princess")
replace admin2 = "Grand Princess" if province_state == "Grand Princess"
replace admin2 = "Grand Princess" if regexm(provincestate, "Diamond Princess")
**In terms of this State version, a concern is how to deal with Diamond Princess; I cleaned it as much as possible - Wooserk 04122020**

replace province_state = "Virgin Islands" if regexm(province_state, "Virgin Islands")
replace province_state = "District of Columbia" if province_state == "Washington, D.C."
**Matching a provincestate variable if two same areas use differet names **

order date* week province_state country_region confirmed deaths recovered
replace deaths = 0 if deaths == .
replace recovered = 0 if recovered == .

tab province_state, m
** Checked missing values: No Missing **

save "$dataoutput\rawdata\append_COVID_cl2.dta", replace
********************************************************************************

********************************************************************************
** 2. Weekly Data Producing **
********************************************************************************	 
use "$dataoutput\rawdata\append_COVID_cl2.dta", clear	  

levelsof week, local(levels)
foreach i of local levels {
preserve
keep if week == `i'
collapse (sum) confirmed deaths recovered (mean) week, by (province_state)
order week
rename (confirmed deaths recovered) (confirmed`i' deaths`i' recovered`i')
save "$dataoutput\weekly_data\week_`i'.dta", replace
restore
}
foreach i of local levels {
use "$dataoutput\weekly_data\week_4.dta", clear
forvalues k = 5/`i' {
merge 1:1 province_state using "$dataoutput\weekly_data\week_`k'.dta", nogen
}
drop week
order province_state confirmed* deaths* recovered*
save "$dataoutput\weekly_data\week_merge.dta", replace
}

** Exporting **
use "$dataoutput\weekly_data\week_merge.dta", clear
reshape long confirmed deaths recovered, i(province_state) j(week)
replace confirmed = 0 if confirmed == .
replace deaths = 0 if deaths == .
replace recovered = 0 if recovered == .
gen week_beginning = mdy(1,1, 2020) + week *7 - 9
format week_beginning %td

gen state_code = "AK" if province_state == "Alaska"
replace state_code = "AL" if province_state == "Alabama"
replace state_code = "AR" if province_state == "Arkansas"
replace state_code = "AZ" if province_state == "Arizona"
replace state_code = "CA" if province_state == "California"
replace state_code = "CO" if province_state == "Colorado"
replace state_code = "CT" if province_state == "Connecticut"
replace state_code = "DC" if province_state == "District of Columbia"
replace state_code = "DE" if province_state == "Delaware"
replace state_code = "FL" if province_state == "Florida"
replace state_code = "GA" if province_state == "Georgia"
replace state_code = "HI" if province_state == "Hawaii"
replace state_code = "IA" if province_state == "Iowa"
replace state_code = "ID" if province_state == "Idaho"
replace state_code = "IL" if province_state == "Illinois"
replace state_code = "IN" if province_state == "Indiana"
replace state_code = "KS" if province_state == "Kansas"
replace state_code = "KY" if province_state == "Kentucky"
replace state_code = "LA" if province_state == "Louisiana"
replace state_code = "MA" if province_state == "Massachusetts"
replace state_code = "MD" if province_state == "Maryland"
replace state_code = "ME" if province_state == "Maine"
replace state_code = "MI" if province_state == "Michigan"
replace state_code = "MN" if province_state == "Minnesota"
replace state_code = "MO" if province_state == "Missouri"
replace state_code = "MS" if province_state == "Mississippi"
replace state_code = "MT" if province_state == "Montana"
replace state_code = "NC" if province_state == "North Carolina"
replace state_code = "ND" if province_state == "North Dakota"
replace state_code = "NE" if province_state == "Nebraska"
replace state_code = "NH" if province_state == "New Hampshire"
replace state_code = "NJ" if province_state == "New Jersey"
replace state_code = "NM" if province_state == "New Mexico"
replace state_code = "NV" if province_state == "Nevada"
replace state_code = "NY" if province_state == "New York"
replace state_code = "OH" if province_state == "Ohio"
replace state_code = "OK" if province_state == "Oklahoma"
replace state_code = "OR" if province_state == "Oregon"
replace state_code = "PA" if province_state == "Pennsylvania"
replace state_code = "RI" if province_state == "Rhode Island"
replace state_code = "SC" if province_state == "South Carolina"
replace state_code = "SD" if province_state == "South Dakota"
replace state_code = "TN" if province_state == "Tennessee"
replace state_code = "TX" if province_state == "Texas"
replace state_code = "UT" if province_state == "Utah"
replace state_code = "VA" if province_state == "Virginia"
replace state_code = "VT" if province_state == "Vermont"
replace state_code = "WA" if province_state == "Washington"
replace state_code = "WI" if province_state == "Wisconsin"
replace state_code = "WV" if province_state == "West Virginia"
replace state_code = "WY" if province_state == "Wyoming"
replace state_code = "GU" if province_state == "Guam"
replace state_code = "PR" if province_state == "Puerto Rico"
replace state_code = "VI" if province_state == "Virgin Islands"
replace state_code = "AS" if province_state == "American Samoa"
**Etc.**
replace state_code = "AE" if province_state == "Armed Forces"
**Unassigned Location: Diamond Princess**
replace state_code = "Grand Princess" if province_state == "Grand Princess"

rename province_state state_name
rename confirmed cumulative_cases
rename deaths cumulative_deaths
rename recovered cumulative_recovered

order state_name state_code week_beginning week cumulative_cases cumulative_deaths cumulative_recovered
export excel using "$dataoutput\weekly_data\weekly_summary.xls", sheet("Export from Stata") sheetmodify firstrow(variables)


**End.**

**Please feel free to suggest and instruct me if you find any issues or problems**
