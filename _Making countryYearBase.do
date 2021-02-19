****************************************
** Making a countryYearBase .dta file **
****************************************

clear all
* Set-up of the folders - Mirek
run "C:/Users/miros/Desktop/Dropbox/Research/_General/Setting up folders Mirek.do"
set maxvar 20000 

* Set-up of the folders - Terka
run "/Users/tereza/Dropbox/_General/Setting up folders Terka.do"

/*
use "$CYB/countryYearBase final.dta", clear
keep if year==2019
save "$CYB/countryBase final.dta", replace 
*/

**Contents: 
{
/*
** 1) Developing country classifications
* 1a) dev_WEO2015 class_devgroup_WEO2015
* 1b) dev_status_un
** 2) International organizations, overseas countries and territories
* 2a) EU-28 
* 2b) OECD
* 2c) British Overseas Territories
* 2d) British Crown Dependencies
* 2e) British Overseas Countries and Territories (2c+2d)
* 2f) Dutch Overseas Countries and Territories
* 2g) French Overseas Countries and Territories
* 2h) Danish Overseas Countries and Territories
* 2i) EU-28 Overseas Countries and Territories (2e+2f+2g+2h)
* 2j) OPEC
* 2k) EFTA
** 3) Tax haven lists
* 3a) th_johannesen2014 th_zucman2013 th_gravelle2015 th_hines2010 th_hines1994 th_oecd2000 th_ibfd1977 th_irish1982 th_imf2000 th_fsf2000 th_fatf2002 th_tjn2005 th_imf2007 th_levin2007 th_lowtaxnet2008 th_fsi2009 th_fsi2011 thl_13 th_unctad2015 spe_unctad2015
* 3b) thl_15, thl_11 - experts' consensus - the sum of appearances on selected tax haven lists
* 3c) th_eu_blacklist_150618
* 3d) th_eu_blacklist_171205
* 3e) th_eu_greylist_171205
* 3f) th_eu_blacklist_180123
* 3g) th_eu_greylist_180123
* 3h) th_eu_blacklist_180313
* 3i) th_eu_greylist_180313
* 3j) th_eu_blacklist_180525
* 3k) th_eu_greylist_180525
* 3l) th_eu_blacklist_181002
* 3m) th_eu_greylist_181002
* 3n) th_eu_blacklist_181106
* 3o) th_eu_greylist_181106
* 3p) th_eu_blacklist_181204
* 3q) th_eu_greylist_181204
* 3r) th_eu_blacklist_190312
* 3s) th_eu_greylist_190312
** 4) WB and other: time invariant variables
* 4a) region_wb
* 4b) income_wb (invariable)
* 4c) region_final
* 4d) region_final dummy
* 4e) income_wb_2017 dummy
** 5) WB and other: time variant variables
* 5a) gdp_wb
* 5b) gdp_un
* 5c) gdp_cia
* 5d) gdp_final
* 5e) population_wb
* 5f) population_final
* 5g) gdppc_final
** 6) World Governance Indicators
* 6a) WGI_1 WGI_2 WGI_3 WGI_4 WGI_5 WGI_6
** 7) Tax rates
* 7a) nctr_kpmg
* 7b) nctr_tradingeconomics
* 7c) nctr_oecd
* 7d) nctr_taxf
* 7e) nctr_final
* 7f) ectr_gjt
* 7g) ectr_oecd
** 8) FSI
* 8a) FSI 2009
* 8b) FSI 2011
* 8c) FSI 2013
* 8d) FSI 2015
* 8e) FSI 2018
* 8f) FSI 2020
* 8f) FSI data of panel nature
* 8g) MFSI - FSI over time
* 8h) KFSI_2018_15_id172
** 9) FDI data
* 9a) FDI stocks (outward and inward) from UNCTAD
* 9b) FDI stocks (outward and inward) from IMF CDIS
** 10) Government revenue data
* 10a) ICTD GRD
* 10b) IMF GFS
** 11) Balance of Payments
* 11a) IMF Balance of Payments
* 11b) WTO exports of financial services
* 11c) WTO imports of financial services
** 12) BIS deposits
** 13) Intermediaries
*13a) Big Four, McKinsey presence
*13b) Big Four offices and Banks
** 14) IMF CPIS
** 15) CTHI
** 16) Number of new businesses registered
** 17) Shadow economy estimates - TODO
* 17a)
** 18) Profit shifting estimates - TODO
** 19) UNCTADStat trade in services
** 20) Comtrade
** 21) Income inequality
*/
}

***Prepare base
{
/*
**The base file is the Excel file called 01_ountry names.csv. It contains all countries that we want. We import it, reshape and save as a .dta file to which we then add other info.
insheet using "$CYB/_country names.csv", clear
reshape long existence, i(country) j(year)
drop imfcountryname existence
order country year
label variable country_iso3 "ISO-3 code of country"
label variable country_iso2 "ISO-2 code of country"
keep if year<2021
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x
save "$CYB/countryYearBase v0.dta", replace
keep if year==2019
drop year
save "$CYB/countryBase v0.dta", replace
*/
}

***Prepare data to be merged onto the base
{
** 1) Developing country classifications
{
* 1a) dev_WEO2015,class_devgroup_WEO2015. Source: IMF 2015 World Economic Outlook for 2015
insheet using "$Data/Development status/dev_WEO2015.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
replace dev_weo2015=0 if dev_weo2015==.
label variable dev_weo2015 "Developing country dummy. Source: IMF WEO 2015, for 2015."
label variable class_devgroup_weo2015 "Developing country classification. Source: IMF WEO 2015, for 2015."
save "$Data/Development status/dev_WEO2015.dta", replace
* 1b) dev_status_un. Source: UN website, 20190212, https://unctadstat.unctad.org/en/classifications.html
insheet using "$Data/Development status/dev_status_un.csv", n clear
run "$General/Harmonizing country names.do"
drop c_x
label variable dev_status_un "Development status. Source: UN, 20190212."
save "$Data/Development status/dev_status_un.dta", replace
}
** 2) International organizations, overseas countries and territories
{
use "$CYB/countryYearBase v0.dta", clear
keep if year==2018
* 2a) EU-27
gen EU27=0
replace EU27=1 if country=="Austria" | country=="Belgium" | country=="Bulgaria" | country=="Croatia" | country=="Cyprus" | country=="Czechia" | country=="Denmark" | country=="Estonia" | country=="Finland" | country=="France" | country=="Germany" | country=="Greece" | country=="Hungary" | country=="Ireland" | country=="Italy" | country=="Latvia" | country=="Lithuania" | country=="Luxembourg" | country=="Malta" | country=="Netherlands" | country=="Poland" | country=="Portugal" | country=="Romania" | country=="Slovakia" | country=="Slovenia" | country=="Spain" | country=="Sweden"
label variable EU27 "Dummy for EU-27 member countries (i.e. excl. UK)"
* 2b) EU-28 - done also in TJN portal
gen EU28=0
replace EU28=1 if country=="Austria" | country=="Belgium" | country=="Bulgaria" | country=="Croatia" | country=="Cyprus" | country=="Czechia" | country=="Denmark" | country=="Estonia" | country=="Finland" | country=="France" | country=="Germany" | country=="Greece" | country=="Hungary" | country=="Ireland" | country=="Italy" | country=="Latvia" | country=="Lithuania" | country=="Luxembourg" | country=="Malta" | country=="Netherlands" | country=="Poland" | country=="Portugal" | country=="Romania" | country=="Slovakia" | country=="Slovenia" | country=="Spain" | country=="Sweden" | country=="United Kingdom"
label variable EU28 "Dummy for EU-28 member countries (i.e. incl. UK)"
* 2b) OECD - done also in TJN portal
gen OECD=0
label variable OECD "Dummy for OECD member countries"
replace OECD=1 if EU28==1 | country=="Australia" | country=="Canada" | country=="Chile" | country=="Israel" | country=="Japan" | country=="South Korea" | country=="Mexico"  | country=="New Zealand"  | country=="Norway"  | country=="Switzerland"  | country=="Turkey" | country=="United States"  | country=="Iceland"
replace OECD=0 if country=="Bulgaria" | country=="Croatia" | country=="Cyprus" | country=="Malta" | country=="Romania"
* 2c) British Overseas Territories. Source: https://ec.europa.eu/europeaid/regions/overseas-countries-and-territories-octs/oct-eu-association_en
gen GBR_OT=0
label variable GBR_OT "Dummy for British overseas territories"
replace GBR_OT=1 if country=="Anguilla" | country=="Bermuda" | country=="British Virgin Islands" | country=="Cayman Islands" | country=="Falkland Islands" | country=="Gibraltar" | country=="Montserrat" | country=="Pitcairn Islands" | country=="St. Helena" | country=="South Georgia and the South Sandwich Islands" | country=="Turks and Caicos Islands" | country=="Akrotiri and Dhekelia" | country=="British Antarctic Territory" | country=="British Indian Ocean Territory"
* 2d) British Crown Dependencies. Source: https://ec.europa.eu/europeaid/regions/overseas-countries-and-territories-octs/oct-eu-association_en
gen GBR_CD=0
label variable GBR_CD "Dummy for British crown dependencies"
replace GBR_CD=1 if country=="Jersey" | country=="Isle of Man" | country=="Guernsey"
* 2e) British Overseas Countries and Territories (2c+2d)
gen GBR_OCT=0
label variable GBR_OCT "Dummy for all British overseas countries and territories (CD+OT)"
replace GBR_OCT=1 if GBR_OT==1 | GBR_CD==1
* 2f) Dutch Overseas Countries and Territories. Source: https://ec.europa.eu/europeaid/regions/overseas-countries-and-territories-octs/oct-eu-association_en
gen NLD_OCT=0
label variable NLD_OCT "Dummy for Dutch overseas countries and territories"
replace NLD_OCT=1 if country=="Aruba" | country=="Curacao" | country=="Sint Maarten" | country=="Netherlands Antilles" | country=="Bonaire, Sint Eustatius and Saba"
* 2g) French overseas territories. Source: https://ec.europa.eu/europeaid/regions/overseas-countries-and-territories-octs/oct-eu-association_en
gen FRA_OCT=0
label variable FRA_OCT "Dummy for French overseas countries and territories"
replace FRA_OCT=1 if country=="French Polynesia" | country=="New Caledonia" | country=="St. Pierre and Miquelon" | country=="Wallis and Futuna" | country=="St. Barthelemy" | country=="St. Martin"
* 2g) Danish overseas territories. Source: https://ec.europa.eu/europeaid/regions/overseas-countries-and-territories-octs/oct-eu-association_en
gen DNK_OCT=0
label variable DNK_OCT "Dummy for Danish overseas countries and territories"
replace DNK_OCT=1 if country=="Greenland" | country=="Faroe Islands"
* 2i) EU-28 Overseas Countries and Territories (2e+2f+2g+2h)
gen EU28_OCT=0
label variable EU28_OCT "Dummy for EU-28 overseas countries and territories"
replace EU28_OCT=1 if GBR_OCT==1 | NLD_OCT==1 | FRA_OCT==1 | DNK_OCT==1
* 2i) EU-27 Overseas Countries and Territories (2f+2g+2h)
gen EU27_OCT=0
label variable EU27_OCT "Dummy for EU-27 overseas countries and territories"
replace EU27_OCT=1 if NLD_OCT==1 | FRA_OCT==1 | DNK_OCT==1
* 2j) USA_OCT
gen USA_OCT=0
label variable USA_OCT "Dummy for USA's overseas countries and territories"
replace USA_OCT=1 if country=="American Samoa" | country=="Guam" | country=="Northern Mariana Islands" | country=="Puerto Rico" | country=="US Virgin Islands"
* 2k) OECD Overseas Countries and Territories (2i + 2j)
gen OECD_OCT=0
label variable OECD_OCT "Dummy for OECD overseas countries and territories"
replace OECD_OCT=1 if EU28_OCT==1 | USA_OCT==1
* 2l) OPEC
gen OPEC=0
label variable OPEC "Dummy for OPEC member countries"
replace OPEC=1 if country=="Algeria" | country=="Angola" | country=="Ecuador" | country=="Equatorial Guinea" | country=="Gabon" | country=="Iran" | country=="Iraq" | country=="Kuwait" | country=="Libya" | country=="Nigeria" | country=="Congo, Rep. of" | country=="Saudi Arabia" | country=="United Arab Emirates" | country=="Venezuela" 
* 2m) EFTA
gen EFTA=0
label variable EFTA "Dummy for EFTA member countries"
replace EFTA=1 if country=="Iceland" | country=="Liechtenstein" | country=="Norway" | country=="Switzerland"
* 2n) CARICOM member countries
gen CARICOM=0
label variable CARICOM "Dummy for CARICOM member countries"
replace CARICOM=1 if country=="Antigua and Barbuda" | country=="Bahamas" | country=="Barbados" | country=="Belize" | country=="Dominica" | country=="Grenada" | country=="Guiana" | country=="Haiti" | country=="Jamaica" | country=="Montserrat" | country=="St. Lucia" | country=="St. Kitts and Nevis" | country=="St. Vincent and the Grenadines" | country=="Suriname" | country=="Trinidad and Tobago"
* 2o) CARICOM associate members
gen CARICOM_ASS=0
label variable CARICOM_ASS "Dummy for CARICOM associate members"
replace CARICOM_ASS=1 if country=="Anguilla" | country=="Bermuda" | country=="British Virgin Islands" | country=="Cayman Islands" | country=="Turks and Caicos Islands"
save "$Data/IO/International organizations to merge.dta", replace
}
** 3) Tax haven lists
{
* 3a) Tax havens dummies based on various sources, comes from Petr's Master file - prepared outside this DO file
use "$Data/THlists/taxHavens_Petr.dta", clear
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x
save "$Data/taxHavens_Petr.dta", replace
use "$CYB/countryYearBase v0.dta", clear
duplicates drop country, force
drop year
order country
joinby country using "$Data/taxHavens_Petr.dta", unmatched(master)
drop _merge
* 3b) Experts' consensus - sum of appearances on selected tax havens lists
gen thl_15= th_ibfd1977+ th_irish1982+th_hines1994+ th_hines2010+ th_imf2000+ th_oecd2000+ th_fsf2000+ th_fatf2002+ th_tjn2005+ th_imf2007+ th_lowtaxnet2008+ th_levin2007+ th_zucman2013+ th_gravelle2015+ th_unctad2015
label variable thl_15 "Sum of 15 important tax haven dummies."
gen thl_11= th_ibfd1977+ th_irish1982+th_hines1994+ th_hines2010+ th_imf2000+ th_oecd2000+ th_fsf2000+ th_fatf2002+ th_tjn2005+ th_imf2007+th_levin2007
label variable thl_11 "Sum of 11 important tax haven dummies."
* 3c) th_eu_blacklist_150618 - EU's tax haven blacklist published on 18 June 2015. This list includes all jurisdictions with at least 10 mentions on the individual member states' lists. Source: https://www.eubusiness.com/news-eu/economy-politics.120n
gen th_eu_blacklist_150618=0
label variable th_eu_blacklist_150618 "EU th blacklist, 150618."
replace th_eu_blacklist_150618=1 if country=="Andorra" | country=="Liechtenstein" | country=="Guernsey" | country=="Monaco" | country=="Mauritius" | country=="Liberia"
replace th_eu_blacklist_150618=1 if country=="Seychelles" | country=="Brunei" | country=="Hong Kong" | country=="Maldives" | country=="Cook Islands" | country=="Nauru"
replace th_eu_blacklist_150618=1 if country=="Niue" | country=="Marshall Islands" | country=="Vanuatu" | country=="Anguilla" | country=="Antigua and Barbuda" | country=="Bahamas"
replace th_eu_blacklist_150618=1 if country=="Barbados" | country=="Belize" | country=="Bermuda" | country=="British Virgin Islands" | country=="Cayman Islands" | country=="Turks and Caicos Islands"
replace th_eu_blacklist_150618=1 if country=="Grenada" | country=="Montserrat" | country=="Panama" | country=="St. Vincent and the Grenadines" | country=="St. Kitts and Nevis" | country=="US Virgin Islands"
* 3d) th_eu_blacklist - EU's tax haven blacklist published originally on 5 December 2017, then amended many times. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_25_05_2018_en.pdf Countries were blacklisted if they were deemed to have failed to meet international standards on tax transparency and tax rates, and had not provided sufficient commitments that they would change in the months leading up to the list's publication.
foreach date in 171205 180123 180313 180525 181002 181106 181204 190312 190522 190621 191017 191114 200218 201006 {
gen th_eu_blacklist_`date'=0
label variable th_eu_blacklist_`date' "EU th blacklist, `date'."
}
*171205 - 17 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_171205=1 if country=="American Samoa" | country=="Bahrain" | country=="Barbados" | country=="Grenada" | country=="Guam" | country=="South Korea" | country=="Macao" | country=="Marshall Islands" | country=="Mongolia" | country=="Namibia" | country=="Palau" | country=="Panama" | country=="St. Lucia" | country=="Samoa" | country=="Trinidad and Tobago" | country=="Tunisia" | country=="United Arab Emirates"
*180123 - 9 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_180123=th_eu_blacklist_171205
replace th_eu_blacklist_180123=0 if country=="Barbados" | country=="Grenada" | country=="South Korea" | country=="Macao" | country=="Mongolia" | country=="Panama" | country=="Tunisia" | country=="United Arab Emirates"
*180313 - 9 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_blacklist_180313=th_eu_blacklist_180123
replace th_eu_blacklist_180313=0 if country=="Bahrain" | country=="Marshall Islands" | country=="St. Lucia"
replace th_eu_blacklist_180313=1 if country=="Bahamas" | country=="St. Kitts and Nevis" | country=="US Virgin Islands"
*180525 - 7 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_blacklist_180525=th_eu_blacklist_180313
replace th_eu_blacklist_180525=0 if country=="Bahamas" | country=="St. Kitts and Nevis"
*181002 - 6 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_181002=th_eu_blacklist_180525
replace th_eu_blacklist_181002=0 if country=="Palau"
*181106 - 5 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_181106=th_eu_blacklist_181002
replace th_eu_blacklist_181106=0 if country=="Namibia"
*181204 - 5 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_181204=th_eu_blacklist_181106
*190312 - 15 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_blacklist_190312=1 if country=="American Samoa" | country=="Aruba" | country=="Barbados" | country=="Bermuda" | country=="Belize" | country=="Dominica" | country=="Fiji" | country=="Guam" | country=="Marshall Islands" | country=="Oman" | country=="Samoa" | country=="Trinidad and Tobago" | country=="United Arab Emirates" | country=="US Virgin Islands" | country=="Vanuatu"
*190522 - 12 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.176.01.0002.01.ENG&toc=OJ:C:2019:176:TOC
replace th_eu_blacklist_190522=th_eu_blacklist_190312
replace th_eu_blacklist_190522=0 if country=="Aruba" | country=="Barbados" | country=="Bermuda"
*190621 - 11 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.210.01.0008.01.ENG&toc=OJ:C:2019:210:TOC
replace th_eu_blacklist_190621=th_eu_blacklist_190522
replace th_eu_blacklist_190621=0 if country=="Dominica"
*191017 - 9 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.351.01.0007.01.ENG&toc=OJ:C:2019:351:TOC
replace th_eu_blacklist_191017=th_eu_blacklist_190621
replace th_eu_blacklist_191017=0 if country=="Marshall Islands" | country=="United Arab Emirates"
*191114 - 8 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/en/TXT/?uri=uriserv:OJ.C_.2019.386.01.0002.01.ENG#ntr3-C_2019386EN.01000201-E0003
replace th_eu_blacklist_191114=th_eu_blacklist_191017
replace th_eu_blacklist_191114=0 if country=="Belize"
*200218 - 12 jurisdictions. Source: Internal contact at European Parliament - maybe will change 
replace th_eu_blacklist_200218=th_eu_blacklist_191114
replace th_eu_blacklist_200218=1 if country=="Palau" | country=="Seychelles" | country=="Panama" | country=="Cayman Islands"
*201006 - 12 jurisdictions. Source: Internal contact at European Parliament - maybe will change 
replace th_eu_blacklist_201006=0
replace th_eu_blacklist_201006=1 if country=="American Samoa" | country=="Anguilla" | country=="Barbados" | country=="Fiji" | country=="Guam" | country=="Palau" | country=="Panama" | country=="Samoa" | country=="Trinidad and Tobago" | country=="US Virgin Islands" | country=="Vanuatu" | country=="Seychelles"

