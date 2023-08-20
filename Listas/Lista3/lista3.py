import wooldridge
import seaborn as sns
import statsmodels.api as sm
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import shapiro
#4. Utilize o dataset HTV, estime o modelo de regresão
# educ = β0 + β1motheduc + β2fatheduc + β3abil + β4abil2 + u
# e interprete os resultados.
htv = wooldridge.data("htv")
ggpairs_no_py = sns.PairGrid(htv[['educ', 'motheduc', 'fatheduc', 'abil']])
ggpairs_no_py.map_diag(sns.kdeplot)
ggpairs_no_py.map_offdiag(sns.scatterplot)
plt.show()

pred_aux = htv[['motheduc', 'fatheduc', 'abil']]
pred_aux['abil2'] = htv.abil**2
preditoras = sm.add_constant(pred_aux)

modelo = sm.OLS(htv.educ, preditoras).fit()
print(modelo.summary())
sm.qqplot(modelo.resid_pearson, line = '45')
plt.show()
shapiro(modelo.resid_pearson).pvalue

