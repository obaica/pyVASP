import os
import fnmatch
import sys
import datetime
import time
import pandas as pd


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



localDir = os.getcwd()
for folder, subs, files in os.walk(localDir) :
    pattern = "output.*"
    for ID in os.listdir(folder) :
        if fnmatch.fnmatch(ID, pattern):
            os.chdir(folder)
            print(os.getcwd())
            print('JobID = ',ID)

            temp = ID.split('.')
            if int(temp[1]) in jobid.values :
                newID = int(input("Enter nre JobID : "))
                run = 'mv '+str(ID)+' output.'+str(newID)
                os.system(run)
                ID = 'output.'+str(newID)


            vasprun = os.path.join(folder,'vasprun.xml')
            with open(vasprun, "r") as f:
                lines = f.readlines()
            with open(vasprun, "w") as f:
                for line in lines:
                    if "SYSTEM" in line.split('"') :
                        f.write('  <i type="string" name="SYSTEM"> GS </i> \n')
                    else :
                        f.write(line)


            poscar = os.path.join(folder,'POSCAR')
            with open(poscar, "r") as f:
                lines = f.readlines()
            with open(poscar, "w") as f:
                for line in lines:
                    if "CsSnI3" in line.split() :
                        f.write('CsSnI3 Cubic \n')
                    else :
                        f.write(line)


            output = os.path.join(folder,ID)
            with open(output, "r") as f:
                lines = f.readlines()
            with open(output, "w") as f:
                for line in lines:
                    if "Time" in line.split() :
                        temp = line[8:-1]
                        f.write(temp)
                        f.write('\n')
                    else :
                        f.write(line)
            with open(output, "a") as f:
                f.write('\n')
                f.write(temp)

            run = 'VASP2MySQL'
            os.system(run)