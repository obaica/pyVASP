"""
Application: Defect Atom
Written by:  Dr.Kittiphong Amnuyswat
Date:        17/09/2018
"""

import sys
import os
import subprocess
import numpy
import datetime
import time


print("\nCurrent date and time: " , datetime.datetime.now().strftime("%d-%m-%Y %H-%M-%S"))


root = '/home/kittiphong/VASP_works/CH3NH3PbX3/mixed-halide/'
path = root + 'antisite-1/'
os.mkdir(path)


############### Read data ###############
print("\nReading POSCAR \n")

poscar = root + 'POSCAR'
with open(poscar) as file:
  data = file.readlines()

  print("System : ",data[0])

  atom_list = data[5].split()
  num_each_atom = data[6].split()
  
  num_atom_type = 0
  num_all_atom = 0
  for i in num_each_atom:
    num_all_atom = num_all_atom+int(i)
    num_atom_type = num_atom_type+1
  print("Total atom : ",num_all_atom)

  i=0
  while (i<num_atom_type):
    print("[",i,"] Atom",atom_list[i], ": ",num_each_atom[i]) 
    i = i+1
  
  print("\n*** Defect system ***")
  list_replace_atom = input("What's atom to replace ? ")
  replaced_atom = input("Replace by ? ")


### Antisite defect 1
  num_defect=0
  while num_defect<int(num_each_atom[int(list_replace_atom)]):
    print("[1 antisite] >> ",num_defect+1)
    pwd = path + '/' + str(num_defect+1)
    os.mkdir(pwd)
    os.chdir(pwd)
    filename="POSCAR"
    output = open(filename, "w")
    line_defect = 0
    temp_atom_type = 0
    temp_num_defect = 0
    for line in data:
      if line_defect<5:
        output.write(data[line_defect])

      elif line_defect==6:
        m=0
        while m<num_atom_type:
          output.write(atom_list[m])
          output.write(" ")
          m = m+1
        output.write(replaced_atom)

      elif line_defect==7:
        output.write("\n")
        m=0
        while m<num_atom_type:
          if m==int(list_replace_atom):
            temp_num_defect = int(num_each_atom[m])-1
            output.write(str(temp_num_defect))
            output.write(" ")
          else:
            output.write(num_each_atom[m])
            output.write(" ")
          m = m+1
        output.write(" 1")

      elif line_defect==8:
        output.write("\nDirect\n")
        temp_num_defect = -1
        defect_found = 0

      elif line_defect>=9:
        if temp_atom_type >= num_atom_type:
          if defect_found>0:
            output.write(defect_location)
            defect_found = defect_found-1
          else:
            output.write(data[line_defect])
        else:
          if temp_atom_type==int(list_replace_atom):
            if temp_num_defect==num_defect:
              defect_location = data[line_defect-1]
              defect_found = defect_found+1
            else:
              output.write(data[line_defect-1])
            if temp_num_defect==int(num_each_atom[int(list_replace_atom)])-1:
              temp_atom_type = temp_atom_type+1
              temp_num_defect = -1
          else:
            output.write(data[line_defect-1])
            if temp_num_defect==int(num_each_atom[temp_atom_type])-1:
              temp_atom_type = temp_atom_type+1
              temp_num_defect = -1

      temp_num_defect = temp_num_defect+1
      line_defect = line_defect+1
    output.close()

    temp_command = 'cp ' + root + '/INCAR ' + pwd
    os.system(temp_command)
    temp_command = 'cp ' + root + '/KPOINTS ' + pwd
    os.system(temp_command)
    temp_command = 'cp ' + root + '/POTCAR ' + pwd
    os.system(temp_command)
    temp_command = 'cp ' + root + '/vdw_kernel.bindat ' + pwd
    os.system(temp_command)
    temp_command = 'cp ' + root + '/MALI.pbs ' + pwd + '/MALI-' + str(num_defect) + '.pbs'
    os.system(temp_command)

    os.chdir(pwd)
    temp = 'qsub ' + pwd + '/*.pbs'
    os.system(temp)
    num_defect = num_defect+1

file.close()