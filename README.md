<br>
<p align="center">
  <a href="https://www.uminho.pt" target="_blank"><img src="https://i.imgur.com/FXQo8OL.png" alt="Universidade do Minho"></a>
  <a href="https://www.eng.uminho.pt" target="_blank"><img src="https://i.imgur.com/WABo4st.png" alt="Escola de Engenharia"></a>
  <br><a href="http://www.dsi.uminho.pt" target="_blank"><strong>Departamento de Sistemas de Informação</strong></a>
  
  <h2 align="center">Projeto de Data Mining em R Grupo 5 TP2 - MIEGSI 2021/2022</h2>
  <br>
  
## Índice de conteúdos

- [Índice de conteúdos](#índice-de-conteúdos)
- [Introdução <a name = "intro"></a>](#introdução-)
- [Tarefa A - Aconselhamento para compra de uma refeição <a name = "ta"></a>](#tarefa-a---aconselhamento-para-compra-de-uma-refeição-)
  - [Parte 1 - Aquisição manual de conhecimento  <a name = "ta1"></a>](#parte-1---aquisição-manual-de-conhecimento--)
  - [Parte 2 - Aquisição automática de conhecimento <a name = "ta2"></a>](#parte-2---aquisição-automática-de-conhecimento-)
  - [Pré-requisitos <a name = "pre1"></a>](#pré-requisitos-)
- [Getting started <a name = "getting1"></a>](#getting-started-)
  - [Installation  <a name = "install1"></a>](#installation--)
    - [Clone the repo](#clone-the-repo)
  - [Usage <a name = "usage1"></a>](#usage-)
- [Tarefa B - Aconselhamento de trajeto para entrega de uma refeição <a name = "tb"></a>](#tarefa-b---aconselhamento-de-trajeto-para-entrega-de-uma-refeição-)
  - [Parte 1 - Resolução via Procura <a name = "tb1"></a>](#parte-1---resolução-via-procura-)
  - [Parte 2 - Otimização do lucro, tempo ou ambos <a name = "tb2"></a>](#parte-2---otimização-do-lucro-tempo-ou-ambos-)
  - [Pré-requisitos <a name = "pre2"></a>](#pré-requisitos--1)
- [Getting started <a name = "getting2"></a>](#getting-started--1)
  - [Quick-start <a name = "quick2"></a>](#quick-start-)
    - [Clone the repo](#clone-the-repo-1)
  - [Usage <a name = "usage2"></a>](#usage--1)
- [Ferramentas <a name = "built"></a>](#ferramentas-)
- [Contactos <a name = "contact"></a>](#contactos-)
- [Acknowledgments <a name = "ack"></a>](#acknowledgments-)
- [Referências <a name = "refer"></a>](#referências-)
- [Licensa <a name = "license"></a>](#licensa-)
- [Repositório Front-End<a name = "Repositório Front-End"></a>](#repositório-front-end)

## Introdução <a name = "intro"></a>

No âmbito da unidade curricular de Sistemas Baseados em Conhecimento, foi-nos proposto a conceção de um SBC implementado na linguagem Prolog, estando a mesma dividida em 2 tarefas com 2 partes cada uma, tendo por base o conceito de food delivery, tão em voga no último ano decorrente da situação pandémica que vivenciamos.
Para tal decidimos dividir a solução em 2 endpoints:
	º Front-end (Node.js) -> Interface gráfica para o utilizador interagir com a aplicação.
	º Back-end (Java Spring Boot) -> Interface de Aplicação Web (Web API) destinada ao processamento dos pedidos HTTP vindos da interface. É est endpoint que executa toda a lógica e interage diretamente com o SBC em prolog.


## Tarefa A - Aconselhamento para compra de uma refeição <a name = "ta"></a>
Tarefa:
Dentro do conceito de food delivery, take away & drive-in, pretende-se que elabore um SBC para aconselhar sobre a escolha e compra de uma refeição (com entrega em casa ou take away).

### Parte 1 - Aquisição manual de conhecimento  <a name = "ta1"></a>

Na parte 1 pertencente à Tarefa A, foi desenvolvido um sistema baseado em conhecimento que aconselha o utilizador um conjunto de pratos, usando como base as respostas que este selecionou num processo interativo de questões.
Posto isto, a equipa iniciou o projeto com a elaboração de um formulário, usando a ferramenta Google Forms, com o objetivo de recolher informação para a realização de uma base de dados. A partir daqui o grupo seguiu para a conceção de um conjunto de questões que integram a plataforma final. Assim, o utilizador poderá selecionar o tipo de refeição que pretende realizar, o peso da mesma, a dieta, se pretende remover algum condimento e, por fim, o intervalo de preços com o qual se sente mais confortável. Após responder a este pequeno questionário, a plataforma irá sugerir ao utilizador um total de seis pratos, sendo que cada um contém uma breve descrição e três restaurantes que servem esse mesmo prato e respetivas localizações.

De modo a que o projeto fosse possível, a equipa integrou seis ficheiros em _Prolog_: “baseconhecimento.pl”, “certainty.pl”, “database.pl”, “forward.pl”, “proof.pl” e “res.pl”. O primeiro ficheiro corresponde à base de conhecimento da equipa que compreende todas as condições _if/then,_ que constituem as regras de produção, e que irão retornar diferentes perfis depois de as condições serem avaliadas. O ficheiro “database.pl” diz respeito à base de dados que compõe um conjunto de perfis relativos a cada prato. Aqui, o grupo desenvolveu um número de perfis que achou razoável para demonstração, uma vez que a combinação de todas as opções resultaria numa quantidade astronómica deles (648 perfis x 6 pratos = 3888 pratos). Por fim, o grupo optou por utilizar o método _forward_ para o sistema de inferência, de modo a obter diferentes condições provindas dos factos que foram armazenados na base de dados.

### Parte 2 - Aquisição automática de conhecimento <a name = "ta2"></a>

Nesta segunda parte, a equipa considerou o trabalho realizado anteriormente, visto que são etapas bastante semelhantes. No entanto, aqui foram utilizadas técnicas automáticas de aquisição de conhecimento, de forma a ser possível extrair regras de produção automaticamente que serão implementadas na base de conhecimento.

Assim sendo, a equipa procedeu à criação de um ficheiro CSV com os dados formulados na primeira parte. Seguidamente, o grupo importou este documento no _software Weka_, ferramenta de _Data Mining/Machine Learning_, de maneira a obter, automaticamente, um conjunto de regras de produção a serem integradas numa nova base de conhecimento.

### Pré-requisitos <a name = "pre1"></a>
* Ferramenta IDE para execução de código Backend em Java (Intellij/Netbeans/etc).
* Node.js para execução da aplicação de Frontend (Node.js).


## Getting started <a name = "getting1"></a>



### Installation  <a name = "install1"></a>

#### Clone the repo
  ```sh
  git clone  https://github.com/JoaoGuedes01/sbcBackend.git
  ```

### Usage <a name = "usage1"></a>
  ```sh
  Correr o Servidor Backend Spring Boot para a Tarefa A é necessário para o uso da aplicação Tarefa A.
  ```
   ```sh
   Instalar as dependencias Node com 'npm i --save'.
  Correr o servidor Frontend referente à parte A em node.js 'node app' que servirá a aplicação na porta 5000.
  ```


## Tarefa B - Aconselhamento de trajeto para entrega de uma refeição <a name = "tb"></a>
Desenvolver um SBC para um estafeta que usa uma scooter como meio de transporte que trabalha para um sistema de entrega de um restaurante. O SBC deve aconselhar que encomendas o estafeta deve pegar no restaurante e qual o caminho a seguir para proceder às entregas. Optamos por desenvolver uma interface que dá ao utilizador a opção entre fazer encomendas(cliente) ou analisar os caminhos e entregar as encomendas(estafeta).

### Parte 1 - Resolução via Procura <a name = "tb1"></a>

No desenvolvimento da tarefa B, foi assumido o contexto de um sistema de entrega ao domicílio. Assim, foi desenvolvido um sistema baseado em conhecimento para um estafeta que usa uma scooter para fazer entregas de encomendas de um restaurante.

Para complementar o trabalho, o grupo desenvolveu uma plataforma que permite ao utilizador utilizá-la com dois estatutos: cliente ou estafeta. Sendo cliente, este poderá definir a sua localização, segundo o mapa presente no enunciado do projeto, e optar entre oito pratos definidos com preços específicos para fazer uma encomenda. No caso de ser estafeta, o utilizador terá acesso a uma tabela com as diferentes encomendas realizadas pelos clientes, podendo optar por três métodos diferentes de procura (Depth-first, Breadthfirst ou Iterative-Deepening) e selecionar aquele que preferir. Uma vez escolhido o tipo de procura, o estafeta irá ter acesso a um mapa personalizado com o percurso, o destino, o item da encomenda, o preço, o gasto, o lucro, tempo da viagem e o tempo total que a entrega demorará.

O projeto em questão tem dois objetivos associados, sendo que apenas o primeiro é de execução obrigatória. No entanto, o grupo procedeu à realização de ambos, ou seja, o estafeta poderá levar uma ou duas encomendas e averiguar uma rota que suporte a sua entrega.

Para a execução do **primeiro objetivo**, a equipa utilizou cinco ficheiros em _Prolog_: ”bd.pl”, “breadthfirst.pl”, “depthfirst.pl”, “main.pl” e “search.pl”.

O ficheiro correspondente à base de dados contém todos os percursos possíveis de realizar, isto é, os ramos do mapa, bem como contém os gastos associados a cada destino.

O ficheiro “main.pl” contêm o código necessário para interação com o SBC incluindo as encomendas dinâmicas, as entregas e as chamadas aos métodos de procura, assim como toda a logica do calculo dos lucros baseada nos custo de deslocamento e preços de encomenda.

Já o ficheiro “search.pl” permite executar o sistema de inferência que realiza a procura, que abrange todos os factos que permitem gerar uma transição. Além do mais, contém um dos métodos de pesquisa disponibilizados ao estafeta como opção de escolha: o Iterative Deepening.

Por fim, os ficheiros “breadthfirst.pl” e “depthfirst.pl” envolvem os outros dois diferentes métodos de procura.

Para a execução do **segundo objetivo**, a equipa manteve praticamente a mesma estrutura: ”bd.pl”, “breadthfirst.pl”, “main.pl” e “search.pl”. Porém, foi necessário a criação de um novo ficheiro “main.pl” para interação com o sistema que permite a avaliação de duas localizações ao mesmo tempo.

Para terminar, tal como foi feito na tarefa anterior, o projeto foi desenvolvido em JAVA Spring Boot, de maneira a que fosse possível realizar a interface em HTML, CSS e JavaScript para que esta fosse mais interativo e agradável para o utilizador.

### Parte 2 - Otimização do lucro, tempo ou ambos <a name = "tb2"></a>
Nesta parte foram desenvolvidas as funcionalidades de optimização usando o método de hillclimbing para o objetivo A (maximizar o lucro), B (minimizar o tempo do percurso) e C (maximizar 0.8*lucro+0.2*(20-tempo)).

Nesta segunda parte, foi utilizada a mesma base dados de forma a obter as mesmas rotas da parte anterior, otimizando uma solução inicial segundo vários parâmetros.

Tenciona-se, então, maximizar o lucro, minimizar o tempo do percurso e maximizar a fórmula. Para que isto seja possível, o sistema baseado em conhecimento foi desenvolvido usando o método de Hill Climbing e Stochastic Hill Climbing.

Posto isto, foram criados seis ficheiros em _Prolog_: “bd.pl”, “auxiliar.pl”, “hill.pl”, “oa.pl”, “ob.pl”, “oc.pl”.

O primeiro ficheiro contém os factos “percurso” que constituem os quatro parâmetros, sendo estes os nós iniciais e de destino, o tempo que demora a percorrer cada percurso e o lucro obtido.

O ficheiro “hill.pl” abrange os métodos de otimização que foram aplicados nesta parte da tarefa. Como auxílio, existe também o “auxiliar.pl” que contém as funções auxiliares ao método.

Os últimos três ficheiros contêm a otimização dos objetivos A, B e C, respetivamente e contêm a lógica e funções de interação com o sistema.


### Pré-requisitos <a name = "pre2"></a>
* Ferramenta IDE para execução de código Backend em Java.
* Node.js para execução da aplicação de Frontend.

## Getting started <a name = "getting2"></a>

### Quick-start <a name = "quick2"></a>

#### Clone the repo
  ```sh
  git clone  https://github.com/JoaoGuedes01/sbcBackend.git
  ```

### Usage <a name = "usage2"></a>
  ```sh
  Correr o Servidor Backend Spring Boot para a Tarefa B é necessário para o uso da aplicação Tarefa A.
  ```
   ```sh
   Instalar as dependencias Node com 'npm i --save'.
  Correr o servidor Frontend referente à parte B em node.js 'node app' que servirá a aplicação na porta 5000.
  ```
  


  
## Ferramentas <a name = "built"></a>
* [SWI-Prolog](https://www.swi-prolog.org)
* [Node.js](https://nodejs.org/en/)
* [Java](https://www.java.com/en/)
* [Spring Boot](https://spring.io/projects/spring-boot)



## Contactos <a name = "contact"></a>

* [Ana Pereira](mailto:a89168@alunos.uminho.pt)
* [Beatriz Rodrigues](mailto:a89204@alunos.uminho.pt)
* [João Guedes](mailto:a89237@alunos.uminho.pt)
* [Manuel Ribeiro](mailto:a89247@alunos.uminho.pt)


## Acknowledgments <a name = "ack"></a>
* [Paulo Cortez](http://www3.dsi.uminho.pt/pcortez/Home.html)
* [André Pilastri](https://pilastri.github.io/andrepilastri.github.io/#about)

## Referências <a name = "refer"></a>

## Licensa <a name = "license"></a>
* [License](https://github.com/JoaoGuedes01/sbcBackend/blob/main/LICENSE)
## Repositório Front-End<a name = "Repositório Front-End"></a>
* [Front-End](https://github.com/JoaoGuedes01/sbcFrontend)


Distributed under the MIT License. See `LICENSE` for more information.