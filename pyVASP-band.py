#!/usr/bin/env python
## Application: Plotting Band structure from VASP vasprun
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    22/04/2020

import sys
import os
import numpy as np
import math
import datetime
import time
import matplotlib.pyplot as plt
import pandas as pd
from pandas import DataFrame
from vasp import *


sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP')
os.system('clear')
print("Plotting Band structure from VASP vasprun")
print("\nCurrent date and time: " , datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))


localDir = os.getcwd()

temp = os.path.join(localDir,'INCAR')
with open(temp) as file:   
  incar = file.readlines()
file.close()

temp = os.path.join(localDir,'OUTCAR')
with open(temp) as file:   
  outcar = file.readlines()
file.close()

temp = os.path.join(localDir,'KPOINTS')
with open(temp) as file:   
  kpoints = file.readlines()
file.close()

temp = os.path.join(localDir,'POTCAR')
with open(temp) as file:   
  potcar = file.readlines()
file.close()


soc = getSOC(outcar)
nelect = getNELC(outcar)
ispin = getSPIN(outcar)
nband = getNB(outcar)
[nkpt,nkdim] = getNKPT(outcar)
[nvb,occ] = getNVB(nelect,ispin,soc)


print('\n>> Reading Eigen Energy from OUTCAR')
i=0
temp = os.path.join(localDir,'EG')
file_band = open(temp,"w")
for line in outcar:
  i+=1
  if "E-fermi" in line.split():
    fermi_line_no = i

line = outcar[fermi_line_no-1]
temp = line.split()
EF = float(temp[2])
print("Fermi level :",EF,"eV")
file_band.write("Fermi energy = %f eV\n" % EF)


### create blank DataFrame
band = pd.DataFrame()


i=0
while i<nkpt :
  fermi_line_no = fermi_line_no+2
  line = outcar[fermi_line_no]
  temp = line.split()
  kpt_x = float(temp[3])
  kpt_y = float(temp[4])
  kpt_z = float(temp[5])

  payload = {
    'kpt_x': [kpt_x],
    'kpt_y': [kpt_y],
    'kpt_z': [kpt_z],
    }
  df_kpt = pd.DataFrame(payload, index=[0])
  
  fermi_line_no = fermi_line_no+1
  j = 0
  bandx = []
  while j<nband :
    fermi_line_no = fermi_line_no+1
    line = outcar[fermi_line_no]
    temp = line.split()
    bandx.append(float(temp[1]))             ### i = nkpt / j = nbands ###
    j = j+1

  df_temp = pd.DataFrame(bandx)
  df_band = df_temp.T
  
  df = pd.concat([df_kpt,df_band],axis=1,ignore_index=True)
  band = pd.concat([band,df],axis=0,ignore_index=True)
  i+=1

# print('\nBAND level : \n',band.head())


### Find VBM
vb = band[nvb+2]
vbm = vb.max()
print('VBM :',vbm)


### Find CBM
cb = band[nvb+3]
cbm = cb.min()
print('CBM :',cbm)

print('Eg  :',cbm-vbm)

### Shift energy
print()
print('>> Shifting energy level ...')
temp = band
for i in range(nband) :
  band[i+3] = temp[i+3]-vbm
# print('\nBAND level : \n',band.head())


### Plotting
x=range(1,nkpt+1)
plt.figure(figsize=(7,10))
for i in range(nband) :
  if i < nvb :
    plt.plot(x,band[i+3],'b')
  else :
    plt.plot(x,band[i+3],'r')
## plt.plot(x,[0] *len(x), 'k--')
plt.xlabel('KPOINTS')
plt.ylabel('Energy (eV)')
plt.title('VASP Band Structure')
plt.grid(True)

step = int(kpoints[1])
label=[]
temp=kpoints[4].split()
label.append(temp[4])
j = 1
for i in range(5,len(kpoints)) :
  temp=kpoints[i].split()
  if len(temp)>1 :
    if temp[4]!=label[j-1] :
      label.append(temp[4])
      j = j+1
  
plt.xticks(np.arange(0, nkpt+1, step), label)
plt.savefig('BAND.png')
plt.show()
print("Saving BAND.png ...")