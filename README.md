<br>
<p align="center">
  <a href="https://www.uminho.pt" target="_blank"><img src="https://i.imgur.com/FXQo8OL.png" alt="Universidade do Minho"></a>
  <a href="https://www.eng.uminho.pt" target="_blank"><img src="https://i.imgur.com/WABo4st.png" alt="Escola de Engenharia"></a>
  <br><a href="http://www.dsi.uminho.pt" target="_blank"><strong>Departamento de Sistemas de Informação</strong></a>
  
  <h2 align="center">Projeto de Data Mining em R Grupo 5 TP2 - MIEGSI 2021/2022</h2>
  <br>

## Implemetação (Aplicação Web)
https://guedes.shinyapps.io/shiny/

## Introdução <a name = "intro"></a>
No âmbito da avaliação da unidade curricular de Técnicas de Inteligência Artificial na Previsão e Otimização em Sistemas Empresariais, inserida no 2º semestre do 4º ano do Mestrado Integrado em Engenharia e Gestão de Sistemas de Informação, foi proposto a elaboração de um projeto focado no suporte à gestão de um espaço comercial alvo de um projeto piloto previamente realizado por uma empresa de TI.
Todos os dados utilizados durante a elaboração do projeto foram fornecidos pelo docente, sendo estes provenientes do projeto piloto previamente elaborado por uma empresa não nomeada.
A finalidade deste projeto foca-se, inicialmente,  na previsão do valor diário de entradas no espaço comercial estudado e, posteriormente, na definição de uma estratégia de marketing para os próximos sete dias, após a indicação do dia desejado.

## Description

<p>O projeto foi realizado com o auxílio da linguagem de programação R e a metodologia CRISP-DM. Como ferramentas para a execução de código utilizamos o Jupyter Notebook para a execução e desenvolvimento das fases do CRISP-DM e o Rstudio para as tarefas de Otimização e desenvolvimento da interface gráfica.</p>

## CRISP-DM
### Business Understanding
```
O Business Understanding trata-se da fase onde explorámos a empresa em estudo de forma a consolidar os seus objetivos e o porquê de se estar a realizar um projeto de Machine Learning.
De seguida, baseando-se nos objetivos da empresa criamos os nossos objetivo de Data Mining onde vamos especificar exatamente o que queremos que o nosso algoritmo seja capaz de fazer, assim como definimos metas ideais para a gestão de sucesso.
Por fim realizamos um plano de projeto de forma a situar no tempo cada uma das fases do projeto.
No nosso caso a empresa em questão trata-se da Sony, que quer prever os ESRB_Ratings dos seus jogos antes de estes serem lançados de forma a poderem realizar campanhas de marketing de forma mais eficiente e livres de erros.
Sendo assim o nosso objetivo de Data Mining é, dado as flags de um dado jogo, prever qual será o rating que lhe será atribuído.
```
### Data Understanding 
```
Esta fase serve para nos familiarizarmos com os dados que vamos tentar prever. Isto é essencial visto que quanto mais familiarizado estivermos com os dados melhores decisões de inclusão ou exclusão de certos parâmetros iremos fazer.
Para realizar este estudo fizemos uma descrição de todos os dados disponibilizados onde explorámos aprofundadamente o que cada parâmetro do nosso dataset significava
Fizemos também uma vistoria inicial dos dados ao qual chamámos Exploração e Verificação da qualidade dos dados onde verificamos o nosso dataset para valores nulos ou outliers (valores fora da norma), a sua cardinalidade e de uma forma geral com que se parece cada tipo de dado.
```
### Data Preparation
```
A fase de Preparação dos Dados é das mais importantes, senão a mais importante em todo o projeto, sendo que é nesta fase que trancamos virtualmente o desempenho do nosso algoritmo (mesmo sem saber).
Nesta fase iremos fazer o tratamento completo aos dados de forma que estes estejam nas melhores condições para serem passados pelos modelos de Machine Learning.
Sendo assim fizemos a seleção dos atributos que consideramos relevantes para processamento nos modelos. Para isto realizamos um estudo das correlações dos atributos, quer entre si, quer com o atributo que pretendemos prever(sobretudo com o atributo que pretendemos prever). Para realizar este estudo utilizamos técnicas quer manuais (como analisar a nuvem volumétrica das relações dos atributos) quer automáticas (como analisar os resultados de um GridSearch com todos os atributos utilizando os modelos).
Esta técnica automática da seleção dos atributos resultou em criarmos 3 cenários diferentes, cada um com um grupo diferente (mas, na mesma relevante) de dados.
```
### Modeling 
```
Para o processo de modelação utilizamos a técnica de Cross Validation de forma a correr múltiplos modelos em sequência e avaliar os resultados deles.
O cross validation é uma técnica utilizada para validar a estabilidade do nosso modelo de Machine Learning. É necessário ter uma forma de garantia de que o modelo resolveu a maioria dos padrões dos dados corretamente sem captar muito ruído obtendo um modelo com alta variância (para ser consistente com todos os datasets de teste possíveis) e com baixa “pré-configuração” (bias).
Sendo assim utilizamos a técnica de cross validation para avaliar o desempenho dos nossos modelos face a dados nunca antes vistos por eles (dados de teste).
Existem várias abordagens para o cross validation porém a que iremos usar é o Stratified KFold que se trata de uma extensão do KFold especialmente para problemas de classificação.
Esta técnica permite que, em vez de as divisões do dataset serem realizadas de forma aleatória, é assegurado que a percentagem de cada classe da variável target é mantida a mesma para cada fold, assim como no dataset original. Por exemplo, a partir da etapa de Exploração dos Dados, foi possível verificar que existe uma percentagem de 37% de dados da classe T, 23% da classe E, 20% da classe M e 20% da classe ET, sendo que em cada fold irá ser preservada essa mesma percentagem de dados de cada classe.
Esta técnica de cross validation é geralmente utilizada quando se verificam duas condições, sendo elas:
    • Quando se pretende preservar a percentagem de cada classe da variável target;
    • Quando possuímos poucos dados de treino.
Posto isto, como o grupo pretende manter a percentagem de cada classe da variável target e como possuímos poucos dados de treino decidimos utilizar esta técnica de cross validation, que permite assegurar que cada fold apresenta a mesma percentagem de dados de cada classe como no dataset original, evitando o problema de algum fold não apresentar dados de uma determinada classe, o que iria prejudicar a viabilidade dos resultados do modelo.
```
### Evaluation 
```
Na avaliação dos resultados iremos analisar os resultados obtidos e retirar as conclusões que forem necessárias. Comparar os resultados obtidos com os resultados previstos/esperados é necessário para averiguar o sucesso obtido.
```

