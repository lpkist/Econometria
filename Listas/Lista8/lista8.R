# 1. Considere o seguinte modelo para estimar o efeito da propriedade (ou não) de um notebook no CR dos formandos da UNICAMP:
#   
#   CR = β0 + β1Notebook + u,
#   
#   em que Notebook é uma dummy que indica a propriedade (1) ou não (0) de um notebook. 
#   a. Por que a variável Notebook pode estar correlacionada com u?.

#### u contém todas as outras covariáveis que não foram incluídas no modelo. Dessa forma, `horas de estudo semanais` faz parte disso. Entretanto, espera-se que haja alguma correlação entre `horas de estudo semanais` e o CR do formando. Dessa forma, a variável Notebook pode estar correlacionada com u.

#   b. Explique por que Notebook possivelmente está relacionado à renda dos pais. Isso significa que a renda dos pais sería uma boa IV de Notebook? (justifique)

##### Alunos cujos pais tenham uma renda maior tendem a ter Notebook (pago por eles), o que explica essa possível correlação. Considerando vários estudos (https://www.estadao.com.br/educacao/cotistas-tem-nota-pior-que-os-outros-alunos-na-faculdade-pesquisas-mostram-que-nao-entenda-estudos/), não há diferença significativa entre os CRs finais devido à forma de ingresso na universidade. Como uma das principais covariáveis relacionadas à renda dos pais é a escolaridade, e não há de indícios de que ela afeta o CR, parece que a renda dos pais seja uma boa IV de notebook.

#   c. Suponha que, quatro anos atrás, a universidade tenha concedido subsídios para a compra de notebooks a, aproximadamente, metade dos alunos novos e que os alunos que receberam esses subsidios tenham sido escolhidos aleatoriamente. Explique detalhadamente como você utilizaria essa informação para construir uma IV para Notebook.

##### Eu construiria uma variável indicadora de que o aluno recebeu o notebook da universidade e a utilizaria como preditora no lugar de notebook. Como a alocação foi aleatória, é não correlacionada com o erro, mas é fortemente correlacionada com Notebook.





# 2. Suponha que queremos estimar o efeito da frequência às aulas sobre o desempenho dos alunos. Um modelo básico é
# 
# stndfnl = β0 + β1atndrte + β2priGP A + β3ACT + u,
# 
# em que stndfnl é o resutado (padronizado) na nota final, atndrte é a taxa de frequência, ACT é o American College Testing e priCPA o é “CR” do último período letivo.

# a. Defina dist como a distância da residência do aluno até a universidade. Você considera que dist e u são não correlacionados?

##### Não, porque dist está negativamente correlacionado com tempo de estudo, já que é necessário maior tempo se transportar até a universidade, o que reduz as horas disponíveis para estudar.

# b. Supondo que u e dist sejam não correlacionados, que outra hipótese dist terá que satisfazer para ser uma IV válida de atndrte?

##### dist deve ser correlacionada com atndrte (ser um instrumento relevante)


# 3. Os dados em fertil2 contém informações sobre o número de filhos, anos de escolaridade, idade e variáveis de religião e status econômico de mulheres de Botsuana durante 1988.
library(wooldridge)
# a. Estime, por MQO, o modelo
# 
# children = β0 + β1educ + β2age + β3age2 + u
# 
# Interprete os resultados (qual o efeito estimado de mais um ano de escolaridade em fertilidade? Se 100 mulheres completassem mais um ano de escolaridade, haveria uma diminuição na quantidade de filhos?)

modelo3a <- lm(children~educ+age,fertil2)
summary(modelo3a)
##### O aumento de um ano na escolaridade, descontando o efeito de age, diminui o número esperado de crianças em 0,09.
##### Se 100 mulheres completassem mais um ano de escolaridade, haveria uma diminuição na quantidade de filhos? Seria esperado que o número de filhos se reduzisse em 9.

# b. A variável frsthalt é uma dummy igual a um, caso a mulher tenha nascido durante os primeiros seis meses do ano. Assumindo que frsthalf seja não correlacionado com u. Mostre que frsthalf é um candidato razoável para IV de educ.

##### Fixando a idade das meninas, essa dummy seria correlacionada com educ no sentido de, caso a menina ainda esteja em idade escolar, se ela for igual a 1, o valor de educ será uma unidade maior do que para outra menina com a mesma idade, mas com frsthalt = 0.

# c. Estime o modelo usando frsthalf como IV para educ. Compare o efeito estimado de educação com a estimativa MQO.

library(AER)
modelo3c1 <- ivreg(children ~ educ + age | frsthalf + age, data = fertil2)
summary(modelo3c1)
modelo3c1$coefficients
modelo3a$coefficients
##### O sinal de educ se manteve, enquanto a magnitude praticamente dobro

# d. Adicione as variáveis electric, tv e bicycle ao modelo (assuma que elas são exôgenas). Estime por MQO e MQ2E e compare os coeficientes estimados para educ. Interprete o coeficiente em tv.
modelo3d1 <- lm(children~educ+age+electric+tv+bicycle,fertil2)
modelo3d2 <- ivreg(children ~ educ + age+electric+tv+bicycle | frsthalf + age+electric+tv+bicycle, data = fertil2)

modelo3d1$coefficients
summary(modelo3d1)
##### O fato de possuir tv diminui o número esperado de filhos em 0,256 em relação a meninas com as mesmas características, mas sem tv
modelo3d2$coefficients
summary(modelo3d2)
##### O fato de possuir tv diminui o número esperado de filhos em 0,004 em relação a meninas com as mesmas características, mas sem tv (praticamente não altera, tanto que não é significativa)


# 4. [Utilize os dados intdef] Uma equação simples relacioando a taxa do título do tesouro norte-americano de três meses à taxa de inflação (construida segundo o índice de preços ao consumidor) é 
# i3t = β0 + β1inft + ut.
# 
# a. Estime o modelo por MQO.
modelo4a <- lm(i3~inf, intdef)
summary(modelo4a)

# b. Alguns economistas acreditam queo índice de preços ao consumidor estima de forma errônea a verdadeira taxa de inflação (fazendo com que o modelo anterior sofra com vies de erro de medida). Reestime o modelo utilizando inf_t−1 como IV para inf_t. Compare as estimativas de β1
modelo4b <- ivreg(i3~inf|inf_1, data = drop_na(intdef))
summary(modelo4b)

modelo4a$coefficients
modelo4b$coefficients
##### O sinal se manteve, mas utilizando inf_t-1 como IV, a magnitude do coeficiente aumentou em quase 50%.

# c. Estime por MQO o seguinte modelo 
# Δi3t = β0 + β1Δinft + Δut.
# 
# Compare a estimativa de β1 com as obtidas anteriormente.
modelo4c <- lm(diff(i3) ~ diff(inf), data = intdef)
summary(modelo4c)
modelo4c$coefficients
##### O sinal permanece o mesmo, mas o coeficiente se tornou muito menos significativo e sua magnitude reduziu para um terço do modelo do item a

# d. Podemos utilizar Δinft−1 como uma VI para Δ inft? (caso afirmativo, ajuste o modelo.)
summary(lm(diff(inf)~diff(inf_1), data= intdef))
##### Não, porque não há relevância