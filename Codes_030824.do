
clear
*directory
cd "E:\ResearchProject\Jamal Sir\ECEP Factors"

******************************************************************************** 
*DATA MERGE 
********************************************************************************

use "wm" , clear
sort HH1 HH2 LN
save "wm" , replace

use "bh" , clear
sort HH1 HH2 LN
save "bh" , replace

use "hh" , clear
sort HH1 HH2
save "hh" , replace

use "ch" , clear
sort HH1 HH2 LN
save "ch" , replace

merge using wm.dta
tab _merge
keep if _merge == 3
save "ch" , replace
drop _merge

merge using hh.dta
tab _merge
keep if _merge == 3
save "ch" , replace
drop _merge

merge using bh.dta
tab _merge
keep if _merge == 3
save "ch" , replace
drop _merge


********************************************************************************
*WEIGHT, STRATA, CLUSTER VARIABLE FOR THE APPENDED DATA
********************************************************************************
gen wgt=chweight
svyset [pw=wgt],psu(HH1) strata(stratum)


********************************************************************************
*Inclusion and Exclusion
********************************************************************************
#age by month

keep if CAGE_11>=4
svy: tab CAGE_11


##ECEP1 creation
*Early Childhood Education Program.

svy: tab UB6
gen ECEP1=UB6
recode ECEP1 1=1
recode ECEP1 2=0
recode ECEP1 9=.
label define ECEP1 1 "Yes" 0 "No"
label values ECEP ECEP1
tab ECEP1
svy: tab ECEP1, count
svy: tab ECEP1


#Stunned

tab HAZ2
recode HAZ2 99.97 = .
recode HAZ2 99.98 = .
recode HAZ2 99.99 = .
tab HAZ2
generate Stunned1   = .
replace  Stunned1   = 1 if (HAZ2 <= -2) 
replace  Stunned1  = 0 if (HAZ2 > -2) & (HAZ2 <.) 
label define Stunned1 1 "Yes" 0 "No"
label values Stunned Stunned1
tab Stunned1

#ARI

generate ari = .
replace ari = 1 if CA17 == 1  & CA18 == 1| CA18 == 3
replace ari = 0 if CA17 == 2 | CA18 == 2
label define ari3 1 "Yes" 0 "No"
label values ari ari3
svy: tab ari

#fever
svy: tab CA14
gen FVR=CA14
recode FVR 1=1
recode FVR 2=0
recode FVR 8=.
label define FVR 1 "Yes" 0"No"
label values FVR FVR
tab FVR

**********************************************************************
**Crosstab****************************************************************
***********************************************************************
#Age

svy: tab CAGE_11
tab CAGE_11 ECEP1, row
svy: tab CAGE_11, count
svy: tab CAGE_11
svy: tab CAGE_11 ECEP1, count cellwidth(12) format(%12.3g) row



#children's sex

svy: tab BH3
tab BH3 ECEP1, row
svy: tab BH3, count
svy: tab BH3
svy: tab BH3 ECEP1, count cellwidth(12) format(%12.3g) row



#Place of residance

label values Area HH6
svy: tab HH6
tab HH6 ECEP1, row
svy: tab HH6, count
svy: tab HH6
svy: tab HH6 ECEP1, count cellwidth(12) format(%12.3g) row



#Division

svy: tab HH7
tab HH7 ECEP1, row
svy: tab HH7, count
svy: tab HH7
svy: tab HH7 ECEP1, count cellwidth(12) format(%12.3g) row



#Mother's education

svy: tab melevel
tab melevel ECEP1, row
svy: tab melevel, count
svy: tab melevel
svy: tab melevel ECEP1, count cellwidth(12) format(%12.3g) row


#Wealth index 

svy: tab windex5
recode windex5 0=.
tab windex5 ECEP1, row
svy: tab windex5, count
svy: tab windex5
svy: tab windex5 ECEP1, count cellwidth(12) format(%12.3g) row

  
*Religion.
svy: tab HC1A
gen Religion1=HC1A
recode Religion1 1=1
recode Religion1 2/7=0
recode Religion1 9=.
label define Religion1 1 "Islam" 0"Others"
label values Religion Religion1
svy: tab Religion
tab Religion ECEP1, row
svy: tab Religion, count
svy: tab Religion
svy: tab Religion ECEP1, count cellwidth(12) format(%12.3g) row

