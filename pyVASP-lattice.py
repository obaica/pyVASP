#!/usr/bin/env python
## Application: Optimized lattice size from VASP
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    22/04/2020

import sys
import os
import numpy as np
import math
import datetime
import time
import matplotlib.pyplot as plt


sys.path.append('/Volumes/kaswat200GB/GitHub/pyVASP')
os.system('clear')
print("Optimized lattice size from VASP")
print("\nCurrent date and time: " , datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))


localDir = os.getcwd()
print("\nReading data from VASP \n")

with open("./data") as file:   
	data = file.readlines()
	lattice = []
	energy = []
	for line in data:
		words = line.split()
		lattice.append(float(words[0]))
		energy.append(float(words[1]))
file.close()

i=0
print("Lattice     Energy")
for x in lattice:
	print("%5.2f    %8.6f" % (lattice[i], energy[i]))
	i+=1


############### Polynomail Fitting ###############
fit = np.polyfit(lattice,energy,3)
# print(fit)

fit2 = []
fit2.insert(0,3*fit[0])
fit2.insert(1,2*fit[1])
fit2.insert(2,1*fit[2])

root = np.roots(fit2)
# print(root)


print("\n")
with open("./temp",'w') as file:
	if (float(root[0])>=lattice[0]) and (float(root[0])<=lattice[len(lattice)-1]):
		print("Minimized lattice is : ", (root[0]))
		file.write(str(root[0]))
		file.close()
		# sys.exit(1)
	elif (float(root[1])>=lattice[0]) and (float(root[1])<=lattice[len(lattice)-1]):
		print("Minimized lattice is : ", (root[1]))
		file.write(str(root[1]))
		file.close()
		# sys.exit(1)
	else:
		print("No root")
		# sys.exit(0)



############### Plotting ###############
xx = np.linspace(lattice[0],lattice[-1],num=len(lattice)*10)
# print(xx)
yfit = np.polyval(fit,xx)
# print(yfit)

fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
# ax1.scatter(lattice, energy, facecolors='None')
plt.plot(lattice,energy,'bo')
plt.plot(xx,yfit,'r--') 
plt.savefig('lattice.png')
plt.show()