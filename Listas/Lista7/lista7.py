import wooldridge
import statsmodels.formula.api as smf
import statsmodels.api as sm
import numpy as np
from scipy import stats
# 1. Utilize o dataset ceosal1 do pacote wooldridge e ajuste o modelo
# 
# log(wage) = β0 + β1 log(sales) + β2 roe + β3 rosneg + u,
# 
# em que rosneg é uma dummy que é igual a um se ros < 0 e zero caso contrário. Aplique o teste RESET e verifique se existe alguma evidência de má-especificaçñao da forma funcional da equação. [ros: retorno sobre o capital das empresas]
ceosal1 = wooldridge.data("ceosal1")

modelo = smf.ols(formula = 'np.log(salary)~np.log(sales)+roe+ros<0', data = ceosal1).fit()
modelo.params
ceosal1['fit'] = modelo.fittedvalues
mod_reset = smf.ols(formula = 'np.log(salary)~np.log(sales)+roe+ros<0+I(fit**2)+I(fit**3)', data = ceosal1).fit()
mod_reset.params
sm.stats.anova_lm(modelo, mod_reset)
# não há evidências para rejeitar H0, ou seja, não há má especificação da forma funcional



# 2. Você e seu colega estão trabalhando com o dataset hprice1 do pacote wooldridge. Depois de várias análises, chegam nos seguintes modelos:
# Modelo 1: log(price) = β0 + β lotsize + β2 sqrft + β3 bdrms + u.
# 
# Modelo 2: log(price) = β0 + β1 log(lotsize) + β2 log(sqrft) + β3 bdrms + u.

# Você e seu colega querem saber se algum dos modelos está mal-especificado. Utilize o teste de Davidson-MacKinnon para saber se existe ou não má-especificação da forma funcional em alguns dos modelos. Preferiria algum modelo frente ao outro? Compare os resultados com os obtidos em sala de aula com o teste de Mizon e Richard.
hprice1 = wooldridge.data("hprice1")
mod1 = smf.ols(formula = 'np.log(price) ~ lotsize + sqrft + bdrms', data = hprice1).fit()
mod2 = smf.ols(formula = 'np.log(price) ~ np.log(lotsize) + np.log(sqrft) + bdrms + mod1.fittedvalues', data = hprice1).fit()
mod2.f_test(np.array([0,0,0,0,1])) # não rej H0
mod3 = smf.ols(formula = 'np.log(price) ~ np.log(lotsize) + np.log(sqrft) + bdrms', data = hprice1).fit()
mod4 = smf.ols(formula = 'np.log(price) ~ lotsize + sqrft + bdrms + mod3.fittedvalues', data = hprice1).fit()
mod4.f_test(np.array([0,0,0,0,1])) # rejeita H0
# Ou seja, há má especificação da forma funcional do modelo 1. Logo, prefiro o modelo 2.
mod5 = smf.ols(formula = 'np.log(price) ~ lotsize + sqrft + bdrms + np.log(lotsize) + np.log(sqrft)', data = hprice1).fit()
sm.stats.anova_lm(mod1, mod5) # rejeito H0, ou seja, há evidências de que os logs são significativos e o modelo 1 está mal especificado
sm.stats.anova_lm(mod3, mod5) # não rejeito H0, ou seja, o modelo 2 não está mal especificado.


# 3. Seja o modelo de interesse: 
#   log(wage) = β0 + β1 educ + β2 exper + β3 tenure + β4married+ β5 south + β6urban + β7 black + β8abil + β9 educ ∗ abil + u.
# 
# Contudo, abil é não observada e precisamos utilizar alguma variável proxy. Utilize o dataset wage2 para ajustar o modelo.

#a. Use a variável QI como proxy para abil. Qual o retorno estimado para a educação nesse caso?

modeloQ3a = smf.ols(formula = 'np.log(wage) ~ educ + exper + tenure + married + south + urban + black + IQ + I(educ*IQ)', data = wage2).fit()
modeloQ3a.params
modeloQ3a.params[1]

# b. Use a variável KWW (conhecimento do mundo do trabalho) como proxy para abil. Qual o retorno estimado para a educação nesse caso?
modeloQ3b = smf.ols(formula = 'np.log(wage) ~ educ + exper + tenure + married + south + urban + black + KWW + I(educ*KWW)', data = wage2).fit()
modeloQ3b.params
modeloQ3b.params[1]


# c. Use QI e KWW juntas como proxy para abil. O que acontece com o retorno estimado para a educação?
modeloQ3c = smf.ols(formula = 'np.log(wage) ~ educ + exper + tenure + married + south + urban + black + KWW + IQ + I(educ*IQ) + I(educ*KWW)', data = wage2).fit()
modeloQ3c.params
modeloQ3c.params[1]


# d. Iq e KWW sao individuasmf.olsente significativas? Elas sao conjuntamente
# significativas?
sm.stats.anova_lm(modeloQ3a, modeloQ3c) # KWW é
sm.stats.anova_lm(modeloQ3b, modeloQ3c) # IQ é
modeloQ3d = smf.ols(formula = 'np.log(wage) ~ educ + exper + tenure + married + south + urban + black', data = wage2).fit()
sm.stats.anova_lm(modeloQ3d, modeloQ3c) # conjuntamente são