*household sex.
svy: tab HHSEX
tab HHSEX ECEP1, row
svy: tab HHSEX, count
svy: tab HHSEX
svy: tab HHSEX ECEP1, count cellwidth(12) format(%12.3g) row

#Ethnicity Of HH
*ethnicity.
svy: tab ethnicity
tab ethnicity ECEP1, row
svy: tab ethnicity, count
svy: tab ethnicity
svy: tab ethnicity ECEP1,count cellwidth(12) format(%12.3g) row


#Mother's age at the time of survey

*Mother Age.
svy: tab WAGE
gen WA4=WAGE
recode WA4 1=0
recode WA4 2/5=1
recode WA4 6/7=2
label define WA4 0 "15-19" 1 "20-34" 2 "35+"
svy: tab WA4
tab WA4 ECEP1, row
svy: tab WA4, count
svy: tab WA4
svy: tab WA4 ECEP1, count cellwidth(12) format(%12.3g) row

*Mother Stimulation.
tab EC5AA
generate MS1    = 0
replace  MS1    = 1 if (EC5AA == "A")
replace  MS1    = 1 if (EC5BA == "A") 
replace  MS1    = 1 if (EC5CA == "A") 
replace  MS1    = 1 if (EC5DA == "A") 
replace  MS1    = 1 if (EC5EA == "A") 
replace  MS1    = 1 if (EC5FA == "A") 
label define MS1 1 "Yes" 0 "No"
svy: tab MS1
tab MS1 ECEP1, row
svy: tab MS1, count
svy: tab MS1
svy: tab MS1 ECEP1, count cellwidth(12) format(%12.3g) row

*Father Stimulation.
generate FS1    = 0
replace  FS1    = 1 if (EC5AB == "B") 
replace  FS1    = 1 if (EC5BB == "B") 
replace  FS1    = 1 if (EC5CB == "B")  
replace  FS1    = 1 if (EC5DB == "B")  
replace  FS1    = 1 if (EC5EB == "B")  
replace  FS1    = 1 if (EC5FB == "B") 
label define FS1 1 "Yes" 0 "No"
svy: tab FS1
tab FS1 ECEP1, row
svy: tab FS1, count
svy: tab FS1
svy: tab FS1 ECEP1, count cellwidth(12) format(%12.3g) row

*Other Stimulation.
generate OS1    = 0
replace  OS1    = 1 if (EC5AX == "X") 
replace  OS1    = 1 if (EC5BX == "X") 
replace  OS1    = 1 if (EC5CX == "X")  
replace  OS1    = 1 if (EC5DX == "X")  
replace  OS1    = 1 if (EC5EX == "X")  
replace  OS1    = 1 if (EC5FX == "X") 
label define OS1 1 "Yes" 0 "No"
svy: tab OS1
tab OS1 ECEP1, row
svy: tab OS1, count
svy: tab OS1
svy: tab OS1 ECEP1, count cellwidth(12) format(%12.3g) row 

*Inadequate supervision.
recode EC3A 8=.
recode EC3A 9=.
recode EC3B 8=.
recode EC3B 9=.
generate IS1    = .
replace  IS1    = 0 if (EC3A == 0) 
replace  IS1    = 1 if (EC3A == 1) 
replace  IS1    = 1 if (EC3A == 2) 
replace  IS1    = 1 if (EC3A == 3) 
replace  IS1    = 1 if (EC3A == 4)
replace  IS1    = 1 if (EC3A == 5)  
replace  IS1    = 1 if (EC3A == 6) 
replace  IS1    = 1 if (EC3A == 7)

replace  IS1    = 0 if (EC3B == 0) 
replace  IS1    = 1 if (EC3B == 1) 
replace  IS1    = 1 if (EC3B == 2) 
replace  IS1    = 1 if (EC3B == 3) 
replace  IS1    = 1 if (EC3B == 4)
replace  IS1    = 1 if (EC3B == 5)  
replace  IS1    = 1 if (EC3B == 6) 
replace  IS1    = 1 if (EC3B == 7)

tab IS1
label define IS1 1 "Yes" 0 "No"
label values IS IS1
svy: tab IS
tab IS ECEP1, row
svy: tab IS, count
svy: tab IS
svy: tab IS ECEP1, count cellwidth(12) format(%12.3g) row 