### Deployment 
```
A fase de deployment consiste em utilizar o/s modelo/s obtido/s nas fases anteriores, completos, treinados, otimizados num ambiente de produção onde os seus outputs criarão valor para a organização em questão.
Em relação ao nosso projeto iremos exportar o modelo que obtivemos através das fases anteriores do CRISP-DM, modelo este que está pronto a ser utilizado para fazer previsões de dados.
No nosso caso exportámos o modelo e utilizámo-lo, quer na previsão dos dados acima de 2019 (para poder analisar os resultados), quer na criação de uma Web API que recebe parâmetros de jogos e utiliza o modelo para prever o respetivo rating para poder enviar a resposta prevista.
```

## Getting Started

### Dependencies

* Windows 10/11, Linux, MacOS
* R instalado na máquina que irá correr
* Jupyter Notebooks (Anaconda)
* RStudio

### Usage (Jupyter Notebook)

* Clonar o repositório
```
git clone https://github.com/JoaoGuedes01/ESRB_Rating_Predictor_CRISPDM.git
```
* Iniciar o serviço do Jupyter
```
cd Jupyter
jupyter notebook
```
No final é apenas necessário navegar até ao notebook onde terá disponível todos os métodos separados convenientemente por divisões que poderá correr e explorar.

### Usage (Shiny App)

* Clonar o repositório
```
git clone https://github.com/JoaoGuedes01/ESRB_Rating_Predictor_CRISPDM.git
```

* Correr a aplicação shiny
```
cd shiny
Rscript app.R
```
<p>Esta aplicação irá importar e carregar o modelo da pasta <b>model</b> e torná-lo utilizável através de pedidos HTTP, assim como disponibilizar uma interface gráfica onde é possível experimentar o modelo.</p>
<p>Após correr o ficheiro <b>app.py</b> pode dirigir-se a <b>http://localhost:33507</b> para aceder à interface gráfica</p>


## Help

Caso tenha problemas ao correr as funções do notebook proceda à instalação dos módulos em falta utilizando o comando:
```
install.packages(<modulo_em_falta>)
```

## Authors
- [João Guedes](https://github.com/JoaoGuedes01)
- [João Teixeira](https://github.com/joaoteixeira10)
- [Manuel Ribeiro](https://github.com/ManuelRibeiro89247)
- [Tomás Lopes](https://github.com/Tomas-Lopes)

## Version History
* 0.1
    * Initial Release

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
  
## Ferramentas <a name = "built"></a>
* [R](https://www.r-project.org/)
* [R Studio](https://www.rstudio.com/)
* [Anaconda](https://www.anaconda.com/)
* [Jupyter Notebooks](https://jupyter.org/)
* [Shiny](https://shiny.rstudio.com/)
* [ShinyApps.io](https://www.shinyapps.io/)
* [Python](https://www.python.org/)



## Contactos <a name = "contact"></a>

* [João Guedes](mailto:a89237@alunos.uminho.pt)
* [João Teixeira](mailto:a89218@alunos.uminho.pt)
* [Tomás Lopes](mailto:a89223@alunos.uminho.pt)
* [Manuel Ribeiro](mailto:a89247@alunos.uminho.pt)


## Acknowledgments <a name = "ack"></a>
* [Paulo Cortez](http://www3.dsi.uminho.pt/pcortez/Home.html)

## Referências <a name = "refer"></a>

## Licensa <a name = "license"></a>
* [License](https://github.com/JoaoGuedes01/TIAPOSE_R_Data_Mining/blob/main/LICENSE)
## Repositório Front-End<a name = "Repositório Front-End"></a>
* [Aplicação](https://github.com/JoaoGuedes01/TIAPOSE_R_Data_Mining/tree/main/shiny)


Distributed under the MIT License. See `LICENSE` for more information.