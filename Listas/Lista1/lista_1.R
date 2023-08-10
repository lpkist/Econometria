library(tidyverse)
library(haven)
library(wooldridge)
## Questão 1
dados <- read_dta('meap01.dta')
dados <- meap01
glimpse(dados)

# a) Encontre os maiores e menores valores de math4.
c('Máximo' = max(dados$math4), 'Mínimo' = min(dados$math4))

# b) Quantas escolas têm a taxa de aprovação em matemática de exatamente 50%?
dados %>% filter(math4 == 50) %>% nrow()

# c) Compare as taxas médias de aprovação em matemática e leitura. Qual teste tem
# aprovação mais dificil?
c('Matemática' = mean(dados$math4), 'Leitura' = mean(dados$read4))
    # Leitura é mais difícil


# d) Encontre a correlação entre math4 e read4. O que pode concluir?
cor(dados$math4, dados$read4)
  # Há correlação positiva forte entre as variáveis

#   e) A variável exppp são os gatos por aluno. Econtre o exppp médio e seu desvio padrão.
c('Média' = mean(dados$exppp), 'sd' = sd(dados$exppp))

# f) Suponha que a escola A gaste USD$6.000 por estudante e a escola B gaste
# USD$5.500 por estudante. Com que percentual os gastos da escola A superam
# os da escola B? Compare isso a 100 × [log(6.000) − log(5.500)], que é a diferença
# percentual aproximada baseada na diferença dos logaritmos.
100*(log(6000)-log(5500))
100*(6000-5500)/5500

###### Questão 2
dados2 <- econmath
glimpse(dados2)

# a) Quantos estudantes estão na amostra? Quantos estudantes declaram ter frequen-
#   tado um curso de economia no ensino médio?
nrow(dados2)
sum(dados2$econhs)
   
#   b) Encontre a nota média dos alunos que frequentaram um curso de economia do
# ensino médio. Como se compara com a nota média daqueles que não o fizeram?
dados2 %>% group_by(econhs) %>% summarise(mean(score)) # É maior

#   c) Os resultados encontrados dizem necessariamente alguma coisa sobre o efeito causal
# de cursar economia no ensino médio sobre o desempenho no curso universitário?
#   (explique)
# Não, correlação não implica em causalidade


# d) Se quiser obter uma boa estimativa causal do efeito de fazer um curso de economia
# no ensino médio utilizando a diferença de médias, que experiência faria?
  # Selecionar um grupo de pessoas com características tão semelhantes quanto
  # possíveis e atribuir aleatoriamente metade para um curso de economia no
  # ensino médio e, posteriormente, medir o efeito na diferença das médias




