*---------------*
* Estimador DID *
*---------------*

// Base ->  CPS78_85.DTA

reg lwage y85 female exper expersq y85fem

reg lwage y85 educ exper expersq y85educ

reg lwage y85 educ y85educ exper expersq union female y85fem

*--------------------------------*
* Estimador Primeiras Diferenças *
*--------------------------------*

// Base ->  CRIME2.DTA

tab year

reg crmrte d87 unem

// ccrmrte e cunem são as primeiras diferenças das variáveis
reg ccrmrte cunem

*-----------------------*
* Estimador Efeito Fixo *
*-----------------------*

// Base ->  CRIME2.DTA

xtset fcode year

xtreg lscrap d88 d89 grant grant_1, fe

*----------------------------*
* Estimador Efeito Aleatório *
*----------------------------*

// Base ->  WAGEPAN.DTA

iis nr

tis year

xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87,re vce(cluster nr) theta

*--------------------------*
* Escolher o melhor modelo *
*--------------------------*

// Base ->  WAGEPAN.DTA

// Teste Breusch and Pagan Lagrangian multiplier test for random effects

xtreg lwage exper expersq union married, re vce(cluster nr) theta

xttest0

// Teste de Chow ou Teste F 

xtreg lwage exper expersq union married, fe

// Teste de Hausman

xtreg lwage exper expersq union married, fe 

estimates store FE

xtreg lwage exper expersq union married, re

hausman FE