* 3e) th_eu_greylist - EU's tax haven greylist published originally on 5 December 2017. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_25_05_2018_en.pdf
foreach date in 171205 180123 180313 180525 181002 181106 181204 190312 190522 190621 191017 191114 200218 201006 {
gen th_eu_greylist_`date'=0
label variable th_eu_greylist_`date' "EU th greylist, `date'."
}
*171205 - 47 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_greylist_171205=1 if country=="Albania" | country=="Andorra" | country=="Armenia" | country=="Aruba" | country=="Belize" | country=="Bermuda" | country=="Bosnia and Herzegovina" | country=="Botswana" | country=="Cape Verde" | country=="Cayman Islands" | country=="Cook Islands" | country=="Curacao" | country=="Faroe Islands" | country=="Fiji" | country=="Greenland" | country=="Guernsey" | country=="Hong Kong" | country=="Jamaica" | country=="Jersey" | country=="Jordan" | country=="Liechtenstein" | country=="North Macedonia" | country=="Malaysia" | country=="Maldives" | country=="Isle of Man" | country=="Labuan Island" | country=="Oman" | country=="Peru" | country=="Morocco" | country=="Mauritius" | country=="Montenegro" | country=="Nauru" | country=="Niue" | country=="New Caledonia"  | country=="Qatar" | country=="St. Vincent and the Grenadines" | country=="San Marino" | country=="Serbia" | country=="Seychelles" | country=="Switzerland" | country=="Vanuatu" | country=="Vietnam" | country=="Eswatini" | country=="Taiwan" | country=="Thailand" | country=="Turkey" | country=="Uruguay" 
*180123 - 55 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_greylist_180123=th_eu_greylist_171205
replace th_eu_greylist_180123=1 if country=="Barbados" | country=="Grenada" | country=="South Korea" | country=="Macao" | country=="Mongolia" | country=="Panama" | country=="Tunisia" | country=="United Arab Emirates"
*180313 - 62 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_greylist_180313=th_eu_greylist_180123
replace th_eu_greylist_180313=1 if country=="Bahrain" | country=="Marshall Islands" | country=="St. Lucia" | country=="Anguilla" | country=="Antigua and Barbuda" | country=="British Virgin Islands" | country=="Dominica"
*180525 - 65 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf 
replace th_eu_greylist_180525=th_eu_greylist_180313
replace th_eu_greylist_180525=1 if country=="Bahamas" | country=="St. Kitts and Nevis" | country=="Turks and Caicos Islands"
*181002 - 64 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_greylist_181002=th_eu_greylist_180525
replace th_eu_greylist_181002=1 if country=="Palau"
replace th_eu_greylist_181002=0 if country=="Liechtenstein" | country=="Peru"
*181106 - 65 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_greylist_181106=th_eu_greylist_181002
replace th_eu_greylist_181106=1 if country=="Namibia"
*181204 - 63 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_greylist_181204=th_eu_greylist_181106
replace th_eu_greylist_181204=0 if country=="Andorra" | country=="San Marino"
*190312 - 34 jurisdictions. Source: https://ec.europa.eu/taxation_customs/sites/taxation/files/eu_list_update_12_03_2019_en.pdf
replace th_eu_greylist_190312=1 if country=="Albania" | country=="Anguilla" | country=="Antigua and Barbuda" | country=="Armenia" | country=="Australia" | country=="Bahamas" | country=="Bosnia and Herzegovina" | country=="Botswana" | country=="British Virgin Islands" | country=="Cape Verde" | country=="Costa Rica" | country=="Curacao" | country=="Cayman Islands" | country=="Cook Islands" | country=="Eswatini" | country=="Jordan" | country=="Maldives" | country=="Mauritius" | country=="Morocco" | country=="Mongolia" | country=="Montenegro" | country=="Namibia" | country=="North Macedonia" | country=="Nauru" | country=="Niue" | country=="Palau" | country=="St. Kitts and Nevis" | country=="St. Lucia" | country=="Serbia" |  country=="Seychelles" | country=="Switzerland" | country=="Thailand" | country=="Turkey" | country=="Vietnam"
*190522 - 36 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.176.01.0002.01.ENG&toc=OJ:C:2019:176:TOC
replace th_eu_greylist_190522=th_eu_greylist_190312
replace th_eu_greylist_190522=1 if country=="Barbados" | country=="Bermuda"
*190621 - 36 jurisdictions (no change). Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.210.01.0008.01.ENG&toc=OJ:C:2019:210:TOC
replace th_eu_greylist_190621=th_eu_greylist_190522
*191017 - 33 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.351.01.0007.01.ENG&toc=OJ:C:2019:351:TOC
replace th_eu_greylist_191017=th_eu_greylist_190621
replace th_eu_greylist_191017=0 if country=="Costa Rica" | country=="Mauritius" | country=="Switzerland" | country=="Albania"
replace th_eu_greylist_191017=1 if country=="Marshall Islands"
*191114 - 33 jurisdictions. Source: https://eur-lex.europa.eu/legal-content/en/TXT/?uri=uriserv:OJ.C_.2019.386.01.0002.01.ENG#ntr3-C_2019386EN.01000201-E0003
replace th_eu_greylist_191114=th_eu_greylist_191017
replace th_eu_greylist_191114=0 if country=="North Macedonia"
replace th_eu_greylist_191114=1 if country=="Belize"
*200218 - 16 jurisdictions. Source: https://www.consilium.europa.eu/media/42596/st06129-en20.pdf
replace th_eu_greylist_200218=1 if country=="Turkey" | country=="Anguilla" | country=="Botswana" | country=="Bosnia and Herzegovina" | country=="Eswatini" | country=="Jordan" | country=="Maldives" | country=="Mongolia" | country=="Namibia" | country=="Thailand" | country=="St. Lucia" | country=="Australia" | country=="Morocco"
*201006 - 12 jurisdictions. Source: Internal contact at European Parliament - maybe will change 
replace th_eu_greylist_201006=0
replace th_eu_greylist_201006=1 if country=="Turkey" | country=="Anguilla" | country=="Botswana" | country=="Eswatini" | country=="Jordan" | country=="Maldives" | country=="Namibia" | country=="Thailand" | country=="St. Lucia" | country=="Australia" | country=="Morocco"
save "$Data/THlists/Tax haven lists to merge.dta", replace
}
** 4) World Bank
{
**4A - World Bank/Cross
{
* 4Aa) Region, downloaded on 20170611 from WB
{
use "$Data/World Bank/Cross/20170611 region_wb.dta", clear
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/World Bank/Cross/region_wb to merge.dta", replace
* 4Ab) Income (cross-section), downloaded on 20200210 from https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups
import excel "$Data\World Bank\Panel\20200210 income_wb.xlsx", sheet("income_wb") firstrow clear
run "$General/Harmonizing country names.do"
drop c_x
order country
rename income_wb* income_wb_*
foreach year of numlist 1987 1988 to 2018 {
replace income_wb_`year'="Low income" if income_wb_`year'=="L"
replace income_wb_`year'="Lower middle income" if income_wb_`year'=="LM"
replace income_wb_`year'="Upper middle income" if income_wb_`year'=="UM"
replace income_wb_`year'="High income" if income_wb_`year'=="H"
}
*Create income_wb_2015 dummy
joinby country using "$Data/IO/OECD 2015 help.dta", unmatched(both)
drop _merge
gen income_wb_LI_2015=0
replace income_wb_LI_2015=1 if income_wb_2015=="Low income"
label variable income_wb_LI_2015 "Low income dummy"
gen income_wb_LMI_2015=0
replace income_wb_LMI_2015=1 if income_wb_2015=="Lower middle income"
label variable income_wb_LMI_2015 "Lower middle income dummy"
gen income_wb_UMI_2015=0
replace income_wb_UMI_2015=1 if income_wb_2015=="Upper middle income"
label variable income_wb_UMI_2015 "Upper middle income dummy"
gen income_wb_HI_2015=0
replace income_wb_HI_2015=1 if income_wb_2015=="High income"
label variable income_wb_HI_2015 "High income dummy"
gen income_wb_HInOECD_2015=0
replace income_wb_HInOECD_2015=1 if income_wb_2015=="High income" & OECD==0 
label variable income_wb_HInOECD_2015 "High income: nonOECD dummy"
gen income_wb_HIOECD_2015=0
replace income_wb_HIOECD_2015=1 if income_wb_2015=="High income" & OECD==1
label variable income_wb_HIOECD_2015 "High income: OECD dummy"
save "$Data/World Bank/Cross/income_wb to merge.dta", replace
}
}
**4B - World Bank/Panel
{
* 4Ba) Variables downloaded via the wbopendata package - newly done all through TJN portal
{
global dateOfUpdate "210102"
*Download data
wbopendata, language(en - English) indicator(NY.GDP.MKTP.CD;BX.PEF.TOTL.CD.WD;BX.KLT.DINV.CD.WD;BN.KLT.DINV.CD;DT.DOD.DECT.CD; ///
	BN.CAB.XOKA.CD;FI.RES.XGLD.CD;NY.GDP.DEFL.ZS;NY.GNP.MKTP.CD; ///
	SH.XPD.PVTD.CH.ZS;SH.XPD.PVTD.PC.CD;SH.XPD.CHEX.PC.CD;SH.MED.BEDS.ZS;SH.MED.NUMW.P3;SH.DYN.MORT;SP.DYN.IMRT.IN;GC.XPN.TOTL.GD.ZS; ///
	SP.POP.TOTL;IC.BUS.NREG;NY.GDP.PCAP.CD;SE.XPD.TOTL.GD.ZS;DT.TDS.DECT.CD;SH.XPD.CHEX.GD.ZS; ///
	SI.POV.DDAY;SI.POV.LMIC;SI.POV.UMIC;SI.POV.NAHC;SI.POV.GAPS;SI.POV.LMIC.GP;SI.POV.UMIC.GP;SI.POV.GINI; ///
	SI.DST.FRST.20;SI.DST.02ND.20;SI.DST.03RD.20;SI.DST.04TH.20;SI.DST.05TH.20;SI.DST.FRST.10;SI.DST.10TH.10) long clear
*Rename the downloaded variables
rename ny_gdp_mktp_cd gdp_wb
label variable gdp_wb "GDP. Source: WB, $dateOfUpdate."
gen gdp_wb_src_link="https://data.worldbank.org/indicator/NY.GDP.MKTP.CD"
rename bx_pef_totl_cd_wd PEInflows
rename bx_klt_dinv_cd_wd FDI_Inflows_WDI
rename bn_klt_dinv_cd FDI_Net_WDI
rename dt_dod_dect_cd ExternalDebtStocks
rename bn_cab_xoka_cd CurrentAccountBalance
rename fi_res_xgld_cd TotalReserves
rename ny_gdp_defl_zs GDPDeflator
rename ny_gnp_mktp_cd GrossNationalIncome
rename sh_xpd_pvtd_ch_zs  
rename sh_xpd_pvtd_pc_cd  
rename sh_xpd_chex_pc_cd HealthExpPerCapita
rename sh_med_beds_zs HospitalBedsPerThousand
rename sh_med_numw_p3 NursesPerThousand
rename sh_dyn_mort Under5Mortality
rename sp_dyn_imrt_in InfantMortality
rename gc_xpn_totl_gd_zs govtExpenditure
rename sp_pop_totl population_wb
label variable population_wb "Population. Source: WB, $dateOfUpdate."
gen population_wb_src_link="https://data.worldbank.org/indicator/SP.POP.TOTL"
rename ic_bus_nreg nbr_wb
label variable nbr_wb "Number of new businesses registered. Source: WB, $dateOfUpdate."
rename ny_gdp_pcap_cd gdppc_wb
label variable gdppc_wb "GDP per capita (current US$). Source: WB, $dateOfUpdate."
gen gdppc_wb_src_link="https://data.worldbank.org/indicator/NY.GDP.PCAP.CD?view=chart"
rename se_xpd_totl_gd_zs gvt_exp_educ_wb
label variable gvt_exp_educ_wb "Government expenditure on education, total (% of GDP). Source: WB, $dateOfUpdate."
rename dt_tds_dect_cd debt_service_wb
label variable debt_service_wb "Debt service on external debt, total (TDS, current US$). Source: WB, $dateOfUpdate."
rename sh_xpd_chex_gd_zs health_exp_to_gdp_wb
label variable health_exp_to_gdp_wb "Current health expenditure (% of GDP). Source: WB, $dateOfUpdate."
*Poverty and inequality variables
rename si_pov_dday pov_hr_190_wb 
label variable pov_hr_190_wb "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population). Source: WB, $dateOfUpdate."
rename si_pov_lmic pov_hr_320_wb
label variable pov_hr_320_wb "Poverty headcount ratio at $3.20 a day (2011 PPP) (% of population). Source: WB, $dateOfUpdate."
rename si_pov_umic pov_hr_550_wb
label variable pov_hr_550_wb "Poverty headcount ratio at $5.50 a day (2011 PPP) (% of population). Source: WB, $dateOfUpdate."
rename si_pov_nahc pov_hr_npl_wb
label variable pov_hr_npl_wb "Poverty headcount ratio at national poverty lines (% of population). Source: WB, $dateOfUpdate."
rename si_pov_gaps pov_gap_190_wb
label variable pov_gap_190_wb "Poverty gap at $1.90 a day (2011 PPP) (%). Source: WB, $dateOfUpdate."
rename si_pov_lmic_gp pov_gap_320_wb
label variable pov_gap_320_wb "Poverty gap at $3.20 a day (2011 PPP) (%). Source: WB, $dateOfUpdate."
rename si_pov_umic_gp pov_gap_550_wb
label variable pov_gap_550_wb "Poverty gap at $5.50 a day (2011 PPP) (%). Source: WB, $dateOfUpdate."
rename si_pov_gini gini_wb
label variable gini_wb "Gini index (World Bank estimate). Source: WB, $dateOfUpdate."
rename si_dst_frst_20 incsh_first20_wb
label variable incsh_first20_wb	"Income share held by lowest 20%. Source: WB, $dateOfUpdate."
rename si_dst_02nd_20 incsh_second20_wb
label variable incsh_second20_wb "Income share held by second 20%. Source: WB, $dateOfUpdate."
rename si_dst_03rd_20 incsh_third20_wb
label variable incsh_third20_wb "Income share held by third 20%. Source: WB, $dateOfUpdate."
rename si_dst_04th_20 incsh_fourth20_wb
label variable incsh_fourth20_wb "Income share held by fourth 20%. Source: WB, $dateOfUpdate."
rename si_dst_05th_20 incsh_fifth20_wb
label variable incsh_fifth20_wb	"Income share held by highest 20%. Source: WB, $dateOfUpdate."
rename si_dst_frst_10 incsh_first10_wb
label variable incsh_first10_wb	"Income share held by lowest 10%. Source: WB, $dateOfUpdate."
rename si_dst_10th_10 incsh_tenth10_wb
label variable incsh_tenth10_wb "Income share held by highest 10%. Source: WB, $dateOfUpdate."
*Rename country variables
rename countrycode country_iso3
drop countryname
save "$Data/World Bank/Panel/WBpanel to merge.dta", replace

/* Had to remove this from the code above because it was moved by the WB to "international debt statistics"
*DT.IXF.DPPG.CD;DT.DFR.DPPG.CD;DT.TXR.DPPG.CD;DT.IXA.DPPG.CD.CG;DT.AXA.DPPG.CD;DT.DOD.DECT.CD  
*recast double dt_ixf_dppg_cd
*rename dt_ixf_dppg_cd InterestForgiven
*recast double dt_dfr_dppg_cd
*rename dt_dfr_dppg_cd DebtForgiveness
*recast double dt_txr_dppg_cd
*rename dt_txr_dppg_cd DebtRescheduled
*recast double dt_ixa_dppg_cd_cg
*rename dt_ixa_dppg_cd_cg NetChangeInterestArrears
*recast double dt_axa_dppg_cd
*rename dt_axa_dppg_cd PrincipalArrears
rename      external_debt_wb DT.DOD.DECT.CD
label variable external_debt_wb "External debt stocks, total (DOD, current USD). Source: WB, $dateOfUpdate."
*/
}
* 4Bb) Income group, source: WB, 20200210. Source: https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups
{
import excel "$Data\World Bank\Panel\20200210 income_wb.xlsx", sheet("income_wb") firstrow clear
reshape long income_wb, i(c_x) j(year)
run "$General/Harmonizing country names.do"
drop c_x
order country year income_wb
replace income_wb="Low income" if income_wb=="L"
replace income_wb="Lower middle income" if income_wb=="LM"
replace income_wb="Upper middle income" if income_wb=="UM"
replace income_wb="High income" if income_wb=="H"
label variable income_wb "Income group. Source: WB, 202002."
save "$Data/World Bank/Panel/income_wb to merge.dta", replace
}
* 4Bc) WGI, source: WB, 210102, downloaded from https://info.worldbank.org/governance/wgi/#home using the link "Download full dataset (Stata)"
{
global dateOfUpdate "210102"
use "$Data/World Bank/Panel/$dateOfUpdate wgi.dta", clear
rename countryname c_x
run "$General/Harmonizing country names.do"
drop code
keep country year *e
order country
rename vae WGI_1
label variable WGI_1 "Voice and Accountability. Source: WGI, $dateOfUpdate."
rename pve WGI_2
label variable WGI_2 "Pol. Stability No Violence. Source: WGI, $dateOfUpdate."
rename gee WGI_3
label variable WGI_3 "Govt Effectiveness. Source: WGI, $dateOfUpdate."
rename rqe WGI_4
label variable WGI_4 "Regulatory quality. Source: WGI, $dateOfUpdate."
rename rle WGI_5
label variable WGI_5 "Rule of Law. Source: WGI, $dateOfUpdate."
rename cce WGI_6
label variable WGI_6 "Control of corruption. Source: WGI, $dateOfUpdate."
save "$Data/World Bank/Panel/World Governance Indicators to merge.dta", replace
}
}
}
** 5) UN
{
* 5a) GDP, source: UN, 20200212, downloaded from https://unstats.un.org/unsd/snaama/Basic
import excel using "$Data/UN/20200212 gdp_un.xlsx", clear first
rename CountryArea c_x
replace c_x="Micronesia, region" if c_x=="Micronesia"
run "$General/Harmonizing country names.do"
drop c_x
order country
rename Year year
destring year, replace
drop Unit
rename GrossDomesticProductGDP gdp_un
drop if gdp_un=="..."
destring gdp_un, replace
label variable gdp_un "GDP. Source: UN, 202002."
gen gdp_un_src_link="https://unstats.un.org/unsd/snaama/Basic"
save "$Data/UN/gdp_un to merge.dta", replace

