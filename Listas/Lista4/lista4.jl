using WooldridgeDatasets, GLM, DataFrames, Distributions

# 3. O dataset rdchem contém informação de 32 empresas da industria química. Entre as in-
#   formações coletadas, temos: rdintens (gastos com pesquisa e desenvolvimento como uma
#   porcentagem das vendas), sales (vendas mensuradas em mlhões de dólares) e profmarg
#   (lucros como uma porcentagem das vendas). Ajuste um modelo da forma
#         rdintens = β0 + β1 log(sales) + β2profmarg + u.
# Assumindo que as hipóteses do modelos linear clássico acontecem:
#   a) Interprete o coeficiente de log(sales).
rdchem = DataFrame(wooldridge("rdchem"))
modelo3 = lm(@formula(rdintens ~ log(sales) + profmarg), rdchem)
print("Um aumento das vendas em 1% aumenta em ", round(coef(modelo3)[2]/100, digits = 4), " unidade o valor de rdintens.")


# b) Teste a hipóteses de que a intensidade de P&D não varia com sales contra a alter-
#   nativa de que P&D aumenta com as vendas.
### Ou seja, testar beta1 = 0 x beta>0
print("\n")
print(round(1 - cdf.(TDist(dof_residual(modelo3)), coef(modelo3)[2]/stderror(modelo3)[2]), digits = 5))
print("\n")

# c) Interprete o coeficiente de profmarg, ele é economicamente grande?
print("O aumento de profmarg em uma unidade eleva o valor de rdintens em ",
             round(coef(modelo3)[3], digits = 4), ". Ele não é economicamente grande (0,05% por unidade de aumento).\n")
print("Além disso, a amplitude dos valores de profmarg é 35, o que representa uma variação de apenas 1,75% ao todo.\n")
findmax(rdchem.profmarg)[1]-findmin(rdchem.profmarg)[1]

# d) profmarg tem um efeito estatisticamente significativo sobre rdintens?
print("\nO p-valor é de ", round(2*cdf.(TDist(dof_residual(modelo3)), -abs(coef(modelo3)[3])/stderror(modelo3)[3]) ,digits = 5), ", o que não traz evidências estatisitcamente significativas de que o coeficiente seja significativo.\n")





# 4. Utilizando o dataset gpa1, ajuste um modelo que explique a nota média em um curso
# superior (colGPA) utilizando o número de faltas às aulas por semana (skipped), horas de
# estudo semanais (hsGPA) e a nota do ACT (equivalente ao vestitubular). Assumindo
# que as hipóteses do modelo linear clássico acontecem:
# a) Encontre um intervalo de confiança 95% para βhsGPA.
gpa1 = DataFrame(wooldridge("gpa1"))
modelo4 = lm(@formula(colGPA ~ skipped + hsGPA + ACT), gpa1)
coef_4a = coef(modelo4)[3]
sd_4a = stderror(modelo4)[3]
print("\n(", coef_4a + quantile(TDist(dof_residual(modelo4)), 0.025)*sd_4a, ";" , coef_4a + quantile(TDist(dof_residual(modelo4)), 0.975)*sd_4a,").\n")


# b) Teste H0∶ βhsGPA = 0.4 vs. H1∶ βhsGPA ≠ 0.4
2*cdf.(TDist(dof_residual(modelo4)), -abs(coef_4a-0.4)/sd_4a) # não rejeita H0
 
# c) Você pode rejeitar a hipóteses H0∶ βhsGPA = 1 contra a alternativa bilateral?
2*cdf.(TDist(dof_residual(modelo4)), -abs(coef_4a-1)/sd_4a) # Sim, rejeita H0

# d) Teste a hipótese nula de que, uma vez tendo sido controlado as horas de estudo
# semanais, o efeito de skipped e ACT sobre colGPA são, conjuntamente, nulos.
modelo4d = lm(@formula(colGPA ~ hsGPA), gpa1)
ftest(modelo4d.model, modelo4.model)# rejeita H0


 # 5. Utilize o conjunto de dados wage2 e ajuste a regressão
# log(wage) = β0 + β1 educ + β2 exper + β3 tenure + u,
# em que wage é o salario-hora em dolares, educ são os anos de educação formal, exper são
# os anos de experiência no mercado de trabalho e tenure são os anos de permanencia no
# emprego atual.
wage2 = DataFrame(wooldridge("wage2"))
modelo5 = lm(@formula(log(wage) ~ educ + exper + tenure), wage2)
# a) Teste a hipótede de significância geral do modelo.
print(ftest(modelo5.model), "\n") # rejeita H0 (é significante)

# b) Teste a hipótese de que um ano a mais de experiência no mercado de trabalho tem o
# mesmo efeito sobre log(wage) que mais um ano de permanencia no emprego atual.
wage2.aux = wage2.tenure + wage2.exper
ftest(lm(@formula(log(wage)~educ+aux), wage2).model, modelo5.model)
# não rejeita

# c) Teste a hipótese de que, controlado o número de anos de permanencia no emprego
# (tenure), educ e exper não tem efeito nenhum sobre log(wage).
ftest(lm(@formula(log(wage) ~ tenure), wage2).model, modelo5.model) # rejeita H0



# 6. Utilize o conjunto de dados htv e ajuste a regressão
# educ = β0 + β1motheduc + β2 fatheduc + β3abil + β4abil2 + u.
htv = DataFrame(wooldridge("htv"))
modelo6 = lm(@formula(educ~motheduc + fatheduc + abil + abil^2), htv)
# a) Teste a hipóteses de que a influencia que motheduc e fatheduc exercem sobre educ
# é a mesma.
htv.aux = htv.motheduc+htv.fatheduc
ftest(lm(@formula(educ ~ aux+abil+abil^2), htv).model, modelo6.model) # não rejeita
# b) Teste a hipótese de que educ está linearmente relacionado com abil contra a alter-
#   nativa que diz que a relação é quadrática.
ftest(lm(@formula(educ~motheduc + fatheduc + abil), htv).model, modelo6.model) # rejeita
# c) Um colega de trabalho diz que o modelo educ = β0+β1abil+β2abil2+u é suficiente,
# e que tanto motheduc e fatheduc não são importantes para o modelos. Faça um teste
# de hipóteses para rejeitar ou não rejeitar a hipótese do seu colega.
ftest(lm(@formula(educ ~ abil + abil^2), htv).model, modelo6.model) # ele tá errado
