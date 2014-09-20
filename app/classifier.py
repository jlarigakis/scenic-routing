import psycopg2
import numpy as np
from sklearn import linear_model

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
cur.execute("""SELECT * from grams""")
rows = cur.fetchall()

x = [list(row) for row in rows]


# clean up text to classify
# for row in x:
# 	row[1] = row[1].decode('utf8').lower().split()
text = [row[1] for row in x]

data_test = text[:len(text)/2]
data_train = text[len(text)/2:]

# classifier
vectorizer = TfidfVectorizer(sublinear_tf=True, max_df=0.5, stop_words='english')
X_train = vectorizer.fit_transform(text)
print("n_samples: %d, n_features: %d" % X_train.shape)


# chi squared test
ch2 = SelectKBest(chi2, "all")
X_train = ch2.fit_transform(X_train, xxxxx) #GET TRAINING TARGET
X_test = ch2.transform(X_test)
print("done in %fs" % (time() - t0))