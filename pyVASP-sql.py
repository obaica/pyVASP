#!/usr/bin/env python
## Application: Collect all VASP parameters and insert to nanoKMILT database server
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    29/11/2019

import os
import sys
import json
import pprint
import numpy
import math
import datetime
import time
from collections import defaultdict
import platform
import pymysql.cursors
import pandas as pd


sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP')
os.system('clear')
print("Collect all VASP parameters and insert to nanoKMITL database server")
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("")

############# Walk all directory #############
import fnmatch
localDir = os.getcwd()
for folder, subs, files in os.walk(localDir) :
  pattern = "output.*"
  for ID in os.listdir(folder):
    if fnmatch.fnmatch(ID, pattern):
        temp = ID.split('.')
        JobID = int(temp[1])
        print("JobID   = ",JobID)

        ######################### Opening DB connection #########################
        import sql
        connection = pymysql.connect(host = sql.host,
                                     user = sql.user,
                                     password = sql.password,
                                     db = sql.db,
                                     charset='utf8',
                                     cursorclass=pymysql.cursors.DictCursor)
        with connection.cursor() as cursor:
            sql = "select `JobID` from `INCAR`"
            cursor.execute(sql)
            result = cursor.fetchall()
        connection.commit()
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
                    break
        temp = os.path.join(folder,ID)
        print("CWD     = ",os.path.abspath(folder))


        ######################### Read all files #########################
        print("")
        print('>>> Opening output .....')
        with open(temp) as file:   
            output = file.readlines()
        file.close()

        print('>>> Opening POSCAR .....')
        temp = os.path.join(folder,'POSCAR')
        with open(temp) as file:   
            poscar = file.readlines()
        file.close()

        print('>>> Opening KPOINTS .....')
        temp = os.path.join(folder,'KPOINTS')
        with open(temp) as file:   
            kpoints_file = file.readlines()
        file.close()

        print('>>> Opening OUTCAR .....')
        temp = os.path.join(folder,'OUTCAR')
        with open(temp) as file:   
            outcar = file.readlines()
        file.close()

        print('>>> Opening POTCAR .....')
        temp = os.path.join(folder,'POTCAR')
        with open(temp) as file:   
            potcar = file.readlines()
        file.close()

        import xmltodict
        print('>>> Opening vasprun.xml .....')
        temp = os.path.join(folder,"vasprun.xml")
        from vasp import del_PRECFOCK
        del_PRECFOCK(temp)
        with open(temp) as file:   
            vasprun = xmltodict.parse(file.read())
        file.close()


        ######################### Read INCAR #########################
        incar=defaultdict(list)
        for j in vasprun['modeling']['incar']['i'] :
            key = j['@name']
            value = j['#text']
            incar[key].append(value)

        ######################### Read generator #########################
        generator=defaultdict(list)
        for j in vasprun['modeling']['generator']['i'] :
            key = j['@name']
            value = j['#text']
            generator[key].append(value)

        ######################### Read parameters general #########################
        general=defaultdict(list)
        for j in vasprun['modeling']['parameters']['separator'][0]['i'] :
            key = j['@name']
            value = j['#text']
            general[key].append(value)

        ######################### Read kpoints #########################
        kpoints=defaultdict(list)
        algo = general['SYSTEM'][0]
        if algo == 'BAND' :
            try :
                key = vasprun['modeling']['kpoints']['generation']['i']['@name']
                value = vasprun['modeling']['kpoints']['generation']['i']['#text']
                kpoints[key].append(value)
            except :
                print("Manual KPOINTS")
                key = "divisions"
                value = 0
                kpoints[key].append(value)

            key = 'usershift'
            value = 0
            kpoints[key].append(value)
        elif algo == 'GW0' or algo == 'GW' :
            for j in vasprun['modeling']['kpoints'][0]['generation']['v'] :
                key = j['@name']
                value = j['#text']
                kpoints[key].append(value)
        else :
            for j in vasprun['modeling']['kpoints']['generation']['v'] :
                key = j['@name']
                value = j['#text']
                kpoints[key].append(value)

        ######################### Read parameters electronic #########################
        electronic=defaultdict(list)
        ## pprint.pprint(vasprun['modeling']['parameters']['separator'][1])
        for j in vasprun['modeling']['parameters']['separator'][1]['i'] :
            key = j['@name']
            value = j['#text']
            electronic[key].append(value)

        ######################### Read parameters smearing #########################
        smearing=defaultdict(list)
        ## pprint.pprint( vasprun['modeling']['parameters']['separator'][1]['separator'][0] )
        for j in vasprun['modeling']['parameters']['separator'][1]['separator'][0]['i'] :
            key = j['@name']
            value = j['#text']
            smearing[key].append(value)

        ######################### Read parameters spin #########################
        spin=defaultdict(list)
        ## pprint.pprint( vasprun['modeling']['parameters']['separator'][1]['separator'][3] )
        for j in vasprun['modeling']['parameters']['separator'][1]['separator'][3]['i'] :
            key = j['@name']
            value = j['#text']
            spin[key].append(value)

        ######################### Read parameters ionic #########################
        ionic=defaultdict(list)
        ## pprint.pprint( vasprun['modeling']['parameters']['separator'][3] )
        for j in vasprun['modeling']['parameters']['separator'][3]['i'] :
            key = j['@name']
            value = j['#text']
            ionic[key].append(value)

        ######################### Read parameters dos #########################
        dos=defaultdict(list)
        ## pprint.pprint(vasprun['modeling']['parameters']['separator'][6])
        for j in vasprun['modeling']['parameters']['separator'][6]['i'] :
            key = j['@name']
            value = j['#text']
            dos[key].append(value)

        ######################### Read parameters exchange-correlation #########################
        xc=defaultdict(list)
        ## pprint.pprint(vasprun['modeling']['parameters']['separator'][10]['i'])
        for j in vasprun['modeling']['parameters']['separator'][10]['i'] :
            key = j['@name']
            value = j['#text']
            xc[key].append(value)

        ######################### Read parameters vdW #########################
        vdW=defaultdict(list)
        ## pprint.pprint(vasprun['modeling']['parameters']['separator'][11]['i'])
        for j in vasprun['modeling']['parameters']['separator'][11]['i'] :
            key = j['@name']
            value = j['#text']
            vdW[key].append(value)

        ######################### Read parameters GW #########################
        GW=defaultdict(list)
        ## pprint.pprint(vasprun['modeling']['parameters']['separator'][15]['i'])
        for j in vasprun['modeling']['parameters']['separator'][15]['i'] :
            key = j['@name']
            value = j['#text']
            GW[key].append(value)

        ######################### Read parameters atominfo #########################
        atom=defaultdict(list)
        #pprint.pprint(vasprun['modeling']['atominfo'])
        atom['atoms'].append(vasprun['modeling']['atominfo']['atoms'])
        atom['types'].append(vasprun['modeling']['atominfo']['types'])

        ######################### Read parameters dimension #########################
        from vasp import getPOT
        PseudoPot = getPOT(potcar)

        pot=defaultdict(list)
        no_atom = int(atom['types'][0])
        ## pprint.pprint(vasprun['modeling']['atominfo']['array'][1]['set']['rc'][0]['c'])
        j = 0
        while j < no_atom :
            key = 'atom'+str(j)
            value = vasprun['modeling']['atominfo']['array'][1]['set']['rc'][j]['c'][1]
            pot[key].append(value)
            j = j+1
        j = 0
        while j < no_atom :
            key = 'valence'+str(j)
            value = vasprun['modeling']['atominfo']['array'][1]['set']['rc'][j]['c'][3]
            pot[key].append(value)
            j = j+1
        j = 0
        while j < no_atom :
            key = 'name'+str(j)
            value = vasprun['modeling']['atominfo']['array'][1]['set']['rc'][j]['c'][4]
            pot[key].append(value)
            j = j+1


        ######################### Read parameters basis #########################
        ## pprint.pprint(vasprun['modeling']['structure'][1])
        atom['basis'].append(str(vasprun['modeling']['structure'][1]['crystal']['varray'][0]['v']))

        n = len(atom['basis'][0])
        bas = atom['basis'][0][2:n-2].split()
        basis_a = bas[0]
        basis_b = bas[4]
        basis_c = bas[8]


        ######################### Read vasp output #########################
        print("")
        from vasp import getPOS
        [material,structure] = getPOS(poscar)

        from vasp import getTOTEN
        toten = getTOTEN(outcar)

        from vasp import getNKPT
        [nkpt,nkdim] = getNKPT(outcar)

        nelect = electronic['NELECT']
        print("No. electron = ",nelect[0])
        ispin = spin['ISPIN']
        print("ispin        = ",ispin[0])
        soc = spin['LNONCOLLINEAR']
        print("SOC          = ",soc[0])
        from vasp import getNVB
        [nvb,occ] = getNVB(float(nelect[0]),int(ispin[0]),soc[0])

        algo = general['SYSTEM']
        print("algoritm     = ",algo[0])
        nbands = electronic['NBANDS']
        print("NBANDS       = ",nbands[0])
        from vasp import getGEG
        [homo,lumo] = getGEG(folder,kpoints_file,outcar,algo[0],nkpt,nvb,float(nelect[0]),int(nbands[0]),occ)

        from vasp import getTIME
        [start,stop]=getTIME(output)
        print("START     = ",start)
        print("STOP      = ",stop)

        from datetime import datetime
        datetimeFormat = '%Y-%m-%d %H:%M:%S'
        duration = datetime.strptime(stop, datetimeFormat) - datetime.strptime(start, datetimeFormat)
        duration_in_s = duration.total_seconds()
        minutes = divmod(duration_in_s, 60)[0]

        print("")



        ######################### Use in paper 2020 #########################
        overall_2020 = False



        ######################### INSERT INTO TABLE #########################
        with connection.cursor() as cursor:
            sql = "INSERT INTO `KPOINTS` (`jobid`,`divisions`,`usershift`,`NKPTS`) VALUES (%s,%s,%s,%s)"
            cursor.execute(sql, (JobID,kpoints['divisions'],kpoints['usershift'],nkpt ))
        connection.commit()

        with connection.cursor() as cursor:
            sql = "INSERT INTO `POSCAR` (`jobid`,`material`,`structure`,`atoms`,`type`,`a`,`b`,`c`,`basis`) \
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            cursor.execute(sql, (JobID,material,structure,atom['atoms'],atom['types'],basis_a,basis_b,basis_c,atom['basis'] ))
        connection.commit()

        with connection.cursor() as cursor:
            sql = "INSERT INTO `INCAR` (`jobid`,`version`,`type`, \
                `precision`,`IALGO`,`ENMAX`,`NBANDS`,`NELECT`,`EDIFF`, \
                `ISMEAR`,`SIGMA`, \
                `ISPIN`,`SOC`, \
                `ISIF`,`NSW`,`EDIFFG`, \
                `NEDOS`, \
                `XC`,`HSE`,`AEXX`, \
                `vdW`, \
                `GW` ) \
                VALUES (%s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s) "
            cursor.execute(sql, (JobID,generator['version'],general['SYSTEM'], \
                electronic['PREC'],electronic['IALGO'], electronic['ENMAX'],electronic['NBANDS'],electronic['NELECT'],electronic['EDIFF'], \
                smearing['ISMEAR'],smearing['SIGMA'], \
                spin['ISPIN'],spin['LNONCOLLINEAR'], \
                ionic['ISIF'],ionic['NSW'],ionic['EDIFFG'], \
                dos['NEDOS'], \
                xc['GGA'],xc['LHFCALC'],xc['AEXX'], \
                vdW['LUSE_VDW'], \
                GW['LSPECTRAL'] ))
        connection.commit()
        
        with connection.cursor() as cursor:
            sql = "INSERT INTO `OUTCAR` (`jobid`,`TOTEN`,`NVB`,`LUMO`,`HOMO`,`EG`,`start`,`stop`,`minute`) \
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            cursor.execute(sql, (JobID,toten,nvb,lumo,homo,lumo-homo,start,stop,minutes))
        connection.commit()

        with connection.cursor() as cursor:
            if no_atom == 1 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`) VALUES (%s,%s,%s,%s,%s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'] ))
            elif no_atom == 2 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`, \
                    `atom_2`,`var_2`,`pot_2`) \
                    VALUES (%s,%s,%s,%s,%s, %s,%s,%s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'], \
                    pot['atom1'],pot['valence1'],pot['name1'] ))
            elif no_atom == 3 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`, \
                    `atom_2`,`var_2`,`pot_2`, \
                    `atom_3`,`var_3`,`pot_3`) \
                    VALUES (%s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'], \
                    pot['atom1'],pot['valence1'],pot['name1'], \
                    pot['atom2'],pot['valence2'],pot['name2']  ))
            elif no_atom == 4 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`, \
                    `atom_2`,`var_2`,`pot_2`, \
                    `atom_3`,`var_3`,`pot_3`, \
                    `atom_4`,`var_4`,`pot_4`) \
                    VALUES (%s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'], \
                    pot['atom1'],pot['valence1'],pot['name1'], \
                    pot['atom2'],pot['valence2'],pot['name2'], \
                    pot['atom3'],pot['valence3'],pot['name3']  ))
            elif no_atom == 5 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`, \
                    `atom_2`,`var_2`,`pot_2`, \
                    `atom_3`,`var_3`,`pot_3`, \
                    `atom_4`,`var_4`,`pot_4`, \
                    `atom_5`,`var_5`,`pot_5`) \
                    VALUES (%s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'], \
                    pot['atom1'],pot['valence1'],pot['name1'], \
                    pot['atom2'],pot['valence2'],pot['name2'], \
                    pot['atom3'],pot['valence3'],pot['name3'], \
                    pot['atom4'],pot['valence4'],pot['name4']  ))
            elif no_atom == 6 :
                sql = "INSERT INTO `POTCAR` (`jobid`,`pot`,`atom_1`,`var_1`,`pot_1`, \
                    `atom_2`,`var_2`,`pot_2`, \
                    `atom_3`,`var_3`,`pot_3`, \
                    `atom_4`,`var_4`,`pot_4`, \
                    `atom_5`,`var_5`,`pot_5`, \
                    `atom_6`,`var_6`,`pot_6`) \
                    VALUES (%s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s,%s, %s,%s,%s,%s,%s)"
                cursor.execute(sql, (JobID,PseudoPot,pot['atom0'],pot['valence0'],pot['name0'], \
                    pot['atom1'],pot['valence1'],pot['name1'], \
                    pot['atom2'],pot['valence2'],pot['name2'], \
                    pot['atom3'],pot['valence3'],pot['name3'], \
                    pot['atom4'],pot['valence4'],pot['name4'], \
                    pot['atom5'],pot['valence5'],pot['name5']  ))
        connection.commit()

        with connection.cursor() as cursor:
            sql = "INSERT INTO `2020` (`jobid`,`overall`) VALUES (%s,%s)"
            cursor.execute(sql, (JobID,overall_2020))
        connection.commit()

        connection.close()