* 5b) Comtrade, 20191101, source: https://comtrade.un.org/data/. Select: (1) Type of product: Goods, Frequency: Annual; (2) HS: As reported; (3) Periods (year): All, Reporters: All, Partners: World, Trade flows: All, HS (as reported) commodity codes: TOTAL - Total of all HS commodities. (4) Download 
import delimited "$Data/UN/20191101 Comtrade exports of goods.csv", clear 
keep reporter year classification tradeflow tradevalueus
rename reporter c_x
run "$General/Harmonizing country names.do"
drop c_x
order country year classification tradeflow tradevalueus
sort country year
replace country="Cote d'Ivoire" if country=="CÃ´te d'Ivoire"
keep if tradeflow=="Export" /*Here I drop potentially useful data*/
drop tradeflow classification
rename tradevalueus expGoods_comtrade
save "$Data/UN/expGoods_comtrade to merge.dta", replace

* 5c) Income inequality - Palma ratios; HDI rank. Downloaded from http://hdr.undp.org/en/indicators/135206#
insheet using "$Data/UN/20200203 inc_ineq_palma_hdr_latest.csv", clear n
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/UN/inc_ineq_palma_hdr_latest to merge.dta", replace

* 5d) Population, 20200210. Source: https://data.un.org/Data.aspx?q=population&d=PopDiv&f=variableID%3a12
insheet using "$Data/UN/20200210 population_un.csv", clear n
rename countryorare c_x
rename years year
drop variant
rename value population_un
replace population_un=population_un*1000
replace c_x="Micronesia, region" if c_x=="Micronesia"
run "$General/Harmonizing country names.do"
drop c_x
order country
gen population_un_src_link="https://data.un.org/Data.aspx?q=population&d=PopDiv&f=variableID%3a12"
save "$Data/UN/population_un to merge.dta", replace

* 5e) GDP per capita, source: UN, 20200212, downloaded from https://unstats.un.org/unsd/snaama/Basic
import excel using "$Data/UN/20200212 gdppc_un.xlsx", clear first
rename CountryArea c_x
replace c_x="Micronesia, region" if c_x=="Micronesia"
run "$General/Harmonizing country names.do"
drop c_x
order country
rename Year year
destring year, replace
drop Unit
rename GrossDomesticProductGDP gdppc_un
drop if gdppc_un=="..."
destring gdppc_un, replace
label variable gdppc_un "GDP per capita. Source: UN, 202002."
gen gdppc_un_src_link="https://unstats.un.org/unsd/snaama/Basic"
save "$Data/UN/gdppc_un to merge.dta", replace

}
** 6) OECD
{
* 6a) Nominal corporate tax rates, 20190226, source: OECD Stat, https://stats.oecd.org/Index.aspx?DataSetCode=CTS_CIT#, 201902
insheet using "$Data/OECD/20190226 nctr_oecd.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
order country
replace nctr_cg_oecd=nctr_cg_oecd/100
label variable nctr_cg_oecd "Nominal corporate tax rate, central government. Source: OECD, 201902."
replace nctr_es_oecd=nctr_es_oecd/100
label variable nctr_es_oecd "Nominal corporate tax rate, exclusive of surtax. Source: OECD, 201902."
replace nctr_ldsnt_oecd=nctr_ldsnt_oecd/100
label variable nctr_ldsnt_oecd "Nominal corporate tax rate, less deductions for sub-national taxes. Source: OECD, 201902."
replace nctr_scg_oecd=nctr_scg_oecd/100
label variable nctr_scg_oecd "Nominal corporate tax rate, sub-central government. Source: OECD, 201902."
replace nctr_oecd=nctr_oecd/100
label variable nctr_oecd "Nominal corporate tax rate. Source: OECD, 201902."
save "$Data/OECD/nctr_oecd to merge.dta", replace
* 6b) Effective corporate tax rates, source: OECD Stat, https://stats.oecd.org/Index.aspx?DataSetCode=CTS_CIT#, 201902 
insheet using "$Data/OECD/20190227 ectr_oecd.csv", n clear
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/OECD/ectr_oecd to merge.dta", replace
* 6c) Transparency rating by OECD. Source: http://www.oecd.org/tax/transparency/documents/exchange-of-information-on-request-ratings.htm, then handled in excel
import excel "$Data/OECD/210211 trans_rating_oecd.xlsx", sheet("data-LGXCI") firstrow clear
rename year trans_rating_oecd_year
replace trans_rating_oecd_year="" if trans_rating_oecd_year=="n/a"
destring trans_rating_oecd_year, replace
drop if trans_rating_oecd=="Not yet reviewed"
bys country: egen max_trans_rating_oecd_year=max(trans_rating_oecd_year)
keep if trans_rating_oecd_year==max_trans_rating_oecd_year
save "$Data/OECD/trans_rating_oecd to merge.dta", replace
* 6d) OECD harmful regimes, source: https://www.oecd.org/tax/beps/harmful-tax-practices-peer-review-results-on-preferential-regimes.pdf Reference: OECD. (2020). Harmful Tax Practices – Peer Review Results. Update (as of November 2020). OECD. https://doi.org/10.1787/9789264311480-en
import excel "$Data/OECD/210216 harmful_regimes_oecd.xlsx", firstrow clear
save "$Data/OECD/harmful_regimes_oecd to merge.dta", replace
}
** 7) KPMG
{
* 7a) Nominal corporate tax rates, source: KPMG, 20190920, https://home.kpmg/vg/en/home/services/tax1/tax-tools-and-resources/tax-rates-online/corporate-tax-rates-table.html
insheet using "$Data/KPMG/20190920 nctr_kpmg.csv", clear
reshape long nctr_kpmg, i(c_x) j(year)
run "$General/Harmonizing country names.do"
drop c_x
order country
replace nctr_kpmg=nctr_kpmg/100
label variable nctr_kpmg "Nominal corporate tax rate. Source: KPMG, 201711."
save "$Data/KPMG/nctr_kpmg to merge.dta", replace
}
** 8) TradingEconomics.com
{
* 8a) Nominal corporate tax rates, 20190227, source: TradingEconomics.com
insheet using "$Data/TradingEconomics/20190227 nctr_tradingeconomics.csv", clear
reshape long nctr_tradingeconomics, i(c_x) j(year)
replace c_x="Congo, Dem. Rep. of" if c_x=="Congo"
run "$General/Harmonizing country names.do"
drop c_x
order country
replace nctr_tradingeconomics=nctr_tradingeconomics/100
label variable nctr_tradingeconomics "Nominal corporate tax rate. Source: Tradingeconomics, 201711."
save "$Data/TradingEconomics/nctr_tradingeconomics to merge.dta", replace
}
** 9) Tax Foundation
{
* 9a) Nominal corporate tax rates, 20190418, source: Tax Foundation, https://github.com/TaxFoundation/data/blob/master/OECD-corporate-income-tax-rates/OECD_corp_income_tax_rates_1981-2015.csv
insheet using "$Data/Tax Foundation/20190418 nctr_taxf.csv", clear
rename v1 c_x
run "$General/Harmonizing country names.do"
drop c_x
order country
reshape long nctr_taxf, i(country) j(year)
label variable nctr_taxf "Nominal corporate tax rate. Source: Tax Foundation, 201904."
save "$Data/Tax Foundation/nctr_taxf to merge.dta", replace
}
** 10) Centre for Business Taxation
{
* 10a) Nominal corporate tax rates, 20190424, source: Centre for Business Taxation Tax Database, only from wayback machine (not online anymore): http://web.archive.org/web/20180227043450/https://www.sbs.ox.ac.uk/faculty-research/tax/publications/data
insheet using "$Data/CBT/20190424 nctr_cbt.csv", clear
label variable nctr_cbt1 "Nominal corporate tax rate, variabel called corptax. Source: Centre for Business Taxation, 201904."
label variable nctr_cbt2 "Nominal corporate tax rate, variabel called statutory_corptax. Source: Centre for Business Taxation, 201904."
save "$Data/CBT/nctr_cbt to merge.dta", replace
* 10b) Effective average corporate tax rates, source: CBT Tax Database, only in wayback machine (not online anymore)
insheet using "$Data/CBT/20190424 ectr_cbt.csv", n clear
label variable eactr_cbt "Effective average corporate tax rate. Source: Centre for Business Taxation, 201904."
label variable emctr_cbt "Effective marginal corporate tax rate. Source: Centre for Business Taxation, 201904."
save "$Data/CBT/ectr_cbt to merge.dta", replace
}
** 11) TJN
{
**Data portal
{
*11h) TJN data portal
*Cross
import delimited "$TJNshared\Data\Final data\20210103_country-level-data.csv", delimiter(tab) varnames(2) rowrange(2) clear
rename iso3 country_iso3
drop country
drop if country_iso3==""
drop if country_iso3=="IND" & ps_torslov2020_2015>8000000000
save "$Data\TJN\country-level-data to merge.dta", replace
*Panel
import delimited "$TJNshared\Data\Final data\20210102_country-year-level-data.csv", delimiter(tab) varnames(2) rowrange(2) clear
rename iso3 country_iso3
drop if country_iso3==""
duplicates drop
save "$Data\TJN\country-year-level-data to merge.dta", replace
}
**FSI
{
* 11a) FSI 2009-2020
insheet using "$Data/TJN/FSI/fsi_2009.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
order country
drop if country==""
gen fsi_2009_total=sum(fsi_2009)
gen fsi_2009_share=fsi_2009/fsi_2009_total
rename fsi_2009_ki* fsi_2009_ss_ki*
foreach number of numlist 1 2 to 12 {
label variable fsi_2009_ss_ki`number' "KFSI-2009-`number'. Source: TJN (2009)."
}
label variable fsi_2009_opscore "FSI 2009 opacity score. Source: TJN (2009)."
label variable fsi_2009_gsw "FSI 2009 global scale weight. Source: TJN (2009)."
label variable fsi_2009_opcomp "FSI 2009 opacity component. Source: TJN (2009)."
label variable fsi_2009 "FSI 2009 value. Source: TJN (2009)."
label variable fsi_2009_rank "FSI 2009 rank." 
label variable fsi_2009_total "Sum of all FSI 2009 values."
label variable fsi_2009_share "Share of FSI 2009 value of total value of FSI 2009 values."
save "$Data/TJN/FSI/fsi_2009 to merge.dta", replace
*FSI 2011
insheet using "$Data/TJN/FSI/fsi_2011.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
order country
drop if country==""
gen fsi_2011_total=sum(fsi_2011)
gen fsi_2011_share=fsi_2011/fsi_2011_total
replace fsi_2011_ki11=1 if fsi_2011_ki11==100
replace fsi_2011_ki15=1 if fsi_2011_ki15==100
rename fsi_2011_ki* fsi_2011_ss_ki*
foreach number of numlist 1 2 to 15 {
label variable fsi_2011_ss_ki`number' "FSI 2011 secrecy score key indicator `number'. Source: TJN (2011)."
}
label variable fsi_2011_ss "FSI 2011 secrecy score. Source: TJN (2011)."
label variable fsi_2011_gsw "FSI 2011 global scale weight. Source: TJN (2011)."
label variable fsi_2011 "FSI 2011 value. Source: TJN (2011)."
label variable fsi_2011_rank "FSI 2011 rank." 
label variable fsi_2011_total "Sum of all FSI 2011 values."
label variable fsi_2011_share "Share of FSI 2011 value of total value of FSI 2011 values."
save "$Data/TJN/FSI/fsi_2011 to merge.dta", replace
*FSI 2013
insheet using "$Data/TJN/FSI/fsi_2013_including5JurisdisctionsFromPetr.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
order country
drop if country==""
replace fsi_2013_gsw=fsi_2013_gsw/100
gen fsi_2013_total=sum(fsi_2013)
gen fsi_2013_share=fsi_2013/fsi_2013_total
rename fsi_2013_ki* fsi_2013_ss_ki*
foreach number of numlist 1 2 to 15 {
label variable fsi_2013_ss_ki`number' "FSI 2013 secrecy score key indicator `number'. Source: TJN (2013)."
}
label variable fsi_2013_ss "FSI 2013 secrecy score. Source: TJN (2013)."
label variable fsi_2013_gsw "FSI 2013 global scale weight. Source: TJN (2013)."
label variable fsi_2013 "FSI 2013 value. Source: TJN (2013)."
label variable fsi_2013_rank "FSI 2013 rank." 
label variable fsi_2013_total "Sum of all FSI 2013 values."
label variable fsi_2013_share "Share of FSI 2013 value of total value of FSI 2013 values."
save "$Data/TJN/FSI/fsi_2013 to merge.dta", replace
*FSI 2015
insheet using "$Data/TJN/FSI/fsi_2015.csv", clear
run "$General/Harmonizing country names.do"
drop c_x
order country
drop if country==""
replace fsi_2015_gsw=fsi_2015_gsw/100
gen fsi_2015_total=sum(fsi_2015)
gen fsi_2015_share=fsi_2015/fsi_2015_total
rename fsi_2015_ki* fsi_2015_ss_ki*
foreach number of numlist 1 2 to 15 {
label variable fsi_2015_ss_ki`number' "FSI 2015 secrecy score key indicator `number'. Source: TJN (2015)."
}
label variable fsi_2015_ss "FSI 2015 secrecy score. Source: TJN (2015)."
label variable fsi_2015_gsw "FSI 2015 global scale weight. Source: TJN (2015)."
label variable fsi_2015 "FSI 2015 value. Source: TJN (2015)."
label variable fsi_2015_rank "FSI 2015 rank." 
label variable fsi_2015_total "Sum of all FSI 2015 values."
label variable fsi_2015_share "Share of FSI 2015 value of total value of FSI 2015 values."
save "$Data/TJN/FSI/fsi_2015 to merge.dta", replace
*FSI 2018
insheet using "$Data/TJN/FSI/fsi_2018.csv", clear
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x
order country
drop if country=="Curacao and St. Maarten"
gen fsi_2018_total=sum(fsi_2018)
foreach number of numlist 1 2 to 20 {
label variable fsi_2018_ss_ki`number' "FSI 2018 secrecy score key indicator `number'. Source: TJN (2018)."
}
label variable fsi_2018_ss "Secrecy score in FSI 2018"
label variable fsi_2018_gsw "FSI 2018 global scale weight. Source: TJN (2018)."
label variable fsi_2018 "FSI 2018"
label variable fsi_2018_rank "Rank in FSI 2018" 
label variable fsi_2018_total "Sum of all FSI 2018 values."
label variable fsi_2018_share "Share of FSI 2018 value of total value of FSI 2018 values."
save "$Data/TJN/FSI/fsi_2018 to merge.dta", replace
*FSI 2020
import excel using "$Data/TJN/FSI/fsi_2020.xlsx", clear first
run "$General/Harmonizing country names.do"
drop c_x
order country
gen fsi_2020_total=sum(fsi_2020)
foreach number of numlist 1 2 to 20 {
label variable fsi_2020_ss_ki`number' "FSI 2020 secrecy score key indicator `number'. Source: TJN (2020)."
}
label variable fsi_2020_ss "Secrecy score in FSI 2020"
label variable fsi_2020_gsw "FSI 2020 global scale weight. Source: TJN (2020)."
label variable fsi_2020 "FSI 2020"
label variable fsi_2020_rank "Rank in FSI 2020" 
label variable fsi_2020_total "Sum of all FSI 2020 values."
label variable fsi_2020_share "Share of FSI 2020 value of total value of FSI 2020 values."
save "$Data/TJN/FSI/fsi_2020 to merge.dta", replace
*Put all editions together
use "$CYB/countryYearBase v0.dta", clear
keep if year==2018
drop year
joinby country using "$Data/TJN/FSI/fsi_2009 to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/fsi_2011 to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/fsi_2013 to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/fsi_2015 to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/fsi_2018 to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/fsi_2020 to merge.dta", unmatched(master)
drop _merge
*Create included_in_fsi_X
gen included_in_fsi_2009=0
replace included_in_fsi_2009=1 if fsi_2009_opscore!=.
foreach year in 2011 2013 2015 2018 2020 {
gen included_in_fsi_`year'=0
replace included_in_fsi_`year'=1 if fsi_`year'_ss!=.
label variable included_in_fsi_`year' "Dummy for being included in FSI `year'"
}
label variable included_in_fsi_2009 "Dummy for being included in FSI 2009"
save "$Data/TJN/FSI/fsi2009-2020 to merge.dta", replace

