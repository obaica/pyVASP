"""
Application: SOC
Written by:  Dr.Kittiphong Amnuyswat
Date:        21/07/2018
"""

import sys
import os
import numpy
import datetime
import time
import subprocess
from subprocess import call


print("\nCurrent date and time: " , datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))


root = '/home/kittiphong/VASP_works/CsSnX3/CsSnI3'
SOC_path = root + '/' + 'SOC'
os.mkdir(SOC_path)

################ LMAXMIX ################
LMAXMIX = ['2','4','6']


################ SAXIS ################
SAXIS = []
for i in range(0,2):
	for j in range(0,2):
		for k in range(0,2):
			temp = str(i) + ' ' + str(j) + ' ' + str(k)
			SAXIS.append(temp)


n=1
for LM in LMAXMIX:
	temp = SOC_path + '/LAMXMIX-' + LM
	os.mkdir(temp)
	for SM in range(1,len(SAXIS)):
		temp = SOC_path + '/LAMXMIX-' + LM + '/SAXIS' + str(SM)
		os.mkdir(temp)
		for MM in range(1,16):
			os.chdir(root)

			folder = SOC_path + '/LAMXMIX-' + LM + '/SAXIS' + str(SM) + '/MAXMOM' + str(MM)	
			os.mkdir(folder)

			temp = 'cp ' + root + '/ATOM ' + folder + '/POSCAR'
			os.system(temp)

			temp = 'cp ' + root + '/POTCAR ' + folder
			os.system(temp)

			temp = 'cp ' + root + '/KPOINTS-shift ' + folder + '/KPOINTS'
			os.system(temp)
			
			filenames = ['INCAR.nsc', 'INCAR.soc']
			with open('INCAR', 'w') as outfile:
				outfile.write("system = CsSnI3 - SOC")
				for fname in filenames:
					with open(fname) as infile:
						content = infile.read()
						outfile.write(content)
					infile.close()
				outfile.write("NBANDS  = 512\n")
				temp = "LMAXMIX = " + LM + '\n'
				outfile.write(temp)
				temp = "SAXIS   = " + SAXIS[SM] + '\n'
				outfile.write(temp)

				MAXMOM = "MAXMOM  = "
				for i in range(1,MM):
					MAXMOM = MAXMOM + '0 '
				MAXMOM = MAXMOM + '1 '
				for i in range(MM,16):
					MAXMOM = MAXMOM + '0 '

				temp = MAXMOM + '\n'
				outfile.write(temp)
				outfile.close()

			temp = 'mv ' + root + '/INCAR ' + folder
			os.system(temp)

			temp = 'cp ' + root + '/CTI.pbs ' + folder + '/CTI' + str(n) + '.pbs'
			os.system(temp)
			
			# temp = 'cd ' + folder
			os.chdir(folder)
			
			temp = 'qsub ' + folder + '/CTI' + str(n) + '.pbs'
			# subprocess.call(temp, shell=True)
			os.system(temp)
			
			n = n+1 

