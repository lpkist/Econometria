{python}
# O conjunto de dados BWGHT contêm informações de nascimentos 
# nos Estados Unidos. As duas variáveis de interesse são bwght 
# (peso do recém-nascido em onças) e cigs (número médio de cigarros
# que a mãe fumou por dia durante a gravidez). Regrida bwght sobre 
# cigs e responda às seguintes perguntas:
import wooldridge
import statsmodels.api as sm
import pandas as pd
bwght = wooldridge.data("bwght")
preditoras = sm.add_constant(bwght.cigs)
modelo = sm.OLS(bwght.bwght, preditoras).fit()
print(modelo.summary())


# a) Qual é o peso do nascimento previsto quando cigs = 0? 
# E quando cigs = 20?
print("Se cigs = 0, a predição é de",modelo.predict(pd.DataFrame({"const":[1], "cigs":[0]}))[0])

print("Já para cigs = 20, a predição é de", modelo.predict(pd.DataFrame({"const":[1], "cigs":[20]}))[0])


#   b) O MRLS necessariamente captura uma relação causal entre o 
# peso do nascimento da criança e os hábitos de fumar da mãe?
#### Não, porque podem existir outros fatores que influenciam o peso 
#### do nascimento que não foram incluídos no modelo

#   c) Para prever um peso de nascimento de 125 onças, qual deveria
# ser a magnitude de cigs?
print((125 - modelo.params[0])/modelo.params[1])
# De fato,
print(modelo.predict([1,(125 - modelo.params[0])/modelo.params[1]]))
# Entretanto, não é factível fumar um número negativo de cigarros


#   d) Verifique qual a proporção de mulheres que não fumaram durante 
# a gravidez na amostra. Sua conclusão no item anterior muda?
print(100*round(bwght[bwght.cigs == 0].shape[0]/bwght.shape[0],4), "%")
# Sim, porque o número de pessoas que não fumou é muito maior, influenciando 
# fortemente no ajuste do modelo