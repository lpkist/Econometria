# O conjunto de dados BWGHT contêm informações de nascimentos 
# nos Estados Unidos. As duas variáveis de interesse são bwght 
# (peso do recém-nascido em onças) e cigs (número médio de cigarros
# que a mãe fumou por dia durante a gravidez). Regrida bwght sobre 
# cigs e responda às seguintes perguntas:
using WooldridgeDatasets, DataFrames, GLM
bwght = DataFrame(wooldridge("bwght"))
modelo = lm(@formula(bwght ~ cigs), bwght)

# a) Qual é o peso do nascimento previsto quando cigs = 0? 
# E quando cigs = 20?
print("Se cigs = 0, a predição é de ", round(predict(modelo, DataFrame(cigs = 0))[1], digits = 2))
print("\nJá para cigs = 20, a predição é de ", round(predict(modelo, DataFrame(cigs = 20))[1], digits = 2))

#   b) O MRLS necessariamente captura uma relação causal entre o 
# peso do nascimento da criança e os hábitos de fumar da mãe?
#### Não, porque podem existir outros fatores que influenciam o peso 
#### do nascimento que não foram incluídos no modelo

#   c) Para prever um peso de nascimento de 125 onças, qual deveria
# ser a magnitude de cigs?
print("\n",(125 - coef(modelo)[1])/coef(modelo)[2], "\n")
# De fato,
print(round(predict(modelo, DataFrame(cigs = (125 - coef(modelo)[1])/coef(modelo)[2]))[1], digits = 2))
# Entretanto, não é factível fumar um número negativo de cigarros


#   d) Verifique qual a proporção de mulheres que não fumaram durante 
# a gravidez na amostra. Sua conclusão no item anterior muda?
print("\n", 100*round(nrow(filter(row -> row.cigs == 0, bwght))/nrow(bwght), digits = 4), "%")
# Sim, porque o número de pessoas que não fumou é muito maior, influenciando 
# fortemente no ajuste do modelo