* 11b) FSI data of panel nature
use "$Data/TJN/FSI/fsi_2009 to merge.dta", clear
rename fsi_2009 fsi
rename fsi_2009_* fsi_*
gen year=2009
order country year
save "$Data/TJN/FSI/fsi_2009panel.dta", replace
use "$Data/TJN/FSI/fsi_2011 to merge.dta"
rename fsi_2011* fsi*
gen year=2011
order country year
save "$Data/TJN/FSI/fsi_2011panel.dta", replace
use "$Data/TJN/FSI/fsi_2013 to merge.dta"
rename fsi_2013 fsi
rename fsi_2013_* fsi_*
gen year=2013
order country year
save "$Data/TJN/FSI/fsi_2013panel.dta", replace
use "$Data/TJN/FSI/fsi_2015 to merge.dta"
rename fsi_2015 fsi
rename fsi_2015_* fsi_*
gen year=2015
order country year
save "$Data/TJN/FSI/fsi_2015panel.dta", replace
use "$Data/TJN/FSI/fsi_2018 to merge.dta"
rename fsi_2018 fsi
rename fsi_2018_* fsi_*
gen year=2018
order country year
save "$Data/TJN/FSI/fsi_2018panel.dta", replace
use "$Data/TJN/FSI/fsi_2020 to merge.dta", clear
rename fsi_2020 fsi
rename fsi_2020_* fsi_*
gen year=2020
order country year
save "$Data/TJN/FSI/fsi_2020panel.dta", replace
append using "$Data/TJN/FSI/fsi_2009panel.dta"
append using "$Data/TJN/FSI/fsi_2011panel.dta"
append using "$Data/TJN/FSI/fsi_2013panel.dta"
append using "$Data/TJN/FSI/fsi_2015panel.dta"
append using "$Data/TJN/FSI/fsi_2018panel.dta"
sort year country
foreach number of numlist 1 2 to 20 {
label variable fsi_ss_ki`number' "KFSI `number'. Source: TJN."
}
label variable fsi_ss "FSI secrecy score. Source: TJN."
label variable fsi_gsw "FSI global scale weight. Source: TJN."
label variable fsi "FSI value. Source: TJN."
label variable fsi_rank "FSI rank in a given year." 
label variable fsi_total "Sum of all FSI values in a given year."
label variable fsi_share "Share of FSI value of total value of FSI values."
label variable fsi_opscore "FSI opacity score. Source: TJN."
label variable fsi_opcomp "FSI opacity component. Source: TJN."
save "$Data/TJN/FSI/fsi_panel to merge.dta", replace

* 11c) MFSI - FSI over time
use "$Data/TJN/FSI/190629 MFSI.dta", clear
duplicates drop
drop if country=="European Union"
drop if country=="Euro area"
drop if country=="Nauru, Republic of"
label variable fsi_2018_ss_mkig1 "Ownership registration (FSI 2018)"
label variable fsi_2018_ss_mkig2 "Legal Entity Transparency (FSI 2018)"
label variable fsi_2018_ss_mkig3 "Integrity of Tax and Financial Regulation (FSI 2018)" 
label variable fsi_2018_ss_mkig4 "International Standards and Cooperation (FSI 2018)"
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/TJN/FSI/MFSI to merge.dta", replace

* 11d) KFSI_2018_15_id172
import excel using "$Data/TJN/FSI/bearer_shares_fsi2018.xlsx", clear first
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/TJN/FSI/bearer_shares_fsi2018 to merge.dta", replace

* 11e) Matej Machil's adjusted SS for 2015 (based on his bachelor thesis) - TODO
import excel using "$Data/TJN/FSI/20200127 fsi_2015_adjMatej_ss_ki_complete.xlsx", clear first
run "$General/Harmonizing country names.do"
drop c_x
order country
}
**CTHI
{
* 11f) CTHI 2019
import excel "$Data/TJN/CTHI/CTHI 2019 Results.xlsx", sheet("CTHI results") firstrow clear
run "$General/Harmonizing country names.do"
drop c_x
order country
rename *cthi_19* *cthi_2019*
label variable cthi_2019_rank "Rank in CTHI 2019"
label variable cthi_2019 "CTHI 2019"
label variable cthi_2019_share "Share of CTHI 2019 on global sum"
label variable cthi_2019_hs "Haven Score in CTHI 2019"
label variable cthi_2019_gsw "Global Scale Weight in CTHI 2019"
label variable cthi_2019_tot_fdi_in_maxrepder "Sum of maximum of reported and derived inward FDI"
label variable cthi_2019_tot_fdi_out_maxrepder "Sum of maximum of reported and derived outward FDI"
label variable cthi_2019_fdi_avginout "Average of inward and outward FDI. Used for GSW in CTHI19."
label variable included_in_cthi_2019 "Dummy for CTHI19 jurisdictions"
label variable cthi_2019_hs_cat1 "LACIT (CTHI 2019)"
label variable cthi_2019_hs_cat2 "Loopholes and Gaps (CTHI 2019)" 
label variable cthi_2019_hs_cat3 "Transparency (CTHI 2019)" 
label variable cthi_2019_hs_cat4 "Anti-Avoidance (CTHI 2019)" 
label variable cthi_2019_hs_cat5 "Double Tax Treaties Aggressiveness (CTHI 2019)"
save "$Data/TJN/CTHI/CTHI 2019 to merge.dta", replace

* 11g) LACIT rate from CTHI 2019, downloaded on 190626 from: https://www.corporatetaxhavenindex.org/EXCEL/LACIT.xlsx
import excel "$Data/TJN/CTHI/190626 lacitr_cthi.xlsx", sheet("LACIT") firstrow clear
run "$General/Harmonizing country names.do"
drop c_x
order country
rename lacitr_cthi lacitr_cthi_2018
replace lacitr_cthi_2018=lacitr_cthi_2018/100
rename lacitr_cthi_2018 lacitr_final2018
foreach year of numlist 2009 2010 to 2017 {
gen lacitr_final`year'=lacitr_final2018
}
reshape long lacitr_final, i(country) j(year)
replace lacitr_final=0.19 if country=="Hungary" & year<2017 & year>2008
replace lacitr_final=0.3 if country=="Spain" & year<2015 & year>2008
replace lacitr_final=0.28 if country=="Spain" & year==2015
replace lacitr_final=0.17 if country=="Taiwan" & year<2018 & year>2008
replace lacitr_final=0.28 if country=="United Kingdom" & year==2010
replace lacitr_final=0.26 if country=="United Kingdom" & year==2011
replace lacitr_final=0.24 if country=="United Kingdom" & year==2012
replace lacitr_final=0.23 if country=="United Kingdom" & year==2013
replace lacitr_final=0.21 if country=="United Kingdom" & year==2014
replace lacitr_final=0.2 if country=="United Kingdom" & year==2015
replace lacitr_final=0.2 if country=="United Kingdom" & year==2016
replace lacitr_final=0.19 if country=="United Kingdom" & year==2017
replace lacitr_final=0.19 if country=="United Kingdom" & year==2018
replace lacitr_final=0.34467 if country=="United States" & year==2010
replace lacitr_final=0.34454 if country=="United States" & year==2011
replace lacitr_final=0.34395 if country=="United States" & year==2012
replace lacitr_final=0.34311 if country=="United States" & year==2013
replace lacitr_final=0.34337 if country=="United States" & year==2014
replace lacitr_final=0.34259 if country=="United States" & year==2015
replace lacitr_final=0.34185 if country=="United States" & year==2016
replace lacitr_final=0.34167 if country=="United States" & year==2017
replace lacitr_final=0.211 if country=="United States" & year==2018
save "$Data/TJN/CTHI/lacitr_final to merge.dta", replace
}

* 11h) CTHI 2021
import excel "$Data/TJN/CTHI/210217_file1_cthi_2021_analysis_HSfrom210211.xlsx", sheet("CTHI2021 full") firstrow clear
keep country_iso3 cthi_2021*
gen included_in_cthi_2021=0
replace included_in_cthi_2021=1 if cthi_2021!=.
label variable cthi_2021_rank "Rank in CTHI 2021"
label variable cthi_2021 "CTHI 2021"
label variable cthi_2021_share "Share of CTHI 2021 on global sum"
label variable cthi_2021_hs "Haven Score in CTHI 2021"
label variable cthi_2021_gsw "Global Scale Weight in CTHI 2021"
label variable included_in_cthi_2021 "Dummy for CTHI21 jurisdictions"
label variable cthi_2021_hs_cat1 "LACIT (CTHI 2021)"
label variable cthi_2021_hs_cat2 "Loopholes and Gaps (CTHI 2021)" 
label variable cthi_2021_hs_cat3 "Transparency (CTHI 2021)" 
label variable cthi_2021_hs_cat4 "Anti-Avoidance (CTHI 2021)" 
label variable cthi_2021_hs_cat5 "Double Tax Treaties Aggressiveness (CTHI 2021)"
save "$Data/TJN/CTHI/CTHI 2021 to merge.dta", replace

* 11i) SOTJ2020 results
import excel "C:\Users\miros\Desktop\Dropbox\Research\_General\Source data\TJN\SOTJ\20201118 combined_output.xlsx", sheet("Sheet1") firstrow clear
drop Year Country 
labvarch *, postfix(". Source: SOTJ 2020 (TJN).")
rename ISO3codeofcountry country_iso3
drop if country_iso3=="PSE" & LossOWUSDmillion==.
save  "$Data/TJN/SOTJ/sotj2020 to merge.dta", replace

}
** 12) UNCTAD
{
* 12a) FDI stocks - downloaded on 20190108 from http://unctadstat.unctad.org/wds/TableViewer/tableView.aspx?ReportId=96740. Relatively extensive edits are needed in the downloaded excel file. Merge countries that were discontinued, delete stars, dots and dashes. Maybe better next time to download the annex tables of the WIR from https://unctad.org/en/Pages/DIAE/World%20Investment%20Report/Annex-Tables.aspx
*Outward
insheet using "$Data/UNCTAD/20190108 UNCTAD FDI outward.csv", n clear
reshape long year, i(c_x) j(y)
rename year fdi_out_unctad
rename y year
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/UNCTAD/UNCTAD FDI outward.dta", replace
*Inward
insheet using "$Data/UNCTAD/20190108 UNCTAD FDI inward.csv", n clear
reshape long year, i(c_x) j(y)
rename year fdi_in_unctad
rename y year
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/UNCTAD/UNCTAD FDI inward.dta", replace
joinby country year using "$Data/UNCTAD/UNCTAD FDI outward.dta", unmatched(both)
drop _merge
replace fdi_in_unctad=fdi_in_unctad*1000000
replace fdi_out_unctad=fdi_out_unctad*1000000
label variable fdi_in_unctad "Inward FDI stock. Source: UNCTAD, 20190108."
label variable fdi_out_unctad "Outward FDI stock. Source: UNCTAD, 20190108."
save "$Data/UNCTAD/UNCTAD FDI to merge.dta", replace

** 12b) UNCTADStat trade in services
{
*Services (BPM6): Exports and imports of total services, value, shares, and growth, annual. Source: https://unctadstat.unctad.org/wds/TableViewer/tableView.aspx
*The file needs to be adjusted a little bit in excel: (i) delete first rows, (ii) rename variables, (iii) trim country names, (iv) replace "-" and "_" by nothing, (v) remove comments, (vi) merge Sudan, (vii) rename "Switzerland, Liechtenstein" to "Switzerland"
import excel using "$Data\UNCTAD\20200129 UNCTADStat exports of services complete.xlsx", clear first
run "$General/Harmonizing country names.do"
drop c_x
order country
reshape long expSer_unctad, i(country) j(year)
label variable expSer_unctad "Exports of services. Source: UNCTADStat, 20200129."
save "$Data\UNCTAD\expSer_unctad to merge.dta", replace
}
}
** 13) IMF
{
* 13a) CDIS, handled in the Bilateral countryYearBase and transformed here into country-year-level
use "$Data/IMF/CDIS/CDIS data v1.dta", clear
keep country counterpart_country year cdis17 cdis18 cdis37 cdis38
keep if counterpart_country=="World"
rename cdis17 fdi_in_der_imfcdis
rename cdis18 fdi_in_imfcdis
rename cdis37 fdi_out_der_imfcdis
rename cdis38 fdi_out_imfcdis
keep country year fdi_in_der_imfcdis fdi_in_imfcdis fdi_out_der_imfcdis fdi_out_imfcdis
label variable fdi_in_der_imfcdis "Inward FDI stock, derived. Source: IMF CDIS, 201214."
label variable fdi_in_imfcdis "Inward FDI stock. Source: IMF CDIS, 201214."
label variable fdi_out_der_imfcdis "Outward FDI stock, derived. Source: IMF CDIS, 201214."
label variable fdi_out_imfcdis "Outward FDI stock. Source: IMF CDIS, 201214."
label variable year ""
save "$Data/IMF/CDIS/IMF CDIS FDI to merge.dta", replace

* 13b) Balance of Payments 
**Data are downloaded on 20201130 in full from the IMF's website (http://data.imf.org/?sk=7A51304B-6426-40C0-83DD-CA473CA1FD52), using the panel option, all economies, yearly data.
insheet using "$Data/IMF/BoP/20201130 BoP complete.csv", clear
*Drop all variables whose label is "Status" or "Official BPM6" - we do not need these
ds
foreach var in `r(varlist)' {
    if substr("`:var l `var''",1,6)=="Status" | substr("`:var l `var''",1,13)=="Official BPM6" drop `var'
}
save "$Data/IMF/BoP/20201130 BoP complete.dta", replace

use "$Data/IMF/BoP/20201130 BoP complete.dta", clear
*Harmonize country names for merging
rename countryname c_x
rename timeperiod year
run "$General/Harmonizing country names.do"
order country
drop c_x
*Keep only those variables that are of interest. Note that USD data is superior to Euros and National Currencies in the IMF BoP data, and we thus use USD data.
keep country year v3850 v5581 v5590 v5599 v5608 v6004 v6013 assetstotalusdollarsia_bp6_usd assetsreserveassetsusdollarsiar_ assetsdirectinvestmentusdollarsi v1702 v1636 v1693	v1762	v1813	v1825	v1855	v1981	v2020	v2209	v2326	v2383	v2410	v2533	v2590	v2617	assetsotherinvestmentdebtinstrum	v2716	v2752	v2809	v2836	v2932	v2980	v3007

label variable v3850 "CA, GandS, S, FS, Credit, USD (BXSOFI_BP6_USD)" /*Current Account, Goods and Services, Services, Financial Services, Credit, US Dollars (BXSOFI_BP6_USD)*/
rename v3850 expFinSer_bop /*v3772 = exports of financial services*/
label variable v5581 "CA, PI, II, DI, Credit, USD (BXIPID_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Credit, US Dollars (BXIPID_BP6_USD)*/
rename v5581 out_fdiincome_bop /*v5503 = outward FDI income*/
label variable v5590 "CA, PI, II, DI, Debit, USD (BMIPID_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Debit, US Dollars (BMIPID_BP6_USD)*/
rename v5590 in_fdiincome_bop /*v5512 = inward FDI income*/
label variable v5599 "CA, PI, II, DI, IEIFS, Credit, USD (BXIPIDE_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Income on Equity and Investment Fund Shares, Credit, US Dollars (BXIPIDE_BP6_USD)*/
rename v5599 out_fdiincome_eq_bop /*v5521 = outward FDI equity income*/
label variable v5608 "CA, PI, II, DI, IEIFS, Debit, USD (BMIPIDE_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Income on Equity and Investment Fund Shares, Debit, US Dollars (BMIPIDE_BP6_USD)*/
rename v5608 in_fdiincome_eq_bop /*v5530 = inward FDI equity income*/
label variable v6004 "CA, PI, II, DI, Int, Credit, USD (BXIPIDI_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Interest, Credit, US Dollars (BXIPIDI_BP6_USD)*/
rename v6004 out_fdiincome_debt_bop /*v5926 = outward FDI debt income*/
label variable v6013 "CA, PI, II, DI, Int, Debit, USD (BMIPIDI_BP6_USD)" /*Current Account, Primary Income, Investment Income, Direct Investment, Interest, Debit, US Dollars (BMIPIDI_BP6_USD)*/
rename v6013 in_fdiincome_debt_bop /*v5935 = inward FDI debt income*/
label variable assetstotalusdollarsia_bp6_usd "Assets, Total, US Dollars (IA_BP6_USD). Source: IMF BoP, 201811." /*"Assets, Total, US Dollars (IA_BP6_USD)"*/
rename assetstotalusdollarsia_bp6_usd assets_bop /*assetstotalusdollarsia_bp6_usd = assets*/
label variable assetsreserveassetsusdollarsiar_ "Assets, Reserve Assets, US Dollars (IAR_BP6_USD)" /*"Assets, Reserve Assets, US Dollars (IAR_BP6_USD)"*/
label variable assetsdirectinvestmentusdollarsi "Assets, Direct Investment, US Dollars (IAD_BP6_USD)" /*"Assets, Direct Investment, US Dollars (IAD_BP6_USD)"*/
label variable v1702 "Assets, FDaESO, MA, USD (IADFMA_BP6_USD)" /*Assets, Financial Derivatives (Other Than Reserves) and Employee Stock Options, Monetary Authorities (Where Relevant), US Dollars (IADFMA_BP6_USD)*/
label variable v1636 "Assets, FDaESO, CB, USD (IADFCB_BP6_USD)" /*Assets, Financial Derivatives (Other Than Reserves) and Employee Stock Options, Central Bank, US Dollars (IADFCB_BP6_USD)*/
label variable v1693 "Assets, FDaESO, GG, USD (IADFG_BP6_USD)" /*Assets, Financial Derivatives (Other Than Reserves) and Employee Stock Options, General Government, US Dollars (IADFG_BP6_USD)*/
label variable v1762 "Assets, O I, CaD, CB, USD (IAOCDCB_BP6_USD)" /*Assets, Other Investment, Currency and Deposits, Central Bank, US Dollars (IAOCDCB_BP6_USD)*/
label variable v1813 "Assets, O I, CaD, GG, Long term, USD (IAOCDG_L_BP6_USD)" /*Assets, Other Investment, Currency and Deposits, General Government, Long-term, US Dollars (IAOCDG_L_BP6_USD)*/
label variable v1825 "Assets, O I, CaD, GG, Short term, USD (IAOCDG_S_BP6_USD)" /*Assets, Other Investment, Currency and Deposits, General Government, Short-term, US Dollars (IAOCDG_S_BP6_USD)*/
label variable v1855 "Assets, O I, CaD, MA, USD (IAOCDMA_BP6_USD)" /*Assets, Other Investment, Currency and Deposits, Monetary Authorities (Where Relevant), US Dollars (IAOCDMA_BP6_USD)*/
label variable v1981 "Assets, O I, L, CB, USD (IAOLNCB_BP6_USD)" /*Assets, Other Investment, Loans, Central Bank, US Dollars (IAOLNCB_BP6_USD)*/
label variable v2020 "Assets, O I, L, GG, USD (IAOLNG_BP6_USD)" /*Assets, Other Investment, Loans, General Government (Where Relevant), US Dollars (IAOLNG_BP6_USD)*/	
label variable v2209 "Assets, O I, L, MA, USD (IAOLNMA_BP6_USD)" /*Assets, Other Investment, Loans, Monetary Authorities (Where Relevant), US Dollars (IAOLNMA_BP6_USD)*/	
label variable v2326 "Assets, O I, OAR, CB, US Dollars (IAORCB_BP6_USD)" /*Assets, Other Investment, Other Accounts Receivable, Central Bank, US Dollars (IAORCB_BP6_USD)*/	
label variable v2383 "Assets, O I, OAR, GG, USD (IAORG_BP6_USD)" /*Assets, Other Investment, Other Accounts Receivable, General Government, US Dollars (IAORG_BP6_USD)*/	
label variable v2410 "Assets, O I, OAR, MA, USD (IAORMA_BP6_USD)" /*Assets, Other Investment, Other Accounts Receivable, Monetary Authorities (Where Relevant), US Dollars (IAORMA_BP6_USD)*/	
label variable v2533 "Assets, O I, TCA, CB, US Dollars (IAOTCB_BP6_USD)" /*Assets, Other Investment, Trade Credit and Advances, Central Bank, US Dollars (IAOTCB_BP6_USD)*/	
label variable v2590 "Assets, O I, TCA, GG, USD (IAOTG_BP6_USD)" /*Assets, Other Investment, Trade Credit and Advances, General Government, US Dollars (IAOTG_BP6_USD)*/
label variable v2617 "Assets, O I, TCA, MA, USD (IAOTMA_BP6_USD)" /*Assets, Other Investment, Trade Credit and Advances, Monetary Authorities (Where Relevant), US Dollars (IAOTMA_BP6_USD)*/	
label variable assetsotherinvestmentdebtinstrum "Assets, O I: DI, CB, US Dollars (IAODCB_BP6_USD)" /*Assets, Other Investment: Debt Instruments, Central Bank, US Dollars (IAODCB_BP6_USD)*/	
label variable v2716 "Assets, O I: DI, GG, USD (IAODG_BP6_USD)" /*Assets, Other Investment: Debt Instruments, General Government, US Dollars (IAODG_BP6_USD)*/	
label variable v2752 "Assets, P I, DS, CB, US Dollars (IAPDCB_BP6_USD)" /*Assets, Portfolio Investment, Debt Securities, Central Bank, US Dollars (IAPDCB_BP6_USD)*/	
label variable v2809 "Assets, P I, DS, GG, USD (IAPDG_BP6_USD)" /*Assets, Portfolio Investment, Debt Securities, General Government, US Dollars (IAPDG_BP6_USD)*/	
label variable v2836 "Assets, P I, DS, MA, USD (IAPDMA_BP6_USD)" /*Assets, Portfolio Investment, Debt Securities, Monetary Authorities (Where Relevant), US Dollars (IAPDMA_BP6_USD)*/	
label variable v2932 "Assets, P I, EIFS, CB, USD (IAPECB_BP6_USD)" /*Assets, Portfolio Investment, Equity and Investment Fund Shares, Central Bank, US Dollars (IAPECB_BP6_USD)*/	
label variable v2980 "Assets, P I, EIFS, GG, USD (IAPEG_BP6_USD)" /*Assets, Portfolio Investment, Equity and Investment Fund Shares, General Government, US Dollars (IAPEG_BP6_USD)*/	
label variable v3007 "Assets, P I, EIFS, MA, USD (IAPEMA_BP6_USD)" /*Assets, Portfolio Investment, Equity and Investment Fund Shares, Monetary Authorities (Where Relevant), US Dollars (IAPEMA_BP6_USD)*/	
**Filtering following Zoromé (2007): "..filtered IIP assets are total IIP assets excluding foreign direct investment, reserve assets, and all assets belonging to general government and monetary authorities."
*Input zero where missing
foreach var in assetsreserveassetsusdollarsiar_ assetsdirectinvestmentusdollarsi v1636 v1693 v1702 v1762 v1813 v1825 v1855 v1981 v2020 v2209 v2326 v2383 v2410 v2533 v2590 v2617 v2716 v2752 v2809 v2836 v2932 v2980 v3007 assetsotherinvestmentdebtinstrum {
replace `var'=0 if `var'==.
}
gen assets_filtered_bop=assets_bop-assetsreserveassetsusdollarsiar_-assetsdirectinvestmentusdollarsi-v1636-v1693-v1702-v1762-v1813-v1825-v1855-v1981-v2020-v2209-v2326-v2383-v2410-v2533-v2590-v2617-v2716-v2752-v2809-v2836-v2932-v2980-v3007-assetsotherinvestmentdebtinstrum
label variable assets_filtered_bop "Assets, filtered (Zoromé 2007). Source: IMF BoP, 201911."
*Replace Assets_bop by 0 if it is negative, as 0 is the assumed minimum value
replace assets_filtered_bop=0 if assets_filtered_bop<0
keep country year assets_bop assets_filtered_bop expFinSer_bop out_fdiincome_bop in_fdiincome_bop out_fdiincome_eq_bop in_fdiincome_eq_bop out_fdiincome_debt_bop in_fdiincome_debt_bop
order country year assets_bop assets_filtered_bop expFinSer_bop out_fdiincome_bop in_fdiincome_bop out_fdiincome_eq_bop in_fdiincome_eq_bop out_fdiincome_debt_bop in_fdiincome_debt_bop
label variable year ""
save "$Data/IMF/BoP/IMF BoP to merge.dta", replace

