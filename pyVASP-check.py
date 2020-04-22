#!/usr/bin/env python
## Application: Scans your input files and looks for common errors
## Written by:  Asst.Prof.Dr. Kittiphong Amnuyswat
## Updated:	    22/04/2020

import os
import sys
import subprocess
import logging
from optparse import OptionParser
import re, collections
import math
import random

# Classes for VASP input/output files

def cross(a,b):
  return [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]

def dot(a,b):
  return a[0]*b[0] + a[1]*b[1] + a[2]*b[2]

class Poscar:
  def __init__(self,filename="POSCAR", use_direct=True):
    #read data from POSCAR file
    poscarfile = open(filename,'r')
    poscardata = poscarfile.readlines()
    #look for POTCAR file and construct atom label list
    #TODO: if no POTCAR, maybe use generic list?
    atoms=[]
    potcar_lines=subprocess.getoutput("grep TITEL POTCAR").split("\n")
    if len(potcar_lines)==0:
      print("Cannot find atomic information in POTCAR. Missing POTCAR?")
      exit(1)
    for line in potcar_lines:
      words = line.split()
      assert(words[0] == 'TITEL')

      #Note, we need the split _ to deal with eg "Li_sv"
      atoms.append(words[3].split("_")[0])
      
    #save the POSCAR header tag for later use when saving the file
    self.description=poscardata[0].strip()
  
    self.direct = use_direct
  
    latticeconstant=float(poscardata[1].strip())
  
    #check if volume scaling (2nd line is negative number) is used
    volumescaling=False
    if latticeconstant < 0.0:
      volumescaling=True 
  
    #read cell parameters
    self.a=[]
    self.b=[]
    self.c=[]

    self.a.append(float(poscardata[2].split()[0].strip()))
    self.a.append(float(poscardata[2].split()[1].strip()))
    self.a.append(float(poscardata[2].split()[2].strip()))

    self.b.append(float(poscardata[3].split()[0].strip()))
    self.b.append(float(poscardata[3].split()[1].strip()))
    self.b.append(float(poscardata[3].split()[2].strip()))

    self.c.append(float(poscardata[4].split()[0].strip()))
    self.c.append(float(poscardata[4].split()[1].strip()))
    self.c.append(float(poscardata[4].split()[2].strip()))

    if volumescaling:
      #lattice constant is really a volume scaling factor
      #calculate unscaled volume from determinant
      
      unscaledvolume=self.a[0]*self.b[1]*self.c[2]-self.a[0]*self.b[2]*self.c[1]+self.a[1]*self.b[2]*self.c[0]-self.a[1]*self.b[0]*self.c[2]+self.a[2]*self.b[0]*self.c[1]-self.a[2]*self.b[1]*self.c[0]
      scalingfactor=(-latticeconstant/unscaledvolume)**(1.0/3.0)

      #apply scaling to lattice constants
      for i in range(0,3):
        self.a[i]=self.a[i]*scalingfactor
        self.b[i]=self.b[i]*scalingfactor
        self.c[i]=self.c[i]*scalingfactor
    else:
      #apply lattice constant
      for i in range(0,3):
        self.a[i]=self.a[i]*latticeconstant
        self.b[i]=self.b[i]*latticeconstant
        self.c[i]=self.c[i]*latticeconstant
    
    #Read atomic positions
    #The "atoms" array is an list with elements like this ("Fe",{0.95,0.5,0.00})
  
    # Skip atoms declaration if it is there
    offset = 5
    if ''.join(poscardata[offset].split()).isalpha():
      offset = offset + 1

    #Read atom counts
    atomlabels = []
    atomcounts = poscardata[offset].split()
    n_atoms = 0
    for i in range(0,len(atomcounts)):
      n = int(atomcounts[i].strip())
      n_atoms = n_atoms + n
      for j in range(0,n):
        atomlabels.append(atoms[i])

    # Advance one line
    offset = offset + 1

    #Check for selective dynamics
    if poscardata[offset].upper()[0] == 'S':
      offset = offset + 1
  
    # Check for direct coordinates
    direct_in_file = True
    if poscardata[offset].upper()[0] == 'C':
      direct_in_file = False
    elif poscardata[offset].upper()[0] == 'D':
      direct_in_file = True
  
    #scan atomic positions
    offset = offset + 1

    self.atoms=[]
    for i in range(offset,offset+n_atoms):
      if poscardata[i] != "" and not ''.join(poscardata[i].split()).isalpha():
        thisatom = [0,0]
        thisatom[0] = atomlabels[i-offset]

        rvector = []
        abc = poscardata[i].split()
    
        if len(abc) == 3:
          if use_direct:
            if direct_in_file:
              #Just save coords
              rvector.append(float(abc[0]))
              rvector.append(float(abc[1]))
              rvector.append(float(abc[2]))
            else:
              #Try to calculate direct coordinates
              #Assume that alpha=beta=gamma=90 deg for now
              if alpha_angle == 90.0 and beta_angle == 90.0 and gamma_angle == 90.0:
                rvector.append(float(abc[0])/a_length)
                rvector.append(float(abc[1])/b_length)
                rvector.append(float(abc[2])/c_length)
              else:
                print("Cannot yet initialize from Cartesian coordinates in non-orthorhombic cells")
                exit(1)
          else:
            if direct_in_file:
              #Convert direct coordinates to Cartesian here
              cx=float(abc[0])*self.a[0]+float(abc[1])*self.a[1]+float(abc[2])*self.a[2]
              cy=float(abc[0])*self.b[0]+float(abc[1])*self.b[1]+float(abc[2])*self.b[2]
              cz=float(abc[0])*self.c[0]+float(abc[1])*self.c[1]+float(abc[2])*self.c[2]
          
              rvector.append(cx)
              rvector.append(cy)
              rvector.append(cz)
            else:
              #Just save coords
              rvector.append(float(abc[0]))
              rvector.append(float(abc[1]))
              rvector.append(float(abc[2]))
            
        # else:
        #   print "Reached end of file when reading POSCAR (read %d lines)" % i
        #   exit(1)      

        thisatom[1] = rvector
        self.atoms.append(thisatom)
      else:
        print("Reached end of file when reading POSCAR (read %d lines)" % i)
        exit(1)

  #Some useful properties that can be calculated from the lattice vectors
  def volume(self):
    #Calculate volume using determinant
    #Formula is from "Vectors and Tensors in Crystallography" by Donald E. Sands
    return self.a[0]*self.b[1]*self.c[2]-self.a[0]*self.b[2]*self.c[1]+self.a[1]*self.b[2]*self.c[0]-self.a[1]*self.b[0]*self.c[2]+self.a[2]*self.b[0]*self.c[1]-self.a[2]*self.b[1]*self.c[0]
  
  def a_length(self):
    return math.sqrt(self.a[0]**2 + self.a[1]**2 + self.a[2]**2)

  def b_length(self):
    return math.sqrt(self.b[0]**2 + self.b[1]**2 + self.b[2]**2)

  def c_length(self):
    return math.sqrt(self.c[0]**2 + self.c[1]**2 + self.c[2]**2)
  
  def alpha_angle(self):
    #alpha = b-c
    return math.acos((self.b[0]*self.c[0] + self.b[1]*self.c[1] + self.b[2]*self.c[2])/(self.b_length() * 
self.c_length()))*180/math.pi

  def beta_angle(self):
    #beta = a-c
    return math.acos((self.a[0]*self.c[0] + self.a[1]*self.c[1] + self.a[2]*self.c[2])/(self.a_length() * 
self.c_length()))*180/math.pi

  def gamma_angle(self):
    #gamma = a-b
    return math.acos((self.b[0]*self.a[0] + self.b[1]*self.a[1] + self.b[2]*self.a[2])/(self.a_length() * 
self.b_length()))*180/math.pi

  #Crystallographer's definition, no 2*PI
  def reciprocal_a(self):
    return [cross(self.b,self.c)[0] / abs(dot(self.a,cross(self.b,self.c))),cross(self.b,self.c)[1] / 
abs(dot(self.a,cross(self.b,self.c))),cross(self.b,self.c)[2] / abs(dot(self.a,cross(self.b,self.c)))]

  def reciprocal_b(self):
    return [cross(self.c,self.a)[0] / abs(dot(self.b,cross(self.c,self.a))),cross(self.c,self.a)[1] / 
abs(dot(self.b,cross(self.c,self.a))),cross(self.c,self.a)[2] / abs(dot(self.b,cross(self.c,self.a)))]

  def reciprocal_c(self):
    return [cross(self.a,self.b)[0] / abs(dot(self.c,cross(self.a,self.b))),cross(self.a,self.b)[1] / 
abs(dot(self.c,cross(self.a,self.b))),cross(self.a,self.b)[2] / abs(dot(self.c,cross(self.a,self.b)))]

  #Physics style definition, 2*PI
  def pi2reciprocal_a(self):
    return [2.0*math.pi*reciprocal_a()[0],2.0*math.pi*reciprocal_a()[1],2.0*math.pi*reciprocal_a()[2]]

  def pi2reciprocal_b(self):
    return [2.0*math.pi*reciprocal_b()[0],2.0*math.pi*reciprocal_b()[1],2.0*math.pi*reciprocal_b()[2]]

  def pi2reciprocal_c(self):
    return [2.0*math.pi*reciprocal_c()[0],2.0*math.pi*reciprocal_c()[1],2.0*math.pi*reciprocal_c()[2]]
  
  def atom_counts(self):
    if len(self.atoms) != 0:
      kinds = []
      counts = []
      for a in self.atoms:
        if a[0] not in kinds:
          kinds.append(a[0])
          counts.append(1)
        else:
          counts[kinds.index(a[0])] = counts[kinds.index(a[0])] + 1
    return counts
  
  #File export options
  def save(self,filename="POSCAR"):
    newfile=open(filename,"w")

    newfile.write(self.description+"\n")

    #Put lattice constant to 1.0, because we have rescaled a,b,c vectors
    newfile.write("1.00\n")

    #a,b,c
    a_line = "%2.9f %2.9f %2.9f\n" % (self.a[0],self.a[1],self.a[2])
    b_line = "%2.9f %2.9f %2.9f\n" % (self.b[0],self.b[1],self.b[2])
    c_line = "%2.9f %2.9f %2.9f\n" % (self.c[0],self.c[1],self.c[2])
    newfile.write(a_line)
    newfile.write(b_line)
    newfile.write(c_line)

    #Atom counts
    atom_counts_string=""
    for c in self.atom_counts():
      atom_counts_string = atom_counts_string + str(c)+ " "

    newfile.write(atom_counts_string + "\n")

    #Coordinate type
    if self.direct:
      newfile.write("Direct\n")
    else:
      newfile.write("Cartesian\n")

    #Atomic positions
    for a in self.atoms:
      coord_line = "%2.9f %2.9f %2.9f\n" % (a[1][0],a[1][1],a[1][2])
      newfile.write(coord_line)
    newfile.close
    
    #Unit cell manipulations
  def scale_volume(self,scalingfactor):
    #apply scaling to lattice constants
    cuberootscale = scalingfactor**(1.0/3.0)
    for i in range(0,3):
        self.a[i] = self.a[i] * cuberootscale
        self.b[i] = self.b[i] * cuberootscale
        self.c[i] = self.c[i] * cuberootscale
    
  def shake(self,dR=0.1):
    for a in self.atoms:
        a[1][0] = a[1][0] + (-1.0+2.0*random.random())*dR
        a[1][1] = a[1][1] + (-1.0+2.0*random.random())*dR
        a[1][2] = a[1][2] + (-1.0+2.0*random.random())*dR

