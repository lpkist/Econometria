using StatFiles, DataFrames, Statistics

dados = DataFrame(load("C:/Users/Lucas/Documents/econometria/lista1/meap01.dta"))

#a) Encontre os maiores e menores valores de math4.

print("O maior valor é ",findmax(dados[:,"math4"])[1], ", enquanto o menor valor é ")
print(findmin(dados[:,"math4"])[1], "\n")

#b) Quantas escolas têm a taxa de aprovaçñao em matemática de exatamente 50%?
print("Há ", nrow(filter(row -> row.math4 == 50, dados)), " escolas com a taxa de aprovação exatamente 50%.", "\n")

#c) Compare as taxas médias de aprovação em matemática e leitura. Qual teste tem
#aprovação mais dificil?
print("A média de aprovação em matemática é ", round(mean(dados[:,"math4"]), digits = 2), ".", "\n")
print("Por outro lado, a média de aprovação em leitura é ", round(mean(dados[:, "read4"]), digits = 2),".", "\n")
materias = ["matemática", "leitura"]
print("Assim, a matéria mais fácil de passar é ", materias[1 + (mean(dados[:,"math4"])<mean(dados[:,"read4"]))], ".\n")

#d) Encontre a correlação entre math4 e read4. O que pode concluir?
print("A correlação é ", round(cor(dados[:, "math4"], dados[:, "read4"]), digits = 2),".\n")

#e) A variável exppp são os gatos por aluno. Econtre o exppp médio e seu desvio padrão.
print("A média é ", round(mean(dados[:, "exppp"]), digits = 2), " enquanto o desvio padrão é ",
 round(std(dados[:, "exppp"]), digits = 2), ".\n")

#f) Suponha que a escola A gaste USD$6.000 por estudante e a escola B gaste
#USD$5.500 por estudante. Com que percentual os gastos da escola A superam
#os da escola B? Compare isso a 100 × [log(6.000) − log(5.500)], que é a diferença
#percentual aproximada baseada na diferença dos logaritmos.
print(round(100*(log(6)-log(5.5)), digits = 2), " é o percentual que os gastos superam.\n")


######### Questão 2