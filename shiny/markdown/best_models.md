# Best Models

<p>After analysing all the results for our picked models for every scenario and time series, the ones with the least MAE were chosen to be used as the best option in the final solution</p>
<p>For all the scenarios the data was divided in the 5 Time Series <b>All</b>,<b>Female</b>,<b>Male</b>,<b>Young</b> and <b>Adult.</b>
</p>

## Scenario 1 (Untouched)
In this scenario we kept all of the columns and values exactly like they were, same columns and same outlier values.

### **All**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>757.59</b>
</p>
<p>
NMAE: <b>4.93</b>
</p>

![image](./imgs/best_cen1_all.png)

### **Female**
<p>
For this time series the aproach was the <b>Multivariate Model</b> composed by
</p>
<p>
Model: <b>ETS</b>
</p>
<p>
MAE: <b>396.7500</b>
</p>
<p>
NMAE: <b>5.32</b>
</p>

![image](./imgs/best_cen1_female.png)

### **Male**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>413.97</b>
</p>
<p>
NMAE: <b>6.02</b>
</p>

![image](./imgs/best_cen1_male.png)

### **Young**
<p>
For this time series the aproach was the <b>Multivariate Model</b> composed by
</p>
<p>
Model: <b>ETS</b>
</p>
<p>
MAE: <b>409.96</b>
</p>
<p>
NMAE: <b>5.61</b>
</p>

![image](./imgs/best_cen1_young.png)

### **Adult**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>422.62</b>
</p>
<p>
NMAE: <b>5.25</b>
</p>

![image](./imgs/best_cen1_adult.png)


## Scenario 2 (Without Outliers)
This scenario is supposed to be identical to the first one but without any outlier values for the time series in question, as they have been replaced with the mean value for the time series column.

### **All**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Conditional Inference Tree</b>
</p>
<p>
MAE: <b>644.82</b>
</p>
<p>
NMAE: <b>11.08</b>
</p>

![image](./imgs/best_cen2_all.png)

### **Female**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>ETS</b>
</p>
<p>
Multivariate Model: <b>Conditional Inference Tree</b>
</p>
<p>
MAE: <b>312.63</b>
</p>
<p>
NMAE: <b>10.78</b>
</p>

![image](./imgs/best_cen2_female.png)

### **Male**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Linear Model</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>405.20</b>
</p>
<p>
NMAE: <b>16.33</b>
</p>

![image](./imgs/best_cen2_male.png)

### **Young**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Linear Model</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>356.75</b>
</p>
<p>
NMAE: <b>12.83</b>
</p>

![image](./imgs/best_cen2_young.png)

### **Adult**
<p>
For this time series the aproach was the <b>Univariate Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
MAE: <b>360.59</b>
</p>
<p>
NMAE: <b>11.47</b>
</p>

![image](./imgs/best_cen2_adult.png)

## Scenario 3 (With Holidays)
This scenario counts with an additional column **holiday** that, for each record, has 1 if that day corresponds with a holiday in Portugal, or a 0 if not. This information was extracted from https://holidays.abstractapi.com where everyday was tested via loop cycle and the results stored in this extra column.

### **All**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>811.93</b>
</p>
<p>
NMAE: <b>5.29</b>
</p>

![image](./imgs/best_cen3_all.png)

### **Female**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>398.71</b>
</p>
<p>
NMAE: <b>5.35</b>
</p>

![image](./imgs/best_cen3_female.png)

### **Male**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Holt Winters</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>415.31</b>
</p>
<p>
NMAE: <b>6.04</b>
</p>

![image](./imgs/best_cen3_male.png)

### **Young**
<p>
For this time series the aproach was the <b>Multivariate Model</b> composed by
</p>
<p>
Univariate Model: <b>ETS</b>
</p>
<p>
MAE: <b>409.96</b>
</p>
<p>
NMAE: <b>5.61</b>
</p>

![image](./imgs/best_cen3_young.png)

### **Adult**
<p>
For this time series the aproach was the <b>Hybrid Model</b> composed by
</p>
<p>
Univariate Model: <b>Linear Model</b>
</p>
<p>
Multivariate Model: <b>Linear Model</b>
</p>
<p>
MAE: <b>531.93</b>
</p>
<p>
NMAE: <b>6.60</b>
</p>

![image](./imgs/best_cen3_adult.png)