class Kpoints:
  def __init__(self,filename="KPOINTS"):
    #read data from KPOINTS file
    kfile = open(filename,'r')
    kdata = kfile.readlines()
    
    self.gridtype = "unknown"
    self.gridsize = 0
    self.origin = [0.0,0.0,0.0]
    
    self.description = kdata[0].strip()
    if kdata[2][0] == 'A':
      #Automatic generation of k-points
      self.gridtype = "Automatic"
      self.gridsize = int(kdata[3])
    elif kdata[2][0] == 'M':
      #Monkhorst-Pack grid
      self.gridtype = "Monkhorst-Pack"
      self.gridsize = map(int,kdata[3].split())
    elif kdata[2][0] == 'G':
      #Gamma-centered grid
      self.gridtype = "Gamma"
      self.gridsize = map(int,kdata[3].split())

    if len(kdata) > 4 and len(kdata[4])>0:
      self.origin = map(float,kdata[4].split())

  def save(self,filename="KPOINTS"):
    kfile = open(filename,"w")

    kfile.write(self.description+"\n")

    #We assume automatic generation here, always "0"
    kfile.write("0\n")

    kfile.write(self.gridtype+"\n")
    
    #The grid size, 1 number for Auto, 3 for Gamma/MP
    if self.gridtype == "Automatic":
      size_line = "%d \n" % (self.gridsize)
    elif self.gridtype == "Gamma" or self.gridtype == "Monkhorst-Pack":
      size_line = "%d %d %d\n" % (self.gridsize[0],self.gridsize[1],self.gridsize[2])
    kfile.write(size_line)
    
    origin_line = "%3.3f %3.3f %3.3f\n" % (self.origin[0],self.origin[1],self.origin[2])
    kfile.write(origin_line)
    kfile.close()
    
  def gridsize_str(self):
    if self.gridtype == "Automatic":
      return "A"+str(self.gridsize)
    elif self.gridtype == "Gamma" or self.gridtype == "Monkhorst-Pack":
      return "%dx%dx%d" % (self.gridsize[0],self.gridsize[1],self.gridsize[2])
    else:
      return "Unknown"
      
