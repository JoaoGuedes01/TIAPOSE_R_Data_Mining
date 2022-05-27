
# Models (Machine Learning)

For our models we chose the ones that fitted the criteria of our data and prediction objective (Time Series Forecasting) from 2 major packages <b>Rminer</b> and <b>Forecast</b>.

# Packages
Both packages were recommended by Paulo Cortez, our teacher and supervisor for the duration of this project.

## Rminer
**Description:** Facilitates the use of data mining algorithms in classification and regression (including time series forecasting) tasks by presenting a short and coherent set of functions.
<p><b>Author:</b>Paulo Cortez</p>
### Models

#### **Linear Regression (lm)**
Linear regression attempts to model the relationship between two variables by fitting a linear equation to observed data. One variable is considered to be an explanatory variable, and the other is considered to be a dependent variable. For example, a modeler might want to relate the weights of individuals to their heights using a linear regression model.

#### **Multilayer Perception Ensemble and Multilayer Perception (mlp & mlpe)**
Multi layer perceptron (MLP) is a supplement of feed forward neural network. It consists of three types of layers: **the input layer, output layer and hidden layer**. The input layer receives the input signal to be processed. The required task such as prediction and classification is performed by the output layer. An arbitrary number of hidden layers that are placed in between the input and output layer are the true computational engine of the MLP. Similar to a feed forward network in a MLP the data flows in the forward direction from input to output layer. The neurons in the MLP are trained with the back propagation learning algorithm. MLPs are designed to approximate any continuous function and can solve problems which are not linearly separable. The major use cases of MLP are pattern classification, recognition, prediction and approximation.

#### **Naive (naive)**
R function that selects the most common class (classification) or mean output value (regression)

#### **Conditional Inference Tree (ctree)**
Conditional Inference Trees is a different kind of decision tree that uses recursive partitioning of dependent variables based on the value of correlations. It avoids biasing just like other algorithms of classification and regression in machine learning. Thus, avoiding vulnerability to the errors making it more flexible for the problems in the data. Conditional inference trees use a significance

#### **Random Forest (randomForest)**
Random forest is a type of supervised learning algorithm that uses ensemble methods (bagging) to solve both regression and classification problems. The algorithm operates by constructing a multitude of decision trees at training time and outputting the mean/mode of prediction of the individual trees.
The fundamental concept behind random forest is the wisdom of crowds wherein a large number of uncorrelated models operating as a committee will outperform any of the individual constituent models.

The reason behind this is the fact that the trees protect each other from their individual errors. Within a random forest, there is no interaction between the individual trees. A random forest acts as an estimator algorithm that aggregates the result of many decision trees and then outputs the most optimal result.

#### **Multiple Regression (mr)**
Multiple regression is **a statistical technique that can be used to analyze the relationship between a single dependent variable and several independent variables**. The objective of multiple regression analysis is to use the independent variables whose values are known to predict the value of the single dependent value.

#### **Relevance Vector Machine (rvm)**
A Relevance Vector Machine (RVM) is a machine learning technique that uses Bayesian inference to obtain parsimonious solutions for regression and classification. The RVM has an identical functional form to the support vector machine, but provides probabilistic classification. It is actually equivalent to a Gaussian process model with a certain covariance function. Compared to that of support vector machines (SVM), the Bayesian formulation of the RVM avoids the set of free parameters of the SVM (that usually require cross-validation-based post-optimizations). However RVMs use an expectation maximization (EM)-like learning method and are therefore at risk of local minima. This is unlike the standard sequential minimal optimization(SMO)-based algorithms employed by SVMs, which are guaranteed to find a global optimum.

#### **Support Vector Machine (ksvm)**
Support Vector Machine can also be used as a regression method, maintaining all the main features that characterize the algorithm (maximal margin). The Support Vector Regression (SVR) uses the same principles as the SVM for classification, with only a few minor differences. First of all, because output is a real number it becomes very difficult to predict the information at hand, which has infinite possibilities. In the case of regression, a margin of tolerance (epsilon) is set in approximation to the SVM which would have already requested from the problem. But besides this fact, there is also a more complicated reason, the algorithm is more complicated therefore to be taken in consideration. However, the main idea is always the same: to minimize error, individualizing the hyperplane which maximizes the margin, keeping in mind that part of the error is tolerated.

## Forecast
**Description:** The R package forecast **provides methods and tools for displaying and analysing univariate time series forecasts including exponential smoothing via state space models and automatic ARIMA modelling**. This package is now retired in favour of the fable package.
<p><b>Authors:</b>Rob Hyndman, George Athanasopoulos, Christoph Bergmeir, Gabriel Caceres, Leanne Chhay, Mitchell O'Hara-Wild , Fotios Petropoulos, Slava Razbash, Earo Wang, Farah Yasmeen , R Core Team, Ross Ihaka, Daniel Reid, David Shaub, Yuan Tang, Zhenyu Zhou</p>
### Models

