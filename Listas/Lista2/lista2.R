library(wooldridge)
library(tidyverse)
# O conjunto de dados BWGHT contêm informações de nascimentos 
# nos Estados Unidos. As duas variáveis de interesse são bwght 
# (peso do recém-nascido em onças) e cigs (número médio de cigarros
# que a mãe fumou por dia durante a gravidez). Regrida bwght sobre 
# cigs e responda às seguintes perguntas:
modelo <- lm(bwght ~ cigs, bwght)
summary(modelo)

# a) Qual é o peso do nascimento previsto quando cigs = 0? 
# E quando cigs = 20?
predict(modelo, data.frame(cigs = c(0,20)))
data.frame("cigs" = c(0,20), "pred" = predict(modelo, data.frame(cigs = c(0,20))))

#   b) O MRLS necessariamente captura uma relação causal entre o 
# peso do nascimento da criança e os hábitos de fumar da mãe?
#### Não, porque podem existir outros fatores que influenciam o peso 
#### do nascimento que não foram incluídos no modelo

#   c) Para prever um peso de nascimento de 125 onças, qual deveria
# ser a magnitude de cigs?
(125 - modelo$coefficients[[1]])/modelo$coefficients[[2]]
# De fato,
predict(modelo, data.frame(cigs = c((125 - modelo$coefficients[[1]])/modelo$coefficients[[2]])))
# Entretanto, não é factível fumar um número negativo de cigarros


#   d) Verifique qual a proporção de mulheres que não fumaram durante 
# a gravidez na amostra. Sua conclusão no item anterior muda?
str_c(round((bwght %>% filter(cigs == 0) %>% nrow())/nrow(bwght)*100,2),"%")
# Sim, porque o número de pessoas que não fumou é muito maior, influenciando 
# fortemente no ajuste do modelo

