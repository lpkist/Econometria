import wooldridge
import statsmodels.formula.api as smf
import statsmodels.api as sm
import numpy as np
from scipy import stats

# 3. O dataset rdchem contém informação de 32 empresas da industria química. Entre as in-
#   formações coletadas, temos: rdintens (gastos com pesquisa e desenvolvimento como uma
#   porcentagem das vendas), sales (vendas mensuradas em mlhões de dólares) e profmarg
#   (lucros como uma porcentagem das vendas). Ajuste um modelo da forma
#         rdintens = β0 + β1 log(sales) + β2profmarg + u.
# Assumindo que as hipóteses do modelos linear clássico acontecem:
#   a) Interprete o coeficiente de log(sales).
rdchem = wooldridge.data("rdchem")
modelo3 = smf.ols(formula = 'rdintens ~ np.log(sales) + profmarg', data = rdchem).fit()
print("Um aumento das vendas em 1% aumenta em ", round(modelo3.params[1]/100, 4), " unidade o valor de rdintens.")

# b) Teste a hipóteses de que a intensidade de P&D não varia com sales contra a alter-
#   nativa de que P&D aumenta com as vendas.
### Ou seja, testar beta1 = 0 x beta>0
round(1 - stats.t.cdf(modelo3.params[1]/modelo3.bse[1], modelo3.df_resid),5)

# c) Interprete o coeficiente de profmarg, ele é economicamente grande?
print("O aumento de profmarg em uma unidade eleva o valor de rdintens em ",
             round(modelo3.params[2], 4), ". Ele não é economicamente grande (0,05% por unidade de aumento).", sep = '')
print("Além disso, a amplitude dos valores de profmarg é 35, o que representa uma variação de apenas 1,75% ao todo.")
np.max(rdchem.profmarg)-np.min(rdchem.profmarg)
# d) profmarg tem um efeito estatisticamente significativo sobre rdintens?
print("O p-valor é de ", round(modelo3.pvalues[2], 5), ", o que não traz evidências estatisitcamente significativas de que o coeficiente seja significativo", sep = '')




# 4. Utilizando o dataset gpa1, ajuste um modelo que explique a nota média em um curso
# superior (colGPA) utilizando o número de faltas às aulas por semana (skipped), horas de
# estudo semanais (hsGPA) e a nota do ACT (equivalente ao vestitubular). Assumindo
# que as hipóteses do modelo linear clássico acontecem:
# a) Encontre um intervalo de confiança 95% para βhsGPA.
gpa1 = wooldridge.data("gpa1")
modelo4 = smf.ols(formula = 'colGPA ~ skipped + hsGPA + ACT', data = gpa1).fit()
coef_4a = modelo4.params[2]
sd_4a = modelo4.bse[2]
[coef_4a + stats.t.ppf(.025, modelo4.df_resid)*sd_4a, coef_4a + stats.t.ppf(.975, modelo4.df_resid)*sd_4a]

# b) Teste H0∶ βhsGPA = 0.4 vs. H1∶ βhsGPA ≠ 0.4
2*stats.t.cdf(-abs(coef_4a-0.4)/sd_4a, modelo4.df_resid) # não rejeita H0
 
# c) Você pode rejeitar a hipóteses H0∶ βhsGPA = 1 contra a alternativa bilateral?
2*stats.t.cdf(-abs(coef_4a-1)/sd_4a, modelo4.df_resid) # Sim, rejeita H0

# d) Teste a hipótese nula de que, uma vez tendo sido controlado as horas de estudo
# semanais, o efeito de skipped e ACT sobre colGPA são, conjuntamente, nulos.
anova(lm(colGPA ~ hsGPA, gpa1), lm(colGPA ~ hsGPA + skipped + ACT, gpa1)) # rejeita H0
sm.stats.anova_lm(smf.ols('colGPA ~ hsGPA', gpa1).fit(), modelo4)

# 5. Utilize o conjunto de dados wage2 e ajuste a regressão
# log(wage) = β0 + β1 educ + β2 exper + β3 tenure + u,
# em que wage é o salario-hora em dolares, educ são os anos de educação formal, exper são
# os anos de experiência no mercado de trabalho e tenure são os anos de permanencia no
# emprego atual.
wage2 = wooldridge.data('wage2')
modelo5 = smf.ols('np.log(wage) ~ educ + exper + tenure', wage2).fit()
# a) Teste a hipótede de significância geral do modelo.
1 - stats.f.cdf(modelo5.fvalue, modelo5.df_model, modelo5.df_resid) # rejeita H0 (é significante)

# b) Teste a hipótese de que um ano a mais de experiência no mercado de trabalho tem o
# mesmo efeito sobre log(wage) que mais um ano de permanencia no emprego atual.

modelo5.f_test(np.array([0,0,1,-1])) # não rejeita
# c) Teste a hipótese de que, controlado o número de anos de permanencia no emprego
# (tenure), educ e exper não tem efeito nenhum sobre log(wage).
sm.stats.anova_lm(smf.ols('np.log(wage) ~ tenure', wage2).fit(), modelo5) # rejeita H0



# 6. Utilize o conjunto de dados htv e ajuste a regressão
# educ = β0 + β1motheduc + β2 fatheduc + β3abil + β4abil2 + u.
htv = wooldridge.data("htv")
modelo6 = smf.ols('educ~motheduc + fatheduc + abil + I(abil**2)', htv).fit()
# a) Teste a hipóteses de que a influencia que motheduc e fatheduc exercem sobre educ
# é a mesma.
modelo6.f_test(np.array([0,1,-1,0,0])) # não rejeita
# b) Teste a hipótese de que educ está linearmente relacionado com abil contra a alter-
#   nativa que diz que a relação é quadrática.
modelo6.pvalues[4]
# c) Um colega de trabalho diz que o modelo educ = β0+β1abil+β2abil2+u é suficiente,
# e que tanto motheduc e fatheduc não são importantes para o modelos. Faça um teste
# de hipóteses para rejeitar ou não rejeitar a hipótese do seu colega.
sm.stats.anova_lm(smf.ols('educ ~ abil + I(abil**2)', htv).fit(), modelo6) # ele tá errado
