#!/usr/bin/env python
## Application: Convert CIF to POSCAR by pymatgen
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    20/04/2020

import os
import sys
import datetime
import time

sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP/')
os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("Convert CIF to POSCAR by pymatgen")
print("")

import fnmatch
import pandas as pd

mycif = []
localDir = os.getcwd()
pattern = ("*.cif")
for file in os.listdir(localDir):
    if fnmatch.fnmatch(file, pattern):
        mycif.append(file)

pattern = ("*.CIF")
for file in os.listdir(localDir):
    if fnmatch.fnmatch(file, pattern):
        mycif.append(file)

mycif = pd.DataFrame(mycif)
print("CIF file : ",mycif)
print()
num = int(input("Select CIF no. : "))
file = mycif.iloc[num].to_string().split()
temp = os.path.join(localDir,file[1])
print(temp)
print()

import pymatgen as mg

cif = mg.Structure.from_file(temp)
print(cif)
cif.to(filename="POSCAR", fmt="poscar")
print("Finished save POSCAR from ",file)
