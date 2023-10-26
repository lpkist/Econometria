# 1. Utilize o dataset ceosal1 do pacote wooldridge e ajuste o modelo
# 
# log(wage) = β0 + β1 log(sales) + β2 roe + β3 rosneg + u,
# 
# em que rosneg é uma dummy que é igual a um se ros < 0 e zero caso contrário. Aplique o teste RESET e verifique se existe alguma evidência de má-especificaçñao da forma funcional da equação. [ros: retorno sobre o capital das empresas]
library(wooldridge)
modelo <- lm(I(log(salary))~I(log(sales))+roe+I(as.numeric(ros<0)), ceosal1)
modelo$model
summary(modelo)
mod_reset <- lm(I(log(salary))~I(log(sales))+roe+I(as.numeric(ros<0))+I(fitted(modelo)^2)+I(fitted(modelo)^3), ceosal1)
anova(modelo, mod_reset)
# não há evidências para rejeitar H0, ou seja, não há má especificação da forma funcional



# 2. Você e seu colega estão trabalhando com o dataset hprice1 do pacote wooldridge. Depois de várias análises, chegam nos seguintes modelos:
# Modelo 1: log(price) = β0 + β lotsize + β2 sqrft + β3 bdrms + u.
# 
# Modelo 2: log(price) = β0 + β1 log(lotsize) + β2 log(sqrft) + β3 bdrms + u.

# Você e seu colega querem saber se algum dos modelos está mal-especificado. Utilize o teste de Davidson-MacKinnon para saber se existe ou não má-especificação da forma funcional em alguns dos modelos. Preferiria algum modelo frente ao outro? Compare os resultados com os obtidos em sala de aula com o teste de Mizon e Richard.

mod1 <- lm(I(log(price)) ~ lotsize + sqrft + bdrms, hprice1)
mod2 <- lm(I(log(price)) ~ I(log(lotsize)) + I(log(sqrft)) + bdrms + I(fitted(mod1)), hprice1)
summary(mod2) # não rej H0
mod3 <- lm(I(log(price)) ~ I(log(lotsize)) + I(log(sqrft)) + bdrms, hprice1)
mod4 <- lm(I(log(price)) ~ lotsize + sqrft + bdrms + I(fitted(mod3)), hprice1)
summary(mod4) # rejeita H0
# Ou seja, há má especificação da forma funcional do modelo 1. Logo, prefiro o modelo 2.
mod5 <- lm(I(log(price)) ~ lotsize + sqrft + bdrms + I(log(lotsize)) + I(log(sqrft)), hprice1)
anova(mod1, mod5) # rejeito H0, ou seja, há evidências de que os logs são significativos e o modelo 1 está mal especificado
anova(mod3, mod5) # não rejeito H0, ou seja, o modelo 2 não está mal especificado.


# 3. Seja o modelo de interesse: 
#   log(wage) = β0 + β1 educ + β2 exper + β3 tenure + β4married+ β5 south + β6urban + β7 black + β8abil + β9 educ ∗ abil + u.
# 
# Contudo, abil é não observada e precisamos utilizar alguma variável proxy. Utilize o dataset wage2 para ajustar o modelo.

#a. Use a variável QI como proxy para abil. Qual o retorno estimado para a educação nesse caso?

modeloQ3a <- lm(I(log(wage)) ~ educ + exper + tenure + married + south + urban + black + IQ + I(educ*IQ),wage2)
summary(modeloQ3a)
coef(modeloQ3a)[[2]]

# b. Use a variável KWW (conhecimento do mundo do trabalho) como proxy para abil. Qual o retorno estimado para a educação nesse caso?
modeloQ3b <- lm(I(log(wage)) ~ educ + exper + tenure + married + south + urban + black + KWW + I(educ*KWW),wage2)
summary(modeloQ3b)
coef(modeloQ3b)[[2]]


# c. Use QI e KWW juntas como proxy para abil. O que acontece com o retorno estimado para a educação?
modeloQ3c <- lm(I(log(wage)) ~ educ + exper + tenure + married + south + urban + black + KWW + IQ + I(educ*IQ) + I(educ*KWW),wage2)
summary(modeloQ3c)
coef(modeloQ3c)[[2]]


# d. Iq e KWW sao individualmente significativas? Elas sao conjuntamente
# significativas?
anova(modeloQ3a, modeloQ3c) # KWW é
anova(modeloQ3b, modeloQ3c) # IQ é
modeloQ3d <- lm(I(log(wage)) ~ educ + exper + tenure + married + south + urban + black, wage2)
anova(modeloQ3d, modeloQ3c) # conjuntamente são