*Books.
svy: tab EC1
gen Books1=EC1
recode Books1 0=0
recode Books1 1/10=1
recode Books1 99=.
label define Books1 1 "Yes" 0 "No"
label values Books Books1
svy: tab Books
tab Books ECEP1, row
svy: tab Books, count
svy: tab Books
svy: tab Books ECEP1, count cellwidth(12) format(%12.3g) row 


*Toys.
recode EC2A 8=.
recode EC2A 9=.
recode EC2B 8=.
recode EC2B 9=.
recode EC2C 8=.
recode EC2C 9=.
replace  Toys1    = 0 if (EC2A == 2) 
replace  Toys1    = 1 if (EC2B == 1)
replace  Toys1    = 0 if (EC2B == 2)  
replace  Toys1    = 1 if (EC2C == 1)  
replace  Toys1    = 0 if (EC2C == 2) 
label define Toys1 1 "Yes" 0 "No"
label values Toys Toys1
svy: tab Toys
tab Toys ECEP1, row
svy: tab Toys, count
svy: tab Toys
svy: tab Toys ECEP1, count cellwidth(12) format(%12.3g) row 



*Mass Media.
recode MT1 9=.
recode MT2 9=.
recode MT3 9=.
generate MM1    = .
replace  MM1    = 0 if (MT1 == 0) 
replace  MM1    = 1 if (MT1 == 1) 
replace  MM1    = 1 if (MT1 == 2) 
replace  MM1    = 1 if (MT1 == 3) 
replace  MM1    = 0 if (MT2 == 0)
replace  MM1    = 1 if (MT2 == 1)  
replace  MM1    = 1 if (MT2 == 2) 
replace  MM1    = 1 if (MT2 == 3)
replace  MM1    = 0 if (MT3 == 0)  
replace  MM1    = 1 if (MT3 == 1) 
replace  MM1    = 1 if (MT3 == 2) 
replace  MM1    = 1 if (MT3 == 3)
label define MM1 1 "Yes" 0 "No"
label values MM MM1
svy: tab MM
tab MM ECEP1, row
svy: tab MM, count
svy: tab MM
svy: tab MM ECEP1, count cellwidth(12) format(%12.3g) row 



*Child Punishment.
recode UCD2A 9 = .
recode UCD2B 9 = .
recode UCD2C 9 = .
recode UCD2D 9 = .
recode UCD2E 9 = .
recode UCD2F 9 = .
recode UCD2G 9 = .
recode UCD2H 9 = .
recode UCD2I 9 = .
recode UCD2J 9 = .
recode UCD2K 9 = .
generate CPU1    = 0
replace  CPU1    = 1 if (UCD2A == 1) 
replace  CPU1    = 0 if (UCD2A == 2) 
replace  CPU1    = 1 if (UCD2B == 1) 
replace  CPU1    = 0 if (UCD2B == 2) 
replace  CPU1    = 1 if (UCD2C == 1) 
replace  CPU1    = 0 if (UCD2C == 2) 
replace  CPU1    = 1 if (UCD2D == 1) 
replace  CPU1    = 0 if (UCD2D == 2) 
replace  CPU1    = 1 if (UCD2E == 1) 
replace  CPU1    = 0 if (UCD2E == 2) 
replace  CPU1    = 1 if (UCD2F == 1) 
replace  CPU1    = 0 if (UCD2F == 2) 
replace  CPU1    = 1 if (UCD2G == 1) 
replace  CPU1    = 0 if (UCD2G == 2) 
replace  CPU1    = 1 if (UCD2H == 1) 
replace  CPU1    = 0 if (UCD2H == 2) 
replace  CPU1    = 1 if (UCD2I == 1) 
replace  CPU1    = 0 if (UCD2I == 2) 
replace  CPU1    = 1 if (UCD2J == 1) 
replace  CPU1    = 0 if (UCD2J == 2) 
replace  CPU1    = 1 if (UCD2K == 1) 
replace  CPU1    = 0 if (UCD2K == 2)  
label define CPU1 1 "Yes" 0 "No"
svy: tab CPU1
tab CPU1 ECEP1, row
svy: tab CPU1, count
svy: tab CPU1
svy: tab CPU1 ECEP1, count cellwidth(12) format(%12.3g) row 


#Diarrhoea