class Incar:
  #Basically a wrapper for the Dictionary class
  
  def __init__(self,filename="INCAR"):
    #Load all input tags into a hash
    self.tags = dict()

    taglines = subprocess.getoutput("grep \"=\" " + filename).split("\n")

    for line in taglines:
      tag_key = line.split("=")[0].strip()
      tag_value = line.split("=")[1].strip()

      #Don't load disabled tags
      if tag_key[0] != "#":
        self.tags[tag_key] = tag_value
  
  def has_tag(self,tagname):
    return (tagname in self.tags)
  
  def tag_value(self,tagname):
    #No error checking here, non-existing tags have the default value of nil
    return self.tags[tagname]
  
  def change_tag(self,tagname,value):
    self.tags[tagname] = value
    return (tagname in self.tags)
  
  def add_tag(self,tagname,value):
    self.tags[tagname] = value
  
  def zap_tag(self,tagname):
    self.tags.delete(tagname)
  
  def save(self,filename="INCAR"):
    newfile = open(filename,"w")
  
    taglist = self.tags.keys()
    taglist.sort()
    for tag in taglist:
      newfile.write(tag + " = " + self.tags[tag] + "\n")

    newfile.close

# Data extractors using grep
def get_total_energy(where):
  return float(subprocess.getoutput("grep \"free  energy\" " + where + "|tail -n 1").split()[4])