* 13c) GFS, 20201005, downloaded from IMF website using the Bulk download option, Panel data, all countries & indicators & years
insheet using "$Data/IMF/GFS/20201005 IMF GFS.csv", clear
keep if unitname=="Percent of GDP"
keep if sectorname=="General government" | sectorname=="Central government (excl. social security funds)"
keep countryname countrycode sectorname timeperiod revenueg1_z taxrevenueg11_z expenseg2_z expenditureg2m_z



****CONTINUE HERE




if classificationname=="Tax revenue" | classificationname=="Revenue" | classificationname=="Taxes on income, profits, & capital gains: corporations"
 & unitname=="Percent of GDP" & attribute=="Value"
rename v54 year
keep countryname classificationname year
drop if year==""
destring year, replace
replace classificationname="tottax_imfgfs" if classificationname=="Tax revenue"
replace classificationname="totrev_imfgfs" if classificationname=="Revenue"
replace classificationname="corp_imfgfs" if classificationname=="Taxes on income, profits, & capital gains: corporations"
reshape wide year, i(countryname) j(classificationname) s
rename year* *
gen year=2016
rename countryname c_x
run "$General/Harmonizing country names.do"
drop c_x
order country year
label variable corp_imfgfs "Corporate tax revenue as a share of GDP. Source: IMF GFS, 201807."
label variable totrev_imfgfs "Total revenue as a share of GDP. Source: IMF GFS, 201807."
label variable tottax_imfgfs "Total tax revenue as a share of GDP. Source: IMF GFS, 201807."
save "$Data/IMF/GFS/IMF GFS to merge.dta", replace

* 13d) CPIS, 20201119, source: http://data.imf.org/CPIS, handled in Bilateral countryYearBase
use "$Data/IMF/CPIS/20201119 CPIS.dta", clear
bys year country: egen tot_y_cpis_assets=sum(cpis_assets)
bys year country: egen tot_y_cpis_liabilities=sum(cpis_liabilities)
bys year country: egen tot_y_cpis_liabilities_derived=sum(cpis_liabilities_derived)
duplicates drop country year, force
drop counterpart_country cpis_liabilities_derived cpis_assets cpis_liabilities
rename tot_y_cpis_assets cpis_assets 
label variable cpis_assets "Assets abroad, reported, USD. Source: IMFCPIS, 201909."
rename tot_y_cpis_liabilities cpis_liabilities 
label variable cpis_liabilities "Liabilities abroad, reported, USD. Source: IMFCPIS, 201909."
rename tot_y_cpis_liabilities_derived cpis_liabilities_derived 
label variable cpis_liabilities_derived "Liabilities abroad, derived, USD. Source: IMFCPIS, 201909."
label variable year ""
save "$Data/IMF/CPIS/CPIS unilateral to merge.dta", replace
}
** 14) UNU-WIDER
{
* 14a) GRD - 20180920, source: https://www.wider.unu.edu/project/government-revenue-dataset
use "$Data/UNU-WIDER/20191208 GRD.dta", clear
*Harmonize country names for merging 
rename country c_x
run "$General/Harmonizing country names.do"
drop c_x iso identifier id
order country year
*Adding labels
foreach var of varlist _all {
label variable `var' "`var'; source: GRD, 20191208."
}
label variable country ""
label variable year ""
label variable tax_corp "Corporate tax revenue / GDP (%)"
save "$Data/UNU-WIDER/GRD to merge.dta", replace
}
** 15) WTO
{
* 15a) Exports of financial services, 20190409, source: https://data.wto.org/
import excel "$Data/WTO/20190409 expFinSer_wto.xlsx", sheet("Report") firstrow clear
*Adjust for merging
rename ReportingEconomy c_x
run "$General/Harmonizing country names.do"
order country
keep if PartnerEconomy=="World"
drop c_x ProductSector PartnerEconomy
reshape long expFinSer_wto, i(country) j(year)
save "$Data/WTO/expFinSer_wto to merge.dta", replace

* 15b) Imports of financial services, 20190409, source: https://data.wto.org/
import excel "$Data/WTO/20190409 impFinSer_wto.xlsx", sheet("Report") firstrow clear
*Adjust for merging
rename ReportingEconomy c_x
run "$General/Harmonizing country names.do"
order country
keep if PartnerEconomy=="World"
drop c_x ProductSector PartnerEconomy
reshape long impFinSer_wto, i(country) j(year)
save "$Data/WTO/impFinSer_wto to merge.dta", replace
}
** 16) BIS
{
* 16a) BIS LBS, handled in the Bilateral countryYearBase and transformed here into country-year-level
use "$Data/BIS/Bilateral BIS for merge.dta", clear
bys counterpart_country year: egen tot_in_claims_bis_all_nbanks=sum(claims_bis_all_nbanks)
duplicates drop counterpart_country year, force
keep counterpart_country year tot_in_claims_bis_all_nbanks
rename counterpart_country country
save "$Data/BIS/Unilateral BIS in to merge.dta", replace
}
** 17) Papers
{
* 18a) Alm and Embaye (2013)
use "$Data/Papers/alm2013/alm2013.dta", clear
label variable shadow_alm2013 "Shadow economy size estimate (% of GDP). Source: Alm and Embaye (2013)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country year using "$CYB/countryYearBase v0.dta", unmatched(master)
rename country_iso3 iso3
drop _merge c_x country country_iso2
order iso3 year
save "$Data/Papers/_to merge panel uni/alm2013 to merge.dta", replace

* 18b) Elgin and Oztunali (2013)
use "$Data/Papers/elgin2013/elgin2013.dta", clear
label variable shadow_elgin2013 "Shadow economy size estimate (% of GDP). Source: Elgin and Oztunali (2013)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country year using "$CYB/countryYearBase v0.dta", unmatched(master)
rename country_iso3 iso3
drop _merge c_x country country_iso2
order iso3 year
save "$Data/Papers/_to merge panel uni/elgin2013 to merge.dta", replace

* 18c) Schneider (2013)
use "$Data/Papers/schneider2013/schneider2013.dta", clear
label variable shadow_schneider2013 "Shadow economy size estimate. Source: Schneider (2013)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country year using "$CYB/countryYearBase v0.dta", unmatched(master)
rename country_iso3 iso3
drop _merge c_x country country_iso2
order iso3 year
save "$Data/Papers/_to merge panel uni/schneider2013 to merge.dta", replace

* 18d) La Porta, Lopez-de-Silanes, Shleifer & Vishny 1998'JPE, available at https://www.journals.uchicago.edu/doi/pdfplus/10.1086/250042, Legal origin, downloaded 20190625 
import excel "$Data/Papers/laporta1998/20190625 legal_origin_llsv.xlsx", firstrow clear
label variable legal_origin "Legal origin. Source: LaPorta, Lopez, Shleifer and Vishny (1998'JPE)"
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
save "$Data/Papers/_to merge cross uni/laporta1998 to merge.dta", replace

* 18e) Murphy, Seabrook & Stausholm (2019), available at: https://zenodo.org/record/2580527#.XH766ChKjCd, received from Saila, handled on 20190111 - Big4 and McKinsey from 
insheet using "$Data/Papers/murphy2019/20190111 Big Four data from Saila.csv", n clear
gen year=2018
label variable kpmg_offices "Number of KPMG offices. Source: Murphy, Seabrook & Stausholm (2019)."
label variable kpmg_partners "Number of KPMG partners. Source: Murphy, Seabrook & Stausholm (2019)."
label variable kpmg_staff "Number of KPMG staff. Source: Murphy, Seabrook & Stausholm (2019)."
label variable kpmg_source "Source for data on KPMG. Source: Murphy, Seabrook & Stausholm (2019)."
label variable ey_offices "Number of EY offices. Source: Murphy, Seabrook & Stausholm (2019)."
label variable ey_partners "Number of EY partners. Source: Murphy, Seabrook & Stausholm (2019)."
label variable ey_staff "Number of EY staff. Source: Murphy, Seabrook & Stausholm (2019)."
label variable ey_source "Source for data on EY. Source: Murphy, Seabrook & Stausholm (2019)."
label variable deloitte_offices "Number of Deloitte offices. Source: Murphy, Seabrook & Stausholm (2019)."
label variable deloitte_partners "Number of Deloitte partners. Source: Murphy, Seabrook & Stausholm (2019)."
label variable deloitte_staff "Number of Deloitte staff. Source: Murphy, Seabrook & Stausholm (2019)."
label variable deloitte_source "Source for data on Deloitte. Source: Murphy, Seabrook & Stausholm (2019)."
label variable pwc_offices "Number of PWC offices. Source: Murphy, Seabrook & Stausholm (2019)."
label variable pwc_partners "Number of PWC partners. Source: Murphy, Seabrook & Stausholm (2019)."
label variable pwc_staff "Number of PWC staff. Source: Murphy, Seabrook & Stausholm (2019)."
label variable pwc_source "Source for data on PWC. Source: Murphy, Seabrook & Stausholm (2019)."
label variable big4_offices "Number of Big4 offices. Source: Murphy, Seabrook & Stausholm (2019)."
label variable big4_present "Dummy for Big4 presence. Source: Murphy, Seabrook & Stausholm (2019)."
label variable mckinsey_present "Dummy for McKinsey presence. Source: Murphy, Seabrook & Stausholm (2019)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country year using "$CYB/countryYearBase v0.dta", unmatched(master)
rename country_iso3 iso3
drop _merge c_x country country_iso2
order iso3 year
drop if iso3==""
*Panel
save "$Data/Papers/_to merge panel uni/murphy2019 to merge.dta", replace
*Cross
rename * *_2018
rename iso3_2018 iso3
drop year
save "$Data/Papers/_to merge cross uni/murphy2019 to merge.dta", replace

* 18f) Harari, Meinzer & Murphy (2012), available at https://www.taxjustice.net/cms/upload/pdf/FSI2012_BanksBig4.pdf, downloaded from appendix tables on 20190625
import excel "$Data/Papers/harari2012/20190625 Big4 offices and Banks HarariMeinzerMurphy2012.xlsx", sheet("Sheet1") firstrow clear
label variable big4_offices "Number of Big4 offices. Source: Harari, Meinzer & Murphy (2012)."
label variable banks_offices "Number of bank offices. Source: Harari, Meinzer & Murphy (2012)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country year using "$CYB/countryYearBase v0.dta", unmatched(master)
rename country_iso3 iso3
drop _merge c_x country country_iso2
order iso3 year
drop if iso3==""
*Panel
save "$Data/Papers/_to merge panel uni/harari2012 to merge.dta", replace
*Cross
rename * *_2012
rename iso3_2012 iso3
drop year
save "$Data/Papers/_to merge cross uni/harari2012 to merge.dta", replace

