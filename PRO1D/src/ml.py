# import sys
# import subprocess
# import pkg_resources
import time

# unused

# # check for any missing dependencies, install if needed
# # https://stackoverflow.com/questions/44210656/how-to-check-if-a-module-is-installed-in-python-and-if-not-install-it-within-t
# required = {'numpy', 'pandas', 'sklearn'}
# installed = {pkg.key for pkg in pkg_resources.working_set}
# missing = required - installed

# if missing:
#     python = sys.executable
#     subprocess.check_call([python, '-m', 'pip', 'install', *missing])

import numpy as np
import pandas
pandas.set_option('future.no_silent_downcasting', True)
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import (
    mean_squared_error, 
    r2_score, 
    d2_absolute_error_score, 
    max_error
)
from sklearn import (
    linear_model, 
    svm
)
import matplotlib.pyplot as plt

# data load
f = open("data/data.csv")
data = pandas.read_csv(f)
# standardising the data that is kept in string format(classes) for SQL reports' sake 
data = data.replace({
    'Public' : -1,
    'Private' : 1,
    'High School' : 0,
    'College' : 1,
    'Postgraduate' : 2,
    'Male' : 0,
    'Female' : 1
})

cols = data.columns.tolist()
# moving the target column to the end of the table
cols.remove('examscore')
cols.insert(-2, 'examscore')
data = data[cols]
# dataset split
y = data.iloc[:,-3:-2] # only predicts the numeric exam score [1-100], examscoreminmax and examscorez are kept for backwards compatibility sake and are not included in the training
X = data.iloc[:,:-3]
# random seed to split the data
import random
seed = random.randint(1, 999)
# fixing the seed for the SVM later
np.random.seed(seed)
print(f'Dataset split seed: {seed}')
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.20, random_state=seed)
# for plotting
y_test_array = y_test.to_numpy()


# KNN Regression
# Chosen as a baseline - the most obvious algorithm to predict the scores
neighbors = 9
start = time.time()
print(f'Fitting KNN Regression model\nNumber of neighbors: {neighbors}')
neigh = KNeighborsRegressor(n_neighbors=neighbors)
neigh.fit(X_train, y_train)
y_pred_knn = pandas.DataFrame(neigh.predict(X_test), columns = ['examscore'])
y_pred_knn = y_pred_knn.to_numpy()
print(f'Finished fitting. Took {time.time() - start} seconds')


# Robust Regression
# Chosen for being able to handge edge cases and outliers, equivalent of straight-A students(high exam score, regarless of input) and ignoramuses(low exam score, regardless of input) from the dataset
# This is still a linear model
start = time.time()
print(f'Fitting RANdom SAmple Consensus model')
ransac = linear_model.RANSACRegressor(random_state=seed)
ransac.fit(X_train, y_train)
y_pred_ransac = ransac.predict(X_test)
print(f'Finished fitting. Took {time.time() - start} seconds')


# Support Vector Regression
# Takes longer to fit, but has greater *potential* accuracy. Has larger variation between runs
start = time.time()
print(f'Fitting Support Vector Regression model\nSeed: {seed}')
svr = svm.LinearSVR(random_state=seed)
svr.fit(X_train, y_train)
y_pred_svr = svr.predict(X_test)
print(f'Finished fitting. Took {time.time() - start} seconds')


# Model performace estimation
# Mean Squared Error metric, smaller is better
mse_knn = mean_squared_error(y_test_array, y_pred_knn)
mse_ransac = mean_squared_error(y_test_array, y_pred_ransac)
mse_svr = mean_squared_error(y_test_array, y_pred_svr)

# R-squared metric, best is 1.0, bigger is better
r2_knn = r2_score(y_test, y_pred_knn)
r2_ransac = r2_score(y_test, y_pred_ransac)
r2_svr = r2_score(y_test, y_pred_svr)

# unused
# D-squared metric, best is 1.0, bigger is better
d2_knn = d2_absolute_error_score(y_test, y_pred_knn)
d2_ransac = d2_absolute_error_score(y_test, y_pred_ransac)
d2_svr = d2_absolute_error_score(y_test, y_pred_svr)

# Maximum Error metric, smaller is better 
me_knn = max_error(y_test, y_pred_knn)
me_ransac = max_error(y_test, y_pred_ransac)
me_svr = max_error(y_test, y_pred_svr)

print(f'Mean Squared Error:\n\tKNN:\t{mse_knn}\n\tRANSAC:\t{mse_ransac}\n\tSVR:\t{mse_svr}')
print(f'R-squared:\n\tKNN:\t{r2_knn}\n\tRANSAC:\t{r2_ransac}\n\tSVM:\t{r2_svr}')
# print(f'D-squared:\n\tKNN:\t{d2_knn}\n\tRANSAC:\t{d2_ransac}\n\tSVM:\t{d2_svr}') # unused
print(f'Max Error:\n\tKNN:\t{me_knn}\n\tRANSAC:\t{me_ransac}\n\tSVM:\t{me_svr}')

# Plot the results
fig, ((ax1, ax2, ax3), (ax4, ax5, ax6)) = plt.subplots(2, 3)

ax1.scatter(y_test_array, y_pred_knn, color='blue', label='KNN', s=40, alpha=0.25, marker='+')
ax1.plot([min(y_test_array), max(y_test_array)], [min(y_test_array), max(y_test_array)], color='red', linewidth=2, label='Ideal fit')
ax1.set(xlabel='Predicted score', ylabel='Actual score', title='K-Nearest-Neighbors')
ax1.legend()

ax2.scatter(y_test_array, y_pred_ransac, color='orange', label='RANSAC', s=40, alpha=0.25, marker='+')
ax2.plot([min(y_test_array), max(y_test_array)], [min(y_test_array), max(y_test_array)], color='red', linewidth=2, label='Ideal fit')
ax2.set(xlabel='Predicted score', ylabel='Actual score', title='RANdom SAmple Consensus')
ax2.legend()

ax3.scatter(y_test_array, y_pred_svr, color='green', label='SVM', s=40, alpha=0.25, marker='+')
ax3.plot([min(y_test_array), max(y_test_array)], [min(y_test_array), max(y_test_array)], color='red', linewidth=2, label='Ideal fit')
ax3.set(xlabel='Predicted score', ylabel='Actual score', title='Support Vector Machine')
ax3.legend()

models = ['KNN', 'RANSAC', 'SVM']
errors_mse = [mse_knn, mse_ransac, mse_svr]
errors_r2 = [r2_knn, r2_ransac, r2_svr]
errors_me = [me_knn, me_ransac, me_svr]
colours = ['blue', 'orange', 'green']

ax4.bar([a+' '+str(np.round(b, 4)) for a,b in zip(models,errors_mse)], errors_mse, 0.75, color=colours, label='Mean Squared Error')
ax4.set(ylabel='Mean Squared Error, smaller is better')

ax5.bar([a+' '+str(np.round(b, 4)) for a,b in zip(models,errors_r2)], errors_r2, 0.75, color=colours, label='R-squared')
ax5.set(ylabel='R-squared, bigger is better')

ax6.bar([a+' '+str(np.round(b, 4)) for a,b in zip(models,errors_me)], errors_me, 0.75, color=colours, label='Maximum Error')
ax6.set(ylabel='Maximum Error, smaller is better')

fig.set_figheight(9)
fig.set_figwidth(16)
fig.suptitle(f'Model comparison\nRandom seed: {seed}')
plt.show()