svy: tab CA1
gen DIA=CA1
recode DIA 1=1
recode DIA 2=0
recode DIA 9=.
recode DIA 8=.
label define DIA 1 "Yes" 0 "No"
label values DIA DIA
svy: tab DIA
tab DIA ECEP1, row
svy: tab DIA, count
svy: tab DIA
svy: tab DIA ECEP1, count cellwidth(12) format(%12.3g) row 


#fever
svy: tab CA14
gen FVR=CA14
recode FVR 1=1
recode FVR 2=0
recode FVR 8=.
label define FVR 1 "Yes" 0 "No"
label values FVR FVR
svy: tab FVR
tab FVR ECEP1, row
svy: tab FVR, count
svy: tab FVR
svy: tab FVR ECEP1, count cellwidth(12) format(%12.3g) row  


##ECEP1 * ARI
drop ari 
generate ari = .
replace ari = 1 if CA17 == 1  & CA18 == 1| CA18 == 3
replace ari = 0 if CA17 == 2 | CA18 == 2
label define ari3 1 "Yes" 0 "No"
label values ari ari3
svy: tab ari
tab ari ECEP1, row
svy: tab ari, count
svy: tab ari
svy: tab ari ECEP1,count cellwidth(12) format(%12.3g) row 




#EarlyChildhood Deases 
*Early Childhood Disease.
recode CA1 8=.
recode CA1 9=.
recode CA1 2=0
recode CA14 8=.
recode CA14 9=.
recode CA14 2=0
recode CA16 8=.
recode CA16 9=.
recode CA16 2=0
gen ED3 = CA1 + CA14 + CA16
recode ED3 0=0
recode ED3 1/3=1
svy: tab ED3
gen ED1=ED3
label define ED1 1 "Yes" 0 "No"
svy: tab ED1
tab ED1 ECEP1, row
svy: tab ED1, count
svy: tab ED1
svy: tab ED1 ECEP1, count cellwidth(12) format(%12.3g) row 


#Underweight

*Weight for Age underweight.
tab WAZ2
recode WAZ2 99.97 = .
recode WAZ2 99.98 = .
recode WAZ2 99.99 = .
tab WAZ2
generate underweight1    = .
replace  underweight1    = 1 if (WAZ2 <= -2) 
replace  underweight1   = 0 if (WAZ2 > -2) & (WAZ2 <.) 
label define underweight1 1 "Yes" 0 "No"
label values underweight underweight1
svy: tab underweight
tab underweight ECEP1, row
svy: tab underweight, count
svy: tab underweight
svy: tab underweight ECEP1, count cellwidth(12) format(%12.3g) row 

#Stunned
*Height for Age Stunned.
tab HAZ2
recode HAZ2 99.97 = .
recode HAZ2 99.98 = .
recode HAZ2 99.99 = .
tab HAZ2
generate Stunned1    = .
replace  Stunned1    = 1 if (HAZ2 <= -2) 
replace  Stunned1    = 0 if (HAZ2 > -2) & (HAZ2 <.) 
label define Stunned1 1 "Yes" 0 "No"
label values Stunned Stunned1
svy: tab Stunned
tab Stunned ECEP1, row
svy: tab Stunned , count
svy: tab Stunned 
svy: tab Stunned ECEP1, count cellwidth(12) format(%12.3g) row 

*Weight for Age Wasted.
tab WHZ2
recode WHZ2 99.97 = .
recode WHZ2 99.98 = .
recode WHZ2 99.99 = .
tab WHZ2
generate Wasted1    = .
replace  Wasted1    = 1 if (WHZ2 <= -2) 
replace  Wasted1    = 0 if (WHZ2 > -2) & (WHZ2 <.) 
label define Wasted1 1 "Yes" 0 "No"
label values Wasted Wasted1
svy: tab Wasted
tab Wasted ECEP1, row
svy: tab Wasted, count
svy: tab Wasted
svy: tab Wasted ECEP1, count cellwidth(12) format(%12.3g) row 

#overweight

*Weight for Age Overweight.
generate Overweight1    = .
replace  Overweight1    = 1 if (WHZ2 >= 2) 
replace  Overweight1    = 0 if (WHZ2 < 2)
label define Overweight1 1 "Yes" 0 "No"
label values Overweight Overweight1
svy: tab Overweight
tab Overweight ECEP1, row
svy: tab Overweight, count
svy: tab Overweight
svy: tab Overweight ECEP1, count cellwidth(12) format(%12.3g) row 

