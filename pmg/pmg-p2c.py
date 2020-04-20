#!/usr/bin/env python
## Application: Convert POSCAR to CIF by pymatgen
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    20/04/2020

import os
import sys
import datetime
import time

sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP/')
os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("Convert POSCAR to CIF by pymatgen")
print("")

localDir = os.getcwd()
temp = os.path.join(localDir,"POSCAR")
print("POSCAR : ",temp)
print()

import pymatgen as mg
cif = mg.Structure.from_file(temp)
cif.to(filename="POSCAR.cif")
print("Finished save CIF from POSCAR")