def get_ediff(where):
  return float(subprocess.getoutput("grep \"  EDIFF\" " + where).split()[2])
  
def get_scf_delay(where):
  return abs(int(subprocess.getoutput("grep NELMDL " + where).split()[6]))

def get_fermi(where):
  return float(subprocess.getoutput("grep \"E-fermi\" " + where).split()[2])

def get_entropy(where):
  return float(subprocess.getoutput("grep EENTRO " + where + "|tail -n 1").split()[4])

def get_external_pressure(where):
  return float(subprocess.getoutput("grep \"pressure\" " + where + "|tail -n 1").split()[3])

def get_number_of_kpoints(where):
  return int(subprocess.getoutput("grep \"NKPT\" " + where + "|tail -n 1").split()[3])

# Peter's Norvig's tiny spell checker in 20 lines...use it to check for misspelled INCAR tags
def words(text):
  return re.findall('[a-z]+', text.lower()) 

def train(features):
    model = collections.defaultdict(lambda: 1)
    for f in features:
        model[f] += 1
    return model

tag_db = train(words("""
  addgrid aexx aggac aggax aldac algo amin amix amix_mag apaco
  bmix bmix_mag cmbj cmbja cmbjb cshift deper dipol dq ebreak
  ediff ediffg efield_pead emax emin enaug encut evenonly
  ferdo ferwe gga gga_compat hfscreen i_constrained_m ialgo
  ibrion icharg ichibare icorelevel images imix inimix iniwav
  ipead isif ismear ispin istart isym iwavr kblock kgamma kpar
  kspacing lambda lasph lcalceps lcalcpol lcharg lchimag lcorr
  ldau ldauj ldaul ldauprint ldautype ldauu ldiag lefg lelf
  lepsilon lhfcalc lhyperfine lkproj lmaxfock lmaxfockae
  lmaxmix lmaxpaw lmaxtau lmixtau lnabla lnmr_sym_red
  lnoncollinear loptics lorbit lpead lplane lreal lrpa
  lscalapack lscalu lsorbit lspectral lthomas lvhar lvtot
  lwannier90 lwannier90_run lwave lwrite_mmn_amn m_constr
  magmom maxmix metagga mixpre nbands nblk nblock ncore ndav
  nedos nelect nelm nelmdl nelmin nfree ngx ngxf ngy ngyf
  ngyromag ngz ngzf nkred nkredx nkredy nkredz nlspline
  nomega nomegar npaco npar nsim nsw nupdown nwrite
  oddonly omegamax omegatl pflat plevel pomass potim
  prec precfock proutine pstress pthreshold quad_efg
  ropt rwigs saxis sigma smass smearings spring symprec
  system tebeg teend time voskown wc weimin zval
  """))

