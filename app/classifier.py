import psycopg2
import numpy as np
from sklearn import linear_model
from collections import defaultdict

from optparse import OptionParser
import sys
from time import time
import matplotlib.pyplot as plt

from sklearn.datasets import fetch_20newsgroups
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.linear_model import RidgeClassifier
from sklearn.svm import LinearSVC
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import PassiveAggressiveClassifier
from sklearn.naive_bayes import BernoulliNB, MultinomialNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import NearestCentroid
from sklearn.utils.extmath import density
from sklearn import metrics


# Connect to PostgreSQL server and get rows
try:
    conn = psycopg2.connect("dbname='scenic_routing_development' host='localhost'")
except:
    print "I am unable to connect to the database"

cur = conn.cursor()
cur.execute("""SELECT location_id, string_agg(body, ' ') from  grams group by location_id """)
rows = cur.fetchall()

# create training set target
labels = [546, 945, 2026, 3035, 3234, 2379, 2886, 1750, 3989, 4313, 2023, 2139, 2380, 1706, 1368, 1140, 2650, 1680, 3048, 941, 3213, 1041, 4873, 4448, 532, 5049, 2032, 4387, 4529, 1914, 4351, 4264, 4196, 2393, 5046, 829, 1305, 2305, 1780, 1442, 4637, 1031, 694, 349, 3116, 2385, 1958, 4488, 1863, 3637, 3915, 911, 1574, 1599, 2626, 2271, 2834, 2091, 2529, 1926, 3117, 2066, 3259, 690, 4870, 2395, 2391, 913, 1117, 3089, 2802, 2854, 961, 1375, 1260, 2411, 1138, 2877, 4798, 857, 4501, 4532, 1247, 4950, 2609, 2901, 1604, 4010, 856, 2871, 2288, 4259, 1801, 2225, 4641, 3195, 4286, 2410, 2398, 1298]

# fill map with true for scenic IDs using labels
targetMap = {}
for l in labels:
	targetMap[l] = True
targetMap = defaultdict(lambda: False, targetMap)

mutRows = [list(row) for row in rows]

# get all labels in set x
target_labels = [targetMap[row[0]] for row in mutRows]

# Strip text out of row
text = [row[1] for row in mutRows]

# split data into train vs test sets
data_test = text[:len(text)/2]
data_train = text[len(text)/2:]

# split labels 
y_test = target_labels[:len(target_labels)/2]
y_train = target_labels[len(target_labels)/2:]

######################################################################
######################################################################
######################################################################
# Feature Extraction
if False:
	vectorizer = HashingVectorizer(stop_words='english', non_negative=True, n_features=1000)
	X_train = vectorizer.transform(data_train)
else:
	vectorizer = TfidfVectorizer(sublinear_tf=True, max_df=0.5, stop_words='english')
	X_train = vectorizer.fit_transform(data_train)

print("n_samples: %d, n_features: %d" % X_train.shape)

X_test = vectorizer.transform(data_test)
print("n_samples: %d, n_features: %d" % X_test.shape)

# before check
# print X_test

# # chi squared test
# ch2 = SelectKBest(chi2, k=10000)
# X_train = ch2.fit_transform(X_train, y_train) #GET TRAINING TARGET
# X_test = ch2.transform(X_test)

# X_test = X_test.todense()

# get features!
feature_names = np.asarray(vectorizer.get_feature_names())

######################################################################
######################################################################
######################################################################
# Benchmark classifiers
def benchmark(clf):
    print('_' * 80)
    print("Training: ")
    print(clf)
    t0 = time()

    clf.fit(X_train, y_train)
    train_time = time() - t0
    print("train time: %0.3fs" % train_time)

    t0 = time()
    pred = clf.predict(X_test)
    test_time = time() - t0
    print("test time:  %0.3fs" % test_time)

    score = metrics.f1_score(y_test, pred)
    print("f1-score:   %0.3f" % score)

    if hasattr(clf, 'coef_'):
        print("dimensionality: %d" % clf.coef_.shape[1])
        print("density: %f" % density(clf.coef_))

        if feature_names is not None:
            print("top 10 keywords per class:")
        print()

    if True:
        print("confusion matrix:")
        print(metrics.confusion_matrix(y_test, pred))

    print()
    clf_descr = str(clf).split('(')[0]
    return clf_descr, score, train_time, test_time


# Train SGD with Elastic Net penalty
print('=' * 80)
print("Elastic-Net penalty")
benchmark(SGDClassifier(alpha=.0001, n_iter=50, penalty="elasticnet"))
# benchmark(LinearSVC(loss='l2', penalty="L1", dual=False, tol=1e-3))
