import sys
import cPickle
import psycopg2
import ppygis
import numpy as np
from time import time
from sklearn import linear_model
from collections import defaultdict
from optparse import OptionParser
from sklearn.feature_extraction.text import TfidfVectorizer
from itertools import ifilter

# get model
with open('model.pkl', 'rb') as fid:
    model = cPickle.load(fid)

with open('vctr.pkl', 'rb') as fid2:
    vectorizer = cPickle.load(fid2)

# get params (longitude, latitude, radius)
lon, lat, radius = sys.argv[1::]

# Connect to PostgreSQL server and get rows
# find points to predict	
try:
    conn = psycopg2.connect("dbname='scenic_routing_development' host='localhost'")
except:
    print "I am unable to connect to the database"

cur = conn.cursor()					
cur.execute('SELECT * FROM grams LEFT JOIN locations ON grams.location_id=locations.id WHERE ST_DWithin(locations.longlat, ST_MakePoint(' + str(lon) + ',' + str(lat) + '),' + str(radius) + ')')

rows = cur.fetchall()

mutRows = [list(row) for row in rows]
text = [row[1] for row in mutRows]

x_set = vectorizer.transform(text)

# predict
results = model.predict(x_set).tolist()

# find and return
index = results.index(next(ifilter(lambda x: True, results), None))
if index is not None:
	answerRow = mutRows[index]

	cur.execute('SELECT * FROM locations WHERE id=' + str(answerRow[5]))
	finalAnswer = cur.fetchall()
	scenery = finalAnswer[0][0]

	print finalAnswer
	print scenery
else:
	print 'None'