alphabet = 'abcdefghijklmnopqrstuvwxyz'

def edits1(word):
   splits     = [(word[:i], word[i:]) for i in range(len(word) + 1)]
   deletes    = [a + b[1:] for a, b in splits if b]
   transposes = [a + b[1] + b[0] + b[2:] for a, b in splits if len(b)>1]
   replaces   = [a + c + b[1:] for a, b in splits for c in alphabet if b]
   inserts    = [a + c + b     for a, b in splits for c in alphabet]
   return set(deletes + transposes + replaces + inserts)

def known_edits2(word):
    return set(e2 for e1 in edits1(word) for e2 in edits1(e1) if e2 in tag_db)

def known(words): return set(w for w in words if w in tag_db)

def correct(word):
    candidates = known([word]) or known(edits1(word)) or known_edits2(word) or [word]
    return max(candidates, key=tag_db.get)

def read_incar():
  incarfile = open("INCAR","r")
  result = {}
  for line in incarfile:
    parts = line.strip().split("=")

    if len(parts) >= 2 and parts[0][0] != "#" and parts[0][0] != "!":
      if parts[1].find("#") != -1:
        stripped = parts[1].split("#")[0]
      else:
        stripped = parts[1]
      result[parts[0].strip().upper()] = stripped.strip().upper()

  return result

# Count e.g. how many magmoms was given on an INCAR line
def atom_defs_given(data):
  result = 0
  for chunk in data.split():
    if "*" in chunk:
      terms = chunk.split("*")
      if len(terms) != 2:
        logging.warning("Preflight was unable to parse MAGMOM/LDAU. Chunk is %s" % (chunk))
      else:
        result = result + int(float(terms[0]))
    else:
      result = result + 1
  return result

# Count e.g. how many LDAUs was given on an INCAR line
def atom_kinds_given(data):
  return len(data.split())

