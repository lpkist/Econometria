using WooldridgeDatasets, DataFrames, GLM, Pingouin, StatsPlots
#4. Utilize o dataset HTV, estime o modelo de regresão
# educ = β0 + β1motheduc + β2fatheduc + β3abil + β4abil2 + u
# e interprete os resultados.
htv = DataFrame(wooldridge("htv"))
display(@df htv corrplot([:educ :motheduc :fatheduc :abil ], grid = false))
modelo = lm(@formula(educ ~ motheduc + fatheduc + abil + abil^2), htv)
print(modelo)
display(qqplot(Normal, residuals(modelo)))
normality(residuals(modelo), method = "shapiro")

#Interpretação dos parâmetros
# Considerando que todos os outros parâmetros se mantenham constante temos as seguintes situações:
# * Para cada ano de estudo da mãe, o tempo de educação aumenta em 0,190
# * Para cada ano de estudo do pai, o tempo de educação aumenta em 0,109
# * Como a variável "abil" está apresentada com sua versão quadrática, há uma dificuldade maior na interpretação de seu efeito na 
# variável resposta. Para isso, derivamos a equação em função da variável "abil" e obtemos (β3 + 2*β4*abil) que pelo modelo será 
# (0,4015 + 2*0,0506*abil).
# Para abil = 1 temos que o tempo de educação aumenta em 0,5027
# Para abil = 6,2637 (máximo) temos que o tempo de educação aumenta em 1,0354
# Para abil = -5,6315 (mínimo) temos que o tempo de educação diminui em 0,1684
