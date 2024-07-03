# Estimação de Dados em Painel
>Esse documento procura demonstrar o processo de estimação de dados em painel, usando como base o livro *Econometric Analysis of Cross Section and Panel Data, Second Edition, de Jeffrey M. Wooldridge*. Todas as bases utilizadas nesse código poder ser encontradas nesse repositório, para quaisquer dúvidas consultar a obra citada acima.

## Pooled Cross Section
#### 1) Primeiro Exemplo 

Carregar Base -> FERTIL1.DTA

Nessa base temos uma combinação de cortes transversais

```r
#criando variável, sugestão do autor
gen age2=age^2 
#fazendo regressão
reg kids educ age age2 black east northcen west farm othrural town smcity
```
*Resultados*:

![novo1](https://github.com/HenrySchall/Stata/assets/96027335/d3220d18-ff9e-411b-bb54-ea5f619a4f99)

Nessa regressão temos 1.129 observações, se quissemos saber quantas observações temos
em cada ano dariamos:

```r
sort year
by year: tab kids
#kids é nossa variável dependente, poderiamos pegar qualquer variável
```
![novo2](https://github.com/HenrySchall/Stata/assets/96027335/5672bab5-815c-4333-8893-a009961878b2)

Pegando os anos de 72 e 74 como exemplo. Podemos ver que no ano de 72, obtivemos 156 entrevistas 
e no ano de 74 obtivemos 173 entrevistadas, se somarmos os demais anos iremos obter as 1.129 observações.
Nosso modelo é significativo, porque temos Prob > F = 0.0000 . Todavia, nem todas nossas variáveis são
significativas ao nível de significância de 10%.

kids| Coefficient|P>(t)  
:---:|:---:|:---:
educ|-.1428788|0.000    
age|.5624223|0.000     
age2|-.0060917|0.000    
black|.977559|0.000    
east|.2362931|0.078    
northcen|.3847487|0.002   
west|.2447027|0.147    
farm|-.054186|0.715    
othrural|-.1670751|0.346   
town|.0842369|0.503    
smcity|.1830768|0.259   
_cons|-8.487543|

- educ = É significativa e possui efeito *negativo* na variável dependente, ou seja, mulheres mais educadas, controlado
pelas outras variáveis, tem menos filhos ou o aumento de uma unidade na variável educação, controlado pelos outros fatores, levá a uma diminuição de 14,28% nos níveis de fecundidade. 
- age = É significativa e possui efeito *positivo* na variável dependente
- age2 = É significativa e possui efeito negativo na variável dependente
- black = É significativa e possui efeito positivo na variável dependente
- east = É significativa e possui efeito positivo na variável dependente
- northcen = É significativa e possui efeito positivo na variável dependente
- west = Não é significativa
- farm = Não é significativa
- othrural = Não é significativa
- town = Não é significativa
- smcity = Não é significativa

Essa base nos permite fazer diversas indagações, sobre o efeito da fecundidade em cada ano, por exemplo será que y76 é maior que y80?. Por isso usaremos dummies estruturais temporais, buscando ver o efeito causal isolado de cada ano.

```r
reg kids educ age age2 black east northcen west farm othrural town smcity y74 y76 y78 y80 y82 y84
```
![Captura de tela 2023-10-26 090141](https://github.com/HenrySchall/Stata/assets/96027335/a46f4f3b-7e82-493c-b85b-75db87e6cd54)

- y74 = Não significativa e possui efeito *positivo*
- y76 = Não significativa e possui efeito negativo
- y78 = Não significativa e possui efeito negativo
- y80 = Não significativa e possui efeito negativo
- y82 = Significativa e possui efeito negativo
- y84 = Significativa e possui efeito negativo

Como as dummies de y74,y76,y78,80 são não significativas, controlado pelos outros fatores, a fecundidade desses anos é estatisticamente igual a de y72.

Podemos ver que as dummies y82 e y84 são significativas e negativas, ou seja, controlado pelos outros fatores, existe 
uma tendência de longo prazo de queda na fecundidade e essa queda é de aproximadamente de 1/2 filho (0.522 - 0.545).

#### 2) Segundo Exemplo

Carregar base -> CPS78_85.DTA
```r
sum
```
![1](https://github.com/HenrySchall/Stata/assets/96027335/39ba4008-23ab-4681-94f1-5bc048e2d4dd)

Para analisarmos as observações em cada ano, damos: 
```r
tab year
```
![2](https://github.com/HenrySchall/Stata/assets/96027335/5ab82a94-afd5-42e9-92c5-97c0db330ab2)

```
reg lwage educ exper expersq union female
```
![3](https://github.com/HenrySchall/Stata/assets/96027335/b0f14b0e-e25d-401a-b82b-3af2b350dc1c)

Nosso modelo é significativo, porque temos Prob > F = 0.0000 e todas as variáveis são significativas estatisticamente
(P>|t| = 0.000). Pegando a variável educ como exemplo, podemos dizer que o aumento de 1 ano de educação, controlado pelos outros fatores, leva ao aumento de salário de aproximadamente 8,84%. Essa base de dados nos permite realizar várias perguntas como:

- Salários de 85 são maiores que os de 78?
- Esse efeito da educação é maior em 78 ou em 85?

Por isso novamente voltaremos à usar dummies para quantificar esse efeito

```r
reg lwage y85 educ y85educ exper expersq union female y85fem
```
As dummies multiplicativas serão usadas para testar o efeito de alteração das variáveis durante y78 e y85

![imag](https://github.com/HenrySchall/Stata/assets/96027335/689ef635-79c4-498c-94be-8dcd7e198770)

Podemos notar que a dummy de y85 não é significativa, ou seja, controlado pelos outros fatores os salários de y78 e y85
são estatisticamente iguais.

- Analisando à variável educ e y85educ. Passamos a decompor à variável, ou seja, controlado pelos outros fatores o aumento de 1 ano de estudo em y78, aumenta os salários em 7,47%, de tal forma, que no ano de y85 esse efeito é 1,85% maior (aumento do efeito de um ano para o outro, ou seja, o prêmio).

 - Analisando à variável female e y85fem. Passamos a decompor à variável, ou seja, controlado pelos outros fatores a diferença salarial em y78, é de -31,67%, de tal forma, que no ano de y85 esse efeito é 8,50% menor (31,67% - 8,50% = -23,17%, ou seja, diminuição do efeito de um ano para o outro).

#### 3) Terceiro Exemplo 
Carregar Base -> KIELMC.DTA

Nessa Base iremos ver como a instalação de um incinerador de lixo, afetou o preço dos imóveis em uma região de Massachusetts

```r
tab year
```
![imag1](https://github.com/HenrySchall/Stata/assets/96027335/d87c5f90-9086-4f4d-b5b1-054c694dedda)

```r
sum
```
![Imag2](https://github.com/HenrySchall/Stata/assets/96027335/d7b26c71-825c-414c-b976-bfa2ae16608c)

```r
#pegando o preço dos imóveis e regredindo com a dummy de localização em 81
reg rprice nearinc if year==1981
```
![imag3](https://github.com/HenrySchall/Stata/assets/96027335/71990ee0-1ecd-4ff4-9e1b-4f4f634ac1d7)

Nosso modelo será significativo do ponto de vista global e a nossa variável nearinc é significativa e negativa, ou seja, em
81, os imóveis que estão localizados próximos a construção do centro de tratamento de lixo possuem preços menores, em média 30.688 doláres, que os imóveis afastados da construção do centro de tratamento de lixo.

- Pergunta: *Essa diferença de preço é causada pela construção do centro de tratamento de lixo?*

```r
#pegando o preço dos imóveis e regredindo com a dummy de localização em 78
reg rprice nearinc if year==1978
```

![imagg](https://github.com/HenrySchall/Stata/assets/96027335/9ad2b6c6-aa1a-4621-81c7-abc58a9f17a4)

Nossa resposta será __*Não*__. Porque vemos o mesmo efeito em 78, muito antes da construção do centro de 
tratamento de lixo. Sendo assim os preço são mais baixos, porque muito possívelmente estamos analisando
uma região menos privilegiada da cidade. Então o efeito real da construção do centro de tratamento de lixo, será a diferença entre os anos y81 e y78, ou seja, 18.824 - 30.688 = 11.864 doláres -> estimador diferenças e indiferenças.

- Todavia esse processo não é nem um pouco prático, então como podemos realizar essa estimação diretamente?

![IMAGES](https://github.com/HenrySchall/Stata/assets/96027335/90d8cbfb-69b6-4513-825f-ae3ad6d0bd66)

```r
reg rprice y81 nearinc y81nri
# note que: y81 = dummy de 81 / nearinc = dummy de localização / y81nri = multiplicação das dummies 
```
![IMAGES](https://github.com/HenrySchall/Stata/assets/96027335/216e6461-362c-4512-83ec-13722622fc6b)

Observa-se que a variável foi dada como não significativa, nesse caso o autor recomenda acrescentar mais variáveis ao modelo (como no exemplo abaixo). Como é apenas um exemplo para demostrar o funcionamento do estimador desconsideramos esse resultado. 

```R
reg rprice y81 nearinc y81nrinc age agesq intst land area rooms baths
```
![ddd](https://github.com/HenrySchall/Stata/assets/96027335/ce010449-0a4e-4d44-9622-e1e8c07a439a)

- O que aconteceria de usássemos log price (lprice)? Teriamos resultados muito diferentes? (Experimente tentar)

#### 4) Quarto Exemplo
Carregar Base -> INJURY.DTA

Resumo base: Em julho de 80 havia um limite para recebimento de auxilio compensação por acidente de trabalho, em relação a renda dos indivíduos, sendo que indivíudos com renda superior ao limite, não recebiam compensação. Após julho de 80, esse limite foi elevado. Qual será o impacto da mudança?

```R
reg ldurat afchnge highearn afhigh
# afchnge = dummy pós período (1 = indivíduos afastados pós novo legislação e 0 = caso contrário)
# highearn = dummy de tratamento (1 = Individuos com renda acima do limite da legislação antiga e 0 = caso contrário)
# afhigh = dummy de interação
```
![imagess](https://github.com/HenrySchall/Stata/assets/96027335/5272cd4f-d043-4609-9255-99db6c4bb4fd)

- afchnge = é não significativa e positiva, ou seja, controlado pelos outros fatores, pós nova legislação não há mudança na duração do afastamento para os indivíduos de renda baixa, porque os afetados são apenas os indivíduos de renda alta. 
- afhigh = é significativa e positiva, ou seja, controlado pelos outros fatores, após a mudança da legislação, os indivíduos que tinham renda mais alta (não eram contemplados pela compensação), passaram à se afastar um período muito maior, cerca de 18% no tempo de duração de afastamento.

```R
reg ldurat afchnge highearn afhigh male married indust injtype
```
![ddddffe](https://github.com/HenrySchall/Stata/assets/96027335/f85820d6-3649-41e6-848c-bebe1f1033c8)

## Painel Verdadeiro 
### Estimador de Primeiras Diferenças
#### Exemplo 
Carregar Base -> CRIME2.DTA

Resumo base: Taxas de criminalidade para os mesmos munícipios americanos em 87 e 82. 
- crmrte = taxa de crime
- unem = desemprego

```R
# Mesma equação descrita na parte teórica
reg crmrte d87 unem
```
![001](https://github.com/HenrySchall/Stata/assets/96027335/adb966a2-9498-4ec7-97d4-9f4bf2c904a4)

unem foi dada como não significativa (resultado contrário ao da literatura), então: 
- há variáveis omitidas no erro
- elas são coorrelacionadas com unem

Então não posso estimar por MQO (viesado), vou usar estimador de primeiras diferenças.

```R
# ccrmrte e cunem = são as primeiras diferenças das variáveis
reg ccrmrte cunem
```
![00202](https://github.com/HenrySchall/Stata/assets/96027335/4ad5cd49-2833-46e5-9809-bd9d3f2181fb)

**Atenção** -> Mudança na interpretação das variáveis

- Vemos claramente que nosso modelo passou a ser significativo, assim como a variável unem.
- Interpretação _cons (intercepto) -> Condicionado pelas outras variavies explicativas iguais a 0, a variação da variável dependente é igual a 15.4 pontos perceutais, ou seja, mesmo com o desemprego não variando, ocorre um aumento nas ocorrências de crimininalidade de 82 para 87 em 15.4 ocorrências para cada grupo de 1000 habitantes.
- Interpretação unem -> Quando o desemprego varia em um ponto percentual, a ocorrência de criminalidade aumenta (varia positivamente) em 2.2 ocorrências para cada grupo de 1000 habitantes.

### Estimador de Efeitos Fixos
#### Exemplo 
Carregar Base -> Jtrain.DTA

Resumo Base: Acompanhamento de 54 empresas, as mesmas durantes os três anos, mostrando a taxa de descarte dos seus produtos, num cenário onde há subsídio governamental para treinamento de funcionários.

- lscrap = taxa de descarte
- grant = subsídio para treinamento dummy para 89
- grant_1 = subsídio para treinamento dummy para 88
- fcode = é o código da empresa

```R
# estimando sem o efeito fixo
reg lscrap d88 d89 grant grant_1
```
![2323fdefef](https://github.com/HenrySchall/Stata/assets/96027335/7de73d72-f916-495f-9ca0-be913a8e0f5e)

grant e grant_1 são positivos, mas não significativos. Então existe alguma coisa omitida no erro, o que leva a estimação via MQO ser viesada. Por exemplo, poderiamos dizer que existe diferenças entre as empresas na forma que os descartes são feitos, ou seja, poderiamos considerar esse fator como um efeito fixo (FE).

```R
# identificando para o stata a presença de um painel, monstrando qual variável será o "i" e quando varipavel será o "t"
iis fcode # variável i 
tis year # variável t
```

```R
# Estimando com o efeito fixo
xtreg lscrap d88 d89 grant grant_1, fe
```
![1212343](https://github.com/HenrySchall/Stata/assets/96027335/9b67a60e-00a6-4fbd-92f7-c0259b61a83c)

- Nosso modelo é significativo do ponto de vista global (Prob > F = 0.0001)
- Controlado por outos fatores as taxas de descarte de 88 não são diferentes de em 89 estatiscamente falando
- As taxas de descarte de 88, controlado por outros fatores, são menores do que em 89
- Subsídios, controlado por outros fatores, reduz a taxa de descarte
- Controladas por outros fatores, os subsidios diminuem as taxas de descarte

#### Método Alternativo -> LSDV (Least Squares Dummy Variable)

```R
tabulate fcode, generate(dum)
```

```R
xtreg lscrap d88 d89 grant grant_1 dum*
```

### Estimador de Efeitos Aleatório
#### Exemplo
Carregar Base -> WAGEPAN.DTA"

Legenda de variáveis:
- ui -> ai
- eit -> uit
- sigma_u -> desvio padrão do efeito fixo (ai)
- sigma_e -> desvio padrão do componente endiossincráico (uit)
- rho -> correlação intraclasse do erro v (composto) ou devido ao ai.
- r2_o -> quadrado do coeficiente de correlação entre valores observados e ajustados (ignorando ai) para variabilidade nas duas dimensões.
- r2_b -> quadrado do coeficiente de correlação entre valores observados e ajustados (ignorando ai) para variabilidade entre grupos.
- r2_w -> quadrado do coeficiente de correlação entre valores observados e ajustados (ignorando ai) para variabilidade intra grupos.
- theta -> lambda

```R
# Sem Efeito Fixo (Ai) -> MQO
reg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, vce(cluster nr)
# vce(cluster nr) -> controle de heterocedasticidade
```
![imagem_1](https://github.com/HenrySchall/Stata/assets/96027335/cd19d5e9-7a60-4095-a23f-8a857d5e036c)

```R
# Efeito Fixo (FE)
iis nr
tis year
xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87,fe vce(cluster nr)
```
![imagem3](https://github.com/HenrySchall/Stata/assets/96027335/abe459b8-70e0-46b5-858f-6a1345aee3a7)

```R
# Efeito Aleatório (RE)
xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, re vce(cluster nr) theta
```
![imagem2223](https://github.com/HenrySchall/Stata/assets/96027335/a2510f48-27db-4936-9465-e008b3ff97b8)

##### Gerar Tabela Comparativa 
```R
# MQO
quietly regress lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, vce(cluster nr) 
estimates store OLS
# quietly é para não apresentar os resultados
```

```R
# Efeito Fixo (FE)
quietly xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, fe vce(cluster nr)
estimates store FE
```

```R
# Efeito Aleatório (RE)
quietly xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, re vce(cluster nr)
estimates store RE
```

```R
# Gerar Tabela Conjunta
estimates table OLS FE RE, b se t stats(N r2 r2_o r2_b r2_w sigma_u sigma_e rho theta)
```
- *A questão é, qual o melhor modelo?*

##### Realizando os testes
Fazer nessa ordem ajuda na interpretação
1) Breusch and Pagan Lagrangian multiplier test for random effects

- Hipótese nula (H0): var(ai) = 0
- Hipótese alternativa (H1): var(ai) ≠ 0
- A rejeição da hipótese nula indica que MQO agrupado não é o modelo apropriado, pois a estrutura de variabilidade dos erros compostos é sigma2. RE é escolha entre eles

```R
xtreg lwage exper expersq union married, re vce(cluster nr) theta
```
![1234454](https://github.com/HenrySchall/Stata/assets/96027335/2f6dff05-d704-4bb6-93dd-1bdaadd72acc)

```R
xttest0
```
![232344](https://github.com/HenrySchall/Stata/assets/96027335/4df14706-da14-49c8-89a7-ec318f806bfd)

- prob > chibar2 = 0 -> hipótese nula rejeitada (inferior a nível de significância de 10%), a variância de ui é diferente de zero, melhor especificação não é MQO Agrupado.
- **Então RE é preferida a MQO Agrupado**

2) Teste F de Chow (Teste de igualdade de interceptos e inclinações do POLS).

> Ele estima uma equação auxiliar, em que se analisa o efeito de um variável explicativa, influenciando a variável dependente, de modo diferente para cada indivíduo, ou seja, é como se eu cria-se uma dummy para cada indivíduo e multiplicasse pela variável explicativa selecionada e ao realizar um teste de hipótese em conjunto (teste de Chow), se os parâmetros forem em conjunto estatisticamente significativos, não há igualdade entre os interceptos, então há efeitos específicos para cada indivíduo.

- Hipótese nula (H0): Há igualdade de interceptos e inclinações para todos os "is"
- Hipótese alternativa (H1): Não há igualdade de interceptos e inclinações para todos os "is"
- A rejeição da hipótese nula indica que os parâmetros são diferentes entre indivíduos, desta forma FE é preferível à MQO Agrupado.

```R
# não pode haver nada depois do fe, se não ele não entrega o teste
xtreg lwage exper expersq union married, fe
```
![4556](https://github.com/HenrySchall/Stata/assets/96027335/d3bd6aa6-3e40-4a6c-9666-b21a5413435d)

- Note que há dois testes um em cima e outro em baixo, o primeiro é a significância global do modelo e o segundo o teste de Chow.
- p-valor > F = 0 -> rejeito H0 (menor que o nível de significância)
- **Então FE é preferida a MQO Agrupado**

Primeiro teste sugeriu RE o segundo FE, nos dois casos a solução de agrupadamento foi descartada. Então qual devo escolher FE ou RE?

3) Teste de Hausman
> Ele é usado para comparar modelos, para verificar se há diferença sistemática nos parâmentros estimados entre os modelos, com o o bjetivo deselecionar o modelo mais parcimonioso.

- Hipótese nula (H0): Diferença nos coeficientes não é sistemática -> EA é consistente (heterogeneidade aleatória)
- Hipótese alternativa (H1): Diferença nos coeficientes é sistemática -> EA não é consistente (homogeneidade aleatória)
- A rejeição da hipótese nula indica que FE é melhor que RE

```R
# Etapa 1 -> Estimar com o Efeito Fixo
xtreg lwage exper expersq union married, fe 
```
![imagem10](https://github.com/HenrySchall/Stata/assets/96027335/020fd7c6-33af-4dfe-b624-b30ba2edbea6)

```R
# guardando resultados
estimates store FE2
# note que eu dei o nome de FE2, pois já havia usado FE anteriormente
```
```R
# Etapa 2 -> Estimar com o Efeito Aleatório
xtreg lwage exper expersq union married, re
```
![Imagem20](https://github.com/HenrySchall/Stata/assets/96027335/66cd46b5-9ca9-4bb5-ab57-1b0b36471ad7)

```R
# Rodando Teste
hausman fixed 
```
![teste](https://github.com/HenrySchall/Stata/assets/96027335/47de4428-6051-485d-9efd-78e4540a2a29)

- P > chi2 = 0 -> menor que o nivel de significancia, ou seja, rejeita H0
- A especificação correta é FE

