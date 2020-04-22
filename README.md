# pyVASP
- [pyVASP-sql.py](https://github.com/kittiphong-am/pyVASP/blob/master/pyVASP-sql.py) Collect all VASP parameters and insert to nanoKMILT database server
- [pyVASP-band.py](https://github.com/kittiphong-am/pyVASP/blob/master/pyVASP-band.py) Plot **band structure** using VASP results
- [pyVASP-lattice.py](https://github.com/kittiphong-am/pyVASP/blob/master/pyVASP-lattice.py) Optimized lattice size from VASP
- [pyVASP-check.py](https://github.com/kittiphong-am/pyVASP/blob/master/pyVASP-check.py) Scans your input files and looks for common errors
- [pyVASP-geo.py](https://github.com/kittiphong-am/pyVASP/blob/master/pyVASP-geo.py) quickly get an overview of VASP geometry optimization runs
- [vasp.py](https://github.com/kittiphong-am/pyVASP/blob/master/vasp.py) Getting parameter from VASP


# SGE script
- [SGE-GS.vasp](https://github.com/kittiphong-am/pyVASP/blob/master/ncn/VASP-GS.sge) GS running script
- [SGE-GW.vasp](https://github.com/kittiphong-am/pyVASP/blob/master/ncn/VASP-GW.sge) GW running script


# pymatgen
**pymatgen (Python Materials Genomics)** is open-source Python library for materials analysis. **Pymatgen** is structured in a highly object-oriented manner. Almost everything (Element, Site, Structure, etc.) is an object. Currently, the code is heavily biased towards the representation and manipulation of crystals with periodic boundary conditions, though flexibility has been built in for molecules.

- [pmg-dos.py](https://github.com/kittiphong-am/pyVASP/blob/master/pmg/pmg-dos.py) : Plots **DOS** using VASP results
- [pmg-band.py](https://github.com/kittiphong-am/pyVASP/blob/master/pmg/pmg-band.py) : Plot **band structure** using VASP results
- [pmg-c2p.py](https://github.com/kittiphong-am/pyVASP/blob/master/pmg/pmg-c2p.py) : Convert **CIF** format to **POSCAR**
- [pmg-p2c.py](https://github.com/kittiphong-am/pyVASP/blob/master/pmg/pmg-p2c.py) : Convert **POSCAR** format to **CIF**


# BASH script
- [cif2pos.sh](https://github.com/kittiphong-am/pyVASP/blob/master/bash/cif2pos.sh) : Convert ***CIF*** format of structure into ***POSCAR*** format
- [vibration.sh](https://github.com/kittiphong-am/pyVASP/blob/master/bash/vibration.sh) : Extract vibration info from OUTCAR, which can be further used by jmol for visualization.
- [plotdist.sh](https://github.com/kittiphong-am/pyVASP/blob/master/bash/plotdist.sh) : Supervises distant changes of structures in VASP optimization.


# VTST tools
**VTST (VASP Transition State Theory)** designed to simulate the properties of systems at the atomic scale by **VASP**.

3 saddle point finding methods and 2 other tools have been implemented

ref : http://theory.cm.utexas.edu/vtsttools/


# VASPKIT
**VASPKIT** is a postprocessing tool for VASP code.

ref : http://vaspkit.sourceforge.net


# p4vasp
GUI-VASP Visualization Tool

ref : http://www.p4vasp.at/#/


# VASP tools
Peter’s collection of small, but useful, VASP scripts. Some of these may be found on NSC’s computers by loading the “vasptools” module.

- [vasp2cif.py](https://github.com/kittiphong-am/pyVASP/blob/master/NSC/vasp2cif.py) : Convert ***POSCAR / POTCAR*** format into ***CIF*** format
- [vaspcheck.py](https://github.com/kittiphong-am/pyVASP/blob/master/NSC/vaspcheck.py) : Script scans your input files and looks for common errors

ref : https://www.nsc.liu.se/~pla/vasptools/


# ASE
**The Atomic Simulation Environment (ASE)** is a set of tools and Python modules for setting up, manipulating, running, visualizing and analyzing atomistic simulations.

ref : https://wiki.fysik.dtu.dk/ase/


# Environments
- Macbook Air Mid 2012 (8GB ram)
- MacOS Catalina (10.15.4)
- python 3.8.2
- VS code 1.44.2
- VASP 5.4.1 / 5.4.4
- pymatgen 2020.4.2


# Contact
[http://ncn.kmitl.ac.th](http://ncn.kmitl.ac.th/ganglia/?c=Nanostructure%20Computational%20Network&m=load_one&r=hour&s=by%20name&hc=4&mc=2)<br>
Nanostructure Computational Network, KMITL<br>
Email : kittiphong.am@kmitl.ac.th, nano@kmitl.ac.th
