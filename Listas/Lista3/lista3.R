#4. Utilize o dataset HTV, estime o modelo de regresão
# educ = β0 + β1motheduc + β2fatheduc + β3abil + β4abil2 + u
# e interprete os resultados.
library(wooldridge)
library(GGally)
library(car)
ggpairs(htv[,c("educ", "motheduc", "fatheduc", "abil")])
modelo <- lm(educ ~ motheduc + fatheduc + abil + I(abil^2), htv)
summary(modelo)
qqPlot(modelo$residuals)
shapiro.test(modelo$residuals)