#sanitation

*Type of toilet facility.
svy: tab WS11
gen TF1=WS11
recode TF1 11/23=0
recode TF1 31/95=1
recode TF1 96=3
recode TF1 99=.
label define TF1 0 "improved" 1 "unimproved" 2 "other"
label values TF TF1
svy: tab TF
tab TF ECEP1, row
svy: tab TF, count
svy: tab TF
svy: tab TF ECEP1, count cellwidth(12) format(%12.3g) row 



*Salt Iodization.
svy: tab SA1
gen SI2=SA1
recode SI2 1=0
recode SI2 2=1
recode SI2 3=1
recode SI2 4=0
recode SI2 6=0
recode SI2 9=.
label define SI2  1 "Yes" 0 "No"
svy: tab SI2
tab SI2 ECEP1, row
svy: tab SI2, count
svy: tab SI2
svy: tab SI2 ECEP1, count cellwidth(12) format(%12.3g) row 






************************************
******Univariate Logistic Regression
*************************************

*****************
***All Variables
*****************
#CAGE_11(age) BH3(children sex)  HH6(Place of residance) HH7(Division) melevel(Mothers education level)
windex5(Wealth index) Religion(Religion of HH) HHSEX(Household head sex) ethnicity(ethnicity of household head)
WA4(Mother Age) ED1(Early Childhood Disease) underweight Stunned1(stunned) Wasted(Weight for Age Wasted) Overweight(Weight for Age Overweight)
TF(Type of toilet facility) MS1(Mother Stimulation) FS1(Father Stimulation) OS1(Other Stimulation)
 IS(Inadequate supervision) Toys SI2(Salt Iodization) Books MM(Mass Media) CPU1(Child Punishment)
ari FVR(Fever) DIA(Diarrhoea) 

#No total variable 28


**************************
****Significant + Not significant variables
**************************
svy: logit ECEP1 i.CAGE_11, or
svy: logit ECEP1 ib2.BH3, or
svy: logit ECEP1 ib2.HH6, or
svy: logit ECEP1 i.HH7, or
svy: logit ECEP1 i.melevel, or
svy: logit ECEP1 i.windex5, or
svy: logit ECEP1 i.Religion, or
svy: logit ECEP1 ib2.HHSEX, or
svy: logit ECEP1 ib2.ethnicity, or
svy: logit ECEP1 ib2.WA4, or
svy: logit ECEP1 i.MS1, or
svy: logit ECEP1 i.FS1, or
svy: logit ECEP1 i.OS1, or
svy: logit ECEP1 ib1.IS, or
svy: logit ECEP1 i.Books, or
svy: logit ECEP1 i.Toys, or
svy: logit ECEP1 i.MM, or
svy: logit ECEP1 i.CPU1, or

svy: logit ECEP1 ib1.DIA, or
svy: logit ECEP1 i.FVR, or
svy: logit ECEP1 i.ari, or
svy: logit ECEP1 i.ED1, or
svy: logit ECEP1 ib1.underweight1, or
svy: logit ECEP1 ib1.Stunned1, or
svy: logit ECEP1 i.Wasted, or
svy: logit ECEP1 i.Overweight, or
svy: logit ECEP1 ib1.TF, or
svy: logit ECEP1 i.SI2, or



********************************************************************************
**Multivariate Logistic regression
********************************************************************************
  
svy: logit ECEP1 i.CAGE_11 ib2.HH6 i.HH7 i.melevel i.windex5 ib2.ethnicity ib2.WA4 i.MS1 ib1.IS i.Books ib1.DIA i.ari ib1.underweight1 ib1.Stunned1 i.Wasted, or

logit ECEP1 i.CAGE_11 ib2.HH6 i.HH7 i.melevel i.windex5 ib2.ethnicity ib2.WA4 i.MS1 ib1.IS i.Books ib1.DIA i.ari ib1.underweight1 ib1.Stunned1 i.Wasted, or
lroc

logit ECEP1 CAGE_11 HH6 HH7 melevel windex5 ethnicity WA4 MS1 IS Books DIA ari underweight1 Stunned1 Wasted

lroc
predict c
roctab ECEP1 c

net sj 17-4 gr0071
net install gr0071
net get gr0071
ssc install moremata
calibrationbelt

estat gof

estat classification

lsens