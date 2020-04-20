#!/usr/bin/env python
## Application: plot band structure by pymatgen
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    20/04/2020
## Original:    http://home.ustc.edu.cn/~lipai/scripts/vasp_scripts/python_plot_dos_band.html

import os
import sys
import datetime
import time

sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP/')
os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("")

import pymatgen as mg

import fnmatch
localDir = os.getcwd()
pattern = input("Input CIF file :")
for file in os.listdir(localDir):
    if fnmatch.fnmatch(file, pattern):
        temp = os.path.join(localDir,file)
        ## cif = mg.Structure.from_str(open(temp).read(), fmt="cif")
        cif = mg.Structure.from_file("CsCl.cif")
        print(cif)
        cif.to(filename="POSCAR", fmt="poscar")
        print("Finished save POSCAR from ",pattern)