* 18g) Garcia, Jansky, Torslov 2019 - Effective corporate tax rates estimates, 20181018
insheet using "$Data/Papers/garcia2019/20181018 ectr_gjt.csv", n clear
label variable ectr_garcia2019 "Effective corporate tax rate estimates, 2011-2015 (%). Source: Garcia, Jansky & Torslov (2019)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/ectr_garcia2019 to merge.dta", replace

* 18h) Janský & Palanský 2019'ITAX
import excel "$Data/Papers/jansky2019/results_jp19.xlsx", firstrow clear
rename *19 *2019
replace trl_globalmodel_jansky2019=1000000*trl_globalmodel_jansky2019
replace trl_devmodel_jansky2019=1000000*trl_devmodel_jansky2019
replace ps_jansky2019=1000000*ps_jansky2019
replace trl_jansky2019=1000000*trl_jansky2019
label variable trl_globalmodel_jansky2019 "Tax revenue loss (USD, 2016), global model. Source: Janský & Palanský (2019'ITAX)"
label variable trl_devmodel_jansky2019 "Tax revenue loss (USD, 2016), developing vs developed model. Source: Janský & Palanský (2019'ITAX)"
label variable ps_jansky2019 "Profits shifted (USD, 2016), main model. Source: Janský & Palanský (2019'ITAX)"
label variable ps_socorpprof_jansky2019 "Profits shifted as a share of corporate profits, 2016, main model. Source: Janský & Palanský (2019'ITAX)"
label variable ps_sofcorpprof_jansky2019 "Profits shifted as a share of foreign corporate profits, 2016, main model. Source: Janský & Palanský (2019'ITAX)"
label variable trl_jansky2019 "Tax revenue loss (USD, 2016), main model. Source: Janský & Palanský (2019'ITAX)"
label variable trl_sogdp_jansky2019 "Tax revenue loss as % of GDP, 2016, main model. Source: Janský & Palanský (2019'ITAX)"
label variable trl_socorptax_jansky2019 "Tax revenue loss as % of corporate tax revenue, 2016, main model. Source: Janský & Palanský (2019'ITAX)" 
label variable trl_sotottax_jansky2019 "Tax revenue loss as % of total tax revenue, 2016, main model. Source: Janský & Palanský (2019'ITAX)"
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/jansky2019 to merge.dta", replace

* 18i) Cobham & Janský 2018'JID
use "$Data/Papers/cobham2018/170912 CobhamJansky2018 results.dta", clear
replace country="Curacao" if country=="Curacao and St. Maarten"
*Transform profit shifting estimates into dollars and create long-run and short-run estimates
replace ps_cobham2018=ps_cobham2018*1000000000
gen pse_cobham2018=ps_cobham2018
label variable pse_cobham2018 "Profit shifting effect (may be positive or negative, USD, 2013). Source: Cobham & Janský (2018'JID)."
*Disregard negative values for ps_cj18 (i.e. disregard profit shifting gains)
replace ps_cobham2018=. if ps_cobham2018<0
gen ps_lr_cobham2018=ps_cobham2018
gen ps_sr_cobham2018=ps_lr_cobham2018*(1-0.851112)
replace ps_sr_cobham2018=ps_lr_cobham2018*(1-0.7965518) if OECD==1
replace tre_cobham2018=tre_cobham2018*1000000000
*Turn effects to losses
gen trl_cobham2018=tre_cobham2018
replace trl_cobham2018=. if trl_cobham2018<0
rename trl_cobham2018 trl_lr_cobham2018
gen trl_sr_cobham2018=trl_lr_cobham2018*(1-0.851112)
replace trl_sr_cobham2018=trl_lr_cobham2018*(1-0.7965518) if OECD==1
drop OECD
label variable trl_lr_cobham2018 "Tax revenue loss, long run (USD, 2013). Source: Cobham & Janský (2018'JID)."
label variable trl_sr_cobham2018 "Tax revenue loss, short run (USD, 2013). Source: Cobham & Janský (2018'JID)."
label variable ps_lr_cobham2018 "Profits shifted, long run (USD, 2013). Source: Cobham & Janský (2018'JID)."
label variable ps_sr_cobham2018 "Profits shifted, long run (USD, 2013). Source: Cobham & Janský (2018'JID)."
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2013
duplicates drop
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/cobham2018 to merge.dta", replace

* 18j) Cobham & Janský 2019'DPR
use "$Data/Papers/cobham2019/180802 CobhamJansky2019 results.dta", clear
gen ps_cobham2019=addgrossprofit_cobham2019*1000000
gen trl_cobham2019=tre_cobham2019*1000000
label variable ps_cobham2019 "Profits shifted (USD, 2012). Source: Cobham & Janský (2019'DPR)"
label variable trl_cobham2019 "Tax revenue loss (USD, 2012). Source: Cobham & Janský (2019'DPR)"
keep country trl ps
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/cobham2019 to merge.dta", replace

* 18k) Clausing 2016'NTJ
insheet using "$Data/Papers/clausing2016/180804 Clausing2016 results.csv", clear
gen ps_clausing2016=excessincome_c16*1000000000
gen trl_clausing2016=tre_c16*(-1)*1000000000
label variable ps_clausing2016 "Profits shifted (USD, 2012). Source: Clausing (2016'NTJ)"
label variable trl_clausing2016 "Tax revenue loss (USD, 2012). Source: Clausing (2016'NTJ)"
keep country ps trl
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/clausing2016 to merge.dta", replace

* 18l) Torslov, Wier, Zucman 2018'NBERWP
insheet using "$Data/Papers/torslov2018/181127 TorslovWierZucman2018 results.csv", clear
replace corp_profits_torslov2018=1000000000*corp_profits_torslov2018	
replace lc_corp_profits_torslov2018=1000000000*lc_corp_profits_torslov2018
replace fc_corp_profits_torslov2018=1000000000*fc_corp_profits_torslov2018	
replace ps_torslov2018=1000000000*ps_torslov2018	
replace corp_tax_rev_torslov2018=1000000000*corp_tax_rev_torslov2018
replace trl_torslov2018=1000000000*trl_torslov2018
label variable ps_torslov2018 "Profits shifted (USD, 2015). Source: Torslov, Wier & Zucman (2018'NBERWP)"
label variable trl_torslov2018 "Tax revenue loss (USD, 2015). Source: Torslov, Wier & Zucman (2018'NBERWP)"
label variable nctr_torslov2018 "Nominal corporate tax rate. Source: Torslov, Wier & Zucman (2018'NBERWP)"
*Prepare for merge
rename country c_x
run "$General/Harmonizing country names.do"
joinby country using "$CYB/countryYearBase v0.dta", unmatched(master)
drop if year!=2018
rename country_iso3 iso3
drop _merge c_x country country_iso2 year
order iso3
drop if iso3==""
save "$Data/Papers/_to merge cross uni/torslov2018 to merge.dta", replace

* 18m) Garcia-Bernardo and Stausholm (2020) LinkedIn paper
import delimited "C:\Users\miros\Desktop\Dropbox\Research\_General\Source data\Papers\garcia2020\combined_data.tsv", clear
drop v1 country population consumption gdp tax_complex voiceandaccountability politicalstabilitynoviolence governmenteffectiveness regulatoryquality ruleoflaw controlofcorruption pi uhnwi cit totalfsi cthi bis
rename * *_garcia2020
rename index_garcia2020 country_iso2
save "$Data/Papers/_to merge cross uni/garcia2020 to merge.dta", replace

* 18n) Fazekas and Kocsis 2020
use "$Data/Papers/fazekas2020/fazekas_countrypanel_ppcorr_151111.dta", clear
rename * *_fazekas2020
rename country_fazekas2020 country_iso2
rename year_fazekas2020 year
save "$Data/Papers/_to merge panel uni/fazekas2020 to merge.dta", replace

*Merge all above and prepare for merge to my file here
*Cross uni
use "$CYB/countryYearBase v0.dta", clear
rename country_iso3 iso3
keep if year==2017
drop year
joinby iso3 using "$Data/Papers/_to merge cross uni/laporta1998 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/murphy2019 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/harari2012 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/ectr_garcia2019 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/jansky2019 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/cobham2018 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/cobham2019 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/clausing2016 to merge.dta", unmatched(master)
drop _merge
joinby iso3 using "$Data/Papers/_to merge cross uni/torslov2018 to merge.dta", unmatched(master)
drop _merge
joinby country_iso2 using "$Data/Papers/_to merge cross uni/garcia2020 to merge.dta", unmatched(master)
drop _merge
*save "C:\Users\miros\Tax Justice Network Ltd\TJN - Shared Documents\Data\Source data\016 Papers\Papers data cross uni to merge.dta", replace
rename iso3 country_iso3
save "$Data/Papers/Papers data cross uni to merge.dta", replace


*Panel uni
use "$CYB/countryYearBase v0.dta", clear
rename country_iso3 iso3
joinby iso3 year using "$Data/Papers/_to merge panel uni/alm2013 to merge.dta", unmatched(master)
drop _merge
joinby iso3 year using "$Data/Papers/_to merge panel uni/elgin2013 to merge.dta", unmatched(master)
drop _merge
joinby iso3 year using "$Data/Papers/_to merge panel uni/schneider2013 to merge.dta", unmatched(master)
drop _merge
joinby iso3 year using "$Data/Papers/_to merge panel uni/murphy2019 to merge.dta", unmatched(master)
drop _merge
joinby iso3 year using "$Data/Papers/_to merge panel uni/harari2012 to merge.dta", unmatched(master)
drop _merge
joinby country_iso2 year using "$Data/Papers/_to merge panel uni/fazekas2020 to merge.dta", unmatched(master)
drop _merge
*save "C:\Users\miros\Tax Justice Network Ltd\TJN - Shared Documents\Data\Source data\016 Papers\Papers data panel uni to merge.dta", replace
rename iso3 country_iso3
save "$Data/Papers/Papers data panel uni to merge.dta", replace


}
** 18) CIA
{
* 19a) GDP, 20190715, copied and pasted to excel and then manipulated a bit, from https://www.cia.gov/library/publications/the-world-factbook/rankorder/2001rank.html
import excel using "$Data/CIA/20190715 gdp_cia.xlsx", sheet("Sheet1") firstrow clear
run "$General/Harmonizing country names.do"
drop c_x
order country
label variable gdp_cia "GDP, current US$. Source: CIA World Factbook, 201907."
gen gdp_cia_src_link="https://www.cia.gov/library/publications/the-world-factbook/rankorder/2001rank.html"
save "$Data/CIA/gdp_cia to merge.dta", replace
}
** 19) Governments (individual data sources by governments)
{
* 21a) population_gvt, 20200210. Sources stored in population_gvt_src
import excel using "$Data/Governments/20200210 population_gvt.xlsx", clear first
save "$Data/Governments/population_gvt to merge.dta", replace
}
** 20) GHS
{
import excel using "$Data/GHS/ghs_index_2019.xlsx", clear first
drop C
run "$General/Harmonizing country names.do"
drop c_x
order country
save "$Data/GHS/ghs_index_2019 to merge.dta", replace
}
}

***Merge all onto base
{
use "$CYB/countryYearBase v0.dta", clear
order country year
*1) Development status
joinby country using "$Data/Development status/dev_WEO2015.dta", unmatched(master)
drop _merge
joinby country using "$Data/Development status/dev_status_un.dta", unmatched(master)
drop _merge
*2) International organizations
joinby country using "$Data/IO/International organizations to merge.dta", unmatched(master)
drop _merge
*3) Tax haven lists
joinby country using "$Data/THlists/Tax haven lists to merge.dta", unmatched(master)
drop _merge
*4) WB
*4A)
joinby country using "$Data/World Bank/Cross/region_wb to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/World Bank/Cross/income_wb to merge.dta", unmatched(master)
drop _merge
*4B)
*joinby country_iso3 year using "$Data/World Bank/Panel/WBpanel to merge.dta", unmatched(master) /*Newly all taken from TJN data portal*/
*drop _merge
joinby country year using "$Data/World Bank/Panel/income_wb to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/World Bank/Panel/World Governance Indicators to merge.dta", unmatched(master)
drop _merge
*5) UN
joinby country year using "$Data/UN/gdp_un to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/UN/expGoods_comtrade to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/UN/inc_ineq_palma_hdr_latest to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/UN/population_un to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/UN/gdppc_un to merge.dta", unmatched(master)
drop _merge
*6) OECD
joinby country year using "$Data/OECD/nctr_oecd to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/OECD/ectr_oecd to merge.dta", unmatched(master)
drop _merge
joinby country_iso2 using "$Data/OECD/trans_rating_oecd to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/OECD/harmful_regimes_oecd to merge.dta", unmatched(master)
drop _merge
replace harmful_regimes_oecd="Not harmful" if harmful_regimes_oecd==""
*7) KPMG
joinby country year using "$Data/KPMG/nctr_kpmg to merge.dta", unmatched(master)
drop _merge
*8) TradingEconomics
joinby country year using "$Data/TradingEconomics/nctr_tradingeconomics to merge.dta", unmatched(master)
drop _merge
*9) Tax Foundation
joinby country year using "$Data/Tax Foundation/nctr_taxf to merge.dta", unmatched(master)
drop _merge
*10) CBT
joinby country_iso3 year using "$Data/CBT/nctr_cbt to merge.dta", unmatched(master)
drop _merge
joinby country_iso3 year using "$Data/CBT/ectr_cbt to merge.dta", unmatched(master)
drop _merge
*11) TJN
*FSI
joinby country using "$Data/TJN/FSI/fsi2009-2020 to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/TJN/FSI/fsi_panel to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/TJN/FSI/190629 MFSI to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/TJN/FSI/bearer_shares_fsi2018 to merge.dta", unmatched(master)
drop _merge
*CTHI
joinby country using "$Data/TJN/CTHI/CTHI 2019 to merge.dta", unmatched(master)
drop _merge
replace included_in_cthi_2019=0 if included_in_cthi_2019==.
joinby country year using "$Data/TJN/CTHI/lacitr_final to merge.dta", unmatched(master)
drop _merge
joinby country_iso3 using "$Data/TJN/CTHI/CTHI 2021 to merge.dta", unmatched(master)
drop _merge
replace included_in_cthi_2021=0 if included_in_cthi_2021==.
*Data portal
joinby country_iso3 using "$Data/TJN/country-level-data to merge.dta", unmatched(master)
drop _merge
joinby country_iso3 year using "$Data/TJN/country-year-level-data to merge.dta", unmatched(master)
drop _merge
*SOTJ2020
joinby country_iso3 using "$Data/TJN/SOTJ/sotj2020 to merge.dta", unmatched(master)
drop _merge
*12) UNCTAD
joinby country year using "$Data/UNCTAD/UNCTAD FDI to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/UNCTAD/expSer_unctad to merge.dta", unmatched(master)
drop _merge
*13) IMF
joinby country year using "$Data/IMF/CDIS/IMF CDIS FDI to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/IMF/BoP/IMF BoP to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/IMF/GFS/IMF GFS to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/IMF/CPIS/CPIS unilateral to merge.dta", unmatched(master)
drop _merge
*14) UNU-WIDER
joinby country year using "$Data/UNU-WIDER/GRD to merge.dta", unmatched(master)
drop _merge
*15) WTO
joinby country year using "$Data/WTO/expFinSer_wto to merge.dta", unmatched(master)
drop _merge
joinby country year using "$Data/WTO/impFinSer_wto to merge.dta", unmatched(master)
drop _merge
*16) BIS
joinby country year using "$Data/BIS/Unilateral BIS in to merge.dta", unmatched(master)
drop _merge
*17) Papers
joinby country year using "$Data/Papers/Papers data panel uni to merge.dta", unmatched(master)
drop _merge
joinby country using "$Data/Papers/Papers data cross uni to merge.dta", unmatched(master)
drop _merge
*18) CIA
joinby country year using "$Data/CIA/gdp_cia to merge.dta", unmatched(master)
drop _merge
*19) Governments
joinby country year using "$Data/Governments/population_gvt to merge.dta", unmatched(master)
drop _merge
*20) GHS
joinby country using "$Data/GHS/ghs_index_2019 to merge.dta", unmatched(master)
drop _merge
save "$CYB/countryYearBase all merged.dta", replace
}

