import os
import fnmatch


localDir = os.getcwd()
for folder, subs, files in os.walk(localDir) :
    pattern = "output.*"
    for ID in os.listdir(folder) :
        if fnmatch.fnmatch(ID, pattern):
            os.chdir(folder)
            print(os.getcwd())


            vasprun = os.path.join(folder,'vasprun.xml')
            with open(vasprun, "r") as f:
                lines = f.readlines()
            with open(vasprun, "w") as f:
                for line in lines:
                    if "SYSTEM" in line.split('"') :
                        f.write('  <i type="string" name="SYSTEM"> GS </i> \n')
                    else :
                        f.write(line)


            poscar = os.path.join(folder,'POSCAR')
            with open(poscar, "r") as f:
                lines = f.readlines()
            with open(poscar, "w") as f:
                for line in lines:
                    if "CsPbI3" in line.split() :
                        f.write('CsPbI3 Cubic \n')
                    else :
                        f.write(line)


            output = os.path.join(folder,ID)
            with open(output, "r") as f:
                lines = f.readlines()
            with open(output, "w") as f:
                for line in lines:
                    if "Time" in line.split() :
                        temp = line[8:-1]
                        f.write(temp)
                        f.write('\n')
                    else :
                        f.write(line)
            with open(output, "a") as f:
                f.write('\n')
                f.write(temp)

            run = 'VASP2MySQL'
            os.system(run)