import pyreadstat  as stat
import pandas as pd
import statistics as sts
import math

dados, meta = stat.read_dta('C:/Users/Lucas/Documents/econometria/lista 1/meap01.dta')

#a) Encontre os maiores e menores valores de math4.
print('Máximo: ', max(dados['math4']), "\n", "Mínimo: ", min(dados['math4']), sep = '')


#b) Quantas escolas têm a taxa de aprovaçñao em matemática de exatamente 50%?
print(dados[dados['math4'] == 50].shape[0])

#c) Compare as taxas médias de aprovação em matemática e leitura. Qual teste tem
#aprovação mais dificil?
print('Média de matemática: ', round(sts.mean(dados['math4']), 2), "\n", "Média de leitura: ",
       round(sts.mean(dados['read4']),2), sep = '')
materias = ['matemática', 'leitura']
print('Logo, é mais fácil passar em', materias[sts.mean(dados['math4']) < sts.mean(dados['read4'])])

#d) Encontre a correlação entre math4 e read4. O que pode concluir?
print('A correlação entre as variáveis é:', round(sts.correlation(dados['math4'], dados['read4']),2))

#e) A variável exppp são os gatos por aluno. Econtre o exppp médio e seu desvio padrão.
print('A média é ', round(sts.mean(dados['exppp']), 2), "\n",
       'O desvio-padrão é ', round(sts.stdev(dados['exppp']), 2), sep = '')
#f) Suponha que a escola A gaste USD$6.000 por estudante e a escola B gaste
#USD$5.500 por estudante. Com que percentual os gastos da escola A superam
#os da escola B? Compare isso a 100 × [log(6.000) − log(5.500)], que é a diferença
#percentual aproximada baseada na diferença dos logaritmos.
print(round(100*(math.log(6) - math.log(5.5)), 2))

######### Questão 2
dados2, meta = stat.read_dta("C:/Users/Lucas/Documents/econometria/lista 1/econmath.dta")
print(dados2.head)

#a) Quantos estudantes estão na amostra? Quantos estudantes declaram ter frequen-
#tado um curso de economia no ensino médio?
print('Há', dados2.shape[0], 'estudantes na amostra. Desses,', dados2[dados2['econhs'] == 1].shape[0],
       'fizeram um curso de economia no ensino médio.')


#b) Encontre a nota média dos alunos que frequentaram um curso de economia do
#ensino médio. Como se compara com a nota média daqueles que não o fizeram?
notas = [round(sts.mean(dados2[dados2['econhs'] == 0]['score']), 2), 
         round(sts.mean(dados2[dados2['econhs'] == 1]['score']),2)]
print('A nota média dos alunos que não fizeram um curso de economia foi', notas[0],
      'enquanto a média dos que fizeram foi', notas[1], '. Assim, a média maior é dos alunos que',
        ['','não'][notas[1] < notas[0]], 'fizeram o curso.')

#c) Os resultados encontrados dizem necessariamente alguma coisa sobre o efeito causal
#de cursar economia no ensino médio sobre o desempenho no curso universitário?
#(explique)
    #Não, correlação não implica em causalidade


#d) Se quiser obter uma boa estimativa causal do efeito de fazer um curso de economia
#no ensino médio utilizando a diferença de médias, que experiência faria?
    # Selecionar um grupo de pessoas com características tão semelhantes quanto
    # possíveis e atribuir aleatoriamente metade para um curso de economia no
    # ensino médio e, posteriormente, medir o efeito na diferença das médias