***CREATE FINAL VARIABLES
{
use "$CYB/countryYearBase all merged.dta", clear
** 1) GDP final - WB, then UN, then CIA
**Create gdp_final
*Take WB data
gen double gdp_final=gdp_wb
gen gdp_final_src=""
replace gdp_final_src="World Bank" if gdp_wb!=. 
*gen gdp_final_src_link=""
*replace gdp_final_src_link=gdp_wb_src_link if gdp_wb!=. 
*UN data
replace gdp_final=gdp_un if gdp_final==.
replace gdp_final_src="United Nations" if gdp_un!=. & gdp_wb==.
*replace gdp_final_src_link=gdp_un_src_link if gdp_un!=. & gdp_wb==.
*CIA data
replace gdp_final=gdp_cia if gdp_final==.
replace gdp_final_src="CIA" if gdp_cia!=. & gdp_un==. & gdp_wb==.
*replace gdp_final_src_link=gdp_cia_src_link if gdp_cia!=. & gdp_un==. & gdp_wb==.
label variable gdp_final "GDP, maximum coverage. Source: WB, then UN, then CIA Factbook."
*Government data
*For Guernsey, we take their official GDP data from their website (https://gov.gg/CHttpHandler.ashx?id=116246&p=0). It is in pounds, so we calculate the dollar value using OECD data on exchange rates (https://data.oecd.org/conversion/exchange-rates.htm).
replace gdp_final=2458*1000000*0.642 if country=="Guernsey" & year==2009
replace gdp_final=2423*1000000*0.647 if country=="Guernsey" & year==2010
replace gdp_final=2629*1000000*0.624 if country=="Guernsey" & year==2011
replace gdp_final=2615*1000000*0.633 if country=="Guernsey" & year==2012
replace gdp_final=2715*1000000*0.640 if country=="Guernsey" & year==2013
replace gdp_final=2779*1000000*0.608 if country=="Guernsey" & year==2014
replace gdp_final=2816*1000000*0.655 if country=="Guernsey" & year==2015
replace gdp_final=2921*1000000*0.741 if country=="Guernsey" & year==2016
replace gdp_final=3050*1000000*0.777 if country=="Guernsey" & year==2017
replace gdp_final=3272*1000000*0.750 if country=="Guernsey" & year==2018
*For Jersey, we take their official GDP data from their website (https://opendata.gov.je/dataset/national-accounts?_ga=2.226997853.1596664405.1568987227-1618946912.1568987227). It is in pounds, so we calculate the dollar value using OECD data on exchange rates (https://data.oecd.org/conversion/exchange-rates.htm).
*Note that this data is in real terms (2017 constant prices), I haven't found data in current USD
replace gdp_final=4110*1000000*0.624 if country=="Jersey" & year==2011 /*We need data for 2011 but can't find it anywhere. This number is based on the fact that Jersey's GVA decreased by 1% between 2011 and 2012. We apply the same coefficient to Jersey's 2012 data point on GDP to arrive at an estimate of GDP in 2011.*/
replace gdp_final=3972*1000000*0.633 if country=="Jersey" & year==2012
replace gdp_final=4011*1000000*0.640 if country=="Jersey" & year==2013
replace gdp_final=4178*1000000*0.608 if country=="Jersey" & year==2014
replace gdp_final=4259*1000000*0.655 if country=="Jersey" & year==2015
replace gdp_final=4285*1000000*0.741 if country=="Jersey" & year==2016
replace gdp_final=4304*1000000*0.777 if country=="Jersey" & year==2017
**Create gdp_final_latest
*Take last known value (but later than 2016) where data is missing for 2019
bys country: egen gdp_final_latest_year=max(cond(gdp_final!=.,year,.))
label variable gdp_final_latest_year "GDP, maximum coverage, year of latest available data."
gen gdp_final_latest=.
replace gdp_final_latest=gdp_final*1.03 if year==gdp_final_latest_year
replace gdp_final_latest=gdp_final_latest[_n-1] if year==2019 & gdp_final_latest==.
replace gdp_final_latest=gdp_final if year==2019 & gdp_final!=.
label variable gdp_final_latest "GDP, maximum coverage, latest available data."

**gdp_final_share
bys year: egen gdp_final_globaltotal=sum(gdp_final)
gen gdp_final_share=gdp_final/gdp_final_globaltotal

/*
*For FSI over time (This is done by assuming above that for countries for which we have 2018 data, we assume a 3% growth in GDP in 2019, then for a couple of countries this is done from 2017 data (by again assuming a 3% GDP growth annually). For Gibraltar, the number for 2018 comes from Wikipedia for the lack of a better source.)
gen gdp_final_forFSIovertime=gdp_final
replace gdp_final_forFSIovertime=302000000 if country=="Anguilla" & year==2019
replace gdp_final_forFSIovertime=7480000000 if country=="Bermuda" & year==2019
replace gdp_final_forFSIovertime=1490000000 if country=="British Virgin Islands" & year==2019
replace gdp_final_forFSIovertime=5680000000 if country=="Cayman Islands" & year==2019
replace gdp_final_forFSIovertime=374000000 if country=="Cook Islands" & year==2019
replace gdp_final_forFSIovertime=3301063521.2 if country=="Gibraltar" & year==2019
replace gdp_final_forFSIovertime=2530000000 if country=="Guernsey" & year==2019
replace gdp_final_forFSIovertime=7720000000 if country=="Isle of Man" & year==2019
replace gdp_final_forFSIovertime=3547870267.2 if country=="Jersey" & year==2019
replace gdp_final_forFSIovertime=7080000000 if country=="Liechtenstein" & year==2019
replace gdp_final_forFSIovertime=7400000000 if country=="Monaco" & year==2019
replace gdp_final_forFSIovertime=65600000 if country=="Montserrat" & year==2019
replace gdp_final_forFSIovertime=1200000000 if country=="Turks and Caicos Islands" & year==2019
replace gdp_final_forFSIovertime=4089769500 if country=="US Virgin Islands" & year==2019
*/
 
/*
*For Guernsey, we take their official GDP data from their website (https://gov.gg/CHttpHandler.ashx?id=116246&p=0). It is in pounds, so we calculate the dollar value using OECD data on exchange rates (https://data.oecd.org/conversion/exchange-rates.htm).
replace gdp_final=2458*1000000*0.642 if country=="Guernsey" & year==2009
replace gdp_final=2423*1000000*0.647 if country=="Guernsey" & year==2010
replace gdp_final=2629*1000000*0.624 if country=="Guernsey" & year==2011
replace gdp_final=2615*1000000*0.633 if country=="Guernsey" & year==2012
replace gdp_final=2715*1000000*0.640 if country=="Guernsey" & year==2013
replace gdp_final=2779*1000000*0.608 if country=="Guernsey" & year==2014
replace gdp_final=2816*1000000*0.655 if country=="Guernsey" & year==2015
replace gdp_final=2921*1000000*0.741 if country=="Guernsey" & year==2016
replace gdp_final=3050*1000000*0.777 if country=="Guernsey" & year==2017

*For Jersey, we take their official GDP data from their website (https://opendata.gov.je/dataset/national-accounts?_ga=2.226997853.1596664405.1568987227-1618946912.1568987227). It is in pounds, so we calculate the dollar value using OECD data on exchange rates (https://data.oecd.org/conversion/exchange-rates.htm).
*Note that this data is in real terms (2017 constant prices), I haven't found data in current USD
replace gdp_final=4110*1000000*0.624 if country=="Jersey" & year==2011 /*We need data for 2011 but can't find it anywhere. This number is based on the fact that Jersey's GVA decreased by 1% between 2011 and 2012. We apply the same coefficient to Jersey's 2012 data point on GDP to arrive at an estimate of GDP in 2011.*/
replace gdp_final=3972*1000000*0.633 if country=="Jersey" & year==2012
replace gdp_final=4011*1000000*0.640 if country=="Jersey" & year==2013
replace gdp_final=4178*1000000*0.608 if country=="Jersey" & year==2014
replace gdp_final=4259*1000000*0.655 if country=="Jersey" & year==2015
replace gdp_final=4285*1000000*0.741 if country=="Jersey" & year==2016
replace gdp_final=4304*1000000*0.777 if country=="Jersey" & year==2017
*For Gibraltar, we take data from the CIA
replace gdp_final=2000000000 if country=="Gibraltar" & year==2011 /*Here we are just taking the same value as for 2012, because data is not available*/
replace gdp_final=2000000000 if country=="Gibraltar" & year==2012
replace gdp_final=1850000000 if country=="Gibraltar" & year==2013
replace gdp_final=2044000000 if country=="Gibraltar" & year==2014
*Other countries
replace gdp_final=287200000000 if country=="Venezuela" & year>2015 /*Based on the information that GDP decreased by 16.5% between 2015 and 2016. Source: https://www.cia.gov/library/publications/the-world-factbook/geos/ve.html*/
replace gdp_final=3480000000 if country=="Cayman Islands" & year>2015 /*Source: https://tradingeconomics.com/cayman-islands/gdp-growth-annual*/
replace gdp_final=6127000000 if country=="Bermuda" & year>2015 /*Source: https://www.cia.gov/library/publications/the-world-factbook/geos/print_bd.html*/
replace gdp_final=1027000000 if country=="British Virgin Islands" & year>2015 /*Source: https://en.wikipedia.org/wiki/Economy_of_the_British_Virgin_Islands*/
replace gdp_final=3128000000 if country=="Curacao" & year>2015 /*Source: https://www.cia.gov/library/publications/the-world-factbook/geos/print_cc.html*/
replace gdp_final=6660000000 if country=="Liechtenstein" & year>2015 /*Source: World Bank*/
replace gdp_final=6260000000 if country=="Monaco" & year>2015
replace gdp_final=28400000000 if country=="Syria" & year>2015
replace gdp_final=519000000000 if country=="Taiwan" & year>2015
replace gdp_final=4010000000 if country=="Netherlands Antilles" & year>2015
replace gdp_final=365800000 if country=="Sint Maarten" & year>2015
replace gdp_final=3860000000 if country=="Eritrea" & year>2013 /*Data for 2014, source: https://tradingeconomics.com/eritrea/gdp*/
replace gdp_final=365800000 if country=="Isle of Man" & year>2015
*/

** 2) Big4staff, Big4staff per gdp
gen double big4staff=kpmg_staff+deloitte_staff+pwc_staff+ey_staff
gen double big4staff_gdp=big4staff/gdp_final

** 3) population_final - WB, then UN, then national government sources
*Create population_final
*Take WB data
gen double population_final=pop_wb
gen population_final_src=""
replace population_final_src="World Bank" if pop_wb!=. 
*gen population_final_src_link=""
*replace population_final_src_link=population_wb_src_link if pop_wb!=. 
*UN data
replace population_final=population_un if population_final==.
replace population_final_src="United Nations" if population_un!=. & pop_wb==.
*replace population_final_src_link=population_un_src_link if population_un!=. & pop_wb==.
*Governments' data
replace population_final=population_gvt if population_final==.
replace population_final_src="National government source" if population_gvt!=. & population_un==. & pop_wb==.
*replace population_final_src_link=population_gvt_src_link if population_gvt!=. & population_un==. & pop_wb==.
label variable population_final "Population, maximum coverage. Source: WB, then UN, then national government sources."
**Create population_final_latest
*Take last known value where data is missing
bys country: egen population_final_latest=max(cond(population_final!=.,population_final,.))
label variable population_final_latest "Population, maximum coverage, latest available data."
bys country: egen population_final_latest_year=max(cond(population_final!=.,year,.))
label variable population_final_latest_year "Population, maximum coverage, year of latest available data."

*population_final_share
bys year: egen population_final_globaltotal=sum(population_final)
gen population_final_share=population_final/population_final_globaltotal

** 4) gdppc_final - WB, then UN, then maximum coverage
**Create gdppc_final
*Take WB data
gen double gdp_pc_final=gdp_pc_wb
gen gdp_pc_final_src=""
replace gdp_pc_final_src="World Bank" if gdp_pc_wb!=. 
*gen gdppc_final_src_link=""
*replace gdppc_final_src_link=gdppc_wb_src_link if gdppc_wb!=. 
*UN data
replace gdp_pc_final=gdppc_un if gdp_pc_final==.
replace gdp_pc_final_src="United Nations" if gdppc_un!=. & gdp_pc_wb==.
*replace gdppc_final_src_link=gdppc_un_src_link if gdppc_un!=. & gdppc_wb==.
*Maximum coverage data
replace gdp_pc_final=gdp_final/population_final if gdp_pc_final==.
replace gdp_pc_final_src="Own calculation based on data from WB, UN, CIA, and national governments." if gdp_pc_final!=. & gdppc_un==. & gdp_pc_wb==.
*replace gdppc_final_src_link="" if gdppc_final!=. & gdppc_un==. & gdppc_wb==.
label variable gdp_pc_final "GDPpc, maximum coverage. Source: WB, then UN, then own calculation."
**Create gdppc_final_latest
*Take last known value where data is missing
bys country: egen gdp_pc_final_latest=max(cond(gdp_pc_final!=.,gdp_pc_final,.))
label variable gdp_pc_final_latest "GDPpc, maximum coverage, latest available data."
bys country: egen gdp_pc_final_latest_year=max(cond(gdp_pc_final!=.,year,.))
label variable gdp_pc_final_latest_year "GDPpc, maximum coverage, year of latest available data."

** 5) nctr_final
*Nominal corporate tax rates, final - OECD, then KPMG, then Tax Foundation, then TradingEconomics, then CBT, then WB's Doing Bussiness or individual government sources
gen double nctr_final=nctr_oecd
label variable nctr_final "Nominal corporate tax rate. Various sources."
replace nctr_final=nctr_kpmg if nctr_final==.
replace nctr_final=nctr_taxf if nctr_final==.
replace nctr_final=nctr_tradingeconomics if nctr_final==.
replace nctr_final=nctr_cbt2 if nctr_final==.
replace nctr_final=0 if year>2008 & country=="Alderney" /*Source: http://www.alderney.gov.gg/article/4069/Taxation */
replace nctr_final=0.25 if year>2008 & year<2013 & country=="Algeria" /*Source: https://tradingeconomics.com/algeria/corporate-tax-rate */
replace nctr_final=.27 if year>2008 & country=="American Samoa" /*Source: https://tradingeconomics.com/samoa/corporate-tax-rate */
replace nctr_final=.2 if year>2008 & year<2016 & country=="Azerbaijan" /*Source: http://www.doingbusiness.org/data/exploreeconomies/azerbaijan#paying-taxes */
replace nctr_final=.194 if year>2008 & year<2017 & country=="Benin" /*Source: http://www.doingbusiness.org/data/exploreeconomies/benin/paying-taxes */
replace nctr_final=0.3 if year>2008 & country=="Bhutan" /*Source: http://www.asiatradehub.com/bhutan/tax.asp */
replace nctr_final=0.25 if year>2008 & country=="Cape Verde" /*Source: http://www.doingbusiness.org/data/exploreeconomies/cabo-verde/paying-taxes */
replace nctr_final=.14 if year>2008 & country=="Guinea-Bissau" /*Source: http://www.doingbusiness.org/data/exploreeconomies/guinea-bissau#paying-taxes */
replace nctr_final=.1 if year>2008 & year<2016 & country=="Kosovo" /*Source: http://www.doingbusiness.org/data/exploreeconomies/kosovo/paying-taxes */
replace nctr_final=.1 if year>2008 & year<2017 & country=="Kyrgyz Republic" /*Source: http://www.doingbusiness.org/data/exploreeconomies/kyrgyz-republic/paying-taxes */
replace nctr_final=.3 if year>2008 & country=="Mali" /*Source: http://www.doingbusiness.org/data/exploreeconomies/mali/paying-taxes */
replace nctr_final=.1 if year>2008 & year<2016 & country=="Mongolia" /*Source: http://www.doingbusiness.org/data/exploreeconomies/mongolia/paying-taxes */
replace nctr_final=0.25 if year>2012 & year<2016 & country=="Myanmar" /*Source: http://www.doingbusiness.org/data/exploreeconomies/myanmar#paying-taxes */
replace nctr_final=.2 if year>2008 & country=="Nepal" /*Source: http://www.doingbusiness.org/data/exploreeconomies/nepal/paying-taxes */
replace nctr_final=.3 if year>2008 & country=="Niger" /*Source: http://www.doingbusiness.org/data/exploreeconomies/niger/paying-taxes */
replace nctr_final=.3 if year>2008 & year<2016 & country=="Rwanda" /*Source: http://www.doingbusiness.org/data/exploreeconomies/rwanda/paying-taxes */
replace nctr_final=.17 if year>2008 & country=="San Marino" /*Source: http://kdocs.kpmg.it/marketing/KSA/Country_Profile_San_Marino.pdf */
replace nctr_final=.3 if year>2008 & year<2017 & country=="Solomon Islands" /*Source: http://www.doingbusiness.org/data/exploreeconomies/solomon-islands/paying-taxes */
replace nctr_final=.14 if year>2008 & country=="Tajikistan" /*Source: http://www.doingbusiness.org/data/exploreeconomies/tajikistan/paying-taxes */
replace nctr_final=.175 if year>2008 & country=="Togo" /*Source: http://www.doingbusiness.org/data/exploreeconomies/togo/paying-taxes */
replace nctr_final=.15 if year>2008 & country=="West Bank and Gaza" /*Source: http://www.doingbusiness.org/data/exploreeconomies/west-bank-and-gaza/paying-taxes */
replace nctr_final=0 if country=="Bahrain" /*Source: http://www.doingbusiness.org/data/exploretopics/paying-taxes?dataPointCode=DB_tax_total */
replace nctr_final=0 if country=="Palau" /*Source: http://www.doingbusiness.org/data/exploretopics/paying-taxes?dataPointCode=DB_tax_total */
replace nctr_final=0 if country=="Bermuda" & year<2000
replace nctr_final=0.35 if country=="Brazil" & year>1979 & year<1988
replace nctr_final=0.3 if country=="Brazil" & year>1987 & year<1991

** 6) expFinSer_final
gen double expFinSer_final=expFinSer_bop
replace expFinSer_final=3089000000 if country=="Taiwan" & year==2018
replace expFinSer_final=2884000000 if country=="Taiwan" & year==2017
replace expFinSer_final=2608000000 if country=="Taiwan" & year==2016
replace expFinSer_final=2422000000 if country=="Taiwan" & year==2015
replace expFinSer_final=2421000000 if country=="Taiwan" & year==2014
replace expFinSer_final=2058000000 if country=="Taiwan" & year==2013
replace expFinSer_final=1750000000 if country=="Taiwan" & year==2012
replace expFinSer_final=909000000 if country=="Taiwan" & year==2011
replace expFinSer_final=847000000 if country=="Taiwan" & year==2010
replace expFinSer_final=727000000 if country=="Taiwan" & year==2009
replace expFinSer_final=1146000000 if country=="Taiwan" & year==2008
replace expFinSer_final=1302000000 if country=="Taiwan" & year==2007
replace expFinSer_final=1232000000 if country=="Taiwan" & year==2006
replace expFinSer_final=1517000000 if country=="Taiwan" & year==2005

** 7) inc_ineq_palma_wb
gen inc_ineq_palma_wb=incsh_tenth10_wb/(incsh_first20_wb+incsh_second20_wb)
**Create inc_ineq_palma_wb_latest
*Take last known value where data is missing
bys country: egen inc_ineq_palma_wb_latest=max(cond(inc_ineq_palma_wb!=.,inc_ineq_palma_wb,.))
label variable inc_ineq_palma_wb_latest "Palma ratio, WB, latest available data."
bys country: egen inc_ineq_palma_wb_latest_year=max(cond(inc_ineq_palma_wb!=.,year,.))
label variable inc_ineq_palma_wb_latest_year "Palma ratio, WB, year of latest available data."