parser = OptionParser()
parser.add_option("-o","--output",dest="output",help="Print preflight check data to file",metavar="FILE")
parser.add_option("-l","--loglevel",dest="loglevel",help="Log events of this level and higher")
parser.add_option("-c","--cores",dest="cores",help="How many cores you intend to run on")
parser.add_option("-n","--nodes",dest="nodes",help="How many nodes you intend to run on")
(options,args) = parser.parse_args()

# TODO: implement LOGLEVEL setting
loglevel = logging.INFO

if options.output:
  logging.basicConfig(filename = options.output, level = loglevel,format='[%(levelname)7s] %(message)s')
else:
  logging.basicConfig(level = loglevel,format='[%(levelname)7s] %(message)s')

allfiles = True
# Assert that all files exist necessary to run a calculation
for inputfile in ["INCAR","POSCAR","KPOINTS","POTCAR"]:
  if not os.path.isfile(inputfile):
    allfiles = False
    logging.error("VASP cannot run without the %s file." % (inputfile))

if not allfiles:
  sys.exit(0)

# Read the INCAR and spell check tags
incar = read_incar()
for tag in incar:
  matched = correct(tag.lower())
  if matched != tag.lower():
    logging.warning("Unknown tag %s in INCAR. Did you mean %s?" % (tag,matched.upper()))

# Look if CONTCAR = POSCAR when restarting
if os.path.isfile("CONTCAR") and subprocess.getoutput("diff CONTCAR POSCAR") != "" and "NSW" in incar:
    logging.warning("POSCAR and CONTCAR are the same. Did you forget to copy CONTCAR to POSCAR?")

# Determine ENMIN and ENMAX from POTCAR
enmax = 0.0
enmin = 0.0
potcarfile = subprocess.getoutput("grep ENMAX POTCAR").split("\n")
for line in potcarfile:
  parts = line.strip().split()
  max = float(parts[2][0:-1])
  min = float(parts[5])
  if max > enmax:
    enmax = max
  if min > enmin: 
    enmin = min

# Look if ENCUT is too large or small
if "ENCUT" not in incar:
  logging.warning("There is no ENCUT value in the INCAR file.")
else:
  cutoff = float(incar["ENCUT"])
  if cutoff < enmin:
    logging.warning("ENCUT is lower than the recommended ENMIN in the POTCAR file.")
  if cutoff < enmax:
    logging.info("ENCUT is lower then the recommended ENMAX in the POTCAR file. This could lead to artificially compression if you relax the cell.")
  if "ISIF" in incar:
    if (incar["ISIF"] == 3 or incar["ISIF"] == 6 or incar["ISIF"] == 7) and incar["ENCUT"] < enmax*1.25:
      logging.warning("Volume relaxation with ENCUT < ENMAX*1.25. Consider adding PSTRESS")
  if cutoff > 1.6*enmax:
    logging.warning("ENCUT is much higher than ENMAX, it might lead to numerical instability.")

# TODO: should abstract access to tags or check more carefully for existence

# Check for PREC High
if "PREC" in incar and incar["PREC"] == "HIGH":
  logging.warning("The PREC = High setting is deprecated. Use PREC = Accurate + suitable ENCUT instead.")

# POTIM should be used with IBRION=1
if "IBRION" in incar and incar["IBRION"] == "1" and "POTIM" not in incar:
  logging.warning("POTIM is not set, even though IBRION=1 is selected. VASP's default value of 0.5 may not be optimal.")

# Check LDA+U and LMAXMIX
if "LDAU" in incar:
  if "LMAXMIX" in incar:
    if int(incar["LMAXMIX"]) < 4:
      logging.info("LDA+U calculations may require higher LMAXMIX if you have d/f-elements")
  else:
    logging.info("LDA+U calculations may require higher LMAXMIX if you have d/f-elements")

# Check MAGMOM if spin-polarized
if "ISPIN" in incar and int(incar["ISPIN"]) == 2 and "MAGMOM" not in incar and "ICHARG" in incar and int(incar["ICHARG"]) != 1:
  logging.info("It is a good idea to set MAGMOM for initializing spin-polarized calculations.")

