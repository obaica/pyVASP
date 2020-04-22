#!/usr/bin/env python
## Application: List all output from SQL server compare to local file
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    02/04/2020

import os
import sys
import datetime
import time
import pandas as pd

sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP/')
os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("")

df = pd.DataFrame(columns=['Local'])

import fnmatch
localDir = os.getcwd()
for folder, subs, files in os.walk(localDir) :
  pattern = "output.*"
  for ID in os.listdir(folder):
    if fnmatch.fnmatch(ID, pattern):
        temp = ID.split('.')
        JobID = int(temp[1])
        # print("JobID   = ",JobID)
        df = df.append(pd.Series([JobID], index=['Local']), ignore_index=True)

df = df.sort_values(by=['Local'])
df = df.reset_index(drop=True)
## print(df)

######################### Opening DB connection #########################
import pymysql.cursors
import sql
connection = pymysql.connect(host = sql.host,
                             user = sql.user,
                             password = sql.password,
                             db = sql.db,
                             charset='utf8',
                             cursorclass=pymysql.cursors.DictCursor)

result = pd.DataFrame()

######################### Opening DB connection #########################
print("Query Material from MySQL server ...")
print("")
with connection.cursor() as cursor:
    sql =  "SELECT DISTINCT `material` from `POSCAR` ORDER BY `material` ASC;"
    cursor.execute(sql)
    result = cursor.fetchall()
connection.commit()

temp = pd.DataFrame.from_dict(result)
temp['material'].astype(str)
print(temp)
print()
num = int(input("Input material index no. >> "))
string = temp.iloc[num].to_string().split()
mat = string[1]


######################### Opening DB connection #########################
print("Query Structure from MySQL server ...")
print("")
with connection.cursor() as cursor:
    sql =  "SELECT DISTINCT `structure` from `POSCAR` \
            WHERE `material` = %s \
            ORDER BY `structure` ASC;"
    cursor.execute(sql, (mat))
    result = cursor.fetchall()
connection.commit()

temp = pd.DataFrame.from_dict(result)
print(temp)
print()
num = int(input("Input structure index no. >> "))
string = temp.iloc[num].to_string().split()
struct = string[1]
print()


######################### Opening DB connection #########################
print("Query JobID from MySQL server ...")
print("Material = ",mat)
print("Structure = ",struct)
print()
with connection.cursor() as cursor:
    sql = "SELECT `JobID` FROM `POSCAR` WHERE `material` = %s AND `structure` = %s ;"
    cursor.execute(sql, (mat,struct) )
    result = cursor.fetchall()
connection.commit()
connection.close()

print("")
list = []
for i in range(len(result)):
    list.append(result[i]['JobID'])

df_sql = pd.DataFrame(list,columns=['SQL'])
## print(df_sql)

df_total = df.join(df_sql)
# df_total = pd.concat([df2, df_sql],sort=False)
print(df_total)
print("")