#### **Holt Winters (HW)**
Holt-Winter’s Exponential Smoothing as named after its two contributors: Charles Holt and Peter Winter’s is one of the oldest time series analysis techniques which takes into account the trend and seasonality while doing the forecasting. This method has 3 major aspects for performing the predictions. It has an average value with the trend and seasonality. The three aspects are 3 types of exponential smoothing and hence the hold winter’s method is also known as triple exponential smoothing.

Let us look at each of the aspects in detail.

- **Exponential Smoothing**: Simple exponential smoothing as the name suggest is used for forecasting when the data set has no trends or seasonality.

- **Holt’s Smoothing method**: Holt’s smoothing technique, also known as linear exponential smoothing, is a widely known smoothing model for forecasting data that has a trend.

- **Winter’s Smoothing method**: Winter’s smoothing technique allows us to include seasonality while making the prediction along with the trend.

Hence the Holt winter’s method takes into account average along with trend and seasonality while making the time series prediction.

Forecast equation^yt+h|t=ℓt+hbt

Level equationℓt=αyt+(1−α)(ℓt−1+bt−1)

Trend equationbt=β∗(ℓt−ℓt−1)+(1−β∗)bt−1

Where ℓtℓt is an estimate of the level of the series at time tt,

btbt is an estimate of the trend of the series at time tt,

αα is the smoothing coefficient
#### ****Autoregressive Integrated Moving Average**(ARIMA)**

ARIMA is the abbreviation for AutoRegressive Integrated Moving Average. Auto Regressive (AR) terms refer to the lags of the differenced series, Moving Average (MA) terms refer to the lags of errors and I is the number of difference used to make the time series stationary.
It's a forecasting algorithm based on the idea that **the information in the past values of the time series can alone be used to predict the future values**.
#### **Neural Netowrk (NN)**
Feed-forward neural networks with a single hidden layer and lagged inputs for forecasting univariate time series.
A feed-forward neural network is **a biologically inspired classification algorithm**. It consists of a number of simple neuron-like processing units, organized in layers and every unit in a layer is connected with all the units in the previous layer.
#### **ETS (Error,Trend,Seasonal)**
The ETS models are a family of time series models with an underlying state space model consisting of a level component, a trend component (T), a seasonal component (S), and an error term (E).

# Optimization Algorithms
#### **Hill Climbing**
In numerical analysis, hill climbing is a mathematical optimization technique which belongs to the family of local search. It is an iterative algorithm that starts with an arbitrary solution to a problem, then attempts to find a better solution by making an incremental change to the solution. If the change produces a better solution, another incremental change is made to the new solution, and so on until no further improvements can be found.

#### **Montecarlo**
Monte Carlo methods, or Monte Carlo experiments, are a broad class of computational algorithms that rely on repeated random sampling to obtain numerical results. The underlying concept is to use randomness to solve problems that might be deterministic in principle. They are often used in physical and mathematical problems and are most useful when it is difficult or impossible to use other approaches. Monte Carlo methods are mainly used in three problem classes:[1] optimization, numerical integration, and generating draws from a probability distribution.

#### **Tabu Search (Tabu)**
Tabu search is a metaheuristic local search method used for mathematical optimization. Local search methods have the tendency to be stuck in suboptimal regions. TS enhances the performance of these techniques by prohibiting already visited solutions or others through user-provided rules. 

#### **Simulated Annealing (Sann)**
Simulated annealing (SA) is a probabilistic technique for approximating the global optimum of a given function. Specifically, it is a metaheuristic to approximate global optimization in a large search space for an optimization problem. It is often used when the search space is discrete (for example the traveling salesman problem, the boolean satisfiability problem, protein structure prediction, and job-shop scheduling). 

#### **R Based Genetic Algorithm (RBGA)**
A R based genetic algorithm that optimizes, using a user set evaluation function, a set of floats. It takes as input minimum and maximum values for the floats to optimizes. The optimum is the chromosome for which the evaluation value is minimal.

#### **Differential Evolution Optimization (DeOptim)**
In evolutionary computation, differential evolution (DE) is a method that optimizes a problem by iteratively trying to improve a candidate solution with regard to a given measure of quality. Such methods are commonly known as metaheuristics as they make few or no assumptions about the problem being optimized and can search very large spaces of candidate solutions. However, metaheuristics such as DE do not guarantee an optimal solution is ever found.
#### **Particle Swarm Optimizer (PsOptim)**
In computational science, particle swarm optimization (PSO)[1] is a computational method that optimizes a problem by iteratively trying to improve a candidate solution with regard to a given measure of quality. It solves a problem by having a population of candidate solutions, here dubbed particles, and moving these particles around in the search-space according to simple mathematical formula over the particle's position and velocity. Each particle's movement is influenced by its local best known position, but is also guided toward the best known positions in the search-space, which are updated as better positions are found by other particles. This is expected to move the swarm toward the best solutions.
