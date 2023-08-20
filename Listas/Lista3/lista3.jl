using WooldridgeDatasets, DataFrames, GLM, Pingouin, StatsPlots
#4. Utilize o dataset HTV, estime o modelo de regresão
# educ = β0 + β1motheduc + β2fatheduc + β3abil + β4abil2 + u
# e interprete os resultados.
htv = DataFrame(wooldridge("htv"))
@df dados corrplot([:educ :motheduc :fatheduc :abil ], grid = false)
modelo = lm(@formula(educ ~ motheduc + fatheduc + abil + abil^2), htv)
normality(residuals(modelo), method = "shapiro")
