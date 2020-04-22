def getALGO(incar,kpoints,nsw,soc):
    algo = 'GGA'
    for line in incar:
        if "ALGO" in line.split():
            text = line.split()
            algo = text[2]
            if algo == 'scGW' :
                algo = 'GW'
            elif (algo=='Normal')&(nsw==0) :
                algo = 'GGA'
            elif nsw > 0 :
                algo = 'Relaxation'
        if "RWIG" in line.split():
            if int(kpoints[1])==0 :
                algo = "DOS"
            else :
                algo = "Band"
        if "HFSCREEN" in line.split():
            algo = "HSE06"
    if soc=='T':
        algo = algo+'+SOC'
    print("ALGO      = ",algo)
    return algo

def getCHARG(outcar):
    for line in outcar:
        if "ICHARG" in line.split():
            text = line.split()
            ICHARG = int(text[2])
            print("ICHARG    = ",ICHARG)
    return ICHARG

def getCPU(outcar):
    for line in outcar:
        if "running" in line.split() :
            if "on" in line.split() :
                text = line.split()
                ncpu = int(text[2])
    print("NCPU      = ",ncpu)
    return(ncpu)

def getENCUT(outcar):
    import math
    for line in outcar:
        if "ENCUT" in line.split():
            text = line.split()
            encut = math.floor(float(text[2]))
            print("ENCUT     = ",encut,'eV')
    return encut

def getENCUTGW(outcar):
    import math
    encutgw = 0
    for line in outcar:
        if "ENCUTGW" in line.split():
            text = line.split()
            encutgw = math.floor(float(text[2]))
            break
    print("ENCUTGW   = ",encutgw,'eV')
    return encutgw

