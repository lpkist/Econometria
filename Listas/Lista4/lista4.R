library(wooldridge)
# 3. O dataset rdchem contém informação de 32 empresas da industria química. Entre as in-
#   formações coletadas, temos: rdintens (gastos com pesquisa e desenvolvimento como uma
#   porcentagem das vendas), sales (vendas mensuradas em mlhões de dólares) e profmarg
#   (lucros como uma porcentagem das vendas). Ajuste um modelo da forma
#         rdintens = β0 + β1 log(sales) + β2profmarg + u.
# Assumindo que as hipóteses do modelos linear clássico acontecem:
#   a) Interprete o coeficiente de log(sales).
modelo3 <- lm(rdintens ~ log(sales) + profmarg, rdchem)
print(paste0("Um aumento das vendas em 1% aumenta em ", 
             round(coef(modelo3)[[2]]/100, 4), " unidade o valor de rdintens."))

# b) Teste a hipóteses de que a intensidade de P&D não varia com sales contra a alter-
#   nativa de que P&D aumenta com as vendas.
### Ou seja, testar beta1 = 0 x beta>0
round(1 - pt(summary(modelo3)$coefficients[,3][[2]], modelo3$df.residual),5)

# c) Interprete o coeficiente de profmarg, ele é economicamente grande?
print(paste0("O aumento de profmarg em uma unidade eleva o valor de rdintens em ",
             round(coef(modelo3)[[3]], 4), ". Ele não é economicamente grande (0,05% por unidade de aumento)."))
print("Além disso, a amplitude dos valores de profmarg é 35, o que representa uma variação de apenas 1,75% ao todo.")
max(rdchem$profmarg)-min(rdchem$profmarg)
# d) profmarg tem um efeito estatisticamente significativo sobre rdintens?
print(paste0("O p-valor é de ", round(summary(modelo3)$coefficients[,4][[3]], 5), ", o que não traz evidências estatisitcamente significativas de que o coeficiente seja significativo"))




# 4. Utilizando o dataset gpa1, ajuste um modelo que explique a nota média em um curso
# superior (colGPA) utilizando o número de faltas às aulas por semana (skipped), horas de
# estudo semanais (hsGPA) e a nota do ACT (equivalente ao vestitubular). Assumindo
# que as hipóteses do modelo linear clássico acontecem:
# a) Encontre um intervalo de confiança 95% para βhsGPA.
modelo4 <- lm(colGPA ~ skipped + hsGPA + ACT, gpa1)
coef_4a <- modelo4$coefficients[[3]]
sd_4a <- summary(modelo4)$coefficients[3,2]
c(coef_4a + qt(.025, modelo4$df.residual)*sd_4a, coef_4a + qt(.975, modelo4$df.residual)*sd_4a)

# b) Teste H0∶ βhsGPA = 0.4 vs. H1∶ βhsGPA ≠ 0.4
2*pt(-abs(coef_4a-0.4)/sd_4a, modelo4$df.residual) # não rejeita H0
 
# c) Você pode rejeitar a hipóteses H0∶ βhsGPA = 1 contra a alternativa bilateral?
2*pt(-abs(coef_4a-1)/sd_4a, modelo4$df.residual) # Sim, rejeita H0

# d) Teste a hipótese nula de que, uma vez tendo sido controlado as horas de estudo
# semanais, o efeito de skipped e ACT sobre colGPA são, conjuntamente, nulos.
anova(lm(colGPA ~ hsGPA, gpa1), lm(colGPA ~ hsGPA + skipped + ACT, gpa1)) # rejeita H0


# 5. Utilize o conjunto de dados wage2 e ajuste a regressão
# log(wage) = β0 + β1 educ + β2 exper + β3 tenure + u,
# em que wage é o salario-hora em dolares, educ são os anos de educação formal, exper são
# os anos de experiência no mercado de trabalho e tenure são os anos de permanencia no
# emprego atual.
modelo5 <- lm(log(wage) ~ educ + exper + tenure, wage2)
# a) Teste a hipótede de significância geral do modelo.
1 - pf(summary(modelo5)$fstatistic[[1]], summary(modelo5)$fstatistic[[2]], summary(modelo5)$fstatistic[[3]]) # rejeita H0 (é significante)

# b) Teste a hipótese de que um ano a mais de experiência no mercado de trabalho tem o
# mesmo efeito sobre log(wage) que mais um ano de permanencia no emprego atual.
library(car)
lht(modelo5, c("exper = tenure")) # não rejeita
# c) Teste a hipótese de que, controlado o número de anos de permanencia no emprego
# (tenure), educ e exper não tem efeito nenhum sobre log(wage).
anova(lm(log(wage) ~ tenure, wage2), modelo5) # rejeita H0



# 6. Utilize o conjunto de dados htv e ajuste a regressão
# educ = β0 + β1motheduc + β2 fatheduc + β3abil + β4abil2 + u.
modelo6 <- lm(educ~motheduc + fatheduc + abil + I(abil^2), htv)
# a) Teste a hipóteses de que a influencia que motheduc e fatheduc exercem sobre educ
# é a mesma.
lht(modelo6, c("motheduc = fatheduc")) # não rejeita
# b) Teste a hipótese de que educ está linearmente relacionado com abil contra a alter-
#   nativa que diz que a relação é quadrática.
summary(modelo6)$coefficients[5,4] # rejeita
# c) Um colega de trabalho diz que o modelo educ = β0+β1abil+β2abil2+u é suficiente,
# e que tanto motheduc e fatheduc não são importantes para o modelos. Faça um teste
# de hipóteses para rejeitar ou não rejeitar a hipótese do seu colega.
anova(lm(educ ~ abil + I(abil^2), htv), modelo6) # ele tá errado
