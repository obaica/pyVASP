#!/usr/bin/env python
## Application: List free JobID
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    01/04/2020

import os
import sys
import datetime
import time
import pandas as pd

import platform
if platform.system() == 'Darwin' or 'Linux' :
    sys.path.append('/Volumes/GoogleDrive/My Drive/Python')
    os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("")


######################### Opening DB connection #########################
import pymysql.cursors
connection = pymysql.connect(host='www.nano.kmitl.ac.th',
                            user='kaswat',
                            password='00bird00',
                            db='vasp',
                            charset='utf8',
                            cursorclass=pymysql.cursors.DictCursor)

with connection.cursor() as cursor:
    sql = "select `JobID` from `INCAR`"
    cursor.execute(sql)
    result = cursor.fetchall()
connection.commit()
os.system('clear')
connection.close()


jobid = pd.DataFrame.from_dict(result)
total = jobid.shape[0]
maxid = int(jobid.iloc[total-1])

for i in range(1,maxid+1) :
    if i not in jobid.values :
        print(i)