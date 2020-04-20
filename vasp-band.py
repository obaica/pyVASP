#!/usr/bin/env python
## Application: plot band structure by pymatgen
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

from pymatgen.io.vasp import Vasprun, BSVasprun
from pymatgen.electronic_structure.plotter import BSPlotter

localDir = os.getcwd()
temp = os.path.join(localDir,'vasprun.xml')
v = BSVasprun(temp)
kpt = os.path.join(localDir,'KPOINTS')
bs = v.get_band_structure(kpoints_filename=kpt,line_mode=True)
plt = BSPlotter(bs)
plt.get_plot(vbm_cbm_marker=True)
plt.save_plot('band.eps')