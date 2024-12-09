* output.do
set more off
clear
set scheme sj

sjlog using calibrationbelt1, replace
use icudata
set seed 101
generate random = runiform()
sort random, stable 
generate extValidation = (_n>750)
quietly logit outcome ib3.adm ib1.chronic ib1.age ib5.gcs ///
		ib3.BP ib3.HR ib1.temp ib3.urine ib1.urea ///
		ib2.WBC ib2.potassium ib2.sodium ib3.HCO3 ///
		ib1.bili ib1.paFiIfVent if extValidation == 0
sjlog close, replace


***********************
* Internal validation *
***********************

sjlog using calibrationbelt2, replace
calibrationbelt 
sjlog close, replace
graph export calibrationbelt1.eps, replace

***********************
* External validation *
***********************

sjlog using calibrationbelt3, replace
predict phat, pr
calibrationbelt outcome phat if extValidation==1, devel("external")
sjlog close, replace
graph export calibrationbelt2.eps, replace