def getGEG(folder,kpoints,outcar,algo,nkpt,nvb,nelect,nbands,occ):
    import os
    temp = os.path.join(folder,'EG')
    file_eg=open(temp,"w")
    i=0
    for line in outcar:
	    i+=1
	    if "E-fermi" in line.split():
		    fermi_line_no = i
    line = outcar[fermi_line_no-1]
    temp = line.split()
    EF = float(temp[2])
    file_eg.write("Fermi energy = %f eV\n" % EF)
    VB=[]
    CB=[]
    EG=[]

    shift = kpoints[4].split()

    if (algo=='GW') or (algo == 'GW+SOC') :
        i=0
        for line in outcar :
            i+=1
            if "iteration" in line.split():
                iteration_line_no = i
        file_eg.write("\n")
        i=0
        getHOMO = 0
        while i<nkpt :
            iteration_line_no = iteration_line_no+2
            line = outcar[iteration_line_no]
            temp = line.split()
            print(line)
            file_eg.write("k-point %d :  %f   %f   %f" % (i+1, float(temp[3]), float(temp[4]), float(temp[5])) )
            getkpt = 0
            if (float(temp[3])==float(shift[0])) & (float(temp[4])==float(shift[1])) & (float(temp[5])==float(shift[2])) :
                getHOMO = 1

            iteration_line_no = iteration_line_no+nvb+2
            line = outcar[iteration_line_no]
            temp = line.split()
            file_eg.write(" %d   %f   %f" % (int(temp[0]), float(temp[2]), float(temp[6])) )
            VB.insert(i,float(temp[2]))
            if getHOMO == 1 :
                homo = float(temp[2])
    
            line = outcar[iteration_line_no+1]
            temp = line.split()
            file_eg.write(" %d    %f   %f" % (int(temp[0]), float(temp[2]), float(temp[6])) )
            CB.insert(i,float(temp[2]))
            if getHOMO == 1 :
                lumo = float(temp[2])

            file_eg.write(" Eg = %2.4f eV" % ( CB[i]-VB[i]) )
            while getkpt == 0 :
                line = outcar[iteration_line_no]
                temp = line.split()
                if temp == [] :
                    getkpt = 1
                else :
                    iteration_line_no = iteration_line_no + 1

            i+=1
            file_eg.write("\n")
            getHOMO = 0
    elif (algo=='BAND') or (algo == 'DOS') or (algo == 'BSE') :
        lumo=0
        homo=0
    elif occ==1 :
        file_eg.write(">>> Eigen Energy <<<\n")
        i=0
        getHOMO = 0
        while i < nkpt:
            fermi_line_no = fermi_line_no+2
            line = outcar[fermi_line_no]
            temp = line.split()
            file_eg.write("k-point %d :  %f   %f   %f" % (i+1, float(temp[3]), float(temp[4]), float(temp[5])) )
            if (float(temp[3])==float(shift[0])) & (float(temp[4])==float(shift[1])) & (float(temp[5])==float(shift[2])) :
                getHOMO = 1

            fermi_line_no = fermi_line_no+nvb+1
            line = outcar[fermi_line_no]
            temp = line.split()
            file_eg.write(" %d   %f   %f" % (int(temp[0]), float(temp[1]), float(temp[2])) )
            VB.insert(i,float(temp[1]))
            if getHOMO == 1 :
                homo = float(temp[1])
		
            line = outcar[fermi_line_no+1]
            temp = line.split()
            file_eg.write(" %d    %f   %f" % (int(temp[0]), float(temp[1]), float(temp[2])) )
            CB.insert(i,float(temp[1]))
            if getHOMO == 1 :
                lumo = float(temp[1])

            EG.insert(i,CB[i]-VB[i])
            file_eg.write(" Eg = %4f eV" % EG[i] )
		
            fermi_line_no = fermi_line_no+nbands-nvb
            i+=1
            file_eg.write("\n")
            getHOMO = 0
        file_eg.write("Minimum Eg = %4f eV " % min(EG) )  #EG.index(min(EG))+1)
  
    if occ==2 :
        file_eg.write(">>> Eigen Energy <<<\n")
        getHOMO = 0
        for loop in range(2) :
            file_eg.write("\n")
            fermi_line_no = fermi_line_no+2
            text = outcar[fermi_line_no]
            file_eg.write(text)
            i=0
            while i < nkpt:
                fermi_line_no = fermi_line_no+2
                line = outcar[fermi_line_no]
                temp = line.split()
                file_eg.write("k-point %d :  %f   %f   %f" % (i+1, float(temp[3]), float(temp[4]), float(temp[5])))
                if (float(temp[3])==float(shift[0])) & (float(temp[4])==float(shift[1])) & (float(temp[5])==float(shift[2])) :
                    if getHOMO == 0 :
                        getHOMO = 1
                    elif getHOMO == 1 :
                        getHOMO = 0

                fermi_line_no = fermi_line_no+nvb+1
                line = outcar[fermi_line_no]
                temp = line.split()
                file_eg.write(" %d   %f   %f" % (int(temp[0]), float(temp[1]), float(temp[2])) )
                VB.insert(i,float(temp[1]))
                if getHOMO == 1 :
                    homo = float(temp[1])

                line = outcar[fermi_line_no+1]
                temp = line.split()
                file_eg.write(" %d    %f   %f" % (int(temp[0]), float(temp[1]), float(temp[2])) )
                CB.insert(i,float(temp[1]))
                if getHOMO == 1 :
                    lumo = float(temp[1])

                EG.insert(i,CB[i]-VB[i])
                file_eg.write(" Eg = %4f eV" % EG[i])

                fermi_line_no = fermi_line_no+nbands-nvb
                i+=1
                file_eg.write("\n")
                getHOMO = 0
        file_eg.write("Minimum Eg = %4f eV " % min(EG) )  #EG.index(min(EG))+1)

    file_eg.close()
    print("HOMO      = ",format(homo,">.4f"),'eV')
    print("LUMO      = ",format(lumo,">.4f"),'eV')
    return homo,lumo 

def getKPT(kpoints,algo):
    if (algo=='Band') or (algo == 'Band+SOC'):
        print("KPOINTS   = BAND/DOS")
        return "Band/DOS"
    else :
        temp = kpoints[2].rstrip("\n\r")
        num = kpoints[3].split()
        text = temp+' '+num[0]+' '+num[1]+' '+num[2]
        print("KPOINTS      = ",text)
        return text

def getNB(outcar):
    for line in outcar:
	    if "NBANDS=" in line.split():
		    text = line.split()
		    print("NBANDS    = ",text[14])
    return int(text[14])

def getNELC(outcar):
    import math
    for line in outcar:
        if "NELECT" in line.split():
            temp = line.split()
            nelect = math.floor(float(temp[2]))
            print("NELECT    = ",nelect)
    return nelect

def getNEDOS(outcar):
    for line in outcar:
        if "NEDOS" in line.split():
            text = line.split()
            nedos = int(text[5])
            nions = int(text[11])
            print("No. DOS   = ",nedos)
            print("No. ions  = ",nions)
    return nedos,nions

def getNKPT(outcar):
    for line in outcar:
        if "NKPTS" in line.split():
            text = line.split()
            nkpts = int(text[3])
            nkdim = int(text[9])
            print("No. KPTS     = ",nkpts)
            print("No. KPTS BZ  = ",nkdim)
    return nkpts,nkdim

