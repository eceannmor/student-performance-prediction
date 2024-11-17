import sys
import subprocess
import pkg_resources

# check for any missing dependencies, install if needed
# https://stackoverflow.com/questions/44210656/how-to-check-if-a-module-is-installed-in-python-and-if-not-install-it-within-t
required = {'numpy', 'pandas', 'scipy', 'sklearn'}
installed = {pkg.key for pkg in pkg_resources.working_set}
missing = required - installed

if missing:
    python = sys.executable
    subprocess.check_call([python, '-m', 'pip', 'install', *missing], stdout=subprocess.DEVNULL)

import csv
import numpy
import pandas 
import matplotlib.pyplot as pyplot
from scipy import stats, linear_model

# data init
# column types:
# Categorical: Gender
# Ordinal: ParentalEducationLevel, SchoolType
# Numeric: the rest
training_data_filename = 'trainingSet.csv'
test_data_filename = 'testSet.csv'
training_set = pandas.read_csv(training_data_filename) 
test_set = pandas.read_csv(test_data_filename) 

dependent_raw = training_set[['HoursStudied','Attendance','ParentalInvolvement','AccessToResources','ExtracurricularActivities','SleepHours','PreviousScores','MotivationLevel','InternetAccess','TutoringSessions','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivity','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
dependent_minmax = training_set[['HoursStudiedMinMax','AttendanceMinMax','ParentalInvolvement','AccessToResources','ExtracurricularActivitiesMinMax','SleepHoursMinMax','PreviousScoresMinMax','MotivationLevel','InternetAccess','TutoringSessionsMinMax','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivityMinMax','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
dependent_z = training_set[['HoursStudiedZ','AttendanceZ','ParentalInvolvement','AccessToResources','ExtracurricularActivitiesZ','SleepHoursZ','PreviousScoresZ','MotivationLevel','InternetAccess','TutoringSessionsZ','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivityZ','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
independent_raw = training_set['ExamScore']
independent_minmax = training_set['ExamScoreMinMax']
independent_z = training_set['ExamScoreZ']

test_dependent_raw = test_set[['HoursStudied','Attendance','ParentalInvolvement','AccessToResources','ExtracurricularActivities','SleepHours','PreviousScores','MotivationLevel','InternetAccess','TutoringSessions','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivity','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
test_dependent_minmax = test_set[['HoursStudiedMinMax','AttendanceMinMax','ParentalInvolvement','AccessToResources','ExtracurricularActivitiesMinMax','SleepHoursMinMax','PreviousScoresMinMax','MotivationLevel','InternetAccess','TutoringSessionsMinMax','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivityMinMax','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
test_dependent_z = test_set[['HoursStudiedZ','AttendanceZ','ParentalInvolvement','AccessToResources','ExtracurricularActivitiesZ','SleepHoursZ','PreviousScoresZ','MotivationLevel','InternetAccess','TutoringSessionsZ','FamilyIncome','TeacherQuality','SchoolType','PeerInfluence','PhysicalActivityZ','LearningDisabilities','ParentalEducationLevel','DistanceFromHome','Gender']]
test_independent_raw = test_set['ExamScore']
test_independent_minmax = test_set['ExamScoreMinMax']
test_independent_z = test_set['ExamScoreZ']

# Multiple Linear Regression

linear_regression = linear_model.LinearRegression()
linear_regression.fit(dependent_z, independent_z)

print(linear_regression.predict(test_dependent_z[0]))
print(test_independent_z[0])

#Ideas for later:
# Lars

# Multinominal Logical Regression

# Robust Regression

#

#

#

#