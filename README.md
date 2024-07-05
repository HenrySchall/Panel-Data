# Estimação de Dados em Painel
> A estimação de dados em painel é a analise de dados que possuem uma estrutura de dois fatores, ou seja temos um fator que representa diferentes unidades (como indivíduos, empresas, países, etc.) e outro que representa diferentes períodos de tempo. Esse documento procura demonstrar o processo de estimação de dados em painel, usando como base o livro: "*Econometric Analysis of Cross Section and Panel Data, Second Edition, de Jeffrey M. Wooldridge*". Todas as bases utilizadas nesse código podem ser encontradas nesse repositório, para quaisquer dúvidas consultar a obra referenciada.

### Características Gerais
- Heterogeneidade das unidades: Cada unidade (indivíduo, empresa, país, etc.) pode ter características próprias que não variam ao longo do tempo.
- Variabilidade temporal: As variáveis podem mudar ao longo do tempo para cada unidade.
- Estrutura longitudinal: A presença de múltiplas observações para cada unidade permite analisar tanto a variabilidade dentro das unidades quanto entre elas.

> Podemos dizer que Dados em Painel subdivide-se em dois tipos: Painel Verdadeiro e Agrupadamento de Cortes Transversais. Quando temos um Painel Verdadeiro usa-se a mesma unidade de análise ao longo do tempo (todos os "is" são iguais), ou seja, em uma pesquisa por exemplo os dados serão sobre os mesmos inddvíduos ao longo do tempo. Já um Agrupadamento de Cortes Transversais os "is" não serão os mesmos entre os períodos, ou seja, em uma pesquisa os dados não serão dos mesmos indivíduos. 

### Modelos de Dados em Painel
1) Modelo de Agrupamento Cortes Transversais (Pooled Cross Section)
2) Modelo de Efeitos Fixos (FE) 
3) Modelo de Efeitos Aleatórios (RE)
4) Modelo de Efeitos Dinâmicos (GMM)

### Equação Geral 
$Yit = \beta0 + + \beta1Xit + \beta2Xit + eit$

- i = unidades específicas
- t = tempo

## Pooled Cross Section (Agrupadamento de Cortes Transversais)

#### 1º Primeiro Exemplo 

Carregar Base -> FERTIL1.DTA (número de filhos por mulher entre os anos 1974 e 1984)

```r
# Criando variável sugerida pelo autor
gen age2=age^2
```
> Primeiro passo é identificar se temos um Painel Verdadeiro ou um Pooled Cross Section, para isso precisamos descobrir quantas observações temos em cada período.