** 8) income_final_2018 - WB, then own calculation (derived from gdppc_final - correct this, it should be based on GNI per capita)
*From WB data
gen income_final_2018=income_wb_2018
gen income_final_2018_src=""
replace income_final_2018_src="World Bank" if income_final_2018!="" 
gen income_final_2018_src_link=""
replace income_final_2018_src_link="https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups" if income_final_2018!="" 
*Own calculation
replace income_final_2018="Low income" if income_final_2018=="" & gdp_pc_final_latest<1025.01 & gdp_pc_final_latest!=.
replace income_final_2018="Lower middle income" if income_final_2018=="" & gdp_pc_final_latest>1025 & gdp_pc_final_latest<3995.01
replace income_final_2018="Upper middle income" if income_final_2018=="" & gdp_pc_final_latest>3995 & gdp_pc_final_latest<12375.01
replace income_final_2018="High income" if income_final_2018=="" & gdp_pc_final_latest>12375 & gdp_pc_final_latest!=.
replace income_final_2018_src="Own calculation based on data from WB, UN, CIA, and national governments." if income_final_2018!="" & income_wb_2018==""
*Fill in the rest by hand
replace income_final_2018="High income" if country=="Reunion"
replace income_final_2018="Low income" if country=="Western Sahara"
replace income_final_2018="High income" if country=="Heard Island and McDonald Islands"
replace income_final_2018="High income" if country=="Pitcairn"
replace income_final_2018="High income" if country=="Vatican"
replace income_final_2018="High income" if country=="South Georgia and the South Sandwich Islands"
replace income_final_2018="High income" if country=="Christmas Island"
replace income_final_2018="High income" if country=="Mayotte"
replace income_final_2018="High income" if country=="Tokelau"
replace income_final_2018="High income" if country=="Svalbard and Jan Mayen Islands"
replace income_final_2018="High income" if country=="Cocos Islands"
replace income_final_2018="High income" if country=="Bonaire, Sint Eustatius and Saba"
replace income_final_2018="High income" if country=="Serbia and Montenegro"
replace income_final_2018="High income" if country=="French Southern and Antarctic Lands"
replace income_final_2018="High income" if country=="Alderney"
replace income_final_2018="High income" if country=="Bouvet Island"
replace income_final_2018="High income" if country=="British Indian Ocean Territory"
replace income_final_2018="High income" if country=="Martinique"
replace income_final_2018="High income" if country=="French Guiana"
replace income_final_2018="High income" if country=="Antarctica"
replace income_final_2018="High income" if country=="Guadeloupe"
replace income_final_2018="High income" if country=="Saint Helena"
replace income_final_2018="High income" if country=="US Pacific Islands"
replace income_final_2018="High income" if country=="Norfolk Island"



** 9) gini_wb_latest
*Take last known value where data is missing
bys country: egen gini_wb_latest=max(cond(gini_wb!=.,gini_wb,.))
label variable gini_wb_latest "Gini coefficient, latest available data. Source: WB."
bys country: egen gini_wb_latest_year=max(cond(gini_wb!=.,year,.))
label variable gini_wb_latest_year "Gini coefficient, year of latest available data. Source: WB."

** 10) region_final
*Create region_final - region from TJN with added values for missing observations
gen region_final=region_tjn
label variable region_final "Region, maximum coverage. Source: TJN, then Google Maps."
replace region_final="Europe" if country=="Alderney"
replace region_final="Africa" if country=="Anjouan"
replace region_final="Oceania" if country=="Antarctica"
replace region_final="Europe" if country=="Campione d'Italia"
replace region_final="Africa" if country=="Ceuta"
replace region_final="Europe" if country=="Channel Islands"
replace region_final="Europe" if country=="Czechoslovakia"
replace region_final="Europe" if country=="East Germany"
replace region_final="Asia" if country=="India"
replace region_final="Asia" if country=="Ingushetia"
replace region_final="Europe" if country=="Kosovo"
replace region_final="Asia" if country=="Labuan Island"
replace region_final="Africa" if country=="Melilla"
replace region_final="Asia" if country=="North Vietnam"
replace region_final="Asia" if country=="North Yemen"
replace region_final="Europe" if country=="Sark"
replace region_final="Europe" if country=="Serbia and Montenegro"
replace region_final="Asia" if country=="South Vietnam"
replace region_final="Asia" if country=="South Yemen"
replace region_final="Asia" if country=="Tibet"
replace region_final="Europe" if country=="Turkish Republic of Northern Cyprus"
replace region_final="Oceania" if country=="US Pacific Islands"
replace region_final="Asia" if country=="USSR"
replace region_final="Asia" if country=="West Bank and Gaza"
replace region_final="Europe" if country=="West Germany"
replace region_final="Europe" if country=="Yugoslavia"
replace region_final="Africa" if country=="Zanzibar"

save "$CYB/countryYearBase final.dta", replace
}


use "$CYB/countryYearBase final.dta", clear
*save "$CYB/countryYearBase final 20200210.dta", replace

*Export for Bilateral countryYearBase
use "$CYB/countryYearBase final.dta", clear
save "$BCYB/20201201 countryYearBase final.dta", replace

***Exporting data for people and projects
{
/*
*20210217 For Andrea
use "$CYB/countryYearBase final.dta", clear
keep country country_iso2 country_iso3 year EU28 OECD th_johannesen2014 th_zucman2013 th_unctad2015 th_eu_blacklist_171205 th_eu_greylist_171205 income_wb fsi_2018_ss cthi_2019_hs region_tjn gdp_final population_final gdp_pc_final
export delimited using "C:\Users\miros\Desktop\Dropbox\Theses IES\Vedení\2020 Tkáčová Andrea\countryYearBase.csv", replace

*210205 For Bunching and CbCR
use "$CYB/countryBase final.dta", clear
keep country_iso2 EU28 th_unctad2015 gdp_final population_final
save "C:\Users\miros\Desktop\Dropbox\Research\2102 Bunching and CBCR\210205 countryBase.dta", replace
rename * guo_*
save "C:\Users\miros\Desktop\Dropbox\Research\2102 Bunching and CBCR\210205 countryBase guo.dta", replace

*201221 For PP and tax havens
use "$CYB/countryYearBase v0.dta", clear
keep if year==2018
drop year
save "$PPth/Data/201221 countrynames.dta", replace
rename * counterpart_*
save "$PPth/Data/201221 counterpart_countrynames.dta", replace
 
*201218 For Blacklisting and bank deposits
use "$CYB/countryYearBase final.dta", clear
save "C:\Users\miros\Desktop\Dropbox\Research\2012 Blacklisting and bank deposits\Data\201218 countryYearBase.dta", replace

*201214 For CTHI 2021
use "$CYB/countryYearBase final.dta", clear
drop *_mss* *_mki* *_mgsw*
drop if country_iso3==""
drop cthi_2021* *cthi_2021
replace HarmOWTotaltotal = HarmOWTotaltotal/100
replace HarmTATotaltotal = HarmTATotaltotal/100
replace HarmTotaltotal = HarmTotaltotal/100
save "C:\Users\miros\Tax Justice Network Ltd\TJN - Shared Documents\Workstreams\Financial Secrecy\CTHI\CTHI-2021\GSW\210211 countryYearBase for CTHI2021.dta", replace
*keep if year==2019
*save "C:\Users\miros\Tax Justice Network Ltd\TJN - Shared Documents\Workstreams\Financial Secrecy\CTHI\CTHI-2021\GSW\210211 countryBase for CTHI2021.dta", replace

*20201127 CARICOM analysis
use "$CYB/countryYearBase final.dta", clear
drop *_mss* *_mki* *_mgsw*
keep if year==2018
save "C:\Users\miros\Tax Justice Network Ltd\TJN - Shared Documents\Workstreams\Scale of Tax Injustice\State of Tax Justice report\CARICOM analysis\Data\20201127 countryYearBase for CARICOM analysis.dta", replace

*20201126 PP and tax havens
use "$CYB/countryYearBase final.dta", clear
save "$PPth/Data/20201126 countryYearBase for PP and tax havens.dta", replace

*20201118 FSI over time paper
use "$CYB/countryYearBase final.dta", clear
save "$FSIovertime/Data/20201118 countryYearBase final.dta", replace

*20201025 for Tax havens and intermediaries paper
use "$CYB/countryYearBase final.dta", clear
save "C:\Users\miros\Desktop\Dropbox\Research\1904 Tax havens and intermediaries\Data\20210218 countryYearBase final.dta", replace

*20200923 Tax treaties worldwide
use "$CYB/countryYearBase final.dta", clear
save "C:\Users\miros\Desktop\Dropbox\Research\1708 Tax treaties\Tax Treaties Worldwide - data\Stata\20200923 countryYearBase final.dta", replace
keep country year income_wb_2016 income_final_2018
save "C:\Users\miros\Desktop\Dropbox\Research\1708 Tax treaties\Data\20201022 countryYearBase income.dta", replace

*20200921 Sarah corp tax rates
use "$CYB/countryYearBase final.dta", clear
keep country country_iso3 year nctr*
save "$General/Exports for people/20200921 nctr for Sarah.dta", replace

*20200421 Markus for German media
use "$CYB/countryYearBase final.dta", clear
keep if year==2018
keep country country_iso3 trl_jansky2019 trl_sr_cobham2018 trl_lr_cobham2018 trl_cobham2019 trl_clausing2016 trl_torslov2018
keep if (trl_jansky2019!=. | trl_sr_cobham2018!=. | trl_lr_cobham2018!=. | trl_cobham2019!=. | trl_clausing2016!=. | trl_torslov2018!=.)
export excel "$General/Exports for people/20200421 Tax revenue losses estimates.xlsx", replace first(varl)
keep if country=="Germany"
export excel "$General/Exports for people/20200421 Tax revenue losses estimates Germany.xlsx", replace first(varl)

*20200228 Alex's contact in Australia
use "$CYB/countryYearBase final.dta", clear
keep if year==2018
keep country country_iso3 country_iso2 fsi_*_s* fsi_*_gsw fsi_2009 fsi_2011 fsi_2013 fsi_2015 fsi_2018 fsi_2020
drop *ms* *mk* *mg*
save "$General/Exports for people/20200228 FSI complete results.dta", replace
export excel "$General/Exports for people/20200228 FSI complete results.xlsx", replace

*20200216 Export for Finance Curse Index
use "$CYB/countryYearBase final.dta", clear
save "$FCI/countryYearBase final 20200216.dta", replace

*20200212 Data for Brigitte (via Markus)
use "$CYB/countryYearBase final.dta", clear
drop *mki* *mss* *mgsw*
save "$General/Exports for people/20200212 Mirek data export for Brigitte.dta", replace
export excel "$General/Exports for people/20200212 Mirek data export for Brigitte.xlsx", replace

*20200211 For Alex and blacklist analysis
use "$CYB/countryYearBase final.dta", clear
keep if year==2018
keep country th_eu* fsi*
drop fsi_s* fsi_gsw fsi_rank fsi fsi_total fsi_opscore fsi_opcomp *ms* *mg* *mk*
foreach date in 171205 180123 180313 180525 181002 181106 181204 190312 190522 190621 191017 191114 {
bys th_eu_blacklist_`date': egen tot_fsi_2020_eu_black_`date'_h1=sum(fsi_2020)
label variable th_eu_blacklist_`date' "EU th blacklist, `date'."
}
bys th_eu_blacklist_191114: egen tot_fsi_20_sh_eu_black_191114_h1=sum(fsi_2020_share)
egen tot_fsi_20_sh_eu_black_191114


*20200210 For IDs in FSI 2020
use "$CYB/countryYearBase final.dta", clear
save "$FSI2020/IDs/countryYearBase final 20200210.dta", replace

*20200414 For cluster analysis in FSI 2020
use "$CYB/countryYearBase final.dta", clear
keep if year==2018
keep country country_iso3 country_iso2 dev_weo2015 class_devgroup_weo2015 dev_status_un EU28 OECD GBR_OT GBR_CD GBR_OCT NLD_OCT FRA_OCT DNK_OCT EU28_OCT OPEC th_unctad2015 th_eu_blacklist_190312 th_eu_greylist_190312 region_final income_wb_2017 gdp_wb population_wb income_wb gini_wb nbr_wb fsi_2018_ss fsi_2018_gsw fsi_2018 fsi_2018_rank fsi_2018_share included_in_fsi_2018 included_in_fsi_2020 cpis_assets included_in_cthi_2019 cthi_2019_rank cthi_2019 cthi_2019_share cthi_2019_hs cthi_2019_gsw lacitr_final big4_offices_2018 legal_origin big4staff population_final gdp_final gdppc_final nctr_final expFinSer_final
export excel using "$FSI2020/Rankings and comparisons/20200114 Cluster analysis raw data.xlsx", replace firstrow(variables)

*20191204 WDYMG
use "$CYB/countryYearBase final.dta", clear
keep if year==2018
keep country country_iso2 EU28
rename country help_country
rename EU28 help_EU28
save "$WDYMG/Data/20191204 countryYearBase reduced.dta", replace

*20191202 Lucas
use "$CYB/countryYearBase final.dta", clear
keep if EU28==1
keep if year==2018
keep country *cthi* *fsi_2018*
drop *mki* *mss* *cat* lacitr_cthi_2018 fsi_2018_total fsi_2018_mgsw cthi_19_share cthi_19_tot_fdi_in_maxrepder cthi_19_tot_fdi_out_maxrepder cthi_19_fdi_avginout fsi_2018_share included_*
order country fsi_2018 fsi_2018_rank fsi_2018_gsw fsi_2018_ss fsi_2018_ss_ki1 fsi_2018_ss_ki2 fsi_2018_ss_ki3 fsi_2018_ss_ki4 fsi_2018_ss_ki5 fsi_2018_ss_ki6 fsi_2018_ss_ki7 fsi_2018_ss_ki8 fsi_2018_ss_ki9 fsi_2018_ss_ki10 fsi_2018_ss_ki11 fsi_2018_ss_ki12 fsi_2018_ss_ki13 fsi_2018_ss_ki14 fsi_2018_ss_ki15 fsi_2018_ss_ki16 fsi_2018_ss_ki17 fsi_2018_ss_ki18 fsi_2018_ss_ki19 fsi_2018_ss_ki20 cthi_19 cthi_19_rank cthi_19_gsw cthi_19_hs cthi_19_hs_hi1
foreach number of numlist 1 2 to 20 {
replace fsi_2018_ss_ki`number'=100*fsi_2018_ss_ki`number'
}
export excel using "C:\Users\miros\Desktop\Dropbox\Research\1910 TJN\20191202 Data for Lucas.xlsx", firstrow(variables) replace

*20190417 Terka
use "$CYB/countryYearBase final.dta", clear
label variable nctr_taxf "Nominal corporate tax rate. Source: Tax Foundation, 201904."
keep country year country_iso3 country_iso2 gdp_final gdppc_final WGI* dev_weo2015 class_devgroup_weo2015 dev_status_un nctr_oecd nctr_kpmg nctr_tradingeconomics nctr_taxf nctr_cbt1 nctr_cbt2 nctr_final ectr_gjt eactr_cbt emctr_cbt fsi_2018_ss fsi_2018_gsw fsi_2018
save "C:/Users/miros/Desktop/Dropbox/Research/1711 GAUK Tax-motivated transfer pricing/Data/Corporate tax rates.dta", replace

*20190310 Corporate tax rates for Markus
use "$CYB/countryYearBase final.dta", clear
keep country year nctr_oecd nctr_kpmg nctr_tradingeconomics nctr_final ectr_avg_spec_oecd included_in_cthi
rename ectr_avg_spec_oecd ectr_oecd
gsort -included_in_cthi year country   
br if year>2016

*20190531 Shadow economy estimates for Enrico Ceretti
use "$CYB/countryYearBase final.dta", clear
keep country year country_iso3 shadow_alm shadow_elgin shadow_schneider
save "C:/Users/miros/Desktop/Shadow economy data for Enrico.dta", replace

*20190614 CTHI HS for Tomáš Vysušil
use "$CYB/countryYearBase final.dta", clear
keep country cthi*
save "C:/Users/miros/Desktop/Dropbox/Research/1805 CTHI/BCTHI/2a) 190614 CTHI19 results.dta", replace
export delimited using "C:/Users/miros/Desktop/Dropbox/Research/1805 CTHI/BCTHI/2b) 190614 CTHI19 results.csv", replace

*20190626 Refined FDI approach Lukáš Nepivoda
use "$CYB/countryYearBase final.dta", clear
keep country year country_iso3 in_fdiincome_bop in_fdiincome_eq_bop in_fdiincome_debt_bop nctr_oecd nctr_kpmg nctr_tradingeconomics nctr_taxf nctr_cbt1 nctr_cbt2 nctr_final lacitr_cthi_2018 lacitr_final gdp_wb gdp_un gdp_cia gdp_final population_wb population_final income_wb_LI_2017 income_wb_LMI_2017 income_wb_UMI_2017 income_wb_HI_2017 income_wb region_final region_EAP region_ECA region_LAC region_MENA region_NA region_SA region_SSA
saveold "C:/Users/miros/Desktop/Dropbox/Theses IES/Vedení/2019 Nepivoda Lukáš FDI ROR and tax rates/countryYearBase pro Lukáše.dta", replace version(12)

*20191030 CTHI LACIT for Tomáš Vysušil
use "$CYB/countryYearBase final.dta", clear
keep if year==2018 & included_in_cthi_19==1
rename lacitr_cthi_2018 lacitr_cthi_2019
keep country included_in_cthi_19 lacitr_cthi_2019
export delimited using "C:/Users/miros/Desktop/Dropbox/Research/1805 CTHI/BCTHI/191030 CTHI19 LACIT.csv", replace
*/
}