def getNOMG(outcar):
    import math
    nomega = 0
    for line in outcar:
        if "NOMEGA" in line.split():
            text = line.split()
            nomega = math.floor(float(text[2]))
    print("NOMEGA    = ",nomega)
    return nomega

def getNSW(outcar):
    for line in outcar:
	    if "NSW" in line.split():
		    temp = line.split()
		    nsw = int(temp[2])
    print("NSW       = ",nsw)
    return nsw

def getNVB(nelect,ispin,soc):
    if soc=='T':
        occ = 1 
        nvb = int(nelect)
    elif ispin==1:  ## 1 = no spin / occupied 2 e per orbitals
        occ = 1
        nvb = int(nelect/2)
    else:           ## 2 = spin / occupied 1 e per orbitals
        occ = 2
        nvb = int(nelect/2)
    print("NVB          = ",nvb)
    return nvb,occ  ## no. to print eigen energy

def getPOT(potcar):
    PseudoPot = "PAW"
    for line in potcar:
        if "DFT-1/2" in line.split():
            print("PseudoPot   =  DFT-1/2")
            PseudoPot = "DFT-1/2"
    if PseudoPot == "PAW" :
        print("PseudoPot   =  PAW")
    return PseudoPot

def getSOC(outcar):
    for line in outcar:
	    if "LSORBIT" in line.split():
		    temp = line.split()
		    LSORBIT = temp[2]
    print("SOC       = ",LSORBIT)
    return LSORBIT

def getSPIN(outcar):
    import math
    for line in outcar:
        if "ISPIN" in line.split():
            temp = line.split()
            ispin = math.floor(float(temp[2]))
            print("ISPIN     = ",ispin," [ 1=no spin | 2=spin ]")
    return ispin

def getSYS(incar):
    for line in incar:
        if "System" in line.split():
            text = line.split()
    if len(text) < 5 :
        text.append(' ')
    print("System    = ",text[2])
    print("sub-sys   = ",text[3])
    print("sub       = ",text[4])
    return text[2],text[3],text[4]

def getTOTEN(outcar):
    toten = 0
    for line in outcar:
        if "TOTEN" in line.split():
            text = line.split()
            toten = text[4]
    print("TOTEN        = ",toten,'eV')
    return float(toten)

def getTIME(output):
    time = []
    for line in output:
        if "Time" in line.split():
            text = line.split()
            if text[3] == 'Jan':
                M = '01'
            elif text[3] == 'Feb':
                M = '02'
            elif text[3] == 'Mar':
                M = '03'
            elif text[3] == 'Apr':
                M = '04'
            elif text[3] == 'May':
                M = '05'
            elif text[3] == 'Jun':
                M = '06'
            elif text[3] == 'Jul':
                M = '07'
            elif text[3] == 'Aug':
                M = '08'
            elif text[3] == 'Sep':
                M = '09'
            elif text[3] == 'Oct':
                M = '10'
            elif text[3] == 'Nov':
                M = '11'
            elif text[3] == 'Dec':
                M = '12'

            if text[4]   == '0':
                D = '00'
            elif text[4] == '1':
                D = '01'
            elif text[4] == '2':
                D = '02'
            elif text[4] == '3':
                D = '03'
            elif text[4] == '4':
                D = '04'
            elif text[4] == '5':
                D = '05'
            elif text[4] == '6':
                D = '06'
            elif text[4] == '7':
                D = '07'
            elif text[4] == '8':
                D = '08'
            elif text[4] == '9':
                D = '09'
            else:
                D = text[4]
            temp = []
            temp = text[7]+'-'+M+'-'+D+' '+text[5]
            time.append(temp)
    return time

def getVERSION(outcar):
    for line in outcar:
        if "vasp.5.4.1" in line.split():
            text = line.split()
            version = text[0]
   # for line in outcar:
        elif "vasp.5.4.4.18Apr17-6-g9f103f2a35" in line.split():
            text = line.split()
            version = "vasp.5.4.4"
        elif "vasp.5.2.12" in line.split():
            text = line.split()
            version = text[0]
    print("VASP      = ",version)
    return version

def getPOS(poscar) :
    temp = poscar[0].split()
    print("Material     = ",temp[0])
    print("Structure    = ",temp[1])
    return temp[0],temp[1]

def del_PRECFOCK(vasprun) :
    with open(vasprun, "r") as f:
        lines = f.readlines()
    with open(vasprun, "w") as f:
        for line in lines:
            if "PRECFOCK" in line.split('"') :
                print(line)
            else :
                f.write(line)