```r
sort year
```
```r
#kids variável dependente
by year: tab kids
```
![3](https://github.com/HenrySchall/Panel_Data/assets/96027335/a2594bbc-866b-4937-b75d-da9adafeeef8)

> Pegando os anos de 72 e 74 como exemplo. Podemos ver que no ano de 72, obtivemos 156 entrevistas 
e no ano de 74 obtivemos 173 entrevistadas, evidenciando que os dados não são os mesmos para cada período, temos então um Pooled Cross Section.

```r
# Fazendo a regressão por MQO Agrupado 
reg kids educ age age2 black east northcen west farm othrural town smcity y74 y76 y78 y80 y82 y84
```
![4](https://github.com/HenrySchall/Panel_Data/assets/96027335/39a5c91b-f6e0-48f3-9982-8920927dc635)

Descrição das variáveis: 
- educ = É significativa e possui efeito *negativo* na variável dependente, ou seja, mulheres mais educadas, controlado pelas outras variáveis, tem menos filhos ou o aumento de uma unidade na variável educação, controlado pelos outros fatores, levá a uma diminuição de 14,28% nos níveis de fecundidade. 
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
- y74 = Não significativa e possui efeito *positivo*
- y76 = Não significativa e possui efeito negativo
- y78 = Não significativa e possui efeito negativo
- y80 = Não significativa e possui efeito negativo
- y82 = Significativa e possui efeito negativo
- y84 = Significativa e possui efeito negativo

Observe que:
- Temos 1.129 observações
- Nosso modelo é significativo, porque temos Prob > F = 0.0000 . Todavia, nem todas nossas variáveis são
significativas ao nível de significância de 10%.
- Como as dummies de y74,y76,y78,80 são não significativas, ou seja, controlado pelos outros fatores, a fecundidade desses anos é estatisticamente igual a de y72.
- Podemos ver que as dummies y82 e y84 são significativas e negativas, ou seja, controlado pelos outros fatores, existe uma tendência de longo prazo na queda de fecundidade e essa queda é de aproximadamente de (0.522 - 0.545 = -0,023 filhos).

#### 2º Segundo Exemplo

Carregar base -> CPS78_85.DTA (Valor dos salários de 1978 e 1985)

```r
sum
```
![5](https://github.com/HenrySchall/Panel_Data/assets/96027335/61fc84b2-87a4-4f35-a41b-02861b481e67)

```r
tab year
```
![6](https://github.com/HenrySchall/Panel_Data/assets/96027335/93821b32-99df-4846-91cb-3a1fd2b66f41)

```
reg lwage educ exper expersq union female
```
![7](https://github.com/HenrySchall/Panel_Data/assets/96027335/7a8054bd-676b-4ddb-b294-4f10a9aa41fa)

- Nosso modelo é significativo, porque temos Prob > F = 0.0000 e todas as variáveis são significativas estatisticamente (P>|t| = 0.000).
- Pegando a variável educ como exemplo, podemos dizer que o aumento de 1 ano de educação, controlado pelos outros fatores, leva ao aumento de salário de aproximadamente 8,84%.
- Pegando a variável female como exemplo, podemos dizer que o fato de ser mulher, controlado pelos outros fatores, leva a uma diminuição de salário de aproximadamente 25,08%.

> Entretanto qual o efeito real sobre os salários entre 1978 e 1985, levando em conta os fatores educação e ser mulher. Ouve aumento ou diminuição no salário de 1978 em relação a 1985? No exemplo anterior realizamos a diferença entre as dummies y82 e y84, para encontrar esse efeito real, todavia uma alternativa seria utilizar-se do Estimador de Diferenças em Diferenças (DID).

### Estimador de diferença em diferenças (DID)
> Ele é uma alternativa ao Estimador MQO Agrupado, utiliza-se ele quando queremos capturar o efeito antes e depois de um evento, ou seja, de uma mudança especifica nos dados. Sua lógica é semelhante aos testes farmacêuticos, onde seleciona-se uma população amostral, no qual uma parte dessa população recebe um tratamento (grupo de tratamento) de um certo processo natural, enquanto à outra parte dessa população não recebe o tratamento (grupo de controle). Dado pela seguinte equação:

$Yit = \beta0 +\delta0D + \beta1DT + \delta1 D * DT + eit$

Onde:

$\delta0D$ = Dummy pós-evento 
- 0 = período observado anterior ao evento 
- 1 = período observado após o evento

$\beta1DT$ = Dummy de Tratamento
- 0 = não recebeu o tratamento
- 1 = recebeu o tratamento

$\delta1 D * DT$ = Dummy de Interação (diferença de receber e não receber o tratamento = DID)

Descrição das variáveis: 
- y85 -> dummy pós-evento
- female e educ -> dummy de tratamento
- y85educ e y85fem -> dummy de interação

```r
reg lwage y85 female exper expersq y85fem
```
![01](https://github.com/HenrySchall/Panel_Data/assets/96027335/830acadc-3543-4a99-ba51-52e274ce0b31)

```r
reg lwage y85 educ exper expersq y85educ
```
![02](https://github.com/HenrySchall/Panel_Data/assets/96027335/4a37671d-9641-4cc6-9f39-047c42ab6b22)

```r
# Podemos analisar os dois efeitos em conjunto, diminuindo possível multicolinealidade e aumentando os graus de liberade do modelo
reg lwage y85 educ y85educ exper expersq union female y85fem
```
![03](https://github.com/HenrySchall/Panel_Data/assets/96027335/1c141c26-d495-4e66-9375-25820dc458fe)

- A dummy de y85 não é significativa, ou seja, controlado pelos outros fatores os salários de y78 e y85 são estatisticamente iguais.

- Analisando à variável educ e y85educ. Temos que o aumento de 1 ano de estudo em y78, aumenta os salários em 7,47%, controlado pelos outros fatores. Além disso, no ano de y85 esse efeito é 1,85% maior (7,47% - 8,50% = 1,85%), ou seja, aumento do efeito de um ano para o outro)

- Analisando à variável female e y85fem. Temos que diferença salarial em y78, é de -31,67%, controlado pelos outros fatores. Além disso, no ano de y85 esse efeito é 8,50% menor (31,67% - 8,50% = -23,17%), ou seja, diminuição do efeito de um ano para o outro).

#### 3º Terceiro Exemplo 

Carregar Base -> KIELMC.DTA (Efeito da instalação de um incinerador de lixo no preço dos imóveis em uma região de Massachusetts)

```r
tab year
```
![1](https://github.com/HenrySchall/Panel-Data/assets/96027335/565abfdf-50d8-4dac-987b-ee32c129b375)

> Observa-se que não tenho um painel de dados verdadeiro

```r
sum
```
![2](https://github.com/HenrySchall/Panel-Data/assets/96027335/9f5fdf1a-8e46-4bb9-a8e1-7d8e842ce0d2)

```r
#nearinc = dummy de localização
reg rprice nearinc if year==1981
```
![3](https://github.com/HenrySchall/Panel-Data/assets/96027335/f849407f-049c-43fe-a715-552934949a35)

> Nosso modelo será significativo do ponto de vista global e a nossa variável nearinc é significativa e negativa, ou seja, em 81, os imóveis que estão localizados próximos do centro de tratamento de lixo possuem preços menores, em média US$30.688, que os imóveis afastados do centro de tratamento de lixo. Todavia será que essa diferença é causada pelo centro de tratamento de lixo?

```r
reg rprice nearinc if year==1978
```
![4](https://github.com/HenrySchall/Panel-Data/assets/96027335/98e48306-ea46-4b58-9ac7-10200695c592)

- Observa-se que a resposta é  __*Não*__. Porque vemos o mesmo efeito em 78, muito antes da instalação do centro de tratamento de lixo. Sendo assim os preço são mais baixos porque muito possívelmente estamos analisando uma região menos privilegiada da cidade.
- Então o efeito real da instalação do centro de tratamento de lixo, será a diferença entre as dummies y81 e y78 (18.824 - 30.688 = US$11.864), que seria o mesmo que estimar usando estimador DID

```r
# usando estimador DID
reg rprice y81 nearinc y81nrinc
```
![124](https://github.com/HenrySchall/Panel-Data/assets/96027335/1163ddd9-932e-412a-b33e-7ca105269504)

```r
# adicionando mais variáveis explciativas (sugestão do autor)
reg rprice y81 nearinc y81nrinc age agesq intst land area rooms baths
```
![6](https://github.com/HenrySchall/Panel-Data/assets/96027335/aa708ee2-8dcf-422f-a54c-d92f5fcb3f30)

#### 4º Quarto Exemplo
Carregar Base -> INJURY.DTA (Em julho de 1980 havia um limite para recebimento de auxilio compensação por acidente de trabalho em relação a renda dos indivíduos, sendo que indivíudos com renda superior ao limite não recebiam compensação. Após julho de 82, esse limite foi elevado)

```R
reg ldurat afchnge highearn afhigh
```
Descrição das variáveis: 
- afchnge = dummy pós período (1 = indivíduos afastados pós novo legislação e 0 = caso contrário)
- highearn = dummy de tratamento (1 = Individuos com renda acima do limite da legislação antiga e 0 = caso contrário)
- afhigh = dummy de interação

![01](https://github.com/HenrySchall/Panel-Data/assets/96027335/a39ed94c-61fc-4687-9b7f-e2f56cacaf6b)

- afchnge = é não significativa e positiva, controlado pelos outros fatores, pós nova legislação não há mudança na duração do afastamento para os indivíduos de renda baixa, porque os afetados são apenas os indivíduos de renda alta. 
- afhigh = é significativa e positiva, controlado pelos outros fatores, após a mudança da legislação, os indivíduos que tinham renda mais alta (não eram contemplados pela compensação) passaram à se afastar um período muito maior, cerca de 18% no tempo de duração de afastamento.

```R
reg ldurat afchnge highearn afhigh male married indust injtype
```
![02](https://github.com/HenrySchall/Panel-Data/assets/96027335/6bd6cd21-9abb-4b20-a372-d7e11254c69a)

## Painel Verdadeiro 
> Até então todos os exemplos se tratavam de agrupamentos de cortes transversais e para esses tipos de datasets MQO Agrupado não é viesado, entretanto quando se tem um painel verdadeiro, todos os "is" serão iguais para todos os períodos, com isso se uma das das variáveis controles tiver alguma relação com as variáveis explicativas do modelo, haverá a presença de endogeneidade, ou seja, COV (Xn,e) ≠ 0. Desta forma a estimação via MQO Agrupado será viesada, sendo assim utiliza-se outra equação geral, consideando o chamado termo de erro composto. 

#### Equação Geral 
$Yit = \beta0 + + \beta1Xit + \beta2Xit + Vit$

$Vit = ai + uit$

- Vit = termo de erro composto
- ai = efeito fixo ou heteogeneidade não observada (aquilo que não varia no tempo)
- uit = erro endossincrático (aquilo que varia no tempo)

> Efeito fixo é algo que explica Yit, sendo específico de i, todavia não varia no horizonte de tempo observado. Como o estimador MQO Agrupado é viesado, passa-se a utilizar outro estimador, o Estimador de Primeiras Diferenças (PD).

### Estimador de Primeiras Diferenças(PD)
> O Estimado de Primeiras Diferenças transforma a equação original subtraindo os valores da variável dependente e das variáveis explicativas, ou seja, todos os cortes transversais de todas as observações i durante o tempo, removendo qualquer efeito fixo que seja constante em t. Matemáticamente falando:

$Yi1 = (\beta0 + \delta0) + \beta1Xi1 + Vit$ (ai + uit)$

$Yi2 = (\beta0 + \delta0) + \beta1Xi1 + Vit$ (ai + uit)$

$(Yi2 - Yi1) = \delta0 + \beta1(Xi2 - Xi1) + (ui2 - ui1)$

$∆Yi = \delta0 + \beta1∆Xi + ∆ui$

#### 1º Primeiro Exemplo 
Carregar Base -> CRIME2.DTA (Taxas de criminalidade para os munícipios americanos em 82 e 87). 

```r
tab year
```
![Captura de tela 2024-07-03 233018](https://github.com/HenrySchall/Panel-Data/assets/96027335/c7b2aaac-fa78-45b5-a800-019fec40e083)

- crmrte = taxa de crime
- unem = desemprego
- observa-se que temos os mesmos números de observações para os anos 82 e 87, então temos um painel verdadeiro

Equação do Modelo: $ccrmrte = \beta0 +\delta0D87 + \beta1cunem + eit$

```R
reg crmrte d87 unem
```
![2](https://github.com/HenrySchall/Panel-Data/assets/96027335/dac9953a-e4c2-4d80-9e92-4e2a41d81c7a)

unem foi dada como não significativa (resultado contrário ao da literatura), então: 
- há variáveis omitidas no erro
- elas são correlacionadas com unem

Então não posso estimar por MQO (viesado), vou usar estimador de primeiras diferenças.

```R
# ccrmrte e cunem #são as primeiras diferenças das variáveis
reg ccrmrte cunem
```

![3](https://github.com/HenrySchall/Panel-Data/assets/96027335/418e4c95-d013-46b5-8c32-6a21295c567c)

- Vemos claramente que nosso modelo passou a ser significativo, assim como a variável unem.
- Interpretação _cons (intercepto) -> Condicionado pelas outras variavies explicativas iguais a 0, a variação da variável dependente é igual a 15.4 pontos perceutais, ou seja, mesmo com o desemprego não variando, ocorre um aumento nas ocorrências de crimininalidade de 82 para 87 em 15.4 ocorrências para cada grupo de 1000 habitantes.
- Interpretação unem -> Quando o desemprego varia em um ponto percentual, a ocorrência de criminalidade aumenta (varia positivamente) em 2.2 ocorrências para cada grupo de 1000 habitantes.

#### 2º Segundo Exemplo 
Carregar Base -> Jtrain.DTA (Acompanhamento de 54 empresas durante três anos, mostrando a taxa de descarte dos seus produtos, num cenário onde há subsídio governamental para treinamento de funcionários). 

Descrição das variáveis: 
- lscrap = taxa de descarte
- grant = subsídio para treinamento dummy para 89
- grant_1 = subsídio para treinamento dummy para 88
- fcode = é o código da empresa

```r
# MQO Agrupado
reg lscrap d88 d89 grant grant_1
```
![1](https://github.com/HenrySchall/Panel-Data/assets/96027335/38738c66-939f-4c2c-8270-12f809667b92)

> Ao rodar modelo via MQO Agrupado, as dummies grant e grant_1 são não significativas. Conclui-se que existe alguma coisa omitida no termo de erro que leva a uma estimação viesada via MQO Agrupado. Por exemplo, poderiamos dizer que existe diferenças entre as empresas, na forma como os descartes são feitos, isso leva a considerar a presença de um efeito fixo (FE) e obviamente a utilização do Estimador de Primeiras Diferenças.

```r
reg clscrap cgrant
```
![imag](https://github.com/HenrySchall/Panel-Data/assets/96027335/2cc76fac-b68d-4fd8-b7f0-e727f264a28f)

> Nesse caso como temos a variável fcode para indicar o número de cada firma, podemos rodar o estimador diretamente, sem precisar calcular as primeiras diferenças de cada variável, como feito no exemplo anterior

```r
# informando para o stata a presença de um painel
xtset fcode year
```
- fcode (variável i)
- year (variável t)

```r
# Primeiras Diferenças
xtreg D.(lscrap grant)
```
![imag2](https://github.com/HenrySchall/Panel-Data/assets/96027335/b190a1f5-8764-453b-950c-3bd3feddc394)

> Observa-se que o estimador de Primeiras Diferenças não retornou resultados estatísticamente significativos para as variáveis explicativas. Mas isso não significa que não temos a presença de Efeito Fixo, apenas que ele poder não ser o estimador adqueado, por isso outra alternativa para esse caso é o Estimador de Efeito Fixo (FE).

### Estimador de Efeito Fixo
> Como vimos Efeito fixo é algo que explica Yit, sendo específico de i, todavia não varia no horizonte de tempo observado, ou seja, ele controla todos os fatores que são constantes ao longo do tempo, mas que variam entre as unidades. Sendo assim, se de fato temos um efeito fixo é esperado que o valor médio da constante i seja exatamente igual a constante, ou seja, a média de ai no tempo é igual ao próprio ai. Essa suposição, permite realizar uma transformação intra-grupo (within), onde em vez de se tomar a diferença entre dois períodos, tira-se a diferença do período em realação a sua média. Matematicamente falando:

$Yit = (\beta0 + \delta0) + \beta1Xit + Vit$ (ai + uit)$

$Yit = (\beta0 + \delta0) + \beta1Xit + Vit$ (ai + \bar{uit})$

$(Yit - \bar{Yi}) = \delta0 + \beta1(Xit - \bar{Xi}) + (uit - \bar{uit})$

$\ddot{Yit} = \delta0 + \beta1\ddot{Xit} + \ddot{uit}$ -> Aplico MQO Agrupado (Não será mais viesado)

> Após essa transformação intra-grupo, teria-se um equação onde o estimador MQO Agrupado não seria mais viesado, permitindo a estimação do modelo. Mas qual a diferença entre os modelos?

#### Comparação PD x FE
- Ambos os métodos controlam para variáveis que são constantes ao longo do tempo, mas o estimador de efeitos fixos faz isso explicitamente, enquanto o método de primeiras diferenças faz isso implicitamente.
- O método de primeiras diferenças perde um período de dados devido à diferenciação, enquanto o estimador de efeitos fixos não.
- No método de efeitos fixos, variáveis que não variam ao longo do tempo não podem ser incluídas no modelo, enquanto no método de primeiras diferenças essas variáveis são eliminadas automaticamente, o que diminui os graus de liberdade, aumentando a multicolinealidade.
- Estudos mostram que em atpe t-2 período os resultados dos estimadores são idênticos, mas FE tem vantagem em relação a primeiras diferencas em paineis não balanceados.

```r
xtset fcode year
```

```R
xtreg lscrap d88 d89 grant grant_1, fe
```
![3](https://github.com/HenrySchall/Panel-Data/assets/96027335/7bc851ba-ec29-471e-a8e3-0fa3050ab947)

- Nosso modelo é significativo do ponto de vista global (Prob > F = 0.0001)
- Controlado por outos fatores as taxas de descarte de 88 não são diferentes de em 89 estatiscamente falando
- As taxas de descarte de 88, controlado por outros fatores, são menores do que em 89
- Subsídios, controlado por outros fatores, reduz a taxa de descarte
- Controladas por outros fatores, os subsidios diminuem as taxas de descarte

### LSDV (Least Squares Dummy Variable)
> O Estimador de Efeito Fixo pode ser descrito de outra forma, chamada de LSDV (Least Squares Dummy Variable), esse método consiste em incluir uma dummy ou intercepto para cada i, com isso mostra-se explicitasmente o efeito dixo de cada i. Essa metodológia possui a vantagem de possbilitar a análise do efeito fixo individual, todavia o excesso de dummies reduz os graus de liberade (diminuindo o número de observações), que podem levar a estimativas menos precisas já dividinde-se a variabilidade entre mais parâmetros. Sendo assim recomenda-se o uso desse modelo apenas quando procura-se saber o efeito fixo individual de cada i;

```R
tabulate fcode, generate(dum)
```

```R
xtreg lscrap d88 d89 grant grant_1 dum*
```

Observaçóes: 
- Paineis desbalanceados são aqueles que apresentam algum tipo de atrito nos seus dados (falta de informação em algum período), nesse caso se as variáveis explicativas estiverem correlacionadas com o termo de erro endossicrático teremos o problema de seleção amostral (solução: Estimador de Heckman).
- Demonstrando como calcular a primeira diferença de uma variável:

``` r
generate ccrmrte2 = D.crmrte
```

### Estimador de Efeitos Aleatório (RE)
> O Estimador de Efeitos Aleatório presume que as diferenças individuais são capturadas por um termo de erro específico de cada unidade, ou seja, há a presença do ai, ele é aleatório e não correlacionado com as variáveis explicativas, com isso o estimador MQO Agrupado não será viesado. Ele até pode não ser viesado (é consistente), mas ele não será eficiente, porque haverá autocorrelação serial no termo de erro composto, ou sejam o erro de um período será levado para o outro, já que o ai não é eliminado. A solução para esse problema é a realização de uma transformação de Mínimos Quadrados Generalizados (GLS), em outras palavras, uma transformação "quase na média", isso ocorre porque conhece-se a COR (Vit, Vit-1) e essa correlação está associada a variância do termo de erro endossincrático e à variância de ai. Sendo assim pode-se ponderar os Xs e o Y, pela estrutura de mudança da variância doas erros, dependendo de X, esse seria todo o processo de obtenção do estimador de Efeito Aleatório (RE). Matemáticamente falando:

![Captura de tela 2024-07-05 151452](https://github.com/HenrySchall/Panel-Data/assets/96027335/337d84de-fcad-4391-8f8b-d52f76bccc52)

- λ -> É a ponderação da estrutura de correlação serial, devido aos efeitos fixos presentes em MQO. Essa é a transformação "quase nada média", poderada por λ (estima-se o λ), em vez da transforma dentro do grupo, para cada Y e cada X de it em relação à média de i.

#### Casos: 

*λ = 1*
  
#### 1º Segundo Exemplo 
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
# MQO
reg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, vce(cluster nr)
# vce(cluster nr) -> controle de heterocedasticidade
```
![imagg1](https://github.com/HenrySchall/Panel-Data/assets/96027335/c2694844-9211-4fae-8741-3e02db132ba7)

```r
iis nr
```

```r
tis year
```

```r
# Efeito Fixo (FE)
xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87,fe vce(cluster nr)
```

![imagg2](https://github.com/HenrySchall/Panel-Data/assets/96027335/07ee40f2-59ae-4d23-9b44-850ab7ae844c)

```R
# Efeito Aleatório (RE)
xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87,re vce(cluster nr) theta
```
![imagg3](https://github.com/HenrySchall/Panel-Data/assets/96027335/8afe11f1-09c0-4fa9-a49c-79a1982770de)


##### Gerar Tabela Comparativa 
```R
# MQO
# quietly é para não apresentar os resultados
quietly regress lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, vce(cluster nr)
```

```r 
estimates store OLS
```

```R
# Efeito Fixo (FE)
quietly xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, fe vce(cluster nr)
```

```r
estimates store FE
```

```R
# Efeito Aleatório (RE)
quietly xtreg lwage black hisp exper expersq union educ married d81 d82 d83 d84 d85 d86 d87, re vce(cluster nr)
```

```r
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

