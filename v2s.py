import os
import fnmatch
import sys
import datetime
import time
import pymysql.cursors
import pandas as pd


print("POSCAR >>>>> ")
mat = input("Material/Structure : ")


localDir = os.getcwd()
for folder, subs, files in os.walk(localDir) :
    pattern = "output.*"
    for ID in os.listdir(folder) :
        if fnmatch.fnmatch(ID, pattern):
            os.chdir(folder)
            print(os.getcwd())
            print('JobID = ',ID)


            ######################### Opening DB connection #########################
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
            connection.close()
            jobid = pd.DataFrame.from_dict(result)
            jobid = pd.DataFrame.from_dict(result)
            total = jobid.shape[0]
            maxid = int(jobid.iloc[total-1])
            temp = ID.split('.')
            if int(temp[1]) in jobid.values :
                for i in range(1,maxid+1) :
                    if i not in jobid.values :
                        newID = i
                        run = 'mv '+str(ID)+' output.'+str(newID)
                        os.system(run)
                        ID = 'output.'+str(newID)
                        print('JobID = ',ID)
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



            print("Job : \n 0. Conv\n 1. Relax\n 2. GS\n 3. GW\n 4. DOS\n 5. BAND")
            job = int(input("Job : "))
            if job == 3 :
                run = 'cp 03-GW/INCAR .'
                os.system(run)
                run = 'cp 03-GW/KPOINTS .'
                os.system(run)
                run = 'cp 03-GW/POSCAR .'
                os.system(run)
                run = 'cp 03-GW/POTCAR .'
                os.system(run)
                run = 'cp 03-GW/OUTCAR .'
                os.system(run)
                run = 'cp 03-GW/vasprun.xml .'
                os.system(run)
            vasprun = os.path.join(folder,'vasprun.xml')
            with open(vasprun, "r") as f:
                lines = f.readlines()
            with open(vasprun, "w") as f:
                for line in lines:
                    if "SYSTEM" in line.split('"') :
                        if job == 0 :
                            f.write('  <i type="string" name="SYSTEM"> Conv </i> \n')
                        elif job == 1 :
                            f.write('  <i type="string" name="SYSTEM"> Relax </i> \n')
                        elif job == 2 :
                            f.write('  <i type="string" name="SYSTEM"> GS </i> \n')
                        elif job == 3 :
                            f.write('  <i type="string" name="SYSTEM"> GW </i> \n')
                        elif job == 4 :
                            f.write('  <i type="string" name="SYSTEM"> DOS </i> \n')
                        elif job == 5 :
                            f.write('  <i type="string" name="SYSTEM"> BAND </i> \n')
                    else :
                        f.write(line)




            poscar = os.path.join(folder,'POSCAR')
            with open(poscar, "r") as f:
                lines = f.readlines()
            with open(poscar, "w") as f:
                f.write(mat)
                f.write('\n')
                lines.pop(0)
                for line in lines :
                    f.write(line)


            run = 'VASP2MySQL'
            os.system(run)