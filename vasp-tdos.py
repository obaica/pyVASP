#!/usr/bin/env python
## Application: plot Total DOS by pymatgen
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    20/04/2020
## Original:    http://home.ustc.edu.cn/~lipai/scripts/vasp_scripts/python_plot_dos_band.html

import os
import sys
import datetime
import time
import pandas as pd

sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP/')
os.system('clear')
print("Current date and time: ", datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))
print("")

from pymatgen.io.vasp import Vasprun
from pymatgen.electronic_structure.plotter import DosPlotter

localDir = os.getcwd()
temp = os.path.join(localDir,'vasprun.xml')
## v = Vasprun('./vasprun.xml')
v = Vasprun(temp)
tdos = v.tdos
plotter = DosPlotter()
plotter.add_dos("Total DOS", tdos)
## plotter.show()
plotter.save_plot('TDOS.eps')