# Check for symmetry restricted MD
if "IBRION" in incar and int(incar["IBRION"]) == 0 and ("ISYM" not in incar or int(incar["ISYM"]) > 0):
  logging.warning("You should turn off symmetry constraints when doing molecular dynamics.")

# NPAR should be set.
if "NPAR" not in incar and "LHFCALC" not in incar:
  logging.warning("NPAR is missing. You must specify it to get good parallel performance.")

# KPAR and NPAR
# if "KPAR" in incar and "NPAR" in incar:
# # Check relationship between KPAR and NPAR, but we can't do it yet without core info
# logging.info("KPAR detected, check that NPAR = cores / KPAR.")

# Check number of atoms in cell vs MAGMOM and LDAU parameters
# POSCAR should exist if we gotten this far, so try to read it
cell = Poscar("POSCAR")
vol = cell.volume()
natoms = sum(cell.atom_counts())

# Check cell volume, write warning if less than one cubic Angstrom per atom
if vol/natoms < 1.0:
  logging.warning("The volume per atom is less than 1.0A^3/atom.")

# Check number of elements in MAGMOM and LDA+U, should match atoms...
if "MAGMOM" in incar and atom_defs_given(incar["MAGMOM"]) != natoms:
  logging.error("MAGMOM and number of atoms is inconsistent.")

if "LDAUU" in incar and atom_kinds_given(incar["LDAUU"]) != len(cell.atom_counts()):
  logging.error("LDAUU and number of atoms is inconsistent. %d != %d" % (atom_kinds_given(incar["LDAUU"]),len(cell.atom_counts())))

if "LDAUJ" in incar and atom_kinds_given(incar["LDAUJ"]) != len(cell.atom_counts()):
  logging.error("LDAUJ and number of atoms is inconsistent.%d != %d" % (atom_kinds_given(incar["LDAUJ"]),len(cell.atom_counts())))

# Parallel running checks
if options.cores:
  # TODO, check for NCORE also, and translate to NPAR
  cores = int(options.cores)
  if "KPAR" in incar:
    kpar = int(incar["KPAR"])
  else:
    kpar = 1

  if "NPAR" in incar:
    npar = int(incar["NPAR"])
  else:
    npar = cores

  if "KPAR" in incar:
    effective_cores = cores / int(incar["KPAR"])
  else:
    effective_cores = cores

  # Spreading too thinly
  if effective_cores > natoms:
    logging.warning("More than 1 MPI rank per atom is usually inefficient.")

  # KPAR and NPAR
  if kpar != 1 and cores != npar*kpar:
    logging.warning("NPAR*KPAR are not equal to the number of cores.")

  # TODO detect GW/RPA calculations also
  if npar == effective_cores and "LHFCALC" not in incar:
    logging.warning("NPAR = cores is highly inefficient.")

  # Suggest optimal NPAR if both nodes and cores are given
  if options.nodes:
    nodes = int(options.nodes)

    optimal_npar = nodes / 2
    if optimal_npar <= 0:
      optimal_npar = 1

    if (npar > 2*optimal_npar or npar < optimal_npar/2) and "LHFCALC" not in incar:
      logging.warning("NPAR setting looks suboptimal. I suggest NPAR=%d." % (optimal_npar))

    # Cores per node for Triolith
    if nodes > 16 and cores == nodes*16 and "LHFCALC" not in incar:
      logging.info("You might see better performance if you drop to 8-12cores/node using #SBATCH --ntasks-per-node 8/12")

    if cores < nodes*16 and "LHFCALC" in incar:
      logging.info("Using less than 16c cores/node is usually not efficient for hybrid calculations.")      
  else:
    # Use very conservative rules otherwise

    # Warn for too low NPAR
    if npar == 1 and effective_cores > 32:
      logging.warning("NPAR is probably too low for optimal performance.")

    # Warn for too high NPAR
    if npar > 2*int(math.sqrt(effective_cores)):
      logging.warning("NPAR is probably too high for optimal performance.")